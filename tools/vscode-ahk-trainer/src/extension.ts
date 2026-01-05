import * as vscode from 'vscode';
import * as path from 'path';
import { MetadataService } from './services/MetadataService';
import { LinterService } from './services/LinterService';
import { ScriptTreeProvider, CategoryTreeProvider, ScriptFileTreeItem, CategoryTreeItem } from './providers/ScriptTreeProvider';
import { QualityRating } from './models/types';

let metadataService: MetadataService;
let linterService: LinterService;
let scriptTreeProvider: ScriptTreeProvider;
let categoryTreeProvider: CategoryTreeProvider;
let diagnosticCollection: vscode.DiagnosticCollection;

/**
 * Extension activation
 */
export async function activate(context: vscode.ExtensionContext) {
  console.log('AHK Training Review extension is now active');

  // Get workspace root
  const workspaceFolders = vscode.workspace.workspaceFolders;
  if (!workspaceFolders || workspaceFolders.length === 0) {
    vscode.window.showWarningMessage('AHK Training Review: No workspace folder found');
    return;
  }

  const workspaceRoot = workspaceFolders[0].uri.fsPath;

  // Get configuration
  const config = vscode.workspace.getConfiguration('ahkTraining');
  const scriptsRoot = config.get<string>('scriptsRoot', 'data/Scripts');
  const metadataPath = config.get<string>('metadataPath', 'data/ahk_example_metadata.jsonl');
  const linterPath = config.get<string>('linterPath', 'tools/ahk-linter');

  // Initialize services
  metadataService = new MetadataService(workspaceRoot, scriptsRoot, metadataPath);
  linterService = new LinterService(workspaceRoot, linterPath);

  // Initialize metadata
  await vscode.window.withProgress(
    {
      location: vscode.ProgressLocation.Notification,
      title: 'AHK Training Review',
      cancellable: false
    },
    async (progress) => {
      progress.report({ message: 'Loading script metadata...' });
      await metadataService.initialize();
      progress.report({ message: 'Ready!' });
    }
  );

  // Create tree providers
  scriptTreeProvider = new ScriptTreeProvider(metadataService);
  categoryTreeProvider = new CategoryTreeProvider(metadataService);

  // Create diagnostic collection
  diagnosticCollection = vscode.languages.createDiagnosticCollection('ahk-training');
  context.subscriptions.push(diagnosticCollection);

  // Register tree views
  const scriptExplorer = vscode.window.createTreeView('ahkTraining.scriptExplorer', {
    treeDataProvider: scriptTreeProvider,
    showCollapseAll: true
  });
  context.subscriptions.push(scriptExplorer);

  const categoriesView = vscode.window.createTreeView('ahkTraining.categories', {
    treeDataProvider: categoryTreeProvider,
    showCollapseAll: true
  });
  context.subscriptions.push(categoriesView);

  // Register commands
  registerCommands(context, workspaceRoot);

  // Show summary
  const totalFiles = metadataService.getTotalFiles();
  const categories = metadataService.getCategories();
  vscode.window.showInformationMessage(
    `AHK Training Review: Loaded ${totalFiles} scripts in ${categories.length} categories`
  );
}

/**
 * Register extension commands
 */
