package com.projectledger.servlet;

import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.SessionUser;
import com.projectledger.model.User;
import com.projectledger.service.AuthService;
import com.projectledger.util.Flash;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles user login and session establishment.
 * Implements strict role-based portal security and session fixation defense via session ID regeneration.
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("role");
        request.setAttribute("selectedRole", role != null ? role.trim().toLowerCase() : "student");
        request.setAttribute("pageTitle", "Sign In");
        request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String requestedRole = request.getParameter("role");
        if (requestedRole == null || requestedRole.isBlank()) {
            requestedRole = "student";
        }
        requestedRole = requestedRole.trim().toLowerCase();

        try {
            User user = authService.login(email, password);

            // Strict Role-Based Portal Verification:
            // Ensure the user's role matches the portal they are attempting to log in from.
            String actualRole = user.getRole().name().toLowerCase();
            if (!actualRole.equals(requestedRole)) {
                String portalName = requestedRole.substring(0, 1).toUpperCase() + requestedRole.substring(1);
                String accountRoleName = user.getRole().getDisplayName();
                throw new AppException("Access Denied: This is the " + portalName + " Portal. Your account is registered as "
                        + accountRoleName + ". Please sign in through the " + accountRoleName + " Portal.");
            }

            // Prevent session fixation attack: regenerate session ID
            HttpSession session = request.getSession(true);
            request.changeSessionId();

            SessionUser sessionUser = user.toSessionUser();
            session.setAttribute(AuthFilter.SESSION_USER_ATTR, sessionUser);

            Flash.success(request, "Welcome back, " + user.getName() + ".");
            response.sendRedirect(request.getContextPath() + user.getDashboardPath());
        } catch (AppException e) {
            Flash.error(request, e.getMessage());
            Flash.transferToRequest(request);
            request.setAttribute("email", email);
            request.setAttribute("selectedRole", requestedRole);
            request.setAttribute("pageTitle", "Sign In");
            request.getRequestDispatcher("/WEB-INF/jsp/auth/login.jsp").forward(request, response);
        }
    }
}
