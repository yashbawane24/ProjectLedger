package com.projectledger.servlet;

import com.projectledger.dao.UserDao;
import com.projectledger.model.Project;
import com.projectledger.model.ProjectHealth;
import com.projectledger.model.Role;
import com.projectledger.model.User;
import com.projectledger.service.ProjectService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Administrator Overview Dashboard.
 * Displays total user counts by role, active project health distributions,
 * and recent user registrations.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient UserDao userDao = new UserDao();
    private final transient ProjectService projectService = new ProjectService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int studentCount = userDao.countUsersByRole(Role.STUDENT);
        int facultyCount = userDao.countUsersByRole(Role.FACULTY);
        int adminCount = userDao.countUsersByRole(Role.ADMIN);

        List<Project> allProjects = projectService.getAllProjects();
        long onTrackProjects = allProjects.stream().filter(p -> p.getHealth() == ProjectHealth.ON_TRACK).count();
        long atRiskProjects = allProjects.stream().filter(p -> p.getHealth() == ProjectHealth.AT_RISK).count();
        long delayedProjects = allProjects.stream().filter(p -> p.getHealth() == ProjectHealth.DELAYED).count();

        List<User> recentSignups = userDao.findRecentSignups(8);

        request.setAttribute("studentCount", studentCount);
        request.setAttribute("facultyCount", facultyCount);
        request.setAttribute("adminCount", adminCount);
        request.setAttribute("totalProjects", allProjects.size());
        request.setAttribute("onTrackProjects", onTrackProjects);
        request.setAttribute("atRiskProjects", atRiskProjects);
        request.setAttribute("delayedProjects", delayedProjects);
        request.setAttribute("recentSignups", recentSignups);
        request.setAttribute("pageTitle", "Administration Overview");
        request.setAttribute("activeNav", "dashboard");

        request.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(request, response);
    }
}
