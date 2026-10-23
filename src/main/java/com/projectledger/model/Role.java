package com.projectledger.model;

/**
 * User roles within ProjectLedger.
 */
public enum Role {
    STUDENT("Student"),
    FACULTY("Faculty"),
    ADMIN("Admin");

    private final String displayName;

    Role(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
