/**
 * Project View Interaction Script
 */
(function() {
    // 1. Format raw ISO completion timestamps in milestones
    document.querySelectorAll('.js-ms-completed-time').forEach(function(el) {
        var raw = el.getAttribute('data-raw');
        if (!raw) return;
        try {
            var d = new Date(raw);
            if (!isNaN(d.getTime())) {
                var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                var dateStr = d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear();
                var hours = d.getHours();
                var minutes = d.getMinutes();
                var ampm = hours >= 12 ? 'PM' : 'AM';
                hours = hours % 12;
                hours = hours ? hours : 12;
                minutes = minutes < 10 ? '0' + minutes : minutes;
                el.textContent = dateStr + ' at ' + hours + ':' + minutes + ' ' + ampm;
            }
        } catch(e) {}
    });

    // 2. Format commit timestamps into friendly dates (e.g. "20 Oct 2026, 01:03 AM · 3 days ago")
    document.querySelectorAll('.js-commit-time').forEach(function(el) {
        var raw = el.getAttribute('datetime');
        if (!raw) return;
        try {
            var d = new Date(raw);
            if (!isNaN(d.getTime())) {
                var now = new Date();
                var diffMs = now - d;
                var diffSec = Math.floor(diffMs / 1000);
                var diffMin = Math.floor(diffSec / 60);
                var diffHour = Math.floor(diffMin / 60);
                var diffDay = Math.floor(diffHour / 24);

                var timeAgo = '';
                if (diffSec < 60) timeAgo = 'Just now';
                else if (diffMin < 60) timeAgo = diffMin + 'm ago';
                else if (diffHour < 24) timeAgo = diffHour + 'h ago';
                else if (diffDay === 1) timeAgo = 'Yesterday';
                else if (diffDay < 30) timeAgo = diffDay + ' days ago';
                else timeAgo = Math.floor(diffDay / 30) + ' mo ago';

                var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                var dateStr = d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear();
                var hours = d.getHours();
                var minutes = d.getMinutes();
                var ampm = hours >= 12 ? 'PM' : 'AM';
                hours = hours % 12;
                hours = hours ? hours : 12;
                minutes = minutes < 10 ? '0' + minutes : minutes;
                var timeStr = hours + ':' + minutes + ' ' + ampm;

                el.textContent = dateStr + ' at ' + timeStr + ' (' + timeAgo + ')';
            }
        } catch(e) {}
    });

    // 3. Parse conventional commit prefixes (feat:, fix:, docs:, chore:, etc.)
    var prefixTypes = ['feat', 'fix', 'docs', 'style', 'refactor', 'perf', 'test', 'chore', 'ci', 'build'];
    document.querySelectorAll('.js-git-msg').forEach(function(el) {
        var text = el.textContent.trim();
        for (var i = 0; i < prefixTypes.length; i++) {
            var p = prefixTypes[i];
            var re = new RegExp('^(' + p + ')(\\([^)]+\\))?:\\s*(.+)$', 'i');
            var match = text.match(re);
            if (match) {
                var type = match[1].toLowerCase();
                var scope = match[2] ? match[2] : '';
                var rest = match[3];
                var badgeClass = 'type-' + type;
                el.innerHTML = '<span class="git-type-pill ' + badgeClass + '">' + type + (scope ? ' ' + scope : '') + '</span> ' + rest;
                break;
            }
        }
    });

    // 4. Copy SHA to clipboard
    document.querySelectorAll('.js-copy-sha').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var sha = this.getAttribute('data-sha');
            if (navigator.clipboard && sha) {
                var self = this;
                navigator.clipboard.writeText(sha).then(function() {
                    self.classList.add('copied');
                    setTimeout(function() {
                        self.classList.remove('copied');
                    }, 1600);
                });
            }
        });
    });

    // 5. Format feedback timestamps
    document.querySelectorAll('.js-fb-time').forEach(function(el) {
        var raw = el.getAttribute('data-raw');
        if (!raw) return;
        try {
            var d = new Date(raw);
            if (!isNaN(d.getTime())) {
                var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                var dateStr = d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear();
                var hours = d.getHours();
                var minutes = d.getMinutes();
                var ampm = hours >= 12 ? 'PM' : 'AM';
                hours = hours % 12;
                hours = hours ? hours : 12;
                minutes = minutes < 10 ? '0' + minutes : minutes;
                el.textContent = dateStr + ' at ' + hours + ':' + minutes + ' ' + ampm;
            }
        } catch(e) {}
    });
})();
