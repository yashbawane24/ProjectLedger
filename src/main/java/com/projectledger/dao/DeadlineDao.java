package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.Deadline;
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
 * Data Access Object for Academic Deadlines.
 */
public class DeadlineDao {

    public Optional<Deadline> findById(int id) {
        String sql = "SELECT d.*, p.title AS project_title, u.name AS creator_name " +
                     "FROM deadlines d " +
                     "LEFT JOIN projects p ON d.project_id = p.id " +
                     "JOIN users u ON d.created_by = u.id " +
                     "WHERE d.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToDeadline(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve deadline with ID: " + id, e);
        }
    }

    public List<Deadline> findGlobalDeadlines() {
        String sql = "SELECT d.*, NULL AS project_title, u.name AS creator_name " +
                     "FROM deadlines d " +
                     "JOIN users u ON d.created_by = u.id " +
                     "WHERE d.project_id IS NULL " +
                     "ORDER BY d.due_date ASC";
        List<Deadline> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToDeadline(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve global deadlines", e);
        }
    }

    public List<Deadline> findByProjectId(int projectId) {
        String sql = "SELECT d.*, p.title AS project_title, u.name AS creator_name " +
                     "FROM deadlines d " +
                     "JOIN projects p ON d.project_id = p.id " +
                     "JOIN users u ON d.created_by = u.id " +
                     "WHERE d.project_id = ? " +
                     "ORDER BY d.due_date ASC";
        List<Deadline> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToDeadline(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve deadlines for project ID: " + projectId, e);
        }
    }

    public List<Deadline> findUpcomingForStudent(int studentId) {
        String sql = "SELECT DISTINCT d.*, p.title AS project_title, u.name AS creator_name " +
                     "FROM deadlines d " +
                     "JOIN projects p ON d.project_id = p.id " +
                     "JOIN users u ON d.created_by = u.id " +
                     "LEFT JOIN team_members tm ON p.id = tm.project_id " +
                     "WHERE d.due_date >= CURRENT_DATE AND (p.leader_id = ? OR tm.user_id = ?) " +
                     "ORDER BY d.due_date ASC LIMIT 10";
        List<Deadline> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToDeadline(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve upcoming deadlines for student ID: " + studentId, e);
        }
    }

    public List<Deadline> findUpcomingForFaculty(int facultyId) {
        String sql = "SELECT DISTINCT d.*, p.title AS project_title, u.name AS creator_name " +
                     "FROM deadlines d " +
                     "LEFT JOIN projects p ON d.project_id = p.id " +
                     "JOIN users u ON d.created_by = u.id " +
                     "WHERE (d.project_id IS NULL OR p.faculty_id = ?) " +
                     "ORDER BY d.due_date ASC LIMIT 20";
        List<Deadline> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToDeadline(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve upcoming deadlines for faculty ID: " + facultyId, e);
        }
    }

    public List<Deadline> findAll() {
        String sql = "SELECT d.*, p.title AS project_title, u.name AS creator_name " +
                     "FROM deadlines d " +
                     "LEFT JOIN projects p ON d.project_id = p.id " +
                     "JOIN users u ON d.created_by = u.id " +
                     "ORDER BY d.due_date ASC";
        List<Deadline> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToDeadline(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve all deadlines", e);
        }
    }

    public int create(Deadline deadline) {
        String sql = "INSERT INTO deadlines (project_id, title, due_date, created_by, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (deadline.getProjectId() != null) {
                ps.setInt(1, deadline.getProjectId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, deadline.getTitle());
            ps.setDate(3, Date.valueOf(deadline.getDueDate()));
            ps.setInt(4, deadline.getCreatedBy());
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new AppException("Creating deadline failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    deadline.setId(generatedKeys.getInt(1));
                    return deadline.getId();
                } else {
                    throw new AppException("Creating deadline failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            throw new AppException("Failed to create deadline: " + deadline.getTitle(), e);
        }
    }

    public void update(Deadline deadline) {
        String sql = "UPDATE deadlines SET title = ?, due_date = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, deadline.getTitle());
            ps.setDate(2, Date.valueOf(deadline.getDueDate()));
            ps.setInt(3, deadline.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update deadline ID: " + deadline.getId(), e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM deadlines WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to delete deadline ID: " + id, e);
        }
    }

    private Deadline mapRowToDeadline(ResultSet rs) throws SQLException {
        Deadline d = new Deadline();
        d.setId(rs.getInt("id"));
        int pId = rs.getInt("project_id");
        d.setProjectId(rs.wasNull() ? null : pId);
        d.setTitle(rs.getString("title"));
        Date dt = rs.getDate("due_date");
        if (dt != null) d.setDueDate(dt.toLocalDate());
        d.setCreatedBy(rs.getInt("created_by"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) d.setCreatedAt(ts.toLocalDateTime());

        d.setProjectTitle(rs.getString("project_title"));
        d.setCreatorName(rs.getString("creator_name"));
        return d;
    }
}
