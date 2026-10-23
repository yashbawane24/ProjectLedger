<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- Mobile Top Bar Header -->
<div class="top-bar-mobile">
    <a href="${pageContext.request.contextPath}/" class="sidebar-wordmark">
        <div class="brand-icon-box sm">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                <polyline points="2 17 12 22 22 17"></polyline>
                <polyline points="2 12 12 17 22 12"></polyline>
            </svg>
        </div>
        <span>ProjectLedger</span>
    </a>
    <button id="mobileMenuToggle" class="btn btn-secondary btn-sm" aria-label="Toggle Navigation Menu">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="3" y1="12" x2="21" y2="12"></line>
            <line x1="3" y1="6" x2="21" y2="6"></line>
            <line x1="3" y1="18" x2="21" y2="18"></line>
        </svg>
    </button>
</div>

<!-- Left Modern Sidebar (Image 2 Design) -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <a href="${pageContext.request.contextPath}/" class="sidebar-wordmark">
            <div class="brand-icon-box">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>
            <span>ProjectLedger</span>
        </a>
    </div>

    <nav class="sidebar-nav" aria-label="Main Navigation">
        <c:choose>
            <%-- FACULTY NAVIGATION (Exact Image 2) --%>
            <c:when test="${sessionScope.currentUser != null and sessionScope.currentUser.faculty}">
                <div class="sidebar-section-label">MENU</div>
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=overview"
                   class="sidebar-link ${activeNav == 'dashboard' or activeNav == 'overview' or empty activeNav ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="3" width="7" height="9"></rect>
                        <rect x="14" y="3" width="7" height="5"></rect>
                        <rect x="14" y="12" width="7" height="9"></rect>
                        <rect x="3" y="16" width="7" height="5"></rect>
                    </svg>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=projects"
                   class="sidebar-link ${activeNav == 'projects' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    <span>Projects</span>
                    <span class="sidebar-count-badge">${totalSupervised != null ? totalSupervised : '6'}</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=feedback"
                   class="sidebar-link ${activeNav == 'feedback' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
                    <span>Feedback</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=deadlines"
                   class="sidebar-link ${activeNav == 'deadlines' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    <span>Deadlines</span>
                </a>
                <a href="${pageContext.request.contextPath}/faculty/dashboard?section=reports"
                   class="sidebar-link ${activeNav == 'reports' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                    <span>Reports</span>
                </a>

                <div class="sidebar-section-label">GENERAL</div>
                <a href="${pageContext.request.contextPath}/profile"
                   class="sidebar-link ${activeNav == 'profile' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Profile</span>
                </a>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline; width:100%;">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <button type="submit" class="sidebar-link" style="width:100%; border:none; background:transparent; cursor:pointer; text-align:left;">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                        <span>Log out</span>
                    </button>
                </form>
            </c:when>

            <%-- STUDENT NAVIGATION --%>
            <c:when test="${sessionScope.currentUser != null and sessionScope.currentUser.student}">
                <div class="sidebar-section-label">MENU</div>
                <a href="${pageContext.request.contextPath}/student/dashboard?section=overview"
                   class="sidebar-link ${activeNav == 'dashboard' or activeNav == 'overview' or empty activeNav ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="3" width="7" height="9"></rect>
                        <rect x="14" y="3" width="7" height="5"></rect>
                        <rect x="14" y="12" width="7" height="9"></rect>
                        <rect x="3" y="16" width="7" height="5"></rect>
                    </svg>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/dashboard?section=projects"
                   class="sidebar-link ${activeNav == 'projects' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                    <span>Projects</span>
                    <span class="sidebar-count-badge">${fn:length(projects)}</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/dashboard?section=tasks"
                   class="sidebar-link ${activeNav == 'tasks' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="9" y1="3" x2="9" y2="21"></line></svg>
                    <span>Tasks</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/dashboard?section=deadlines"
                   class="sidebar-link ${activeNav == 'deadlines' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    <span>Deadlines</span>
                </a>
                <a href="${pageContext.request.contextPath}/student/projects/new"
                   class="sidebar-link ${activeNav == 'new-project' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="16"></line><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                    <span>New Project</span>
                </a>

                <div class="sidebar-section-label">GENERAL</div>
                <a href="${pageContext.request.contextPath}/profile"
                   class="sidebar-link ${activeNav == 'profile' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Profile</span>
                </a>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline; width:100%;">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <button type="submit" class="sidebar-link" style="width:100%; border:none; background:transparent; cursor:pointer; text-align:left;">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                        <span>Log out</span>
                    </button>
                </form>
            </c:when>

            <%-- ADMIN NAVIGATION --%>
            <c:when test="${sessionScope.currentUser != null and sessionScope.currentUser.admin}">
                <div class="sidebar-section-label">MENU</div>
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   class="sidebar-link ${activeNav == 'dashboard' or empty activeNav ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="sidebar-link ${activeNav == 'users' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    <span>Users</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/projects"
                   class="sidebar-link ${activeNav == 'projects' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 16 12 14 15 10 15 8 12 2 12"></polyline><path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"></path></svg>
                    <span>Projects</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/deadlines"
                   class="sidebar-link ${activeNav == 'deadlines' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    <span>Deadlines</span>
                </a>

                <div class="sidebar-section-label">GENERAL</div>
                <a href="${pageContext.request.contextPath}/profile"
                   class="sidebar-link ${activeNav == 'profile' ? 'active' : ''}">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    <span>Profile</span>
                </a>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline; width:100%;">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <button type="submit" class="sidebar-link" style="width:100%; border:none; background:transparent; cursor:pointer; text-align:left;">
                        <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                        <span>Log out</span>
                    </button>
                </form>
            </c:when>
        </c:choose>
    </nav>

    <!-- Final Submission Forest Card in Sidebar (Exact Image 2) -->
    <div class="sidebar-submission-card">
        <div class="sidebar-sub-label">Final submission</div>
        <div class="sidebar-sub-date">14 Nov 2026</div>
        <div class="sidebar-sub-days">in 22 days</div>
        <a href="${pageContext.request.contextPath}/student/dashboard?section=deadlines" class="sidebar-sub-btn">View deadlines</a>
    </div>
</aside>

<!-- Main Content Area with Modern Top Header Bar -->
<main class="main-content" id="mainContent">

    <!-- Top Header Bar with Contextual Breadcrumb and User Actions (Search Removed) -->
    <div class="main-topbar">
        <div class="topbar-crumb-box">
            <span class="topbar-crumb-badge">ProjectLedger</span>
            <span class="topbar-crumb-sep">/</span>
            <span class="topbar-crumb-title"><c:out value="${pageTitle != null ? pageTitle : 'Academic Workspace'}"/></span>
        </div>

        <div class="topbar-actions">
            <div class="topbar-icon-btn" title="System Notifications" style="position:relative;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                <span style="position:absolute; top:7px; right:8px; width:7px; height:7px; border-radius:50%; background:#dc2626;"></span>
            </div>

            <a href="${pageContext.request.contextPath}/profile" class="topbar-user-badge" title="My Profile Settings">
                <div class="topbar-avatar">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser != null and fn:length(sessionScope.currentUser.name) gt 0}">
                            ${fn:substring(sessionScope.currentUser.name, 0, 1)}
                        </c:when>
                        <c:otherwise>U</c:otherwise>
                    </c:choose>
                </div>
                <div class="topbar-user-info">
                    <span class="topbar-name"><c:out value="${sessionScope.currentUser != null ? sessionScope.currentUser.name : ''}"/></span>
                    <span class="topbar-role-sub">
                        <c:choose>
                            <c:when test="${sessionScope.currentUser.faculty}">Faculty &middot; SCOPE</c:when>
                            <c:when test="${sessionScope.currentUser.student}">Student &middot; SCOPE</c:when>
                            <c:otherwise>Admin &middot; Academic Governance</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </a>
        </div>
    </div>

    <div class="content-body">
        <!-- Flash Messages Banner -->
    <c:if test="${flash != null}">
        <div class="flash-message flash-${flash.type}" role="alert" aria-live="polite">
            <div style="display:flex; align-items:center; gap:0.5rem;">
                <c:choose>
                    <c:when test="${flash.type == 'success'}">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    </c:when>
                    <c:when test="${flash.type == 'error'}">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    </c:when>
                    <c:otherwise>
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
                    </c:otherwise>
                </c:choose>
                <span><c:out value="${flash.message}"/></span>
            </div>
            <button type="button" class="flash-close-btn" aria-label="Dismiss alert">&times;</button>
        </div>
    </c:if>
