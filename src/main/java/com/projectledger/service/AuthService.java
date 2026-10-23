package com.projectledger.service;

import com.projectledger.dao.UserDao;
import com.projectledger.exception.AppException;
import com.projectledger.model.Student;
import com.projectledger.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Service managing user authentication, registration, password hashing, and profiles.
 */
public class AuthService {
    private final UserDao userDao;

    public AuthService() {
        this.userDao = new UserDao();
    }

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    /**
     * Authenticates a user with email and plain password.
     * Validates BCrypt hash and checks account active status.
     *
     * @param email    login email
     * @param password plain text password
     * @return authenticated User subclass
     */
    public User login(String email, String password) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            throw new AppException("Email and password are required.");
        }

        Optional<User> optionalUser = userDao.findByEmail(email.trim());
        if (optionalUser.isEmpty()) {
            throw new AppException("Invalid email or password.");
        }

        User user = optionalUser.get();
        if (!BCrypt.checkpw(password, user.getPasswordHash())) {
            throw new AppException("Invalid email or password.");
        }

        if (!user.isActive()) {
            throw new AppException("Your account has been deactivated. Please contact the administrator.");
        }

        return user;
    }

    /**
     * Registers a new student account.
     */
    public User registerStudent(String name, String email, String regNo, String password, String githubUsername) {
        String cleanEmail = email != null ? email.trim().toLowerCase() : "";
        if (userDao.findByEmail(cleanEmail).isPresent()) {
            throw new AppException("An account with email '" + cleanEmail + "' already exists.");
        }

        String salt = BCrypt.gensalt(12);
        String passwordHash = BCrypt.hashpw(password, salt);

        String cleanGithub = (githubUsername != null && !githubUsername.isBlank()) ? githubUsername.trim() : null;
        String cleanRegNo = (regNo != null && !regNo.isBlank()) ? regNo.trim() : null;

        Student student = new Student();
        student.setName(name != null ? name.trim() : "");
        student.setEmail(cleanEmail);
        student.setPasswordHash(passwordHash);
        student.setRegNo(cleanRegNo);
        student.setGithubUsername(cleanGithub);
        student.setActive(true);
        student.setCreatedAt(LocalDateTime.now());

        int id = userDao.create(student);
        student.setId(id);
        return student;
    }

    /**
     * Updates editable profile fields.
     */
    public void updateProfile(int userId, String name, String githubUsername) {
        String cleanName = name != null ? name.trim() : "";
        String cleanGithub = (githubUsername != null && !githubUsername.isBlank()) ? githubUsername.trim() : null;
        userDao.updateProfile(userId, cleanName, cleanGithub);
    }

    /**
     * Changes user password after verifying current password.
     */
    public void changePassword(int userId, String currentPassword, String newPassword) {
        User user = userDao.findById(userId)
                .orElseThrow(() -> new AppException("User not found."));

        if (!BCrypt.checkpw(currentPassword, user.getPasswordHash())) {
            throw new AppException("Current password is incorrect.");
        }

        String salt = BCrypt.gensalt(12);
        String newHash = BCrypt.hashpw(newPassword, salt);
        userDao.updatePassword(userId, newHash);
    }

    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }
}
