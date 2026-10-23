package com.projectledger.exception;

/**
 * Thrown when an error occurs while communicating with the GitHub REST API
 * (e.g., repository not found, invalid token, rate limit reached, network failure).
 */
public class GitHubException extends AppException {
    private static final long serialVersionUID = 1L;
    private final int statusCode;

    public GitHubException(String message) {
        super(message);
        this.statusCode = 0;
    }

    public GitHubException(String message, int statusCode) {
        super(message);
        this.statusCode = statusCode;
    }

    public GitHubException(String message, Throwable cause) {
        super(message, cause);
        this.statusCode = 0;
    }

    public int getStatusCode() {
        return statusCode;
    }
}
