package com.projectledger.servlet;

import com.projectledger.dao.UserDao;
import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.SessionUser;
import com.projectledger.model.User;
import com.projectledger.service.AuthService;
import com.projectledger.util.Flash;
import com.projectledger.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles viewing and editing user profile, GitHub handle, and password changes.
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient AuthService authService = new AuthService();
    private final transient UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser sessionUser = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);

        User user = userDao.findById(sessionUser.getId())
                .orElseThrow(() -> new AppException("User record could not be found."));

        request.setAttribute("user", user);
        request.setAttribute("pageTitle", "Account Profile");
        request.setAttribute("activeNav", "profile");
        request.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser sessionUser = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String action = request.getParameter("action");

        if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");

            Validator validator = new Validator();
            validator.requireNonBlank("currentPassword", currentPassword, "Current password is required.");
            validator.requireNonBlank("newPassword", newPassword, "New password is required.");
            validator.requireLength("newPassword", newPassword, 6, 64, "New password must be at least 6 characters.");

            if (newPassword != null && !newPassword.equals(confirmNewPassword)) {
                validator.addError("confirmNewPassword", "New passwords do not match.");
            }

            if (validator.hasErrors()) {
                request.setAttribute("passwordErrors", validator.getErrors());
                doGet(request, response);
                return;
            }

            try {
                authService.changePassword(sessionUser.getId(), currentPassword, newPassword);
                Flash.success(request, "Password changed successfully.");
                response.sendRedirect(request.getContextPath() + "/profile");
            } catch (AppException e) {
                Flash.error(request, e.getMessage());
                doGet(request, response);
            }
        } else {
            // Update profile
            String name = request.getParameter("name");
            String githubUsername = request.getParameter("githubUsername");

            Validator validator = new Validator();
            validator.requireNonBlank("name", name, "Full name cannot be blank.");
            validator.requireLength("name", name, 2, 100, "Name must be between 2 and 100 characters.");

            if (validator.hasErrors()) {
                request.setAttribute("profileErrors", validator.getErrors());
                doGet(request, response);
                return;
            }

            try {
                authService.updateProfile(sessionUser.getId(), name, githubUsername);

                // Update session
                User updated = userDao.findById(sessionUser.getId()).orElseThrow();
                session.setAttribute(AuthFilter.SESSION_USER_ATTR, updated.toSessionUser());

                Flash.success(request, "Profile details updated.");
                response.sendRedirect(request.getContextPath() + "/profile");
            } catch (AppException e) {
                Flash.error(request, e.getMessage());
                doGet(request, response);
            }
        }
    }
}
