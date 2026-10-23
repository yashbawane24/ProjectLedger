package com.projectledger.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.Serializable;

/**
 * Flash message manager supporting Post/Redirect/Get workflows.
 * Stores ephemeral feedback in HTTP session and transfers to request attributes on next render.
 */
public final class Flash implements Serializable {
    private static final long serialVersionUID = 1L;
    private static final String FLASH_SESSION_KEY = "_PL_FLASH_MESSAGE";

    private final String type; // "success", "error", "info"
    private final String message;

    public Flash(String type, String message) {
        this.type = type;
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public String getMessage() {
        return message;
    }

    public static void success(HttpServletRequest request, String message) {
        set(request, "success", message);
    }

    public static void error(HttpServletRequest request, String message) {
        set(request, "error", message);
    }

    public static void info(HttpServletRequest request, String message) {
        set(request, "info", message);
    }

    private static void set(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession(true);
        session.setAttribute(FLASH_SESSION_KEY, new Flash(type, message));
    }

    /**
     * Consumes the flash message from session and places it in request scope as "flash".
     */
    public static void transferToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object obj = session.getAttribute(FLASH_SESSION_KEY);
            if (obj instanceof Flash flash) {
                request.setAttribute("flash", flash);
                session.removeAttribute(FLASH_SESSION_KEY);
            }
        }
    }
}
