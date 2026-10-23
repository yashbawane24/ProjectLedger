package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.Feedback;
import com.projectledger.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Faculty Feedback and Evaluation Scores.
 */
public class FeedbackDao {

    public List<Feedback> findByProjectId(int projectId) {
        String sql = "SELECT fb.*, u.name AS faculty_name, m.title AS milestone_title " +
                     "FROM feedback fb " +
                     "JOIN users u ON fb.faculty_id = u.id " +
                     "LEFT JOIN milestones m ON fb.milestone_id = m.id " +
                     "WHERE fb.project_id = ? " +
                     "ORDER BY fb.created_at DESC";
        List<Feedback> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToFeedback(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve feedback for project ID: " + projectId, e);
        }
    }

    public int create(Feedback feedback) {
        String sql = "INSERT INTO feedback (project_id, faculty_id, milestone_id, comment, score, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, feedback.getProjectId());
            ps.setInt(2, feedback.getFacultyId());
            if (feedback.getMilestoneId() != null) {
                ps.setInt(3, feedback.getMilestoneId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, feedback.getComment());
            if (feedback.getScore() != null) {
                ps.setBigDecimal(5, feedback.getScore());
            } else {
                ps.setNull(5, Types.DECIMAL);
            }
            ps.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new AppException("Creating feedback failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    feedback.setId(generatedKeys.getInt(1));
                    return feedback.getId();
                } else {
                    throw new AppException("Creating feedback failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            throw new AppException("Failed to create feedback for project ID: " + feedback.getProjectId(), e);
        }
    }

    private Feedback mapRowToFeedback(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getInt("id"));
        f.setProjectId(rs.getInt("project_id"));
        f.setFacultyId(rs.getInt("faculty_id"));
        int mId = rs.getInt("milestone_id");
        f.setMilestoneId(rs.wasNull() ? null : mId);
        f.setComment(rs.getString("comment"));
        f.setScore(rs.getBigDecimal("score"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) f.setCreatedAt(ts.toLocalDateTime());

        f.setFacultyName(rs.getString("faculty_name"));
        f.setMilestoneTitle(rs.getString("milestone_title"));
        return f;
    }

    public List<Feedback> findByFacultyId(int facultyId) {
        String sql = "SELECT fb.*, u.name AS faculty_name, m.title AS milestone_title, p.title AS project_title " +
                     "FROM feedback fb " +
                     "JOIN users u ON fb.faculty_id = u.id " +
                     "JOIN projects p ON fb.project_id = p.id " +
                     "LEFT JOIN milestones m ON fb.milestone_id = m.id " +
                     "WHERE fb.faculty_id = ? " +
                     "ORDER BY fb.created_at DESC";
        List<Feedback> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = mapRowToFeedback(rs);
                    f.setProjectTitle(rs.getString("project_title"));
                    list.add(f);
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve feedback for faculty ID: " + facultyId, e);
        }
    }
}
