# ProjectLedger — Academic Project Development & Monitoring Platform

**Team 15:**
- Bawane Yash Sunil (24BBS0119)
- Gulam Moinuddin (24BBS0135)
- Kartik Jindal (24BBS0143)

ProjectLedger is an academic project development and continuous process monitoring platform. It enables undergraduate engineering students to systematically manage capstone projects across their lifecycle (milestone syllabus, weighted task boards, team rosters, and GitHub activity), while empowering supervising faculty to monitor the development process rather than evaluating only the final submission.

---

## Technology Stack

- **Platform Runtime:** Java 17 (LTS), Apache Maven (Packaging: `war`)
- **Web & Servlet Engine:** Jakarta Servlet 6.0, JSP 3.1, JSTL 3.0 (Jakarta EE 10 namespace, `jakarta.*`)
- **Application Server:** Apache Tomcat 10.1.x
- **Persistence:** MySQL 8 with raw JDBC (`PreparedStatement` throughout) and HikariCP connection pooling
- **Security:** `org.mindrot:jbcrypt` for salted password hashing, per-session CSRF token filter, session fixation defense
- **Integrations:** `java.net.http.HttpClient` + `com.google.code.gson:gson` for GitHub REST API v3
- **Test Framework:** JUnit 5 (Jupiter)
- **Frontend Architecture:** Server-rendered JSP, handcrafted CSS design system, minimal vanilla JavaScript (no React, Bootstrap, Tailwind, jQuery, or third-party UI kits)

---

## Directory Structure

```
projectledger/
  pom.xml                             # Maven build configuration (Java 17, war packaging)
  README.md                           # Setup manual, business rules, and troubleshooting
  database/
    schema.sql                        # InnoDB utf8mb4 schema (8 relational tables with foreign keys)
    seed.sql                          # Seed data with real BCrypt hashes and 3 active projects
  src/main/java/com/projectledger/
    model/                            # Domain entities
      User (abstract)                 # Polymorphic base class
      Student, Faculty, Admin         # Concrete polymorphic subclasses
      Project                         # Implements Reviewable
      TeamMember                      # Team roster representation
      Task                            # Implements Assignable
      Milestone                       # Implements Reviewable
      Deadline                        # Institutional & project deadlines
      GitHubCommit                    # Synchronized Git commits
      Feedback                        # Faculty reviews and scores
      StudentEvidence                 # Contribution evidence carrier
      ProjectHealth (enum)            # ON_TRACK, AT_RISK, DELAYED
      TaskStatus (enum)               # NOT_STARTED, IN_PROGRESS, COMPLETED
      Priority (enum)                 # LOW (1), MEDIUM (2), HIGH (3)
      Role (enum)                     # STUDENT, FACULTY, ADMIN
      SessionUser                     # Lightweight session token object
    interfaces/
      Assignable.java                 # Contract for assignable items (assignTo, getAssigneeId)
      Reviewable.java                 # Contract for evaluated items (getReviewStatus, markReviewed)
    dao/                              # Data Access Objects (SQLException -> AppException)
      UserDao, ProjectDao, TeamMemberDao, TaskDao,
      MilestoneDao, DeadlineDao, GitHubActivityDao, FeedbackDao
    service/                          # Domain business logic & calculations
      AuthService, ProjectService, TaskService, MilestoneService,
      FeedbackService, GitHubService, HealthCalculator, ProgressCalculator
    servlet/                          # Feature-specific controllers
      LoginServlet, RegisterServlet, LogoutServlet, ProfileServlet,
      StudentDashboardServlet, ProjectNewServlet, ProjectServlet,
      ProjectEditServlet, ProjectTeamServlet, ProjectMilestoneServlet,
      ProjectTaskServlet, ProjectGitHubSyncServlet, FacultyDashboardServlet,
      FacultyFeedbackServlet, AdminDashboardServlet, AdminUsersServlet,
      AdminProjectsServlet, AdminDeadlinesServlet
    filter/                           # Pipeline security and encoding filters
      EncodingFilter (UTF-8), CsrfFilter, AuthFilter, RoleFilter
    util/                             # Infrastructure utilities
      DatabaseConnection (HikariCP), AppConfig, Validator, DateUtil, Flash, AppContextListener
    exception/                        # Domain exception hierarchy
      AppException, NotFoundException, AccessDeniedException, GitHubException
  src/main/resources/
    app.properties                    # Database URL/credentials & GitHub token
  src/main/webapp/
    WEB-INF/
      web.xml                         # Deployment descriptor (session timeout, 403/404/500 mappings)
      jsp/
        layout/ (header, sidebar, footer)
        auth/ (login, register)
        student/ (dashboard, project_new)
        project/ (view)
        faculty/ (dashboard)
        admin/ (dashboard, users, projects, deadlines)
        error/ (403, 404, 500)
        profile.jsp
    assets/
      css/app.css                     # Complete handcrafted editorial stylesheet
      js/app.js                       # Vanilla JavaScript (flash dismissal, modal drawers, mobile toggle)
  src/test/java/com/projectledger/
    ProgressCalculatorTest.java       # JUnit 5 tests for weighted progress formulas
    HealthCalculatorTest.java         # JUnit 5 tests for all Delayed/At-Risk/On-Track rules
    SeedHasher.java                   # BCrypt hash generation utility
```

