<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<!-- Project Header Banner -->
<div class="page-header">
    <div style="flex:1;">
        <div style="display:flex; align-items:center; gap:0.75rem; flex-wrap:wrap; margin-bottom:0.35rem;">
            <h1 class="page-title" style="margin-bottom:0;"><c:out value="${project.title}"/></h1>
            <span class="health-stamp ${project.health.cssClass}">
                <c:out value="${project.health.displayName}"/>
            </span>
        </div>
        <div class="header-lead">
            Supervised by <strong><c:out value="${project.facultyName != null ? project.facultyName : 'Pending Allocation'}"/></strong>
            · Team Lead: <strong><c:out value="${project.leaderName}"/></strong>
        </div>
    </div>
    <div class="header-actions">
        <c:if test="${project.repoOwner != null}">
            <a href="https://github.com/${project.repoOwner}/${project.repoName}" target="_blank" rel="noopener noreferrer" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path>
                </svg>
                <span>GitHub Repo</span>
            </a>
        </c:if>
        <c:if test="${project.demoUrl != null}">
            <a href="${project.demoUrl}" target="_blank" rel="noopener noreferrer" class="btn btn-secondary btn-sm">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                    <polyline points="15 3 21 3 21 9"></polyline>
                    <line x1="10" y1="14" x2="21" y2="3"></line>
                </svg>
                <span>Live Demo</span>
            </a>
        </c:if>
        <c:if test="${canManage}">
            <form action="${pageContext.request.contextPath}/project/delete" method="post" style="display:inline;">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="projectId" value="${project.id}">
                <button type="submit" class="btn btn-danger btn-sm" data-confirm="Are you sure you want to permanently delete project '${project.title}'? This action cannot be undone.">
                    Delete Project
                </button>
            </form>
        </c:if>
    </div>
</div>

<!-- Localhost Warning Alert -->
<c:if test="${isLocalhostDemo}">
    <div class="alert-warning" role="alert">
        <strong>Local Address Notice:</strong> The registered live demonstration URL (<code><c:out value="${project.demoUrl}"/></code>) points to a local address (localhost). It is only accessible on the student machine running the local server.
    </div>
</c:if>

<!-- Navigation Tabs -->
<div class="tabs-nav" role="tablist">
    <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=overview"
       class="tab-link ${activeTab == 'overview' ? 'active' : ''}">Overview</a>
    <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=tasks"
       class="tab-link ${activeTab == 'tasks' ? 'active' : ''}">Tasks (${fn:length(tasks)})</a>
    <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=milestones"
       class="tab-link ${activeTab == 'milestones' ? 'active' : ''}">Milestones (${fn:length(milestones)})</a>
    <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=team"
       class="tab-link ${activeTab == 'team' ? 'active' : ''}">Team &amp; Contributions (${fn:length(teamMembers)})</a>
    <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=activity"
       class="tab-link ${activeTab == 'activity' ? 'active' : ''}">GitHub Activity (${fn:length(commits)})</a>
    <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=feedback"
       class="tab-link ${activeTab == 'feedback' ? 'active' : ''}">Faculty Feedback (${fn:length(feedbackList)})</a>
</div>

<!-- =========================================================================
     TAB 1: OVERVIEW
     ========================================================================= -->
