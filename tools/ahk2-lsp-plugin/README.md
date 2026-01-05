# AHK2 LSP Plugin for Claude Code

AutoHotkey v2 language server integration for Claude Code.

## Features

- **Syntax Diagnostics**: Real-time error detection
- **Code Intelligence**: Go to definition, find references, hover info
- **Formatting**: Code beautification via LSP
- **v1 Detection**: Warns when v1 syntax is used

## Prerequisites

1. **Node.js** (v18+)
2. **Build the LSP server**:
   ```bash
   cd vscode-autohotkey2-lsp
   npm install
   node esbuild.mjs
   ```

## Installation

### Option 1: Copy to Claude Config

```bash
# Copy .lsp.json to your project or global config
cp .lsp.json ~/.claude/.lsp.json

# Or for project-specific:
cp .lsp.json /path/to/your/project/.lsp.json
```

### Option 2: Enable LSP Support

```bash
# Enable LSP in Claude Code
export ENABLE_LSP_TOOL=1

# Optional: Apply tweakcc patches
npx tweakcc --apply
```

## Configuration

Edit `.lsp.json` to customize:

```json
{
  "autohotkey2": {
    "command": "node",
    "args": ["/absolute/path/to/server/dist/server.js", "--stdio"],
    "initializationOptions": {
      "Diagnostics": {
        "ClassStaticMemberCheck": true,
        "ParamsCheck": true
      },
      "Warn": {
        "VarUnset": true,
        "LocalSameAsGlobal": true,
        "CallWithoutParentheses": true
      }
    }
  }
}
```

## LSP Operations Available

Once configured, you can use the LSP tool in Claude Code:

```
LSP operation=hover filePath=script.ahk line=10 character=5
LSP operation=goToDefinition filePath=script.ahk line=15 character=12
LSP operation=findReferences filePath=script.ahk line=20 character=8
LSP operation=documentSymbol filePath=script.ahk line=1 character=1
```

## Troubleshooting

### LSP not starting
- Check Node.js is installed: `node --version`
- Verify server.js exists: `ls vscode-autohotkey2-lsp/server/dist/server.js`
- Check path in .lsp.json is absolute or correctly relative

### No diagnostics appearing
- Ensure ENABLE_LSP_TOOL=1 is set
- Check file has .ahk extension
- Verify the file is saved (LSP reads from disk)

## Integration with Agent Harness

The agent harness can use LSP diagnostics when available:

```python
# In tools/agent-harness/agent.py
# LSP diagnostics are automatically included when the LSP is running
```

## Credits

- **THQBY**: Original vscode-autohotkey2-lsp implementation
- **Claude Code**: LSP integration support
