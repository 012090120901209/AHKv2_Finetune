/**
 * AHK Training Reviewer - Main Application (Monaco Edition)
 */

// State
const state = {
    scripts: [],
    filteredScripts: [],
    currentScript: null,
    currentIndex: -1,
    isEditing: false,
    isReviewMode: false,
    fixResult: null,
    categories: [],
    monaco: null,
    editor: null,
    diffOriginalEditor: null,
    diffFixedEditor: null
};

// DOM Elements
const elements = {
    // Stats
    statTotal: document.getElementById('stat-total'),
    statReviewed: document.getElementById('stat-reviewed'),
    statProgress: document.getElementById('stat-progress'),

    // Filters
    filterCategory: document.getElementById('filter-category'),
    filterStatus: document.getElementById('filter-status'),
    filterQuality: document.getElementById('filter-quality'),

    // Script list
    scriptList: document.getElementById('script-list'),

    // Script viewer
    scriptTitle: document.getElementById('script-title'),
    scriptCategory: document.getElementById('script-category'),
    scriptStatus: document.getElementById('script-status'),
    scriptQuality: document.getElementById('script-quality'),
    monacoContainer: document.getElementById('monaco-container'),

    // Buttons
    btnRun: document.getElementById('btn-run'),
    btnLint: document.getElementById('btn-lint'),
    btnEdit: document.getElementById('btn-edit'),
    btnSave: document.getElementById('btn-save'),
    btnCancelEdit: document.getElementById('btn-cancel-edit'),
    btnFix: document.getElementById('btn-fix'),
    btnReviewMode: document.getElementById('btn-review-mode'),
    btnRefresh: document.getElementById('btn-refresh'),
    fixLevel: document.getElementById('fix-level'),

    // Lint results
    lintResults: document.getElementById('lint-results'),
    lintList: document.getElementById('lint-list'),

    // Diff viewer
    diffViewer: document.getElementById('diff-viewer'),
    diffOriginalContainer: document.getElementById('diff-original-monaco'),
    diffFixedContainer: document.getElementById('diff-fixed-monaco'),
    btnAcceptFix: document.getElementById('btn-accept-fix'),
    btnRejectFix: document.getElementById('btn-reject-fix'),

    // Script viewer container
    scriptViewer: document.getElementById('script-viewer'),

    // Review mode
    reviewModeOverlay: document.getElementById('review-mode-overlay'),
    reviewModeProgress: document.getElementById('review-mode-progress'),
    btnExitReview: document.getElementById('btn-exit-review'),

    // Loading & Toast
    loading: document.getElementById('loading'),
    loadingText: document.getElementById('loading-text'),
    toastContainer: document.getElementById('toast-container')
};

// API helpers
async function api(endpoint, options = {}) {
    const response = await fetch(`/api${endpoint}`, {
        headers: { 'Content-Type': 'application/json' },
        ...options
    });
    if (!response.ok) {
        const error = await response.json().catch(() => ({ detail: 'Unknown error' }));
        throw new Error(error.detail || 'Request failed');
    }
    return response.json();
}

function showLoading(text = 'Loading...') {
    elements.loadingText.textContent = text;
    elements.loading.classList.remove('hidden');
}

function hideLoading() {
    elements.loading.classList.add('hidden');
}

function toast(message, type = 'success') {
    const div = document.createElement('div');
    div.className = `toast ${type}`;
    div.textContent = message;
    elements.toastContainer.appendChild(div);
    setTimeout(() => div.remove(), 3000);
}

