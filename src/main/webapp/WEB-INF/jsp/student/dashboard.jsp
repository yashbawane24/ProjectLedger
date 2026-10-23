<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<!-- ========================================================================= -->
<!-- SECTION 1: DASHBOARD OVERVIEW                                            -->
<!-- ========================================================================= -->
<div id="student-section-overview" class="student-section" style="${activeSection == 'overview' or empty activeSection ? 'display:block;' : 'display:none;'}">
    <!-- Dashboard Header Banner -->
    <div class="dash-header-row">
        <div>
            <h1 class="dash-header-title">Hello, <c:out value="${sessionScope.currentUser.name}"/></h1>
            <div class="dash-header-sub">
                Continuous development ledger · <c:out value="${fn:length(taskGroups.overdue)}"/> overdue tasks require your attention.
            </div>
        </div>
        <div class="dash-btn-group">
            <a href="${pageContext.request.contextPath}/student/projects/new" class="dash-btn-forest">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Register New Project</span>
            </a>
        </div>
    </div>

    <!-- Top 4 KPI Metric Cards -->
    <div class="kpi-grid-4">
        <!-- Card 1: Active Projects -->
        <a href="${pageContext.request.contextPath}/student/dashboard?section=projects" onclick="switchSection('projects', event)" class="kpi-card-forest">
            <div class="kpi-forest-top">
                <span class="kpi-forest-title">Active Projects</span>
                <div class="kpi-arrow-white">↗</div>
            </div>
            <div>
                <div class="kpi-forest-val">${fn:length(projects)}</div>
                <div class="kpi-forest-sub">Enrolled development teams</div>
            </div>
        </a>

        <!-- Card 2: Assigned Tasks -->
        <a href="${pageContext.request.contextPath}/student/dashboard?section=tasks" onclick="switchSection('tasks', event)" class="kpi-card-white" style="text-decoration:none; color:inherit;">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Assigned Tasks</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${fn:length(taskGroups.overdue) + fn:length(taskGroups.thisWeek) + fn:length(taskGroups.later)}</div>
                <div class="kpi-white-sub">Active tasks in sprint pipeline</div>
            </div>
        </a>

        <!-- Card 3: Action Required -->
        <a href="${pageContext.request.contextPath}/student/dashboard?section=tasks" onclick="switchSection('tasks', event)" class="kpi-card-white" style="text-decoration:none; color:inherit;">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Action Required</span>
                <span class="kpi-dot orange"></span>
            </div>
            <div>
                <div class="kpi-white-val">${fn:length(taskGroups.overdue)}</div>
                <div class="kpi-white-sub orange">Overdue milestone items</div>
            </div>
        </a>

        <!-- Card 4: Completed -->
        <a href="${pageContext.request.contextPath}/student/dashboard?section=tasks" onclick="switchSection('tasks', event)" class="kpi-card-white" style="text-decoration:none; color:inherit;">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Completed</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${fn:length(taskGroups.completed)}</div>
                <div class="kpi-white-sub">Tasks marked done</div>
            </div>
        </a>
    </div>

    <!-- Projects Overview Row -->
    <div class="ruled-section" style="margin-top: 1.5rem;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
            <h2 class="chart-title" style="margin-bottom:0;">Enrolled Academic Projects</h2>
            <a href="${pageContext.request.contextPath}/student/dashboard?section=projects" onclick="switchSection('projects', event)" class="dash-btn-outline" style="padding: 4px 12px; font-size: 12px;">
                View All Projects (${fn:length(projects)}) →
            </a>
        </div>

        <c:choose>
            <c:when test="${empty projects}">
                <div class="empty-state">
                    <p class="empty-state-text">You have not registered or joined any academic projects yet.</p>
                    <a href="${pageContext.request.contextPath}/student/projects/new" class="dash-btn-forest" style="display:inline-flex; margin-top:10px;">Register your first project</a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 1.25rem;">
                    <c:forEach var="p" items="${projects}">
                        <div class="middle-card-white" style="margin-bottom:0; display:flex; flex-direction:column; justify-content:space-between;">
                            <div>
                                <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:0.5rem; margin-bottom:0.75rem;">
                                    <h3 style="font-size:1.15rem; font-weight:700;">
                                        <a href="${pageContext.request.contextPath}/project?id=${p.id}" style="color:var(--navy); text-decoration:none;">
                                            <c:out value="${p.title}"/>
                                        </a>
                                    </h3>
                                    <span class="status-chip-pill ${p.health.name() == 'DELAYED' ? 'delayed' : (p.health.name() == 'AT_RISK' ? 'at-risk' : 'on-track')}">
                                        • <c:out value="${p.health.displayName}"/>
                                    </span>
                                </div>

                                <p style="font-size:0.867rem; color:var(--muted); margin-bottom:1.25rem; line-height:1.45;">
                                    <c:out value="${p.description}"/>
                                </p>

                                <!-- Progress with Striped Track & Expected Tick Mark -->
                                <div style="margin-bottom:1.25rem;">
                                    <div style="display:flex; justify-content:space-between; align-items:baseline; margin-bottom:6px; font-size:12px;">
                                        <span style="font-weight:600; color:var(--navy);">Overall Progress</span>
                                        <span style="font-weight:700; color:var(--navy);">${p.overallProgress}% <span style="font-weight:400; color:var(--muted);">(Expected ${p.expectedProgress}%)</span></span>
                                    </div>
                                    <div class="striped-bar-track" style="width:100%; height:9px;" title="Expected: ${p.expectedProgress}%">
                                        <div class="striped-bar-fill" style="width: ${p.overallProgress}%;"></div>
                                        <div class="striped-bar-tick" style="left: ${p.expectedProgress}%;"></div>
                                    </div>
                                </div>
                            </div>

                            <div style="border-top:1px solid var(--line); padding-top:0.75rem; display:flex; justify-content:space-between; align-items:center; font-size:0.8rem; color:var(--muted);">
                                <div>
                                    <c:choose>
                                        <c:when test="${p.nextMilestoneTitle != null}">
                                            Next: <strong><c:out value="${p.nextMilestoneTitle}"/></strong>
                                        </c:when>
                                        <c:otherwise>
                                            Supervisor: <strong><c:out value="${p.facultyName != null ? p.facultyName : 'Unassigned'}"/></strong>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <a href="${pageContext.request.contextPath}/project?id=${p.id}" class="dash-btn-outline" style="padding:4px 12px; font-size:12px;">Open Ledger →</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Snapshot of Tasks & Deadlines -->
    <div class="form-grid-2" style="margin-top: 1.5rem;">
        <!-- Left: Quick Tasks Snapshot -->
        <div class="middle-card-white">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                <h3 class="chart-title" style="margin-bottom:0;">Sprint Tasks Priority</h3>
                <a href="${pageContext.request.contextPath}/student/dashboard?section=tasks" onclick="switchSection('tasks', event)" class="chart-meta" style="color:var(--forest); font-weight:700;">Open Tasks Board →</a>
            </div>
            <c:choose>
                <c:when test="${empty taskGroups.overdue and empty taskGroups.thisWeek}">
                    <p style="color:var(--muted); font-size:13px; margin:0;">No urgent tasks currently due this week.</p>
                </c:when>
                <c:otherwise>
                    <div style="display:flex; flex-direction:column; gap:8px;">
                        <c:forEach var="t" items="${taskGroups.overdue}" end="2">
                            <div style="padding:10px 12px; background:#fff5f5; border-left:3px solid #dc2626; border-radius:6px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="font-weight:600; font-size:13px; color:var(--navy);"><c:out value="${t.title}"/></div>
                                    <div style="font-size:11px; color:#dc2626;">Overdue · Due ${t.dueDate}</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/project?id=${t.projectId}&amp;tab=tasks" class="dash-btn-outline" style="padding:3px 8px; font-size:11px;">View</a>
                            </div>
                        </c:forEach>
                        <c:forEach var="t" items="${taskGroups.thisWeek}" end="2">
                            <div style="padding:10px 12px; background:#fbfdf9; border-left:3px solid var(--forest); border-radius:6px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="font-weight:600; font-size:13px; color:var(--navy);"><c:out value="${t.title}"/></div>
                                    <div style="font-size:11px; color:var(--muted);">Due ${t.dueDate}</div>
                                </div>
                                <a href="${pageContext.request.contextPath}/project?id=${t.projectId}&amp;tab=tasks" class="dash-btn-outline" style="padding:3px 8px; font-size:11px;">View</a>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Right: Upcoming Deadlines Snapshot -->
        <div class="middle-card-white">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                <h3 class="chart-title" style="margin-bottom:0;">Upcoming Academic Deadlines</h3>
                <a href="${pageContext.request.contextPath}/student/dashboard?section=deadlines" onclick="switchSection('deadlines', event)" class="chart-meta" style="color:var(--forest); font-weight:700;">Full Calendar →</a>
            </div>
            <c:choose>
                <c:when test="${empty upcomingDeadlines}">
                    <p style="color:var(--muted); font-size:13px; margin:0;">No upcoming deadlines scheduled.</p>
                </c:when>
                <c:otherwise>
                    <div style="display:flex; flex-direction:column; gap:8px;">
                        <c:forEach var="d" items="${upcomingDeadlines}" end="3">
                            <div style="padding:10px 12px; border:1px solid var(--line); border-radius:8px; display:flex; justify-content:space-between; align-items:center;">
                                <div>
                                    <div style="font-weight:600; font-size:13px; color:var(--navy);"><c:out value="${d.title}"/></div>
                                    <div style="font-size:11.5px; color:var(--muted);">
                                        <c:choose>
                                            <c:when test="${d.global}">University Global</c:when>
                                            <c:otherwise><c:out value="${d.projectTitle}"/></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <span class="mono-text" style="font-size:12px; font-weight:700; color:var(--forest);">${d.dueDate}</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- SECTION 2: DEDICATED MY PROJECTS VIEW                                     -->
