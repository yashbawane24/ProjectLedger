package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.GitHubCommit;
import com.projectledger.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Data Access Object for synchronized GitHub commit activity.
 */
public class GitHubActivityDao {

    public List<GitHubCommit> findByProjectId(int projectId) {
        String sql = "SELECT * FROM github_activity WHERE project_id = ? ORDER BY committed_at DESC";
        List<GitHubCommit> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToCommit(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve GitHub commits for project ID: " + projectId, e);
        }
    }

    public void upsertCommits(int projectId, List<GitHubCommit> commits) {
        if (commits == null || commits.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO github_activity (project_id, sha, author_login, author_name, message, committed_at, html_url) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "author_login = VALUES(author_login), " +
                     "author_name = VALUES(author_name), " +
                     "message = VALUES(message), " +
                     "committed_at = VALUES(committed_at), " +
                     "html_url = VALUES(html_url)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            for (GitHubCommit commit : commits) {
                ps.setInt(1, projectId);
                ps.setString(2, commit.getSha());
                ps.setString(3, commit.getAuthorLogin());
                ps.setString(4, commit.getAuthorName());
                ps.setString(5, commit.getMessage());
                ps.setTimestamp(6, Timestamp.valueOf(commit.getCommittedAt()));
                ps.setString(7, commit.getHtmlUrl());
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            throw new AppException("Failed to batch upsert GitHub commits for project ID: " + projectId, e);
        }
    }

    public Optional<LocalDateTime> findLastCommitDate(int projectId) {
        String sql = "SELECT MAX(committed_at) FROM github_activity WHERE project_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp ts = rs.getTimestamp(1);
                    if (ts != null) {
                        return Optional.of(ts.toLocalDateTime());
                    }
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve last commit date for project ID: " + projectId, e);
        }
    }

    public int countCommitsByAuthor(int projectId, String githubUsername) {
        if (githubUsername == null || githubUsername.isBlank()) {
            return 0;
        }
        String sql = "SELECT COUNT(*) FROM github_activity WHERE project_id = ? AND LOWER(author_login) = LOWER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setString(2, githubUsername.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        } catch (SQLException e) {
            throw new AppException("Failed to count commits for author: " + githubUsername, e);
        }
    }

    public Optional<LocalDateTime> findLastCommitDateByAuthor(int projectId, String githubUsername) {
        if (githubUsername == null || githubUsername.isBlank()) {
            return Optional.empty();
        }
        String sql = "SELECT MAX(committed_at) FROM github_activity WHERE project_id = ? AND LOWER(author_login) = LOWER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setString(2, githubUsername.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Timestamp ts = rs.getTimestamp(1);
                    if (ts != null) {
                        return Optional.of(ts.toLocalDateTime());
                    }
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve author's last commit date: " + githubUsername, e);
        }
    }

    /**
     * Retrieves daily commit counts for the last 30 days.
     * Returns a map of Date -> CommitCount for all 30 days up to today.
     */
    public Map<LocalDate, Integer> getDailyCommitCountsLast30Days(int projectId) {
        LocalDate today = LocalDate.now();
        LocalDate startDate = today.minusDays(29);
        Map<LocalDate, Integer> counts = new LinkedHashMap<>();
        for (int i = 0; i < 30; i++) {
            counts.put(startDate.plusDays(i), 0);
        }

        String sql = "SELECT DATE(committed_at) AS c_date, COUNT(*) AS c_count " +
                     "FROM github_activity " +
                     "WHERE project_id = ? AND committed_at >= ? " +
                     "GROUP BY DATE(committed_at)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setTimestamp(2, Timestamp.valueOf(startDate.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocalDate date = rs.getDate("c_date").toLocalDate();
                    int count = rs.getInt("c_count");
                    counts.put(date, count);
                }
            }
            return counts;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve 30-day commit activity for project ID: " + projectId, e);
        }
    }

    private GitHubCommit mapRowToCommit(ResultSet rs) throws SQLException {
        GitHubCommit c = new GitHubCommit();
        c.setId(rs.getInt("id"));
        c.setProjectId(rs.getInt("project_id"));
        c.setSha(rs.getString("sha"));
        c.setAuthorLogin(rs.getString("author_login"));
        c.setAuthorName(rs.getString("author_name"));
        c.setMessage(rs.getString("message"));
        Timestamp ts = rs.getTimestamp("committed_at");
        if (ts != null) c.setCommittedAt(ts.toLocalDateTime());
        c.setHtmlUrl(rs.getString("html_url"));
        return c;
    }
}
