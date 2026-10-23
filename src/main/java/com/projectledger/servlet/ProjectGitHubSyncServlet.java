package com.projectledger.servlet;

import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.service.GitHubService;
import com.projectledger.service.ProjectService;
import com.projectledger.util.Flash;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller to manually trigger GitHub repository activity synchronization.
 */
@WebServlet(name = "ProjectGitHubSyncServlet", urlPatterns = {"/project/github/sync"})
public class ProjectGitHubSyncServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();
    private final transient GitHubService gitHubService = new GitHubService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);

        String projectIdStr = request.getParameter("projectId");
        int projectId = Integer.parseInt(projectIdStr.trim());

        Project project = projectService.getProjectWithMetrics(projectId);
        projectService.checkAccess(project, user);

        try {
            int count = gitHubService.syncCommits(project);
            Flash.success(request, "GitHub activity synchronized: " + count + " commits analyzed.");
        } catch (AppException e) {
            Flash.error(request, e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=activity");
    }
}
