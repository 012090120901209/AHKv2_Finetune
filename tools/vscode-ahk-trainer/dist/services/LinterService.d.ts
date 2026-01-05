import * as vscode from 'vscode';
import { Diagnostic, LinterOutput } from '../models/types';
/**
 * Service for interfacing with the ahk-linter CLI tool
 */
export declare class LinterService {
    private linterPath;
    private workspaceRoot;
    constructor(workspaceRoot: string, linterPath: string);
    /**
     * Lint a single file
     */
    lintFile(filePath: string): Promise<Diagnostic[]>;
    /**
     * Lint multiple files with progress
     */
    lintFiles(filePaths: string[], progress?: vscode.Progress<{
        message?: string;
        increment?: number;
    }>): Promise<Map<string, Diagnostic[]>>;
    /**
     * Lint a directory recursively
     */
    lintDirectory(directoryPath: string): Promise<LinterOutput | null>;
    /**
     * Run the linter CLI
     */
    private runLinter;
    /**
     * Convert raw linter diagnostics to our format
     */
    private convertDiagnostics;
    /**
     * Map severity from various formats
     */
    private mapSeverity;
    /**
     * Convert our diagnostics to VS Code diagnostics
     */
    toVSCodeDiagnostics(diagnostics: Diagnostic[], uri: vscode.Uri): vscode.Diagnostic[];
    /**
     * Convert severity to VS Code severity
     */
    private toVSCodeSeverity;
    /**
     * Get error and warning counts from diagnostics
     */
    getCounts(diagnostics: Diagnostic[]): {
        errors: number;
        warnings: number;
    };
}
//# sourceMappingURL=LinterService.d.ts.map