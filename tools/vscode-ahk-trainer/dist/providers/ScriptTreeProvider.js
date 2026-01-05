"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoryTreeProvider = exports.ScriptTreeProvider = exports.ScriptFileTreeItem = exports.CategoryTreeItem = void 0;
const vscode = __importStar(require("vscode"));
/**
 * Tree item for a category (folder)
 */
class CategoryTreeItem extends vscode.TreeItem {
    category;
    constructor(category) {
        super(category.name, vscode.TreeItemCollapsibleState.Collapsed);
        this.category = category;
        this.description = `${category.fileCount} files`;
        this.tooltip = `${category.name}: ${category.fileCount} files`;
        this.contextValue = 'category';
        // Set icon based on quality
        if (category.errorCount > 0) {
            this.iconPath = new vscode.ThemeIcon('folder', new vscode.ThemeColor('testing.iconFailed'));
        }
        else if (category.warningCount > 0) {
            this.iconPath = new vscode.ThemeIcon('folder', new vscode.ThemeColor('list.warningForeground'));
        }
        else {
            this.iconPath = new vscode.ThemeIcon('folder');
        }
    }
}
exports.CategoryTreeItem = CategoryTreeItem;
/**
 * Tree item for a script file
 */
class ScriptFileTreeItem extends vscode.TreeItem {
    script;
    constructor(script) {
        super(script.filename, vscode.TreeItemCollapsibleState.None);
        this.script = script;
        // Set description from metadata or use defaults
        this.description = script.metadata?.title || '';
        this.tooltip = this.buildTooltip();
        this.contextValue = 'scriptFile';
        // Set icon based on quality
        this.iconPath = this.getQualityIcon();
        // Set command to open file when clicked
        this.command = {
            command: 'vscode.open',
            title: 'Open File',
            arguments: [vscode.Uri.file(script.absolutePath)]
        };
        // Set resource URI for file decorations
        this.resourceUri = vscode.Uri.file(script.absolutePath);
    }
    buildTooltip() {
        const md = new vscode.MarkdownString();
        md.appendMarkdown(`**${this.script.filename}**\n\n`);
        if (this.script.metadata) {
            if (this.script.metadata.title) {
                md.appendMarkdown(`${this.script.metadata.title}\n\n`);
            }
            if (this.script.metadata.description) {
                md.appendMarkdown(`${this.script.metadata.description}\n\n`);
            }
            md.appendMarkdown(`---\n`);
            md.appendMarkdown(`- **Lines:** ${this.script.metadata.line_count || 'unknown'}\n`);
            md.appendMarkdown(`- **Category:** ${this.script.category}\n`);
            if (this.script.metadata.functions && this.script.metadata.functions.length > 0) {
                md.appendMarkdown(`- **Functions:** ${this.script.metadata.functions.slice(0, 5).join(', ')}`);
                if (this.script.metadata.functions.length > 5) {
                    md.appendMarkdown(` +${this.script.metadata.functions.length - 5} more`);
                }
                md.appendMarkdown('\n');
            }
        }
        if (this.script.quality) {
            md.appendMarkdown(`\n**Quality:** ${this.script.quality.rating}`);
            if (this.script.quality.errorCount > 0) {
                md.appendMarkdown(` (${this.script.quality.errorCount} errors)`);
            }
            if (this.script.quality.warningCount > 0) {
                md.appendMarkdown(` (${this.script.quality.warningCount} warnings)`);
            }
        }
        return md;
    }
    getQualityIcon() {
        if (!this.script.quality || this.script.quality.rating === 'unknown') {
            return new vscode.ThemeIcon('file');
        }
        switch (this.script.quality.rating) {
            case 'good':
                return new vscode.ThemeIcon('check', new vscode.ThemeColor('testing.iconPassed'));
            case 'warning':
                return new vscode.ThemeIcon('warning', new vscode.ThemeColor('list.warningForeground'));
            case 'error':
                return new vscode.ThemeIcon('error', new vscode.ThemeColor('testing.iconFailed'));
            default:
                return new vscode.ThemeIcon('file');
        }
    }
}
exports.ScriptFileTreeItem = ScriptFileTreeItem;
/**
 * Tree data provider for the script explorer
 */
class ScriptTreeProvider {
    metadataService;
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
    qualityFilter = null;
    constructor(metadataService) {
        this.metadataService = metadataService;
    }
    /**
     * Refresh the entire tree
     */
    refresh() {
        this._onDidChangeTreeData.fire(undefined);
    }
    /**
     * Refresh a specific item
     */
    refreshItem(item) {
        this._onDidChangeTreeData.fire(item);
    }
    /**
     * Set quality filter
     */
    setQualityFilter(rating) {
        this.qualityFilter = rating;
        this.refresh();
    }
    /**
     * Get tree item for display
     */
    getTreeItem(element) {
        return element;
    }
    /**
     * Get children of a tree item
     */
    async getChildren(element) {
        if (!element) {
            // Root level: return categories
            const categories = this.metadataService.getCategories();
            // If filtering by quality, only show categories with matching files
            if (this.qualityFilter) {
                const filteredCategories = categories.filter(cat => {
                    return cat.files.some(f => f.quality?.rating === this.qualityFilter);
                });
                return filteredCategories.map(cat => new CategoryTreeItem(cat));
            }
            return categories.map(cat => new CategoryTreeItem(cat));
        }
        if (element instanceof CategoryTreeItem) {
            // Category level: return scripts in category
            let scripts = this.metadataService.getScriptsInCategory(element.category.name);
            // Apply quality filter if set
            if (this.qualityFilter) {
                scripts = scripts.filter(s => s.quality?.rating === this.qualityFilter);
            }
            // Sort by filename
            scripts.sort((a, b) => a.filename.localeCompare(b.filename));
            return scripts.map(script => new ScriptFileTreeItem(script));
        }
        return [];
    }
    /**
     * Get parent of a tree item
     */
    getParent(element) {
        if (element instanceof ScriptFileTreeItem) {
            const category = this.metadataService.getCategory(element.script.category);
            if (category) {
                return new CategoryTreeItem(category);
            }
        }
        return undefined;
    }
}
exports.ScriptTreeProvider = ScriptTreeProvider;
/**
 * Category tree provider (for the second view)
 */
class CategoryTreeProvider {
    metadataService;
    _onDidChangeTreeData = new vscode.EventEmitter();
    onDidChangeTreeData = this._onDidChangeTreeData.event;
    constructor(metadataService) {
        this.metadataService = metadataService;
    }
    refresh() {
        this._onDidChangeTreeData.fire(undefined);
    }
    getTreeItem(element) {
        return element;
    }
    async getChildren(element) {
        if (!element) {
            const categories = this.metadataService.getCategories();
            return categories.map(cat => new CategoryTreeItem(cat));
        }
        return [];
    }
}
exports.CategoryTreeProvider = CategoryTreeProvider;
//# sourceMappingURL=ScriptTreeProvider.js.map