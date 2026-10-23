package com.projectledger.filter;

import com.projectledger.model.Role;
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
 * Role-based authorization filter.
 * Restricts access to role-scoped paths:
 *   /student/* -> requires STUDENT role
 *   /faculty/* -> requires FACULTY role
 *   /admin/*   -> requires ADMIN role
 */
@WebFilter(filterName = "RoleFilter", urlPatterns = {"/student/*", "/faculty/*", "/admin/*"})
public class RoleFilter implements Filter {

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

        HttpSession session = request.getSession(false);
        SessionUser user = (session != null) ? (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR) : null;

        if (user == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (path.startsWith("/student/") && user.getRole() != Role.STUDENT) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Student access required.");
            return;
        }

        if (path.startsWith("/faculty/") && user.getRole() != Role.FACULTY) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Faculty access required.");
            return;
        }

        if (path.startsWith("/admin/") && user.getRole() != Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
