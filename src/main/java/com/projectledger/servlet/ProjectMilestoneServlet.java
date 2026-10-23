package com.projectledger.servlet;

import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Milestone;
import com.projectledger.model.SessionUser;
import com.projectledger.service.MilestoneService;
import com.projectledger.util.DateUtil;
import com.projectledger.util.Flash;
import com.projectledger.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

/**
 * Controller for academic milestone deliverables: creating, editing,
 * reordering, and completing syllabus targets.
 */
@WebServlet(name = "ProjectMilestoneServlet", urlPatterns = {
        "/project/milestone/save",
        "/project/milestone/complete",
        "/project/milestone/reorder"
})
public class ProjectMilestoneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient MilestoneService milestoneService = new MilestoneService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String path = request.getServletPath();

        String projectIdStr = request.getParameter("projectId");
        int projectId = Integer.parseInt(projectIdStr.trim());

        if ("/project/milestone/complete".equals(path)) {
            int milestoneId = Integer.parseInt(request.getParameter("milestoneId"));
            boolean isCompleted = "true".equalsIgnoreCase(request.getParameter("completed"));
            // Toggle
            milestoneService.toggleComplete(milestoneId, !isCompleted, user);
            Flash.success(request, "Milestone completion status updated.");

        } else if ("/project/milestone/reorder".equals(path)) {
            int milestoneId = Integer.parseInt(request.getParameter("milestoneId"));
            int sortOrder = Integer.parseInt(request.getParameter("sortOrder"));
            milestoneService.reorderMilestones(milestoneId, sortOrder, user);
            Flash.success(request, "Milestone order updated.");

        } else if ("/project/milestone/save".equals(path)) {
            String milestoneIdStr = request.getParameter("milestoneId");
            int milestoneId = (milestoneIdStr != null && !milestoneIdStr.isBlank()) ? Integer.parseInt(milestoneIdStr) : 0;
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String targetDateStr = request.getParameter("targetDate");
            String sortOrderStr = request.getParameter("sortOrder");

            LocalDate targetDate = DateUtil.parseDate(targetDateStr);
            int sortOrder = 1;
            try {
                if (sortOrderStr != null) sortOrder = Integer.parseInt(sortOrderStr);
            } catch (NumberFormatException ignored) {
            }

            Validator validator = new Validator();
            validator.requireNonBlank("title", title, "Milestone title is required.");
            validator.requireNonBlank("targetDate", targetDateStr, "Target date is required.");

            if (validator.hasErrors()) {
                Flash.error(request, validator.getErrors().values().iterator().next());
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=milestones");
                return;
            }

            try {
                Milestone m = (milestoneId > 0) ? milestoneService.getMilestone(milestoneId) : new Milestone();
                m.setProjectId(projectId);
                m.setTitle(title.trim());
                m.setDescription(description != null ? description.trim() : null);
                m.setTargetDate(targetDate);
                m.setSortOrder(sortOrder);

                milestoneService.saveMilestone(m, user);
                Flash.success(request, "Milestone saved successfully.");
            } catch (AppException e) {
                Flash.error(request, "Failed to save milestone: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=milestones");
    }
}