function registerCommands(context: vscode.ExtensionContext, workspaceRoot: string) {
  // Refresh explorer
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.refreshExplorer', async () => {
      await metadataService.refresh();
      scriptTreeProvider.refresh();
      categoryTreeProvider.refresh();
      vscode.window.showInformationMessage('Script explorer refreshed');
    })
  );

  // Open preview (placeholder for now)
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.openPreview', (item?: ScriptFileTreeItem) => {
      if (item && item.script) {
        vscode.window.showTextDocument(vscode.Uri.file(item.script.absolutePath));
      }
    })
  );

  // Open analytics (placeholder for now)
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.openAnalytics', () => {
      const stats = metadataService.getCategoryStats();
      const totalFiles = metadataService.getTotalFiles();

      const message = `AHK Training Analytics\n\n` +
        `Total Files: ${totalFiles}\n` +
        `Categories: ${stats.length}\n\n` +
        `Top Categories:\n` +
        stats.slice(0, 5).map(s => `  ${s.name}: ${s.fileCount} files`).join('\n');

      vscode.window.showInformationMessage(message, { modal: true });
    })
  );

  // Search scripts (placeholder for now)
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.searchScripts', async () => {
      const query = await vscode.window.showInputBox({
        prompt: 'Search training scripts',
        placeHolder: 'Enter search term...'
      });

      if (query) {
        const results = metadataService.searchScripts(query);
        if (results.length === 0) {
          vscode.window.showInformationMessage(`No scripts found matching "${query}"`);
          return;
        }

        const items = results.slice(0, 20).map(script => ({
          label: script.filename,
          description: script.category,
          detail: script.metadata?.title || '',
          script
        }));

        const selected = await vscode.window.showQuickPick(items, {
          placeHolder: `Found ${results.length} scripts`
        });

        if (selected) {
          vscode.window.showTextDocument(vscode.Uri.file(selected.script.absolutePath));
        }
      }
    })
  );

  // Lint file
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.lintFile', async (item?: ScriptFileTreeItem) => {
      let filePath: string | undefined;

      if (item && item.script) {
        filePath = item.script.absolutePath;
      } else {
        // Use active editor
        const editor = vscode.window.activeTextEditor;
        if (editor && editor.document.languageId === 'ahk2') {
          filePath = editor.document.uri.fsPath;
        }
      }

      if (!filePath) {
        vscode.window.showWarningMessage('No AHK file selected');
        return;
      }

      await vscode.window.withProgress(
        {
          location: vscode.ProgressLocation.Notification,
          title: 'Linting script...',
          cancellable: false
        },
        async () => {
          const diagnostics = await linterService.lintFile(filePath!);
          const uri = vscode.Uri.file(filePath!);

          // Update VS Code diagnostics
          const vscodeDiagnostics = linterService.toVSCodeDiagnostics(diagnostics, uri);
          diagnosticCollection.set(uri, vscodeDiagnostics);

          // Update metadata service
          const relativePath = path.relative(
            path.resolve(workspaceRoot, 'data/Scripts'),
            filePath!
          );
          const counts = linterService.getCounts(diagnostics);
          metadataService.updateQuality(relativePath, counts.errors, counts.warnings);

          // Refresh tree
          scriptTreeProvider.refresh();

          // Show result
          if (diagnostics.length === 0) {
            vscode.window.showInformationMessage('No issues found');
          } else {
            vscode.window.showWarningMessage(
              `Found ${counts.errors} error(s) and ${counts.warnings} warning(s)`
            );
          }
        }
      );
    })
  );

  // Lint category
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.lintCategory', async (item?: CategoryTreeItem) => {
      if (!item) {
        vscode.window.showWarningMessage('No category selected');
        return;
      }

      const scripts = metadataService.getScriptsInCategory(item.category.name);
      const filePaths = scripts.map(s => s.absolutePath);

      await vscode.window.withProgress(
        {
          location: vscode.ProgressLocation.Notification,
          title: `Linting ${item.category.name}...`,
          cancellable: true
        },
        async (progress, token) => {
          const results = await linterService.lintFiles(filePaths, progress);

          let totalErrors = 0;
          let totalWarnings = 0;

          for (const [filePath, diagnostics] of results) {
            const uri = vscode.Uri.file(filePath);
            const vscodeDiagnostics = linterService.toVSCodeDiagnostics(diagnostics, uri);
            diagnosticCollection.set(uri, vscodeDiagnostics);

            const counts = linterService.getCounts(diagnostics);
            totalErrors += counts.errors;
            totalWarnings += counts.warnings;

            // Update metadata
            const relativePath = path.relative(
              path.resolve(workspaceRoot, 'data/Scripts'),
              filePath
            );
            metadataService.updateQuality(relativePath, counts.errors, counts.warnings);
          }

          // Refresh tree
          scriptTreeProvider.refresh();

          vscode.window.showInformationMessage(
            `Linted ${scripts.length} files: ${totalErrors} error(s), ${totalWarnings} warning(s)`
          );
        }
      );
    })
  );

  // Lint all
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.lintAll', async () => {
      const scripts = metadataService.getAllScripts();

      const confirm = await vscode.window.showWarningMessage(
        `This will lint all ${scripts.length} scripts. Continue?`,
        'Yes',
        'No'
      );

      if (confirm !== 'Yes') {
        return;
      }

      const filePaths = scripts.map(s => s.absolutePath);

      await vscode.window.withProgress(
        {
          location: vscode.ProgressLocation.Notification,
          title: 'Linting all scripts...',
          cancellable: true
        },
        async (progress) => {
          const results = await linterService.lintFiles(filePaths, progress);

          let totalErrors = 0;
          let totalWarnings = 0;
          let cleanFiles = 0;

          for (const [filePath, diagnostics] of results) {
            const uri = vscode.Uri.file(filePath);
            const vscodeDiagnostics = linterService.toVSCodeDiagnostics(diagnostics, uri);
            diagnosticCollection.set(uri, vscodeDiagnostics);

            const counts = linterService.getCounts(diagnostics);
            totalErrors += counts.errors;
            totalWarnings += counts.warnings;

            if (counts.errors === 0 && counts.warnings === 0) {
              cleanFiles++;
            }

            // Update metadata
            const relativePath = path.relative(
              path.resolve(workspaceRoot, 'data/Scripts'),
              filePath
            );
            metadataService.updateQuality(relativePath, counts.errors, counts.warnings);
          }

          // Refresh tree
          scriptTreeProvider.refresh();

          const pct = ((cleanFiles / scripts.length) * 100).toFixed(1);
          vscode.window.showInformationMessage(
            `Linted ${scripts.length} files: ${cleanFiles} clean (${pct}%), ` +
            `${totalErrors} error(s), ${totalWarnings} warning(s)`
          );
        }
      );
    })
  );

  // Filter by quality
  context.subscriptions.push(
    vscode.commands.registerCommand('ahkTraining.filterByQuality', async () => {
      const options: vscode.QuickPickItem[] = [
        { label: 'All', description: 'Show all scripts' },
        { label: 'Good', description: 'Scripts with no errors or warnings' },
        { label: 'Warning', description: 'Scripts with warnings' },
        { label: 'Error', description: 'Scripts with errors' },
        { label: 'Unknown', description: 'Scripts not yet linted' }
      ];

      const selected = await vscode.window.showQuickPick(options, {
        placeHolder: 'Filter scripts by quality'
      });

      if (selected) {
        const filter = selected.label.toLowerCase() === 'all'
          ? null
          : selected.label.toLowerCase() as QualityRating;

        scriptTreeProvider.setQualityFilter(filter);
      }
    })
  );
}

/**
 * Extension deactivation
 */
export function deactivate() {
  console.log('AHK Training Review extension deactivated');
}
