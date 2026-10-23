package com.projectledger.interfaces;

/**
 * Interface representing academic work items that can be reviewed and approved by faculty.
 */
public interface Reviewable {
    /**
     * Gets current review status ("PENDING", "REVIEWED").
     */
    String getReviewStatus();

    /**
     * Marks the item as formally reviewed.
     */
    void markReviewed();
}
