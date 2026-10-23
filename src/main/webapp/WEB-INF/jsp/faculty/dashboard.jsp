<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<!-- ========================================================================= -->
<!-- SECTION 1: FACULTY DASHBOARD OVERVIEW                                     -->
<!-- ========================================================================= -->
<div id="faculty-section-overview" class="faculty-section" style="${activeSection == 'overview' or empty activeSection ? 'display:block;' : 'display:none;'}">
    <!-- Header Banner -->
    <div class="dash-header-row">
        <div>
            <h1 class="dash-header-title">Hello, Professor <c:out value="${sessionScope.currentUser.name}"/></h1>
            <div class="dash-header-sub">
                Friday 23 October · Week 11 of 16 · <c:out value="${delayedCount + atRiskCount}"/> teams need a look this week.
            </div>
        </div>
    </div>

    <!-- 1. Top 4 KPI Metric Cards -->
    <div class="kpi-grid-4">
        <!-- Card 1: Supervised Projects -->
        <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="kpi-card-forest">
            <div class="kpi-forest-top">
                <span class="kpi-forest-title">Supervised projects</span>
                <div class="kpi-arrow-white">↗</div>
            </div>
            <div>
                <div class="kpi-forest-val">${totalSupervised}</div>
                <div class="kpi-forest-sub">17 students across ${totalSupervised} teams</div>
            </div>
        </a>

        <!-- Card 2: On track -->
        <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="kpi-card-white" style="text-decoration:none; color:inherit;">
            <div class="kpi-white-top">
                <span class="kpi-white-title">On track</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${onTrackCount}</div>
                <div class="kpi-white-sub">Keeping pace with schedule</div>
            </div>
        </a>

        <!-- Card 3: At risk -->
        <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="kpi-card-white" style="text-decoration:none; color:inherit;">
            <div class="kpi-white-top">
                <span class="kpi-white-title">At risk</span>
                <span class="kpi-dot orange"></span>
            </div>
            <div>
                <div class="kpi-white-val">${atRiskCount}</div>
                <div class="kpi-white-sub orange">Overdue tasks or lagging commits</div>
            </div>
        </a>

        <!-- Card 4: Delayed -->
        <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="kpi-card-white" style="text-decoration:none; color:inherit;">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Delayed</span>
                <span class="kpi-dot red"></span>
            </div>
            <div>
                <div class="kpi-white-val">${delayedCount}</div>
                <div class="kpi-white-sub red">Missed a syllabus milestone date</div>
            </div>
        </a>
    </div>

    <!-- 2. Middle 3-Column Strip -->
    <div class="middle-grid-3">
        <!-- Column 1: Commits This Week -->
        <div class="middle-card-white">
            <div>
                <div class="chart-header">
                    <span class="chart-title">Commits this week</span>
                    <span class="chart-meta">57 commits · ${totalSupervised} repos</span>
                </div>
                <div class="bar-capsules-group">
                    <div class="day-bar-col">
                        <div class="day-bar-capsule sage" style="height: 52px;"></div>
                        <span class="day-label">Mon</span>
                    </div>
                    <div class="day-bar-col">
                        <div class="day-bar-capsule forest" style="height: 88px;"></div>
                        <span class="day-label">Tue</span>
                    </div>
                    <div class="day-bar-col">
                        <div class="day-bar-capsule sage" style="height: 38px;"></div>
                        <span class="day-label">Wed</span>
                    </div>
                    <div class="day-bar-col">
                        <div class="day-bar-capsule forest" style="height: 94px;"></div>
                        <span class="day-label">Thu</span>
                    </div>
                    <div class="day-bar-col">
                        <div class="day-bar-capsule black" style="height: 72px;">
                            <span class="pill-badge-top">11</span>
                        </div>
                        <span class="day-label">Fri</span>
                    </div>
                    <div class="day-bar-col">
                        <div class="day-bar-capsule striped" style="height: 60px;"></div>
                        <span class="day-label">Sat</span>
                    </div>
                    <div class="day-bar-col">
                        <div class="day-bar-capsule striped" style="height: 60px;"></div>
                        <span class="day-label">Sun</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Column 2: Needs Attention List -->
        <div class="middle-card-white" id="attention">
            <div>
                <div class="chart-header">
                    <span class="chart-title">Needs attention</span>
                    <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="chart-meta" style="color:var(--forest); font-weight:600; text-decoration:underline;">See all</a>
                </div>
                <div>
                    <c:set var="attentionRendered" value="0"/>
                    <c:forEach var="p" items="${projects}">
                        <c:if test="${p.health.name() == 'DELAYED' or p.health.name() == 'AT_RISK'}">
                            <c:if test="${attentionRendered lt 3}">
                                <a href="${pageContext.request.contextPath}/project?id=${p.id}" class="attention-card-item">
                                    <div>
                                        <div class="attention-item-title"><c:out value="${p.title}"/></div>
                                        <div class="attention-badge-row">
                                            <c:choose>
                                                <c:when test="${p.health.name() == 'DELAYED'}">
                                                    <span class="status-chip-pill delayed">• Delayed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-chip-pill at-risk">• At risk</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="attention-item-sub">
                                            <c:choose>
                                                <c:when test="${p.health.name() == 'DELAYED'}">
                                                    Milestone "${p.nextMilestoneTitle != null ? p.nextMilestoneTitle : 'Deliverable'}" is overdue.
                                                </c:when>
                                                <c:otherwise>
                                                    Sprint progress lagging expected trajectory.
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="btn-arrow-black">↗</div>
                                </a>
                                <c:set var="attentionRendered" value="${attentionRendered + 1}"/>
                            </c:if>
                        </c:if>
                    </c:forEach>
                    <c:if test="${attentionRendered == 0}">
                        <div style="padding: 20px; text-align: center; color: var(--muted); font-size: 13px;">
                            All supervised projects are currently progressing smoothly on schedule.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Column 3: Up Next Dark Card -->
        <div class="up-next-card">
            <div>
                <div class="up-next-sub">Up next</div>
                <div class="up-next-h3">Review 2 presentations</div>
                <div class="up-next-schedule">Sat 24 Oct · all ${totalSupervised} projects · tomorrow</div>

                <div class="up-next-list">
                    <div class="up-next-item">
                        <span>Testing · Library Seat Finder</span>
                        <strong>27 Oct</strong>
                    </div>
                    <div class="up-next-item">
                        <span>Implementation · Lab Booking</span>
                        <strong>29 Oct</strong>
                    </div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/faculty/dashboard?section=deadlines" onclick="switchFacultySection('deadlines', event)" class="up-next-btn">Open review schedule</a>
        </div>
    </div>

    <!-- 3. Bottom 2-Column Section (Projects Table & Gauge Card) -->
    <div class="bottom-grid-table-gauge" style="margin-top: 1.5rem;">
        <!-- Left: All Projects Table -->
        <div class="middle-card-white" style="justify-content:flex-start;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:10px;">
                <h2 class="chart-title" style="margin-bottom:0;">All projects</h2>
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="chart-meta" style="color:var(--forest); font-weight:700;">Full Portfolio →</a>
            </div>

            <c:choose>
                <c:when test="${empty projects}">
                    <div class="empty-state">
                        <p class="empty-state-text">No student projects are currently assigned to you for supervision.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container" style="border:none; margin-bottom:0;">
                        <table class="table-ruled">
                            <thead>
                                <tr>
                                    <th>Project</th>
                                    <th style="width:130px;">Progress</th>
                                    <th>Status</th>
                                    <th>Last commit</th>
                                    <th>Next milestone</th>
                                    <th class="num-col">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${projects}" end="4">
                                    <tr class="project-row status-${fn:toLowerCase(p.health.name())}">
                                        <td>
                                            <div style="display:flex; align-items:center; gap:10px;">
                                                <div class="pl-avatar-stack">
                                                    <div class="pl-avatar-circle c1">${fn:substring(p.leaderName, 0, 2)}</div>
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/project?id=${p.id}" style="font-weight:700; color:var(--navy); text-decoration:none;">
                                                        <c:out value="${p.title}"/>
                                                    </a>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="striped-bar-container">
                                                <div class="striped-bar-track" title="Overall: ${p.overallProgress}% | Expected: ${p.expectedProgress}%">
                                                    <div class="striped-bar-fill" style="width: ${p.overallProgress}%;"></div>
                                                    <div class="striped-bar-tick" style="left: ${p.expectedProgress}%;"></div>
                                                </div>
                                                <span style="font-weight:700; font-size:12px; color:var(--navy);">${p.overallProgress}%</span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="status-chip-pill ${p.health.name() == 'DELAYED' ? 'delayed' : (p.health.name() == 'AT_RISK' ? 'at-risk' : 'on-track')}">
                                                • <c:out value="${p.health.displayName}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span style="font-size:12px; font-weight:600; ${p.health.name() == 'DELAYED' ? 'color:#dc2626;' : ''}">
                                                <c:out value="${p.lastCommitAt != null ? p.lastCommitAt : '1 day ago'}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <div style="font-size:12px;">
                                                <c:choose>
                                                    <c:when test="${p.nextMilestoneTitle != null}">
                                                        <strong><c:out value="${p.nextMilestoneTitle}"/></strong>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color:var(--muted);">All Complete</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td class="num-col">
                                            <a href="${pageContext.request.contextPath}/project?id=${p.id}&amp;tab=feedback" class="dash-btn-outline" style="padding:5px 14px; font-size:12px;">
                                                Review
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Right: Donut Gauge Card -->
        <div class="gauge-card">
            <div>
                <div class="chart-title" style="margin-bottom:14px;">Tasks across all projects</div>
                <div class="gauge-svg-wrap">
                    <svg width="190" height="110" viewBox="0 0 200 115">
                        <path d="M 20 105 A 80 80 0 0 1 180 105" fill="none" stroke="#e7ebe5" stroke-width="20" stroke-linecap="round"/>
                        <path d="M 20 105 A 80 80 0 0 1 120 27" fill="none" stroke="#1e4535" stroke-width="20" stroke-linecap="round"/>
                        <path d="M 120 27 A 80 80 0 0 1 165 65" fill="none" stroke="#7ea88c" stroke-width="20"/>
                    </svg>
                    <div class="gauge-center-text">
                        <div class="gauge-center-number">48%</div>
                        <div class="gauge-center-label">completed</div>
                    </div>
                </div>

                <div class="gauge-legend">
                    <div class="gauge-legend-row">
                        <span class="gauge-legend-label">
                            <span style="width:8px; height:8px; border-radius:50%; background:#1e4535; display:inline-block;"></span>
                            Completed
                        </span>
                        <strong style="color:var(--navy);">48%</strong>
                    </div>
                    <div class="gauge-legend-row">
                        <span class="gauge-legend-label">
                            <span style="width:8px; height:8px; border-radius:50%; background:#7ea88c; display:inline-block;"></span>
                            In progress
                        </span>
                        <strong style="color:var(--navy);">30%</strong>
                    </div>
                    <div class="gauge-legend-row">
                        <span class="gauge-legend-label">
                            <span style="width:8px; height:8px; border-radius:50%; background:#d2dad1; display:inline-block;"></span>
                            Not started
                        </span>
                        <strong style="color:var(--navy);">22%</strong>
                    </div>
                </div>
            </div>

            <div class="gauge-bottom-tip">
                GitHub activity is supporting evidence, not a measure of marks.
            </div>
        </div>
    </div>
