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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;family=IBM+Plex+Mono:wght@400;500;600&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css?v=20261023_v7">
    <style>
        html, body.auth-body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            width: 100%;
            background: #f8faf7 !important;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #18221b;
        }

        .auth-split-form-panel {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 24px;
            background: #eff2ee;
            box-sizing: border-box;
            min-height: 100vh;
        }

        .auth-form-container {
            width: 100%;
            max-width: 520px;
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

        .form-label {
            font-size: 12px;
            font-weight: 700;
            color: #18221b;
            margin-bottom: 6px;
            display: block;
        }

        .form-input {
            border-radius: 12px;
            border: 1px solid #dce2d9;
            padding: 10px 14px;
            font-size: 14px;
            width: 100%;
            box-sizing: border-box;
            background: #ffffff;
            color: #18221b;
            transition: all 0.15s ease;
        }

        .form-input:focus {
            border-color: #1e4535;
            outline: none;
            box-shadow: 0 0 0 3px rgba(30, 69, 53, 0.1);
        }

        .form-input.is-invalid {
            border-color: #d9383a;
            background-color: #fff8f8;
        }

        .form-error {
            font-size: 11px;
            color: #d9383a;
            margin-top: 4px;
            font-weight: 500;
        }

        .form-help {
            font-size: 11px;
            color: #7b887f;
            margin-top: 4px;
            line-height: 1.4;
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 1.1rem;
        }

        @media (max-width: 600px) {
            .form-grid-2 {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            .auth-form-container {
                padding: 26px 20px;
            }
        }
    </style>
</head>
<body class="auth-body">
<div class="auth-split-wrapper">
    <!-- Left Calm Accent Panel -->
    <div class="auth-split-brand">
        <div class="auth-brand-content">
            <a href="${pageContext.request.contextPath}/landing" class="auth-logo-badge">
                <div class="auth-logo-icon">PL</div>
                <span>ProjectLedger</span>
            </a>

            <div class="auth-brand-headline">
                Empowering <span>Academic</span> Excellence.
            </div>

            <p class="auth-brand-subtext">
                Continuous evaluation, GitHub commit telemetry, and transparent milestone tracking across your capstone engineering lifecycle.
            </p>

            <div class="auth-brand-features">
                <div class="auth-feature-chip">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Real-time milestone progress &amp; task boards</span>
                </div>
                <div class="auth-feature-chip">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Automated GitHub commit attribution per student</span>
                </div>
                <div class="auth-feature-chip">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Rubric-based faculty evaluation &amp; feedback</span>
                </div>
            </div>
        </div>

        <div class="auth-split-meta">
            Faculty and Administrator accounts are provisioned exclusively by Academic Administration.
        </div>
    </div>

    <!-- Right Paper Form Panel -->
    <div class="auth-split-form-panel">
        <div class="auth-form-container">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                <a href="${pageContext.request.contextPath}/login" class="btn-back-link">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                    <span>Back to Sign In</span>
                </a>
                <span class="role-pill-indicator">Student Portal</span>
            </div>

            <h1 class="page-title" style="font-size: 22px; font-weight: 800; color: #18221b; margin: 0 0 4px 0;">Create Student Account</h1>
            <p style="font-size: 13px; color: #6b778c; margin: 0 0 1.4rem 0; line-height: 1.5;">Register your student credentials to join capstone teams and track deliverables.</p>

            <!-- Flash messages -->
            <c:if test="${flash != null}">
                <div class="flash-message flash-${flash.type}" role="alert" aria-live="polite" style="margin-bottom: 1.25rem;">
                    <span><c:out value="${flash.message}"/></span>
                    <button type="button" class="flash-close-btn" aria-label="Dismiss">&times;</button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="form-group" style="margin-bottom: 1.1rem;">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" id="name" name="name" class="form-input ${errors.name != null ? 'is-invalid' : ''}"
                           value="<c:out value="${name != null ? name : ''}"/>"
                           placeholder="e.g. Bawane Yash Sunil" required autofocus>
                    <c:if test="${errors.name != null}">
                        <div class="form-error"><c:out value="${errors.name}"/></div>
                    </c:if>
                </div>

                <div class="form-grid-2">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="email" class="form-label">University Email</label>
                        <input type="email" id="email" name="email" class="form-input ${errors.email != null ? 'is-invalid' : ''}"
                               value="<c:out value="${email != null ? email : ''}"/>"
                               placeholder="yourname@vitstudent.ac.in" required autocomplete="email">
                        <c:if test="${errors.email != null}">
                            <div class="form-error"><c:out value="${errors.email}"/></div>
                        </c:if>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="regNo" class="form-label">Registration Number</label>
                        <input type="text" id="regNo" name="regNo" class="form-input mono-text ${errors.regNo != null ? 'is-invalid' : ''}"
                               value="<c:out value="${regNo != null ? regNo : ''}"/>"
                               placeholder="24BBS0119" required>
                        <c:if test="${errors.regNo != null}">
                            <div class="form-error"><c:out value="${errors.regNo}"/></div>
                        </c:if>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 1.1rem;">
                    <label for="githubUsername" class="form-label">GitHub Username <span style="font-weight:normal; color:#7b887f;">(Optional)</span></label>
                    <input type="text" id="githubUsername" name="githubUsername" class="form-input mono-text"
                           value="<c:out value="${githubUsername != null ? githubUsername : ''}"/>"
                           placeholder="octocat">
                    <div class="form-help">Used by faculty to attribute commit activity and telemetry.</div>
                </div>

                <div class="form-grid-2">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="password" class="form-label">Password</label>
                        <div class="password-input-wrap">
                            <input type="password" id="password" name="password" class="form-input ${errors.password != null ? 'is-invalid' : ''}"
                                   placeholder="Min. 6 characters" required autocomplete="new-password" style="padding-right: 36px;">
                            <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('password', 'eye1')" aria-label="Toggle password visibility">
                                <svg id="eye1" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </button>
                        </div>
                        <c:if test="${errors.password != null}">
                            <div class="form-error"><c:out value="${errors.password}"/></div>
                        </c:if>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="password-input-wrap">
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input ${errors.confirmPassword != null ? 'is-invalid' : ''}"
                                   placeholder="Re-type password" required autocomplete="new-password" style="padding-right: 36px;">
                            <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('confirmPassword', 'eye2')" aria-label="Toggle password visibility">
                                <svg id="eye2" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                            </button>
                        </div>
                        <c:if test="${errors.confirmPassword != null}">
                            <div class="form-error"><c:out value="${errors.confirmPassword}"/></div>
                        </c:if>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">
                    <span>Complete Registration</span>
                    <div class="auth-arrow-badge">↗</div>
                </button>
            </form>

            <div style="margin-top: 1.4rem; text-align: center; font-size: 13px; color: #6b778c;">
                Already have an account? <a href="${pageContext.request.contextPath}/login" style="color: #1e4535; font-weight: 700; text-decoration: underline;">Sign in &rarr;</a>
            </div>
        </div>
    </div>
</div>

<script>
    function togglePasswordVisibility(fieldId, iconId) {
        const passInput = document.getElementById(fieldId);
        const eyeIcon = document.getElementById(iconId);
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
