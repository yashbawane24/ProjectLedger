package com.projectledger.dao;

import com.projectledger.exception.AppException;
import com.projectledger.model.Admin;
import com.projectledger.model.Faculty;
import com.projectledger.model.Role;
import com.projectledger.model.Student;
import com.projectledger.model.User;
import com.projectledger.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object for User entities.
 * Returns polymorphic User subclasses (Student, Faculty, Admin) based on database role.
 */
public class UserDao {

    public Optional<User> findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToUser(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve user with ID: " + id, e);
        }
    }

    public Optional<User> findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email != null ? email.trim() : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRowToUser(rs));
                }
            }
            return Optional.empty();
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve user with email: " + email, e);
        }
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY role, name";
        List<User> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToUser(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to list all users", e);
        }
    }

    public List<User> findByRole(Role role) {
        String sql = "SELECT * FROM users WHERE role = ? AND active = true ORDER BY name";
        List<User> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToUser(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to list users with role: " + role, e);
        }
    }

    public List<Student> searchStudents(String query) {
        String sql = "SELECT * FROM users WHERE role = 'STUDENT' AND active = true AND (" +
                     "LOWER(name) LIKE ? OR LOWER(email) LIKE ? OR LOWER(reg_no) LIKE ?) ORDER BY name LIMIT 10";
        List<Student> list = new ArrayList<>();
        String pattern = "%" + (query != null ? query.trim().toLowerCase() : "") + "%";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = mapRowToUser(rs);
                    if (u instanceof Student student) {
                        list.add(student);
                    }
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to search students with query: " + query, e);
        }
    }

    public int create(User user) {
        String sql = "INSERT INTO users (name, email, password_hash, role, github_username, reg_no, department, active, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail().toLowerCase().trim());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name());
            ps.setString(5, user.getGithubUsername());
            ps.setString(6, user.getRegNo());
            ps.setString(7, user.getDepartment());
            ps.setBoolean(8, user.isActive());
            ps.setTimestamp(9, Timestamp.valueOf(user.getCreatedAt() != null ? user.getCreatedAt() : LocalDateTime.now()));

            int affected = ps.executeUpdate();
            if (affected == 0) {
                throw new AppException("Creating user failed, no rows affected.");
            }
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                    return user.getId();
                } else {
                    throw new AppException("Creating user failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            throw new AppException("Failed to create user: " + user.getEmail(), e);
        }
    }

    public void updateProfile(int userId, String name, String githubUsername) {
        String sql = "UPDATE users SET name = ?, github_username = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, githubUsername);
            ps.setInt(3, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update profile for user ID: " + userId, e);
        }
    }

    public void updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to update password for user ID: " + userId, e);
        }
    }

    public void toggleActive(int userId, boolean active) {
        String sql = "UPDATE users SET active = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new AppException("Failed to toggle status for user ID: " + userId, e);
        }
    }

    public int countUsersByRole(Role role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role.name());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return 0;
        } catch (SQLException e) {
            throw new AppException("Failed to count users with role: " + role, e);
        }
    }

    public List<User> findRecentSignups(int limit) {
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
        List<User> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToUser(rs));
                }
            }
            return list;
        } catch (SQLException e) {
            throw new AppException("Failed to retrieve recent signups", e);
        }
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String passwordHash = rs.getString("password_hash");
        Role role = Role.valueOf(rs.getString("role"));
        String githubUsername = rs.getString("github_username");
        String regNo = rs.getString("reg_no");
        String department = rs.getString("department");
        boolean active = rs.getBoolean("active");
        Timestamp ts = rs.getTimestamp("created_at");
        LocalDateTime createdAt = (ts != null) ? ts.toLocalDateTime() : LocalDateTime.now();

        // Polymorphic instantiations
        return switch (role) {
            case STUDENT -> new Student(id, name, email, passwordHash, githubUsername, regNo, department, active, createdAt);
            case FACULTY -> new Faculty(id, name, email, passwordHash, githubUsername, department, active, createdAt);
            case ADMIN -> new Admin(id, name, email, passwordHash, active, createdAt);
        };
    }
}
