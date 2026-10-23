package com.projectledger.servlet;

import com.projectledger.dao.UserDao;
import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Project;
import com.projectledger.model.Role;
import com.projectledger.model.SessionUser;
import com.projectledger.model.User;
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
import java.util.List;

/**
 * Controller for creating new student academic projects.
 */
@WebServlet(name = "ProjectNewServlet", urlPatterns = {"/student/projects/new"})
public class ProjectNewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();
    private final transient UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> facultyList = userDao.findByRole(Role.FACULTY);
        request.setAttribute("facultyList", facultyList);
        request.setAttribute("pageTitle", "Register New Academic Project");
        request.setAttribute("activeNav", "new-project");

        request.getRequestDispatcher("/WEB-INF/jsp/student/project_new.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String facultyIdStr = request.getParameter("facultyId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String repoUrl = request.getParameter("repoUrl");
        String demoUrl = request.getParameter("demoUrl");
        boolean addMilestones = "true".equalsIgnoreCase(request.getParameter("addDefaultMilestones")) ||
                                request.getParameter("addDefaultMilestones") != null;

        LocalDate startDate = DateUtil.parseDate(startDateStr);
        LocalDate endDate = DateUtil.parseDate(endDateStr);

        Validator validator = new Validator();
        validator.requireNonBlank("title", title, "Project title is required.");
        validator.requireLength("title", title, 5, 200, "Title must be between 5 and 200 characters.");
        validator.requireNonBlank("description", description, "Project description is required.");
        validator.requireNonBlank("startDate", startDateStr, "Start date is required.");
        validator.requireNonBlank("endDate", endDateStr, "End date is required.");
        validator.requireDateOrder("endDate", startDate, endDate, "End date must be after start date.");

        String owner = null;
        String repo = null;
        if (repoUrl != null && !repoUrl.isBlank()) {
            String[] parts = Validator.parseGitHubRepo(repoUrl);
            if (parts == null) {
                validator.addError("repoUrl", "Please enter a valid GitHub repository URL (e.g. https://github.com/owner/repo).");
            } else {
                owner = parts[0];
                repo = parts[1];
            }
        }

        if (demoUrl != null && !demoUrl.isBlank()) {
            validator.requireUrl("demoUrl", demoUrl, "Please provide a valid URL for the live demo (starting with http:// or https://).");
        }

        Integer facultyId = null;
        if (facultyIdStr != null && !facultyIdStr.isBlank()) {
            try {
                facultyId = Integer.parseInt(facultyIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        if (validator.hasErrors()) {
            request.setAttribute("errors", validator.getErrors());
            request.setAttribute("title", title);
            request.setAttribute("description", description);
            request.setAttribute("facultyId", facultyId);
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);
            request.setAttribute("repoUrl", repoUrl);
            request.setAttribute("demoUrl", demoUrl);
            request.setAttribute("addDefaultMilestones", addMilestones);
            doGet(request, response);
            return;
        }

        try {
            Project project = new Project();
            project.setTitle(title.trim());
            project.setDescription(description.trim());
            project.setLeaderId(user.getId());
            project.setFacultyId(facultyId);
            project.setStartDate(startDate);
            project.setEndDate(endDate);
            project.setRepoOwner(owner);
            project.setRepoName(repo);
            project.setDemoUrl((demoUrl != null && !demoUrl.isBlank()) ? demoUrl.trim() : null);

            projectService.createProject(project, addMilestones);

            Flash.success(request, "Project '" + project.getTitle() + "' created successfully.");
            response.sendRedirect(request.getContextPath() + "/project?id=" + project.getId());
        } catch (AppException e) {
            Flash.error(request, e.getMessage());
            doGet(request, response);
        }
    }
}