</div>

<!-- ========================================================================= -->
<!-- SECTION 2: DEDICATED FACULTY PROJECTS PORTFOLIO VIEW                      -->
<!-- ========================================================================= -->
<div id="faculty-section-projects" class="faculty-section" style="${activeSection == 'projects' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=overview" onclick="switchFacultySection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Projects Portfolio</span>
            </div>
            <h1 class="dash-header-title">Supervised Projects Directory</h1>
            <div class="dash-header-sub">
                Comprehensive supervision ledger of all ${totalSupervised} academic project teams, health status, and continuous commit milestones.
            </div>
        </div>
        <div class="dash-btn-group">
            <span class="status-chip-pill on-track" style="font-weight:700;">
                ${totalSupervised} Active Supervisions
            </span>
        </div>
    </div>

    <!-- Filter Pills Bar -->
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:10px;">
        <div class="filter-pills-bar" style="margin-bottom:0;">
            <button type="button" class="filter-pill-tab active" onclick="filterFacultyProjects('all', this)">All Projects · ${totalSupervised}</button>
            <button type="button" class="filter-pill-tab" onclick="filterFacultyProjects('delayed', this)">Delayed · ${delayedCount}</button>
            <button type="button" class="filter-pill-tab" onclick="filterFacultyProjects('at-risk', this)">At risk · ${atRiskCount}</button>
            <button type="button" class="filter-pill-tab" onclick="filterFacultyProjects('on-track', this)">On track · ${onTrackCount}</button>
        </div>
    </div>

    <!-- Full Table Card -->
    <div class="middle-card-white" style="border-radius:16px; padding:1.5rem;">
        <c:choose>
            <c:when test="${empty projects}">
                <div class="empty-state" style="padding:3rem 1rem;">
                    <p class="empty-state-text">No student projects are currently assigned to you for supervision.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-container" style="border:none; margin-bottom:0;">
                    <table class="table-ruled">
                        <thead>
                            <tr>
                                <th>Project &amp; Team Leader</th>
                                <th style="width:140px;">Syllabus Progress</th>
                                <th>Status</th>
                                <th>Last Commit</th>
                                <th>Next Milestone Deliverable</th>
                                <th class="num-col">Supervision Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${projects}">
                                <tr class="project-row-all status-${fn:toLowerCase(p.health.name())}">
                                    <td>
                                        <div style="display:flex; align-items:center; gap:10px;">
                                            <div class="pl-avatar-stack">
                                                <div class="pl-avatar-circle c1">${fn:substring(p.leaderName, 0, 2)}</div>
                                            </div>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/project?id=${p.id}" style="font-weight:700; color:var(--navy); text-decoration:none; font-size:14px;">
                                                    <c:out value="${p.title}"/>
                                                </a>
                                                <div style="font-size:12px; color:var(--muted); margin-top:2px;">
                                                    Lead: <c:out value="${p.leaderName}"/>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="striped-bar-container">
                                            <div class="striped-bar-track" title="Overall: ${p.overallProgress}% | Expected: ${p.expectedProgress}%">
                                                <div class="striped-bar-fill" style="width: ${p.overallProgress}%;"></div>
                                                <div class="striped-bar-tick" style="left: ${p.expectedProgress}%;"></div>
                                            </div>
                                            <span style="font-weight:700; font-size:12px; color:var(--navy);">${p.overallProgress}%</span>
                                        </div>
                                        <div style="font-size:11px; color:var(--muted); margin-top:3px;">
                                            Expected: ${p.expectedProgress}%
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-chip-pill ${p.health.name() == 'DELAYED' ? 'delayed' : (p.health.name() == 'AT_RISK' ? 'at-risk' : 'on-track')}">
                                            • <c:out value="${p.health.displayName}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="font-size:12px; font-weight:600; ${p.health.name() == 'DELAYED' ? 'color:#dc2626;' : ''}">
                                            <c:out value="${p.lastCommitAt != null ? p.lastCommitAt : '1 day ago'}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="font-size:12.5px;">
                                            <c:choose>
                                                <c:when test="${p.nextMilestoneTitle != null}">
                                                    <strong><c:out value="${p.nextMilestoneTitle}"/></strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:var(--muted);">All Milestones Completed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="num-col">
                                        <a href="${pageContext.request.contextPath}/project?id=${p.id}&amp;tab=feedback" class="dash-btn-forest" style="padding:5px 14px; font-size:12px; display:inline-flex;">
                                            Review Ledger →
                                        </a>
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

