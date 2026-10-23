package com.projectledger.servlet;

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
 * Handles student self-registration with server-side validation.
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Student Registration");
        request.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String regNo = request.getParameter("regNo");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String githubUsername = request.getParameter("githubUsername");

        Validator validator = new Validator();
        validator.requireNonBlank("name", name, "Full name is required.");
        validator.requireLength("name", name, 2, 100, "Name must be between 2 and 100 characters.");
        validator.requireNonBlank("email", email, "Email address is required.");
        validator.requireEmail("email", email, "Please provide a valid academic email address.");
        validator.requireNonBlank("regNo", regNo, "Registration number is required (e.g. 24BBS0119).");
        validator.requireNonBlank("password", password, "Password is required.");
        validator.requireLength("password", password, 6, 64, "Password must be at least 6 characters.");

        if (password != null && !password.equals(confirmPassword)) {
            validator.addError("confirmPassword", "Passwords do not match.");
        }

        if (validator.hasErrors()) {
            request.setAttribute("errors", validator.getErrors());
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("regNo", regNo);
            request.setAttribute("githubUsername", githubUsername);
            request.setAttribute("pageTitle", "Student Registration");
            request.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(request, response);
            return;
        }

        try {
            User user = authService.registerStudent(name, email, regNo, password, githubUsername);

            HttpSession session = request.getSession(true);
            request.changeSessionId();

            SessionUser sessionUser = user.toSessionUser();
            session.setAttribute(AuthFilter.SESSION_USER_ATTR, sessionUser);

            Flash.success(request, "Registration successful! Welcome to ProjectLedger.");
            response.sendRedirect(request.getContextPath() + user.getDashboardPath());
        } catch (AppException e) {
            Flash.error(request, e.getMessage());
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("regNo", regNo);
            request.setAttribute("githubUsername", githubUsername);
            request.setAttribute("pageTitle", "Student Registration");
            request.getRequestDispatcher("/WEB-INF/jsp/auth/register.jsp").forward(request, response);
        }
    }
}
