<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">University Academic Projects</h1>
        <div class="header-lead">Institutional project oversight, supervisor allocations, and governance controls.</div>
    </div>
</div>

<div class="panel">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
        <h2 class="section-title" style="margin-bottom:0;">All Registered Projects (${fn:length(projects)})</h2>
    </div>

    <div class="table-container" style="border:none;">
        <table class="table-ruled">
            <thead>
                <tr>
                    <th>Project Title &amp; Team</th>
                    <th>Health Status</th>
                    <th class="num-col">Progress</th>
                    <th>Supervising Faculty</th>
                    <th class="num-col">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${projects}">
                    <tr>
                        <td style="max-width:320px;">
                            <div style="font-weight:600;">
                                <a href="${pageContext.request.contextPath}/project?id=${p.id}" style="color:var(--ink); text-decoration:none;">
                                    <c:out value="${p.title}"/>
                                </a>
                            </div>
                            <div style="font-size:0.75rem; color:var(--ink-soft); margin-top:0.2rem;">
                                Leader: <strong><c:out value="${p.leaderName}"/></strong> &middot; Timeline: <span class="mono-text">${p.startDate} to ${p.endDate}</span>
                            </div>
                        </td>
                        <td>
                            <span class="health-stamp ${p.health.cssClass}">
                                <c:out value="${p.health.displayName}"/>
                            </span>
                        </td>
                        <td class="num-col">
                            <div style="display:flex; align-items:center; justify-content:flex-end; gap:0.5rem;">
                                <span class="mono-text">${p.overallProgress}%</span>
                                <div class="progress-track" style="width:50px;">
                                    <div class="progress-fill ${p.health.name() == 'DELAYED' ? 'delayed-bar' : ''}" style="width:${p.overallProgress}%;"></div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <!-- Form to reassign supervisor -->
                            <form action="${pageContext.request.contextPath}/admin/projects/reassign" method="post" style="display:flex; gap:0.4rem; align-items:center;">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="projectId" value="${p.id}">
                                <select name="facultyId" class="form-select" style="font-size:0.8rem; padding:0.25rem 0.5rem;">
                                    <option value="">-- Unassigned --</option>
                                    <c:forEach var="fac" items="${facultyList}">
                                        <option value="${fac.id}" ${p.facultyId == fac.id ? 'selected' : ''}>
                                            <c:out value="${fac.name}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-secondary btn-sm" style="font-size:0.75rem; padding:0.25rem 0.5rem;">Reassign</button>
                            </form>
                        </td>
                        <td class="num-col">
                            <div style="display:flex; justify-content:flex-end; align-items:center; gap:0.75rem;">
                                <a href="${pageContext.request.contextPath}/project?id=${p.id}" class="btn btn-secondary btn-sm">Inspect</a>
                                <form action="${pageContext.request.contextPath}/project/delete" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="projectId" value="${p.id}">
                                    <button type="submit" class="btn-inline" style="color:var(--delayed); font-size:0.8rem;" data-confirm="Permanently delete project '${p.title}'?">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
