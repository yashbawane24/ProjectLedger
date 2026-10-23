package com.projectledger.model;

import com.projectledger.interfaces.Reviewable;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Domain entity representing an academic project milestone.
 * Implements Reviewable for faculty process assessment.
 */
public class Milestone implements Reviewable, Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int projectId;
    private String title;
    private String description;
    private LocalDate targetDate;
    private LocalDateTime completedAt;
    private int sortOrder;
    private String reviewStatus = "PENDING";

    // Computed attributes for progress calculation
    private int totalTasks;
    private int completedTasks;

    public Milestone() {
    }

    public Milestone(int id, int projectId, String title, String description,
                     LocalDate targetDate, LocalDateTime completedAt, int sortOrder, String reviewStatus) {
        this.id = id;
        this.projectId = projectId;
        this.title = title;
        this.description = description;
        this.targetDate = targetDate;
        this.completedAt = completedAt;
        this.sortOrder = sortOrder;
        this.reviewStatus = (reviewStatus != null) ? reviewStatus : "PENDING";
    }

    public boolean isCompleted() {
        return completedAt != null;
    }

    @Override
    public String getReviewStatus() {
        return reviewStatus;
    }

    @Override
    public void markReviewed() {
        this.reviewStatus = "REVIEWED";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getTargetDate() {
        return targetDate;
    }

    public void setTargetDate(LocalDate targetDate) {
        this.targetDate = targetDate;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public int getTotalTasks() {
        return totalTasks;
    }

    public void setTotalTasks(int totalTasks) {
        this.totalTasks = totalTasks;
    }

    public int getCompletedTasks() {
        return completedTasks;
    }

    public void setCompletedTasks(int completedTasks) {
        this.completedTasks = completedTasks;
    }

    public double getTaskCompletionPercentage() {
        if (totalTasks == 0) {
            return 0.0;
        }
        return ((double) completedTasks / totalTasks) * 100.0;
    }
}
