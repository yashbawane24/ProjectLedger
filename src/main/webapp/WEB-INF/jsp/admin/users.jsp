<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">User Accounts Administration</h1>
        <div class="header-lead">Directory of students, faculty supervisors, and system administrators.</div>
    </div>
    <div class="header-actions">
        <button type="button" class="btn btn-primary" onclick="document.getElementById('newUserDrawer').style.display = 'block';">
            + Provision Account
        </button>
    </div>
</div>

<!-- Provision Account Drawer -->
<div id="newUserDrawer" class="panel" style="display:none; background-color:var(--paper); margin-bottom:2rem;">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
        <h2 class="section-title" style="margin-bottom:0;">Provision Faculty or Administrator Account</h2>
        <button type="button" class="btn-inline" onclick="document.getElementById('newUserDrawer').style.display = 'none';">&times; Close</button>
    </div>
    <form action="${pageContext.request.contextPath}/admin/users/save" method="post">
        <input type="hidden" name="csrfToken" value="${csrfToken}">

        <div class="form-grid-3">
            <div class="form-group">
                <label class="form-label" for="uName">Full Name</label>
                <input type="text" id="uName" name="name" class="form-input" placeholder="e.g. Dr. Jane Smith" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="uEmail">University Email</label>
                <input type="email" id="uEmail" name="email" class="form-input" placeholder="name@projectledger.edu" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="uRole">Account Role</label>
                <select id="uRole" name="role" class="form-select">
                    <option value="FACULTY">Faculty Member</option>
                    <option value="ADMIN">System Administrator</option>
                </select>
            </div>
        </div>

        <div class="form-grid-2">
            <div class="form-group">
                <label class="form-label" for="uDept">Academic Department</label>
                <input type="text" id="uDept" name="department" class="form-input" placeholder="e.g. Computer Science &amp; Engineering">
            </div>

            <div class="form-group">
                <label class="form-label" for="uPass">Initial Temporary Password</label>
                <input type="password" id="uPass" name="password" class="form-input" placeholder="Minimum 6 characters" required>
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Create User Account</button>
    </form>
</div>

<!-- Search Filter Bar -->
<div class="panel" style="padding:1rem 1.25rem; margin-bottom:1.5rem;">
    <form action="${pageContext.request.contextPath}/admin/users" method="get" style="display:flex; gap:0.75rem; align-items:center;">
        <input type="text" name="q" class="form-input" placeholder="Search by name, email, or registration number..."
               value="<c:out value="${query != null ? query : ''}"/>" style="max-width:400px;">
        <button type="submit" class="btn btn-secondary btn-sm">Filter Directory</button>
        <c:if test="${query != null and not empty query}">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn-inline" style="font-size:0.867rem;">Clear search</a>
        </c:if>
    </form>
</div>

<!-- Users Table -->
<div class="table-container">
    <table class="table-ruled">
        <thead>
            <tr>
                <th>User Details</th>
                <th>Role</th>
                <th>Identifier / Dept</th>
                <th>Status</th>
                <th class="num-col">Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td>
                        <div style="font-weight:600;"><c:out value="${u.name}"/></div>
                        <div class="mono-text" style="font-size:0.75rem; color:var(--ink-soft);"><c:out value="${u.email}"/></div>
                    </td>
                    <td>
                        <span class="label-caps">${u.role.displayName}</span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${u.regNo != null}">
                                <span class="mono-text">${u.regNo}</span>
                            </c:when>
                            <c:when test="${u.department != null}">
                                <c:out value="${u.department}"/>
                            </c:when>
                            <c:otherwise>&mdash;</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <span class="label-caps" style="color: ${u.active ? 'var(--ontrack)' : 'var(--delayed)'};">
                            ${u.active ? 'Active' : 'Deactivated'}
                        </span>
                    </td>
                    <td class="num-col">
                        <div style="display:flex; justify-content:flex-end; gap:0.75rem; align-items:center;">
                            <!-- Reset Password -->
                            <form action="${pageContext.request.contextPath}/admin/users/reset-password" method="post" style="display:inline;">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="userId" value="${u.id}">
                                <button type="submit" class="btn-inline" data-confirm="Reset password for ${u.name}? A temporary password will be generated and displayed.">
                                    Reset Password
                                </button>
                            </form>

                            <!-- Toggle Status -->
                            <c:if test="${u.id != sessionScope.currentUser.id}">
                                <form action="${pageContext.request.contextPath}/admin/users/toggle" method="post" style="display:inline;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <input type="hidden" name="active" value="${u.active}">
                                    <button type="submit" class="btn-inline" style="color: ${u.active ? 'var(--delayed)' : 'var(--ontrack)'};"
                                            data-confirm="${u.active ? 'Deactivate user ' : 'Reactivate user '}${u.name}?">
                                        ${u.active ? 'Deactivate' : 'Reactivate'}
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
