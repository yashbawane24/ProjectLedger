/**
 * Student Dashboard Interaction Script
 */
function switchSection(sectionName, e) {
    if (e && e.preventDefault) {
        e.preventDefault();
    }

    // Update URL query parameter without full reload if supported
    if (history.pushState) {
        const newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?section=' + sectionName;
        window.history.pushState({path: newurl}, '', newurl);
    }

    // Hide all student sections
    document.querySelectorAll('.student-section').forEach(sec => {
        sec.style.display = 'none';
    });

    // Show target section
    const target = document.getElementById('student-section-' + sectionName);
    if (target) {
        target.style.display = 'block';
    } else {
        const overview = document.getElementById('student-section-overview');
        if (overview) overview.style.display = 'block';
    }

    // Update sidebar active link state
    document.querySelectorAll('.sidebar-link').forEach(link => {
        const href = link.getAttribute('href') || '';
        if (href.includes('section=' + sectionName)) {
            link.classList.add('active');
        } else if (sectionName === 'overview' && (href.endsWith('/student/dashboard') || href.includes('section=overview'))) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });

    // Scroll to top of content
    window.scrollTo({top: 0, behavior: 'smooth'});
}

function filterStudentProjects(status, btn) {
    btn.parentElement.querySelectorAll('.filter-pill-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const cards = document.querySelectorAll('.student-project-card');
    cards.forEach(card => {
        if (status === 'all') {
            card.style.display = '';
        } else if (status === 'on-track') {
            card.style.display = card.classList.contains('status-on_track') ? '' : 'none';
        } else if (status === 'at-risk') {
            card.style.display = card.classList.contains('status-at_risk') ? '' : 'none';
        } else if (status === 'delayed') {
            card.style.display = card.classList.contains('status-delayed') ? '' : 'none';
        }
    });
}

function filterTaskView(category, btn) {
    btn.parentElement.querySelectorAll('.filter-pill-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const groups = {
        'overdue': document.querySelector('.group-overdue'),
        'this-week': document.querySelector('.group-this-week'),
        'later': document.querySelector('.group-later'),
        'completed': document.querySelector('.group-completed')
    };

    if (category === 'all') {
        Object.values(groups).forEach(g => { if (g) g.style.display = ''; });
    } else {
        Object.entries(groups).forEach(([key, g]) => {
            if (g) {
                g.style.display = (key === category) ? '' : 'none';
            }
        });
    }
}

// Hash & URL parameter listener on page load
window.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    let sec = urlParams.get('section');
    if (!sec && window.location.hash) {
        sec = window.location.hash.replace('#', '');
    }
    if (sec && ['overview', 'projects', 'tasks', 'deadlines'].includes(sec)) {
        switchSection(sec);
    }
});

window.addEventListener('hashchange', () => {
    const hash = window.location.hash.replace('#', '');
    if (hash && ['overview', 'projects', 'tasks', 'deadlines'].includes(hash)) {
        switchSection(hash);
    }
});
