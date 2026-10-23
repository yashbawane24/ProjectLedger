<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found — ProjectLedger</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&amp;family=IBM+Plex+Sans:ital,wght@0,400;0,500;0,600;1,400&amp;family=Newsreader:ital,opsz,wght@0,6..72,500;0,6..72,600;1,6..72,500&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
</head>
<body style="display:flex; align-items:center; justify-content:center; min-height:100vh; padding: 2rem;">
    <div class="panel" style="max-width: 500px; width:100%; text-align:center; padding: 3rem 2rem;">
        <span class="label-caps" style="color: var(--atrisk);">HTTP 404</span>
        <h1 class="page-title" style="margin-top: 0.5rem; margin-bottom: 1rem;">Record Not Found</h1>
        <p style="color: var(--ink-soft); margin-bottom: 2rem;">
            The requested page or record could not be located in the ledger. It may have been removed or the link is incorrect.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return to Dashboard</a>
    </div>
</body>
</html>
