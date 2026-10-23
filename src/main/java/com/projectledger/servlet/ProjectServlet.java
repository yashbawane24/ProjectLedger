package com.projectledger.servlet;

import com.projectledger.dao.FeedbackDao;
import com.projectledger.dao.GitHubActivityDao;
import com.projectledger.dao.MilestoneDao;
import com.projectledger.dao.TeamMemberDao;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Feedback;
import com.projectledger.model.GitHubCommit;
import com.projectledger.model.Milestone;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.model.StudentEvidence;
import com.projectledger.model.Task;
import com.projectledger.model.TaskStatus;
import com.projectledger.model.TeamMember;
import com.projectledger.service.GitHubService;
import com.projectledger.service.ProjectService;
import com.projectledger.service.TaskService;
import com.projectledger.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Main project controller managing tabs:
 * Overview, Tasks, Milestones, Team, Activity, and Feedback.
 */
@WebServlet(name = "ProjectServlet", urlPatterns = {"/project"})
public class ProjectServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(ProjectServlet.class.getName());

    private final transient ProjectService projectService = new ProjectService();
    private final transient TaskService taskService = new TaskService();
    private final transient MilestoneDao milestoneDao = new MilestoneDao();
    private final transient TeamMemberDao teamMemberDao = new TeamMemberDao();
    private final transient GitHubActivityDao gitHubActivityDao = new GitHubActivityDao();
    private final transient FeedbackDao feedbackDao = new FeedbackDao();
    private final transient GitHubService gitHubService = new GitHubService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + user.getDashboardPath());
            return;
        }

        int projectId;
        try {
            projectId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid project ID.");
            return;
        }

        Project project;
        try {
            project = projectService.getProjectWithMetrics(projectId);
            projectService.checkAccess(project, user);
        } catch (com.projectledger.exception.NotFoundException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, e.getMessage());
            return;
        } catch (com.projectledger.exception.AccessDeniedException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
            return;
        }

        // Auto-sync GitHub if connected and last synced > 30 mins ago
        boolean hasRepo = project.getRepoOwner() != null && project.getRepoName() != null;
        if (hasRepo) {
            LocalDateTime lastSync = project.getLastSyncedAt();
            if (lastSync == null || ChronoUnit.MINUTES.between(lastSync, LocalDateTime.now()) >= 30) {
                try {
                    gitHubService.syncCommits(project);
                    // Refresh project metrics after sync
                    project = projectService.getProjectWithMetrics(projectId);
                } catch (Exception e) {
                    LOGGER.log(Level.INFO, "Auto-sync GitHub failed gracefully: " + e.getMessage());
                }
            }
        }

        String tab = request.getParameter("tab");
        if (tab == null || tab.isBlank()) {
            tab = "overview";
        }

        List<Task> tasks = taskService.getProjectTasks(projectId);
        Map<String, List<Task>> kanbanColumns = taskService.getKanbanColumns(projectId);
        List<Milestone> milestones = milestoneDao.findByProjectId(projectId);
        List<TeamMember> teamMembers = teamMemberDao.findByProjectId(projectId);
        List<Feedback> feedbackList = feedbackDao.findByProjectId(projectId);

        // Build contribution evidence per student
        List<StudentEvidence> evidenceList = new ArrayList<>();
        for (TeamMember tm : teamMembers) {
            StudentEvidence ev = new StudentEvidence(tm);
            int assigned = 0;
            int completed = 0;
            int overdue = 0;
            for (Task t : tasks) {
                if (t.getAssigneeId() != null && t.getAssigneeId() == tm.getUserId()) {
                    assigned++;
                    if (t.getStatus() == TaskStatus.COMPLETED) {
                        completed++;
                    } else if (t.isOverdue()) {
                        overdue++;
                    }
                }
            }
            ev.setTasksAssigned(assigned);
            ev.setTasksCompleted(completed);
            ev.setTasksOverdue(overdue);

            if (tm.getUserGithub() != null && !tm.getUserGithub().isBlank()) {
                ev.setCommitCount(gitHubActivityDao.countCommitsByAuthor(projectId, tm.getUserGithub()));
                ev.setLastCommitDate(gitHubActivityDao.findLastCommitDateByAuthor(projectId, tm.getUserGithub()).orElse(null));
            }
            evidenceList.add(ev);
        }

        // Commits and charts for Activity tab
        List<GitHubCommit> commits = gitHubActivityDao.findByProjectId(projectId);
        Map<LocalDate, Integer> dailyCommits = gitHubActivityDao.getDailyCommitCountsLast30Days(projectId);
        List<String> contributors = hasRepo ? gitHubService.getContributors(project.getRepoOwner(), project.getRepoName()) : Collections.emptyList();
        List<String> branches = hasRepo ? gitHubService.getBranches(project.getRepoOwner(), project.getRepoName()) : Collections.emptyList();

        boolean isLeader = project.getLeaderId() == user.getId();
        boolean canManage = isLeader || user.isAdmin();
        boolean isLocalhostDemo = Validator.isLocalhostUrl(project.getDemoUrl());

        request.setAttribute("project", project);
        request.setAttribute("tasks", tasks);
        request.setAttribute("kanbanColumns", kanbanColumns);
        request.setAttribute("milestones", milestones);
        request.setAttribute("teamMembers", teamMembers);
        request.setAttribute("evidenceList", evidenceList);
        request.setAttribute("commits", commits);
        request.setAttribute("dailyCommits", dailyCommits);
        request.setAttribute("contributors", contributors);
        request.setAttribute("branches", branches);
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("isLeader", isLeader);
        request.setAttribute("canManage", canManage);
        request.setAttribute("isLocalhostDemo", isLocalhostDemo);
        request.setAttribute("activeTab", tab);
        request.setAttribute("pageTitle", project.getTitle());

        request.getRequestDispatcher("/WEB-INF/jsp/project/view.jsp").forward(request, response);
    }
}
