package com.projectledger.exception;

/**
 * Base application exception for ProjectLedger.
 * Checked or unchecked domain exceptions extend this or are wrapped by this class.
 */
public class AppException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public AppException(String message) {
        super(message);
    }

    public AppException(String message, Throwable cause) {
        super(message, cause);
    }
}