<c:if test="${activeTab == 'overview'}">
    <!-- Top 4 Quick KPI Summary Cards -->
    <div class="git-kpi-grid" style="margin-bottom:20px;">
        <div class="git-kpi-card">
            <div class="git-kpi-icon-box forest">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <div>
                <div class="git-kpi-val">${project.overallProgress}%</div>
                <div class="git-kpi-label">Actual Progress</div>
            </div>
        </div>
        <div class="git-kpi-card">
            <div class="git-kpi-icon-box soft">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
            </div>
            <div>
                <div class="git-kpi-val">${project.expectedProgress}%</div>
                <div class="git-kpi-label">Expected Schedule Pace</div>
            </div>
        </div>
        <div class="git-kpi-card">
            <div class="git-kpi-icon-box lime">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
            </div>
            <div>
                <div class="git-kpi-val">${fn:length(tasks)}</div>
                <div class="git-kpi-label">Assigned Tasks</div>
            </div>
        </div>
        <div class="git-kpi-card">
            <div class="git-kpi-icon-box obsidian">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
            </div>
            <div>
                <div class="git-kpi-val">${fn:length(milestones)}</div>
                <div class="git-kpi-label">Syllabus Milestones</div>
            </div>
        </div>
    </div>

    <div class="overview-grid">
        <!-- Left Column -->
        <div>
            <!-- Abstract & Scope -->
            <div class="overview-card">
                <div class="overview-card-header">
                    <h2 class="overview-card-title">Project Scope &amp; Abstract</h2>
                    <span class="git-pill-badge active-dot">Academic Capstone</span>
                </div>
                <p style="font-size:14px; line-height:1.65; color:#374151; margin:0 0 16px 0;">
                    <c:out value="${project.description}"/>
                </p>

                <div class="meta-pill-strip">
                    <div class="meta-pill-item">
                        <div class="meta-pill-label">Academic Timeline</div>
                        <div class="meta-pill-val">${project.startDate} — ${project.endDate}</div>
                    </div>
                    <div class="meta-pill-item">
                        <div class="meta-pill-label">Repository Sync</div>
                        <div class="meta-pill-val">
                            <c:out value="${project.lastSyncedAt != null ? project.lastSyncedAt : 'Never synchronized'}"/>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Project Settings (for Leader/Admin) -->
            <c:if test="${canManage}">
                <div class="overview-card">
                    <div class="overview-card-header">
                        <h2 class="overview-card-title">Update Project Settings</h2>
                        <span class="git-pill-badge">Management</span>
                    </div>
                    <form action="${pageContext.request.contextPath}/project/edit" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="projectId" value="${project.id}">

                        <div class="form-group" style="margin-bottom:14px;">
                            <label class="form-label" for="pTitle">Project Title</label>
                            <input type="text" id="pTitle" name="title" class="form-input" value="${project.title}" required>
                        </div>

                        <div class="form-group" style="margin-bottom:14px;">
                            <label class="form-label" for="pDesc">Description</label>
                            <textarea id="pDesc" name="description" class="form-textarea" rows="3" required><c:out value="${project.description}"/></textarea>
                        </div>

                        <div class="form-grid-2" style="margin-bottom:14px;">
                            <div class="form-group">
                                <label class="form-label" for="pStart">Start Date</label>
                                <input type="date" id="pStart" name="startDate" class="form-input mono-text" value="${project.startDate}" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="pEnd">End Date</label>
                                <input type="date" id="pEnd" name="endDate" class="form-input mono-text" value="${project.endDate}" required>
                            </div>
                        </div>

                        <div class="form-grid-2" style="margin-bottom:18px;">
                            <div class="form-group">
                                <label class="form-label" for="pRepo">GitHub Repo URL</label>
                                <input type="text" id="pRepo" name="repoUrl" class="form-input mono-text"
                                       value="${project.gitHubRepoFullName != null ? 'https://github.com/'.concat(project.gitHubRepoFullName) : ''}">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="pDemo">Demo URL</label>
                                <input type="url" id="pDemo" name="demoUrl" class="form-input mono-text" value="${project.demoUrl}">
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary" style="border-radius:20px; padding:8px 22px; font-weight:700;">Save Changes</button>
                    </form>
                </div>
            </c:if>
        </div>

        <!-- Right Column -->
        <div>
            <!-- Continuous Health Diagnostic Panel -->
            <div class="overview-card">
                <div class="overview-card-header">
                    <h2 class="overview-card-title">Process Health Assessment</h2>
                    <span class="health-stamp ${project.health.cssClass}">
                        <c:out value="${project.health.displayName}"/>
                    </span>
                </div>

                <!-- Striped Progress Bar Matching Image 1 & 2 -->
                <div style="margin-bottom:1.5rem;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; font-size:13px; font-weight:700; color:#18221b;">
                        <span>Actual Overall Delivery</span>
                        <span class="mono-text" style="font-size:15px; color:#1e4535;">${project.overallProgress}%</span>
                    </div>

                    <div class="striped-bar-track" style="height:12px; border-radius:6px;" title="Expected pace: ${project.expectedProgress}%">
                        <div class="striped-bar-fill ${project.health.name() == 'DELAYED' ? 'delayed' : (project.health.name() == 'AT_RISK' ? 'atrisk' : '')}"
                             style="width: ${project.overallProgress}%;"></div>
                        <div class="striped-bar-tick" style="left: ${project.expectedProgress}%; height:16px; top:-2px;" title="Target pace: ${project.expectedProgress}%"></div>
                    </div>

                    <div style="display:flex; justify-content:space-between; font-size:11.5px; color:#6b778c; margin-top:8px;">
                        <span>Weighted: 60% Tasks + 40% Milestones</span>
                        <span>Schedule Baseline: <strong style="color:#18221b;">${project.expectedProgress}%</strong></span>
                    </div>
                </div>

                <div class="meta-pill-label" style="margin-bottom:8px;">Status Justification &amp; Indicators</div>
                <ul class="health-reasons-list">
                    <c:forEach var="reason" items="${project.healthReasons}">
                        <li class="health-reason-pill ${project.health.name() == 'DELAYED' ? 'delayed' : 'ontrack'}">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            <span><c:out value="${reason}"/></span>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Next Milestone Summary (Dark Card matching Image 1) -->
            <div class="dark-milestone-banner">
                <div class="dark-ms-label">Next Academic Milestone</div>
                <c:choose>
                    <c:when test="${project.nextMilestoneTitle != null}">
                        <div class="dark-ms-title"><c:out value="${project.nextMilestoneTitle}"/></div>
                        <span class="dark-ms-pill">Target: ${project.nextMilestoneDate}</span>
                        <div>
                            <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=milestones" class="dark-ms-btn">
                                Inspect Syllabus Milestones →
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="dark-ms-title">All Milestones Complete</div>
                        <p style="color:#9da89f; font-size:13px; margin:0;">All defined syllabus milestones have been fulfilled.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</c:if>

<!-- =========================================================================
     TAB 2: TASKS (Kanban Board + Table View)
     ========================================================================= -->
