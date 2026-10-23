package com.projectledger.service;

import com.projectledger.dao.ProjectDao;
import com.projectledger.dao.TaskDao;
import com.projectledger.dao.TeamMemberDao;
import com.projectledger.exception.AccessDeniedException;
import com.projectledger.exception.NotFoundException;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Service managing task creation, assignment, Kanban boards, and student dashboard grouping.
 */
public class TaskService {
    private final TaskDao taskDao = new TaskDao();
    private final ProjectDao projectDao = new ProjectDao();
    private final TeamMemberDao teamMemberDao = new TeamMemberDao();

    public Task getTask(int taskId) {
        return taskDao.findById(taskId)
                .orElseThrow(() -> new NotFoundException("Task", taskId));
    }

    public List<Task> getProjectTasks(int projectId) {
        return taskDao.findByProjectId(projectId);
    }

    public void createTask(Task task, SessionUser user) {
        Project project = projectDao.findById(task.getProjectId())
                .orElseThrow(() -> new NotFoundException("Project", task.getProjectId()));

        // Verification: Any team member or admin can create tasks
        if (!user.isAdmin() && project.getLeaderId() != user.getId() &&
                teamMemberDao.findByProjectAndUser(project.getId(), user.getId()).isEmpty()) {
            throw new AccessDeniedException("Only team members may create tasks for this project.");
        }

        task.setCreatedBy(user.getId());
        taskDao.create(task);
    }

    public void updateTask(Task task, SessionUser user) {
        Task existing = getTask(task.getId());
        Project project = projectDao.findById(existing.getProjectId()).orElseThrow();

        if (!user.isAdmin() && project.getLeaderId() != user.getId() &&
                teamMemberDao.findByProjectAndUser(project.getId(), user.getId()).isEmpty()) {
            throw new AccessDeniedException("Only team members may edit tasks for this project.");
        }

        taskDao.update(task);
    }

    public void updateStatus(int taskId, TaskStatus status, SessionUser user) {
        Task task = getTask(taskId);
        Project project = projectDao.findById(task.getProjectId()).orElseThrow();

        // Assignee or leader can change status
        boolean isAssignee = task.getAssigneeId() != null && task.getAssigneeId() == user.getId();
        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isAssignee && !isLeader) {
            throw new AccessDeniedException("Only the assigned member or project leader may update task status.");
        }

        taskDao.updateStatus(taskId, status);
    }

    public void deleteTask(int taskId, SessionUser user) {
        Task task = getTask(taskId);
        Project project = projectDao.findById(task.getProjectId()).orElseThrow();

        boolean isCreator = task.getCreatedBy() == user.getId();
        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isCreator && !isLeader) {
            throw new AccessDeniedException("Only the task creator or project leader may delete tasks.");
        }

        taskDao.delete(taskId);
    }

    /**
     * Groups project tasks into 4 Kanban columns: NOT_STARTED, IN_PROGRESS, COMPLETED, OVERDUE.
     */
    public Map<String, List<Task>> getKanbanColumns(int projectId) {
        List<Task> allTasks = taskDao.findByProjectId(projectId);
        Map<String, List<Task>> columns = new LinkedHashMap<>();
        columns.put("NOT_STARTED", new ArrayList<>());
        columns.put("IN_PROGRESS", new ArrayList<>());
        columns.put("COMPLETED", new ArrayList<>());
        columns.put("OVERDUE", new ArrayList<>());

        for (Task task : allTasks) {
            if (task.isOverdue()) {
                columns.get("OVERDUE").add(task);
            } else if (task.getStatus() == TaskStatus.NOT_STARTED) {
                columns.get("NOT_STARTED").add(task);
            } else if (task.getStatus() == TaskStatus.IN_PROGRESS) {
                columns.get("IN_PROGRESS").add(task);
            } else if (task.getStatus() == TaskStatus.COMPLETED) {
                columns.get("COMPLETED").add(task);
            }
        }
        return columns;
    }

    /**
     * Groups a student's assigned tasks for dashboard display:
     * Overdue -> Due this week -> Later -> Completed recently
     */
    public Map<String, List<Task>> getStudentDashboardTasks(int studentId) {
        List<Task> tasks = taskDao.findByAssigneeId(studentId);
        LocalDate today = LocalDate.now();
        LocalDate weekEnd = today.plusDays(7);

        Map<String, List<Task>> groups = new LinkedHashMap<>();
        groups.put("overdue", new ArrayList<>());
        groups.put("thisWeek", new ArrayList<>());
        groups.put("later", new ArrayList<>());
        groups.put("completed", new ArrayList<>());

        for (Task t : tasks) {
            if (t.getStatus() == TaskStatus.COMPLETED) {
                groups.get("completed").add(t);
            } else if (t.getDueDate() != null && t.getDueDate().isBefore(today)) {
                groups.get("overdue").add(t);
            } else if (t.getDueDate() != null && !t.getDueDate().isAfter(weekEnd)) {
                groups.get("thisWeek").add(t);
            } else {
                groups.get("later").add(t);
            }
        }
        return groups;
    }
}
