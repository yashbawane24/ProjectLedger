-- ProjectLedger Demo Seed Data
-- Passwords:
-- Admin: Admin@123
-- Faculty: Faculty@123
-- Students: Student@123

USE `projectledger`;

-- Clear existing data
DELETE FROM `feedback`;
DELETE FROM `github_activity`;
DELETE FROM `tasks`;
DELETE FROM `milestones`;
DELETE FROM `team_members`;
DELETE FROM `deadlines`;
DELETE FROM `projects`;
DELETE FROM `users`;

-- 1. Users
-- Real BCrypt hashes from SeedHasher
-- Admin: $2a$12$H5J4ZDcxV3/eVrPUeA.AsOoTA6gALkpT2NbB8WGj0QpDsGAHlXDzG
-- Faculty: $2a$12$KFm/FvYxm1I9VPAbSH0lh.yOkRC6vpWtLJBB9.FIxYp24gOGEUpSm
-- Student: $2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `github_username`, `reg_no`, `department`, `active`, `created_at`) VALUES
-- Admin
(1, 'Dr. Aris Thorne (Dean)', 'admin@projectledger.edu', '$2a$12$H5J4ZDcxV3/eVrPUeA.AsOoTA6gALkpT2NbB8WGj0QpDsGAHlXDzG', 'ADMIN', 'admin-pl', NULL, 'Academic Affairs', true, '2026-08-01 09:00:00'),

-- Faculty
(2, 'Dr. Ramesh Sharma', 'faculty1@projectledger.edu', '$2a$12$KFm/FvYxm1I9VPAbSH0lh.yOkRC6vpWtLJBB9.FIxYp24gOGEUpSm', 'FACULTY', 'ramesh-sharma', NULL, 'Computer Science & Engineering', true, '2026-08-05 10:00:00'),
(3, 'Dr. Anita Roy', 'faculty2@projectledger.edu', '$2a$12$KFm/FvYxm1I9VPAbSH0lh.yOkRC6vpWtLJBB9.FIxYp24gOGEUpSm', 'FACULTY', 'anita-roy', NULL, 'Software Systems & AI', true, '2026-08-05 10:30:00'),

-- Students (Team 15 & Cohort)
(4, 'Bawane Yash Sunil', 'student1@projectledger.edu', '$2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq', 'STUDENT', 'yash-bawane', '24BBS0119', 'Computer Science', true, '2026-08-10 11:00:00'),
(5, 'Gulam Moinuddin', 'student2@projectledger.edu', '$2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq', 'STUDENT', 'gulam-moin', '24BBS0135', 'Computer Science', true, '2026-08-10 11:15:00'),
(6, 'Kartik Jindal', 'student3@projectledger.edu', '$2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq', 'STUDENT', 'kartik-jindal', '24BBS0143', 'Computer Science', true, '2026-08-10 11:30:00'),
(7, 'Priya Nair', 'student4@projectledger.edu', '$2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq', 'STUDENT', 'priya-nair', '24BBS0150', 'Computer Science', true, '2026-08-10 12:00:00'),
(8, 'Rohan Verma', 'student5@projectledger.edu', '$2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq', 'STUDENT', 'rohan-verma', '24BBS0155', 'Computer Science', true, '2026-08-10 12:15:00'),
(9, 'Siddharth Rao', 'student6@projectledger.edu', '$2a$12$cypcDnujwfbQwEsOzSDI2uEs7ZBuBm5PsLueRyEsi3IoORCuX4XKq', 'STUDENT', 'siddharth-rao', '24BBS0160', 'Computer Science', true, '2026-08-10 12:30:00');

-- 2. Projects
-- Current date context: ~2026-10-19
INSERT INTO `projects` (`id`, `title`, `description`, `leader_id`, `faculty_id`, `start_date`, `end_date`, `repo_owner`, `repo_name`, `demo_url`, `last_synced_at`, `created_at`, `updated_at`) VALUES
-- Project 1: ON TRACK
(1, 'Automated Campus Energy Grid Monitor',
 'Real-time telemetry aggregation and power usage forecasting across campus facilities using IoT sensor arrays.',
 4, 2, '2026-09-01', '2026-12-15', 'spring-projects', 'spring-petclinic', 'https://energy-grid.demo.projectledger.edu', '2026-10-19 18:30:00', '2026-09-01 10:00:00', '2026-10-19 18:30:00'),

