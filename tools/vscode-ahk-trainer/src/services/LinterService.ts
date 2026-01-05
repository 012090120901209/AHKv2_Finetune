import * as vscode from 'vscode';
import { spawn } from 'child_process';
import * as path from 'path';
import { Diagnostic, DiagnosticSeverity, LinterOutput, LinterFileResult } from '../models/types';

/**
 * Service for interfacing with the ahk-linter CLI tool
 */
export class LinterService {
  private linterPath: string;
  private workspaceRoot: string;

  constructor(workspaceRoot: string, linterPath: string) {
    this.workspaceRoot = workspaceRoot;
    this.linterPath = path.resolve(workspaceRoot, linterPath);
  }

  /**
   * Lint a single file
   */
  async lintFile(filePath: string): Promise<Diagnostic[]> {
    const output = await this.runLinter(filePath);
    if (!output || !output.files || output.files.length === 0) {
      return [];
    }
    return this.convertDiagnostics(output.files[0].diagnostics || []);
  }

  /**
   * Lint multiple files with progress
   */
  async lintFiles(
    filePaths: string[],
    progress?: vscode.Progress<{ message?: string; increment?: number }>
  ): Promise<Map<string, Diagnostic[]>> {
    const results = new Map<string, Diagnostic[]>();
    const total = filePaths.length;

    for (let i = 0; i < filePaths.length; i++) {
      const filePath = filePaths[i];

      if (progress) {
        progress.report({
          message: `Linting ${path.basename(filePath)} (${i + 1}/${total})`,
          increment: (1 / total) * 100
        });
      }

      try {
        const diagnostics = await this.lintFile(filePath);
        results.set(filePath, diagnostics);
      } catch (error) {
        console.error(`Error linting ${filePath}:`, error);
        results.set(filePath, []);
      }
    }

    return results;
  }

  /**
   * Lint a directory recursively
   */
  async lintDirectory(directoryPath: string): Promise<LinterOutput | null> {
    return this.runLinter(directoryPath, true);
  }

  /**
   * Run the linter CLI
   */
  private runLinter(targetPath: string, recursive: boolean = false): Promise<LinterOutput | null> {
    return new Promise((resolve, reject) => {
      const args = [
        'ts-node', 'index.ts', 'lint',
        `path=${targetPath}`,
        '--format=json',
        '--quiet'
      ];

      if (recursive) {
        args.push('--recursive');
      }

      const process = spawn('npx', args, {
        cwd: this.linterPath,
        shell: true,
        env: { ...globalThis.process.env }
      });

      let stdout = '';
      let stderr = '';

      process.stdout.on('data', (data) => {
        stdout += data.toString();
      });

      process.stderr.on('data', (data) => {
        stderr += data.toString();
      });

      process.on('close', (code) => {
        if (code !== 0 && code !== 1) {
          // Code 1 means errors found, which is okay
          console.error(`Linter exited with code ${code}: ${stderr}`);
        }

        try {
          // Find the JSON in the output (skip any non-JSON lines)
          const jsonMatch = stdout.match(/\{[\s\S]*\}/);
          if (jsonMatch) {
            const result = JSON.parse(jsonMatch[0]);
            resolve(result);
          } else {
            resolve(null);
          }
        } catch (e) {
          console.error('Failed to parse linter output:', e);
          resolve(null);
        }
      });

      process.on('error', (err) => {
        console.error('Failed to start linter:', err);
        reject(err);
      });
    });
  }

  /**
   * Convert raw linter diagnostics to our format
   */
  private convertDiagnostics(raw: any[]): Diagnostic[] {
    return raw.map(d => ({
      message: d.message || 'Unknown error',
      line: d.line || 1,
      column: d.column || 1,
      endLine: d.endLine,
      endColumn: d.endColumn,
      severity: this.mapSeverity(d.severity),
      code: d.code
    }));
  }

  /**
   * Map severity from various formats
   */
  private mapSeverity(severity: string | number): DiagnosticSeverity {
    if (typeof severity === 'number') {
      switch (severity) {
        case 1: return 'error';
        case 2: return 'warning';
        case 3: return 'info';
        case 4: return 'hint';
        default: return 'error';
      }
    }

    switch (severity?.toLowerCase()) {
      case 'error': return 'error';
      case 'warning': return 'warning';
      case 'info':
      case 'information': return 'info';
      case 'hint': return 'hint';
      default: return 'error';
    }
  }

  /**
   * Convert our diagnostics to VS Code diagnostics
   */
  toVSCodeDiagnostics(diagnostics: Diagnostic[], uri: vscode.Uri): vscode.Diagnostic[] {
    return diagnostics.map(d => {
      const range = new vscode.Range(
        new vscode.Position(Math.max(0, d.line - 1), Math.max(0, d.column - 1)),
        new vscode.Position(Math.max(0, (d.endLine || d.line) - 1), Math.max(0, (d.endColumn || d.column) - 1))
      );

      const vscodeDiagnostic = new vscode.Diagnostic(
        range,
        d.message,
        this.toVSCodeSeverity(d.severity)
      );

      vscodeDiagnostic.source = 'ahk-training';
      if (d.code) {
        vscodeDiagnostic.code = d.code;
      }

      return vscodeDiagnostic;
    });
  }

  /**
   * Convert severity to VS Code severity
   */
  private toVSCodeSeverity(severity: DiagnosticSeverity): vscode.DiagnosticSeverity {
    switch (severity) {
      case 'error': return vscode.DiagnosticSeverity.Error;
      case 'warning': return vscode.DiagnosticSeverity.Warning;
      case 'info': return vscode.DiagnosticSeverity.Information;
      case 'hint': return vscode.DiagnosticSeverity.Hint;
      default: return vscode.DiagnosticSeverity.Error;
    }
  }

  /**
   * Get error and warning counts from diagnostics
   */
  getCounts(diagnostics: Diagnostic[]): { errors: number; warnings: number } {
    let errors = 0;
    let warnings = 0;

    for (const d of diagnostics) {
      if (d.severity === 'error') {
        errors++;
      } else if (d.severity === 'warning') {
        warnings++;
      }
    }

    return { errors, warnings };
  }
}
