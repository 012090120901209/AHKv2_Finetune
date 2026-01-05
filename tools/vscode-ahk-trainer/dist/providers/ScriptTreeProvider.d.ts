import * as vscode from 'vscode';
import { MetadataService } from '../services/MetadataService';
import { Category, ScriptFile, QualityRating } from '../models/types';
/**
 * Tree item representing either a category or a script file
 */
export type ScriptTreeItem = CategoryTreeItem | ScriptFileTreeItem;
/**
 * Tree item for a category (folder)
 */
export declare class CategoryTreeItem extends vscode.TreeItem {
    readonly category: Category;
    constructor(category: Category);
}
/**
 * Tree item for a script file
 */
export declare class ScriptFileTreeItem extends vscode.TreeItem {
    readonly script: ScriptFile;
    constructor(script: ScriptFile);
    private buildTooltip;
    private getQualityIcon;
}
/**
 * Tree data provider for the script explorer
 */
export declare class ScriptTreeProvider implements vscode.TreeDataProvider<ScriptTreeItem> {
    private metadataService;
    private _onDidChangeTreeData;
    readonly onDidChangeTreeData: vscode.Event<ScriptTreeItem | null | undefined>;
    private qualityFilter;
    constructor(metadataService: MetadataService);
    /**
     * Refresh the entire tree
     */
    refresh(): void;
    /**
     * Refresh a specific item
     */
    refreshItem(item: ScriptTreeItem): void;
    /**
     * Set quality filter
     */
    setQualityFilter(rating: QualityRating | null): void;
    /**
     * Get tree item for display
     */
    getTreeItem(element: ScriptTreeItem): vscode.TreeItem;
    /**
     * Get children of a tree item
     */
    getChildren(element?: ScriptTreeItem): Promise<ScriptTreeItem[]>;
    /**
     * Get parent of a tree item
     */
    getParent(element: ScriptTreeItem): vscode.ProviderResult<ScriptTreeItem>;
}
/**
 * Category tree provider (for the second view)
 */
export declare class CategoryTreeProvider implements vscode.TreeDataProvider<CategoryTreeItem> {
    private metadataService;
    private _onDidChangeTreeData;
    readonly onDidChangeTreeData: vscode.Event<CategoryTreeItem | null | undefined>;
    constructor(metadataService: MetadataService);
    refresh(): void;
    getTreeItem(element: CategoryTreeItem): vscode.TreeItem;
    getChildren(element?: CategoryTreeItem): Promise<CategoryTreeItem[]>;
}
//# sourceMappingURL=ScriptTreeProvider.d.ts.map