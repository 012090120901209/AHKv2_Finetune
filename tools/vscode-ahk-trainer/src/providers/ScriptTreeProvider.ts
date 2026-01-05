import * as vscode from 'vscode';
import * as path from 'path';
import { MetadataService } from '../services/MetadataService';
import { Category, ScriptFile, QualityRating } from '../models/types';

/**
 * Tree item representing either a category or a script file
 */
export type ScriptTreeItem = CategoryTreeItem | ScriptFileTreeItem;

/**
 * Tree item for a category (folder)
 */
export class CategoryTreeItem extends vscode.TreeItem {
  constructor(
    public readonly category: Category
  ) {
    super(category.name, vscode.TreeItemCollapsibleState.Collapsed);

    this.description = `${category.fileCount} files`;
    this.tooltip = `${category.name}: ${category.fileCount} files`;
    this.contextValue = 'category';

    // Set icon based on quality
    if (category.errorCount > 0) {
      this.iconPath = new vscode.ThemeIcon('folder', new vscode.ThemeColor('testing.iconFailed'));
    } else if (category.warningCount > 0) {
      this.iconPath = new vscode.ThemeIcon('folder', new vscode.ThemeColor('list.warningForeground'));
    } else {
      this.iconPath = new vscode.ThemeIcon('folder');
    }
  }
}

/**
 * Tree item for a script file
 */
export class ScriptFileTreeItem extends vscode.TreeItem {
  constructor(
    public readonly script: ScriptFile
  ) {
    super(script.filename, vscode.TreeItemCollapsibleState.None);

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

  private buildTooltip(): vscode.MarkdownString {
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

  private getQualityIcon(): vscode.ThemeIcon {
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

/**
 * Tree data provider for the script explorer
 */
export class ScriptTreeProvider implements vscode.TreeDataProvider<ScriptTreeItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<ScriptTreeItem | undefined | null>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;

  private qualityFilter: QualityRating | null = null;

  constructor(private metadataService: MetadataService) {}

  /**
   * Refresh the entire tree
   */
  refresh(): void {
    this._onDidChangeTreeData.fire(undefined);
  }

  /**
   * Refresh a specific item
   */
  refreshItem(item: ScriptTreeItem): void {
    this._onDidChangeTreeData.fire(item);
  }

  /**
   * Set quality filter
   */
  setQualityFilter(rating: QualityRating | null): void {
    this.qualityFilter = rating;
    this.refresh();
  }

  /**
   * Get tree item for display
   */
  getTreeItem(element: ScriptTreeItem): vscode.TreeItem {
    return element;
  }

  /**
   * Get children of a tree item
   */
  async getChildren(element?: ScriptTreeItem): Promise<ScriptTreeItem[]> {
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
  getParent(element: ScriptTreeItem): vscode.ProviderResult<ScriptTreeItem> {
    if (element instanceof ScriptFileTreeItem) {
      const category = this.metadataService.getCategory(element.script.category);
      if (category) {
        return new CategoryTreeItem(category);
      }
    }
    return undefined;
  }
}

/**
 * Category tree provider (for the second view)
 */
export class CategoryTreeProvider implements vscode.TreeDataProvider<CategoryTreeItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<CategoryTreeItem | undefined | null>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;

  constructor(private metadataService: MetadataService) {}

  refresh(): void {
    this._onDidChangeTreeData.fire(undefined);
  }

  getTreeItem(element: CategoryTreeItem): vscode.TreeItem {
    return element;
  }

  async getChildren(element?: CategoryTreeItem): Promise<CategoryTreeItem[]> {
    if (!element) {
      const categories = this.metadataService.getCategories();
      return categories.map(cat => new CategoryTreeItem(cat));
    }
    return [];
  }
}
