package com.projectledger.servlet;

import com.projectledger.dao.DeadlineDao;
import com.projectledger.dao.FeedbackDao;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Deadline;
import com.projectledger.model.Feedback;
import com.projectledger.model.Project;
import com.projectledger.model.ProjectHealth;
import com.projectledger.model.SessionUser;
import com.projectledger.service.ProjectService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the Faculty Supervision Dashboard.
 * Displays supervised projects sorted by health urgency (Delayed first),
 * feedback records, deadlines, and supervision reports.
 */
@WebServlet(name = "FacultyDashboardServlet", urlPatterns = {"/faculty/dashboard"})
public class FacultyDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();
    private final transient FeedbackDao feedbackDao = new FeedbackDao();
    private final transient DeadlineDao deadlineDao = new DeadlineDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);

        List<Project> projects = projectService.getFacultyProjects(user.getId());
        List<Feedback> feedbackList = feedbackDao.findByFacultyId(user.getId());
        List<Deadline> upcomingDeadlines = deadlineDao.findUpcomingForFaculty(user.getId());

        int totalSupervised = projects.size();
        long onTrackCount = projects.stream().filter(p -> p.getHealth() == ProjectHealth.ON_TRACK).count();
        long atRiskCount = projects.stream().filter(p -> p.getHealth() == ProjectHealth.AT_RISK).count();
        long delayedCount = projects.stream().filter(p -> p.getHealth() == ProjectHealth.DELAYED).count();
        int complianceRate = totalSupervised > 0 ? (int) Math.round((onTrackCount * 100.0) / totalSupervised) : 0;

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
                pageTitle = "Supervised Projects";
                activeNav = "projects";
                break;
            case "feedback":
                pageTitle = "Faculty Process Feedback";
                activeNav = "feedback";
                break;
            case "deadlines":
                pageTitle = "Supervised Project Deadlines";
                activeNav = "deadlines";
                break;
            case "reports":
                pageTitle = "Process Oversight Reports";
                activeNav = "reports";
                break;
            default:
                section = "overview";
                pageTitle = "Faculty Supervision Dashboard";
                activeNav = "dashboard";
                break;
        }

        request.setAttribute("projects", projects);
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("upcomingDeadlines", upcomingDeadlines);
        request.setAttribute("totalSupervised", totalSupervised);
        request.setAttribute("onTrackCount", onTrackCount);
        request.setAttribute("atRiskCount", atRiskCount);
        request.setAttribute("delayedCount", delayedCount);
        request.setAttribute("complianceRate", complianceRate);
        request.setAttribute("activeSection", section);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("activeNav", activeNav);

        request.getRequestDispatcher("/WEB-INF/jsp/faculty/dashboard.jsp").forward(request, response);
    }
}
