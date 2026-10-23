package com.projectledger.model;

import java.time.LocalDateTime;

/**
 * Concrete Student entity extending User.
 * Manages project tasks, milestones, and commits.
 */
public class Student extends User {
    private static final long serialVersionUID = 1L;

    public Student() {
        super(Role.STUDENT);
    }

    public Student(int id, String name, String email, String passwordHash,
                   String githubUsername, String regNo, String department, boolean active, LocalDateTime createdAt) {
        super(id, name, email, passwordHash, Role.STUDENT, githubUsername, regNo, department, active, createdAt);
    }

    @Override
    public String getDashboardPath() {
        return "/student/dashboard";
    }
}
