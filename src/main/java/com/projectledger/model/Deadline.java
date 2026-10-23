package com.projectledger.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Domain entity representing an academic deadline.
 * If projectId is null, the deadline is global (set by Admin for all projects).
 */
public class Deadline implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Integer projectId;
    private String title;
    private LocalDate dueDate;
    private int createdBy;
    private LocalDateTime createdAt;

    // View joins
    private String projectTitle;
    private String creatorName;

    public Deadline() {
    }

    public Deadline(int id, Integer projectId, String title, LocalDate dueDate, int createdBy, LocalDateTime createdAt) {
        this.id = id;
        this.projectId = projectId;
        this.title = title;
        this.dueDate = dueDate;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    public boolean isGlobal() {
        return projectId == null;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getProjectTitle() {
        return projectTitle;
    }

    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getCreatorName() {
        return creatorName;
    }

    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }
}
