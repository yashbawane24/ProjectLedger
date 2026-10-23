package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.TeamMember;
import com.projectledger.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for Project Team Members.
 */
public class TeamMemberDao {

    public List<TeamMember> findByProjectId(int projectId) {
        String sql = "SELECT tm.*, u.name AS user_name, u.email AS user_email, u.reg_no AS user_reg_no, u.github_username AS user_github " +
                     "FROM team_members tm " +
                     "JOIN users u ON tm.user_id = u.id " +
                     "WHERE tm.project_id = ? " +
                     "ORDER BY tm.joined_at ASC";
        List<TeamMember> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTeamMember(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve team members for project ID: " + projectId, e);
        }
    }

    public Optional<TeamMember> findByProjectAndUser(int projectId, int userId) {
        String sql = "SELECT tm.*, u.name AS user_name, u.email AS user_email, u.reg_no AS user_reg_no, u.github_username AS user_github " +
                     "FROM team_members tm " +
                     "JOIN users u ON tm.user_id = u.id " +
                     "WHERE tm.project_id = ? AND tm.user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToTeamMember(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to check team membership for project ID: " + projectId + " and user ID: " + userId, e);
        }
    }

    public void addMember(int projectId, int userId, String responsibility, Connection conn) throws SQLException {
        String sql = "INSERT INTO team_members (project_id, user_id, responsibility, joined_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, userId);
            ps.setString(3, (responsibility != null && !responsibility.isBlank()) ? responsibility.trim() : "Developer");
            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            ps.executeUpdate();
        }
    }

    public void addMember(int projectId, int userId, String responsibility) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            addMember(projectId, userId, responsibility, conn);
        } catch (SQLException e) {
            throw new AppException("Failed to add team member to project ID: " + projectId, e);
        }
    }

    public void removeMember(int projectId, int userId) {
        String sql = "DELETE FROM team_members WHERE project_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to remove member from project ID: " + projectId, e);
        }
    }

    public int countByProjectId(int projectId) {
        String sql = "SELECT COUNT(*) FROM team_members WHERE project_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        } catch (SQLException e) {
            throw new AppException("Failed to count team members for project ID: " + projectId, e);
        }
    }

    private TeamMember mapRowToTeamMember(ResultSet rs) throws SQLException {
        TeamMember tm = new TeamMember();
        tm.setId(rs.getInt("id"));
        tm.setProjectId(rs.getInt("project_id"));
        tm.setUserId(rs.getInt("user_id"));
        tm.setResponsibility(rs.getString("responsibility"));
        Timestamp ts = rs.getTimestamp("joined_at");
        if (ts != null) tm.setJoinedAt(ts.toLocalDateTime());
        tm.setUserName(rs.getString("user_name"));
        tm.setUserEmail(rs.getString("user_email"));
        tm.setUserRegNo(rs.getString("user_reg_no"));
        tm.setUserGithub(rs.getString("user_github"));
        return tm;
    }
}
