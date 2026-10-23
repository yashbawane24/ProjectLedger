package com.projectledger.exception;

/**
 * Thrown when an authenticated user attempts to access or modify a resource
 * they do not have authorization to view or edit.
 * Leads to a user-friendly 403 Forbidden page.
 */
public class AccessDeniedException extends AppException {
    private static final long serialVersionUID = 1L;

    public AccessDeniedException(String message) {
        super(message);
    }
}
