/**
 * AHK v2 Linter CLI - Headless diagnostics using THQBY LSP
 *
 * Usage:
 *   npx ts-node index.ts lint path=/path/to/script.ahk
 *   npx ts-node index.ts lint path=/path/to/scripts --recursive
 *   npx ts-node index.ts lint path=script.ahk --format=json
 *   npx ts-node index.ts lint path=script.ahk --format=sarif
 *   npx ts-node index.ts beautify path=script.ahk
 */

import { existsSync, readdirSync, statSync, readFileSync, writeFileSync } from 'fs';
import { resolve, dirname, basename, extname, join } from 'path';
import { TextDocument } from 'vscode-languageserver-textdocument';
import { URI } from 'vscode-uri';

// LSP imports - adjust path based on build location
const LSP_ROOT = resolve(__dirname, '../../vscode-autohotkey2-lsp/server');

// Default root for resolving script paths (relative to this file's location)
const DEFAULT_SCRIPTS_ROOT = resolve(__dirname, '../../data/Scripts');

// Dynamic imports to handle the LSP module structure
let Lexer: any;
let openFile: any;
let setRootDir: any;
let initCaches: any;
let loadSyntax: any;

interface Diagnostic {
	message: string;
	line: number;
	column: number;
	endLine: number;
	endColumn: number;
	severity: 'error' | 'warning' | 'info' | 'hint';
	code?: string;
}

interface FileResult {
	file: string;
	diagnostics: Diagnostic[];
	summary: {
		errors: number;
		warnings: number;
		info: number;
		hints: number;
	};
}

interface BatchResult {
	files: FileResult[];
	summary: {
		totalFiles: number;
		filesWithErrors: number;
		filesWithWarnings: number;
		totalErrors: number;
		totalWarnings: number;
	};
}

// Severity mapping from LSP DiagnosticSeverity
const SEVERITY_MAP: Record<number, 'error' | 'warning' | 'info' | 'hint'> = {
	1: 'error',
	2: 'warning',
	3: 'info',
	4: 'hint'
};

