package com.projectledger.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Data carrier for student process contribution evidence.
 * Tracks assigned tasks, completion metrics, milestone associations, and GitHub commit counts.
 */
public class StudentEvidence implements Serializable {
    private static final long serialVersionUID = 1L;

    private final TeamMember member;
    private int tasksAssigned;
    private int tasksCompleted;
    private int tasksOverdue;
    private int commitCount;
    private LocalDateTime lastCommitDate;

    public StudentEvidence(TeamMember member) {
        this.member = member;
    }

    public TeamMember getMember() {
        return member;
    }

    public int getTasksAssigned() {
        return tasksAssigned;
    }

    public void setTasksAssigned(int tasksAssigned) {
        this.tasksAssigned = tasksAssigned;
    }

    public int getTasksCompleted() {
        return tasksCompleted;
    }

    public void setTasksCompleted(int tasksCompleted) {
        this.tasksCompleted = tasksCompleted;
    }

    public int getTasksOverdue() {
        return tasksOverdue;
    }

    public void setTasksOverdue(int tasksOverdue) {
        this.tasksOverdue = tasksOverdue;
    }

    public int getCommitCount() {
        return commitCount;
    }

    public void setCommitCount(int commitCount) {
        this.commitCount = commitCount;
    }

    public LocalDateTime getLastCommitDate() {
        return lastCommitDate;
    }

    public void setLastCommitDate(LocalDateTime lastCommitDate) {
        this.lastCommitDate = lastCommitDate;
    }

    public double getCompletionRate() {
        if (tasksAssigned == 0) return 0.0;
        return ((double) tasksCompleted / tasksAssigned) * 100.0;
    }

    public int getCompletionRatePercent() {
        return (int) Math.round(getCompletionRate());
    }
}
