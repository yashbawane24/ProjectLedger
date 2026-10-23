package com.projectledger.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.Locale;

/**
 * Date and time formatting and calculation utilities for ProjectLedger.
 * Adheres to the academic ledger display style: "19 Oct 2026" and relative time representations.
 */
public final class DateUtil {
    public static final DateTimeFormatter DISPLAY_DATE = DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.ENGLISH);
    public static final DateTimeFormatter INPUT_DATE = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.ENGLISH);
    public static final DateTimeFormatter DISPLAY_DATETIME = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm", Locale.ENGLISH);

    private DateUtil() {
    }

    /**
     * Formats a LocalDate into academic style: "19 Oct 2026".
     */
    public static String format(LocalDate date) {
        if (date == null) {
            return "—";
        }
        return DISPLAY_DATE.format(date);
    }

    /**
     * Formats a LocalDateTime into academic style: "19 Oct 2026, 14:30".
     */
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "—";
        }
        return DISPLAY_DATETIME.format(dateTime);
    }

    /**
     * Parses an ISO date string "yyyy-MM-dd" into a LocalDate.
     */
    public static LocalDate parseDate(String text) {
        if (text == null || text.isBlank()) {
            return null;
        }
        try {
            return LocalDate.parse(text.trim(), INPUT_DATE);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    /**
     * Returns human-readable relative time representation, e.g. "today", "in 3 days", "2 days overdue".
     */
    public static String relativeDueDate(LocalDate dueDate) {
        if (dueDate == null) {
            return "";
        }
        LocalDate today = LocalDate.now();
        long days = ChronoUnit.DAYS.between(today, dueDate);

        if (days == 0) {
            return "due today";
        } else if (days == 1) {
            return "due tomorrow";
        } else if (days > 1) {
            return "in " + days + " days";
        } else if (days == -1) {
            return "1 day overdue";
        } else {
            return Math.abs(days) + " days overdue";
        }
    }

    /**
     * Returns relative time for past activities, e.g. "just now", "2 hours ago", "yesterday", "3 days ago".
     */
    public static String relativeTimeAgo(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "—";
        }
        LocalDateTime now = LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(dateTime, now);
        if (minutes < 1) {
            return "just now";
        }
        if (minutes < 60) {
            return minutes + (minutes == 1 ? " min ago" : " mins ago");
        }
        long hours = ChronoUnit.HOURS.between(dateTime, now);
        if (hours < 24) {
            return hours + (hours == 1 ? " hour ago" : " hours ago");
        }
        long days = ChronoUnit.DAYS.between(dateTime.toLocalDate(), now.toLocalDate());
        if (days == 1) {
            return "yesterday";
        }
        if (days < 30) {
            return days + " days ago";
        }
        return format(dateTime.toLocalDate());
    }
}
