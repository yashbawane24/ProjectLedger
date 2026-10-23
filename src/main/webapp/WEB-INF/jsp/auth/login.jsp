<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — ProjectLedger</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=IBM+Plex+Mono:wght@400;500;600&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css?v=20261023_v6">
    <style>
        html, body.auth-body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            width: 100%;
            display: flex !important;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: #eff2ee !important;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #18221b;
        }

        .auth-centered-wrapper {
            width: 100%;
            max-width: 470px;
            padding: 30px 20px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .auth-brand-header {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: #18221b;
            font-weight: 800;
            font-size: 19px;
            letter-spacing: -0.01em;
            margin-bottom: 24px;
        }

        .auth-brand-logo-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: #1e4535;
            color: #d4f970;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 900;
            font-size: 14px;
        }

        .auth-card {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e3e8df;
            border-radius: 26px;
            padding: 36px 34px;
            box-shadow: 0 8px 30px rgba(24, 34, 27, 0.05);
            box-sizing: border-box;
        }

        .password-input-wrap {
            position: relative;
            width: 100%;
        }

        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #8fa89b;
            padding: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .password-toggle-btn:hover {
            color: #1e4535;
        }

        .auth-bottom-meta {
            margin-top: 24px;
            font-size: 12px;
            color: #7b887f;
            text-align: center;
        }
    </style>
</head>
<body class="auth-body">

<div class="auth-centered-wrapper">
    <!-- Brand Logo Header -->
    <a href="${pageContext.request.contextPath}/landing" class="auth-brand-header">
        <div class="auth-brand-logo-icon">PL</div>
        <span>ProjectLedger</span>
    </a>

    <!-- Main Sign In Card -->
    <div class="auth-card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <a href="${pageContext.request.contextPath}/landing" class="btn-back-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                <span>Back to Overview</span>
            </a>
            <span class="role-pill-indicator" id="rolePill">
                <c:choose>
                    <c:when test="${selectedRole == 'faculty'}">Faculty Portal</c:when>
                    <c:when test="${selectedRole == 'admin'}">Admin Portal</c:when>
                    <c:otherwise>Student Portal</c:otherwise>
                </c:choose>
            </span>
        </div>

        <!-- Role Selector Tabs -->
        <div class="role-tabs-bar" role="tablist">
            <a href="${pageContext.request.contextPath}/login?role=student"
               onclick="return switchRoleTab('student', event);"
               id="tabStudent"
               class="role-tab ${selectedRole == 'student' || empty selectedRole ? 'active' : ''}">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                <span>Student</span>
            </a>
            <a href="${pageContext.request.contextPath}/login?role=faculty"
               onclick="return switchRoleTab('faculty', event);"
               id="tabFaculty"
               class="role-tab ${selectedRole == 'faculty' ? 'active' : ''}">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
                <span>Faculty</span>
            </a>
            <a href="${pageContext.request.contextPath}/login?role=admin"
               onclick="return switchRoleTab('admin', event);"
               id="tabAdmin"
               class="role-tab ${selectedRole == 'admin' ? 'active' : ''}">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                <span>Admin</span>
            </a>
        </div>

        <h1 class="page-title" id="pageHeading" style="margin-bottom: 1.5rem; font-size:24px; font-weight:800; color:#18221b;">
            <c:choose>
                <c:when test="${selectedRole == 'faculty'}">Faculty Sign In</c:when>
                <c:when test="${selectedRole == 'admin'}">Administrator Sign In</c:when>
                <c:otherwise>Student Sign In</c:otherwise>
            </c:choose>
        </h1>

        <!-- Flash messages / Role Access Alerts -->
        <c:if test="${flash != null}">
            <div class="flash-message flash-${flash.type}" role="alert" aria-live="polite" style="margin-bottom: 1.25rem;">
                <span><c:out value="${flash.message}"/></span>
                <button type="button" class="flash-close-btn" aria-label="Dismiss">&times;</button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" novalidate>
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="role" id="currentRoleInput" value="${selectedRole != null ? selectedRole : 'student'}">

            <div class="form-group" style="margin-bottom: 1.2rem;">
                <label for="email" class="form-label" style="font-size:12px; font-weight:700; color:#18221b; margin-bottom:5px; display:block;">University Email</label>
                <input type="email" id="email" name="email" class="form-input"
                       value="<c:out value="${email != null ? email : ''}"/>"
                       placeholder="${selectedRole == 'faculty' ? 'professor@vit.ac.in' : (selectedRole == 'admin' ? 'admin@projectledger.edu' : 'yourname@vitstudent.ac.in')}"
                       required autofocus autocomplete="email"
                       style="border-radius:12px; border:1px solid #dce2d9; padding:11px 14px; font-size:14px; width:100%; box-sizing:border-box;">
            </div>

            <div class="form-group" style="margin-bottom: 1.2rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                    <label for="password" class="form-label" style="font-size:12px; font-weight:700; color:#18221b; margin-bottom:0;">Password</label>
                    <a href="mailto:admin@projectledger.edu?subject=Password%20Reset%20Request" style="font-size:11px; color:#6b778c; text-decoration:underline;">Forgot?</a>
                </div>
                <div class="password-input-wrap">
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="••••••••" required autocomplete="current-password"
                           style="border-radius:12px; border:1px solid #dce2d9; padding:11px 40px 11px 14px; font-size:14px; width:100%; box-sizing:border-box;">
                    <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility()" aria-label="Toggle password visibility">
                        <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                    </button>
                </div>
            </div>

            <button type="submit" class="auth-submit-btn" id="submitBtn">
                <span id="submitBtnText">
                    <c:choose>
                        <c:when test="${selectedRole == 'faculty'}">Sign In as Faculty</c:when>
                        <c:when test="${selectedRole == 'admin'}">Sign In as Administrator</c:when>
                        <c:otherwise>Sign In as Student</c:otherwise>
                    </c:choose>
                </span>
                <div class="auth-arrow-badge">↗</div>
            </button>
        </form>

        <div class="auth-footer-help" style="margin-top: 1.5rem; text-align:center; font-size:12px; color:#6b778c;">
            <div id="footerNotice">
                <c:choose>
                    <c:when test="${selectedRole == 'faculty' || selectedRole == 'admin'}">
                        <span>Faculty and Admin accounts are provisioned exclusively by University IT Administration.</span>
                    </c:when>
                    <c:otherwise>
                        <span>New student? <a href="${pageContext.request.contextPath}/register" style="color:#1e4535; font-weight:700; text-decoration:underline;">Create a student account &rarr;</a></span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Bottom Meta Footnote -->
    <div class="auth-bottom-meta">
        Team 15 &middot; VIT Vellore &middot; Academic Capstone Project Monitoring System
    </div>
