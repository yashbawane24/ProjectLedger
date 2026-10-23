package com.projectledger.model;

import com.projectledger.interfaces.Reviewable;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Domain entity representing an academic student project.
 * Implements Reviewable for faculty review and approval.
 */
public class Project implements Reviewable, Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String title;
    private String description;
    private int leaderId;
    private Integer facultyId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String repoOwner;
    private String repoName;
    private String demoUrl;
    private LocalDateTime lastSyncedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Display helpers and calculated attributes
    private String leaderName;
    private String leaderEmail;
    private String facultyName;
    private int overallProgress;
    private int expectedProgress;
    private ProjectHealth health = ProjectHealth.ON_TRACK;
    private ArrayList<String> healthReasons = new ArrayList<>();
    private String nextMilestoneTitle;
    private LocalDate nextMilestoneDate;
    private LocalDateTime lastCommitAt;
    private String reviewStatus = "PENDING";

    public Project() {
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

    public int getLeaderId() {
        return leaderId;
    }

    public void setLeaderId(int leaderId) {
        this.leaderId = leaderId;
    }

    public Integer getFacultyId() {
        return facultyId;
    }

    public void setFacultyId(Integer facultyId) {
        this.facultyId = facultyId;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getRepoOwner() {
        return repoOwner;
    }

    public void setRepoOwner(String repoOwner) {
        this.repoOwner = repoOwner;
    }

    public String getRepoName() {
        return repoName;
    }

    public void setRepoName(String repoName) {
        this.repoName = repoName;
    }

    public String getGitHubRepoFullName() {
        if (repoOwner != null && !repoOwner.isBlank() && repoName != null && !repoName.isBlank()) {
            return repoOwner + "/" + repoName;
        }
        return null;
    }

    public String getRepoUrl() {
        if (repoOwner != null && !repoOwner.isBlank() && repoName != null && !repoName.isBlank()) {
            return "https://github.com/" + repoOwner + "/" + repoName;
        }
        return null;
    }

    public String getDemoUrl() {
        return demoUrl;
    }

    public void setDemoUrl(String demoUrl) {
        this.demoUrl = demoUrl;
    }

    public LocalDateTime getLastSyncedAt() {
        return lastSyncedAt;
    }

    public void setLastSyncedAt(LocalDateTime lastSyncedAt) {
        this.lastSyncedAt = lastSyncedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getLeaderName() {
        return leaderName;
    }

    public void setLeaderName(String leaderName) {
        this.leaderName = leaderName;
    }

    public String getLeaderEmail() {
        return leaderEmail;
    }

    public void setLeaderEmail(String leaderEmail) {
        this.leaderEmail = leaderEmail;
    }

    public String getFacultyName() {
        return facultyName;
    }

    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    public int getOverallProgress() {
        return overallProgress;
    }

    public void setOverallProgress(int overallProgress) {
        this.overallProgress = overallProgress;
    }

    public int getExpectedProgress() {
        return expectedProgress;
    }

    public void setExpectedProgress(int expectedProgress) {
        this.expectedProgress = expectedProgress;
    }

    public ProjectHealth getHealth() {
        return health;
    }

    public void setHealth(ProjectHealth health) {
        this.health = health;
    }

    public List<String> getHealthReasons() {
        return healthReasons;
    }

    public void setHealthReasons(List<String> healthReasons) {
        this.healthReasons = healthReasons != null ? new ArrayList<>(healthReasons) : new ArrayList<>();
    }

    public String getNextMilestoneTitle() {
        return nextMilestoneTitle;
    }

    public void setNextMilestoneTitle(String nextMilestoneTitle) {
        this.nextMilestoneTitle = nextMilestoneTitle;
    }

    public LocalDate getNextMilestoneDate() {
        return nextMilestoneDate;
    }

    public void setNextMilestoneDate(LocalDate nextMilestoneDate) {
        this.nextMilestoneDate = nextMilestoneDate;
    }

    public LocalDateTime getLastCommitAt() {
        return lastCommitAt;
    }

    public void setLastCommitAt(LocalDateTime lastCommitAt) {
        this.lastCommitAt = lastCommitAt;
    }

    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }
}
