package com.projectledger.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.logging.Logger;

/**
 * Application lifecycle listener to cleanly release database resources on shutdown.
 */
@WebListener
public class AppContextListener implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("ProjectLedger web application initialized. Pre-warming database connection pool...");
        try (java.sql.Connection conn = DatabaseConnection.getConnection()) {
            LOGGER.info("Database connection pool warmed up successfully.");
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.WARNING, "Database pool pre-warm encountered: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("ProjectLedger web application shutting down. Releasing database pool...");
        DatabaseConnection.shutdown();
    }
}
