<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ProjectLedger — Track the work, not just the submission</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css?v=20261023_v5">
    
    <style>
        :root {
            --pl-canvas: #eaede9;
            --pl-forest: #1e4535;
            --pl-forest-dark: #163628;
            --pl-lime: #d4f970;
            --pl-lime-dark: #bfe955;
            --pl-black: #18221b;
            --pl-card-bg: #ffffff;
            --pl-card-subtle: #f7f9f6;
            --pl-border: #e0e6dd;
            --pl-text: #18221b;
            --pl-muted: #6b778c;
            --pl-sage: #8fa89b;
        }

        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body.pl-landing-page {
            display: block !important;
            width: 100% !important;
            min-height: 100vh;
            margin: 0 !important;
            padding: 0 !important;
            background-color: var(--pl-canvas) !important;
            color: var(--pl-text);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            font-size: 14px;
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }

        .pl-shell {
            max-width: 1220px;
            margin: 0 auto;
            padding: 16px 20px 48px;
        }

        /* -------------------------------------------------------------------------
           1. Top Navigation Bar (White floating card)
           ------------------------------------------------------------------------- */
        .pl-header {
            background: #ffffff;
            border-radius: 24px;
            padding: 10px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
        }

        .pl-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            color: var(--pl-black);
            font-weight: 800;
            font-size: 16px;
            letter-spacing: -0.01em;
        }

        .pl-brand-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: var(--pl-forest);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
        }

        .pl-nav-pill-group {
            background: #f2f5f1;
            border-radius: 30px;
            padding: 4px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .pl-nav-link {
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            color: #4b5563;
            padding: 6px 16px;
            border-radius: 20px;
            transition: all 0.15s ease;
        }

        .pl-nav-link:hover {
            color: var(--pl-black);
        }

        .pl-nav-link.active {
            background: var(--pl-black);
            color: #ffffff;
            font-weight: 600;
        }

        .pl-btn-get-started {
            background: var(--pl-black);
            color: #ffffff;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            padding: 7px 8px 7px 18px;
            border-radius: 24px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: opacity 0.15s ease;
        }

        .pl-btn-get-started:hover {
            opacity: 0.92;
        }

        .pl-arrow-lime-badge {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--pl-lime);
            color: var(--pl-black);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 13px;
        }

        /* -------------------------------------------------------------------------
           2. Giant Forest Green Hero Card
           ------------------------------------------------------------------------- */
        .pl-hero-card {
            background: var(--pl-forest);
            border-radius: 36px;
            padding: 56px 54px;
            color: #ffffff;
            position: relative;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 48px;
            margin-bottom: 24px;
        }

        /* Diagonal subtle stripes in bottom right */
        .pl-hero-card::after {
            content: "";
            position: absolute;
            bottom: -30px;
            right: -30px;
            width: 280px;
            height: 280px;
            background: repeating-linear-gradient(45deg, rgba(255,255,255,0.04), rgba(255,255,255,0.04) 5px, transparent 5px, transparent 15px);
            border-radius: 50%;
            pointer-events: none;
        }

        .pl-hero-badge {
            display: inline-flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.12);
            padding: 5px 14px 5px 6px;
            border-radius: 24px;
            font-size: 12px;
            color: #e2f0d9;
            margin-bottom: 24px;
            gap: 8px;
        }

        .pl-badge-new {
            background: var(--pl-lime);
            color: var(--pl-black);
            font-size: 10px;
            font-weight: 800;
            padding: 2px 7px;
            border-radius: 12px;
            letter-spacing: 0.04em;
        }

        .pl-hero-title {
            font-size: 52px;
            font-weight: 800;
            line-height: 1.05;
            letter-spacing: -0.03em;
            color: #ffffff;
            margin-bottom: 22px;
        }

        .pl-hero-title span.lime-word {
            color: var(--pl-lime);
        }

        .pl-hero-desc {
            font-size: 15px;
            color: #c4d7cc;
            line-height: 1.5;
            max-width: 440px;
            margin-bottom: 34px;
        }

        .pl-hero-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
        }

        .pl-btn-role {
            background: var(--pl-lime);
            color: var(--pl-black);
            font-weight: 700;
            border-radius: 28px;
            padding: 10px 12px 10px 22px;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            transition: all 0.15s ease;
        }

        .pl-btn-role:hover {
            background: var(--pl-lime-dark);
        }

        .pl-circle-black-icon {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: var(--pl-black);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 12px;
        }

        .pl-btn-demo {
            background: transparent;
            color: #ffffff;
            border: 1.5px solid rgba(255, 255, 255, 0.35);
            border-radius: 28px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.15s ease;
        }

        .pl-btn-demo:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.6);
        }

        /* -------------------------------------------------------------------------
           Right Hero Widgets Stack (Exact reproduction of Image 1)
           ------------------------------------------------------------------------- */
        .pl-hero-widgets {
            display: flex;
            flex-direction: column;
            gap: 14px;
            position: relative;
            z-index: 2;
        }

        /* Widget 1: Sample Project Card */
        .pl-card-sample {
            background: #ffffff;
            color: var(--pl-black);
            border-radius: 20px;
            padding: 20px 24px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.14);
        }

        .pl-sample-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .pl-sample-label {
            font-size: 12px;
            color: #8fa89b;
            font-weight: 500;
        }

        .pl-pill-status {
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .pl-pill-status.at-risk {
            background: #fff3e3;
            color: #bf6a12;
        }

        .pl-pill-status.at-risk::before {
            content: "•";
            font-size: 16px;
            line-height: 1;
            color: #bf6a12;
        }

        .pl-sample-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--pl-black);
            margin-bottom: 14px;
            letter-spacing: -0.01em;
        }

        .pl-progress-meta {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .pl-progress-meta strong {
            font-weight: 800;
            font-size: 16px;
        }

        .pl-progress-meta span {
            color: #6b778c;
            font-size: 12px;
        }

        .pl-striped-track {
            height: 10px;
            border-radius: 6px;
            background: repeating-linear-gradient(45deg, #e7eae4, #e7eae4 4px, #dadfd7 4px, #dadfd7 8px);
            position: relative;
            overflow: hidden;
            margin-bottom: 16px;
        }

        .pl-striped-fill {
            height: 100%;
            background: var(--pl-forest);
            border-radius: 6px;
        }

        .pl-expected-tick {
            position: absolute;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #000000;
            z-index: 2;
        }

        .pl-sample-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .pl-avatar-stack {
            display: flex;
            align-items: center;
        }

        .pl-avatar-circle {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            font-weight: 700;
            border: 2px solid #ffffff;
            margin-right: -6px;
        }

        .pl-avatar-circle.c1 { background: #d7f58d; color: #354e17; }
        .pl-avatar-circle.c2 { background: #d3e7fc; color: #1e4577; }
        .pl-avatar-circle.c3 { background: #fde0cb; color: #7a3a14; }

        .pl-sample-overdue {
            font-size: 11px;
            color: #6b778c;
            font-weight: 500;
        }

        /* Widget 2: Lime Commits Card */
        .pl-card-commits {
            background: var(--pl-lime);
            color: var(--pl-black);
            border-radius: 20px;
            padding: 18px 24px;
        }

        .pl-commits-label {
            font-size: 12px;
            font-weight: 600;
            color: #314421;
            margin-bottom: 10px;
        }

        .pl-capsules-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
        }

        .pl-capsule {
            border-radius: 14px;
            display: inline-block;
        }

        .pl-capsule.cap1 { width: 50px; height: 18px; background: #1e4535; }
        .pl-capsule.cap2 { width: 56px; height: 26px; background: #2f5f4b; }
        .pl-capsule.cap3 { width: 48px; height: 18px; background: #1e4535; }
        .pl-capsule.cap4 { width: 62px; height: 32px; background: #18221b; }
        .pl-capsule.cap5 {
            width: 52px;
            height: 20px;
            background: repeating-linear-gradient(45deg, rgba(24,34,27,0.15), rgba(24,34,27,0.15) 3px, transparent 3px, transparent 6px);
            border: 1px solid rgba(24,34,27,0.25);
        }

        .pl-commits-count {
            font-size: 28px;
            font-weight: 900;
            line-height: 1;
            letter-spacing: -0.02em;
        }

        /* Widget 3: Dark Milestone Card */
        .pl-card-milestone {
            background: #141d16;
            color: #ffffff;
            border-radius: 18px;
            padding: 16px 22px;
        }

        .pl-ms-sub {
            font-size: 11px;
            color: #9da89f;
            margin-bottom: 4px;
        }

        .pl-ms-title {
            font-size: 17px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .pl-ms-pill {
            background: rgba(255, 255, 255, 0.12);
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            color: #ffffff;
            display: inline-block;
            font-weight: 500;
        }

        /* -------------------------------------------------------------------------
           3. Sign In Section ("Who's signing in today?")
           ------------------------------------------------------------------------- */
        .pl-signin-section {
            background: #ffffff;
            border-radius: 32px;
            padding: 40px 44px;
            margin-bottom: 24px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.02);
        }

        .pl-signin-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 28px;
        }

        .pl-signin-label {
            font-size: 13px;
            font-weight: 600;
            color: var(--pl-muted);
            margin-bottom: 4px;
        }

        .pl-signin-h2 {
            font-size: 34px;
            font-weight: 800;
            color: var(--pl-black);
            letter-spacing: -0.02em;
            line-height: 1.1;
        }

        .pl-signin-sub {
            font-size: 13px;
            color: var(--pl-muted);
            max-width: 330px;
            line-height: 1.45;
            text-align: left;
        }

        /* 3 Role Cards Grid */
        .pl-roles-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .pl-role-box {
            border-radius: 22px;
            padding: 26px 24px;
            cursor: pointer;
            transition: all 0.22s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 210px;
        }

        .pl-role-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 28px rgba(0, 0, 0, 0.08);
        }

        /* Active / Selected Role Card (Default: Student) */
        .pl-role-box.active {
            background: var(--pl-forest) !important;
            color: #ffffff !important;
            border: 1.5px solid transparent !important;
        }

        .pl-role-box.active:hover {
            background: var(--pl-forest-dark) !important;
        }

        .pl-role-box.inactive {
            background: var(--pl-card-subtle);
            color: var(--pl-black);
            border: 1.5px solid #e7ece4;
        }

        .pl-role-box.inactive:hover {
            border-color: #cbd5c5;
            background: #ffffff;
        }

        .pl-role-icon-bar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 28px;
        }

        .pl-role-icon-box {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pl-role-box.active .pl-role-icon-box {
            background: var(--pl-lime);
            color: var(--pl-black);
        }

        .pl-role-box.inactive .pl-role-icon-box {
            background: #ffffff;
            color: var(--pl-black);
            border: 1px solid #e2e8de;
        }

        .pl-role-arrow-circle {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 800;
            transition: transform 0.2s ease, background-color 0.2s ease;
        }

        .pl-role-box.active .pl-role-arrow-circle {
            background: #ffffff;
            color: var(--pl-black);
        }

        .pl-role-box.active:hover .pl-role-arrow-circle {
            background: var(--pl-lime);
            transform: translate(2px, -2px);
        }

        .pl-role-box.inactive .pl-role-arrow-circle {
            background: #ffffff;
            color: #8c97a7;
            border: 1px solid #e2e8de;
        }

        .pl-role-box.inactive:hover .pl-role-arrow-circle {
            color: var(--pl-forest);
            border-color: var(--pl-forest);
            transform: translate(2px, -2px);
        }

        .pl-role-tag-pill {
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 3px 8px;
            border-radius: 6px;
            width: fit-content;
            margin-bottom: 8px;
            display: inline-block;
        }

        .pl-role-box.active .pl-role-tag-pill {
            background: rgba(212, 249, 112, 0.2);
            color: var(--pl-lime);
        }

        .pl-role-box.inactive .pl-role-tag-pill {
            background: #eaf0e8;
            color: #3b5043;
        }

        .pl-role-title {
            font-size: 21px;
            font-weight: 800;
            margin-bottom: 6px;
            letter-spacing: -0.01em;
        }

        .pl-role-box.active .pl-role-title { color: #ffffff; }
        .pl-role-box.inactive .pl-role-title { color: var(--pl-black); }

        .pl-role-desc {
            font-size: 13px;
            line-height: 1.45;
            margin-bottom: 12px;
        }

        .pl-role-box.active .pl-role-desc { color: #c4d7cc; }
        .pl-role-box.inactive .pl-role-desc { color: #6b778c; }

        .pl-role-action-link {
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .pl-role-box.active .pl-role-action-link {
            color: var(--pl-lime);
        }

        .pl-role-box.inactive .pl-role-action-link {
            color: var(--pl-forest);
        }

        /* -------------------------------------------------------------------------
           4. Dedicated Portal Launch Strip (Replaces cramped bottom form)
           ------------------------------------------------------------------------- */
        .pl-portal-launch-strip {
            background: #f3f5f2;
            border-radius: 20px;
            padding: 22px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            border: 1px solid #e2e8de;
            flex-wrap: wrap;
        }

        .pl-drawer-left {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .pl-drawer-role-pill {
            background: var(--pl-black);
            color: #ffffff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 12px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            width: fit-content;
        }

        .pl-drawer-role-pill::before {
            content: "";
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--pl-lime);
        }

        .pl-drawer-h3 {
            font-size: 17px;
            font-weight: 800;
            color: var(--pl-black);
            letter-spacing: -0.01em;
        }

        .pl-drawer-new {
            font-size: 12px;
            color: #6b778c;
        }

        .pl-portal-btn-row {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .pl-portal-launch-btn {
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            padding: 10px 18px;
            border-radius: 26px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.18s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .pl-portal-launch-btn.primary {
            background: var(--pl-forest);
            color: #ffffff;
        }

        .pl-portal-launch-btn.primary:hover {
            background: var(--pl-forest-dark);
            transform: translateY(-1px);
        }

        .pl-portal-launch-btn.secondary {
            background: #ffffff;
            color: var(--pl-black);
            border: 1px solid #dce2d9;
        }

        .pl-portal-launch-btn.secondary:hover {
            background: #f8faf7;
            border-color: #cbd4c8;
            transform: translateY(-1px);
        }

        .pl-arrow-circle-sm {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #eff3ee;
            color: #4b5563;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 800;
        }

        /* -------------------------------------------------------------------------
           5. Footer Strip (Matching bottom of Image 1)
           ------------------------------------------------------------------------- */
        .pl-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 8px;
            font-size: 12px;
            color: #6b778c;
        }

        .pl-footer strong {
            color: var(--pl-black);
            font-weight: 600;
            margin: 0 4px;
        }

        /* Responsive Breakpoints */
        @media (max-width: 980px) {
            .pl-hero-card {
                grid-template-columns: 1fr;
                padding: 40px 28px;
            }
            .pl-roles-row {
                grid-template-columns: 1fr;
            }
            .pl-auth-drawer {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            .pl-footer {
                flex-direction: column;
                gap: 8px;
                text-align: center;
            }
        }
    </style>
</head>
<body class="pl-landing-page">

<div class="pl-shell">

    <!-- Top Navigation Bar -->
    <header class="pl-header">
        <a href="${pageContext.request.contextPath}/" class="pl-brand">
            <div class="pl-brand-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>
            <span>ProjectLedger</span>
        </a>

        <nav class="pl-nav-pill-group" aria-label="Main Navigation">
            <a href="${pageContext.request.contextPath}/landing" class="pl-nav-link active">Home</a>
            <a href="#roles" class="pl-nav-link">Features</a>
            <a href="#roles" class="pl-nav-link">Sign in</a>
            <a href="mailto:admin@projectledger.edu" class="pl-nav-link">Contact</a>
        </nav>

        <a href="#roles" class="pl-btn-get-started">
            <span>Get started</span>
            <div class="pl-arrow-lime-badge">↗</div>
        </a>
    </header>

    <!-- Giant Forest Green Hero Card -->
    <section class="pl-hero-card">
        <div>
            <div class="pl-hero-badge">
                <span class="pl-badge-new">NEW</span>
                <span>GitHub activity now syncs automatically</span>
            </div>

            <h1 class="pl-hero-title">
                Track the work,<br>
                not just the<br>
                <span class="lime-word">submission.</span>
            </h1>

            <p class="pl-hero-desc">
                Tasks, milestones, commits and the live demo for every student project, in one place. Faculty see progress all semester, not only on the last day.
            </p>

            <div class="pl-hero-actions">
                <a href="#roles" class="pl-btn-role">
                    <span>Choose your role</span>
                    <div class="pl-circle-black-icon">↓</div>
                </a>
                <a href="${pageContext.request.contextPath}/login" class="pl-btn-demo">
                    View a demo dashboard
                </a>
            </div>
        </div>

        <!-- Right Side Stacked Preview Widgets (Exact Image 1) -->
        <div class="pl-hero-widgets">
            <!-- Sample Project Card -->
            <div class="pl-card-sample">
                <div class="pl-sample-top">
                    <span class="pl-sample-label">Sample project</span>
                    <span class="pl-pill-status at-risk">At risk</span>
                </div>
                <div class="pl-sample-title">Campus Library Seat Finder</div>
                <div class="pl-progress-meta">
                    <div><strong>54%</strong> <span>done</span></div>
                    <span>Expected 68%</span>
                </div>
                <div class="pl-striped-track">
                    <div class="pl-striped-fill" style="width: 54%;"></div>
                    <div class="pl-expected-tick" style="left: 68%;"></div>
                </div>
                <div class="pl-sample-footer">
                    <div class="pl-avatar-stack">
                        <div class="pl-avatar-circle c1">AR</div>
                        <div class="pl-avatar-circle c2">SK</div>
                        <div class="pl-avatar-circle c3">MP</div>
                    </div>
                    <div class="pl-sample-overdue">Task "Seat map API" is 2 days overdue</div>
                </div>
            </div>

            <!-- Commits This Week Lime Card -->
            <div class="pl-card-commits">
                <div class="pl-commits-label">Commits this week</div>
                <div class="pl-capsules-row">
                    <span class="pl-capsule cap1"></span>
                    <span class="pl-capsule cap2"></span>
                    <span class="pl-capsule cap3"></span>
                    <span class="pl-capsule cap4"></span>
                    <span class="pl-capsule cap5"></span>
                </div>
                <div class="pl-commits-count">23</div>
            </div>

            <!-- Next Milestone Dark Card -->
            <div class="pl-card-milestone">
                <div class="pl-ms-sub">Next milestone</div>
                <div class="pl-ms-title">Testing</div>
                <div class="pl-ms-pill">27 Oct · in 4 days</div>
            </div>
        </div>
    </section>

    <!-- Sign In Section: "Who's signing in today?" -->
    <section class="pl-signin-section" id="roles">
        <div class="pl-signin-header">
            <div>
                <div class="pl-signin-label">Sign in</div>
                <h2 class="pl-signin-h2">Who's signing in today?</h2>
            </div>
            <div class="pl-signin-sub">
                Pick your role. Each one opens its own dashboard with only the tools you need.
            </div>
        </div>

        <!-- 3 Role Selector Cards: Direct Sign In Navigation (Same Tab) -->
        <div class="pl-roles-row">
            <!-- Student Card -->
            <a href="${pageContext.request.contextPath}/login?role=student" class="pl-role-box active" id="roleCardStudent" title="Sign In as Student">
                <div class="pl-role-icon-bar">
                    <div class="pl-role-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                            <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                        </svg>
                    </div>
                    <div class="pl-role-arrow-circle">↗</div>
                </div>
                <div>
                    <span class="pl-role-tag-pill">Student Workspace</span>
                    <div class="pl-role-title">Student</div>
                    <div class="pl-role-desc">Plan tasks with your team, update progress and link your GitHub repo.</div>
                    <div class="pl-role-action-link">Sign In as Student &rarr;</div>
                </div>
            </a>

            <!-- Faculty Card -->
            <a href="${pageContext.request.contextPath}/login?role=faculty" class="pl-role-box inactive" id="roleCardFaculty" title="Sign In as Faculty">
                <div class="pl-role-icon-bar">
                    <div class="pl-role-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                            <line x1="8" y1="21" x2="16" y2="21"></line>
                            <line x1="12" y1="17" x2="12" y2="21"></line>
                        </svg>
                    </div>
                    <div class="pl-role-arrow-circle">↗</div>
                </div>
                <div>
                    <span class="pl-role-tag-pill">Supervisor Portal</span>
                    <div class="pl-role-title">Faculty</div>
                    <div class="pl-role-desc">Monitor supervised projects, check contributions and leave feedback.</div>
                    <div class="pl-role-action-link">Sign In as Faculty &rarr;</div>
                </div>
            </a>

            <!-- Admin Card -->
            <a href="${pageContext.request.contextPath}/login?role=admin" class="pl-role-box inactive" id="roleCardAdmin" title="Sign In as Admin">
                <div class="pl-role-icon-bar">
                    <div class="pl-role-icon-box">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                    </div>
                    <div class="pl-role-arrow-circle">↗</div>
                </div>
                <div>
                    <span class="pl-role-tag-pill">Institutional Admin</span>
                    <div class="pl-role-title">Admin</div>
                    <div class="pl-role-desc">Manage accounts, assign supervisors and set deadlines for everyone.</div>
                    <div class="pl-role-action-link">Sign In as Admin &rarr;</div>
                </div>
            </a>
        </div>

        <!-- Student Registration Link -->
        <div style="text-align: center; margin-top: 1.25rem; font-size: 13px; color: #6b778c;">
            New student joining a project? 
            <a href="${pageContext.request.contextPath}/register" style="font-weight: 700; color: var(--pl-forest); text-decoration: underline; margin-left: 4px;">
                Create an account &rarr;
            </a>
        </div>
    </section>

    <!-- Footer Strip -->
    <footer class="pl-footer">
        <div>
            Built with <strong>Java</strong> &middot; <strong>JSP &amp; Servlets</strong> &middot; <strong>JDBC</strong> &middot; <strong>MySQL</strong> &middot; <strong>GitHub API</strong>
        </div>
        <div>
            Team 15 &middot; VIT Vellore &middot; Java Programming
        </div>
    </footer>

</div>

</body>
</html>