// Monaco Editor Setup
async function setupMonaco() {
    state.monaco = await window.initMonaco();

    // Create main editor
    state.editor = state.monaco.editor.create(elements.monacoContainer, {
        value: '// Select a script from the list',
        language: window.AHK_LANGUAGE_ID,
        theme: window.AHK_THEME_NAME,
        readOnly: true,
        automaticLayout: true,
        fontSize: 14,
        lineNumbers: 'on',
        minimap: { enabled: false },
        scrollBeyondLastLine: false,
        wordWrap: 'on',
        renderWhitespace: 'selection'
    });

    // Create diff editors
    state.diffOriginalEditor = state.monaco.editor.create(elements.diffOriginalContainer, {
        value: '',
        language: window.AHK_LANGUAGE_ID,
        theme: window.AHK_THEME_NAME,
        readOnly: true,
        automaticLayout: true,
        fontSize: 13,
        lineNumbers: 'on',
        minimap: { enabled: false },
        scrollBeyondLastLine: false
    });

    state.diffFixedEditor = state.monaco.editor.create(elements.diffFixedContainer, {
        value: '',
        language: window.AHK_LANGUAGE_ID,
        theme: window.AHK_THEME_NAME,
        readOnly: true,
        automaticLayout: true,
        fontSize: 13,
        lineNumbers: 'on',
        minimap: { enabled: false },
        scrollBeyondLastLine: false
    });

    // Ctrl+S to save when editing
    state.editor.addCommand(state.monaco.KeyMod.CtrlCmd | state.monaco.KeyCode.KeyS, () => {
        if (state.isEditing) {
            saveScript();
        }
    });
}

// Load data
async function loadScripts() {
    const category = elements.filterCategory.value;
    const status = elements.filterStatus.value;
    const quality = elements.filterQuality.value;

    const params = new URLSearchParams();
    if (category) params.append('category', category);
    if (status) params.append('status', status);
    if (quality) params.append('quality', quality);

    const data = await api(`/scripts?${params}`);
    state.scripts = data.scripts;
    state.filteredScripts = data.scripts;
    renderScriptList();
}

async function loadCategories() {
    const data = await api('/categories');
    state.categories = data.categories;

    elements.filterCategory.innerHTML = '<option value="">All Categories</option>';
    for (const cat of state.categories) {
        const option = document.createElement('option');
        option.value = cat.name;
        option.textContent = `${cat.name} (${cat.total})`;
        elements.filterCategory.appendChild(option);
    }
}

async function loadStats() {
    const data = await api('/stats');
    elements.statTotal.textContent = data.total;
    elements.statReviewed.textContent = data.reviewed;
    elements.statProgress.textContent = `${data.review_progress}%`;
}

function renderScriptList() {
    elements.scriptList.innerHTML = '';

    for (let i = 0; i < state.filteredScripts.length; i++) {
        const script = state.filteredScripts[i];
        const div = document.createElement('div');
        div.className = 'script-item' + (state.currentScript?.id === script.id ? ' active' : '');
        div.dataset.index = i;

        div.innerHTML = `
            <div class="filename">${script.filename}</div>
            <div class="meta">
                <span class="badge badge-${script.status}">${script.status}</span>
                <span class="badge badge-${script.quality}">${script.quality}</span>
            </div>
        `;

        div.addEventListener('click', () => selectScript(i));
        elements.scriptList.appendChild(div);
    }
}

async function selectScript(index) {
    if (index < 0 || index >= state.filteredScripts.length) return;

    state.currentIndex = index;
    const scriptSummary = state.filteredScripts[index];

    showLoading('Loading script...');

    try {
        // Load full script details
        const script = await api(`/scripts/${encodeURIComponent(scriptSummary.id)}`);
        const contentData = await api(`/script-content/${encodeURIComponent(scriptSummary.id)}`);

        state.currentScript = { ...script, content: contentData.content };

        // Update UI
        elements.scriptTitle.textContent = script.filename;
        elements.scriptCategory.textContent = script.category;
        elements.scriptCategory.className = 'badge';
        elements.scriptStatus.textContent = script.status;
        elements.scriptStatus.className = `badge badge-${script.status}`;
        elements.scriptQuality.textContent = script.quality;
        elements.scriptQuality.className = `badge badge-${script.quality}`;

        // Update Monaco editor
        if (state.editor) {
            state.editor.setValue(contentData.content);
            state.editor.updateOptions({ readOnly: true });
        }

        // Show lint results if available
        if (script.lint_results && script.lint_results.length > 0) {
            showLintResults(script.lint_results);
        } else {
            elements.lintResults.classList.add('hidden');
        }

        // Reset edit mode
        exitEditMode();

        // Hide diff viewer
        elements.diffViewer.classList.add('hidden');
        elements.scriptViewer.classList.remove('hidden');

        // Update list selection
        renderScriptList();

        // Scroll to active item
        const activeItem = elements.scriptList.querySelector('.active');
        if (activeItem) {
            activeItem.scrollIntoView({ block: 'nearest' });
        }

        // Update review mode progress
        if (state.isReviewMode) {
            elements.reviewModeProgress.textContent = `${index + 1} / ${state.filteredScripts.length}`;
        }

    } catch (error) {
        toast(error.message, 'error');
    } finally {
        hideLoading();
    }
}