<!-- ========================================================================= -->
<div id="student-section-projects" class="student-section" style="${activeSection == 'projects' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/student/dashboard?section=overview" onclick="switchSection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Projects Directory</span>
            </div>
            <h1 class="dash-header-title">My Academic Projects</h1>
            <div class="dash-header-sub">
                All development ledgers, git commits, milestone deliverables, and supervisory oversight assigned to you.
            </div>
        </div>
        <div class="dash-btn-group">
            <a href="${pageContext.request.contextPath}/student/projects/new" class="dash-btn-forest">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                <span>Register New Project</span>
            </a>
        </div>
    </div>

    <!-- Filter Pills for Projects -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem; flex-wrap: wrap; gap: 10px;">
        <div class="filter-pills-bar" style="margin-bottom: 0;">
            <button type="button" class="filter-pill-tab active" onclick="filterStudentProjects('all', this)">All Projects · ${fn:length(projects)}</button>
            <button type="button" class="filter-pill-tab" onclick="filterStudentProjects('on-track', this)">On Track</button>
            <button type="button" class="filter-pill-tab" onclick="filterStudentProjects('at-risk', this)">At Risk</button>
            <button type="button" class="filter-pill-tab" onclick="filterStudentProjects('delayed', this)">Delayed</button>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty projects}">
            <div class="empty-state" style="padding: 4rem 2rem; background: #ffffff; border-radius: 16px; border: 1px solid var(--line);">
                <div style="font-size: 2.5rem; margin-bottom: 1rem;">📁</div>
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--navy); margin-bottom: 0.5rem;">No Academic Projects Enrolled</h3>
                <p class="empty-state-text" style="max-width: 460px; margin: 0 auto 1.5rem auto;">You are not enrolled in any development projects yet. Register a new academic project ledger to begin tracking syllabus milestones and code commits.</p>
                <a href="${pageContext.request.contextPath}/student/projects/new" class="dash-btn-forest" style="display: inline-flex;">Register New Project</a>
            </div>
        </c:when>
        <c:otherwise>
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 1.25rem;">
                <c:forEach var="p" items="${projects}">
                    <div class="middle-card-white student-project-card status-${fn:toLowerCase(p.health.name())}" 
                         style="border-radius: 16px; padding: 1.5rem; display: flex; flex-direction: column; justify-content: space-between; margin-bottom: 0; box-shadow: 0 4px 16px rgba(0,0,0,0.03);">
                        <div>
                            <!-- Header with Title & Health Badge -->
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 0.75rem; margin-bottom: 0.75rem;">
                                <h3 style="font-size: 1.15rem; font-weight: 700; line-height: 1.35; margin: 0;">
                                    <a href="${pageContext.request.contextPath}/project?id=${p.id}" style="color: var(--navy); text-decoration: none;">
                                        <c:out value="${p.title}"/>
                                    </a>
                                </h3>
                                <span class="status-chip-pill ${p.health.name() == 'DELAYED' ? 'delayed' : (p.health.name() == 'AT_RISK' ? 'at-risk' : 'on-track')}" style="flex-shrink: 0;">
                                    • <c:out value="${p.health.displayName}"/>
                                </span>
                            </div>

                            <!-- Abstract / Description -->
                            <p style="font-size: 0.875rem; color: var(--muted); margin-bottom: 1.25rem; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                <c:out value="${p.description}"/>
                            </p>

                            <!-- Progress Track with Expected Tick Mark -->
                            <div style="margin-bottom: 1.25rem; background: #fafcfa; border: 1px solid #e7ebe5; border-radius: 10px; padding: 12px 14px;">
                                <div style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 6px; font-size: 12px;">
                                    <span style="font-weight: 600; color: var(--navy);">Syllabus Progress</span>
                                    <span style="font-weight: 700; color: var(--navy);">${p.overallProgress}% <span style="font-weight: 400; color: var(--muted);">(Expected: ${p.expectedProgress}%)</span></span>
                                </div>
                                <div class="striped-bar-track" style="width: 100%; height: 9px;" title="Overall: ${p.overallProgress}% | Expected: ${p.expectedProgress}%">
                                    <div class="striped-bar-fill" style="width: ${p.overallProgress}%;"></div>
                                    <div class="striped-bar-tick" style="left: ${p.expectedProgress}%;"></div>
                                </div>
                            </div>

                            <!-- Faculty & Milestone Info -->
                            <div style="display: flex; flex-direction: column; gap: 6px; font-size: 12.5px; color: var(--text); margin-bottom: 1.25rem;">
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--muted);">Faculty Supervisor:</span>
                                    <strong><c:out value="${p.facultyName != null ? p.facultyName : 'Pending Assignment'}"/></strong>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: var(--muted);">Next Milestone:</span>
                                    <strong style="color: var(--forest);"><c:out value="${p.nextMilestoneTitle != null ? p.nextMilestoneTitle : 'All Completed'}"/></strong>
                                </div>
                                <c:if test="${p.repoUrl != null and fn:length(p.repoUrl) gt 0}">
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <span style="color: var(--muted);">Repository:</span>
                                        <a href="${p.repoUrl}" target="_blank" rel="noopener noreferrer" class="mono-text" style="color: var(--forest); text-decoration: underline; font-size: 11.5px;">GitHub ↗</a>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Card Footer Action -->
                        <div style="border-top: 1px solid var(--line); padding-top: 1rem; display: flex; justify-content: space-between; align-items: center;">
                            <span class="label-caps" style="color: var(--muted); font-size: 11px;">Week 11 Active</span>
                            <a href="${pageContext.request.contextPath}/project?id=${p.id}" class="dash-btn-forest" style="padding: 6px 16px; font-size: 12.5px;">
                                <span>Open Ledger</span>
                                <span style="color: var(--lime);">→</span>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- ========================================================================= -->
