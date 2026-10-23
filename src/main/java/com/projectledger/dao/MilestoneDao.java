package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.Milestone;
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
 * Data Access Object for Milestone entities.
 */
public class MilestoneDao {

    public Optional<Milestone> findById(int id) {
        String sql = "SELECT m.*, " +
                     "(SELECT COUNT(*) FROM tasks t WHERE t.milestone_id = m.id) AS total_tasks, " +
                     "(SELECT COUNT(*) FROM tasks t WHERE t.milestone_id = m.id AND t.status = 'COMPLETED') AS completed_tasks " +
                     "FROM milestones m WHERE m.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToMilestone(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve milestone with ID: " + id, e);
        }
    }

    public List<Milestone> findByProjectId(int projectId) {
        String sql = "SELECT m.*, " +
                     "(SELECT COUNT(*) FROM tasks t WHERE t.milestone_id = m.id) AS total_tasks, " +
                     "(SELECT COUNT(*) FROM tasks t WHERE t.milestone_id = m.id AND t.status = 'COMPLETED') AS completed_tasks " +
                     "FROM milestones m " +
                     "WHERE m.project_id = ? " +
                     "ORDER BY m.sort_order ASC, m.target_date ASC";
        List<Milestone> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToMilestone(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve milestones for project ID: " + projectId, e);
        }
    }

    public int create(Milestone milestone, Connection conn) throws SQLException {
        String sql = "INSERT INTO milestones (project_id, title, description, target_date, completed_at, sort_order, review_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, milestone.getProjectId());
            ps.setString(2, milestone.getTitle());
            ps.setString(3, milestone.getDescription());
            ps.setDate(4, Date.valueOf(milestone.getTargetDate()));
            if (milestone.getCompletedAt() != null) {
                ps.setTimestamp(5, Timestamp.valueOf(milestone.getCompletedAt()));
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }
            ps.setInt(6, milestone.getSortOrder());
            ps.setString(7, milestone.getReviewStatus() != null ? milestone.getReviewStatus() : "PENDING");

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating milestone failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    milestone.setId(generatedKeys.getInt(1));
                    return milestone.getId();
                } else {
                    throw new SQLException("Creating milestone failed, no ID obtained.");
                }
            }
        }
    }

    public int create(Milestone milestone) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            return create(milestone, conn);
        } catch (SQLException e) {
            throw new AppException("Failed to create milestone: " + milestone.getTitle(), e);
        }
    }

    public void update(Milestone milestone) {
        String sql = "UPDATE milestones SET title = ?, description = ?, target_date = ?, sort_order = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, milestone.getTitle());
            ps.setString(2, milestone.getDescription());
            ps.setDate(3, Date.valueOf(milestone.getTargetDate()));
            ps.setInt(4, milestone.getSortOrder());
            ps.setInt(5, milestone.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update milestone ID: " + milestone.getId(), e);
        }
    }

    public void toggleComplete(int milestoneId, boolean complete) {
        String sql = "UPDATE milestones SET completed_at = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (complete) {
                ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            } else {
                ps.setNull(1, Types.TIMESTAMP);
            }
            ps.setInt(2, milestoneId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to toggle completion for milestone ID: " + milestoneId, e);
        }
    }

    public void markReviewed(int milestoneId) {
        String sql = "UPDATE milestones SET review_status = 'REVIEWED' WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, milestoneId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to mark milestone reviewed for ID: " + milestoneId, e);
        }
    }

    public void updateSortOrder(int milestoneId, int sortOrder) {
        String sql = "UPDATE milestones SET sort_order = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sortOrder);
            ps.setInt(2, milestoneId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update sort order for milestone ID: " + milestoneId, e);
        }
    }

    public void delete(int milestoneId) {
        String sql = "DELETE FROM milestones WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, milestoneId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to delete milestone ID: " + milestoneId, e);
        }
    }

    private Milestone mapRowToMilestone(ResultSet rs) throws SQLException {
        Milestone m = new Milestone();
        m.setId(rs.getInt("id"));
        m.setProjectId(rs.getInt("project_id"));
        m.setTitle(rs.getString("title"));
        m.setDescription(rs.getString("description"));
        Date tDate = rs.getDate("target_date");
        if (tDate != null) m.setTargetDate(tDate.toLocalDate());
        Timestamp cTs = rs.getTimestamp("completed_at");
        if (cTs != null) m.setCompletedAt(cTs.toLocalDateTime());
        m.setSortOrder(rs.getInt("sort_order"));
        m.setReviewStatus(rs.getString("review_status"));

        try {
            m.setTotalTasks(rs.getInt("total_tasks"));
            m.setCompletedTasks(rs.getInt("completed_tasks"));
        } catch (SQLException ignored) {
            // total_tasks column might not be in every query
        }
        return m;
    }
}
