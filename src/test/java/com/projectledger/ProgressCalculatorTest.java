package com.projectledger;

import com.projectledger.model.Milestone;
import com.projectledger.model.Priority;
import com.projectledger.model.Project;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;
import com.projectledger.service.ProgressCalculator;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ProgressCalculatorTest {

    @Test
    @DisplayName("Empty project with no tasks and no milestones yields 0 progress")
    void testEmptyProject() {
        Project project = new Project();
        project.setStartDate(LocalDate.of(2026, 9, 1));
        project.setEndDate(LocalDate.of(2026, 12, 1));

        ProgressCalculator.ProgressResult result = ProgressCalculator.calculate(
                project, Collections.emptyList(), Collections.emptyList(), LocalDate.of(2026, 10, 1));

        assertEquals(0, result.getOverallProgress());
        assertEquals(0.0, result.getTaskProgress(), 0.001);
        assertEquals(0.0, result.getMilestoneProgress(), 0.001);
    }

    @Test
    @DisplayName("Weighted task progress calculation with Low(1), Medium(2), High(3)")
    void testWeightedTaskProgress() {
        Project project = new Project();
        project.setStartDate(LocalDate.of(2026, 9, 1));
        project.setEndDate(LocalDate.of(2026, 12, 1));

        Task t1 = new Task(); // LOW (1), COMPLETED
        t1.setPriority(Priority.LOW);
        t1.setStatus(TaskStatus.COMPLETED);

        Task t2 = new Task(); // MEDIUM (2), COMPLETED
        t2.setPriority(Priority.MEDIUM);
        t2.setStatus(TaskStatus.COMPLETED);

        Task t3 = new Task(); // HIGH (3), IN_PROGRESS
        t3.setPriority(Priority.HIGH);
        t3.setStatus(TaskStatus.IN_PROGRESS);

        // Total weight = 1 + 2 + 3 = 6
        // Completed weight = 1 + 2 = 3
        // taskProgress = 3 / 6 = 0.50 (50%)

        Milestone m1 = new Milestone(); // COMPLETED
        m1.setCompletedAt(LocalDate.of(2026, 9, 15).atStartOfDay());

        Milestone m2 = new Milestone(); // PENDING
        m2.setCompletedAt(null);

        // milestoneProgress = 1 / 2 = 0.50 (50%)
        // overallProgress = 0.60 * 50 + 0.40 * 50 = 30 + 20 = 50%

        ProgressCalculator.ProgressResult result = ProgressCalculator.calculate(
                project, List.of(t1, t2, t3), List.of(m1, m2), LocalDate.of(2026, 10, 1));

        assertEquals(0.50, result.getTaskProgress(), 0.001);
        assertEquals(0.50, result.getMilestoneProgress(), 0.001);
        assertEquals(50, result.getOverallProgress());
    }

    @Test
    @DisplayName("Expected progress clamped between 0 and 100 based on elapsed days")
    void testExpectedProgress() {
        Project project = new Project();
        project.setStartDate(LocalDate.of(2026, 10, 1));
        project.setEndDate(LocalDate.of(2026, 10, 21)); // 20 days total

        // Before start
        assertEquals(0, ProgressCalculator.calculateExpectedProgress(project, LocalDate.of(2026, 9, 20)));

        // Exactly halfway (10 days in)
        assertEquals(50, ProgressCalculator.calculateExpectedProgress(project, LocalDate.of(2026, 10, 11)));

        // Past end date -> clamped to 100
        assertEquals(100, ProgressCalculator.calculateExpectedProgress(project, LocalDate.of(2026, 11, 5)));
    }
}