<!-- SECTION 3: DEDICATED MY TASKS VIEW                                       -->
<!-- ========================================================================= -->
<div id="student-section-tasks" class="student-section" style="${activeSection == 'tasks' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/student/dashboard?section=overview" onclick="switchSection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Tasks Board</span>
            </div>
            <h1 class="dash-header-title">My Development Tasks</h1>
            <div class="dash-header-sub">
                Sprint tasks, deliverable implementation items, and completion tracking across all your academic projects.
            </div>
        </div>
        <div class="dash-btn-group">
            <span class="status-chip-pill on-track" style="font-weight:700;">
                ${fn:length(taskGroups.completed)} Completed · ${fn:length(taskGroups.overdue) + fn:length(taskGroups.thisWeek) + fn:length(taskGroups.later)} Pending
            </span>
        </div>
    </div>

    <!-- Filter Tabs for Tasks -->
    <div class="filter-pills-bar" style="margin-bottom: 1.25rem;">
        <button type="button" class="filter-pill-tab active" onclick="filterTaskView('all', this)">All Tasks (${fn:length(taskGroups.overdue) + fn:length(taskGroups.thisWeek) + fn:length(taskGroups.later) + fn:length(taskGroups.completed)})</button>
        <button type="button" class="filter-pill-tab" onclick="filterTaskView('overdue', this)">Overdue (${fn:length(taskGroups.overdue)})</button>
        <button type="button" class="filter-pill-tab" onclick="filterTaskView('this-week', this)">Due This Week (${fn:length(taskGroups.thisWeek)})</button>
        <button type="button" class="filter-pill-tab" onclick="filterTaskView('later', this)">Later (${fn:length(taskGroups.later)})</button>
        <button type="button" class="filter-pill-tab" onclick="filterTaskView('completed', this)">Completed (${fn:length(taskGroups.completed)})</button>
    </div>

    <!-- Task Groups Container -->
    <div style="display: flex; flex-direction: column; gap: 1.5rem;">
        
        <!-- 1. Overdue Tasks Group -->
        <div class="task-category-group group-overdue" style="${empty taskGroups.overdue ? 'display:none;' : ''}">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 0.75rem;">
                <span style="width: 10px; height: 10px; border-radius: 50%; background: #dc2626;"></span>
                <h3 style="font-size: 1rem; font-weight: 700; color: #dc2626; margin: 0;">Overdue Action Required (${fn:length(taskGroups.overdue)})</h3>
            </div>
            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                <c:forEach var="t" items="${taskGroups.overdue}">
                    <div class="middle-card-white" style="border-left: 4px solid #dc2626; padding: 1rem 1.25rem; margin-bottom: 0; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                        <div>
                            <div style="font-weight: 700; font-size: 1rem; color: var(--navy); margin-bottom: 4px;">
                                <c:out value="${t.title}"/>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 12px;">
                                <span style="color: #dc2626; font-weight: 700;">Due: ${t.dueDate} (Overdue)</span>
                                <span style="color: var(--line-strong);">•</span>
                                <span class="status-chip-pill delayed" style="font-size: 11px;">${t.priority.displayName} Priority</span>
                                <span style="color: var(--line-strong);">•</span>
                                <a href="${pageContext.request.contextPath}/project?id=${t.projectId}&amp;tab=tasks" style="color: var(--forest); text-decoration: underline;">
                                    View in Project →
                                </a>
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/project/task/status" method="post" style="display: inline;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${t.projectId}">
                            <input type="hidden" name="taskId" value="${t.id}">
                            <input type="hidden" name="status" value="COMPLETED">
                            <button type="submit" class="dash-btn-forest" style="padding: 6px 16px; font-size: 12.5px; border: none; cursor: pointer;">
                                Mark Done ✓
                            </button>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 2. Due This Week Group -->
        <div class="task-category-group group-this-week" style="${empty taskGroups.thisWeek ? 'display:none;' : ''}">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 0.75rem;">
                <span style="width: 10px; height: 10px; border-radius: 50%; background: #d97706;"></span>
                <h3 style="font-size: 1rem; font-weight: 700; color: #d97706; margin: 0;">Due This Week (${fn:length(taskGroups.thisWeek)})</h3>
            </div>
            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                <c:forEach var="t" items="${taskGroups.thisWeek}">
                    <div class="middle-card-white" style="border-left: 4px solid #d97706; padding: 1rem 1.25rem; margin-bottom: 0; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                        <div>
                            <div style="font-weight: 700; font-size: 1rem; color: var(--navy); margin-bottom: 4px;">
                                <c:out value="${t.title}"/>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 12px;">
                                <span style="color: var(--navy); font-weight: 600;">Due: ${t.dueDate}</span>
                                <span style="color: var(--line-strong);">•</span>
                                <span class="status-chip-pill at-risk" style="font-size: 11px;">${t.priority.displayName}</span>
                                <span style="color: var(--line-strong);">•</span>
                                <a href="${pageContext.request.contextPath}/project?id=${t.projectId}&amp;tab=tasks" style="color: var(--forest); text-decoration: underline;">
                                    View in Project →
                                </a>
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/project/task/status" method="post" style="display: inline;">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="projectId" value="${t.projectId}">
                            <input type="hidden" name="taskId" value="${t.id}">
                            <input type="hidden" name="status" value="COMPLETED">
                            <button type="submit" class="dash-btn-forest" style="padding: 6px 16px; font-size: 12.5px; border: none; cursor: pointer;">
                                Complete ✓
                            </button>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 3. Scheduled Later Group -->
        <div class="task-category-group group-later" style="${empty taskGroups.later ? 'display:none;' : ''}">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 0.75rem;">
                <span style="width: 10px; height: 10px; border-radius: 50%; background: var(--forest);"></span>
                <h3 style="font-size: 1rem; font-weight: 700; color: var(--navy); margin: 0;">Scheduled Later (${fn:length(taskGroups.later)})</h3>
            </div>
            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                <c:forEach var="t" items="${taskGroups.later}">
                    <div class="middle-card-white" style="padding: 1rem 1.25rem; margin-bottom: 0; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                        <div>
                            <div style="font-weight: 700; font-size: 1rem; color: var(--navy); margin-bottom: 4px;">
                                <c:out value="${t.title}"/>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px; font-size: 12px; color: var(--muted);">
                                <span>Due: ${t.dueDate}</span>
                                <span>•</span>
                                <span>Priority: ${t.priority.displayName}</span>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/project?id=${t.projectId}&amp;tab=tasks" class="dash-btn-outline" style="padding: 6px 16px; font-size: 12.5px;">
                            View Task Details →
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 4. Completed Tasks Group -->
        <div class="task-category-group group-completed" style="${empty taskGroups.completed ? 'display:none;' : ''}">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 0.75rem;">
                <span style="width: 10px; height: 10px; border-radius: 50%; background: var(--green);"></span>
                <h3 style="font-size: 1rem; font-weight: 700; color: var(--green); margin: 0;">Completed Tasks (${fn:length(taskGroups.completed)})</h3>
            </div>
            <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                <c:forEach var="t" items="${taskGroups.completed}">
                    <div class="middle-card-white" style="padding: 0.85rem 1.25rem; margin-bottom: 0; display: flex; justify-content: space-between; align-items: center; opacity: 0.85;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span style="color: var(--green); font-size: 16px;">✓</span>
                            <div style="text-decoration: line-through; font-weight: 500; font-size: 0.95rem; color: var(--muted);">
                                <c:out value="${t.title}"/>
                            </div>
                        </div>
                        <span class="status-chip-pill on-track" style="font-size: 11px;">Completed</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <c:if test="${empty taskGroups.overdue and empty taskGroups.thisWeek and empty taskGroups.later and empty taskGroups.completed}">
            <div class="empty-state" style="padding: 4rem 2rem; background: #ffffff; border-radius: 16px; border: 1px solid var(--line);">
                <div style="font-size: 2.5rem; margin-bottom: 1rem;">📋</div>
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--navy); margin-bottom: 0.5rem;">No Development Tasks Assigned</h3>
                <p class="empty-state-text" style="max-width: 460px; margin: 0 auto;">You have no tasks in your sprint queue. Open one of your project ledgers to create and assign tasks.</p>
            </div>
        </c:if>
    </div>
