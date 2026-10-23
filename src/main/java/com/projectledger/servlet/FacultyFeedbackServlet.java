package com.projectledger.servlet;

import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.SessionUser;
import com.projectledger.service.FeedbackService;
import com.projectledger.service.MilestoneService;
import com.projectledger.util.Flash;
import com.projectledger.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

/**
 * Controller for faculty process evaluation, feedback submissions, and milestone reviews.
 */
@WebServlet(name = "FacultyFeedbackServlet", urlPatterns = {
        "/faculty/feedback/save",
        "/faculty/milestone/review"
})
public class FacultyFeedbackServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient FeedbackService feedbackService = new FeedbackService();
    private final transient MilestoneService milestoneService = new MilestoneService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String path = request.getServletPath();

        if ("/faculty/milestone/review".equals(path)) {
            int milestoneId = Integer.parseInt(request.getParameter("milestoneId"));
            int projectId = Integer.parseInt(request.getParameter("projectId"));

            try {
                milestoneService.markReviewed(milestoneId, user);
                Flash.success(request, "Milestone marked as formally reviewed.");
            } catch (AppException e) {
                Flash.error(request, e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=milestones");
            return;
        }

        // /faculty/feedback/save
        String projectIdStr = request.getParameter("projectId");
        int projectId = Integer.parseInt(projectIdStr.trim());
        String milestoneIdStr = request.getParameter("milestoneId");
        String comment = request.getParameter("comment");
        String scoreStr = request.getParameter("score");
        boolean markReviewed = "true".equalsIgnoreCase(request.getParameter("markReviewed")) ||
                               request.getParameter("markReviewed") != null;

        Integer milestoneId = null;
        if (milestoneIdStr != null && !milestoneIdStr.isBlank()) {
            milestoneId = Integer.parseInt(milestoneIdStr.trim());
        }

        BigDecimal score = null;
        if (scoreStr != null && !scoreStr.isBlank()) {
            try {
                double val = Double.parseDouble(scoreStr.trim());
                if (val < 0.0 || val > 10.0) {
                    Flash.error(request, "Evaluation score must be between 0.0 and 10.0.");
                    response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=feedback");
                    return;
                }
                score = BigDecimal.valueOf(val);
            } catch (NumberFormatException e) {
                Flash.error(request, "Please enter a valid numeric score (e.g. 8.5).");
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=feedback");
                return;
            }
        }

        Validator validator = new Validator();
        validator.requireNonBlank("comment", comment, "Feedback comment cannot be blank.");

        if (validator.hasErrors()) {
            Flash.error(request, validator.getErrors().values().iterator().next());
            response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=feedback");
            return;
        }

        try {
            feedbackService.addFeedback(projectId, milestoneId, comment, score, markReviewed, user);
            Flash.success(request, "Evaluation feedback recorded.");
        } catch (AppException e) {
            Flash.error(request, "Failed to record feedback: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=feedback");
    }
}
