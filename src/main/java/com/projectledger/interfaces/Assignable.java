package com.projectledger.interfaces;

/**
 * Interface representing any work item or entity that can be assigned to a user.
 */
public interface Assignable {
    /**
     * Assigns this item to the specified user identifier.
     *
     * @param userId the user id to assign to
     */
    void assignTo(Integer userId);

    /**
     * Gets the identifier of the assigned user.
     *
     * @return assigned user id, or null if unassigned
     */
    Integer getAssigneeId();
}