<c:if test="${activeTab == 'tasks'}">
    <!-- Action Bar & Summary -->
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:1.5rem;">
        <div>
            <div style="display:flex; align-items:center; gap:10px;">
                <h2 class="section-title" style="margin-bottom:0;">Task Board &amp; Execution Ledger</h2>
                <span class="git-pill-badge active-dot">${fn:length(tasks)} Total Tasks</span>
            </div>
            <div style="font-size:0.867rem; color:var(--muted); margin-top:4px;">
                Kanban workflow tracking engineering subtasks, milestone linkage, and team assignments.
            </div>
        </div>
        <button type="button" class="btn btn-primary" onclick="document.getElementById('newTaskDrawer').style.display = 'block';"
                style="display:inline-flex; align-items:center; gap:8px; border-radius:24px; padding:8px 18px; font-weight:700;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
            </svg>
            <span>Add Task</span>
        </button>
    </div>

    <!-- New Task Form Drawer (Hidden by default) -->
    <div id="newTaskDrawer" class="overview-card" style="display:none; margin-bottom:1.5rem;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
            <h3 style="font-size:16px; font-weight:800; color:#18221b; margin:0;">Create Project Task</h3>
            <button type="button" class="btn-inline" onclick="document.getElementById('newTaskDrawer').style.display = 'none';" style="font-size:13px; font-weight:600; color:#6b778c;">× Close</button>
        </div>
        <form action="${pageContext.request.contextPath}/project/task/save" method="post">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="projectId" value="${project.id}">

            <div class="form-group" style="margin-bottom:14px;">
                <label class="form-label" for="taskTitle">Task Title</label>
                <input type="text" id="taskTitle" name="title" class="form-input" placeholder="e.g. Implement HikariCP database connection pool" required>
            </div>

            <div class="form-group" style="margin-bottom:14px;">
                <label class="form-label" for="taskDesc">Description &amp; Acceptance Criteria</label>
                <textarea id="taskDesc" name="description" class="form-textarea" rows="2" placeholder="Detail the expected technical output..."></textarea>
            </div>

            <div class="form-grid-3" style="margin-bottom:14px;">
                <div class="form-group">
                    <label class="form-label" for="taskAssignee">Assignee</label>
                    <select id="taskAssignee" name="assigneeId" class="form-select">
                        <option value="">-- Unassigned --</option>
                        <c:forEach var="m" items="${teamMembers}">
                            <option value="${m.userId}"><c:out value="${m.userName}"/> (${m.userRegNo != null ? m.userRegNo : m.responsibility})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="taskMilestone">Milestone Link</label>
                    <select id="taskMilestone" name="milestoneId" class="form-select">
                        <option value="">-- No Milestone --</option>
                        <c:forEach var="ms" items="${milestones}">
                            <option value="${ms.id}"><c:out value="${ms.title}"/></option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="taskPriority">Priority</label>
                    <select id="taskPriority" name="priority" class="form-select">
                        <option value="LOW">Low (Weight 1)</option>
                        <option value="MEDIUM" selected>Medium (Weight 2)</option>
                        <option value="HIGH">High (Weight 3)</option>
                    </select>
                </div>
            </div>

            <div class="form-group" style="max-width:300px; margin-bottom:18px;">
                <label class="form-label" for="taskDue">Due Date</label>
                <input type="date" id="taskDue" name="dueDate" class="form-input mono-text" required>
            </div>

            <button type="submit" class="btn btn-primary" style="border-radius:20px; padding:8px 22px; font-weight:700;">Save and Assign Task</button>
        </form>
    </div>

    <!-- 4-Column Modern Kanban Board -->
    <div class="task-kanban-board">
        <!-- Column 1: Not Started -->
        <div class="task-col-wrapper">
            <div class="task-col-head">
                <div class="task-col-title-group">
                    <span class="task-col-dot not-started"></span>
                    <span>Not Started</span>
                </div>
                <span class="task-col-badge">${fn:length(kanbanColumns.NOT_STARTED)}</span>
            </div>
            <div style="display:flex; flex-direction:column; gap:10px;">
                <c:forEach var="t" items="${kanbanColumns.NOT_STARTED}">
                    <div class="task-card-item priority-${fn:toLowerCase(t.priority.name())}">
                        <div class="task-card-title"><c:out value="${t.title}"/></div>
                        <c:if test="${t.milestoneTitle != null}">
                            <div class="task-ms-chip">¶ <c:out value="${t.milestoneTitle}"/></div>
                        </c:if>
                        <div class="task-card-bottom">
                            <span class="task-assignee-pill" title="${t.assigneeName != null ? t.assigneeName : 'Unassigned'}">
                                <span class="task-avatar-circle">${t.assigneeInitials}</span>
                                <span><c:out value="${t.assigneeName != null ? t.assigneeName : 'Unassigned'}"/></span>
                            </span>
                            <span class="task-due-chip">${t.dueDate}</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/project/task/status" method="post" style="margin:0;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${project.id}">
                            <input type="hidden" name="taskId" value="${t.id}">
                            <select name="status" class="task-select-pill" onchange="this.form.submit()">
                                <option value="NOT_STARTED" selected>Status: Not Started</option>
                                <option value="IN_PROGRESS">Start Work →</option>
                                <option value="COMPLETED">Mark Complete ✓</option>
                            </select>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Column 2: In Progress -->
        <div class="task-col-wrapper">
            <div class="task-col-head">
                <div class="task-col-title-group">
                    <span class="task-col-dot in-progress"></span>
                    <span>In Progress</span>
                </div>
                <span class="task-col-badge">${fn:length(kanbanColumns.IN_PROGRESS)}</span>
            </div>
            <div style="display:flex; flex-direction:column; gap:10px;">
                <c:forEach var="t" items="${kanbanColumns.IN_PROGRESS}">
                    <div class="task-card-item priority-${fn:toLowerCase(t.priority.name())}">
                        <div class="task-card-title"><c:out value="${t.title}"/></div>
                        <c:if test="${t.milestoneTitle != null}">
                            <div class="task-ms-chip">¶ <c:out value="${t.milestoneTitle}"/></div>
                        </c:if>
                        <div class="task-card-bottom">
                            <span class="task-assignee-pill" title="${t.assigneeName != null ? t.assigneeName : 'Unassigned'}">
                                <span class="task-avatar-circle">${t.assigneeInitials}</span>
                                <span><c:out value="${t.assigneeName != null ? t.assigneeName : 'Unassigned'}"/></span>
                            </span>
                            <span class="task-due-chip">${t.dueDate}</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/project/task/status" method="post" style="margin:0;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${project.id}">
                            <input type="hidden" name="taskId" value="${t.id}">
                            <select name="status" class="task-select-pill" onchange="this.form.submit()">
                                <option value="NOT_STARTED">← Move Back</option>
                                <option value="IN_PROGRESS" selected>Status: In Progress</option>
                                <option value="COMPLETED">Mark Complete ✓</option>
                            </select>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Column 3: Completed -->
        <div class="task-col-wrapper">
            <div class="task-col-head">
                <div class="task-col-title-group">
                    <span class="task-col-dot completed"></span>
                    <span>Completed</span>
                </div>
                <span class="task-col-badge">${fn:length(kanbanColumns.COMPLETED)}</span>
            </div>
            <div style="display:flex; flex-direction:column; gap:10px;">
                <c:forEach var="t" items="${kanbanColumns.COMPLETED}">
                    <div class="task-card-item" style="border-left:4px solid #10b981; opacity:0.92;">
                        <div class="task-card-title" style="text-decoration:line-through; color:#6b778c;"><c:out value="${t.title}"/></div>
                        <div class="task-card-bottom">
                            <span class="task-assignee-pill" title="${t.assigneeName}">
                                <span class="task-avatar-circle" style="background:#15803d;">${t.assigneeInitials}</span>
                                <span style="color:#15803d; font-weight:700;">Completed</span>
                            </span>
                            <span class="task-due-chip">${t.dueDate}</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/project/task/status" method="post" style="margin:0;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${project.id}">
                            <input type="hidden" name="taskId" value="${t.id}">
                            <select name="status" class="task-select-pill" onchange="this.form.submit()">
                                <option value="NOT_STARTED">← Reopen Task</option>
                                <option value="IN_PROGRESS">← Mark In Progress</option>
                                <option value="COMPLETED" selected>✓ Completed</option>
                            </select>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Column 4: Overdue -->
        <div class="task-col-wrapper" style="border-color:#fca5a5; background:#fffbfb;">
            <div class="task-col-head">
                <div class="task-col-title-group">
                    <span class="task-col-dot overdue"></span>
                    <span style="color:#b91c1c;">Overdue</span>
                </div>
                <span class="task-col-badge" style="background:#fee2e2; color:#b91c1c; border-color:#fca5a5;">${fn:length(kanbanColumns.OVERDUE)}</span>
            </div>
            <div style="display:flex; flex-direction:column; gap:10px;">
                <c:forEach var="t" items="${kanbanColumns.OVERDUE}">
                    <div class="task-card-item priority-${fn:toLowerCase(t.priority.name())}" style="background:#ffffff; border-color:#fecaca;">
                        <div class="task-card-title" style="color:#991b1b;"><c:out value="${t.title}"/></div>
                        <c:if test="${t.milestoneTitle != null}">
                            <div class="task-ms-chip" style="background:#fee2e2; color:#991b1b;">¶ <c:out value="${t.milestoneTitle}"/></div>
                        </c:if>
                        <div class="task-card-bottom">
                            <span class="task-assignee-pill" title="${t.assigneeName}">
                                <span class="task-avatar-circle" style="background:#b91c1c;">${t.assigneeInitials}</span>
                                <span><c:out value="${t.assigneeName}"/></span>
                            </span>
                            <span class="task-due-chip is-overdue">${t.dueDate} (Overdue)</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/project/task/status" method="post" style="margin:0;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${project.id}">
                            <input type="hidden" name="taskId" value="${t.id}">
                            <select name="status" class="task-select-pill" style="border-color:#fca5a5;" onchange="this.form.submit()">
                                <option value="NOT_STARTED" ${t.status.name() == 'NOT_STARTED' ? 'selected' : ''}>Not Started</option>
                                <option value="IN_PROGRESS" ${t.status.name() == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                <option value="COMPLETED">Resolve Now ✓</option>
                            </select>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Tabular View in Modern Card -->
    <div class="overview-card" style="margin-top:2rem;">
        <div class="overview-card-header">
            <h3 class="overview-card-title">All Project Tasks (Tabular View)</h3>
            <span class="git-pill-badge">${fn:length(tasks)} Tasks</span>
        </div>
        <div class="table-container">
            <table class="table-ruled">
                <thead>
                    <tr>
                        <th>Task Title</th>
                        <th>Milestone Link</th>
                        <th>Assignee</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th class="num-col">Due Date</th>
                        <th class="num-col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${tasks}">
                        <tr>
                            <td>
                                <div style="font-weight:700; color:#18221b;"><c:out value="${t.title}"/></div>
                                <c:if test="${t.description != null and not empty t.description}">
                                    <div style="font-size:12px; color:#6b778c; margin-top:2px;"><c:out value="${t.description}"/></div>
                                </c:if>
                            </td>
                            <td><c:out value="${t.milestoneTitle != null ? t.milestoneTitle : '—'}"/></td>
                            <td>
                                <span class="task-assignee-pill">
                                    <span class="task-avatar-circle">${t.assigneeInitials}</span>
                                    <span><c:out value="${t.assigneeName != null ? t.assigneeName : 'Unassigned'}"/></span>
                                </span>
                            </td>
                            <td>
                                <span class="ms-status-pill ${t.priority.name() == 'HIGH' ? 'pending-review' : (t.priority.name() == 'MEDIUM' ? 'in-progress' : 'reviewed')}">
                                    ${t.priority.displayName}
                                </span>
                            </td>
                            <td>
                                <span class="ms-status-pill ${t.status.name() == 'COMPLETED' ? 'reviewed' : (t.overdue ? 'pending-review' : 'in-progress')}">
                                    ${t.status.displayName} ${t.overdue ? '(Overdue)' : ''}
                                </span>
                            </td>
                            <td class="num-col">
                                <span class="mono-text ${t.overdue ? 'task-due-chip is-overdue' : ''}">${t.dueDate}</span>
                            </td>
                            <td class="num-col">
                                <c:if test="${canManage}">
                                    <form action="${pageContext.request.contextPath}/project/task/delete" method="post" style="display:inline;">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="projectId" value="${project.id}">
                                        <input type="hidden" name="taskId" value="${t.id}">
                                        <button type="submit" class="btn-inline" style="color:#dc2626; font-weight:700;" data-confirm="Delete task '${t.title}'?">Remove</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<!-- =========================================================================
     TAB 3: MILESTONES (Syllabus Timeline)
     ========================================================================= -->
<c:if test="${activeTab == 'milestones'}">
    <div class="ms-container">
        <!-- 1. Top Header Row -->
        <div class="ms-header-row">
            <div>
                <h2 class="section-title" style="margin-bottom:0.25rem;">Academic Syllabus Milestones</h2>
                <div style="font-size:0.867rem; color:var(--muted);">
                    Ordered developmental phases evaluated for continuous academic progress.
                </div>
            </div>
            <c:if test="${canManage}">
                <button type="button" class="btn btn-primary" onclick="document.getElementById('newMilestoneDrawer').style.display = 'block';" style="border-radius:24px; padding:8px 18px; font-weight:700;">
                    + Add Milestone
                </button>
            </c:if>
        </div>

        <!-- 2. New Milestone Drawer -->
        <c:if test="${canManage}">
            <div id="newMilestoneDrawer" class="panel" style="display:none; margin-bottom:1.5rem; background-color:#ffffff; border:1px solid #e3e8df; border-radius:20px; padding:24px;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
                    <h3 style="font-size:16px; font-weight:800; color:#18221b; margin:0;">Add Academic Milestone</h3>
                    <button type="button" class="btn-inline" onclick="document.getElementById('newMilestoneDrawer').style.display = 'none';" style="font-size:13px; font-weight:600; color:#6b778c;">× Close</button>
                </div>
                <form action="${pageContext.request.contextPath}/project/milestone/save" method="post">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <input type="hidden" name="projectId" value="${project.id}">

                    <div class="form-group" style="margin-bottom:14px;">
                        <label class="form-label" for="mTitle">Milestone Title</label>
                        <input type="text" id="mTitle" name="title" class="form-input" placeholder="e.g. Architecture &amp; System Design" required>
                    </div>

                    <div class="form-group" style="margin-bottom:14px;">
                        <label class="form-label" for="mDesc">Deliverables Description</label>
                        <textarea id="mDesc" name="description" class="form-textarea" placeholder="Detail milestone artifacts to be presented..."></textarea>
                    </div>

                    <div class="form-grid-2" style="margin-bottom:18px;">
                        <div class="form-group">
                            <label class="form-label" for="mTarget">Target Date</label>
                            <input type="date" id="mTarget" name="targetDate" class="form-input mono-text" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="mOrder">Sequence Order</label>
                            <input type="number" id="mOrder" name="sortOrder" class="form-input mono-text" value="${fn:length(milestones) + 1}" min="1">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" style="border-radius:20px; padding:8px 20px; font-weight:700;">Save Milestone</button>
                </form>
            </div>
        </c:if>

        <!-- 3. Progress Stepper Bar -->
        <c:if test="${not empty milestones}">
            <div class="ms-stepper-card">
                <div class="ms-stepper-track">
                    <c:forEach var="m" items="${milestones}" varStatus="status">
                        <div class="ms-step-node-wrap">
                            <c:if test="${!status.last}">
                                <div class="ms-step-connector ${m.completed ? 'completed' : ''}"></div>
                            </c:if>
                            <div class="ms-step-circle ${m.reviewStatus == 'REVIEWED' ? 'done' : (m.completed ? 'pending' : '')}">
                                <c:choose>
                                    <c:when test="${m.reviewStatus == 'REVIEWED'}">&#10003;</c:when>
                                    <c:otherwise>${m.sortOrder}</c:otherwise>
                                </c:choose>
                            </div>
                            <span class="ms-step-label">${m.title}</span>
                            <span class="ms-step-sub">${m.targetDate}</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <!-- 4. Clean Milestone Cards List (Fixes the ugly squished text) -->
        <div class="ms-list">
            <c:forEach var="m" items="${milestones}">
                <div class="ms-card">
                    <!-- Top Line: Step number, Title, Status badge, and Actions -->
                    <div class="ms-card-top">
                        <div class="ms-card-title-group">
                            <div class="ms-badge-circle ${m.reviewStatus == 'REVIEWED' ? 'done' : (m.completed ? 'pending' : 'open')}">
                                <c:choose>
                                    <c:when test="${m.reviewStatus == 'REVIEWED'}">&#10003;</c:when>
                                    <c:when test="${m.completed}">&#9679;</c:when>
                                    <c:otherwise>${m.sortOrder}</c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
                                    <span class="ms-title-text">${m.sortOrder}. <c:out value="${m.title}"/></span>
                                    <c:choose>
                                        <c:when test="${m.reviewStatus == 'REVIEWED'}">
                                            <span class="ms-status-pill reviewed">
                                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                Reviewed by Faculty
                                            </span>
                                        </c:when>
                                        <c:when test="${m.completed}">
                                            <span class="ms-status-pill pending-review">
                                                <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                                Pending Review
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="ms-status-pill in-progress">In Progress</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="ms-actions-group">
                            <!-- Faculty Sign-off Button -->
                            <c:if test="${sessionScope.currentUser.faculty and m.reviewStatus != 'REVIEWED'}">
                                <form action="${pageContext.request.contextPath}/faculty/milestone/review" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="projectId" value="${project.id}">
                                    <input type="hidden" name="milestoneId" value="${m.id}">
                                    <button type="submit" class="ms-btn-signoff">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        Sign-off &amp; Mark Reviewed
                                    </button>
                                </form>
                            </c:if>

                            <!-- Student / Lead Toggle Button -->
                            <c:if test="${canManage}">
                                <form action="${pageContext.request.contextPath}/project/milestone/complete" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="projectId" value="${project.id}">
                                    <input type="hidden" name="milestoneId" value="${m.id}">
                                    <input type="hidden" name="completed" value="${m.completed}">
                                    <button type="submit" class="ms-btn-toggle">
                                        ${m.completed ? 'Reopen Milestone' : 'Mark Complete'}
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>

                    <!-- Description -->
                    <div class="ms-desc-body">
                        <c:out value="${m.description}"/>
                    </div>

                    <!-- Bottom Meta Strip (Target Date, Formatted Completion Date, Linked Tasks) -->
                    <div class="ms-meta-bar">
                        <span class="ms-meta-chip">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            Target: <strong>${m.targetDate}</strong>
                        </span>

                        <c:if test="${m.completedAt != null}">
                            <span class="ms-meta-chip completed-date">
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                Completed: <strong class="js-ms-completed-time" data-raw="${m.completedAt}">${m.completedAt}</strong>
                            </span>
                        </c:if>

                        <span class="ms-meta-chip">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            Tasks Linked: <strong>${m.completedTasks} / ${m.totalTasks} completed</strong>
                        </span>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</c:if>

<!-- =========================================================================
     TAB 4: TEAM & CONTRIBUTIONS
     ========================================================================= -->
<c:if test="${activeTab == 'team'}">
    <!-- Header Row -->
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:1.5rem;">
        <div>
            <div style="display:flex; align-items:center; gap:10px;">
                <h2 class="section-title" style="margin-bottom:0;">Project Team &amp; Process Contributions</h2>
                <span class="git-pill-badge active-dot">${fn:length(teamMembers)} of 6 Members</span>
            </div>
            <div style="font-size:0.867rem; color:var(--muted); margin-top:4px;">
                Verified development contributions per student: sprint velocity, linked tasks, and Git commit evidence.
            </div>
        </div>
        <c:if test="${canManage and fn:length(teamMembers) lt 6}">
            <button type="button" class="btn btn-primary" onclick="document.getElementById('addMemberDrawer').style.display = 'block';"
                    style="display:inline-flex; align-items:center; gap:8px; border-radius:24px; padding:8px 18px; font-weight:700;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                <span>Add Member (${fn:length(teamMembers)}/6)</span>
            </button>
        </c:if>
    </div>

    <!-- Process Evidence Notice Box -->
    <div style="background:#f8faf7; border:1px solid #e3e8df; border-radius:16px; padding:14px 18px; margin-bottom:1.5rem; display:flex; align-items:center; gap:12px;">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1e4535" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
        <span style="font-size:13px; color:#374151;">
            <strong>Continuous Evaluation Policy:</strong> GitHub activity and task completion statistics are supporting evidence of active participation and continuous progress, evaluated under supervisor review.
        </span>
    </div>

    <!-- Add Member Form Drawer -->
    <c:if test="${canManage and fn:length(teamMembers) lt 6}">
        <div id="addMemberDrawer" class="overview-card" style="display:none; margin-bottom:1.5rem;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.25rem;">
                <h3 style="font-size:16px; font-weight:800; color:#18221b; margin:0;">Add Student Team Member</h3>
                <button type="button" class="btn-inline" onclick="document.getElementById('addMemberDrawer').style.display = 'none';" style="font-size:13px; font-weight:600; color:#6b778c;">× Close</button>
            </div>
            <form action="${pageContext.request.contextPath}/project/team/add" method="post">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="projectId" value="${project.id}">

                <div class="form-grid-2" style="margin-bottom:18px;">
                    <div class="form-group">
                        <label class="form-label" for="studentId">Student Email or Registration Number</label>
                        <input type="text" id="studentId" name="studentIdentifier" class="form-input" placeholder="e.g. 24BBS0135 or student2@projectledger.edu" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="responsibility">Assigned Responsibility</label>
                        <input type="text" id="responsibility" name="responsibility" class="form-input" placeholder="e.g. Backend API &amp; Test Suite" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" style="border-radius:20px; padding:8px 22px; font-weight:700;">Add Member to Ledger</button>
            </form>
        </div>
    </c:if>

    <!-- Student Team Member Cards Grid -->
    <div class="team-grid">
        <c:forEach var="ev" items="${evidenceList}">
            <div class="team-card">
                <div class="team-card-head">
                    <div class="team-avatar-lg">
                        ${fn:toUpperCase(fn:substring(ev.member.userName, 0, 1))}
                    </div>
                    <div style="flex:1;">
                        <div class="team-name-title">
                            <c:out value="${ev.member.userName}"/>
                            <c:if test="${ev.member.userId == project.leaderId}">
                                <span class="team-lead-badge">Team Lead</span>
                            </c:if>
                        </div>
                        <div class="team-role-sub"><c:out value="${ev.member.responsibility}"/></div>
                    </div>
                </div>

                <!-- Registration & GitHub Tags -->
                <div style="display:flex; gap:8px; flex-wrap:wrap;">
                    <span class="mono-text" style="background:#f1f4ef; border:1px solid #dce3d8; padding:3px 10px; border-radius:12px; font-size:11.5px; color:#18221b;">
                        Reg: <c:out value="${ev.member.userRegNo != null ? ev.member.userRegNo : '—'}"/>
                    </span>
                    <c:choose>
                        <c:when test="${ev.member.userGithub != null}">
                            <a href="https://github.com/${ev.member.userGithub}" target="_blank" rel="noopener noreferrer" class="git-pill-badge" style="font-size:11.5px; text-decoration:none; padding:3px 10px;">
                                @${ev.member.userGithub} ↗
                            </a>
                        </c:when>
                        <c:otherwise>
                            <span class="mono-text" style="color:#7d899b; font-size:11.5px; padding:3px 0;">No GitHub linked</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Velocity Stats Box -->
                <div class="team-stats-box">
                    <div>
                        <div class="team-stat-item-label">Tasks Completed</div>
                        <div class="team-stat-item-val" style="color:#1e4535;">
                            ${ev.tasksCompleted} <span style="font-size:12px; font-weight:500; color:#6b778c;">/ ${ev.tasksAssigned}</span>
                        </div>
                    </div>
                    <div>
                        <div class="team-stat-item-label">Verified Commits</div>
                        <div class="team-stat-item-val">${ev.commitCount}</div>
                    </div>
                </div>

                <!-- Completion Progress Bar -->
                <div>
                    <div style="display:flex; justify-content:space-between; font-size:11.5px; margin-bottom:6px;">
                        <span style="font-weight:600; color:#6b778c;">Task Completion Rate</span>
                        <span class="mono-text" style="font-weight:700; color:#18221b;">${ev.completionRatePercent}%</span>
                    </div>
                    <div style="background:#e8ece5; height:6px; border-radius:3px; overflow:hidden;">
                        <div style="background:#1e4535; height:100%; width:${ev.completionRatePercent}%; border-radius:3px;"></div>
                    </div>
                </div>

                <!-- Remove Button (if leader/admin and not self) -->
                <c:if test="${canManage and ev.member.userId != project.leaderId}">
                    <div style="padding-top:10px; border-top:1px solid #f2f5f0; text-align:right;">
                        <form action="${pageContext.request.contextPath}/project/team/remove" method="post" style="display:inline;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${project.id}">
                            <input type="hidden" name="userId" value="${ev.member.userId}">
                            <button type="submit" class="btn-inline" style="color:#dc2626; font-size:12px; font-weight:700;" data-confirm="Remove '${ev.member.userName}' from the project team?">
                                Remove Member
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</c:if>

<!-- =========================================================================
     TAB 5: GITHUB ACTIVITY
     ========================================================================= -->
<c:if test="${activeTab == 'activity'}">
    <div class="git-container">
        <!-- 1. Top Section Header & Actions -->
        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:0.5rem;">
            <div>
                <div style="display:flex; align-items:center; gap:8px;">
                    <h2 class="section-title" style="margin-bottom:0;">GitHub Development Activity</h2>
                    <c:if test="${project.repoOwner != null}">
                        <a href="https://github.com/${project.repoOwner}/${project.repoName}" target="_blank" rel="noopener noreferrer" class="git-pill-badge" style="text-decoration:none;">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path>
                            </svg>
                            <span>${project.repoOwner}/${project.repoName}</span>
                            <span style="font-size:11px;">↗</span>
                        </a>
                    </c:if>
                </div>
                <div style="font-size:0.867rem; color:var(--muted); margin-top:4px;">
                    Synchronized commit timeline, daily delivery velocity, and contributor evidence.
                </div>
            </div>
            <c:if test="${project.repoOwner != null}">
                <form action="${pageContext.request.contextPath}/project/github/sync" method="post" style="display:inline;">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <input type="hidden" name="projectId" value="${project.id}">
                    <button type="submit" class="btn btn-primary" style="display:inline-flex; align-items:center; gap:8px; border-radius:24px; padding:8px 18px; font-weight:700;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="23 4 23 10 17 10"></polyline>
                            <polyline points="1 20 1 14 7 14"></polyline>
                            <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                        </svg>
                        <span>Sync Now</span>
                    </button>
                </form>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${project.repoOwner == null}">
                <div class="empty-state" style="background:#ffffff; border-radius:20px; border:1px solid #e3e8df; padding:48px 24px;">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#6b778c" stroke-width="1.5" style="margin-bottom:12px;">
                        <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path>
                    </svg>
                    <h3 style="font-size:16px; font-weight:800; color:#18221b; margin-bottom:6px;">No GitHub repository connected</h3>
                    <p class="empty-state-text" style="color:#6b778c; max-width:440px; margin:0 auto 16px;">
                        Link your team repository in the project settings to enable automatic commit imports, contributor velocity tracking, and process auditing.
                    </p>
                    <c:if test="${canManage}">
                        <a href="${pageContext.request.contextPath}/project?id=${project.id}&amp;tab=overview" class="btn btn-secondary">Configure Repository in Overview →</a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <!-- 2. KPI Metrics Strip -->
                <div class="git-kpi-grid">
                    <div class="git-kpi-card">
                        <div class="git-kpi-icon-box forest">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="4"></circle><line x1="1.05" y1="12" x2="7" y2="12"></line><line x1="17.01" y1="12" x2="22.96" y2="12"></line></svg>
                        </div>
                        <div>
                            <div class="git-kpi-val">${fn:length(commits)}</div>
                            <div class="git-kpi-label">Synchronized Commits</div>
                        </div>
                    </div>
                    <div class="git-kpi-card">
                        <div class="git-kpi-icon-box soft">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="6" y1="3" x2="6" y2="15"></line><circle cx="18" cy="6" r="3"></circle><circle cx="6" cy="18" r="3"></circle><path d="M18 9a9 9 0 0 1-9 9"></path></svg>
                        </div>
                        <div>
                            <div class="git-kpi-val">${fn:length(branches)}</div>
                            <div class="git-kpi-label">Active Branches</div>
                        </div>
                    </div>
                    <div class="git-kpi-card">
                        <div class="git-kpi-icon-box lime">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </div>
                        <div>
                            <div class="git-kpi-val">${fn:length(contributors)}</div>
                            <div class="git-kpi-label">Active Contributors</div>
                        </div>
                    </div>
                    <div class="git-kpi-card">
                        <div class="git-kpi-icon-box obsidian">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>
                        <div>
                            <div class="git-kpi-val" style="font-size:16px;">
                                <c:choose>
                                    <c:when test="${fn:length(commits) gt 0}">Active</c:when>
                                    <c:otherwise>Standby</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="git-kpi-label">Pipeline Sync</div>
                        </div>
                    </div>
                </div>

                <!-- 3. Commit Frequency (Last 30 Days) Capsule Bar Chart -->
                <div class="git-card">
                    <div class="git-card-header">
                        <div class="git-card-title-group">
                            <h3>Commit Frequency (Last 30 Days)</h3>
                            <p>Daily development volume and commit regularity across all contributors.</p>
                        </div>
                        <span class="git-pill-badge active-dot">
                            ${fn:length(commits)} Total Synchronized Commits
                        </span>
                    </div>

                    <div class="git-chart-container">
                        <div class="git-chart-canvas">
                            <c:forEach var="entry" items="${dailyCommits}">
                                <div class="git-bar-col" data-tooltip="${entry.key}: ${entry.value} commit<c:if test="${entry.value != 1}">s</c:if>">
                                    <c:choose>
                                        <c:when test="${entry.value gt 0}">
                                            <!-- Scaled capsule bar -->
                                            <div class="git-bar-capsule ${entry.value ge 4 ? 'high' : ''}"
                                                 style="height: ${entry.value * 12 + 14 gt 72 ? 72 : (entry.value * 12 + 14)}px;"></div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Discrete baseline tick -->
                                            <div class="git-bar-baseline"></div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="git-chart-axis">
                            <span>30 days ago</span>
                            <span>15 days ago</span>
                            <span>Today</span>
                        </div>
                    </div>
                </div>

                <!-- 4. Active Branches & GitHub Contributors Strip -->
                <div class="git-details-grid">
                    <!-- Branches Card -->
                    <div class="git-subcard">
                        <div class="git-subcard-header">
                            <span class="git-subcard-title">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="6" y1="3" x2="6" y2="15"></line><circle cx="18" cy="6" r="3"></circle><circle cx="6" cy="18" r="3"></circle><path d="M18 9a9 9 0 0 1-9 9"></path></svg>
                                <span>Active Repository Branches</span>
                            </span>
                            <span class="git-pill-badge" style="font-size:11px; padding:2px 8px;">${fn:length(branches)}</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty branches}">
                                <div class="git-tags-wrap">
                                    <c:forEach var="b" items="${branches}">
                                        <span class="git-branch-tag ${b == 'main'  or  b == 'master' ? 'main-branch' : ''}">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="6" y1="3" x2="6" y2="15"></line><circle cx="18" cy="6" r="3"></circle><circle cx="6" cy="18" r="3"></circle><path d="M18 9a9 9 0 0 1-9 9"></path></svg>
                                            ${b}
                                            <c:if test="${b == 'main'  or  b == 'master'}">
                                                <span class="default-badge">DEFAULT</span>
                                            </c:if>
                                        </span>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span style="font-size:0.867rem; color:var(--muted);">No live branches fetched (using default branch).</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Contributors Card -->
                    <div class="git-subcard">
                        <div class="git-subcard-header">
                            <span class="git-subcard-title">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                <span>GitHub Contributors</span>
                            </span>
                            <span class="git-pill-badge" style="font-size:11px; padding:2px 8px;">${fn:length(contributors)}</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty contributors}">
                                <div class="git-tags-wrap">
                                    <c:forEach var="c" items="${contributors}">
                                        <a href="https://github.com/${c}" target="_blank" rel="noopener noreferrer" class="git-contributor-chip" title="View GitHub profile">
                                            <span class="git-contrib-avatar">
                                                ${fn:toUpperCase(fn:substring(c, 0, 1))}
                                            </span>
                                            <span>@${c}</span>
                                            <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                                        </a>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span style="font-size:0.867rem; color:var(--muted);">No external contributors fetched.</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 5. Commit Log / Development Timeline (Replaces the raw unstyled text!) -->
                <div class="git-card">
                    <div class="git-card-header">
                        <div class="git-card-title-group">
                            <h3>Commit Log</h3>
                            <p>Continuous process commit history synchronized directly from Git repository.</p>
                        </div>
                        <span class="git-pill-badge">
                            ${fn:length(commits)} Commits Recorded
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${empty commits}">
                            <div class="empty-state" style="padding:32px 16px;">
                                <p class="empty-state-text" style="color:var(--muted); margin-bottom:12px;">No commits synchronized yet.</p>
                                <form action="${pageContext.request.contextPath}/project/github/sync" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="projectId" value="${project.id}">
                                    <button type="submit" class="btn btn-secondary btn-sm">Click here to import from GitHub</button>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Structured Git Timeline -->
                            <div class="git-timeline">
                                <c:forEach var="cm" items="${commits}">
                                    <div class="git-commit-entry">
                                        <div class="git-commit-node" title="Commit ${cm.shortSha}"></div>
                                        <div class="git-commit-card">
                                            <!-- Top Line: Commit Message & Actions -->
                                            <div class="git-commit-top">
                                                <div class="git-commit-msg-wrap">
                                                    <span class="git-commit-msg-text js-git-msg" title="${cm.message}">
                                                        <c:out value="${cm.firstLineMessage}"/>
                                                    </span>
                                                </div>

                                                <div class="git-commit-actions">
                                                    <a href="${cm.htmlUrl}" target="_blank" rel="noopener noreferrer" class="git-sha-badge" title="View commit on GitHub">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="4"></circle><line x1="1.05" y1="12" x2="7" y2="12"></line><line x1="17.01" y1="12" x2="22.96" y2="12"></line></svg>
                                                        <code>${cm.shortSha}</code>
                                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="7" y1="17" x2="17" y2="7"></line><polyline points="7 7 17 7 17 17"></polyline></svg>
                                                    </a>
                                                    <button type="button" class="git-copy-btn js-copy-sha" data-sha="${cm.sha}" title="Copy full SHA">
                                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>
                                                    </button>
                                                </div>
                                            </div>

                                            <!-- Bottom Meta Line: Author, Timestamp, Verification -->
                                            <div class="git-commit-meta">
                                                <c:choose>
                                                    <c:when test="${cm.authorLogin != null}">
                                                        <a href="https://github.com/${cm.authorLogin}" target="_blank" rel="noopener noreferrer" class="git-author-info">
                                                            <span class="git-author-circle">
                                                                ${fn:toUpperCase(fn:substring(cm.authorLogin, 0, 1))}
                                                            </span>
                                                            <span>@${cm.authorLogin}</span>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="git-author-info">
                                                            <span class="git-author-circle">
                                                                ${fn:toUpperCase(fn:substring(cm.authorName, 0, 1))}
                                                            </span>
                                                            <span><c:out value="${cm.authorName}"/></span>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <span class="git-time-tag">
                                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                                    <time class="js-commit-time" datetime="${cm.committedAt}">${cm.committedAt}</time>
                                                </span>

                                                <span class="git-verified-pill">
                                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                    Verified
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</c:if>

