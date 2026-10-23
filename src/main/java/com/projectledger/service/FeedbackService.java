package com.projectledger.service;

import com.projectledger.dao.FeedbackDao;
import com.projectledger.dao.MilestoneDao;
import com.projectledger.dao.ProjectDao;
import com.projectledger.exception.AccessDeniedException;
import com.projectledger.exception.NotFoundException;
import com.projectledger.model.Feedback;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Service managing faculty feedback and evaluation scores.
 */
public class FeedbackService {
    private final FeedbackDao feedbackDao = new FeedbackDao();
    private final ProjectDao projectDao = new ProjectDao();
    private final MilestoneDao milestoneDao = new MilestoneDao();

    public List<Feedback> getProjectFeedback(int projectId) {
        return feedbackDao.findByProjectId(projectId);
    }

    public void addFeedback(int projectId, Integer milestoneId, String comment, BigDecimal score,
                            boolean markMilestoneReviewed, SessionUser user) {
        Project project = projectDao.findById(projectId)
                .orElseThrow(() -> new NotFoundException("Project", projectId));

        if (!user.isAdmin() && (!user.isFaculty() || project.getFacultyId() == null || project.getFacultyId() != user.getId())) {
            throw new AccessDeniedException("Only the assigned supervising faculty member may provide evaluation feedback.");
        }

        Feedback fb = new Feedback();
        fb.setProjectId(projectId);
        fb.setFacultyId(user.getId());
        fb.setMilestoneId(milestoneId);
        fb.setComment(comment != null ? comment.trim() : "");
        fb.setScore(score);
        fb.setCreatedAt(LocalDateTime.now());

        feedbackDao.create(fb);

        if (markMilestoneReviewed && milestoneId != null) {
            milestoneDao.markReviewed(milestoneId);
        }
    }
}
