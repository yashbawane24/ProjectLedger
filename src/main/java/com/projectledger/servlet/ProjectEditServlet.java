package com.projectledger.servlet;

import com.projectledger.exception.AccessDeniedException;
import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.service.ProjectService;
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
 * Controller for editing or deleting academic projects.
 */
@WebServlet(name = "ProjectEditServlet", urlPatterns = {"/project/edit", "/project/delete"})
public class ProjectEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String path = request.getServletPath();

        String idStr = request.getParameter("projectId");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + user.getDashboardPath());
            return;
        }

        int projectId;
        try {
            projectId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid project ID.");
            return;
        }

        Project project = projectService.getProjectWithMetrics(projectId);
        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isLeader) {
            throw new AccessDeniedException("Only the project leader or an administrator may modify this project.");
        }

        if ("/project/delete".equals(path)) {
            projectService.deleteProject(projectId);
            Flash.success(request, "Project '" + project.getTitle() + "' was deleted.");
            response.sendRedirect(request.getContextPath() + user.getDashboardPath());
            return;
        }

        // Edit flow
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String repoUrl = request.getParameter("repoUrl");
        String demoUrl = request.getParameter("demoUrl");

        LocalDate startDate = DateUtil.parseDate(startDateStr);
        LocalDate endDate = DateUtil.parseDate(endDateStr);

        Validator validator = new Validator();
        validator.requireNonBlank("title", title, "Project title is required.");
        validator.requireLength("title", title, 5, 200, "Title must be between 5 and 200 characters.");
        validator.requireNonBlank("description", description, "Description is required.");
        validator.requireNonBlank("startDate", startDateStr, "Start date is required.");
        validator.requireNonBlank("endDate", endDateStr, "End date is required.");
        validator.requireDateOrder("endDate", startDate, endDate, "End date must be after start date.");

        String owner = null;
        String repo = null;
        if (repoUrl != null && !repoUrl.isBlank()) {
            String[] parts = Validator.parseGitHubRepo(repoUrl);
            if (parts == null) {
                validator.addError("repoUrl", "Invalid GitHub repository format (expected https://github.com/owner/repo).");
            } else {
                owner = parts[0];
                repo = parts[1];
            }
        }

        if (demoUrl != null && !demoUrl.isBlank()) {
            validator.requireUrl("demoUrl", demoUrl, "Invalid live demo URL (must begin with http:// or https://).");
        }

        if (validator.hasErrors()) {
            Flash.error(request, validator.getErrors().values().iterator().next());
            response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=overview");
            return;
        }

        try {
            project.setTitle(title.trim());
            project.setDescription(description.trim());
            project.setStartDate(startDate);
            project.setEndDate(endDate);
            project.setRepoOwner(owner);
            project.setRepoName(repo);
            project.setDemoUrl((demoUrl != null && !demoUrl.isBlank()) ? demoUrl.trim() : null);

            projectService.updateProject(project);
            Flash.success(request, "Project details updated.");
        } catch (AppException e) {
            Flash.error(request, "Failed to update project: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=overview");
    }
}
