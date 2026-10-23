package com.projectledger;

import com.projectledger.model.Milestone;
import com.projectledger.model.Priority;
import com.projectledger.model.Project;
import com.projectledger.model.ProjectHealth;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;
import com.projectledger.service.HealthCalculator;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class HealthCalculatorTest {
    private final LocalDate today = LocalDate.of(2026, 10, 19);
    private Project project;

    @BeforeEach
    void setUp() {
        project = new Project();
        project.setStartDate(LocalDate.of(2026, 9, 1));
        project.setEndDate(LocalDate.of(2026, 12, 1));
        project.setRepoName(null);
    }

    @Test
    @DisplayName("Empty project is ON_TRACK by default when on schedule")
    void testEmptyProjectOnTrack() {
        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, Collections.emptyList(), Collections.emptyList(), 50, 50, null, today);

        assertEquals(ProjectHealth.ON_TRACK, result.getHealth());
    }

    @Test
    @DisplayName("DELAYED when a milestone target date has passed and it is not completed")
    void testDelayedPastMilestone() {
        Milestone m = new Milestone();
        m.setTitle("Design Phase");
        m.setTargetDate(LocalDate.of(2026, 10, 10)); // Past
        m.setCompletedAt(null); // Not completed

        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, Collections.emptyList(), List.of(m), 50, 50, null, today);

        assertEquals(ProjectHealth.DELAYED, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("Design Phase")));
    }

    @Test
    @DisplayName("DELAYED when a HIGH priority task is overdue by more than 3 days")
    void testDelayedHighPriorityTaskOverdue() {
        Task task = new Task();
        task.setTitle("Core Database Driver");
        task.setPriority(Priority.HIGH);
        task.setStatus(TaskStatus.IN_PROGRESS);
        task.setDueDate(LocalDate.of(2026, 10, 14)); // 5 days ago (today is 19)

        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, List.of(task), Collections.emptyList(), 50, 50, null, today);

        assertEquals(ProjectHealth.DELAYED, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("Core Database Driver")));
    }

    @Test
    @DisplayName("DELAYED when overall progress is more than 25 points below expected")
    void testDelayedProgressGap() {
        // overall: 20%, expected: 50% -> gap = 30 (> 25)
        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, Collections.emptyList(), Collections.emptyList(), 20, 50, null, today);

        assertEquals(ProjectHealth.DELAYED, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("points behind expected schedule")));
    }

    @Test
    @DisplayName("DELAYED when project end date has passed and progress < 100")
    void testDelayedProjectDeadlinePassed() {
        project.setEndDate(LocalDate.of(2026, 10, 15)); // Past

        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, Collections.emptyList(), Collections.emptyList(), 85, 100, null, today);

        assertEquals(ProjectHealth.DELAYED, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("Project end date")));
    }

    @Test
    @DisplayName("AT_RISK when any task is overdue (if not delayed)")
    void testAtRiskOverdueTask() {
        Task task = new Task();
        task.setTitle("Write User Documentation");
        task.setPriority(Priority.MEDIUM); // Medium overdue by 2 days
        task.setStatus(TaskStatus.IN_PROGRESS);
        task.setDueDate(LocalDate.of(2026, 10, 17));

        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, List.of(task), Collections.emptyList(), 50, 50, null, today);

        assertEquals(ProjectHealth.AT_RISK, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("Write User Documentation")));
    }

    @Test
    @DisplayName("AT_RISK when milestone is due within 7 days and < 50% tasks completed")
    void testAtRiskMilestoneUpcomingWithLowCompletion() {
        Milestone m = new Milestone();
        m.setId(101);
        m.setTitle("Prototype Delivery");
        m.setTargetDate(LocalDate.of(2026, 10, 24)); // in 5 days
        m.setCompletedAt(null);

        Task t1 = new Task();
        t1.setMilestoneId(101);
        t1.setStatus(TaskStatus.COMPLETED);

        Task t2 = new Task();
        t2.setMilestoneId(101);
        t2.setStatus(TaskStatus.IN_PROGRESS);
        t2.setDueDate(LocalDate.of(2026, 10, 22));

        Task t3 = new Task();
        t3.setMilestoneId(101);
        t3.setStatus(TaskStatus.NOT_STARTED);
        t3.setDueDate(LocalDate.of(2026, 10, 23));

        // 1 of 3 tasks completed = 33% (< 50%)
        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, List.of(t1, t2, t3), List.of(m), 50, 50, null, today);

        assertEquals(ProjectHealth.AT_RISK, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("Prototype Delivery")));
    }

    @Test
    @DisplayName("AT_RISK when overall progress is 10-25 points below expected")
    void testAtRiskProgressGap() {
        // overall: 40%, expected: 55% -> gap = 15
        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, Collections.emptyList(), Collections.emptyList(), 40, 55, null, today);

        assertEquals(ProjectHealth.AT_RISK, result.getHealth());
    }

    @Test
    @DisplayName("AT_RISK when repo is connected and no commits in last 14 days (project 14+ days old)")
    void testAtRiskNoCommits() {
        project.setRepoName("sample-repo");
        project.setStartDate(LocalDate.of(2026, 9, 1)); // Project is ~48 days old
        LocalDateTime lastCommit = LocalDateTime.of(2026, 10, 1, 10, 0); // 18 days ago

        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, Collections.emptyList(), Collections.emptyList(), 50, 50, lastCommit, today);

        assertEquals(ProjectHealth.AT_RISK, result.getHealth());
        assertTrue(result.getReasons().stream().anyMatch(r -> r.contains("No commits recorded")));
    }

    @Test
    @DisplayName("ON_TRACK when all metrics are on schedule")
    void testOnTrackHealthyProject() {
        Milestone m = new Milestone();
        m.setTargetDate(LocalDate.of(2026, 11, 15));
        m.setCompletedAt(null);

        Task task = new Task();
        task.setStatus(TaskStatus.IN_PROGRESS);
        task.setDueDate(LocalDate.of(2026, 10, 28));

        HealthCalculator.HealthResult result = HealthCalculator.calculate(
                project, List.of(task), List.of(m), 50, 50, LocalDateTime.of(2026, 10, 18, 12, 0), today);

        assertEquals(ProjectHealth.ON_TRACK, result.getHealth());
        assertFalse(result.getReasons().isEmpty());
    }
}
