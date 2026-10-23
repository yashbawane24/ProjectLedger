package com.projectledger.filter;

import com.projectledger.util.Flash;
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
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Cross-Site Request Forgery (CSRF) protection filter.
 * Maintains a cryptographically secure random token per session.
 * Enforces token validation on all state-changing HTTP methods (POST, PUT, DELETE).
 * Also transfers flash messages to request attributes on every request.
 */
@WebFilter(filterName = "CsrfFilter", urlPatterns = "/*")
public class CsrfFilter implements Filter {
    public static final String CSRF_SESSION_ATTR = "_PL_CSRF_TOKEN";
    public static final String CSRF_PARAM_NAME = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Transfer any flash messages from session to request scope
        Flash.transferToRequest(request);

        // Ensure session exists or can generate token
        HttpSession session = request.getSession(true);
        String sessionToken = (String) session.getAttribute(CSRF_SESSION_ATTR);
        if (sessionToken == null) {
            byte[] bytes = new byte[32];
            RANDOM.nextBytes(bytes);
            sessionToken = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            session.setAttribute(CSRF_SESSION_ATTR, sessionToken);
        }

        // Expose token to request attributes for JSPs
        request.setAttribute(CSRF_PARAM_NAME, sessionToken);

        String method = request.getMethod();
        if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method)) {
            String requestToken = request.getParameter(CSRF_PARAM_NAME);
            if (requestToken == null || !sessionToken.equals(requestToken)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
