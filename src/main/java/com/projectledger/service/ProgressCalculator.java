package com.projectledger.service;

import com.projectledger.model.Milestone;
import com.projectledger.model.Project;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Calculates academic project progress metrics according to specification rules:
 * - taskProgress = completed tasks / total tasks, weighted by priority (LOW=1, MEDIUM=2, HIGH=3)
 * - milestoneProgress = completed milestones / total milestones
 * - overallProgress = 60% taskProgress + 40% milestoneProgress, rounded to whole percent
 *   (If a project has no tasks and no milestones, progress = 0)
 * - expectedProgress = days elapsed since start_date / total project days, clamped 0-100
 */
public class ProgressCalculator {

    public static class ProgressResult {
        private final double taskProgress;       // 0.0 to 1.0
        private final double milestoneProgress;  // 0.0 to 1.0
        private final int overallProgress;        // 0 to 100
        private final int expectedProgress;       // 0 to 100

        public ProgressResult(double taskProgress, double milestoneProgress, int overallProgress, int expectedProgress) {
            this.taskProgress = taskProgress;
            this.milestoneProgress = milestoneProgress;
            this.overallProgress = overallProgress;
            this.expectedProgress = expectedProgress;
        }

        public double getTaskProgress() {
            return taskProgress;
        }

        public double getMilestoneProgress() {
            return milestoneProgress;
        }

        public int getOverallProgress() {
            return overallProgress;
        }

        public int getExpectedProgress() {
            return expectedProgress;
        }
    }

    public static ProgressResult calculate(Project project, List<Task> tasks, List<Milestone> milestones) {
        return calculate(project, tasks, milestones, LocalDate.now());
    }

    public static ProgressResult calculate(Project project, List<Task> tasks, List<Milestone> milestones, LocalDate referenceDate) {
        int totalTaskWeight = 0;
        int completedTaskWeight = 0;

        if (tasks != null) {
            for (Task task : tasks) {
                int weight = (task.getPriority() != null) ? task.getPriority().getWeight() : 2;
                totalTaskWeight += weight;
                if (task.getStatus() == TaskStatus.COMPLETED) {
                    completedTaskWeight += weight;
                }
            }
        }

        int totalMilestones = (milestones != null) ? milestones.size() : 0;
        int completedMilestones = 0;
        if (milestones != null) {
            for (Milestone m : milestones) {
                if (m.isCompleted()) {
                    completedMilestones++;
                }
            }
        }

        double taskProgress = (totalTaskWeight > 0) ? ((double) completedTaskWeight / totalTaskWeight) : 0.0;
        double milestoneProgress = (totalMilestones > 0) ? ((double) completedMilestones / totalMilestones) : 0.0;

        int overallProgress = 0;
        if (totalTaskWeight == 0 && totalMilestones == 0) {
            overallProgress = 0;
        } else if (totalTaskWeight > 0 && totalMilestones > 0) {
            overallProgress = (int) Math.round((0.60 * taskProgress + 0.40 * milestoneProgress) * 100.0);
        } else if (totalTaskWeight > 0) {
            overallProgress = (int) Math.round(taskProgress * 100.0);
        } else {
            overallProgress = (int) Math.round(milestoneProgress * 100.0);
        }
        overallProgress = Math.min(100, Math.max(0, overallProgress));

        int expectedProgress = calculateExpectedProgress(project, referenceDate);

        return new ProgressResult(taskProgress, milestoneProgress, overallProgress, expectedProgress);
    }

    public static int calculateExpectedProgress(Project project, LocalDate referenceDate) {
        if (project == null || project.getStartDate() == null || project.getEndDate() == null) {
            return 0;
        }

        LocalDate start = project.getStartDate();
        LocalDate end = project.getEndDate();
        LocalDate today = (referenceDate != null) ? referenceDate : LocalDate.now();

        long totalDays = ChronoUnit.DAYS.between(start, end);
        if (totalDays <= 0) {
            return today.isBefore(start) ? 0 : 100;
        }

        long daysElapsed = ChronoUnit.DAYS.between(start, today);
        if (daysElapsed <= 0) {
            return 0;
        }
        if (daysElapsed >= totalDays) {
            return 100;
        }

        int expected = (int) Math.round(((double) daysElapsed / totalDays) * 100.0);
        return Math.min(100, Math.max(0, expected));
    }
}