-- Project 2: AT RISK
(2, 'Distributed Blockchain Ledger for Academic Transcripts',
 'Cryptographically verifiable, tamper-evident digital credential issuance and verification platform for universities.',
 7, 3, '2026-09-15', '2026-12-20', 'octocat', 'Hello-World', 'http://localhost:8080/demo', '2026-10-18 14:00:00', '2026-09-15 14:00:00', '2026-10-18 14:00:00'),

-- Project 3: DELAYED
(3, 'Autonomous Drone Path Planning via Deep Q-Networks',
 'Multi-agent obstacle avoidance and optimal trajectory planning for autonomous quadcopters in GPS-denied environments.',
 9, 2, '2026-08-15', '2026-11-30', NULL, NULL, NULL, NULL, '2026-08-15 09:30:00', '2026-10-15 16:00:00');

-- 3. Team Members
INSERT INTO `team_members` (`id`, `project_id`, `user_id`, `responsibility`, `joined_at`) VALUES
-- Project 1 Team
(1, 1, 4, 'Team Lead & Backend Architecture', '2026-09-01 10:00:00'),
(2, 1, 5, 'Data Ingestion & Sensor APIs', '2026-09-02 11:00:00'),
(3, 1, 6, 'Frontend Visualization & Reporting', '2026-09-02 11:30:00'),

-- Project 2 Team
(4, 2, 7, 'Team Lead & Smart Contract Engineer', '2026-09-15 14:00:00'),
(5, 2, 8, 'Full-Stack Integration & Client SDK', '2026-09-16 10:00:00'),

-- Project 3 Team
(6, 3, 9, 'Team Lead & Reinforcement Learning', '2026-08-15 09:30:00'),
(7, 3, 5, 'Simulation Environment & 3D Physics', '2026-08-16 14:00:00');

-- 4. Milestones
INSERT INTO `milestones` (`id`, `project_id`, `title`, `description`, `target_date`, `completed_at`, `sort_order`, `review_status`) VALUES
-- Project 1 Milestones (Progressing smoothly)
(1, 1, 'Project Planning & Requirements', 'System requirements specification, sensor interfaces definition, and architecture signoff.', '2026-09-20', '2026-09-18 16:00:00', 1, 'REVIEWED'),
(2, 1, 'Architecture & Database Design', 'Schema design, connection pooling setup, and timeseries data modeling.', '2026-10-10', '2026-10-09 15:30:00', 2, 'REVIEWED'),
(3, 1, 'Core Sensor Ingestion Module', 'High-throughput MQTT broker listener and validator pipeline.', '2026-11-05', NULL, 3, 'PENDING'),
(4, 1, 'Analytics Dashboard & Reporting', 'Web UI with power usage graphs and anomaly detection alerts.', '2026-11-25', NULL, 4, 'PENDING'),
(5, 1, 'Final Evaluation & Deployment', 'Field validation with 10 physical sensors and final thesis report.', '2026-12-10', NULL, 5, 'PENDING'),

-- Project 2 Milestones (Milestone 7 due within 7 days and <50% tasks done -> AT RISK)
(6, 2, 'Problem Statement & Literature Survey', 'Analysis of existing blockchain credentialing systems and cryptographic standards.', '2026-09-30', '2026-09-29 11:00:00', 1, 'REVIEWED'),
(7, 2, 'Consensus & Smart Contract Prototype', 'Solidity contract specifications for verifiable credential signing.', '2026-10-24', NULL, 2, 'PENDING'),
(8, 2, 'Frontend Verification Portal', 'Public portal for employers to verify student credential hashes.', '2026-11-20', NULL, 3, 'PENDING'),
(9, 2, 'Final Security Audit & Evaluation', 'Static analysis, gas optimization, and formal verification.', '2026-12-15', NULL, 4, 'PENDING'),

-- Project 3 Milestones (Milestone 11 target_date 2026-10-05 has passed and NOT completed -> DELAYED)
(10, 3, 'Simulation Environment Setup', 'Setup AirSim / Gazebo physics simulation environment.', '2026-09-10', '2026-09-12 17:00:00', 1, 'REVIEWED'),
(11, 3, 'Baseline Navigation Algorithms', 'Implement A* and RRT algorithms for baseline path benchmark.', '2026-10-05', NULL, 2, 'PENDING'),
(12, 3, 'Deep Q-Network Integration', 'Design state representations and train DQN policy with experience replay.', '2026-11-10', NULL, 3, 'PENDING'),
(13, 3, 'Physical Hardware Trials', 'Deploy model onto embedded Jetson Nano aboard quadcopter.', '2026-11-28', NULL, 4, 'PENDING');

