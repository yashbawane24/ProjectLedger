/**
 * Faculty Dashboard Interaction Script
 */
function switchFacultySection(sectionName, e) {
    if (e && e.preventDefault) {
        e.preventDefault();
    }

    // Update URL query parameter without full reload if supported
    if (history.pushState) {
        const newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?section=' + sectionName;
        window.history.pushState({path: newurl}, '', newurl);
    }

    // Hide all faculty sections
    document.querySelectorAll('.faculty-section').forEach(sec => {
        sec.style.display = 'none';
    });

    // Show target section
    const target = document.getElementById('faculty-section-' + sectionName);
    if (target) {
        target.style.display = 'block';
    } else {
        const overview = document.getElementById('faculty-section-overview');
        if (overview) overview.style.display = 'block';
    }

    // Update sidebar active link state
    document.querySelectorAll('.sidebar-link').forEach(link => {
        const href = link.getAttribute('href') || '';
        if (href.includes('section=' + sectionName)) {
            link.classList.add('active');
        } else if (sectionName === 'overview' && (href.endsWith('/faculty/dashboard') || href.includes('section=overview'))) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });

    // Scroll to top of content
    window.scrollTo({top: 0, behavior: 'smooth'});
}

function filterFacultyProjects(status, btn) {
    btn.parentElement.querySelectorAll('.filter-pill-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const rows = document.querySelectorAll('.project-row-all');
    rows.forEach(row => {
        if (status === 'all') {
            row.style.display = '';
        } else if (status === 'delayed') {
            row.style.display = row.classList.contains('status-delayed') ? '' : 'none';
        } else if (status === 'at-risk') {
            row.style.display = row.classList.contains('status-at_risk') ? '' : 'none';
        } else if (status === 'on-track') {
            row.style.display = row.classList.contains('status-on_track') ? '' : 'none';
        }
    });
}

// Hash & URL parameter listener on page load
window.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    let sec = urlParams.get('section');
    if (!sec && window.location.hash) {
        sec = window.location.hash.replace('#', '');
    }
    if (sec && ['overview', 'projects', 'feedback', 'deadlines', 'reports'].includes(sec)) {
        switchFacultySection(sec);
    }
});

window.addEventListener('hashchange', () => {
    const hash = window.location.hash.replace('#', '');
    if (hash && ['overview', 'projects', 'feedback', 'deadlines', 'reports'].includes(hash)) {
        switchFacultySection(hash);
    }
});
