package com.projectledger.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Abstract base class representing a user in the ProjectLedger platform.
 * Encapsulates common user attributes and defines polymorphic dashboard routing.
 */
public abstract class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String email;
    private String passwordHash;
    private Role role;
    private String githubUsername;
    private String regNo;
    private String department;
    private boolean active;
    private LocalDateTime createdAt;

    public User() {
        this.active = true;
    }

    public User(Role role) {
        this.role = role;
        this.active = true;
    }

    public User(int id, String name, String email, String passwordHash, Role role,
                String githubUsername, String regNo, String department, boolean active, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.githubUsername = githubUsername;
        this.regNo = regNo;
        this.department = department;
        this.active = active;
        this.createdAt = createdAt;
    }

    /**
     * Polymorphic method to determine the destination dashboard URI for this user subclass.
     *
     * @return relative path to the dashboard (e.g. /student/dashboard)
     */
    public abstract String getDashboardPath();

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getGithubUsername() {
        return githubUsername;
    }

    public void setGithubUsername(String githubUsername) {
        this.githubUsername = githubUsername;
    }

    public String getRegNo() {
        return regNo;
    }

    public void setRegNo(String regNo) {
        this.regNo = regNo;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Creates a lightweight session token object from this full User entity.
     */
    public SessionUser toSessionUser() {
        return new SessionUser(id, name, email, role, githubUsername, regNo);
    }
}
