package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.Priority;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;
import com.projectledger.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for Task entities.
 */
public class TaskDao {

    public Optional<Task> findById(int id) {
        String sql = "SELECT t.*, m.title AS milestone_title, u.name AS assignee_name, u.email AS assignee_email, c.name AS creator_name " +
                     "FROM tasks t " +
                     "LEFT JOIN milestones m ON t.milestone_id = m.id " +
                     "LEFT JOIN users u ON t.assignee_id = u.id " +
                     "JOIN users c ON t.created_by = c.id " +
                     "WHERE t.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToTask(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve task with ID: " + id, e);
        }
    }

    public List<Task> findByProjectId(int projectId) {
        String sql = "SELECT t.*, m.title AS milestone_title, u.name AS assignee_name, u.email AS assignee_email, c.name AS creator_name " +
                     "FROM tasks t " +
                     "LEFT JOIN milestones m ON t.milestone_id = m.id " +
                     "LEFT JOIN users u ON t.assignee_id = u.id " +
                     "JOIN users c ON t.created_by = c.id " +
                     "WHERE t.project_id = ? " +
                     "ORDER BY t.due_date ASC, t.priority DESC";
        List<Task> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTask(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve tasks for project ID: " + projectId, e);
        }
    }

    public List<Task> findByAssigneeId(int userId) {
        String sql = "SELECT t.*, m.title AS milestone_title, u.name AS assignee_name, u.email AS assignee_email, c.name AS creator_name " +
                     "FROM tasks t " +
                     "LEFT JOIN milestones m ON t.milestone_id = m.id " +
                     "LEFT JOIN users u ON t.assignee_id = u.id " +
                     "JOIN users c ON t.created_by = c.id " +
                     "WHERE t.assignee_id = ? " +
                     "ORDER BY t.due_date ASC";
        List<Task> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTask(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve tasks for assignee ID: " + userId, e);
        }
    }

    public int create(Task task, Connection conn) throws SQLException {
        String sql = "INSERT INTO tasks (project_id, milestone_id, title, description, assignee_id, priority, " +
                     "status, due_date, completed_at, created_by, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, task.getProjectId());
            if (task.getMilestoneId() != null) {
                ps.setInt(2, task.getMilestoneId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, task.getTitle());
            ps.setString(4, task.getDescription());
            if (task.getAssigneeId() != null) {
                ps.setInt(5, task.getAssigneeId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setString(6, task.getPriority().name());
            ps.setString(7, task.getStatus().name());
            ps.setDate(8, Date.valueOf(task.getDueDate()));
            if (task.getCompletedAt() != null) {
                ps.setTimestamp(9, Timestamp.valueOf(task.getCompletedAt()));
            } else {
                ps.setNull(9, Types.TIMESTAMP);
            }
            ps.setInt(10, task.getCreatedBy());
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            ps.setTimestamp(11, now);
            ps.setTimestamp(12, now);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating task failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    task.setId(generatedKeys.getInt(1));
                    return task.getId();
                } else {
                    throw new SQLException("Creating task failed, no ID obtained.");
                }
            }
        }
    }

    public int create(Task task) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return create(task, conn);
        } catch (SQLException e) {
            throw new AppException("Failed to create task: " + task.getTitle(), e);
        }
    }

    public void update(Task task) {
        String sql = "UPDATE tasks SET milestone_id = ?, title = ?, description = ?, assignee_id = ?, " +
                     "priority = ?, due_date = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (task.getMilestoneId() != null) {
                ps.setInt(1, task.getMilestoneId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, task.getTitle());
            ps.setString(3, task.getDescription());
            if (task.getAssigneeId() != null) {
                ps.setInt(4, task.getAssigneeId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, task.getPriority().name());
            ps.setDate(6, Date.valueOf(task.getDueDate()));
            ps.setInt(7, task.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update task ID: " + task.getId(), e);
        }
    }

    public void updateStatus(int taskId, TaskStatus status) {
        String sql = "UPDATE tasks SET status = ?, completed_at = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            if (status == TaskStatus.COMPLETED) {
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            } else {
                ps.setNull(2, Types.TIMESTAMP);
            }
            ps.setInt(3, taskId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update status for task ID: " + taskId, e);
        }
    }

    public void delete(int taskId) {
        String sql = "DELETE FROM tasks WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to delete task ID: " + taskId, e);
        }
    }

    private Task mapRowToTask(ResultSet rs) throws SQLException {
        Task t = new Task();
        t.setId(rs.getInt("id"));
        t.setProjectId(rs.getInt("project_id"));
        int mId = rs.getInt("milestone_id");
        t.setMilestoneId(rs.wasNull() ? null : mId);
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        int aId = rs.getInt("assignee_id");
        t.setAssigneeId(rs.wasNull() ? null : aId);
        t.setPriority(Priority.valueOf(rs.getString("priority")));
        t.setStatus(TaskStatus.valueOf(rs.getString("status")));
        Date dDate = rs.getDate("due_date");
        if (dDate != null) t.setDueDate(dDate.toLocalDate());
        Timestamp cTs = rs.getTimestamp("completed_at");
        if (cTs != null) t.setCompletedAt(cTs.toLocalDateTime());
        t.setCreatedBy(rs.getInt("created_by"));
        Timestamp crTs = rs.getTimestamp("created_at");
        if (crTs != null) t.setCreatedAt(crTs.toLocalDateTime());
        Timestamp uTs = rs.getTimestamp("updated_at");
        if (uTs != null) t.setUpdatedAt(uTs.toLocalDateTime());

        t.setMilestoneTitle(rs.getString("milestone_title"));
        t.setAssigneeName(rs.getString("assignee_name"));
        t.setAssigneeEmail(rs.getString("assignee_email"));
        t.setCreatorName(rs.getString("creator_name"));
        return t;
    }
}
