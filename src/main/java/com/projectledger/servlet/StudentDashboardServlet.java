package com.projectledger.servlet;

import com.projectledger.dao.DeadlineDao;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Deadline;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.model.Task;
import com.projectledger.service.ProjectService;
import com.projectledger.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller for the Student Dashboard.
 * Displays "My Projects" with health stamps, "My Tasks" grouped by due dates,
 * and upcoming academic deadlines.
 */
@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();
    private final transient TaskService taskService = new TaskService();
    private final transient DeadlineDao deadlineDao = new DeadlineDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);

        List<Project> projects = projectService.getStudentProjects(user.getId());
        Map<String, List<Task>> taskGroups = taskService.getStudentDashboardTasks(user.getId());
        List<Deadline> upcomingDeadlines = deadlineDao.findUpcomingForStudent(user.getId());

        String section = request.getParameter("section");
        if (section == null || section.isBlank()) {
            section = "overview";
        } else {
            section = section.trim().toLowerCase();
        }

        String pageTitle;
        String activeNav;
        switch (section) {
            case "projects":
                pageTitle = "My Projects";
                activeNav = "projects";
                break;
            case "tasks":
                pageTitle = "My Development Tasks";
                activeNav = "tasks";
                break;
            case "deadlines":
                pageTitle = "Academic Deadlines & Milestones";
                activeNav = "deadlines";
                break;
            default:
                section = "overview";
                pageTitle = "Student Dashboard";
                activeNav = "dashboard";
                break;
        }

        request.setAttribute("projects", projects);
        request.setAttribute("taskGroups", taskGroups);
        request.setAttribute("upcomingDeadlines", upcomingDeadlines);
        request.setAttribute("activeSection", section);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("activeNav", activeNav);

        request.getRequestDispatcher("/WEB-INF/jsp/student/dashboard.jsp").forward(request, response);
    }
}
