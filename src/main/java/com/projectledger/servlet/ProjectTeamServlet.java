package com.projectledger.servlet;

import com.google.gson.Gson;
import com.projectledger.dao.TeamMemberDao;
import com.projectledger.dao.UserDao;
import com.projectledger.exception.AccessDeniedException;
import com.projectledger.exception.AppException;
import com.projectledger.filter.AuthFilter;
import com.projectledger.model.Project;
import com.projectledger.model.SessionUser;
import com.projectledger.model.Student;
import com.projectledger.model.User;
import com.projectledger.service.ProjectService;
import com.projectledger.util.Flash;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Controller for managing project team rosters, searching students,
 * adding members (up to 6), and removing members.
 */
@WebServlet(name = "ProjectTeamServlet", urlPatterns = {"/project/team/add", "/project/team/remove", "/project/team/search"})
public class ProjectTeamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final transient ProjectService projectService = new ProjectService();
    private final transient TeamMemberDao teamMemberDao = new TeamMemberDao();
    private final transient UserDao userDao = new UserDao();
    private final transient Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/project/team/search".equals(path)) {
            String query = request.getParameter("q");
            List<Student> students = userDao.searchStudents(query);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            List<Map<String, Object>> result = students.stream().map(s -> {
                Map<String, Object> map = new HashMap<>();
                map.put("id", s.getId());
                map.put("name", s.getName());
                map.put("email", s.getEmail());
                map.put("regNo", s.getRegNo() != null ? s.getRegNo() : "");
                map.put("github", s.getGithubUsername() != null ? s.getGithubUsername() : "");
                return map;
            }).toList();

            response.getWriter().write(gson.toJson(result));
            return;
        }
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        SessionUser user = (SessionUser) session.getAttribute(AuthFilter.SESSION_USER_ATTR);
        String path = request.getServletPath();

        String projectIdStr = request.getParameter("projectId");
        if (projectIdStr == null || projectIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + user.getDashboardPath());
            return;
        }

        int projectId;
        try {
            projectId = Integer.parseInt(projectIdStr.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid project ID.");
            return;
        }

        Project project = projectService.getProjectWithMetrics(projectId);
        boolean isLeader = project.getLeaderId() == user.getId();
        if (!user.isAdmin() && !isLeader) {
            throw new AccessDeniedException("Only the project leader may manage team members.");
        }

        if ("/project/team/add".equals(path)) {
            String studentSearch = request.getParameter("studentIdentifier");
            String responsibility = request.getParameter("responsibility");

            if (studentSearch == null || studentSearch.isBlank()) {
                Flash.error(request, "Please provide a student email or registration number.");
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=team");
                return;
            }

            int currentCount = teamMemberDao.countByProjectId(projectId);
            if (currentCount >= 6) {
                Flash.error(request, "Project team is full. Maximum team capacity is 6 members.");
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=team");
                return;
            }

            // Find student by email or search
            Optional<User> targetUser = userDao.findByEmail(studentSearch.trim());
            if (targetUser.isEmpty()) {
                List<Student> match = userDao.searchStudents(studentSearch.trim());
                if (!match.isEmpty()) {
                    targetUser = Optional.of(match.get(0));
                }
            }

            if (targetUser.isEmpty() || !(targetUser.get() instanceof Student targetStudent)) {
                Flash.error(request, "No active student account found matching '" + studentSearch + "'.");
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=team");
                return;
            }

            if (teamMemberDao.findByProjectAndUser(projectId, targetStudent.getId()).isPresent()) {
                Flash.error(request, targetStudent.getName() + " is already a member of this project team.");
                response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=team");
                return;
            }

            try {
                teamMemberDao.addMember(projectId, targetStudent.getId(), responsibility);
                Flash.success(request, targetStudent.getName() + " was added to the project team.");
            } catch (AppException e) {
                Flash.error(request, "Failed to add member: " + e.getMessage());
            }

        } else if ("/project/team/remove".equals(path)) {
            String targetUserIdStr = request.getParameter("userId");
            try {
                int targetUserId = Integer.parseInt(targetUserIdStr);
                if (targetUserId == project.getLeaderId()) {
                    Flash.error(request, "The project leader cannot be removed from the team.");
                } else {
                    teamMemberDao.removeMember(projectId, targetUserId);
                    Flash.success(request, "Team member removed.");
                }
            } catch (Exception e) {
                Flash.error(request, "Failed to remove member.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/project?id=" + projectId + "&tab=team");
    }
}
