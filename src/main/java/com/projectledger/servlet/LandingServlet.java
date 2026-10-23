package com.projectledger.servlet;

import com.projectledger.filter.AuthFilter;
import com.projectledger.model.SessionUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller for the public product landing page.
 * Highlights platform capabilities, workflow overview, and provides
 * dedicated role-based entry gates for Student, Faculty, and Admin.
 */
@WebServlet(name = "LandingServlet", urlPatterns = {"/landing"})
public class LandingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (session != null) ? (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR) : null;

        request.setAttribute("currentUser", user);
        request.setAttribute("pageTitle", "ProjectLedger — Academic Project Development & Monitoring Platform");
        request.getRequestDispatcher("/WEB-INF/jsp/landing.jsp").forward(request, response);
    }
}
