package com.projectledger.service;

import com.projectledger.dao.MilestoneDao;
import com.projectledger.dao.ProjectDao;
import com.projectledger.exception.AccessDeniedException;
import com.projectledger.exception.NotFoundException;
import com.projectledger.model.Milestone;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;

import java.util.List;

/**
 * Service managing academic milestone lifecycles, syllabus sequencing, and faculty reviews.
 */
public class MilestoneService {
    private final MilestoneDao milestoneDao = new MilestoneDao();
    private final ProjectDao projectDao = new ProjectDao();

    public Milestone getMilestone(int milestoneId) {
        return milestoneDao.findById(milestoneId)
                .orElseThrow(() -> new NotFoundException("Milestone", milestoneId));
    }

    public List<Milestone> getProjectMilestones(int projectId) {
        return milestoneDao.findByProjectId(projectId);
    }

    public void saveMilestone(Milestone milestone, SessionUser user) {
        Project project = projectDao.findById(milestone.getProjectId())
                .orElseThrow(() -> new NotFoundException("Project", milestone.getProjectId()));

        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isLeader) {
            throw new AccessDeniedException("Only the project leader may add or edit milestones.");
        }

        if (milestone.getId() > 0) {
            milestoneDao.update(milestone);
        } else {
            milestoneDao.create(milestone);
        }
    }

    public void toggleComplete(int milestoneId, boolean complete, SessionUser user) {
        Milestone m = getMilestone(milestoneId);
        Project project = projectDao.findById(m.getProjectId()).orElseThrow();

        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isLeader) {
            throw new AccessDeniedException("Only the project leader may mark milestones complete.");
        }

        milestoneDao.toggleComplete(milestoneId, complete);
    }

    public void markReviewed(int milestoneId, SessionUser user) {
        Milestone m = getMilestone(milestoneId);
        Project project = projectDao.findById(m.getProjectId()).orElseThrow();

        if (!user.isAdmin() && (!user.isFaculty() || project.getFacultyId() == null || project.getFacultyId() != user.getId())) {
            throw new AccessDeniedException("Only the supervising faculty member may mark milestones as reviewed.");
        }

        milestoneDao.markReviewed(milestoneId);
    }

    public void reorderMilestones(int milestoneId, int sortOrder, SessionUser user) {
        Milestone m = getMilestone(milestoneId);
        Project project = projectDao.findById(m.getProjectId()).orElseThrow();

        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isLeader) {
            throw new AccessDeniedException("Only the project leader may reorder milestones.");
        }

        milestoneDao.updateSortOrder(milestoneId, sortOrder);
    }

    public void deleteMilestone(int milestoneId, SessionUser user) {
        Milestone m = getMilestone(milestoneId);
        Project project = projectDao.findById(m.getProjectId()).orElseThrow();

        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isLeader) {
            throw new AccessDeniedException("Only the project leader may delete milestones.");
        }

        milestoneDao.delete(milestoneId);
    }
}
