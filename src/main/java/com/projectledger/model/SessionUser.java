package com.projectledger.model;

import java.io.Serializable;

/**
 * Lightweight representation of an authenticated user stored in HttpSession.
 */
public class SessionUser implements Serializable {
    private static final long serialVersionUID = 1L;

    private final int id;
    private final String name;
    private final String email;
    private final Role role;
    private final String githubUsername;
    private final String regNo;

    public SessionUser(int id, String name, String email, Role role, String githubUsername, String regNo) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
        this.githubUsername = githubUsername;
        this.regNo = regNo;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public Role getRole() {
        return role;
    }

    public String getGithubUsername() {
        return githubUsername;
    }

    public String getRegNo() {
        return regNo;
    }

    public boolean isStudent() {
        return role == Role.STUDENT;
    }

    public boolean isFaculty() {
        return role == Role.FACULTY;
    }

    public boolean isAdmin() {
        return role == Role.ADMIN;
    }

    public String getDashboardPath() {
        return switch (role) {
            case STUDENT -> "/student/dashboard";
            case FACULTY -> "/faculty/dashboard";
            case ADMIN -> "/admin/dashboard";
        };
    }
}
