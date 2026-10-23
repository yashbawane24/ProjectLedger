/**
 * ProjectLedger — Academic Project Development & Monitoring Platform
 * Lightweight Vanilla JavaScript
 */

document.addEventListener('DOMContentLoaded', function () {
  // 1. Auto-dismiss flash messages after 5 seconds
  const flash = document.querySelector('.flash-message');
  if (flash) {
    const timer = setTimeout(function () {
      flash.style.opacity = '0';
      flash.style.transition = 'opacity 300ms ease';
      setTimeout(function () { flash.remove(); }, 300);
    }, 5000);

    const closeBtn = flash.querySelector('.flash-close-btn');
    if (closeBtn) {
      closeBtn.addEventListener('click', function () {
        clearTimeout(timer);
        flash.remove();
      });
    }
  }

  // 2. Mobile sidebar toggle
  const mobileToggle = document.getElementById('mobileMenuToggle');
  const sidebar = document.querySelector('.sidebar');
  if (mobileToggle && sidebar) {
    mobileToggle.addEventListener('click', function () {
      sidebar.classList.toggle('mobile-open');
    });
  }

  // 3. Confirm prompts for destructive actions
  document.querySelectorAll('[data-confirm]').forEach(function (el) {
    el.addEventListener('click', function (e) {
      const message = this.getAttribute('data-confirm') || 'Are you sure you wish to proceed?';
      if (!confirm(message)) {
        e.preventDefault();
      }
    });
  });

  // 4. Quick task status change submission
  document.querySelectorAll('.task-status-select').forEach(function (select) {
    select.addEventListener('change', function () {
      const form = this.closest('form');
      if (form) {
        form.submit();
      }
    });
  });

  // 5. Global ⌘K / Ctrl+K search focus
  const searchInput = document.querySelector('.topbar-search-input');
  if (searchInput) {
    document.addEventListener('keydown', function (e) {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        searchInput.focus();
        searchInput.select();
      }
    });
  }
});