function showLintResults(diagnostics) {
    elements.lintList.innerHTML = '';

    for (const diag of diagnostics) {
        const div = document.createElement('div');
        const line = diag.range?.start?.line || diag.line || '?';
        div.className = `lint-item ${diag.severity === 1 ? 'error' : 'warning'}`;
        div.innerHTML = `
            <span class="line">Line ${line}</span>
            <span class="message">${diag.message || 'Unknown issue'}</span>
        `;
        // Click to go to line
        div.addEventListener('click', () => {
            if (typeof line === 'number' && state.editor) {
                state.editor.revealLineInCenter(line);
                state.editor.setPosition({ lineNumber: line, column: 1 });
                state.editor.focus();
            }
        });
        div.style.cursor = 'pointer';
        elements.lintList.appendChild(div);
    }

    elements.lintResults.classList.remove('hidden');
}

// Edit mode
function enterEditMode() {
    if (!state.currentScript || !state.editor) return;

    state.isEditing = true;
    state.editor.updateOptions({ readOnly: false });
    state.editor.focus();
    elements.btnSave.classList.remove('hidden');
    elements.btnCancelEdit.classList.remove('hidden');
    elements.btnEdit.classList.add('hidden');
}

function exitEditMode() {
    state.isEditing = false;
    if (state.editor) {
        state.editor.updateOptions({ readOnly: true });
        // Restore original content if canceling
        if (state.currentScript) {
            state.editor.setValue(state.currentScript.content);
        }
    }
    elements.btnSave.classList.add('hidden');
    elements.btnCancelEdit.classList.add('hidden');
    elements.btnEdit.classList.remove('hidden');
}

async function saveScript() {
    if (!state.currentScript || !state.isEditing || !state.editor) return;

    const content = state.editor.getValue();

    showLoading('Saving...');

    try {
        await api(`/script-content/${encodeURIComponent(state.currentScript.id)}`, {
            method: 'PUT',
            body: JSON.stringify({ content })
        });

        state.currentScript.content = content;

        state.isEditing = false;
        state.editor.updateOptions({ readOnly: true });
        elements.btnSave.classList.add('hidden');
        elements.btnCancelEdit.classList.add('hidden');
        elements.btnEdit.classList.remove('hidden');

        toast('Script saved');

    } catch (error) {
        toast(error.message, 'error');
    } finally {
        hideLoading();
    }
}

// Review status
async function setStatus(status) {
    if (!state.currentScript) return;

    try {
        await api(`/script-status/${encodeURIComponent(state.currentScript.id)}`, {
            method: 'POST',
            body: JSON.stringify({ status })
        });

        state.currentScript.status = status;

        // Update in filtered list
        const scriptInList = state.filteredScripts[state.currentIndex];
        if (scriptInList) {
            scriptInList.status = status;
        }

        // Update UI
        elements.scriptStatus.textContent = status;
        elements.scriptStatus.className = `badge badge-${status}`;
        renderScriptList();
        loadStats();

        toast(`Marked as ${status}`);

        // In review mode, auto-advance
        if (state.isReviewMode) {
            setTimeout(() => nextScript(), 300);
        }

    } catch (error) {
        toast(error.message, 'error');
    }
}

// Run script with local AHK
async function runCurrentScript() {
    if (!state.currentScript) return;

    showLoading('Running script...');

    try {
        const result = await api(`/script-run/${encodeURIComponent(state.currentScript.id)}`, {
            method: 'POST'
        });

        if (result.success) {
            toast(`Script running (PID: ${result.pid})`, 'success');
        } else {
            toast(result.message || 'Failed to run script', 'error');
        }

    } catch (error) {
        toast(error.message, 'error');
    } finally {
        hideLoading();
    }
}

