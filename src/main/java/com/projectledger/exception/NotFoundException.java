package com.projectledger.exception;

/**
 * Thrown when an entity (User, Project, Task, Milestone, etc.) cannot be found.
 * Leads to a user-friendly 404 page.
 */
public class NotFoundException extends AppException {
    private static final long serialVersionUID = 1L;

    public NotFoundException(String message) {
        super(message);
    }

    public NotFoundException(String resourceName, Object identifier) {
        super(resourceName + " with identifier '" + identifier + "' was not found.");
    }
}
