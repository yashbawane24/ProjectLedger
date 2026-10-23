package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.Project;
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
 * Data Access Object for Project entities.
 */
public class ProjectDao {

    public Optional<Project> findById(int id) {
        String sql = "SELECT p.*, l.name AS leader_name, l.email AS leader_email, f.name AS faculty_name " +
                     "FROM projects p " +
                     "JOIN users l ON p.leader_id = l.id " +
                     "LEFT JOIN users f ON p.faculty_id = f.id " +
                     "WHERE p.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToProject(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve project with ID: " + id, e);
        }
    }

    public List<Project> findByStudentId(int studentId) {
        String sql = "SELECT DISTINCT p.*, l.name AS leader_name, l.email AS leader_email, f.name AS faculty_name " +
                     "FROM projects p " +
                     "JOIN users l ON p.leader_id = l.id " +
                     "LEFT JOIN users f ON p.faculty_id = f.id " +
                     "LEFT JOIN team_members tm ON p.id = tm.project_id " +
                     "WHERE p.leader_id = ? OR tm.user_id = ? " +
                     "ORDER BY p.updated_at DESC";
        List<Project> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToProject(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve projects for student ID: " + studentId, e);
        }
    }

    public List<Project> findByFacultyId(int facultyId) {
        String sql = "SELECT p.*, l.name AS leader_name, l.email AS leader_email, f.name AS faculty_name " +
                     "FROM projects p " +
                     "JOIN users l ON p.leader_id = l.id " +
                     "LEFT JOIN users f ON p.faculty_id = f.id " +
                     "WHERE p.faculty_id = ? " +
                     "ORDER BY p.updated_at DESC";
        List<Project> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facultyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToProject(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve projects for faculty ID: " + facultyId, e);
        }
    }

    public List<Project> findAll() {
        String sql = "SELECT p.*, l.name AS leader_name, l.email AS leader_email, f.name AS faculty_name " +
                     "FROM projects p " +
                     "JOIN users l ON p.leader_id = l.id " +
                     "LEFT JOIN users f ON p.faculty_id = f.id " +
                     "ORDER BY p.created_at DESC";
        List<Project> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToProject(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve all projects", e);
        }
    }

    public int create(Project project, Connection conn) throws SQLException {
        String sql = "INSERT INTO projects (title, description, leader_id, faculty_id, start_date, end_date, " +
                     "repo_owner, repo_name, demo_url, last_synced_at, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, project.getTitle());
            ps.setString(2, project.getDescription());
            ps.setInt(3, project.getLeaderId());
            if (project.getFacultyId() != null) {
                ps.setInt(4, project.getFacultyId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setDate(5, Date.valueOf(project.getStartDate()));
            ps.setDate(6, Date.valueOf(project.getEndDate()));
            ps.setString(7, project.getRepoOwner());
            ps.setString(8, project.getRepoName());
            ps.setString(9, project.getDemoUrl());
            if (project.getLastSyncedAt() != null) {
                ps.setTimestamp(10, Timestamp.valueOf(project.getLastSyncedAt()));
            } else {
                ps.setNull(10, Types.TIMESTAMP);
            }
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            ps.setTimestamp(11, now);
            ps.setTimestamp(12, now);

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new SQLException("Creating project failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    project.setId(generatedKeys.getInt(1));
                    return project.getId();
                } else {
                    throw new SQLException("Creating project failed, no ID obtained.");
                }
            }
        }
    }

    public void update(Project project) {
        String sql = "UPDATE projects SET title = ?, description = ?, faculty_id = ?, start_date = ?, end_date = ?, " +
                     "repo_owner = ?, repo_name = ?, demo_url = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, project.getTitle());
            ps.setString(2, project.getDescription());
            if (project.getFacultyId() != null) {
                ps.setInt(3, project.getFacultyId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setDate(4, Date.valueOf(project.getStartDate()));
            ps.setDate(5, Date.valueOf(project.getEndDate()));
            ps.setString(6, project.getRepoOwner());
            ps.setString(7, project.getRepoName());
            ps.setString(8, project.getDemoUrl());
            ps.setInt(9, project.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update project ID: " + project.getId(), e);
        }
    }

    public void reassignFaculty(int projectId, Integer facultyId) {
        String sql = "UPDATE projects SET faculty_id = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (facultyId != null) {
                ps.setInt(1, facultyId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, projectId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to reassign faculty for project ID: " + projectId, e);
        }
    }

    public void updateLastSyncedAt(int projectId, LocalDateTime syncedAt) {
        String sql = "UPDATE projects SET last_synced_at = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(syncedAt));
            ps.setInt(2, projectId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update last_synced_at for project ID: " + projectId, e);
        }
    }

    public void delete(int projectId) {
        String sql = "DELETE FROM projects WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to delete project ID: " + projectId, e);
        }
    }

    public int countProjects() {
        String sql = "SELECT COUNT(*) FROM projects";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            throw new AppException("Failed to count projects", e);
        }
    }

    private Project mapRowToProject(ResultSet rs) throws SQLException {
        Project p = new Project();
        p.setId(rs.getInt("id"));
        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));
        p.setLeaderId(rs.getInt("leader_id"));
        int facId = rs.getInt("faculty_id");
        p.setFacultyId(rs.wasNull() ? null : facId);
        Date sDate = rs.getDate("start_date");
        if (sDate != null) p.setStartDate(sDate.toLocalDate());
        Date eDate = rs.getDate("end_date");
        if (eDate != null) p.setEndDate(eDate.toLocalDate());
        p.setRepoOwner(rs.getString("repo_owner"));
        p.setRepoName(rs.getString("repo_name"));
        p.setDemoUrl(rs.getString("demo_url"));
        Timestamp syncTs = rs.getTimestamp("last_synced_at");
        if (syncTs != null) p.setLastSyncedAt(syncTs.toLocalDateTime());
        Timestamp cTs = rs.getTimestamp("created_at");
        if (cTs != null) p.setCreatedAt(cTs.toLocalDateTime());
        Timestamp uTs = rs.getTimestamp("updated_at");
        if (uTs != null) p.setUpdatedAt(uTs.toLocalDateTime());

        p.setLeaderName(rs.getString("leader_name"));
        p.setLeaderEmail(rs.getString("leader_email"));
        p.setFacultyName(rs.getString("faculty_name"));
        return p;
    }
}
