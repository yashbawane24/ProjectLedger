package com.projectledger.servlet;

import com.projectledger.dao.UserDao;
import com.projectledger.exception.AppException;
import com.projectledger.model.Project;
import com.projectledger.model.Role;
import com.projectledger.model.User;
import com.projectledger.service.ProjectService;
import com.projectledger.util.Flash;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for administrator project oversight and faculty reassignment.
 */
@WebServlet(name = "AdminProjectsServlet", urlPatterns = {
        "/admin/projects",
        "/admin/projects/reassign"
})
public class AdminProjectsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();
    private final transient UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Project> projects = projectService.getAllProjects();
        List<User> facultyList = userDao.findByRole(Role.FACULTY);

        request.setAttribute("projects", projects);
        request.setAttribute("facultyList", facultyList);
        request.setAttribute("pageTitle", "Academic Projects Administration");
        request.setAttribute("activeNav", "projects");

        request.getRequestDispatcher("/WEB-INF/jsp/admin/projects.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/projects/reassign".equals(path)) {
            int projectId = Integer.parseInt(request.getParameter("projectId"));
            String facultyIdStr = request.getParameter("facultyId");
            Integer facultyId = (facultyIdStr != null && !facultyIdStr.isBlank()) ? Integer.parseInt(facultyIdStr) : null;

            try {
                projectService.reassignFaculty(projectId, facultyId);
                Flash.success(request, "Supervising faculty reassigned successfully.");
            } catch (AppException e) {
                Flash.error(request, "Failed to reassign supervisor: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/projects");
    }
}