</div>

<script>
    const roleConfigs = {
        student: {
            title: 'Student Sign In',
            pill: 'Student Portal',
            placeholder: 'yourname@vitstudent.ac.in',
            btnText: 'Sign In as Student',
            footer: 'New student? <a href="${pageContext.request.contextPath}/register" style="color:#1e4535; font-weight:700; text-decoration:underline;">Create a student account &rarr;</a>'
        },
        faculty: {
            title: 'Faculty Sign In',
            pill: 'Faculty Portal',
            placeholder: 'professor@vit.ac.in',
            btnText: 'Sign In as Faculty',
            footer: 'Faculty accounts are provisioned exclusively by University IT Administration.'
        },
        admin: {
            title: 'Administrator Sign In',
            pill: 'Admin Portal',
            placeholder: 'admin@projectledger.edu',
            btnText: 'Sign In as Administrator',
            footer: 'Administrative oversight & governance portal.'
        }
    };

    let activeRole = '${selectedRole != null ? selectedRole : "student"}';

    function switchRoleTab(role, event) {
        if (event) {
            event.preventDefault();
        }
        activeRole = role;

        // Update tabs active state
        document.querySelectorAll('.role-tab').forEach(t => t.classList.remove('active'));
        const activeTab = document.getElementById('tab' + role.charAt(0).toUpperCase() + role.slice(1));
        if (activeTab) activeTab.classList.add('active');

        // Update config
        const conf = roleConfigs[role] || roleConfigs.student;
        document.getElementById('pageHeading').innerText = conf.title;
        document.getElementById('rolePill').innerText = conf.pill;
        document.getElementById('email').placeholder = conf.placeholder;
        document.getElementById('submitBtnText').innerText = conf.btnText;
        document.getElementById('footerNotice').innerHTML = conf.footer;
        document.getElementById('currentRoleInput').value = role;

        // Update URL parameter without reload
        if (window.history && window.history.replaceState) {
            const url = new URL(window.location);
            url.searchParams.set('role', role);
            window.history.replaceState({}, '', url);
        }
        return false;
    }

    function togglePasswordVisibility() {
        const passInput = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');
        if (passInput.type === 'password') {
            passInput.type = 'text';
            eyeIcon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line>';
        } else {
            passInput.type = 'password';
            eyeIcon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>';
        }
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