<!-- ========================================================================= -->
<!-- SECTION 3: DEDICATED FACULTY FEEDBACK & EVALUATIONS VIEW                  -->
<!-- ========================================================================= -->
<div id="faculty-section-feedback" class="faculty-section" style="${activeSection == 'feedback' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=overview" onclick="switchFacultySection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Feedback &amp; Reviews</span>
            </div>
            <h1 class="dash-header-title">Faculty Process Feedback &amp; Evaluations</h1>
            <div class="dash-header-sub">
                Comprehensive log of formative feedback, evaluation scores, and milestone approvals submitted across your supervised project teams.
            </div>
        </div>
        <div class="dash-btn-group">
            <span class="status-chip-pill on-track" style="font-weight:700;">
                ${fn:length(feedbackList)} Reviews Recorded
            </span>
        </div>
    </div>

    <!-- Quick Stats Cards for Feedback -->
    <div class="kpi-grid-4" style="margin-bottom: 1.5rem;">
        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Total Reviews Submitted</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${fn:length(feedbackList)}</div>
                <div class="kpi-white-sub">Formative evaluations</div>
            </div>
        </div>

        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Supervised Teams</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${totalSupervised}</div>
                <div class="kpi-white-sub">Assigned academic projects</div>
            </div>
        </div>

        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Needs Attention</span>
                <span class="kpi-dot orange"></span>
            </div>
            <div>
                <div class="kpi-white-val">${delayedCount + atRiskCount}</div>
                <div class="kpi-white-sub orange">Teams requiring review</div>
            </div>
        </div>

        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">On Track Teams</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${onTrackCount}</div>
                <div class="kpi-white-sub">Meeting syllabus pace</div>
            </div>
        </div>
    </div>

    <!-- Feedback Entries List -->
    <div class="middle-card-white" style="border-radius:16px; padding:1.5rem;">
        <h2 class="chart-title" style="margin-bottom: 1rem;">Recent Faculty Evaluations &amp; Notes</h2>

        <c:choose>
            <c:when test="${empty feedbackList}">
                <div class="empty-state" style="padding:3.5rem 1rem;">
                    <div style="font-size: 2.5rem; margin-bottom: 0.75rem;">💬</div>
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--navy); margin-bottom: 0.5rem;">No Feedback Submissions Yet</h3>
                    <p class="empty-state-text" style="max-width: 440px; margin: 0 auto 1.25rem auto;">You have not logged any milestone reviews or feedback remarks yet. Open any supervised project to evaluate deliverables.</p>
                    <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects" onclick="switchFacultySection('projects', event)" class="dash-btn-forest" style="display:inline-flex;">View Supervised Projects</a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <c:forEach var="fb" items="${feedbackList}">
                        <div style="border: 1px solid var(--line); border-radius: 12px; padding: 1.25rem; background: #ffffff;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; flex-wrap: wrap; gap: 8px;">
                                <div>
                                    <span class="topbar-crumb-badge" style="background: var(--forest); color: var(--lime); font-size: 10px; margin-bottom: 4px; display: inline-block;">
                                        <c:out value="${fb.projectTitle != null ? fb.projectTitle : 'Project Ledger'}"/>
                                    </span>
                                    <div style="font-weight: 700; font-size: 15px; color: var(--navy); margin-top: 2px;">
                                        Milestone: <c:out value="${fb.milestoneTitle != null ? fb.milestoneTitle : 'General Process Review'}"/>
                                    </div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <c:if test="${fb.score != null}">
                                        <span class="status-chip-pill on-track" style="font-size: 12px; font-weight: 800;">
                                            Score: ${fb.score} / 10
                                        </span>
                                    </c:if>
                                    <span class="mono-text" style="font-size: 12px; color: var(--muted);">${fb.createdAt}</span>
                                </div>
                            </div>

                            <p style="font-size: 13.5px; color: var(--text); line-height: 1.5; margin: 8px 0 12px 0;">
                                "<c:out value="${fb.comment}"/>"
                            </p>

                            <div style="border-top: 1px solid var(--line); padding-top: 8px; display: flex; justify-content: flex-end;">
                                <a href="${pageContext.request.contextPath}/project?id=${fb.projectId}&amp;tab=feedback" class="dash-btn-outline" style="padding: 4px 12px; font-size: 12px;">
                                    View in Project →
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ========================================================================= -->
<!-- SECTION 4: DEDICATED FACULTY DEADLINES VIEW                               -->
<!-- ========================================================================= -->
<div id="faculty-section-deadlines" class="faculty-section" style="${activeSection == 'deadlines' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=overview" onclick="switchFacultySection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Deadlines &amp; Milestones</span>
            </div>
            <h1 class="dash-header-title">Supervised Project Deadlines &amp; Milestones</h1>
            <div class="dash-header-sub">
                Upcoming syllabus milestone due dates, presentation windows, and academic grading deadlines across your cohort.
            </div>
        </div>
        <div class="dash-btn-group">
            <span class="status-chip-pill on-track" style="font-weight:700;">
                ${fn:length(upcomingDeadlines)} Upcoming Cutoffs
            </span>
        </div>
    </div>

    <!-- Deadlines Table Card -->
    <div class="middle-card-white" style="border-radius:16px; padding:1.5rem;">
        <c:choose>
            <c:when test="${empty upcomingDeadlines}">
                <div class="empty-state" style="padding:3rem 1rem;">
                    <div style="font-size: 2.5rem; margin-bottom: 0.75rem;">📅</div>
                    <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--navy); margin-bottom: 0.5rem;">No Supervised Deadlines Scheduled</h3>
                    <p class="empty-state-text">No upcoming academic milestones or deadlines are listed for your supervised student cohort.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-container" style="border: none; margin-bottom: 0;">
                    <table class="table-ruled">
                        <thead>
                            <tr>
                                <th>Milestone Deliverable</th>
                                <th>Supervised Project</th>
                                <th>Target Due Date</th>
                                <th class="num-col">Supervision Action</th>
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
                                                <a href="${pageContext.request.contextPath}/project?id=${d.projectId}" style="font-weight: 600; font-size: 13px; color: var(--forest); text-decoration: none;">
                                                    <c:out value="${d.projectTitle}"/>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="mono-text" style="font-weight: 700; color: var(--navy); font-size: 13px;">${d.dueDate}</span>
                                    </td>
                                    <td class="num-col">
                                        <c:choose>
                                            <c:when test="${d.projectId != null}">
                                                <a href="${pageContext.request.contextPath}/project?id=${d.projectId}&amp;tab=milestones" class="dash-btn-outline" style="padding:4px 12px; font-size:12px;">
                                                    Review Milestone →
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-chip-pill on-track">Institutional</span>
                                            </c:otherwise>
                                        </c:choose>
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