<!-- =========================================================================
     TAB 6: FACULTY FEEDBACK & EVALUATION
     ========================================================================= -->
<c:if test="${activeTab == 'feedback'}">
    <!-- Header Row -->
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:1.5rem;">
        <div>
            <div style="display:flex; align-items:center; gap:10px;">
                <h2 class="section-title" style="margin-bottom:0;">Supervisory Feedback &amp; Evaluation</h2>
                <span class="git-pill-badge active-dot">${fn:length(feedbackList)} Records</span>
            </div>
            <div style="font-size:0.867rem; color:var(--muted); margin-top:4px;">
                Continuous process reviews, milestone scorecards, and supervisory qualitative guidance.
            </div>
        </div>
    </div>

    <!-- Faculty Add Feedback Form (Visible only to assigned faculty or admin) -->
    <c:if test="${sessionScope.currentUser.faculty  or  sessionScope.currentUser.admin}">
        <div class="overview-card" style="margin-bottom:1.5rem;">
            <div class="overview-card-header">
                <h3 class="overview-card-title">Record Process Evaluation</h3>
                <span class="git-pill-badge">Supervisor Portal</span>
            </div>
            <form action="${pageContext.request.contextPath}/faculty/feedback/save" method="post">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="projectId" value="${project.id}">

                <div class="form-grid-2" style="margin-bottom:14px;">
                    <div class="form-group">
                        <label class="form-label" for="fbMilestone">Associate with Milestone (Optional)</label>
                        <select id="fbMilestone" name="milestoneId" class="form-select">
                            <option value="">-- General Project Review --</option>
                            <c:forEach var="m" items="${milestones}">
                                <option value="${m.id}"><c:out value="${m.title}"/> (${m.reviewStatus})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="fbScore">Evaluation Score (0.0 to 10.0)</label>
                        <input type="number" id="fbScore" name="score" class="form-input mono-text" step="0.1" min="0" max="10" placeholder="e.g. 8.5">
                    </div>
                </div>

                <div class="form-group" style="margin-bottom:14px;">
                    <label class="form-label" for="fbComment">Faculty Guidance &amp; Observations</label>
                    <textarea id="fbComment" name="comment" class="form-textarea" rows="3" placeholder="Note development strengths, architectural bottlenecks, and required improvements..." required></textarea>
                </div>

                <div class="form-group" style="margin-bottom:18px;">
                    <label style="display:flex; align-items:center; gap:8px; font-size:13px; font-weight:600; color:#18221b; cursor:pointer;">
                        <input type="checkbox" name="markReviewed" value="true" checked style="accent-color:#1e4535; width:16px; height:16px;">
                        <span>Mark associated milestone as formally reviewed by faculty</span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary" style="border-radius:20px; padding:8px 22px; font-weight:700;">Submit Evaluation</button>
            </form>
        </div>
    </c:if>

    <!-- Feedback Entries List -->
    <c:choose>
        <c:when test="${empty feedbackList}">
            <div class="overview-card" style="text-align:center; padding:48px 24px;">
                <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="#6b778c" stroke-width="1.5" style="margin-bottom:12px;">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                </svg>
                <h3 style="font-size:16px; font-weight:800; color:#18221b; margin-bottom:6px;">No feedback recorded yet</h3>
                <p class="empty-state-text" style="color:#6b778c; max-width:440px; margin:0 auto;">
                    Supervisors can log reviews, qualitative guidance, and milestone ratings to document continuous academic progress.
                </p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="feedback-grid">
                <c:forEach var="fb" items="${feedbackList}">
                    <div class="feedback-card">
                        <div class="feedback-card-top">
                            <div class="feedback-author-row">
                                <div class="feedback-avatar">
                                    ${fn:toUpperCase(fn:substring(fb.facultyName, 0, 1))}
                                </div>
                                <div>
                                    <div class="feedback-name">
                                        <c:out value="${fb.facultyName}"/>
                                        <c:if test="${fb.milestoneTitle != null}">
                                            <span class="feedback-milestone-tag">
                                                ¶ Milestone: <c:out value="${fb.milestoneTitle}"/>
                                            </span>
                                        </c:if>
                                    </div>
                                    <div style="font-size:11.5px; color:#6b778c;">Faculty Supervisory Evaluation</div>
                                </div>
                            </div>

                            <c:if test="${fb.score != null}">
                                <div class="feedback-score-pill">
                                    Score: ${fb.score} / 10.0
                                </div>
                            </c:if>
                        </div>

                        <p class="feedback-comment-text">
                            <c:out value="${fb.comment}"/>
                        </p>

                        <div class="feedback-card-footer">
                            <span style="font-weight:600; color:#1e4535; display:inline-flex; align-items:center; gap:5px;">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                Formal Process Assessment
                            </span>
                            <span class="mono-text js-fb-time" data-raw="${fb.createdAt}">${fb.createdAt}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </c:otherwise>
    </c:choose>
</c:if>

<script src="${pageContext.request.contextPath}/assets/js/project-view.js"></script>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
