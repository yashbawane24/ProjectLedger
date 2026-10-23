<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<!-- Dashboard Header Banner (Image 2 Style) -->
<div class="dash-header-row">
    <div>
        <h1 class="dash-header-title">Hello, <c:out value="${sessionScope.currentUser.name}"/></h1>
        <div class="dash-header-sub">
            Academic governance &middot; System-wide project health oversight and user directory management.
        </div>
    </div>
    <div class="dash-btn-group">
        <a href="${pageContext.request.contextPath}/admin/users" class="dash-btn-forest">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
            </svg>
            <span>Manage Users</span>
        </a>
    </div>
</div>

<!-- 1. Top 4 KPI Metric Cards (Image 2 Style) -->
<div class="kpi-grid-4">
    <!-- Card 1: Total Projects (Forest Green Card) -->
    <a href="${pageContext.request.contextPath}/admin/projects" class="kpi-card-forest">
        <div class="kpi-forest-top">
            <span class="kpi-forest-title">Total Projects</span>
            <div class="kpi-arrow-white">↗</div>
        </div>
        <div>
            <div class="kpi-forest-val">${totalProjects}</div>
            <div class="kpi-forest-sub">Academic portfolio</div>
        </div>
    </a>

    <!-- Card 2: Registered Students -->
    <div class="kpi-card-white">
        <div class="kpi-white-top">
            <span class="kpi-white-title">Students</span>
            <span class="kpi-dot green"></span>
        </div>
        <div>
            <div class="kpi-white-val">${studentCount}</div>
            <div class="kpi-white-sub">Enrolled developers</div>
        </div>
    </div>

    <!-- Card 3: Faculty Supervisors -->
    <div class="kpi-card-white">
        <div class="kpi-white-top">
            <span class="kpi-white-title">Faculty</span>
            <span class="kpi-dot green"></span>
        </div>
        <div>
            <div class="kpi-white-val">${facultyCount}</div>
            <div class="kpi-white-sub">Active supervisors</div>
        </div>
    </div>

    <!-- Card 4: Delayed Projects -->
    <div class="kpi-card-white">
        <div class="kpi-white-top">
            <span class="kpi-white-title">Delayed</span>
            <span class="kpi-dot red"></span>
        </div>
        <div>
            <div class="kpi-white-val">${delayedProjects}</div>
            <div class="kpi-white-sub red">Needs institutional review</div>
        </div>
    </div>
</div>

<!-- Section 2: Project Health Distribution -->
<div class="middle-card-white" style="margin-bottom:20px;">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
        <h2 class="chart-title" style="margin-bottom:0;">Academic Projects Portfolio (${totalProjects} Total)</h2>
        <a href="${pageContext.request.contextPath}/admin/projects" class="dash-btn-outline" style="padding:4px 14px; font-size:12px;">Manage All Projects &rarr;</a>
    </div>

    <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap:1rem;">
        <div style="padding:1rem 1.25rem; background-color:#f6faf6; border:1px solid #d7e8d6; border-left:4px solid #2e7d32; border-radius:12px;">
            <span class="label-caps" style="color:#2e7d32;">On Track</span>
            <div style="font-size:1.75rem; font-weight:800; color:var(--navy); margin-top:0.25rem;">${onTrackProjects}</div>
            <div style="font-size:0.75rem; color:var(--muted); margin-top:0.25rem;">Advancing per milestone schedule</div>
        </div>

        <div style="padding:1rem 1.25rem; background-color:#fffdf7; border:1px solid #fde68a; border-left:4px solid #d97706; border-radius:12px;">
            <span class="label-caps" style="color:#d97706;">At Risk</span>
            <div style="font-size:1.75rem; font-weight:800; color:var(--navy); margin-top:0.25rem;">${atRiskProjects}</div>
            <div style="font-size:0.75rem; color:var(--muted); margin-top:0.25rem;">Overdue tasks or inactive repo</div>
        </div>

        <div style="padding:1rem 1.25rem; background-color:#fef6f6; border:1px solid #fecaca; border-left:4px solid #dc2626; border-radius:12px;">
            <span class="label-caps" style="color:#dc2626;">Delayed</span>
            <div style="font-size:1.75rem; font-weight:800; color:var(--navy); margin-top:0.25rem;">${delayedProjects}</div>
            <div style="font-size:0.75rem; color:var(--muted); margin-top:0.25rem;">Missed milestone targets</div>
        </div>
    </div>
</div>

<!-- Section 3: Recent Signups Table -->
<div class="panel">
    <h2 class="section-title">Recent User Registrations</h2>
    <div class="table-container" style="border:none;">
        <table class="table-ruled">
            <thead>
                <tr>
                    <th>User Name</th>
                    <th>Email Address</th>
                    <th>Role</th>
                    <th>Department / Reg No</th>
                    <th>Status</th>
                    <th class="num-col">Registered Date</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${recentSignups}">
                    <tr>
                        <td style="font-weight:500;"><c:out value="${u.name}"/></td>
                        <td class="mono-text"><c:out value="${u.email}"/></td>
                        <td>
                            <span class="label-caps">${u.role.displayName}</span>
                        </td>
                        <td>
                            <c:out value="${u.regNo != null ? u.regNo : (u.department != null ? u.department : '—')}"/>
                        </td>
                        <td>
                            <span class="label-caps" style="color: ${u.active ? 'var(--ontrack)' : 'var(--delayed)'};">
                                ${u.active ? 'Active' : 'Deactivated'}
                            </span>
                        </td>
                        <td class="num-col mono-text" style="font-size:0.8rem;">
                            ${u.createdAt}
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