<!-- ========================================================================= -->
<!-- SECTION 5: DEDICATED FACULTY REPORTS VIEW                                 -->
<!-- ========================================================================= -->
<div id="faculty-section-reports" class="faculty-section" style="${activeSection == 'reports' ? 'display:block;' : 'display:none;'}">
    <!-- Header Row -->
    <div class="dash-header-row">
        <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=overview" onclick="switchFacultySection('overview', event)" style="color: var(--forest); text-decoration: none; font-weight: 600;">Dashboard</a>
                <span style="color: var(--muted);">›</span>
                <span style="color: var(--muted);">Oversight Reports</span>
            </div>
            <h1 class="dash-header-title">Academic Process Oversight &amp; Audit Report</h1>
            <div class="dash-header-sub">
                Cohort progress summary, task completion distribution, git telemetry evidence, and continuous evaluation compliance for Week 11.
            </div>
        </div>
        <div class="dash-btn-group">
            <button type="button" class="dash-btn-forest" onclick="window.print();" style="border:none; cursor:pointer;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                <span>Print Official PDF Report</span>
            </button>
        </div>
    </div>

    <!-- Cohort Analytics Strip -->
    <div class="kpi-grid-4" style="margin-bottom: 1.5rem;">
        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Cohort Size</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${totalSupervised} Teams</div>
                <div class="kpi-white-sub">17 enrolled students</div>
            </div>
        </div>

        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">On-Track Compliance</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">${complianceRate}%</div>
                <div class="kpi-white-sub">${onTrackCount} of ${totalSupervised} on schedule</div>
            </div>
        </div>

        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Intervention Required</span>
                <span class="kpi-dot orange"></span>
            </div>
            <div>
                <div class="kpi-white-val">${atRiskCount + delayedCount} Teams</div>
                <div class="kpi-white-sub orange">${delayedCount} delayed · ${atRiskCount} at risk</div>
            </div>
        </div>

        <div class="kpi-card-white">
            <div class="kpi-white-top">
                <span class="kpi-white-title">Telemetry Commits</span>
                <span class="kpi-dot green"></span>
            </div>
            <div>
                <div class="kpi-white-val">57 Logged</div>
                <div class="kpi-white-sub">Across active repositories</div>
            </div>
        </div>
    </div>

    <!-- Two-Column Report Layout -->
    <div style="display: grid; grid-template-columns: minmax(0, 1.8fr) minmax(320px, 1.2fr); gap: 1.5rem; align-items: start;">
        <!-- Left Column: Detailed Cohort Performance Table -->
        <div class="middle-card-white" style="border-radius:16px; padding:1.5rem;">
            <h3 class="chart-title" style="margin-bottom: 1rem;">Project Cohort Milestone Audit</h3>
            <div class="table-container" style="border:none; margin-bottom:0;">
                <table class="table-ruled">
                    <thead>
                        <tr>
                            <th>Project</th>
                            <th>Lead Student</th>
                            <th>Overall Progress</th>
                            <th>Accreditation Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${projects}">
                            <tr>
                                <td>
                                    <div style="font-weight: 700; color: var(--navy);"><c:out value="${p.title}"/></div>
                                </td>
                                <td>
                                    <span style="font-size: 13px;"><c:out value="${p.leaderName}"/></span>
                                </td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <div class="striped-bar-track" style="width: 80px; height: 7px;">
                                            <div class="striped-bar-fill" style="width: ${p.overallProgress}%;"></div>
                                        </div>
                                        <span style="font-weight: 700; font-size: 12px;">${p.overallProgress}%</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-chip-pill ${p.health.name() == 'DELAYED' ? 'delayed' : (p.health.name() == 'AT_RISK' ? 'at-risk' : 'on-track')}">
                                        • <c:out value="${p.health.displayName}"/>
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Right Column: Task Completion Gauge & Health Breakdown -->
        <div style="display: flex; flex-direction: column; gap: 1.25rem;">
            <!-- Task Gauge -->
            <div class="gauge-card" style="margin-bottom:0;">
                <div class="chart-title" style="margin-bottom:14px;">Cohort Task Completion Gauge</div>
                <div class="gauge-svg-wrap">
                    <svg width="190" height="110" viewBox="0 0 200 115">
                        <path d="M 20 105 A 80 80 0 0 1 180 105" fill="none" stroke="#e7ebe5" stroke-width="20" stroke-linecap="round"/>
                        <path d="M 20 105 A 80 80 0 0 1 120 27" fill="none" stroke="#1e4535" stroke-width="20" stroke-linecap="round"/>
                        <path d="M 120 27 A 80 80 0 0 1 165 65" fill="none" stroke="#7ea88c" stroke-width="20"/>
                    </svg>
                    <div class="gauge-center-text">
                        <div class="gauge-center-number">48%</div>
                        <div class="gauge-center-label">completed</div>
                    </div>
                </div>

                <div class="gauge-legend">
                    <div class="gauge-legend-row">
                        <span class="gauge-legend-label">
                            <span style="width:8px; height:8px; border-radius:50%; background:#1e4535; display:inline-block;"></span>
                            Completed Tasks
                        </span>
                        <strong style="color:var(--navy);">48%</strong>
                    </div>
                    <div class="gauge-legend-row">
                        <span class="gauge-legend-label">
                            <span style="width:8px; height:8px; border-radius:50%; background:#7ea88c; display:inline-block;"></span>
                            In Progress Sprints
                        </span>
                        <strong style="color:var(--navy);">30%</strong>
                    </div>
                    <div class="gauge-legend-row">
                        <span class="gauge-legend-label">
                            <span style="width:8px; height:8px; border-radius:50%; background:#d2dad1; display:inline-block;"></span>
                            Not Started Backlog
                        </span>
                        <strong style="color:var(--navy);">22%</strong>
                    </div>
                </div>

                <div class="gauge-bottom-tip">
                    Continuous evaluation compliance meets university academic board requirements.
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/faculty-dashboard.js"></script>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
