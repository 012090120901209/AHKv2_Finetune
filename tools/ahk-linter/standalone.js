#!/usr/bin/env node
/**
 * Standalone AHK v2 Linter - Quick validation without full LSP
 *
 * Uses regex patterns to detect common issues.
 * For full LSP diagnostics, install the LSP dependencies first.
 *
 * Usage:
 *   node standalone.js path/to/script.ahk
 *   node standalone.js path/to/scripts --recursive
 */

const fs = require('fs');
const path = require('path');

// Validation patterns
const CHECKS = [
    {
        id: 'missing-requires',
        severity: 'error',
        pattern: /^#Requires\s+AutoHotkey\s+v2/im,
        invert: true, // Error if NOT found
        message: 'Missing #Requires AutoHotkey v2.0 header'
    },
    {
        id: 'v1-msgbox',
        severity: 'error',
        pattern: /^\s*MsgBox\s*,/im,
        message: 'v1 MsgBox syntax detected (use MsgBox() instead)'
    },
    {
        id: 'v1-gui',
        severity: 'error',
        pattern: /^\s*Gui\s*,/im,
        message: 'v1 Gui syntax detected (use Gui() object instead)'
    },
    {
        id: 'v1-stringreplace',
        severity: 'error',
        pattern: /^\s*StringReplace\s*,/im,
        message: 'v1 StringReplace command (use StrReplace() instead)'
    },
    {
        id: 'v1-ifequal',
        severity: 'error',
        pattern: /^\s*IfEqual\s*,/im,
        message: 'v1 IfEqual syntax (use if var = value instead)'
    },
    {
        id: 'v1-setenv',
        severity: 'error',
        pattern: /^\s*SetEnv\s*,/im,
        message: 'v1 SetEnv command (use := assignment instead)'
    },
    {
        id: 'v1-goto',
        severity: 'warning',
        pattern: /^\s*Goto\s*,/im,
        message: 'v1 Goto syntax (use Goto(label) instead)'
    },
    {
        id: 'missing-singleinstance',
        severity: 'warning',
        pattern: /^#SingleInstance/im,
        invert: true,
        message: 'Missing #SingleInstance directive (recommended: #SingleInstance Force)'
    },
    {
        id: 'conversion-artifact',
        severity: 'warning',
        pattern: /V1toV2|converter|Issue\s*#?\d+/i,
        message: 'Conversion artifact detected - should be cleaned up'
    },
    {
        id: 'hardcoded-path',
        severity: 'warning',
        pattern: /[A-Z]:\\Users\\[^"'\s]+/i,
        message: 'Hardcoded user path detected'
    }
];

function lintFile(filePath) {
    const content = fs.readFileSync(filePath, 'utf-8');
    const lines = content.split('\n');
    const issues = [];

    for (const check of CHECKS) {
        if (check.invert) {
            // Pattern should be present
            if (!check.pattern.test(content)) {
                issues.push({
                    line: 1,
                    severity: check.severity,
                    code: check.id,
                    message: check.message
                });
            }
        } else {
            // Pattern should NOT be present
            for (let i = 0; i < lines.length; i++) {
                if (check.pattern.test(lines[i])) {
                    issues.push({
                        line: i + 1,
                        severity: check.severity,
                        code: check.id,
                        message: check.message
                    });
                }
            }
        }
    }

    return {
        file: filePath,
        issues,
        summary: {
            errors: issues.filter(i => i.severity === 'error').length,
            warnings: issues.filter(i => i.severity === 'warning').length
        }
    };
}

function findAhkFiles(dir, recursive) {
    const files = [];
    const entries = fs.readdirSync(dir, { withFileTypes: true });

    for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);
        if (entry.isDirectory() && recursive) {
            files.push(...findAhkFiles(fullPath, recursive));
        } else if (entry.isFile() && entry.name.toLowerCase().endsWith('.ahk')) {
            files.push(fullPath);
        }
    }

    return files;
}

function main() {
    const args = process.argv.slice(2);

    if (args.length === 0) {
        console.log(`
AHK v2 Standalone Linter

Usage:
  node standalone.js <file.ahk>              Lint single file
  node standalone.js <directory>             Lint directory
  node standalone.js <directory> --recursive Lint recursively
  node standalone.js <path> --json           Output as JSON

Examples:
  node standalone.js script.ahk
  node standalone.js data/Scripts --recursive
  node standalone.js data/Scripts --recursive --json > report.json
`);
        process.exit(0);
    }

    const targetPath = args[0];
    const recursive = args.includes('--recursive') || args.includes('-r');
    const jsonOutput = args.includes('--json');

    if (!fs.existsSync(targetPath)) {
        console.error(`Error: Path not found: ${targetPath}`);
        process.exit(1);
    }

    const stat = fs.statSync(targetPath);
    let files = [];

    if (stat.isDirectory()) {
        files = findAhkFiles(targetPath, recursive);
    } else {
        files = [targetPath];
    }

    const results = files.map(f => lintFile(f));

    const summary = {
        totalFiles: results.length,
        filesWithErrors: results.filter(r => r.summary.errors > 0).length,
        filesWithWarnings: results.filter(r => r.summary.warnings > 0).length,
        totalErrors: results.reduce((sum, r) => sum + r.summary.errors, 0),
        totalWarnings: results.reduce((sum, r) => sum + r.summary.warnings, 0)
    };

    if (jsonOutput) {
        console.log(JSON.stringify({ summary, files: results }, null, 2));
    } else {
        // Human-readable output
        for (const result of results) {
            if (result.issues.length > 0) {
                console.log(`\n${result.file}:`);
                for (const issue of result.issues) {
                    const prefix = issue.severity === 'error' ? '  ERROR' : '  WARN ';
                    console.log(`${prefix} [${issue.code}] Line ${issue.line}: ${issue.message}`);
                }
            }
        }

        console.log(`\n${'='.repeat(60)}`);
        console.log(`Files scanned:      ${summary.totalFiles}`);
        console.log(`Files with errors:  ${summary.filesWithErrors}`);
        console.log(`Files with warnings: ${summary.filesWithWarnings}`);
        console.log(`Total errors:       ${summary.totalErrors}`);
        console.log(`Total warnings:     ${summary.totalWarnings}`);
    }

    // Exit with error code if errors found
    process.exit(summary.totalErrors > 0 ? 1 : 0);
}

main();
