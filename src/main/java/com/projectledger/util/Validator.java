package com.projectledger.util;

import java.time.LocalDate;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Server-side validation helper.
 * Accumulates field-level validation errors and validates domain formats.
 */
public class Validator {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern GITHUB_REPO_PATTERN = Pattern.compile("^(?:https?:\\/\\/github\\.com\\/)?([A-Za-z0-9_.-]+)\\/([A-Za-z0-9_.-]+?)(?:\\.git)?$");
    private static final Pattern URL_PATTERN = Pattern.compile("^(https?:\\/\\/)[^\\s/$.?#].[^\\s]*$", Pattern.CASE_INSENSITIVE);

    private final Map<String, String> errors = new LinkedHashMap<>();

    public Validator() {
    }

    public Validator requireNonBlank(String field, String value, String message) {
        if (value == null || value.trim().isEmpty()) {
            addError(field, message);
        }
        return this;
    }

    public Validator requireLength(String field, String value, int min, int max, String message) {
        if (value != null && !value.trim().isEmpty()) {
            int len = value.trim().length();
            if (len < min || len > max) {
                addError(field, message);
            }
        }
        return this;
    }

    public Validator requireEmail(String field, String value, String message) {
        if (value != null && !value.trim().isEmpty()) {
            if (!EMAIL_PATTERN.matcher(value.trim()).matches()) {
                addError(field, message);
            }
        }
        return this;
    }

    public Validator requireDateOrder(String field, LocalDate start, LocalDate end, String message) {
        if (start != null && end != null && end.isBefore(start)) {
            addError(field, message);
        }
        return this;
    }

    public Validator requireUrl(String field, String value, String message) {
        if (value != null && !value.trim().isEmpty()) {
            if (!URL_PATTERN.matcher(value.trim()).matches()) {
                addError(field, message);
            }
        }
        return this;
    }

    public Validator requireGitHubRepo(String field, String value, String message) {
        if (value != null && !value.trim().isEmpty()) {
            if (!GITHUB_REPO_PATTERN.matcher(value.trim()).matches()) {
                addError(field, message);
            }
        }
        return this;
    }

    public void addError(String field, String message) {
        errors.putIfAbsent(field, message);
    }

    public boolean hasErrors() {
        return !errors.isEmpty();
    }

    public boolean isValid() {
        return errors.isEmpty();
    }

    public Map<String, String> getErrors() {
        return Collections.unmodifiableMap(errors);
    }

    /**
     * Parses a GitHub URL or "owner/repo" into a 2-element String array [owner, repo].
     * Returns null if string does not match standard GitHub pattern.
     */
    public static String[] parseGitHubRepo(String input) {
        if (input == null || input.isBlank()) {
            return null;
        }
        Matcher matcher = GITHUB_REPO_PATTERN.matcher(input.trim());
        if (matcher.matches()) {
            return new String[]{matcher.group(1), matcher.group(2)};
        }
        return null;
    }

    public static boolean isLocalhostUrl(String url) {
        if (url == null || url.isBlank()) {
            return false;
        }
        String lower = url.toLowerCase();
        return lower.contains("localhost") || lower.contains("127.0.0.1") || lower.contains("::1");
    }
}