function parseArgs(args: string[]): Record<string, string | boolean> {
	const options: Record<string, string | boolean> = {};
	args.forEach(arg => {
		if (arg.startsWith('--')) {
			const [key, value] = arg.slice(2).split('=');
			options[key] = value ?? true;
		} else if (arg.includes('=')) {
			const [key, value] = arg.split('=');
			options[key] = value.replace(/^(['"])(.*)\1$/, '$2');
		} else {
			options.command = arg;
		}
	});
	return options;
}

async function initializeLSP(): Promise<void> {
	try {
		// Import from compiled JS files (server/out/) not TypeScript source
		const common = await import(`${LSP_ROOT}/out/common.js`);
		const lexerModule = await import(`${LSP_ROOT}/out/Lexer.js`);

		Lexer = lexerModule.Lexer;
		openFile = common.openFile;
		setRootDir = common.setRootDir;
		initCaches = common.initCaches;
		loadSyntax = common.loadSyntax;

		// Initialize the LSP
		setRootDir(LSP_ROOT);
		initCaches();
		loadSyntax('ahk2', 3);
	} catch (e) {
		console.error('Failed to initialize LSP:', e);
		process.exit(1);
	}
}

function readTextFile(path: string): string | undefined {
	try {
		return readFileSync(path, 'utf-8');
	} catch {
		return undefined;
	}
}

function lintFile(filePath: string): FileResult {
	const absPath = resolve(filePath);
	const text = readTextFile(absPath);

	if (text === undefined) {
		return {
			file: absPath,
			diagnostics: [{
				message: `Cannot read file: ${absPath}`,
				line: 1,
				column: 1,
				endLine: 1,
				endColumn: 1,
				severity: 'error',
				code: 'file-not-found'
			}],
			summary: { errors: 1, warnings: 0, info: 0, hints: 0 }
		};
	}

	const uri = URI.file(absPath).toString();
	const doc = TextDocument.create(uri, 'ahk2', 0, text);

	const lexer = new Lexer(doc);
	lexer.parseScript();

	const diagnostics: Diagnostic[] = lexer.diagnostics.map((d: any) => ({
		message: d.message,
		line: (d.range?.start?.line ?? 0) + 1,
		column: (d.range?.start?.character ?? 0) + 1,
		endLine: (d.range?.end?.line ?? 0) + 1,
		endColumn: (d.range?.end?.character ?? 0) + 1,
		severity: SEVERITY_MAP[d.severity] ?? 'error',
		code: d.code
	}));

	const summary = {
		errors: diagnostics.filter(d => d.severity === 'error').length,
		warnings: diagnostics.filter(d => d.severity === 'warning').length,
		info: diagnostics.filter(d => d.severity === 'info').length,
		hints: diagnostics.filter(d => d.severity === 'hint').length
	};

	return { file: absPath, diagnostics, summary };
}

function findAhkFiles(dir: string, recursive: boolean): string[] {
	const files: string[] = [];

	const entries = readdirSync(dir);
	for (const entry of entries) {
		const fullPath = join(dir, entry);
		const stat = statSync(fullPath);

		if (stat.isDirectory() && recursive) {
			files.push(...findAhkFiles(fullPath, recursive));
		} else if (stat.isFile() && extname(entry).toLowerCase() === '.ahk') {
			files.push(fullPath);
		}
	}

	return files;
}

function lintBatch(paths: string[], recursive: boolean): BatchResult {
	const allFiles: string[] = [];

	for (const p of paths) {
		const absPath = resolve(p);
		if (!existsSync(absPath)) {
			console.error(`Path not found: ${absPath}`);
			continue;
		}

		const stat = statSync(absPath);
		if (stat.isDirectory()) {
			allFiles.push(...findAhkFiles(absPath, recursive));
		} else if (extname(absPath).toLowerCase() === '.ahk') {
			allFiles.push(absPath);
		}
	}

	const results: FileResult[] = allFiles.map(file => lintFile(file));

	return {
		files: results,
		summary: {
			totalFiles: results.length,
			filesWithErrors: results.filter(r => r.summary.errors > 0).length,
			filesWithWarnings: results.filter(r => r.summary.warnings > 0).length,
			totalErrors: results.reduce((sum, r) => sum + r.summary.errors, 0),
			totalWarnings: results.reduce((sum, r) => sum + r.summary.warnings, 0)
		}
	};
}

function beautifyFile(filePath: string, options: Record<string, any> = {}): string | null {
	const absPath = resolve(filePath);
	const td = openFile(absPath, false);
	if (!td) {
		console.error(`Cannot open file: ${absPath}`);
		return null;
	}

	const lexer = new Lexer(td);
	return lexer.beautify(options);
}

function toSARIF(result: BatchResult): object {
	return {
		$schema: 'https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json',
		version: '2.1.0',
		runs: [{
			tool: {
				driver: {
					name: 'ahk-linter',
					version: '1.0.0',
					informationUri: 'https://github.com/thqby/vscode-autohotkey2-lsp'
				}
			},
			results: result.files.flatMap(file =>
				file.diagnostics.map(d => ({
					ruleId: d.code ?? 'unknown',
					level: d.severity === 'error' ? 'error' : d.severity === 'warning' ? 'warning' : 'note',
					message: { text: d.message },
					locations: [{
						physicalLocation: {
							artifactLocation: { uri: `file://${file.file.replace(/\\/g, '/')}` },
							region: {
								startLine: d.line,
								startColumn: d.column,
								endLine: d.endLine,
								endColumn: d.endColumn
							}
						}
					}]
				}))
			)
		}]
	};
}

function printUsage(): void {
	console.log(`
AHK v2 Linter CLI - Headless diagnostics using THQBY LSP

Usage:
  npx ts-node index.ts <command> [options]

Commands:
  lint        Lint AHK files and output diagnostics
  beautify    Format AHK files using the LSP beautifier

Options:
  path=<path>       File or directory to process (required)
  --root=<dir>      Base directory for resolving paths (default: data/Scripts)
  --recursive       Process directories recursively
  --format=<fmt>    Output format: json (default), sarif, summary
  --output=<file>   Write output to file instead of stdout
  --fix             For lint: also beautify files (write changes)
  --quiet           Only output errors, no summary

Examples:
  npx ts-node index.ts lint path=Array/Array_01_Chunk.ahk
  npx ts-node index.ts lint path=Array --recursive
  npx ts-node index.ts lint path=Advanced --recursive --format=summary
  npx ts-node index.ts lint path=. --recursive --format=sarif --output=report.sarif
  npx ts-node index.ts beautify path=Array/Array_01_Chunk.ahk
  npx ts-node index.ts lint path=/absolute/path/script.ahk  # absolute paths bypass --root
`);
}

function resolvePath(inputPath: string, root: string): string {
	// If it's already absolute, use it directly
	if (inputPath.startsWith('/') || /^[A-Za-z]:/.test(inputPath)) {
		return resolve(inputPath);
	}
	// Otherwise resolve relative to root
	return resolve(root, inputPath);
}

async function main(): Promise<void> {
	const args = process.argv.slice(2);
	if (args.length === 0) {
		printUsage();
		process.exit(0);
	}

	const options = parseArgs(args);
	const command = options.command as string;
	const filePath = options.path as string;
	const format = (options.format as string) ?? 'json';
	const recursive = !!options.recursive;
	const outputFile = options.output as string;
	const quiet = !!options.quiet;
	const fix = !!options.fix;
	const root = options.root ? resolve(options.root as string) : DEFAULT_SCRIPTS_ROOT;

	if (!command || !['lint', 'beautify'].includes(command)) {
		printUsage();
		process.exit(1);
	}

	if (!filePath) {
		console.error('Error: path= is required');
		process.exit(1);
	}

	if (!quiet) {
		console.error(`Using root: ${root}`);
	}

	// Initialize LSP
	await initializeLSP();

	if (command === 'lint') {
		const paths = filePath.split(',').map(p => resolvePath(p.trim(), root));
		const result = lintBatch(paths, recursive);

		// Optionally fix files
		if (fix) {
			for (const fileResult of result.files) {
				if (fileResult.diagnostics.length > 0) {
					const beautified = beautifyFile(fileResult.file);
					if (beautified) {
						writeFileSync(fileResult.file, beautified, 'utf-8');
					}
				}
			}
		}

		let output: string;
		if (format === 'sarif') {
			output = JSON.stringify(toSARIF(result), null, 2);
		} else if (format === 'summary') {
			output = [
				`Files scanned: ${result.summary.totalFiles}`,
				`Files with errors: ${result.summary.filesWithErrors}`,
				`Files with warnings: ${result.summary.filesWithWarnings}`,
				`Total errors: ${result.summary.totalErrors}`,
				`Total warnings: ${result.summary.totalWarnings}`,
				'',
				...result.files
					.filter(f => f.summary.errors > 0 || f.summary.warnings > 0)
					.map(f => `  ${f.file}: ${f.summary.errors} errors, ${f.summary.warnings} warnings`)
			].join('\n');
		} else {
			output = JSON.stringify(result, null, 2);
		}

		if (outputFile) {
			writeFileSync(outputFile, output, 'utf-8');
			if (!quiet) {
				console.log(`Output written to: ${outputFile}`);
			}
		} else {
			console.log(output);
		}

		// Exit with error code if there are errors
		process.exit(result.summary.totalErrors > 0 ? 1 : 0);

	} else if (command === 'beautify') {
		const beautified = beautifyFile(resolvePath(filePath, root));
		if (beautified) {
			if (outputFile) {
				writeFileSync(outputFile, beautified, 'utf-8');
				if (!quiet) {
					console.log(`Output written to: ${outputFile}`);
				}
			} else {
				console.log(beautified);
			}
		} else {
			process.exit(1);
		}
	}
}

main().catch(e => {
	console.error(e);
	process.exit(1);
});
