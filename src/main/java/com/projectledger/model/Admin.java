package com.projectledger.model;

import java.time.LocalDateTime;

/**
 * Concrete Admin entity extending User.
 * Manages user accounts, projects, global deadlines, and system parameters.
 */
public class Admin extends User {
    private static final long serialVersionUID = 1L;

    public Admin() {
        super(Role.ADMIN);
    }

    public Admin(int id, String name, String email, String passwordHash,
                 boolean active, LocalDateTime createdAt) {
        super(id, name, email, passwordHash, Role.ADMIN, null, null, null, active, createdAt);
    }

    @Override
    public String getDashboardPath() {
        return "/admin/dashboard";
    }
}
