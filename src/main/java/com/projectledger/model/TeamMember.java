package com.projectledger.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Domain entity representing a student team member assigned to a project.
 */
public class TeamMember implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int projectId;
    private int userId;
    private String responsibility;
    private LocalDateTime joinedAt;

    // Joined user attributes
    private String userName;
    private String userEmail;
    private String userRegNo;
    private String userGithub;

    public TeamMember() {
    }

    public TeamMember(int id, int projectId, int userId, String responsibility, LocalDateTime joinedAt) {
        this.id = id;
        this.projectId = projectId;
        this.userId = userId;
        this.responsibility = responsibility;
        this.joinedAt = joinedAt;
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

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getResponsibility() {
        return responsibility;
    }

    public void setResponsibility(String responsibility) {
        this.responsibility = responsibility;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserRegNo() {
        return userRegNo;
    }

    public void setUserRegNo(String userRegNo) {
        this.userRegNo = userRegNo;
    }

    public String getUserGithub() {
        return userGithub;
    }

    public void setUserGithub(String userGithub) {
        this.userGithub = userGithub;
    }

    public String getInitials() {
        if (userName == null || userName.isBlank()) {
            return "?";
        }
        String[] parts = userName.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        }
        return ("" + parts[0].charAt(0) + parts[parts.length - 1].charAt(0)).toUpperCase();
    }
}
