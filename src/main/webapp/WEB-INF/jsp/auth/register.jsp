<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration — ProjectLedger</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;family=IBM+Plex+Mono:wght@400;500;600&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css?v=20261023_v2">
    <style>
        html, body.auth-body { margin: 0; padding: 0; min-height: 100vh; width: 100%; display: block !important; background: #ffffff !important; }
    </style>
</head>
<body class="auth-body">
<div class="auth-split-wrapper">
    <!-- Left Calm Accent Panel -->
    <div class="auth-split-brand">
        <div>
            <div class="auth-split-brand-title">ProjectLedger</div>
            <div class="label-caps" style="color: var(--highlight); margin-top: 0.5rem;">Academic Project Development &amp; Continuous Monitoring Platform</div>
        </div>
        <div class="auth-split-brand-tagline">
            “Accountability throughout the development lifecycle.”
        </div>
        <div class="auth-split-meta">
            Faculty and Administrator accounts are provisioned exclusively by Academic Administration.
        </div>
    </div>

    <!-- Right Paper Form Panel -->
    <div class="auth-split-form-panel">
        <h1 class="page-title">Create Student Account</h1>
        <p class="header-lead" style="margin-bottom: 2rem;">Register your student credentials to join teams and manage academic deliverables.</p>

        <!-- Flash messages -->
        <c:if test="${flash != null}">
            <div class="flash-message flash-${flash.type}" role="alert" aria-live="polite">
                <span><c:out value="${flash.message}"/></span>
                <button type="button" class="flash-close-btn" aria-label="Dismiss">&times;</button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
            <input type="hidden" name="csrfToken" value="${csrfToken}">

            <div class="form-group">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" id="name" name="name" class="form-input ${errors.name != null ? 'is-invalid' : ''}"
                       value="<c:out value="${name != null ? name : ''}"/>"
                       placeholder="e.g. Bawane Yash Sunil" required autofocus>
                <c:if test="${errors.name != null}">
                    <div class="form-error"><c:out value="${errors.name}"/></div>
                </c:if>
            </div>

            <div class="form-grid-2">
                <div class="form-group">
                    <label for="email" class="form-label">University Email</label>
                    <input type="email" id="email" name="email" class="form-input ${errors.email != null ? 'is-invalid' : ''}"
                           value="<c:out value="${email != null ? email : ''}"/>"
                           placeholder="student@projectledger.edu" required autocomplete="email">
                    <c:if test="${errors.email != null}">
                        <div class="form-error"><c:out value="${errors.email}"/></div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="regNo" class="form-label">Registration Number</label>
                    <input type="text" id="regNo" name="regNo" class="form-input mono-text ${errors.regNo != null ? 'is-invalid' : ''}"
                           value="<c:out value="${regNo != null ? regNo : ''}"/>"
                           placeholder="24BBS0119" required>
                    <c:if test="${errors.regNo != null}">
                        <div class="form-error"><c:out value="${errors.regNo}"/></div>
                    </c:if>
                </div>
            </div>

            <div class="form-group">
                <label for="githubUsername" class="form-label">GitHub Username <span style="font-weight:normal; text-transform:none;">(Optional)</span></label>
                <input type="text" id="githubUsername" name="githubUsername" class="form-input mono-text"
                       value="<c:out value="${githubUsername != null ? githubUsername : ''}"/>"
                       placeholder="octocat">
                <div class="form-help">Used by faculty to attribute process contributions and commit history.</div>
            </div>

            <div class="form-grid-2">
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-input ${errors.password != null ? 'is-invalid' : ''}"
                           placeholder="Minimum 6 characters" required autocomplete="new-password">
                    <c:if test="${errors.password != null}">
                        <div class="form-error"><c:out value="${errors.password}"/></div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input ${errors.confirmPassword != null ? 'is-invalid' : ''}"
                           placeholder="Re-type password" required autocomplete="new-password">
                    <c:if test="${errors.confirmPassword != null}">
                        <div class="form-error"><c:out value="${errors.confirmPassword}"/></div>
                    </c:if>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 0.75rem; padding: 0.75rem;">
                Complete Registration
            </button>
        </form>

        <div style="margin-top: 1.5rem; text-align: center; font-size: 0.867rem; color: var(--ink-soft);">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
