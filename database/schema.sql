-- ProjectLedger Database Schema
-- MySQL 8.x, InnoDB, utf8mb4

CREATE DATABASE IF NOT EXISTS `projectledger` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `projectledger`;

-- 1. Users Table
DROP TABLE IF EXISTS `feedback`;
DROP TABLE IF EXISTS `github_activity`;
DROP TABLE IF EXISTS `tasks`;
DROP TABLE IF EXISTS `milestones`;
DROP TABLE IF EXISTS `team_members`;
DROP TABLE IF EXISTS `deadlines`;
DROP TABLE IF EXISTS `projects`;
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` ENUM('STUDENT', 'FACULTY', 'ADMIN') NOT NULL,
    `github_username` VARCHAR(100) NULL,
    `reg_no` VARCHAR(50) NULL,
    `department` VARCHAR(100) NULL,
    `active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_users_role` (`role`),
    INDEX `idx_users_reg_no` (`reg_no`),
    INDEX `idx_users_github` (`github_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Projects Table
CREATE TABLE `projects` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT NOT NULL,
    `leader_id` INT NOT NULL,
    `faculty_id` INT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `repo_owner` VARCHAR(100) NULL,
    `repo_name` VARCHAR(100) NULL,
    `demo_url` VARCHAR(255) NULL,
    `last_synced_at` DATETIME NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_projects_leader` FOREIGN KEY (`leader_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_projects_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
    INDEX `idx_projects_leader` (`leader_id`),
    INDEX `idx_projects_faculty` (`faculty_id`),
    INDEX `idx_projects_dates` (`start_date`, `end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Team Members Table
CREATE TABLE `team_members` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `responsibility` VARCHAR(255) NOT NULL DEFAULT 'Developer',
    `joined_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_project_user` (`project_id`, `user_id`),
    CONSTRAINT `fk_tm_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_tm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    INDEX `idx_tm_project` (`project_id`),
    INDEX `idx_tm_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Milestones Table
CREATE TABLE `milestones` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_id` INT NOT NULL,
    `title` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,
    `target_date` DATE NOT NULL,
    `completed_at` DATETIME NULL,
    `sort_order` INT NOT NULL DEFAULT 1,
    `review_status` ENUM('PENDING', 'REVIEWED') NOT NULL DEFAULT 'PENDING',
    CONSTRAINT `fk_milestones_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    INDEX `idx_milestones_project` (`project_id`),
    INDEX `idx_milestones_target_date` (`target_date`),
    INDEX `idx_milestones_review` (`review_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Tasks Table
CREATE TABLE `tasks` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_id` INT NOT NULL,
    `milestone_id` INT NULL,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT NULL,
    `assignee_id` INT NULL,
    `priority` ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
    `status` ENUM('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED') NOT NULL DEFAULT 'NOT_STARTED',
    `due_date` DATE NOT NULL,
    `completed_at` DATETIME NULL,
    `created_by` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_tasks_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_tasks_milestone` FOREIGN KEY (`milestone_id`) REFERENCES `milestones` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_tasks_assignee` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_tasks_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    INDEX `idx_tasks_project` (`project_id`),
    INDEX `idx_tasks_milestone` (`milestone_id`),
    INDEX `idx_tasks_assignee` (`assignee_id`),
    INDEX `idx_tasks_status` (`status`),
    INDEX `idx_tasks_due_date` (`due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. GitHub Activity Table
CREATE TABLE `github_activity` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_id` INT NOT NULL,
    `sha` CHAR(40) NOT NULL,
    `author_login` VARCHAR(100) NULL,
    `author_name` VARCHAR(150) NOT NULL,
    `message` TEXT NOT NULL,
    `committed_at` DATETIME NOT NULL,
    `html_url` VARCHAR(255) NOT NULL,
    UNIQUE KEY `uk_project_sha` (`project_id`, `sha`),
    CONSTRAINT `fk_github_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    INDEX `idx_github_project` (`project_id`),
    INDEX `idx_github_author_login` (`author_login`),
    INDEX `idx_github_committed_at` (`committed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Feedback Table
CREATE TABLE `feedback` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_id` INT NOT NULL,
    `faculty_id` INT NOT NULL,
    `milestone_id` INT NULL,
    `comment` TEXT NOT NULL,
    `score` DECIMAL(4, 1) NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_feedback_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_feedback_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_feedback_milestone` FOREIGN KEY (`milestone_id`) REFERENCES `milestones` (`id`) ON DELETE SET NULL,
    INDEX `idx_feedback_project` (`project_id`),
    INDEX `idx_feedback_faculty` (`faculty_id`),
    INDEX `idx_feedback_milestone` (`milestone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Deadlines Table
CREATE TABLE `deadlines` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_id` INT NULL, -- NULL indicates global deadline set by admin for all projects
    `title` VARCHAR(200) NOT NULL,
    `due_date` DATE NOT NULL,
    `created_by` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_deadlines_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_deadlines_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    INDEX `idx_deadlines_project` (`project_id`),
    INDEX `idx_deadlines_due_date` (`due_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
