<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<div class="page-header">
    <div>
        <h1 class="page-title">User Profile</h1>
        <div class="header-lead">Manage your academic credentials, GitHub process identity, and password security.</div>
    </div>
</div>

<div class="form-grid-2">
    <!-- Left Column: Personal Information -->
    <div class="panel">
        <h2 class="section-title">Personal Details</h2>
        <form action="${pageContext.request.contextPath}/profile" method="post">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="action" value="updateProfile">

            <div class="form-group">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" id="name" name="name" class="form-input ${profileErrors.name != null ? 'is-invalid' : ''}"
                       value="${user.name}" required>
                <c:if test="${profileErrors.name != null}">
                    <div class="form-error"><c:out value="${profileErrors.name}"/></div>
                </c:if>
            </div>

            <div class="form-group">
                <label class="form-label">University Email</label>
                <input type="email" class="form-input" value="${user.email}" disabled style="background-color: var(--paper); cursor: not-allowed;">
                <div class="form-help">Email is managed by university directory and cannot be modified.</div>
            </div>

            <div class="form-group">
                <label class="form-label">Role</label>
                <input type="text" class="form-input mono-text" value="${user.role.displayName}" disabled style="background-color: var(--paper); cursor: not-allowed;">
            </div>

            <c:if test="${user.regNo != null}">
                <div class="form-group">
                    <label class="form-label">Registration Number</label>
                    <input type="text" class="form-input mono-text" value="${user.regNo}" disabled style="background-color: var(--paper); cursor: not-allowed;">
                </div>
            </c:if>

            <div class="form-group">
                <label for="githubUsername" class="form-label">GitHub Username</label>
                <input type="text" id="githubUsername" name="githubUsername" class="form-input mono-text"
                       value="${user.githubUsername != null ? user.githubUsername : ''}"
                       placeholder="octocat">
                <div class="form-help">Facilitates commit attribution and contribution evidence for faculty.</div>
            </div>

            <button type="submit" class="btn btn-primary">Save Profile Changes</button>
        </form>
    </div>

    <!-- Right Column: Change Password -->
    <div class="panel">
        <h2 class="section-title">Change Password</h2>
        <form action="${pageContext.request.contextPath}/profile" method="post">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="action" value="changePassword">

            <div class="form-group">
                <label for="currentPassword" class="form-label">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" class="form-input ${passwordErrors.currentPassword != null ? 'is-invalid' : ''}" required>
                <c:if test="${passwordErrors.currentPassword != null}">
                    <div class="form-error"><c:out value="${passwordErrors.currentPassword}"/></div>
                </c:if>
            </div>

            <div class="form-group">
                <label for="newPassword" class="form-label">New Password</label>
                <input type="password" id="newPassword" name="newPassword" class="form-input ${passwordErrors.newPassword != null ? 'is-invalid' : ''}" required placeholder="Minimum 6 characters">
                <c:if test="${passwordErrors.newPassword != null}">
                    <div class="form-error"><c:out value="${passwordErrors.newPassword}"/></div>
                </c:if>
            </div>

            <div class="form-group">
                <label for="confirmNewPassword" class="form-label">Confirm New Password</label>
                <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-input ${passwordErrors.confirmNewPassword != null ? 'is-invalid' : ''}" required placeholder="Re-type new password">
                <c:if test="${passwordErrors.confirmNewPassword != null}">
                    <div class="form-error"><c:out value="${passwordErrors.confirmNewPassword}"/></div>
                </c:if>
            </div>

            <button type="submit" class="btn btn-secondary">Update Password</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