---

## Installation & Setup Guide

### 1. Prerequisites
- **JDK 17 or higher:** (Check with `java -version`)
- **Apache Maven 3.8+:** (Check with `mvn -version`)
- **MySQL 8.0+:** Running locally on port `3306`
- **Apache Tomcat 10.1.x:** (Must be Tomcat 10.1+ supporting Jakarta EE 10 / Servlet 6.0)

### 2. Database Initialization
Open **MySQL Workbench** or your terminal shell:
```bash
# Apply database schema
mysql -u root -p < database/schema.sql

# Seed realistic demo data
mysql -u root -p < database/seed.sql
```

### 3. Application Configuration
Configuration parameters reside in `src/main/resources/app.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/projectledger?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=utf8
db.user=root
db.password=your_mysql_password
github.token=
```
**Environment Variables (Override properties automatically):**
- `DB_URL`
- `DB_USER`
- `DB_PASSWORD`
- `GITHUB_TOKEN`

#### Creating an Optional Fine-Grained GitHub Token:
1. Navigate to **GitHub &rarr; Settings &rarr; Developer Settings &rarr; Personal Access Tokens &rarr; Fine-grained tokens**.
2. Click **Generate new token**.
3. Under **Repository access**, select **Public Repositories (read-only)**.
4. Set token in `app.properties` or as `export GITHUB_TOKEN=ghp_...` to raise rate limits from 60 to 5,000 requests/hour. Note: Public repositories work seamlessly without any token.

### 4. Build the Application
```bash
mvn clean package
```
This runs the test suite and produces the deployable artifact:
`target/projectledger.war`

### 5. Deployment

#### Standalone Apache Tomcat 10.1:
1. Copy `target/projectledger.war` into Tomcat's `webapps/` directory:
   ```bash
   cp target/projectledger.war /path/to/tomcat10/webapps/
   ```
2. Start Tomcat:
   - macOS / Linux: `/path/to/tomcat10/bin/startup.sh`
   - Windows: `\path\to\tomcat10\bin\startup.bat`
3. Access the application in your browser:
   `http://localhost:8080/projectledger/`

#### IntelliJ IDEA (Ultimate):
1. Go to **Run &rarr; Edit Configurations &rarr; Add New &rarr; Tomcat Server &rarr; Local**.
2. Configure Application Server path pointing to your Tomcat 10.1 installation.
3. In the **Deployment** tab, click **+ &rarr; Artifact &rarr; projectledger:war**.
4. Set Application Context to `/projectledger`.
5. Click **Run / Debug**.

#### Eclipse IDE:
1. In the **Servers** view, click **New &rarr; Server &rarr; Apache &rarr; Tomcat v10.1 Server**.
2. Point Eclipse to your Tomcat 10.1 directory and JRE 17.
3. Right-click the project &rarr; **Run As &rarr; Run on Server**.

---

## Demo Credentials

All test accounts use real BCrypt hashes generated using `SeedHasher`:

