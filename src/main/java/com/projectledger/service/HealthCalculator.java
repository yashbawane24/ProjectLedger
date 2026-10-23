package com.projectledger.service;

import com.projectledger.model.Milestone;
import com.projectledger.model.Priority;
import com.projectledger.model.Project;
import com.projectledger.model.ProjectHealth;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;
import com.projectledger.util.DateUtil;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Assesses academic project health status and produces human-readable diagnostic reasons.
 *
 * Rules:
 * DELAYED if any of:
 *   - a milestone's target_date has passed and it's not completed
 *   - a HIGH priority task is overdue by more than 3 days
 *   - overallProgress is more than 25 points below expectedProgress
 *   - project end_date has passed and progress < 100
 *
 * AT_RISK (if not delayed) if any of:
 *   - any task is overdue
 *   - a milestone is due within 7 days and less than 50% of its tasks are completed
 *   - overallProgress is 10-25 points below expectedProgress
 *   - a repo is connected and there are no commits in the last 14 days (only after the project is 14+ days old)
 *
 * ON_TRACK otherwise.
 */
public class HealthCalculator {

    public static class HealthResult {
        private final ProjectHealth health;
        private final List<String> reasons;

        public HealthResult(ProjectHealth health, List<String> reasons) {
            this.health = health;
            this.reasons = reasons != null ? Collections.unmodifiableList(reasons) : Collections.emptyList();
        }

        public ProjectHealth getHealth() {
            return health;
        }

        public List<String> getReasons() {
            return reasons;
        }
    }

    public static HealthResult calculate(Project project, List<Task> tasks, List<Milestone> milestones,
                                         int overallProgress, int expectedProgress, LocalDateTime lastCommitDate) {
        return calculate(project, tasks, milestones, overallProgress, expectedProgress, lastCommitDate, LocalDate.now());
    }

    public static HealthResult calculate(Project project, List<Task> tasks, List<Milestone> milestones,
                                         int overallProgress, int expectedProgress, LocalDateTime lastCommitDate,
                                         LocalDate referenceDate) {
        LocalDate today = (referenceDate != null) ? referenceDate : LocalDate.now();
        List<String> delayedReasons = new ArrayList<>();
        List<String> atRiskReasons = new ArrayList<>();

        // Check DELAYED conditions
        // 1. A milestone's target_date has passed and it's not completed
        if (milestones != null) {
            for (Milestone m : milestones) {
                if (!m.isCompleted() && m.getTargetDate() != null && m.getTargetDate().isBefore(today)) {
                    delayedReasons.add("Milestone '" + m.getTitle() + "' was due on " + DateUtil.format(m.getTargetDate()) + " and is not complete.");
                }
            }
        }

        // 2. A HIGH priority task is overdue by more than 3 days
        if (tasks != null) {
            for (Task t : tasks) {
                if (t.getPriority() == Priority.HIGH && t.getStatus() != TaskStatus.COMPLETED && t.getDueDate() != null) {
                    long overdueDays = ChronoUnit.DAYS.between(t.getDueDate(), today);
                    if (overdueDays > 3) {
                        delayedReasons.add("High priority task '" + t.getTitle() + "' is overdue by " + overdueDays + " days.");
                    }
                }
            }
        }

        // 3. Overall progress is more than 25 points below expectedProgress
        int gap = expectedProgress - overallProgress;
        if (gap > 25) {
            delayedReasons.add("Overall progress (" + overallProgress + "%) is " + gap + " points behind expected schedule (" + expectedProgress + "%).");
        }

        // 4. Project end_date has passed and progress < 100
        if (project != null && project.getEndDate() != null && project.getEndDate().isBefore(today) && overallProgress < 100) {
            delayedReasons.add("Project end date (" + DateUtil.format(project.getEndDate()) + ") has passed and completion is only " + overallProgress + "%.");
        }

        if (!delayedReasons.isEmpty()) {
            return new HealthResult(ProjectHealth.DELAYED, delayedReasons);
        }

        // Check AT_RISK conditions (only if not delayed)
        // 1. Any task is overdue
        if (tasks != null) {
            for (Task t : tasks) {
                if (t.getStatus() != TaskStatus.COMPLETED && t.getDueDate() != null && t.getDueDate().isBefore(today)) {
                    long days = ChronoUnit.DAYS.between(t.getDueDate(), today);
                    atRiskReasons.add("Task '" + t.getTitle() + "' is overdue by " + days + " " + (days == 1 ? "day" : "days") + " (due " + DateUtil.format(t.getDueDate()) + ").");
                }
            }
        }

        // 2. A milestone is due within 7 days and less than 50% of its tasks are completed
        if (milestones != null) {
            for (Milestone m : milestones) {
                if (!m.isCompleted() && m.getTargetDate() != null && !m.getTargetDate().isBefore(today)) {
                    long daysUntil = ChronoUnit.DAYS.between(today, m.getTargetDate());
                    if (daysUntil <= 7) {
                        // Calculate milestone's task completion
                        int totalMTasks = 0;
                        int completedMTasks = 0;
                        if (tasks != null) {
                            for (Task t : tasks) {
                                if (t.getMilestoneId() != null && t.getMilestoneId() == m.getId()) {
                                    totalMTasks++;
                                    if (t.getStatus() == TaskStatus.COMPLETED) {
                                        completedMTasks++;
                                    }
                                }
                            }
                        }
                        if (totalMTasks > 0) {
                            double pct = ((double) completedMTasks / totalMTasks) * 100.0;
                            if (pct < 50.0) {
                                atRiskReasons.add("Milestone '" + m.getTitle() + "' is due in " + daysUntil + " " + (daysUntil == 1 ? "day" : "days") + " and only " + (int) pct + "% of its tasks are completed.");
                            }
                        }
                    }
                }
            }
        }

        // 3. Overall progress is 10-25 points below expectedProgress
        if (gap >= 10 && gap <= 25) {
            atRiskReasons.add("Overall progress (" + overallProgress + "%) is " + gap + " points behind expected schedule (" + expectedProgress + "%).");
        }

        // 4. A repo is connected and there are no commits in the last 14 days (only after project is 14+ days old)
        if (project != null && project.getStartDate() != null) {
            long projectAgeDays = ChronoUnit.DAYS.between(project.getStartDate(), today);
            boolean hasRepo = project.getRepoName() != null && !project.getRepoName().isBlank();
            if (hasRepo && projectAgeDays >= 14) {
                if (lastCommitDate == null) {
                    atRiskReasons.add("Repository is connected but no commits have been synchronized in the last 14 days.");
                } else {
                    long daysSinceCommit = ChronoUnit.DAYS.between(lastCommitDate.toLocalDate(), today);
                    if (daysSinceCommit > 14) {
                        atRiskReasons.add("No commits recorded in the repository for the last " + daysSinceCommit + " days.");
                    }
                }
            }
        }

        if (!atRiskReasons.isEmpty()) {
            return new HealthResult(ProjectHealth.AT_RISK, atRiskReasons);
        }

        return new HealthResult(ProjectHealth.ON_TRACK, List.of("All milestones and development tasks are currently on schedule."));
    }
}
