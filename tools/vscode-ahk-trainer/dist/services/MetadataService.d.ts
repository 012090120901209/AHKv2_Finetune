import { ScriptFile, Category, CategoryStats, FeatureCoverage, QualityRating } from '../models/types';
/**
 * Service for loading and indexing script metadata
 */
export declare class MetadataService {
    private scriptsRoot;
    private metadataPath;
    private fileMap;
    private categoryMap;
    private initialized;
    constructor(workspaceRoot: string, scriptsRoot: string, metadataPath: string);
    /**
     * Initialize the service by loading metadata
     */
    initialize(): Promise<void>;
    /**
     * Scan the scripts directory and build the file index
     */
    private scanScriptsDirectory;
    /**
     * Load metadata from JSONL file and merge with file index
     */
    private loadMetadataFile;
    /**
     * Refresh metadata from files
     */
    refresh(): Promise<void>;
    /**
     * Get all categories
     */
    getCategories(): Category[];
    /**
     * Get a specific category
     */
    getCategory(name: string): Category | undefined;
    /**
     * Get scripts in a category
     */
    getScriptsInCategory(categoryName: string): ScriptFile[];
    /**
     * Get a script by relative path
     */
    getScript(relativePath: string): ScriptFile | undefined;
    /**
     * Get all scripts
     */
    getAllScripts(): ScriptFile[];
    /**
     * Get total file count
     */
    getTotalFiles(): number;
    /**
     * Update quality for a script
     */
    updateQuality(relativePath: string, errorCount: number, warningCount: number): void;
    /**
     * Calculate quality score (0-100)
     */
    private calculateScore;
    /**
     * Recalculate category error/warning counts
     */
    private recalculateCategoryCounts;
    /**
     * Get category statistics for analytics
     */
    getCategoryStats(): CategoryStats[];
    /**
     * Get feature coverage analysis
     */
    getFeatureCoverage(): FeatureCoverage;
    /**
     * Search scripts by query
     */
    searchScripts(query: string): ScriptFile[];
    /**
     * Filter scripts by quality
     */
    filterByQuality(rating: QualityRating): ScriptFile[];
}
//# sourceMappingURL=MetadataService.d.ts.map