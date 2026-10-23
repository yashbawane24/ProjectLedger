<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
<jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

<!-- Page Header Breadcrumb & Title -->
<div class="dash-header-row" style="margin-bottom: 1.5rem;">
    <div>
        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px; font-size: 13px;">
            <a href="${pageContext.request.contextPath}/student/dashboard?section=projects" style="color: var(--forest); text-decoration: none; font-weight: 600;">Projects</a>
            <span style="color: var(--muted);">&rsaquo;</span>
            <span style="color: var(--muted);">New Project</span>
        </div>
        <div style="display:flex; align-items:center; gap:10px;">
            <h1 class="dash-header-title" style="margin-bottom:0;">Register New Academic Project</h1>
            <span class="status-chip-pill on-track" style="font-size:11px; font-weight:700;">ONBOARDING</span>
        </div>
        <div class="dash-header-sub" style="margin-top: 4px;">
            Initialize project governance, assign faculty supervision, and configure continuous development tracking.
        </div>
    </div>
    <div class="dash-btn-group">
        <a href="${pageContext.request.contextPath}/student/dashboard?section=projects" class="dash-btn-outline">
            &larr; Back to Projects
        </a>
    </div>
</div>

<!-- Two-Column Layout: Form on Left (68%), Best Practices & Timeline on Right (32%) -->
<div style="display: grid; grid-template-columns: minmax(0, 2fr) minmax(300px, 1fr); gap: 1.5rem; align-items: start;">
    
    <!-- Left Column: The Registration Form -->
    <div class="middle-card-white" style="padding: 2rem; border-radius: 18px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
        <form action="${pageContext.request.contextPath}/student/projects/new" method="post" novalidate>
            <input type="hidden" name="csrfToken" value="${csrfToken}">

            <!-- Section 1: Project Identity -->
            <div style="border-bottom: 1px solid var(--line); padding-bottom: 1.25rem; margin-bottom: 1.5rem;">
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 1.25rem;">
                    <span style="display: inline-flex; align-items: center; justify-content: center; width: 26px; height: 26px; border-radius: 50%; background: var(--forest); color: var(--lime); font-size: 12px; font-weight: 800;">1</span>
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--navy); margin: 0;">Project Identity &amp; Scope</h3>
                </div>

                <div class="form-group" style="margin-bottom: 1.25rem;">
                    <label for="title" class="form-label" style="font-weight: 700; font-size: 12.5px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase;">
                        Project Title <span style="color: #dc2626;">*</span>
                    </label>
                    <input type="text" id="title" name="title" 
                           class="form-input ${errors.title != null ? 'is-invalid' : ''}"
                           style="border-radius: 10px; height: 44px; font-size: 14px; padding: 0 14px; border-color: var(--line-strong);"
                           value="<c:out value="${title != null ? title : ''}"/>"
                           placeholder="e.g. Distributed Telemetry Pipeline for IoT Sensor Networks" required autofocus>
                    <c:if test="${errors.title != null}">
                        <div class="form-error" style="color: #dc2626; font-size: 12px; margin-top: 4px;"><c:out value="${errors.title}"/></div>
                    </c:if>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="description" class="form-label" style="font-weight: 700; font-size: 12.5px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase;">
                        Project Scope &amp; Abstract <span style="color: #dc2626;">*</span>
                    </label>
                    <textarea id="description" name="description" 
                              class="form-textarea ${errors.description != null ? 'is-invalid' : ''}"
                              style="border-radius: 10px; min-height: 110px; font-size: 13.5px; line-height: 1.5; padding: 12px 14px; border-color: var(--line-strong);"
                              placeholder="Outline project objectives, architectural stack, technical challenges, and expected deliverables..." required><c:out value="${description != null ? description : ''}"/></textarea>
                    <div style="font-size: 12px; color: var(--muted); margin-top: 5px;">
                        Provide a clear description for your supervising faculty to review and approve.
                    </div>
                    <c:if test="${errors.description != null}">
                        <div class="form-error" style="color: #dc2626; font-size: 12px; margin-top: 4px;"><c:out value="${errors.description}"/></div>
                    </c:if>
                </div>
            </div>

            <!-- Section 2: Supervision & Timeline -->
            <div style="border-bottom: 1px solid var(--line); padding-bottom: 1.25rem; margin-bottom: 1.5rem;">
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 1.25rem;">
                    <span style="display: inline-flex; align-items: center; justify-content: center; width: 26px; height: 26px; border-radius: 50%; background: var(--forest); color: var(--lime); font-size: 12px; font-weight: 800;">2</span>
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--navy); margin: 0;">Supervision &amp; Timeline</h3>
                </div>

                <div class="form-grid-3" style="gap: 1rem;">
                    <div class="form-group">
                        <label for="facultyId" class="form-label" style="font-weight: 700; font-size: 12px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase;">
                            Supervising Faculty
                        </label>
                        <select id="facultyId" name="facultyId" class="form-select" style="border-radius: 10px; height: 44px; font-size: 13.5px; border-color: var(--line-strong);">
                            <option value="">-- Select Faculty Advisor --</option>
                            <c:forEach var="fac" items="${facultyList}">
                                <option value="${fac.id}" ${facultyId == fac.id ? 'selected' : ''}>
                                    <c:out value="${fac.name}"/> (${fac.department})
                                </option>
                            </c:forEach>
                        </select>
                        <div class="form-help" style="font-size: 11.5px; color: var(--muted); margin-top: 4px;">Faculty advisor reviews milestone deliverables.</div>
                    </div>

                    <div class="form-group">
                        <label for="startDate" class="form-label" style="font-weight: 700; font-size: 12px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase;">
                            Start Date <span style="color: #dc2626;">*</span>
                        </label>
                        <input type="date" id="startDate" name="startDate" 
                               class="form-input mono-text ${errors.startDate != null ? 'is-invalid' : ''}"
                               style="border-radius: 10px; height: 44px; font-size: 13px; border-color: var(--line-strong);"
                               value="<c:out value="${startDate != null ? startDate : ''}"/>" required>
                        <c:if test="${errors.startDate != null}">
                            <div class="form-error" style="color: #dc2626; font-size: 12px; margin-top: 4px;"><c:out value="${errors.startDate}"/></div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="endDate" class="form-label" style="font-weight: 700; font-size: 12px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase;">
                            Completion Date <span style="color: #dc2626;">*</span>
                        </label>
                        <input type="date" id="endDate" name="endDate" 
                               class="form-input mono-text ${errors.endDate != null ? 'is-invalid' : ''}"
                               style="border-radius: 10px; height: 44px; font-size: 13px; border-color: var(--line-strong);"
                               value="<c:out value="${endDate != null ? endDate : ''}"/>" required>
                        <c:if test="${errors.endDate != null}">
                            <div class="form-error" style="color: #dc2626; font-size: 12px; margin-top: 4px;"><c:out value="${errors.endDate}"/></div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Section 3: Evidence & Tracking URLs -->
            <div style="border-bottom: 1px solid var(--line); padding-bottom: 1.25rem; margin-bottom: 1.5rem;">
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 1.25rem;">
                    <span style="display: inline-flex; align-items: center; justify-content: center; width: 26px; height: 26px; border-radius: 50%; background: var(--forest); color: var(--lime); font-size: 12px; font-weight: 800;">3</span>
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--navy); margin: 0;">Code Repository &amp; Deployment (Optional)</h3>
                </div>

                <div class="form-grid-2" style="gap: 1rem;">
                    <div class="form-group">
                        <label for="repoUrl" class="form-label" style="font-weight: 700; font-size: 12px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase; display:flex; justify-content:space-between;">
                            <span>GitHub Repository URL</span>
                            <span style="font-weight: normal; color: var(--muted); text-transform: none; font-size: 11px;">Optional</span>
                        </label>
                        <div style="position: relative;">
                            <input type="text" id="repoUrl" name="repoUrl" 
                                   class="form-input mono-text ${errors.repoUrl != null ? 'is-invalid' : ''}"
                                   style="border-radius: 10px; height: 44px; font-size: 13px; padding-left: 36px; border-color: var(--line-strong);"
                                   value="<c:out value="${repoUrl != null ? repoUrl : ''}"/>"
                                   placeholder="https://github.com/owner/repository">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="position: absolute; left: 12px; top: 14px; color: var(--muted);">
                                <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77 5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7A3.37 3.37 0 0 0 9 18.13V22"></path>
                            </svg>
                        </div>
                        <div class="form-help" style="font-size: 11.5px; color: var(--muted); margin-top: 4px;">Enables commit synchronization and process evidence tracking.</div>
                        <c:if test="${errors.repoUrl != null}">
                            <div class="form-error" style="color: #dc2626; font-size: 12px; margin-top: 4px;"><c:out value="${errors.repoUrl}"/></div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="demoUrl" class="form-label" style="font-weight: 700; font-size: 12px; letter-spacing: 0.3px; color: var(--navy); text-transform: uppercase; display:flex; justify-content:space-between;">
                            <span>Live Demo / Staging URL</span>
                            <span style="font-weight: normal; color: var(--muted); text-transform: none; font-size: 11px;">Optional</span>
                        </label>
                        <div style="position: relative;">
                            <input type="url" id="demoUrl" name="demoUrl" 
                                   class="form-input mono-text ${errors.demoUrl != null ? 'is-invalid' : ''}"
                                   style="border-radius: 10px; height: 44px; font-size: 13px; padding-left: 36px; border-color: var(--line-strong);"
                                   value="<c:out value="${demoUrl != null ? demoUrl : ''}"/>"
                                   placeholder="https://staging.example.com">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="position: absolute; left: 12px; top: 14px; color: var(--muted);">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="2" y1="12" x2="22" y2="12"></line>
                                <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                            </svg>
                        </div>
                        <div class="form-help" style="font-size: 11.5px; color: var(--muted); margin-top: 4px;">Link to preview environment for faculty evaluation.</div>
                        <c:if test="${errors.demoUrl != null}">
                            <div class="form-error" style="color: #dc2626; font-size: 12px; margin-top: 4px;"><c:out value="${errors.demoUrl}"/></div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Section 4: Academic Milestones Auto-Generation Card -->
            <div style="background: #f7faf6; border: 1px solid #dbe6d6; border-radius: 14px; padding: 1.25rem; margin-bottom: 1.75rem;">
                <label style="display: flex; align-items: flex-start; gap: 10px; cursor: pointer; user-select: none;">
                    <input type="checkbox" name="addDefaultMilestones" value="true" checked 
                           style="accent-color: var(--forest); width: 18px; height: 18px; margin-top: 2px;">
                    <div>
                        <div style="font-weight: 700; color: var(--navy); font-size: 14px;">
                            Initialize Standard Academic Milestones
                        </div>
                        <div style="font-size: 12.5px; color: var(--muted); margin-top: 4px; line-height: 1.45;">
                            Automatically configures standard 5-phase academic curriculum milestones:
                        </div>
                        <div style="display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px;">
                            <span class="status-chip-pill on-track" style="font-size: 11px;">1. Planning</span>
                            <span class="status-chip-pill on-track" style="font-size: 11px;">2. System Design</span>
                            <span class="status-chip-pill on-track" style="font-size: 11px;">3. Core Implementation</span>
                            <span class="status-chip-pill on-track" style="font-size: 11px;">4. Testing &amp; QA</span>
                            <span class="status-chip-pill on-track" style="font-size: 11px;">5. Final Delivery</span>
                        </div>
                    </div>
                </label>
            </div>

            <!-- Form Actions -->
            <div style="display: flex; justify-content: flex-end; align-items: center; gap: 1rem; border-top: 1px solid var(--line); padding-top: 1.25rem;">
                <a href="${pageContext.request.contextPath}/student/dashboard?section=projects" class="dash-btn-outline" style="padding: 10px 22px;">
                    Cancel
                </a>
                <button type="submit" class="dash-btn-forest" style="padding: 10px 28px; font-size: 14px; font-weight: 700; cursor: pointer; border: none;">
                    <span>Create Project Ledger</span>
                    <span style="color: var(--lime); font-size: 16px; margin-left: 4px;">&rarr;</span>
                </button>
            </div>
        </form>
    </div>

    <!-- Right Column: Governance Guidance & Process Principles -->
    <div style="display: flex; flex-direction: column; gap: 1.25rem;">
        
        <!-- Guidance Card 1: What Happens Next -->
        <div class="middle-card-white" style="border-radius: 18px; padding: 1.5rem;">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 1rem;">
                <span class="topbar-crumb-badge" style="background: var(--forest); color: var(--lime); font-size: 10px;">GOVERNANCE</span>
                <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: var(--navy);">Onboarding Lifecycle</h4>
            </div>
            
            <div style="display: flex; flex-direction: column; gap: 14px; font-size: 13px; color: var(--text);">
                <div style="display: flex; gap: 10px; align-items: flex-start;">
                    <div style="width: 22px; height: 22px; border-radius: 50%; background: #eaf2ed; color: var(--forest); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 11px; flex-shrink: 0;">1</div>
                    <div>
                        <strong>Team Invitation</strong>
                        <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">Once created, invite peer student co-authors from your department ledger.</div>
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; align-items: flex-start;">
                    <div style="width: 22px; height: 22px; border-radius: 50%; background: #eaf2ed; color: var(--forest); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 11px; flex-shrink: 0;">2</div>
                    <div>
                        <strong>Faculty Oversight</strong>
                        <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">Assigned faculty advisor receives automated notifications for weekly commit reviews.</div>
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; align-items: flex-start;">
                    <div style="width: 22px; height: 22px; border-radius: 50%; background: #eaf2ed; color: var(--forest); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 11px; flex-shrink: 0;">3</div>
                    <div>
                        <strong>Milestone Sign-off</strong>
                        <div style="font-size: 12px; color: var(--muted); margin-top: 2px;">Each syllabus deliverable requires faculty review approval to mark completed.</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Guidance Card 2: Faculty Advisory Note -->
        <div style="background: var(--obsidian); color: #ffffff; border-radius: 18px; padding: 1.5rem;">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                <span style="font-size: 14px;">💡</span>
                <span style="font-size: 11px; font-weight: 700; color: var(--lime); letter-spacing: 0.5px; text-transform: uppercase;">Faculty Evaluation Note</span>
            </div>
            <p style="font-size: 12.5px; color: #a3b3a6; line-height: 1.5; margin: 0;">
                GitHub activity and development tasks are continuously correlated with milestone completion. Maintaining regular commits ensures your project stays <strong style="color: #ffffff;">On Track</strong>.
            </p>
        </div>

    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layout/footer.jsp" />
