package com.projectledger.servlet;

import com.projectledger.dao.UserDao;
import com.projectledger.exception.AppException;
import com.projectledger.model.Admin;
import com.projectledger.model.Faculty;
import com.projectledger.model.Role;
import com.projectledger.model.User;
import com.projectledger.service.AuthService;
import com.projectledger.util.Flash;
import com.projectledger.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Controller for user account administration.
 * Enables account search, provisioning faculty/admin accounts,
 * toggling active status, and password resets with temporary passwords.
 */
@WebServlet(name = "AdminUsersServlet", urlPatterns = {
        "/admin/users",
        "/admin/users/save",
        "/admin/users/toggle",
        "/admin/users/reset-password"
})
public class AdminUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String TEMP_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789@#$";
    private static final SecureRandom RANDOM = new SecureRandom();

    private final transient UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        List<User> users;
        if (query != null && !query.isBlank()) {
            String lower = query.trim().toLowerCase();
            users = userDao.findAll().stream()
                    .filter(u -> u.getName().toLowerCase().contains(lower) ||
                                 u.getEmail().toLowerCase().contains(lower) ||
                                 (u.getRegNo() != null && u.getRegNo().toLowerCase().contains(lower)))
                    .toList();
        } else {
            users = userDao.findAll();
        }

        request.setAttribute("users", users);
        request.setAttribute("query", query);
        request.setAttribute("pageTitle", "User Account Management");
        request.setAttribute("activeNav", "users");

        request.getRequestDispatcher("/WEB-INF/jsp/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin/users/toggle".equals(path)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean active = "true".equalsIgnoreCase(request.getParameter("active"));
            userDao.toggleActive(userId, !active);
            Flash.success(request, "User status updated.");

        } else if ("/admin/users/reset-password".equals(path)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String tempPassword = generateTempPassword(10);
            String hash = AuthService.hashPassword(tempPassword);
            userDao.updatePassword(userId, hash);
            Flash.info(request, "Password reset. Temporary password (shown once): " + tempPassword);

        } else if ("/admin/users/save".equals(path)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String roleStr = request.getParameter("role");
            String department = request.getParameter("department");
            String initialPassword = request.getParameter("password");

            Validator validator = new Validator();
            validator.requireNonBlank("name", name, "Name is required.");
            validator.requireNonBlank("email", email, "Email is required.");
            validator.requireEmail("email", email, "Valid academic email format required.");
            validator.requireNonBlank("password", initialPassword, "Initial password is required.");
            validator.requireLength("password", initialPassword, 6, 64, "Password must be at least 6 characters.");

            if (validator.hasErrors()) {
                Flash.error(request, validator.getErrors().values().iterator().next());
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            try {
                Role role = Role.valueOf(roleStr);
                String passwordHash = AuthService.hashPassword(initialPassword);

                User newUser;
                if (role == Role.FACULTY) {
                    newUser = new Faculty(0, name.trim(), email.trim().toLowerCase(), passwordHash, null, department, true, LocalDateTime.now());
                } else {
                    newUser = new Admin(0, name.trim(), email.trim().toLowerCase(), passwordHash, true, LocalDateTime.now());
                }

                userDao.create(newUser);
                Flash.success(request, role.getDisplayName() + " account created for " + name + ".");
            } catch (AppException e) {
                Flash.error(request, e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private String generateTempPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(TEMP_CHARS.charAt(RANDOM.nextInt(TEMP_CHARS.length())));
        }
        return sb.toString();
    }
}
