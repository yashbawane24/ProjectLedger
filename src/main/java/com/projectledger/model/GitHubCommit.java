package com.projectledger.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Domain entity representing a synchronized Git commit from GitHub repository activity.
 */
public class GitHubCommit implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int projectId;
    private String sha;
    private String authorLogin;
    private String authorName;
    private String message;
    private LocalDateTime committedAt;
    private String htmlUrl;

    public GitHubCommit() {
    }

    public GitHubCommit(int id, int projectId, String sha, String authorLogin,
                        String authorName, String message, LocalDateTime committedAt, String htmlUrl) {
        this.id = id;
        this.projectId = projectId;
        this.sha = sha;
        this.authorLogin = authorLogin;
        this.authorName = authorName;
        this.message = message;
        this.committedAt = committedAt;
        this.htmlUrl = htmlUrl;
    }

    public String getShortSha() {
        if (sha != null && sha.length() >= 7) {
            return sha.substring(0, 7);
        }
        return sha;
    }

    public String getFirstLineMessage() {
        if (message == null) {
            return "";
        }
        int newline = message.indexOf('\n');
        if (newline != -1) {
            return message.substring(0, newline).trim();
        }
        return message.trim();
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

    public String getSha() {
        return sha;
    }

    public void setSha(String sha) {
        this.sha = sha;
    }

    public String getAuthorLogin() {
        return authorLogin;
    }

    public void setAuthorLogin(String authorLogin) {
        this.authorLogin = authorLogin;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCommittedAt() {
        return committedAt;
    }

    public void setCommittedAt(LocalDateTime committedAt) {
        this.committedAt = committedAt;
    }

    public String getHtmlUrl() {
        return htmlUrl;
    }

    public void setHtmlUrl(String htmlUrl) {
        this.htmlUrl = htmlUrl;
    }
}