| Role | Email | Password | Details |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin@projectledger.edu` | `Admin@123` | Institutional Dean / Administrator |
| **Faculty 1** | `faculty1@projectledger.edu` | `Faculty@123` | Dr. Ramesh Sharma (Supervises Projects 1 & 3) |
| **Faculty 2** | `faculty2@projectledger.edu` | `Faculty@123` | Dr. Anita Roy (Supervises Project 2) |
| **Student 1** | `student1@projectledger.edu` | `Student@123` | Bawane Yash Sunil (24BBS0119) &middot; Lead (Project 1) |
| **Student 2** | `student2@projectledger.edu` | `Student@123` | Gulam Moinuddin (24BBS0135) &middot; Developer (Project 1 & 3) |
| **Student 3** | `student3@projectledger.edu` | `Student@123` | Kartik Jindal (24BBS0143) &middot; Developer (Project 1) |
| **Student 4** | `student4@projectledger.edu` | `Student@123` | Priya Nair (24BBS0150) &middot; Lead (Project 2) |
| **Student 5** | `student5@projectledger.edu` | `Student@123` | Rohan Verma (24BBS0155) &middot; Developer (Project 2) |
| **Student 6** | `student6@projectledger.edu` | `Student@123` | Siddharth Rao (24BBS0160) &middot; Lead (Project 3) |

---

## Business Logic & Continuous Health Rules

### Progress Calculation (`ProgressCalculator`)
1. **Weighted Task Progress:**
   Each task contributes according to its priority weight:
   - `LOW`: weight = 1
   - `MEDIUM`: weight = 2
   - `HIGH`: weight = 3
   $$\text{taskProgress} = \frac{\sum \text{weight of COMPLETED tasks}}{\sum \text{weight of ALL tasks}}$$
2. **Milestone Progress:**
   $$\text{milestoneProgress} = \frac{\text{completed milestones}}{\text{total milestones}}$$
3. **Overall Combined Progress:**
   $$\text{overallProgress} = 60\% \times \text{taskProgress} + 40\% \times \text{milestoneProgress}$$
   *(Rounded to whole integer percent. Returns 0% if no tasks or milestones exist.)*
4. **Expected Schedule Progress:**
   $$\text{expectedProgress} = \text{clamp}\left(\frac{\text{days elapsed since start date}}{\text{total project duration in days}} \times 100, 0, 100\right)$$

### Health Assessment (`HealthCalculator`)

Every health classification is accompanied by human-readable diagnostic explanations:

- **DELAYED** (Red Ink Stamp) if any of:
  - Any milestone's `target_date` has passed and it is not completed.
  - Any `HIGH` priority task is overdue by more than 3 days.
  - `overallProgress` is more than 25 percentage points behind `expectedProgress`.
  - Project `end_date` has elapsed and progress is less than 100%.

- **AT_RISK** (Ochre Ink Stamp, evaluated if not delayed) if any of:
  - Any task is overdue (`status != COMPLETED AND due_date < today`).
  - A milestone is due within 7 days and less than 50% of its linked tasks are completed.
  - `overallProgress` is 10 to 25 percentage points behind `expectedProgress`.
  - A GitHub repository is connected and no commits have been made in the last 14 days (applicable once project is 14+ days old).

- **ON_TRACK** (Forest Green Ink Stamp) otherwise.

---

## Troubleshooting Guide

### 1. Port 8080 Already in Use
If Tomcat fails to start because port 8080 is bound:
- **macOS / Linux:**
  ```bash
  lsof -i :8080
  kill -9 <PID>
  ```
- **Windows:**
  ```cmd
  netstat -ano | findstr :8080
  taskkill /PID <PID> /F
  ```
- Alternatively, modify port `8080` to `8081` in Tomcat's `conf/server.xml`:
  ```xml
  <Connector port="8081" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />
  ```

### 2. MySQL Access Denied / Connection Refused
- Verify MySQL service is active:
  ```bash
  mysqladmin -u root -p status
  ```
- If your root user requires a password, update `app.properties` or set:
  ```bash
  export DB_PASSWORD=your_password
  ```
- If encountering `Public Key Retrieval is not allowed`, confirm `allowPublicKeyRetrieval=true` in `db.url` (already pre-configured).

### 3. `javax.*` vs `jakarta.*` Namespace Errors
- Tomcat 10.1 implements **Jakarta EE 10** (`jakarta.servlet.*`, `jakarta.servlet.jsp.*`, `jakarta.servlet.jsp.jstl.*`).
- If deploying to Tomcat 9 or older, Tomcat 9 expects `javax.*` and will fail. Always use **Apache Tomcat 10.1.x**.

### 4. GitHub Rate Limit Exceeded
- Unauthenticated GitHub API calls allow 60 requests per hour per IP.
- If the rate limit is reached, ProjectLedger displays:
  `"GitHub rate limit reached, resets at HH:mm"`
- The Activity tab gracefully preserves and renders all previously stored commit records from `github_activity`.
- Provide a personal access token via `app.properties` (`github.token=ghp_...`) or `export GITHUB_TOKEN=ghp_...` to obtain 5,000 requests/hour.