// Lint
async function lintCurrentScript() {
    if (!state.currentScript) return;

    showLoading('Linting...');

    try {
        const result = await api(`/script-lint/${encodeURIComponent(state.currentScript.id)}`, {
            method: 'POST'
        });

        state.currentScript.lint_results = result.diagnostics;
        state.currentScript.errors = result.errors;
        state.currentScript.warnings = result.warnings;

        // Update quality badge
        let quality = 'good';
        if (result.errors > 0) quality = 'error';
        else if (result.warnings > 0) quality = 'warning';

        state.currentScript.quality = quality;
        elements.scriptQuality.textContent = quality;
        elements.scriptQuality.className = `badge badge-${quality}`;

        // Update in list
        const scriptInList = state.filteredScripts[state.currentIndex];
        if (scriptInList) {
            scriptInList.quality = quality;
            scriptInList.errors = result.errors;
            scriptInList.warnings = result.warnings;
        }

        renderScriptList();

        if (result.diagnostics && result.diagnostics.length > 0) {
            showLintResults(result.diagnostics);
            toast(`Found ${result.errors} error(s), ${result.warnings} warning(s)`, 'warning');
        } else {
            elements.lintResults.classList.add('hidden');
            toast('No issues found', 'success');
        }

    } catch (error) {
        toast(error.message, 'error');
    } finally {
        hideLoading();
    }
}

// Fix with AI
async function fixCurrentScript() {
    if (!state.currentScript) return;

    const level = elements.fixLevel.value;
    showLoading(`Running AI fix (${level})...`);

    try {
        const result = await api(`/script-fix/${encodeURIComponent(state.currentScript.id)}`, {
            method: 'POST',
            body: JSON.stringify({ level })
        });

        state.fixResult = result;

        if (!result.success) {
            toast(result.error || 'Fix failed', 'error');
            return;
        }

        if (!result.changed) {
            toast('No changes needed', 'success');
            return;
        }

        // Show diff
        elements.scriptViewer.classList.add('hidden');
        elements.diffViewer.classList.remove('hidden');

        if (state.diffOriginalEditor) {
            state.diffOriginalEditor.setValue(result.original);
        }
        if (state.diffFixedEditor) {
            state.diffFixedEditor.setValue(result.fixed);
        }

        toast('Fix complete - review changes', 'success');

    } catch (error) {
        toast(error.message, 'error');
    } finally {
        hideLoading();
    }
}

function acceptFix() {
    if (!state.fixResult || !state.fixResult.changed) return;

    // Update current script content
    state.currentScript.content = state.fixResult.fixed;

    // Update Monaco editor
    if (state.editor) {
        state.editor.setValue(state.fixResult.fixed);
    }

    // Hide diff, show viewer
    elements.diffViewer.classList.add('hidden');
    elements.scriptViewer.classList.remove('hidden');

    state.fixResult = null;
    toast('Fix accepted');
}

async function rejectFix() {
    if (!state.fixResult) return;

    // Restore original content if we have backup
    if (state.fixResult.backup) {
        try {
            await api(`/script-content/${encodeURIComponent(state.currentScript.id)}`, {
                method: 'PUT',
                body: JSON.stringify({ content: state.fixResult.original })
            });
        } catch (error) {
            console.error('Failed to restore:', error);
        }
    }

    // Hide diff, show viewer
    elements.diffViewer.classList.add('hidden');
    elements.scriptViewer.classList.remove('hidden');

    state.fixResult = null;
    toast('Fix rejected');
}

// Review mode
function enterReviewMode() {
    state.isReviewMode = true;
    elements.reviewModeOverlay.classList.remove('hidden');

    if (state.currentIndex < 0 && state.filteredScripts.length > 0) {
        selectScript(0);
    }

    updateReviewProgress();
}

function exitReviewMode() {
    state.isReviewMode = false;
    elements.reviewModeOverlay.classList.add('hidden');
}

function updateReviewProgress() {
    const current = state.currentIndex + 1;
    const total = state.filteredScripts.length;
    elements.reviewModeProgress.textContent = `${current} / ${total}`;
}

