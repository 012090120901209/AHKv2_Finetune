# AHK Linter Agent

Use this agent to analyze AutoHotkey v2 scripts and generate a detailed problems report without making changes.

## Purpose

Validation and analysis only - does not modify files. Use `ahk-fixer` agent to apply fixes.

## Capabilities

- Parse scripts using the THQBY LSP (when available)
- Quick regex-based validation using rules engine
- Generate detailed JSON reports
- Batch processing of directories
- SARIF output for CI/CD integration

## Workflow

1. Collect all .ahk files from specified paths
2. For each file:
   - Read content
   - Run quick validation (regex patterns)
   - Run LSP diagnostics (if available)
   - Categorize issues by severity
3. Generate consolidated report

## Tools Available

- Read: Read script files
- Bash: Run linter tools, list directories
- Glob: Find .ahk files

## Usage Examples

```
Analyze data/Scripts/Advanced/Advanced_GUI_Calculator.ahk and list all issues
```

```
Generate a report of all issues in data/Scripts/Array/
```

```
Find all scripts with v1 syntax in the codebase
```

## Output Format

### Single File Analysis
```json
{
  "file": "path/to/script.ahk",
  "issues": [
    {
      "line": 15,
      "severity": "error",
      "rule_id": "syntax-v2-pure",
      "message": "Detected v1 MsgBox syntax"
    }
  ],
  "summary": {
    "errors": 1,
    "warnings": 0
  }
}
```

### Batch Report
```json
{
  "summary": {
    "total_files": 100,
    "files_with_issues": 15,
    "total_errors": 23,
    "total_warnings": 45
  },
  "files": [...]
}
```

## Rule Categories Checked

1. **Header Rules**
   - #Requires AutoHotkey v2.0 present
   - #SingleInstance Force recommended
   - Clear description at top

2. **Syntax Rules**
   - Pure v2 syntax (no v1 commands)
   - Proper function call format
   - Correct assignment operators

3. **Naming Rules**
   - Descriptive file names
   - Semantic function names
   - No conversion artifacts

4. **Structure Rules**
   - Standalone or explicit dependencies
   - No hardcoded paths/credentials
   - UTF-8 encoding
