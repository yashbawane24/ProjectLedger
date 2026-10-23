<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">University Deadlines Management</h1>
        <div class="header-lead">Institution-wide evaluation milestones and project-specific submission schedules.</div>
    </div>
    <div class="header-actions">
        <button type="button" class="btn btn-primary" onclick="document.getElementById('newDeadlineDrawer').style.display = 'block';">
            + Add Academic Deadline
        </button>
    </div>
</div>

<!-- New Deadline Drawer -->
<div id="newDeadlineDrawer" class="panel" style="display:none; background-color:var(--paper); margin-bottom:2rem;">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
        <h2 class="section-title" style="margin-bottom:0;">Establish Academic Deadline</h2>
        <button type="button" class="btn-inline" onclick="document.getElementById('newDeadlineDrawer').style.display = 'none';">&times; Close</button>
    </div>
    <form action="${pageContext.request.contextPath}/admin/deadlines/save" method="post">
        <input type="hidden" name="csrfToken" value="${csrfToken}">

        <div class="form-group">
            <label class="form-label" for="dTitle">Deadline Title</label>
            <input type="text" id="dTitle" name="title" class="form-input" placeholder="e.g. Mid-Term Academic Progress Review" required>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label class="form-label" for="dDue">Target Due Date</label>
                <input type="date" id="dDue" name="dueDate" class="form-input mono-text" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="dProject">Scope Target</label>
                <select id="dProject" name="projectId" class="form-select">
                    <option value="">-- University Global (All Projects) --</option>
                    <c:forEach var="p" items="${projects}">
                        <option value="${p.id}"><c:out value="${p.title}"/></option>
                    </c:forEach>
                </select>
                <div class="form-help">Leave unselected to apply as a university-wide institutional deadline.</div>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Publish Deadline</button>
    </form>
</div>

<!-- Deadlines Table -->
<div class="panel">
    <div class="table-container" style="border:none;">
        <table class="table-ruled">
            <thead>
                <tr>
                    <th>Deadline Title</th>
                    <th>Target Scope</th>
                    <th>Published By</th>
                    <th class="num-col">Due Date</th>
                    <th class="num-col">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="d" items="${deadlines}">
                    <tr>
                        <td style="font-weight:600;"><c:out value="${d.title}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${d.global}">
                                    <span class="label-caps" style="color:var(--accent);">University Global</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-size:0.867rem;"><c:out value="${d.projectTitle}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${d.creatorName}"/></td>
                        <td class="num-col mono-text">
                            <strong>${d.dueDate}</strong>
                        </td>
                        <td class="num-col">
                            <form action="${pageContext.request.contextPath}/admin/deadlines/delete" method="post" style="display:inline;">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="deadlineId" value="${d.id}">
                                <button type="submit" class="btn-inline" style="color:var(--delayed); font-size:0.8rem;" data-confirm="Remove deadline '${d.title}'?">Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
