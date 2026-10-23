package com.projectledger.model;

import java.time.LocalDateTime;

/**
 * Concrete Faculty entity extending User.
 * Supervises student academic projects, conducts reviews, and provides process feedback.
 */
public class Faculty extends User {
    private static final long serialVersionUID = 1L;

    public Faculty() {
        super(Role.FACULTY);
    }

    public Faculty(int id, String name, String email, String passwordHash,
                   String githubUsername, String department, boolean active, LocalDateTime createdAt) {
        super(id, name, email, passwordHash, Role.FACULTY, githubUsername, null, department, active, createdAt);
    }

    @Override
    public String getDashboardPath() {
        return "/faculty/dashboard";
    }
}
