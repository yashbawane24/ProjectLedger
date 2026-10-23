package com.projectledger.servlet;

import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Priority;
import com.projectledger.model.SessionUser;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;
import com.projectledger.service.TaskService;
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
 * Controller for task creation, status updates (Kanban column moves), and deletions.
 */
@WebServlet(name = "ProjectTaskServlet", urlPatterns = {
        "/project/task/save",
        "/project/task/status",
        "/project/task/delete"
})
public class ProjectTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient TaskService taskService = new TaskService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String path = request.getServletPath();

        String projectIdStr = request.getParameter("projectId");
        int projectId = Integer.parseInt(projectIdStr.trim());

        if ("/project/task/status".equals(path)) {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String statusStr = request.getParameter("status");
            try {
                TaskStatus status = TaskStatus.valueOf(statusStr);
                taskService.updateStatus(taskId, status, user);
                Flash.success(request, "Task status changed to " + status.getDisplayName() + ".");
            } catch (Exception e) {
                Flash.error(request, "Could not update status: " + e.getMessage());
            }

        } else if ("/project/task/delete".equals(path)) {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            try {
                taskService.deleteTask(taskId, user);
                Flash.success(request, "Task deleted.");
            } catch (Exception e) {
                Flash.error(request, "Could not delete task: " + e.getMessage());
            }

        } else if ("/project/task/save".equals(path)) {
            String taskIdStr = request.getParameter("taskId");
            int taskId = (taskIdStr != null && !taskIdStr.isBlank()) ? Integer.parseInt(taskIdStr) : 0;
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String assigneeIdStr = request.getParameter("assigneeId");
            String milestoneIdStr = request.getParameter("milestoneId");
            String priorityStr = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");

            LocalDate dueDate = DateUtil.parseDate(dueDateStr);
            Priority priority = Priority.MEDIUM;
            try {
                if (priorityStr != null) priority = Priority.valueOf(priorityStr);
            } catch (IllegalArgumentException ignored) {
            }

            Integer assigneeId = null;
            if (assigneeIdStr != null && !assigneeIdStr.isBlank()) {
                assigneeId = Integer.parseInt(assigneeIdStr);
            }

            Integer milestoneId = null;
            if (milestoneIdStr != null && !milestoneIdStr.isBlank()) {
                milestoneId = Integer.parseInt(milestoneIdStr);
            }

            Validator validator = new Validator();
            validator.requireNonBlank("title", title, "Task title is required.");
            validator.requireLength("title", title, 3, 200, "Title must be between 3 and 200 characters.");
            validator.requireNonBlank("dueDate", dueDateStr, "Due date is required.");

            if (validator.hasErrors()) {
                Flash.error(request, validator.getErrors().values().iterator().next());
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=tasks");
                return;
            }

            try {
                Task task = (taskId > 0) ? taskService.getTask(taskId) : new Task();
                task.setProjectId(projectId);
                task.setTitle(title.trim());
                task.setDescription(description != null ? description.trim() : null);
                task.setAssigneeId(assigneeId);
                task.setMilestoneId(milestoneId);
                task.setPriority(priority);
                task.setDueDate(dueDate);

                if (taskId > 0) {
                    taskService.updateTask(task, user);
                    Flash.success(request, "Task updated successfully.");
                } else {
                    taskService.createTask(task, user);
                    Flash.success(request, "Task created.");
                }
            } catch (AppException e) {
                Flash.error(request, "Failed to save task: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=tasks");
    }
}