function nextScript() {
    if (state.currentIndex < state.filteredScripts.length - 1) {
        selectScript(state.currentIndex + 1);
    }
}

function prevScript() {
    if (state.currentIndex > 0) {
        selectScript(state.currentIndex - 1);
    }
}

// Keyboard shortcuts (only when not in Monaco editor)
document.addEventListener('keydown', (e) => {
    // Check if focus is inside Monaco editor
    const isInMonaco = document.activeElement?.closest('.monaco-editor');

    // Ctrl+R to run script (works everywhere)
    if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
        e.preventDefault();
        runCurrentScript();
        return;
    }

    // Allow Escape to work even in Monaco
    if (e.key === 'Escape') {
        if (state.isEditing) {
            exitEditMode();
            e.preventDefault();
        } else if (state.isReviewMode) {
            exitReviewMode();
            e.preventDefault();
        } else if (!elements.diffViewer.classList.contains('hidden')) {
            rejectFix();
            e.preventDefault();
        }
        return;
    }

    // Ignore other shortcuts if in Monaco or input elements
    if (isInMonaco || e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.tagName === 'SELECT') {
        return;
    }

    // Global shortcuts
    switch (e.key) {
        case 'r':
        case 'R':
            e.preventDefault();
            if (state.isReviewMode) {
                exitReviewMode();
            } else {
                enterReviewMode();
            }
            break;

        case 'e':
        case 'E':
            if (!state.isEditing) {
                e.preventDefault();
                enterEditMode();
            }
            break;

        case 'l':
        case 'L':
            e.preventDefault();
            lintCurrentScript();
            break;

        case 'f':
        case 'F':
            e.preventDefault();
            fixCurrentScript();
            break;

        case '1':
            e.preventDefault();
            setStatus('approved');
            break;

        case '2':
            e.preventDefault();
            setStatus('needs_fix');
            break;

        case '3':
            e.preventDefault();
            setStatus('rejected');
            break;

        case '4':
            e.preventDefault();
            setStatus('reviewed_ok');
            break;

        case '5':
            e.preventDefault();
            setStatus('skip');
            break;

        case 'ArrowDown':
        case 'j':
            e.preventDefault();
            nextScript();
            break;

        case 'ArrowUp':
        case 'k':
            e.preventDefault();
            prevScript();
            break;
    }
});

// Event listeners
elements.btnReviewMode.addEventListener('click', () => {
    if (state.isReviewMode) {
        exitReviewMode();
    } else {
        enterReviewMode();
    }
});

elements.btnExitReview.addEventListener('click', exitReviewMode);
elements.btnRefresh.addEventListener('click', async () => {
    showLoading('Refreshing...');
    await Promise.all([loadScripts(), loadCategories(), loadStats()]);
    hideLoading();
    toast('Refreshed');
});

elements.filterCategory.addEventListener('change', loadScripts);
elements.filterStatus.addEventListener('change', loadScripts);
elements.filterQuality.addEventListener('change', loadScripts);

elements.btnRun.addEventListener('click', runCurrentScript);
elements.btnEdit.addEventListener('click', enterEditMode);
elements.btnSave.addEventListener('click', saveScript);
elements.btnCancelEdit.addEventListener('click', exitEditMode);
elements.btnLint.addEventListener('click', lintCurrentScript);
elements.btnFix.addEventListener('click', fixCurrentScript);

elements.btnAcceptFix.addEventListener('click', acceptFix);
elements.btnRejectFix.addEventListener('click', rejectFix);

// Status buttons
document.querySelectorAll('.status-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        setStatus(btn.dataset.status);
    });
});

// Initialize
async function init() {
    showLoading('Loading Monaco Editor...');

    try {
        await setupMonaco();

        showLoading('Loading scripts...');

        await Promise.all([
            loadCategories(),
            loadStats()
        ]);
        await loadScripts();

        // Select first script if available
        if (state.filteredScripts.length > 0) {
            await selectScript(0);
        }

    } catch (error) {
        toast('Failed to load: ' + error.message, 'error');
        console.error(error);
    } finally {
        hideLoading();
    }
}

init();
