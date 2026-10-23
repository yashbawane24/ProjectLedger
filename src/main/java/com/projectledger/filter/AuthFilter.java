package com.projectledger.filter;

import com.projectledger.model.SessionUser;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication filter.
 * Protects all routes except public endpoints (/login, /register, /assets/*).
 * Redirects the root path ("/") to the user's role-specific dashboard or /login.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = "/*")
public class AuthFilter implements Filter {
    public static final String SESSION_USER_ATTR = "currentUser";

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.substring(contextPath.length());

        // Static assets are always allowed
        if (path.startsWith("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        SessionUser user = (session != null) ? (SessionUser) session.getAttribute(SESSION_USER_ATTR) : null;

        // Root path "/" redirect: authenticated users to their dashboard, guests to landing page
        if (path.isEmpty() || "/".equals(path)) {
            if (user != null) {
                response.sendRedirect(contextPath + user.getDashboardPath());
            } else {
                response.sendRedirect(contextPath + "/landing");
            }
            return;
        }

        // Public routes
        if ("/landing".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Public authentication routes (login / register)
        boolean isPublicAuth = "/login".equals(path) || "/register".equals(path);
        if (isPublicAuth) {
            if (user != null) {
                response.sendRedirect(contextPath + user.getDashboardPath());
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Error pages are public
        if (path.startsWith("/WEB-INF/jsp/error/") || path.startsWith("/error")) {
            chain.doFilter(request, response);
            return;
        }

        // Protected routes require authenticated user
        if (user == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
