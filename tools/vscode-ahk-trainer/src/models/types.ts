/**
 * Type definitions for AHK Training Review extension
 */

/**
 * Metadata for a single AHK script file
 * Matches structure from ahk_example_metadata.jsonl
 */
export interface ScriptMetadata {
  file: string;
  group: string;
  category: string;
  title: string;
  description?: string;
  comment_lines?: string[];
  directives?: string[];
  hotkeys?: string[];
  functions?: string[];
  line_count: number;
  relative_path: string;
}

/**
 * Represents an AHK script file with its metadata and quality info
 */
export interface ScriptFile {
  absolutePath: string;
  relativePath: string;
  filename: string;
  category: string;
  subcategory?: string;
  metadata?: ScriptMetadata;
  quality?: QualityScore;
  diagnostics?: Diagnostic[];
  lastLinted?: Date;
}

/**
 * Represents a category of scripts
 */
export interface Category {
  name: string;
  path: string;
  fileCount: number;
  errorCount: number;
  warningCount: number;
  files: ScriptFile[];
}

/**
 * A diagnostic issue from the linter
 */
export interface Diagnostic {
  message: string;
  line: number;
  column: number;
  endLine?: number;
  endColumn?: number;
  severity: DiagnosticSeverity;
  code?: string;
}

/**
 * Diagnostic severity levels
 */
export type DiagnosticSeverity = 'error' | 'warning' | 'info' | 'hint';

/**
 * Quality score for a script file
 */
export interface QualityScore {
  rating: QualityRating;
  errorCount: number;
  warningCount: number;
  infoCount: number;
  hintCount: number;
  score: number; // 0-100 normalized score
}

/**
 * Quality rating categories
 */
export type QualityRating = 'good' | 'warning' | 'error' | 'unknown';

/**
 * Linter output format (matches ahk-linter JSON output)
 */
export interface LinterOutput {
  files: LinterFileResult[];
  summary: LinterSummary;
}

/**
 * Linter result for a single file
 */
export interface LinterFileResult {
  file: string;
  diagnostics: Diagnostic[];
  summary: {
    errors: number;
    warnings: number;
    info: number;
    hints: number;
  };
}

/**
 * Overall linter summary
 */
export interface LinterSummary {
  totalFiles: number;
  filesWithErrors: number;
  filesWithWarnings: number;
  totalErrors: number;
  totalWarnings: number;
}

/**
 * Analytics data for the dashboard
 */
export interface AnalyticsData {
  totalFiles: number;
  totalLines: number;
  categoryStats: CategoryStats[];
  qualityDistribution: QualityDistribution;
  featureCoverage: FeatureCoverage;
}

/**
 * Statistics per category
 */
export interface CategoryStats {
  name: string;
  fileCount: number;
  lineCount: number;
  errorCount: number;
  warningCount: number;
  cleanCount: number;
}

/**
 * Quality distribution across all files
 */
export interface QualityDistribution {
  good: number;
  warning: number;
  error: number;
  unknown: number;
}

/**
 * AHK feature coverage analysis
 */
export interface FeatureCoverage {
  directives: FeatureCount[];
  functions: FeatureCount[];
  hotkeys: FeatureCount[];
}

/**
 * Count of a specific feature
 */
export interface FeatureCount {
  name: string;
  count: number;
  files: string[];
}
