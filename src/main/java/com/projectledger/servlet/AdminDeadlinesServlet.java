package com.projectledger.servlet;

import com.projectledger.dao.DeadlineDao;
import com.projectledger.dao.ProjectDao;
import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Deadline;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
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
 * Controller for administrator deadline management (both global and project-scoped).
 */
@WebServlet(name = "AdminDeadlinesServlet", urlPatterns = {
        "/admin/deadlines",
        "/admin/deadlines/save",
        "/admin/deadlines/delete"
})
public class AdminDeadlinesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient DeadlineDao deadlineDao = new DeadlineDao();
    private final transient ProjectDao projectDao = new ProjectDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Deadline> deadlines = deadlineDao.findAll();
        List<Project> projects = projectDao.findAll();

        request.setAttribute("deadlines", deadlines);
        request.setAttribute("projects", projects);
        request.setAttribute("pageTitle", "University Deadlines Management");
        request.setAttribute("activeNav", "deadlines");

        request.getRequestDispatcher("/WEB-INF/jsp/admin/deadlines.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String path = request.getServletPath();

        if ("/admin/deadlines/delete".equals(path)) {
            int deadlineId = Integer.parseInt(request.getParameter("deadlineId"));
            try {
                deadlineDao.delete(deadlineId);
                Flash.success(request, "Deadline removed.");
            } catch (AppException e) {
                Flash.error(request, "Failed to remove deadline: " + e.getMessage());
            }

        } else if ("/admin/deadlines/save".equals(path)) {
            String idStr = request.getParameter("deadlineId");
            int id = (idStr != null && !idStr.isBlank()) ? Integer.parseInt(idStr) : 0;
            String title = request.getParameter("title");
            String dueDateStr = request.getParameter("dueDate");
            String projectIdStr = request.getParameter("projectId");

            LocalDate dueDate = DateUtil.parseDate(dueDateStr);
            Integer projectId = null;
            if (projectIdStr != null && !projectIdStr.isBlank()) {
                projectId = Integer.parseInt(projectIdStr.trim());
            }

            Validator validator = new Validator();
            validator.requireNonBlank("title", title, "Deadline title is required.");
            validator.requireNonBlank("dueDate", dueDateStr, "Due date is required.");

            if (validator.hasErrors()) {
                Flash.error(request, validator.getErrors().values().iterator().next());
                response.sendRedirect(request.getContextPath() + "/admin/deadlines");
                return;
            }

            try {
                Deadline deadline = (id > 0) ? deadlineDao.findById(id).orElseThrow() : new Deadline();
                deadline.setTitle(title.trim());
                deadline.setDueDate(dueDate);
                deadline.setProjectId(projectId);
                deadline.setCreatedBy(user.getId());

                if (id > 0) {
                    deadlineDao.update(deadline);
                    Flash.success(request, "Deadline updated.");
                } else {
                    deadlineDao.create(deadline);
                    Flash.success(request, "Deadline established.");
                }
            } catch (AppException e) {
                Flash.error(request, "Failed to save deadline: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/deadlines");
    }
}