-- 5. Tasks (~10 tasks per project)
INSERT INTO `tasks` (`id`, `project_id`, `milestone_id`, `title`, `description`, `assignee_id`, `priority`, `status`, `due_date`, `completed_at`, `created_by`, `created_at`, `updated_at`) VALUES
-- Project 1 Tasks (On Track: good completion, future due dates)
(1, 1, 1, 'Draft System Requirements Specification', 'Detail functional and non-functional requirements for the monitoring suite.', 4, 'HIGH', 'COMPLETED', '2026-09-15', '2026-09-14 14:00:00', 4, '2026-09-02 10:00:00', '2026-09-14 14:00:00'),
(2, 1, 1, 'Define IoT Telemetry Packet Schema', 'JSON specification for energy meter voltage, current, and active power.', 5, 'MEDIUM', 'COMPLETED', '2026-09-18', '2026-09-17 12:00:00', 4, '2026-09-02 10:30:00', '2026-09-17 12:00:00'),
(3, 1, 2, 'Design Relational Timeseries Database Tables', 'Create MySQL partitioned tables for hourly energy readings.', 4, 'HIGH', 'COMPLETED', '2026-10-02', '2026-10-01 16:30:00', 4, '2026-09-20 11:00:00', '2026-10-01 16:30:00'),
(4, 1, 2, 'Configure HikariCP Connection Pool', 'Establish production pool settings and connection validation.', 6, 'LOW', 'COMPLETED', '2026-10-06', '2026-10-05 18:00:00', 4, '2026-09-20 11:15:00', '2026-10-05 18:00:00'),
(5, 1, 2, 'Build DAO Test Harness', 'Verify PreparedStatement data integrity with JUnit tests.', 5, 'MEDIUM', 'COMPLETED', '2026-10-08', '2026-10-08 17:00:00', 4, '2026-09-20 11:30:00', '2026-10-08 17:00:00'),
(6, 1, 3, 'Implement MQTT Message Ingestion Worker', 'Subscribe to campus substation topics and process payload bursts.', 5, 'HIGH', 'IN_PROGRESS', '2026-10-25', NULL, 4, '2026-10-10 09:00:00', '2026-10-18 10:00:00'),
(7, 1, 3, 'Telemetry Payload Data Validator', 'Filter out malformed packets and voltage spikes.', 4, 'MEDIUM', 'IN_PROGRESS', '2026-10-28', NULL, 4, '2026-10-10 09:30:00', '2026-10-17 14:00:00'),
(8, 1, 3, 'Synthetic Telemetry Load Generator', 'Create CLI simulation tool to stream 100 packets/sec for stress testing.', 6, 'LOW', 'COMPLETED', '2026-10-18', '2026-10-18 19:00:00', 4, '2026-10-10 10:00:00', '2026-10-18 19:00:00'),
(9, 1, 4, 'Construct Energy Consumption Heatmap UI', 'Interactive dashboard grid showing building-by-building draw.', 6, 'MEDIUM', 'NOT_STARTED', '2026-11-12', NULL, 4, '2026-10-10 10:15:00', '2026-10-10 10:15:00'),
(10, 1, 4, 'Implement Real-time Anomaly Alerts', 'Notify facilities management when power factor drops below 0.85.', 5, 'HIGH', 'NOT_STARTED', '2026-11-18', NULL, 4, '2026-10-10 10:30:00', '2026-10-10 10:30:00'),

