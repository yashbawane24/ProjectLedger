<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="ProjectLedger — Academic Project Development and Continuous Process Monitoring Platform">
    <title><c:out value="${pageTitle != null ? pageTitle : 'ProjectLedger'}"/> — ProjectLedger</title>

    <!-- Modern Typography: Plus Jakarta Sans & Inter, IBM Plex Mono for technical data -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&amp;family=Inter:wght@400;500;600;700&amp;family=IBM+Plex+Mono:wght@400;500;600&amp;display=swap" rel="stylesheet">

    <!-- Design System -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css?v=20261023_v5">
</head>
<body>
<div class="app-container">
