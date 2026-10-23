package com.projectledger.model;

/**
 * Health assessment status of an academic project.
 */
public enum ProjectHealth {
    ON_TRACK("On Track", "on-track"),
    AT_RISK("At Risk", "at-risk"),
    DELAYED("Delayed", "delayed");

    private final String displayName;
    private final String cssClass;

    ProjectHealth(String displayName, String cssClass) {
        this.displayName = displayName;
        this.cssClass = cssClass;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getCssClass() {
        return cssClass;
    }
}
