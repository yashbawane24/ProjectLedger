package com.projectledger.util;

import com.projectledger.exception.AppException;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Singleton database connection manager utilizing the HikariCP connection pool.
 * Configured via AppConfig with fallback defaults.
 */
public final class DatabaseConnection {
    private static final Logger LOGGER = Logger.getLogger(DatabaseConnection.class.getName());
    private static volatile HikariDataSource dataSource;
    private static final Object LOCK = new Object();

    private DatabaseConnection() {
        // Private constructor for singleton
    }

    private static HikariDataSource getDataSource() {
        if (dataSource == null) {
            synchronized (LOCK) {
                if (dataSource == null) {
                    try {
                        // Ensure MySQL driver is registered
                        Class.forName("com.mysql.cj.jdbc.Driver");

                        HikariConfig config = new HikariConfig();
                        config.setJdbcUrl(AppConfig.getDbUrl());
                        config.setUsername(AppConfig.getDbUser());
                        config.setPassword(AppConfig.getDbPassword());

                        config.setMaximumPoolSize(AppConfig.getInt("db.pool.maximumPoolSize", 10));
                        config.setMinimumIdle(AppConfig.getInt("db.pool.minimumIdle", 2));
                        config.setIdleTimeout(AppConfig.getInt("db.pool.idleTimeoutMs", 30000));
                        config.setConnectionTimeout(AppConfig.getInt("db.pool.connectionTimeoutMs", 20000));
                        config.setPoolName("ProjectLedger-HikariPool");

                        // Optimizations for MySQL
                        config.addDataSourceProperty("cachePrepStmts", "true");
                        config.addDataSourceProperty("prepStmtCacheSize", "250");
                        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
                        config.addDataSourceProperty("useServerPrepStmts", "true");

                        dataSource = new HikariDataSource(config);
                        LOGGER.info("HikariCP connection pool initialized successfully.");
                    } catch (ClassNotFoundException e) {
                        LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
                        throw new AppException("MySQL JDBC driver could not be loaded", e);
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Failed to initialize HikariCP connection pool", e);
                        throw new AppException("Could not initialize database connection pool: " + e.getMessage(), e);
                    }
                }
            }
        }
        return dataSource;
    }

    /**
     * Obtains a Connection from the HikariCP pool.
     * Callers must close the connection using try-with-resources.
     *
     * @return active java.sql.Connection
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    /**
     * Closes the connection pool on application shutdown.
     */
    public static void shutdown() {
        synchronized (LOCK) {
            if (dataSource != null && !dataSource.isClosed()) {
                dataSource.close();
                dataSource = null;
                LOGGER.info("HikariCP connection pool shut down.");
            }
        }
    }
}
