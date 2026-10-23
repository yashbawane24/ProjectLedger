package com.projectledger.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Application configuration manager.
 * Reads configurations from app.properties on the classpath and allows
 * environment variables (e.g. DB_URL, DB_USER, DB_PASSWORD, GITHUB_TOKEN)
 * to override property values.
 */
public final class AppConfig {
    private static final Logger LOGGER = Logger.getLogger(AppConfig.class.getName());
    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream in = AppConfig.class.getClassLoader().getResourceAsStream("app.properties")) {
            if (in != null) {
                PROPERTIES.load(in);
            } else {
                LOGGER.warning("app.properties not found on classpath; relying solely on environment variables or defaults.");
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Failed to read app.properties", e);
        }
    }

    private AppConfig() {
        // Private constructor for utility class
    }

    public static String get(String key, String defaultValue) {
        String envKey = key.toUpperCase().replace('.', '_');
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }
        String propValue = PROPERTIES.getProperty(key);
        if (propValue != null && !propValue.isBlank()) {
            return propValue.trim();
        }
        return defaultValue;
    }

    public static String get(String key) {
        return get(key, null);
    }

    public static int getInt(String key, int defaultValue) {
        String val = get(key, null);
        if (val == null || val.isBlank()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static String getDbUrl() {
        return get("db.url", "jdbc:mysql://localhost:3306/projectledger?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=utf8");
    }

    public static String getDbUser() {
        return get("db.user", "root");
    }

    public static String getDbPassword() {
        return get("db.password", "");
    }

    public static String getGitHubToken() {
        return get("github.token", "");
    }
}
