import * as fs from 'fs';
import * as path from 'path';
import * as readline from 'readline';
import {
  ScriptMetadata,
  ScriptFile,
  Category,
  CategoryStats,
  FeatureCoverage,
  FeatureCount,
  QualityRating
} from '../models/types';

/**
 * Service for loading and indexing script metadata
 */
export class MetadataService {
  private scriptsRoot: string;
  private metadataPath: string;
  private fileMap: Map<string, ScriptFile> = new Map();
  private categoryMap: Map<string, Category> = new Map();
  private initialized: boolean = false;

  constructor(workspaceRoot: string, scriptsRoot: string, metadataPath: string) {
    this.scriptsRoot = path.resolve(workspaceRoot, scriptsRoot);
    this.metadataPath = path.resolve(workspaceRoot, metadataPath);
  }

  /**
   * Initialize the service by loading metadata
   */
  async initialize(): Promise<void> {
    if (this.initialized) {
      return;
    }

    // First, scan the file system for actual scripts
    await this.scanScriptsDirectory();

    // Then, load metadata from JSONL file if it exists
    if (fs.existsSync(this.metadataPath)) {
      await this.loadMetadataFile();
    }

    this.initialized = true;
  }

  /**
   * Scan the scripts directory and build the file index
   */
  private async scanScriptsDirectory(): Promise<void> {
    if (!fs.existsSync(this.scriptsRoot)) {
      console.warn(`Scripts directory not found: ${this.scriptsRoot}`);
      return;
    }

    const categories = fs.readdirSync(this.scriptsRoot, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .map(dirent => dirent.name);

    for (const categoryName of categories) {
      const categoryPath = path.join(this.scriptsRoot, categoryName);
      const files = fs.readdirSync(categoryPath)
        .filter(file => file.endsWith('.ahk'));

      const category: Category = {
        name: categoryName,
        path: categoryPath,
        fileCount: files.length,
        errorCount: 0,
        warningCount: 0,
        files: []
      };

      for (const filename of files) {
        const absolutePath = path.join(categoryPath, filename);
        const relativePath = path.relative(this.scriptsRoot, absolutePath);

        const scriptFile: ScriptFile = {
          absolutePath,
          relativePath,
          filename,
          category: categoryName,
          quality: { rating: 'unknown', errorCount: 0, warningCount: 0, infoCount: 0, hintCount: 0, score: 0 }
        };

        this.fileMap.set(relativePath, scriptFile);
        this.fileMap.set(filename, scriptFile); // Also index by filename for metadata lookup
        category.files.push(scriptFile);
      }

      this.categoryMap.set(categoryName, category);
    }
  }

  /**
   * Load metadata from JSONL file and merge with file index
   */
  private async loadMetadataFile(): Promise<void> {
    return new Promise((resolve, reject) => {
      const fileStream = fs.createReadStream(this.metadataPath);
      const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity
      });

      rl.on('line', (line) => {
        try {
          const metadata: ScriptMetadata = JSON.parse(line);

          // Try to match by filename
          const scriptFile = this.fileMap.get(metadata.file);
          if (scriptFile) {
            scriptFile.metadata = metadata;
          }
        } catch (e) {
          // Skip malformed lines
        }
      });

      rl.on('close', () => {
        resolve();
      });

      rl.on('error', (err) => {
        reject(err);
      });
    });
  }

  /**
   * Refresh metadata from files
   */
  async refresh(): Promise<void> {
    this.initialized = false;
    this.fileMap.clear();
    this.categoryMap.clear();
    await this.initialize();
  }

  /**
   * Get all categories
   */
  getCategories(): Category[] {
    return Array.from(this.categoryMap.values())
      .sort((a, b) => b.fileCount - a.fileCount);
  }

  /**
   * Get a specific category
   */
  getCategory(name: string): Category | undefined {
    return this.categoryMap.get(name);
  }

  /**
   * Get scripts in a category
   */
  getScriptsInCategory(categoryName: string): ScriptFile[] {
    const category = this.categoryMap.get(categoryName);
    return category?.files || [];
  }

  /**
   * Get a script by relative path
   */
  getScript(relativePath: string): ScriptFile | undefined {
    return this.fileMap.get(relativePath);
  }

  /**
   * Get all scripts
   */
  getAllScripts(): ScriptFile[] {
    const scripts: ScriptFile[] = [];
    for (const category of this.categoryMap.values()) {
      scripts.push(...category.files);
    }
    return scripts;
  }

  /**
   * Get total file count
   */
  getTotalFiles(): number {
    let total = 0;
    for (const category of this.categoryMap.values()) {
      total += category.fileCount;
    }
    return total;
  }

  /**
   * Update quality for a script
   */
  updateQuality(relativePath: string, errorCount: number, warningCount: number): void {
    const script = this.fileMap.get(relativePath);
    if (script) {
      let rating: QualityRating = 'good';
      if (errorCount > 0) {
        rating = 'error';
      } else if (warningCount > 0) {
        rating = 'warning';
      }

      script.quality = {
        rating,
        errorCount,
        warningCount,
        infoCount: 0,
        hintCount: 0,
        score: this.calculateScore(errorCount, warningCount)
      };

      // Update category counts
      const category = this.categoryMap.get(script.category);
      if (category) {
        this.recalculateCategoryCounts(category);
      }
    }
  }

  /**
   * Calculate quality score (0-100)
   */
  private calculateScore(errors: number, warnings: number): number {
    if (errors > 0) {
      return Math.max(0, 50 - errors * 10);
    }
    if (warnings > 0) {
      return Math.max(50, 100 - warnings * 10);
    }
    return 100;
  }

  /**
   * Recalculate category error/warning counts
   */
  private recalculateCategoryCounts(category: Category): void {
    let errorCount = 0;
    let warningCount = 0;

    for (const file of category.files) {
      if (file.quality) {
        errorCount += file.quality.errorCount;
        warningCount += file.quality.warningCount;
      }
    }

    category.errorCount = errorCount;
    category.warningCount = warningCount;
  }

  /**
   * Get category statistics for analytics
   */
  getCategoryStats(): CategoryStats[] {
    const stats: CategoryStats[] = [];

    for (const category of this.categoryMap.values()) {
      let lineCount = 0;
      let cleanCount = 0;

      for (const file of category.files) {
        if (file.metadata?.line_count) {
          lineCount += file.metadata.line_count;
        }
        if (file.quality?.rating === 'good') {
          cleanCount++;
        }
      }

      stats.push({
        name: category.name,
        fileCount: category.fileCount,
        lineCount,
        errorCount: category.errorCount,
        warningCount: category.warningCount,
        cleanCount
      });
    }

    return stats.sort((a, b) => b.fileCount - a.fileCount);
  }

  /**
   * Get feature coverage analysis
   */
  getFeatureCoverage(): FeatureCoverage {
    const directivesMap = new Map<string, string[]>();
    const functionsMap = new Map<string, string[]>();
    const hotkeysMap = new Map<string, string[]>();

    for (const [, script] of this.fileMap) {
      if (!script.metadata) continue;

      // Track directives
      for (const directive of script.metadata.directives || []) {
        const existing = directivesMap.get(directive) || [];
        existing.push(script.relativePath);
        directivesMap.set(directive, existing);
      }

      // Track functions
      for (const func of script.metadata.functions || []) {
        const existing = functionsMap.get(func) || [];
        existing.push(script.relativePath);
        functionsMap.set(func, existing);
      }

      // Track hotkeys
      for (const hotkey of script.metadata.hotkeys || []) {
        const existing = hotkeysMap.get(hotkey) || [];
        existing.push(script.relativePath);
        hotkeysMap.set(hotkey, existing);
      }
    }

    const mapToFeatureCounts = (map: Map<string, string[]>): FeatureCount[] => {
      return Array.from(map.entries())
        .map(([name, files]) => ({ name, count: files.length, files }))
        .sort((a, b) => b.count - a.count);
    };

    return {
      directives: mapToFeatureCounts(directivesMap),
      functions: mapToFeatureCounts(functionsMap),
      hotkeys: mapToFeatureCounts(hotkeysMap)
    };
  }

  /**
   * Search scripts by query
   */
  searchScripts(query: string): ScriptFile[] {
    const lowerQuery = query.toLowerCase();
    const results: ScriptFile[] = [];

    for (const [, script] of this.fileMap) {
      // Search in filename
      if (script.filename.toLowerCase().includes(lowerQuery)) {
        results.push(script);
        continue;
      }

      // Search in metadata
      if (script.metadata) {
        if (script.metadata.title?.toLowerCase().includes(lowerQuery) ||
            script.metadata.description?.toLowerCase().includes(lowerQuery) ||
            script.metadata.category?.toLowerCase().includes(lowerQuery)) {
          results.push(script);
        }
      }
    }

    return results;
  }

  /**
   * Filter scripts by quality
   */
  filterByQuality(rating: QualityRating): ScriptFile[] {
    const results: ScriptFile[] = [];

    for (const [, script] of this.fileMap) {
      if (script.quality?.rating === rating) {
        results.push(script);
      }
    }

    return results;
  }
}