</div>

<!-- ========================================================================= -->
<!-- SECTION 4: DEDICATED DEADLINES VIEW                                       -->
<!-- ========================================================================= -->
<div id="student-section-deadlines" class="student-section" style="${activeSection == 'deadlines' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/student/dashboard?section=overview" onclick="switchSection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Academic Deadlines</span>
            </div>
            <h1 class="dash-header-title">Academic Deadlines &amp; Milestones</h1>
            <div class="dash-header-sub">
                Official syllabus milestone deliverables, formal evaluation cutoffs, and university global project deadlines.
            </div>
        </div>
        <div class="dash-btn-group">
            <span class="status-chip-pill on-track" style="font-weight:700;">
                ${fn:length(upcomingDeadlines)} Upcoming Events
            </span>
        </div>
    </div>

    <!-- Deadlines Table Card -->
    <div class="middle-card-white" style="border-radius: 16px; padding: 1.5rem;">
        <c:choose>
            <c:when test="${empty upcomingDeadlines}">
                <div class="empty-state" style="padding: 3rem 1rem;">
                    <div style="font-size: 2.5rem; margin-bottom: 0.75rem;">📅</div>
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--navy); margin-bottom: 0.5rem;">No Deadlines Scheduled</h3>
                    <p class="empty-state-text">No academic deadlines are currently listed for your enrolled projects or institution.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-container" style="border: none; margin-bottom: 0;">
                    <table class="table-ruled">
                        <thead>
                            <tr>
                                <th>Milestone / Deadline</th>
                                <th>Academic Scope</th>
                                <th>Target Due Date</th>
                                <th class="num-col">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${upcomingDeadlines}">
                                <tr>
                                    <td>
                                        <div style="font-weight: 700; font-size: 14px; color: var(--navy);"><c:out value="${d.title}"/></div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${d.global}">
                                                <span class="topbar-crumb-badge" style="background: var(--forest); color: var(--lime); font-size: 10px;">UNIVERSITY GLOBAL</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="font-weight: 600; font-size: 13px; color: var(--forest);"><c:out value="${d.projectTitle}"/></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="mono-text" style="font-weight: 700; color: var(--navy); font-size: 13px;">${d.dueDate}</span>
                                    </td>
                                    <td class="num-col">
                                        <span class="status-chip-pill on-track">• Scheduled</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/student-dashboard.js"></script>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