-- Project 2 Tasks (At Risk: overdue task + milestone due in 5 days with low completion)
(11, 2, 6, 'Survey W3C Decentralized Identifiers (DIDs)', 'Synthesize DID specification documents and key formats.', 7, 'MEDIUM', 'COMPLETED', '2026-09-22', '2026-09-21 16:00:00', 7, '2026-09-16 10:00:00', '2026-09-21 16:00:00'),
(12, 2, 6, 'Evaluate Ethereum vs Hyperledger Fabric', 'Comparative report on transaction finality and private consortium suitability.', 8, 'LOW', 'COMPLETED', '2026-09-27', '2026-09-26 15:00:00', 7, '2026-09-16 10:30:00', '2026-09-26 15:00:00'),
(13, 2, 7, 'Write Solidity Verifiable Credential Contract', 'Base contract for registrar accreditation and hash storage.', 7, 'HIGH', 'IN_PROGRESS', '2026-10-22', NULL, 7, '2026-10-01 09:00:00', '2026-10-15 11:00:00'),
(14, 2, 7, 'Setup Hardhat Local Testing Environment', 'Script deployment fixtures and automated unit tests for gas cost.', 8, 'MEDIUM', 'COMPLETED', '2026-10-14', '2026-10-13 18:00:00', 7, '2026-10-01 09:15:00', '2026-10-13 18:00:00'),
(15, 2, 7, 'Resolve Smart Contract Re-entrancy Vulnerability', 'Implement Checks-Effects-Interactions pattern for batch revocation.', 7, 'MEDIUM', 'IN_PROGRESS', '2026-10-16', NULL, 7, '2026-10-01 09:30:00', '2026-10-16 10:00:00'), -- Overdue!
(16, 2, 7, 'Integrate Elliptic Curve Signature Verification', 'Verify secp256k1 university registrar signatures on-chain.', 8, 'HIGH', 'NOT_STARTED', '2026-10-24', NULL, 7, '2026-10-01 10:00:00', '2026-10-01 10:00:00'),
(17, 2, 8, 'Develop Verification REST Microservice', 'Spring/Node gateway connecting university SIS to Ethereum node.', 7, 'MEDIUM', 'NOT_STARTED', '2026-11-08', NULL, 7, '2026-10-01 10:15:00', '2026-10-01 10:15:00'),
(18, 2, 8, 'Design Public QR Verification Page', 'Mobile-responsive transcript scanner using browser webcam.', 8, 'LOW', 'NOT_STARTED', '2026-11-14', NULL, 7, '2026-10-01 10:30:00', '2026-10-01 10:30:00'),
(19, 2, 9, 'Security Penetration Testing', 'Fuzz smart contracts using Slither and Mythril.', 7, 'HIGH', 'NOT_STARTED', '2026-12-05', NULL, 7, '2026-10-01 10:45:00', '2026-10-01 10:45:00'),

-- Project 3 Tasks (Delayed: HIGH priority task overdue > 3 days, overdue milestone)
(20, 3, 10, 'Install ROS2 and Gazebo Simulator', 'Configure robotics middleware and verify quadcopter kinematics model.', 9, 'MEDIUM', 'COMPLETED', '2026-08-25', '2026-08-24 17:00:00', 9, '2026-08-16 10:00:00', '2026-08-24 17:00:00'),
(21, 3, 10, 'Generate 3D Obstacle Course Point Cloud', 'Build simulated indoor warehouse with static and dynamic obstacles.', 5, 'LOW', 'COMPLETED', '2026-09-05', '2026-09-07 14:00:00', 9, '2026-08-16 10:30:00', '2026-09-07 14:00:00'),
(22, 3, 11, 'Implement 3D A* Shortest Path Baseline', 'Classical graph search algorithm benchmark in C++.', 9, 'HIGH', 'IN_PROGRESS', '2026-10-10', NULL, 9, '2026-09-12 11:00:00', '2026-10-10 15:00:00'), -- HIGH overdue by 9 days!
(23, 3, 11, 'Implement RRT* Dynamic Trajectory Planner', 'Rapidly-exploring random trees for kinematic smoothing.', 5, 'HIGH', 'NOT_STARTED', '2026-10-12', NULL, 9, '2026-09-12 11:15:00', '2026-10-12 12:00:00'), -- HIGH overdue by 7 days!
(24, 3, 11, 'Benchmarking Suite for Flight Path Latency', 'Compare computation times between A* and RRT* on 100 trials.', 9, 'MEDIUM', 'NOT_STARTED', '2026-10-15', NULL, 9, '2026-09-12 11:30:00', '2026-10-15 11:00:00'), -- Overdue
(25, 3, 12, 'Define Reinforcement Learning State-Action Space', 'Quaternion orientation, velocity vectors, and LiDAR range readings.', 9, 'HIGH', 'NOT_STARTED', '2026-11-01', NULL, 9, '2026-09-12 11:45:00', '2026-09-12 11:45:00'),
(26, 3, 12, 'Implement Deep Q-Network Policy Network', 'PyTorch / LibTorch neural network with prioritized replay buffer.', 5, 'HIGH', 'NOT_STARTED', '2026-11-06', NULL, 9, '2026-09-12 12:00:00', '2026-09-12 12:00:00'),
(27, 3, 12, 'Reward Function Engineering for Collision Penalties', 'Reward shaping balancing distance to goal and clearance margin.', 9, 'MEDIUM', 'NOT_STARTED', '2026-11-09', NULL, 9, '2026-09-12 12:15:00', '2026-09-12 12:15:00'),
(28, 3, 13, 'Hardware-in-the-Loop Jetson Nano Deployment', 'TensorRT quantization and serial communication with flight controller.', 5, 'HIGH', 'NOT_STARTED', '2026-11-22', NULL, 9, '2026-09-12 12:30:00', '2026-09-12 12:30:00');

