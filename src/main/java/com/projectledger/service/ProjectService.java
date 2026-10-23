package com.projectledger.service;

import com.projectledger.dao.GitHubActivityDao;
import com.projectledger.dao.MilestoneDao;
import com.projectledger.dao.ProjectDao;
import com.projectledger.dao.TaskDao;
import com.projectledger.dao.TeamMemberDao;
import com.projectledger.exception.AccessDeniedException;
import com.projectledger.exception.AppException;
import com.projectledger.exception.NotFoundException;
import com.projectledger.model.Milestone;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.model.Task;
import com.projectledger.util.DatabaseConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Service managing project lifecycles, access control, multi-table transactions,
 * and continuous process health evaluation.
 */
public class ProjectService {
    private final ProjectDao projectDao = new ProjectDao();
    private final TeamMemberDao teamMemberDao = new TeamMemberDao();
    private final MilestoneDao milestoneDao = new MilestoneDao();
    private final TaskDao taskDao = new TaskDao();
    private final GitHubActivityDao gitHubActivityDao = new GitHubActivityDao();

    /**
     * Retrieves a project by ID and computes dynamic progress and health metrics.
     */
    public Project getProjectWithMetrics(int projectId) {
        Project project = projectDao.findById(projectId)
                .orElseThrow(() -> new NotFoundException("Project", projectId));

        enrichMetrics(project);
        return project;
    }

    /**
     * Retrieves all projects for a student (as leader or team member) with calculated metrics.
     */
    public List<Project> getStudentProjects(int studentId) {
        List<Project> projects = projectDao.findByStudentId(studentId);
        for (Project p : projects) {
            enrichMetrics(p);
        }
        return projects;
    }

    /**
     * Retrieves all projects supervised by a faculty member, sorted by health (DELAYED first).
     */
    public List<Project> getFacultyProjects(int facultyId) {
        List<Project> projects = projectDao.findByFacultyId(facultyId);
        for (Project p : projects) {
            enrichMetrics(p);
        }
        // Sort: DELAYED first, then AT_RISK, then ON_TRACK
        projects.sort((p1, p2) -> Integer.compare(p2.getHealth().ordinal(), p1.getHealth().ordinal()));
        return projects;
    }

    /**
     * Retrieves all projects for administrators with metrics.
     */
    public List<Project> getAllProjects() {
        List<Project> projects = projectDao.findAll();
        for (Project p : projects) {
            enrichMetrics(p);
        }
        return projects;
    }

    /**
     * Enforces role-based ownership checks.
     * Student: must be leader or team member.
     * Faculty: must be assigned supervising faculty.
     * Admin: unrestricted access.
     */
    public void checkAccess(Project project, SessionUser user) {
        if (user == null) {
            throw new AccessDeniedException("Authentication required.");
        }
        if (user.isAdmin()) {
            return;
        }
        if (user.isFaculty()) {
            if (project.getFacultyId() == null || project.getFacultyId() != user.getId()) {
                throw new AccessDeniedException("You are not assigned as the supervisor for this project.");
            }
            return;
        }
        if (user.isStudent()) {
            boolean isLeader = project.getLeaderId() == user.getId();
            boolean isMember = teamMemberDao.findByProjectAndUser(project.getId(), user.getId()).isPresent();
            if (!isLeader && !isMember) {
                throw new AccessDeniedException("You do not have access to this student project.");
            }
            return;
        }
        throw new AccessDeniedException("Access forbidden.");
    }

    /**
     * Creates a new project in a single transaction:
     * 1. Inserts projects table row
     * 2. Adds creator as leader and first team member
     * 3. Optionally seeds default academic milestones
     */
    public Project createProject(Project project, boolean addDefaultMilestones) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int projectId = projectDao.create(project, conn);
                project.setId(projectId);

                // Add leader as team member
                teamMemberDao.addMember(projectId, project.getLeaderId(), "Team Lead & Project Architect", conn);

                if (addDefaultMilestones) {
                    seedDefaultMilestones(project, conn);
                }

                conn.commit();
                return project;
            } catch (Exception e) {
                conn.rollback();
                throw new AppException("Failed to create project: " + e.getMessage(), e);
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            throw new AppException("Database transaction error while creating project", e);
        }
    }

    public void updateProject(Project project) {
        projectDao.update(project);
    }

    public void deleteProject(int projectId) {
        projectDao.delete(projectId);
    }

    public void reassignFaculty(int projectId, Integer facultyId) {
        projectDao.reassignFaculty(projectId, facultyId);
    }

    private void seedDefaultMilestones(Project project, Connection conn) throws SQLException {
        LocalDate start = project.getStartDate();
        LocalDate end = project.getEndDate();
        long totalDays = java.time.temporal.ChronoUnit.DAYS.between(start, end);

        String[] titles = {
            "Planning & Requirements",
            "Architecture & System Design",
            "Core Implementation",
            "Testing & Verification",
            "Final Delivery & Documentation"
        };

        String[] descriptions = {
            "Problem definition, literature review, and requirements specification.",
            "Database schema, API contracts, and high-level component diagrams.",
            "Development of primary feature set and operational prototype.",
            "Automated test coverage, integration testing, and bug remediation.",
            "Final evaluation report, user demonstration, and repository freeze."
        };

        double[] fractions = {0.15, 0.35, 0.70, 0.90, 1.00};

        for (int i = 0; i < titles.length; i++) {
            long daysToAdd = Math.max(1, (long) (totalDays * fractions[i]));
            LocalDate targetDate = start.plusDays(daysToAdd);
            if (targetDate.isAfter(end)) {
                targetDate = end;
            }

            Milestone m = new Milestone();
            m.setProjectId(project.getId());
            m.setTitle(titles[i]);
            m.setDescription(descriptions[i]);
            m.setTargetDate(targetDate);
            m.setSortOrder(i + 1);
            m.setReviewStatus("PENDING");
            milestoneDao.create(m, conn);
        }
    }

    private void enrichMetrics(Project project) {
        List<Task> tasks = taskDao.findByProjectId(project.getId());
        List<Milestone> milestones = milestoneDao.findByProjectId(project.getId());
        LocalDateTime lastCommit = gitHubActivityDao.findLastCommitDate(project.getId()).orElse(null);

        ProgressCalculator.ProgressResult progress = ProgressCalculator.calculate(project, tasks, milestones);
        project.setOverallProgress(progress.getOverallProgress());
        project.setExpectedProgress(progress.getExpectedProgress());
        project.setLastCommitAt(lastCommit);

        HealthCalculator.HealthResult health = HealthCalculator.calculate(
                project, tasks, milestones, progress.getOverallProgress(), progress.getExpectedProgress(), lastCommit);

        project.setHealth(health.getHealth());
        project.setHealthReasons(health.getReasons());

        // Find next milestone
        for (Milestone m : milestones) {
            if (!m.isCompleted()) {
                project.setNextMilestoneTitle(m.getTitle());
                project.setNextMilestoneDate(m.getTargetDate());
                break;
            }
        }
    }
}
