"use strict";
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// src/extension.ts
var extension_exports = {};
__export(extension_exports, {
  activate: () => activate,
  deactivate: () => deactivate
});
module.exports = __toCommonJS(extension_exports);
var vscode3 = __toESM(require("vscode"));
var path3 = __toESM(require("path"));

// src/services/MetadataService.ts
var fs = __toESM(require("fs"));
var path = __toESM(require("path"));
var readline = __toESM(require("readline"));
var MetadataService = class {
  scriptsRoot;
  metadataPath;
  fileMap = /* @__PURE__ */ new Map();
  categoryMap = /* @__PURE__ */ new Map();
  initialized = false;
  constructor(workspaceRoot, scriptsRoot, metadataPath) {
    this.scriptsRoot = path.resolve(workspaceRoot, scriptsRoot);
    this.metadataPath = path.resolve(workspaceRoot, metadataPath);
  }
  /**
   * Initialize the service by loading metadata
   */
  async initialize() {
    if (this.initialized) {
      return;
    }
    await this.scanScriptsDirectory();
    if (fs.existsSync(this.metadataPath)) {
      await this.loadMetadataFile();
    }
    this.initialized = true;
  }
  /**
   * Scan the scripts directory and build the file index
   */
  async scanScriptsDirectory() {
    if (!fs.existsSync(this.scriptsRoot)) {
      console.warn(`Scripts directory not found: ${this.scriptsRoot}`);
      return;
    }
    const categories = fs.readdirSync(this.scriptsRoot, { withFileTypes: true }).filter((dirent) => dirent.isDirectory()).map((dirent) => dirent.name);
    for (const categoryName of categories) {
      const categoryPath = path.join(this.scriptsRoot, categoryName);
      const files = fs.readdirSync(categoryPath).filter((file) => file.endsWith(".ahk"));
      const category = {
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
        const scriptFile = {
          absolutePath,
          relativePath,
          filename,
          category: categoryName,
          quality: { rating: "unknown", errorCount: 0, warningCount: 0, infoCount: 0, hintCount: 0, score: 0 }
        };
        this.fileMap.set(relativePath, scriptFile);
        this.fileMap.set(filename, scriptFile);
        category.files.push(scriptFile);
      }
      this.categoryMap.set(categoryName, category);
    }
  }
  /**
   * Load metadata from JSONL file and merge with file index
   */
  async loadMetadataFile() {
    return new Promise((resolve4, reject) => {
      const fileStream = fs.createReadStream(this.metadataPath);
      const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity
      });
      rl.on("line", (line) => {
        try {
          const metadata = JSON.parse(line);
          const scriptFile = this.fileMap.get(metadata.file);
          if (scriptFile) {
            scriptFile.metadata = metadata;
          }
        } catch (e) {
        }
      });
      rl.on("close", () => {
        resolve4();
      });
      rl.on("error", (err) => {
        reject(err);
      });
    });
  }
  /**
   * Refresh metadata from files
   */
  async refresh() {
    this.initialized = false;
    this.fileMap.clear();
    this.categoryMap.clear();
    await this.initialize();
  }
  /**
   * Get all categories
   */
  getCategories() {
    return Array.from(this.categoryMap.values()).sort((a, b) => b.fileCount - a.fileCount);
  }
  /**
   * Get a specific category
   */
  getCategory(name) {
    return this.categoryMap.get(name);
  }
  /**
   * Get scripts in a category
   */
  getScriptsInCategory(categoryName) {
    const category = this.categoryMap.get(categoryName);
    return category?.files || [];
  }
  /**
   * Get a script by relative path
   */
  getScript(relativePath) {
    return this.fileMap.get(relativePath);
  }
  /**
   * Get all scripts
   */
  getAllScripts() {
    const scripts = [];
    for (const category of this.categoryMap.values()) {
      scripts.push(...category.files);
    }
    return scripts;
  }
  /**
   * Get total file count
   */
  getTotalFiles() {
    let total = 0;
    for (const category of this.categoryMap.values()) {
      total += category.fileCount;
    }
    return total;
  }
  /**
   * Update quality for a script
   */
  updateQuality(relativePath, errorCount, warningCount) {
    const script = this.fileMap.get(relativePath);
    if (script) {
      let rating = "good";
      if (errorCount > 0) {
        rating = "error";
      } else if (warningCount > 0) {
        rating = "warning";
      }
      script.quality = {
        rating,
        errorCount,
        warningCount,
        infoCount: 0,
        hintCount: 0,
        score: this.calculateScore(errorCount, warningCount)
      };
      const category = this.categoryMap.get(script.category);
      if (category) {
        this.recalculateCategoryCounts(category);
      }
    }
  }
  /**
   * Calculate quality score (0-100)
   */
  calculateScore(errors, warnings) {
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
  recalculateCategoryCounts(category) {
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
  getCategoryStats() {
    const stats = [];
    for (const category of this.categoryMap.values()) {
      let lineCount = 0;
      let cleanCount = 0;
      for (const file of category.files) {
        if (file.metadata?.line_count) {
          lineCount += file.metadata.line_count;
        }
        if (file.quality?.rating === "good") {
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
  getFeatureCoverage() {
    const directivesMap = /* @__PURE__ */ new Map();
    const functionsMap = /* @__PURE__ */ new Map();
    const hotkeysMap = /* @__PURE__ */ new Map();
    for (const [, script] of this.fileMap) {
      if (!script.metadata) continue;
      for (const directive of script.metadata.directives || []) {
        const existing = directivesMap.get(directive) || [];
        existing.push(script.relativePath);
        directivesMap.set(directive, existing);
      }
      for (const func of script.metadata.functions || []) {
        const existing = functionsMap.get(func) || [];
        existing.push(script.relativePath);
        functionsMap.set(func, existing);
      }
      for (const hotkey of script.metadata.hotkeys || []) {
        const existing = hotkeysMap.get(hotkey) || [];
        existing.push(script.relativePath);
        hotkeysMap.set(hotkey, existing);
      }
    }
    const mapToFeatureCounts = (map) => {
      return Array.from(map.entries()).map(([name, files]) => ({ name, count: files.length, files })).sort((a, b) => b.count - a.count);
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
  searchScripts(query) {
    const lowerQuery = query.toLowerCase();
    const results = [];
    for (const [, script] of this.fileMap) {
      if (script.filename.toLowerCase().includes(lowerQuery)) {
        results.push(script);
        continue;
      }
      if (script.metadata) {
        if (script.metadata.title?.toLowerCase().includes(lowerQuery) || script.metadata.description?.toLowerCase().includes(lowerQuery) || script.metadata.category?.toLowerCase().includes(lowerQuery)) {
          results.push(script);
        }
      }
    }
    return results;
  }
  /**
   * Filter scripts by quality
   */
  filterByQuality(rating) {
    const results = [];
    for (const [, script] of this.fileMap) {
      if (script.quality?.rating === rating) {
        results.push(script);
      }
    }
    return results;
  }
};

// src/services/LinterService.ts
var vscode = __toESM(require("vscode"));
var import_child_process = require("child_process");
var path2 = __toESM(require("path"));
var LinterService = class {
  linterPath;
  workspaceRoot;
  constructor(workspaceRoot, linterPath) {
    this.workspaceRoot = workspaceRoot;
    this.linterPath = path2.resolve(workspaceRoot, linterPath);
  }
  /**
   * Lint a single file
   */
  async lintFile(filePath) {
    const output = await this.runLinter(filePath);
    if (!output || !output.files || output.files.length === 0) {
      return [];
    }
    return this.convertDiagnostics(output.files[0].diagnostics || []);
  }
  /**
   * Lint multiple files with progress
   */
  async lintFiles(filePaths, progress) {
    const results = /* @__PURE__ */ new Map();
    const total = filePaths.length;
    for (let i = 0; i < filePaths.length; i++) {
      const filePath = filePaths[i];
      if (progress) {
        progress.report({
          message: `Linting ${path2.basename(filePath)} (${i + 1}/${total})`,
          increment: 1 / total * 100
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
  async lintDirectory(directoryPath) {
    return this.runLinter(directoryPath, true);
  }
  /**
   * Run the linter CLI
   */
  runLinter(targetPath, recursive = false) {
    return new Promise((resolve4, reject) => {
      const args = [
        "ts-node",
        "index.ts",
        "lint",
        `path=${targetPath}`,
        "--format=json",
        "--quiet"
      ];
      if (recursive) {
        args.push("--recursive");
      }
      const process = (0, import_child_process.spawn)("npx", args, {
        cwd: this.linterPath,
        shell: true,
        env: { ...globalThis.process.env }
      });
      let stdout = "";
      let stderr = "";
      process.stdout.on("data", (data) => {
        stdout += data.toString();
      });
      process.stderr.on("data", (data) => {
        stderr += data.toString();
      });
      process.on("close", (code) => {
        if (code !== 0 && code !== 1) {
          console.error(`Linter exited with code ${code}: ${stderr}`);
        }
        try {
          const jsonMatch = stdout.match(/\{[\s\S]*\}/);
          if (jsonMatch) {
            const result = JSON.parse(jsonMatch[0]);
            resolve4(result);
          } else {
            resolve4(null);
          }
        } catch (e) {
          console.error("Failed to parse linter output:", e);
          resolve4(null);
        }
      });
      process.on("error", (err) => {
        console.error("Failed to start linter:", err);
        reject(err);
      });
    });
  }
  /**
   * Convert raw linter diagnostics to our format
   */
  convertDiagnostics(raw) {
    return raw.map((d) => ({
      message: d.message || "Unknown error",
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
  mapSeverity(severity) {
    if (typeof severity === "number") {
      switch (severity) {
        case 1:
          return "error";
        case 2:
          return "warning";
        case 3:
          return "info";
        case 4:
          return "hint";
        default:
          return "error";
      }
    }
    switch (severity?.toLowerCase()) {
      case "error":
        return "error";
      case "warning":
        return "warning";
      case "info":
      case "information":
        return "info";
      case "hint":
        return "hint";
      default:
        return "error";
    }
  }
  /**
   * Convert our diagnostics to VS Code diagnostics
   */
  toVSCodeDiagnostics(diagnostics, uri) {
    return diagnostics.map((d) => {
      const range = new vscode.Range(
        new vscode.Position(Math.max(0, d.line - 1), Math.max(0, d.column - 1)),
        new vscode.Position(Math.max(0, (d.endLine || d.line) - 1), Math.max(0, (d.endColumn || d.column) - 1))
      );
      const vscodeDiagnostic = new vscode.Diagnostic(
        range,
        d.message,
        this.toVSCodeSeverity(d.severity)
      );
      vscodeDiagnostic.source = "ahk-training";
      if (d.code) {
        vscodeDiagnostic.code = d.code;
      }
      return vscodeDiagnostic;
    });
  }
  /**
   * Convert severity to VS Code severity
   */
  toVSCodeSeverity(severity) {
    switch (severity) {
      case "error":
        return vscode.DiagnosticSeverity.Error;
      case "warning":
        return vscode.DiagnosticSeverity.Warning;
      case "info":
        return vscode.DiagnosticSeverity.Information;
      case "hint":
        return vscode.DiagnosticSeverity.Hint;
      default:
        return vscode.DiagnosticSeverity.Error;
    }
  }
  /**
   * Get error and warning counts from diagnostics
   */
  getCounts(diagnostics) {
    let errors = 0;
    let warnings = 0;
    for (const d of diagnostics) {
      if (d.severity === "error") {
        errors++;
      } else if (d.severity === "warning") {
        warnings++;
      }
    }
    return { errors, warnings };
  }
};

// src/providers/ScriptTreeProvider.ts
var vscode2 = __toESM(require("vscode"));
var CategoryTreeItem = class extends vscode2.TreeItem {
  constructor(category) {
    super(category.name, vscode2.TreeItemCollapsibleState.Collapsed);
    this.category = category;
    this.description = `${category.fileCount} files`;
    this.tooltip = `${category.name}: ${category.fileCount} files`;
    this.contextValue = "category";
    if (category.errorCount > 0) {
      this.iconPath = new vscode2.ThemeIcon("folder", new vscode2.ThemeColor("testing.iconFailed"));
    } else if (category.warningCount > 0) {
      this.iconPath = new vscode2.ThemeIcon("folder", new vscode2.ThemeColor("list.warningForeground"));
    } else {
      this.iconPath = new vscode2.ThemeIcon("folder");
    }
  }
};
var ScriptFileTreeItem = class extends vscode2.TreeItem {
  constructor(script) {
    super(script.filename, vscode2.TreeItemCollapsibleState.None);
    this.script = script;
    this.description = script.metadata?.title || "";
    this.tooltip = this.buildTooltip();
    this.contextValue = "scriptFile";
    this.iconPath = this.getQualityIcon();
    this.command = {
      command: "vscode.open",
      title: "Open File",
      arguments: [vscode2.Uri.file(script.absolutePath)]
    };
    this.resourceUri = vscode2.Uri.file(script.absolutePath);
  }
  buildTooltip() {
    const md = new vscode2.MarkdownString();
    md.appendMarkdown(`**${this.script.filename}**

`);
    if (this.script.metadata) {
      if (this.script.metadata.title) {
        md.appendMarkdown(`${this.script.metadata.title}

`);
      }
      if (this.script.metadata.description) {
        md.appendMarkdown(`${this.script.metadata.description}

`);
      }
      md.appendMarkdown(`---
`);
      md.appendMarkdown(`- **Lines:** ${this.script.metadata.line_count || "unknown"}
`);
      md.appendMarkdown(`- **Category:** ${this.script.category}
`);
      if (this.script.metadata.functions && this.script.metadata.functions.length > 0) {
        md.appendMarkdown(`- **Functions:** ${this.script.metadata.functions.slice(0, 5).join(", ")}`);
        if (this.script.metadata.functions.length > 5) {
          md.appendMarkdown(` +${this.script.metadata.functions.length - 5} more`);
        }
        md.appendMarkdown("\n");
      }
    }
    if (this.script.quality) {
      md.appendMarkdown(`
**Quality:** ${this.script.quality.rating}`);
      if (this.script.quality.errorCount > 0) {
        md.appendMarkdown(` (${this.script.quality.errorCount} errors)`);
      }
      if (this.script.quality.warningCount > 0) {
        md.appendMarkdown(` (${this.script.quality.warningCount} warnings)`);
      }
    }
    return md;
  }
  getQualityIcon() {
    if (!this.script.quality || this.script.quality.rating === "unknown") {
      return new vscode2.ThemeIcon("file");
    }
    switch (this.script.quality.rating) {
      case "good":
        return new vscode2.ThemeIcon("check", new vscode2.ThemeColor("testing.iconPassed"));
      case "warning":
        return new vscode2.ThemeIcon("warning", new vscode2.ThemeColor("list.warningForeground"));
      case "error":
        return new vscode2.ThemeIcon("error", new vscode2.ThemeColor("testing.iconFailed"));
      default:
        return new vscode2.ThemeIcon("file");
    }
  }
};
var ScriptTreeProvider = class {
  constructor(metadataService2) {
    this.metadataService = metadataService2;
  }
  _onDidChangeTreeData = new vscode2.EventEmitter();
  onDidChangeTreeData = this._onDidChangeTreeData.event;
  qualityFilter = null;
  /**
   * Refresh the entire tree
   */
  refresh() {
    this._onDidChangeTreeData.fire(void 0);
  }
  /**
   * Refresh a specific item
   */
  refreshItem(item) {
    this._onDidChangeTreeData.fire(item);
  }
  /**
   * Set quality filter
   */
  setQualityFilter(rating) {
    this.qualityFilter = rating;
    this.refresh();
  }
  /**
   * Get tree item for display
   */
  getTreeItem(element) {
    return element;
  }
  /**
   * Get children of a tree item
   */
  async getChildren(element) {
    if (!element) {
      const categories = this.metadataService.getCategories();
      if (this.qualityFilter) {
        const filteredCategories = categories.filter((cat) => {
          return cat.files.some((f) => f.quality?.rating === this.qualityFilter);
        });
        return filteredCategories.map((cat) => new CategoryTreeItem(cat));
      }
      return categories.map((cat) => new CategoryTreeItem(cat));
    }
    if (element instanceof CategoryTreeItem) {
      let scripts = this.metadataService.getScriptsInCategory(element.category.name);
      if (this.qualityFilter) {
        scripts = scripts.filter((s) => s.quality?.rating === this.qualityFilter);
      }
      scripts.sort((a, b) => a.filename.localeCompare(b.filename));
      return scripts.map((script) => new ScriptFileTreeItem(script));
    }
    return [];
  }
  /**
   * Get parent of a tree item
   */
  getParent(element) {
    if (element instanceof ScriptFileTreeItem) {
      const category = this.metadataService.getCategory(element.script.category);
      if (category) {
        return new CategoryTreeItem(category);
      }
    }
    return void 0;
  }
};
var CategoryTreeProvider = class {
  constructor(metadataService2) {
    this.metadataService = metadataService2;
  }
  _onDidChangeTreeData = new vscode2.EventEmitter();
  onDidChangeTreeData = this._onDidChangeTreeData.event;
  refresh() {
    this._onDidChangeTreeData.fire(void 0);
  }
  getTreeItem(element) {
    return element;
  }
  async getChildren(element) {
    if (!element) {
      const categories = this.metadataService.getCategories();
      return categories.map((cat) => new CategoryTreeItem(cat));
    }
    return [];
  }
};

// src/extension.ts
var metadataService;
var linterService;
var scriptTreeProvider;
var categoryTreeProvider;
var diagnosticCollection;
async function activate(context) {
  console.log("AHK Training Review extension is now active");
  const workspaceFolders = vscode3.workspace.workspaceFolders;
  if (!workspaceFolders || workspaceFolders.length === 0) {
    vscode3.window.showWarningMessage("AHK Training Review: No workspace folder found");
    return;
  }
  const workspaceRoot = workspaceFolders[0].uri.fsPath;
  const config = vscode3.workspace.getConfiguration("ahkTraining");
  const scriptsRoot = config.get("scriptsRoot", "data/Scripts");
  const metadataPath = config.get("metadataPath", "data/ahk_example_metadata.jsonl");
  const linterPath = config.get("linterPath", "tools/ahk-linter");
  metadataService = new MetadataService(workspaceRoot, scriptsRoot, metadataPath);
  linterService = new LinterService(workspaceRoot, linterPath);
  await vscode3.window.withProgress(
    {
      location: vscode3.ProgressLocation.Notification,
      title: "AHK Training Review",
      cancellable: false
    },
    async (progress) => {
      progress.report({ message: "Loading script metadata..." });
      await metadataService.initialize();
      progress.report({ message: "Ready!" });
    }
  );
  scriptTreeProvider = new ScriptTreeProvider(metadataService);
  categoryTreeProvider = new CategoryTreeProvider(metadataService);
  diagnosticCollection = vscode3.languages.createDiagnosticCollection("ahk-training");
  context.subscriptions.push(diagnosticCollection);
  const scriptExplorer = vscode3.window.createTreeView("ahkTraining.scriptExplorer", {
    treeDataProvider: scriptTreeProvider,
    showCollapseAll: true
  });
  context.subscriptions.push(scriptExplorer);
  const categoriesView = vscode3.window.createTreeView("ahkTraining.categories", {
    treeDataProvider: categoryTreeProvider,
    showCollapseAll: true
  });
  context.subscriptions.push(categoriesView);
  registerCommands(context, workspaceRoot);
  const totalFiles = metadataService.getTotalFiles();
  const categories = metadataService.getCategories();
  vscode3.window.showInformationMessage(
    `AHK Training Review: Loaded ${totalFiles} scripts in ${categories.length} categories`
  );
}
function registerCommands(context, workspaceRoot) {
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.refreshExplorer", async () => {
      await metadataService.refresh();
      scriptTreeProvider.refresh();
      categoryTreeProvider.refresh();
      vscode3.window.showInformationMessage("Script explorer refreshed");
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.openPreview", (item) => {
      if (item && item.script) {
        vscode3.window.showTextDocument(vscode3.Uri.file(item.script.absolutePath));
      }
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.openAnalytics", () => {
      const stats = metadataService.getCategoryStats();
      const totalFiles = metadataService.getTotalFiles();
      const message = `AHK Training Analytics

Total Files: ${totalFiles}
Categories: ${stats.length}

Top Categories:
` + stats.slice(0, 5).map((s) => `  ${s.name}: ${s.fileCount} files`).join("\n");
      vscode3.window.showInformationMessage(message, { modal: true });
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.searchScripts", async () => {
      const query = await vscode3.window.showInputBox({
        prompt: "Search training scripts",
        placeHolder: "Enter search term..."
      });
      if (query) {
        const results = metadataService.searchScripts(query);
        if (results.length === 0) {
          vscode3.window.showInformationMessage(`No scripts found matching "${query}"`);
          return;
        }
        const items = results.slice(0, 20).map((script) => ({
          label: script.filename,
          description: script.category,
          detail: script.metadata?.title || "",
          script
        }));
        const selected = await vscode3.window.showQuickPick(items, {
          placeHolder: `Found ${results.length} scripts`
        });
        if (selected) {
          vscode3.window.showTextDocument(vscode3.Uri.file(selected.script.absolutePath));
        }
      }
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.lintFile", async (item) => {
      let filePath;
      if (item && item.script) {
        filePath = item.script.absolutePath;
      } else {
        const editor = vscode3.window.activeTextEditor;
        if (editor && editor.document.languageId === "ahk2") {
          filePath = editor.document.uri.fsPath;
        }
      }
      if (!filePath) {
        vscode3.window.showWarningMessage("No AHK file selected");
        return;
      }
      await vscode3.window.withProgress(
        {
          location: vscode3.ProgressLocation.Notification,
          title: "Linting script...",
          cancellable: false
        },
        async () => {
          const diagnostics = await linterService.lintFile(filePath);
          const uri = vscode3.Uri.file(filePath);
          const vscodeDiagnostics = linterService.toVSCodeDiagnostics(diagnostics, uri);
          diagnosticCollection.set(uri, vscodeDiagnostics);
          const relativePath = path3.relative(
            path3.resolve(workspaceRoot, "data/Scripts"),
            filePath
          );
          const counts = linterService.getCounts(diagnostics);
          metadataService.updateQuality(relativePath, counts.errors, counts.warnings);
          scriptTreeProvider.refresh();
          if (diagnostics.length === 0) {
            vscode3.window.showInformationMessage("No issues found");
          } else {
            vscode3.window.showWarningMessage(
              `Found ${counts.errors} error(s) and ${counts.warnings} warning(s)`
            );
          }
        }
      );
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.lintCategory", async (item) => {
      if (!item) {
        vscode3.window.showWarningMessage("No category selected");
        return;
      }
      const scripts = metadataService.getScriptsInCategory(item.category.name);
      const filePaths = scripts.map((s) => s.absolutePath);
      await vscode3.window.withProgress(
        {
          location: vscode3.ProgressLocation.Notification,
          title: `Linting ${item.category.name}...`,
          cancellable: true
        },
        async (progress, token) => {
          const results = await linterService.lintFiles(filePaths, progress);
          let totalErrors = 0;
          let totalWarnings = 0;
          for (const [filePath, diagnostics] of results) {
            const uri = vscode3.Uri.file(filePath);
            const vscodeDiagnostics = linterService.toVSCodeDiagnostics(diagnostics, uri);
            diagnosticCollection.set(uri, vscodeDiagnostics);
            const counts = linterService.getCounts(diagnostics);
            totalErrors += counts.errors;
            totalWarnings += counts.warnings;
            const relativePath = path3.relative(
              path3.resolve(workspaceRoot, "data/Scripts"),
              filePath
            );
            metadataService.updateQuality(relativePath, counts.errors, counts.warnings);
          }
          scriptTreeProvider.refresh();
          vscode3.window.showInformationMessage(
            `Linted ${scripts.length} files: ${totalErrors} error(s), ${totalWarnings} warning(s)`
          );
        }
      );
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.lintAll", async () => {
      const scripts = metadataService.getAllScripts();
      const confirm = await vscode3.window.showWarningMessage(
        `This will lint all ${scripts.length} scripts. Continue?`,
        "Yes",
        "No"
      );
      if (confirm !== "Yes") {
        return;
      }
      const filePaths = scripts.map((s) => s.absolutePath);
      await vscode3.window.withProgress(
        {
          location: vscode3.ProgressLocation.Notification,
          title: "Linting all scripts...",
          cancellable: true
        },
        async (progress) => {
          const results = await linterService.lintFiles(filePaths, progress);
          let totalErrors = 0;
          let totalWarnings = 0;
          let cleanFiles = 0;
          for (const [filePath, diagnostics] of results) {
            const uri = vscode3.Uri.file(filePath);
            const vscodeDiagnostics = linterService.toVSCodeDiagnostics(diagnostics, uri);
            diagnosticCollection.set(uri, vscodeDiagnostics);
            const counts = linterService.getCounts(diagnostics);
            totalErrors += counts.errors;
            totalWarnings += counts.warnings;
            if (counts.errors === 0 && counts.warnings === 0) {
              cleanFiles++;
            }
            const relativePath = path3.relative(
              path3.resolve(workspaceRoot, "data/Scripts"),
              filePath
            );
            metadataService.updateQuality(relativePath, counts.errors, counts.warnings);
          }
          scriptTreeProvider.refresh();
          const pct = (cleanFiles / scripts.length * 100).toFixed(1);
          vscode3.window.showInformationMessage(
            `Linted ${scripts.length} files: ${cleanFiles} clean (${pct}%), ${totalErrors} error(s), ${totalWarnings} warning(s)`
          );
        }
      );
    })
  );
  context.subscriptions.push(
    vscode3.commands.registerCommand("ahkTraining.filterByQuality", async () => {
      const options = [
        { label: "All", description: "Show all scripts" },
        { label: "Good", description: "Scripts with no errors or warnings" },
        { label: "Warning", description: "Scripts with warnings" },
        { label: "Error", description: "Scripts with errors" },
        { label: "Unknown", description: "Scripts not yet linted" }
      ];
      const selected = await vscode3.window.showQuickPick(options, {
        placeHolder: "Filter scripts by quality"
      });
      if (selected) {
        const filter = selected.label.toLowerCase() === "all" ? null : selected.label.toLowerCase();
        scriptTreeProvider.setQualityFilter(filter);
      }
    })
  );
}
function deactivate() {
  console.log("AHK Training Review extension deactivated");
}
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  activate,
  deactivate
});