-- 6. GitHub Activity (for Project 1)
INSERT INTO `github_activity` (`id`, `project_id`, `sha`, `author_login`, `author_name`, `message`, `committed_at`, `html_url`) VALUES
(1, 1, '7a9b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b', 'yash-bawane', 'Bawane Yash Sunil', 'feat: initialize telemetry ingestion worker and message pipeline', '2026-10-19 14:22:10', 'https://github.com/spring-projects/spring-petclinic/commit/7a9b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b'),
(2, 1, '8b0c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c', 'gulam-moin', 'Gulam Moinuddin', 'fix: resolve voltage spike validation edge case in sensor parser', '2026-10-18 16:45:30', 'https://github.com/spring-projects/spring-petclinic/commit/8b0c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c'),
(3, 1, '9c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d', 'kartik-jindal', 'Kartik Jindal', 'test: add integration test suite for synthetic telemetry generator', '2026-10-18 11:10:00', 'https://github.com/spring-projects/spring-petclinic/commit/9c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d'),
(4, 1, '0d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e', 'yash-bawane', 'Bawane Yash Sunil', 'perf: tune HikariCP pool parameters for high throughput telemetry', '2026-10-16 18:05:12', 'https://github.com/spring-projects/spring-petclinic/commit/0d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e'),
(5, 1, '1e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f', 'gulam-moin', 'Gulam Moinuddin', 'refactor: decouple MQTT connection handler from database layer', '2026-10-14 09:30:45', 'https://github.com/spring-projects/spring-petclinic/commit/1e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f'),
(6, 1, '2f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a', 'kartik-jindal', 'Kartik Jindal', 'docs: update architecture diagram and data flow specifications', '2026-10-12 17:15:00', 'https://github.com/spring-projects/spring-petclinic/commit/2f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a'),
(7, 1, '3a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b', 'yash-bawane', 'Bawane Yash Sunil', 'feat: implement database schema migrations for partitioned energy logs', '2026-10-08 13:40:20', 'https://github.com/spring-projects/spring-petclinic/commit/3a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b');

-- 7. Feedback
INSERT INTO `feedback` (`id`, `project_id`, `faculty_id`, `milestone_id`, `comment`, `score`, `created_at`) VALUES
(1, 1, 2, 1, 'Comprehensive requirements specification and thorough telemetry schema design. Good separation of concerns.', 9.0, '2026-09-20 17:00:00'),
(2, 1, 2, 2, 'Database partitioning strategy is sound. Connection pooling benchmark demonstrates robust scalability.', 9.2, '2026-10-11 11:30:00'),
(3, 2, 3, 6, 'Clear comparison of blockchain architectures, but need deeper threat modeling regarding private key management.', 7.0, '2026-10-02 14:00:00'),
(4, 3, 2, 10, 'Gazebo simulation physics calibrated accurately. However, path planning benchmarks are lagging behind schedule.', 5.5, '2026-09-14 16:30:00');

-- 8. Deadlines
INSERT INTO `deadlines` (`id`, `project_id`, `title`, `due_date`, `created_by`, `created_at`) VALUES
-- Global deadline set by Admin
(1, NULL, 'University Mid-Term Academic Project Progress Review', '2026-10-28', 1, '2026-09-01 09:00:00'),
(2, NULL, 'Final Project Report & Code Repository Freeze', '2026-12-12', 1, '2026-09-01 09:00:00'),

-- Project-specific deadlines
(3, 1, 'Substation Sensor Hardware Integration Test', '2026-11-04', 2, '2026-10-01 10:00:00'),
(4, 2, 'Smart Contract Formal Verification Review', '2026-10-25', 3, '2026-10-05 11:00:00'),
(5, 3, 'AirSim Kinematics Benchmark Demonstration', '2026-10-24', 2, '2026-10-08 14:00:00');
