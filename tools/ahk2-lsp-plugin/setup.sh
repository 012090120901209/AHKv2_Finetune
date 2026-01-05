#!/bin/bash
# AHK2 LSP Plugin Setup Script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LSP_DIR="$PROJECT_ROOT/vscode-autohotkey2-lsp"

echo "=== AHK2 LSP Plugin Setup ==="
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js not found. Please install Node.js first."
    exit 1
fi
echo "✓ Node.js found: $(node --version)"

# Check if LSP exists
if [ ! -d "$LSP_DIR" ]; then
    echo "ERROR: LSP directory not found at $LSP_DIR"
    exit 1
fi
echo "✓ LSP directory found"

# Install dependencies
echo ""
echo "Installing LSP dependencies..."
cd "$LSP_DIR"
npm install

# Build LSP
echo ""
echo "Building LSP server..."
node esbuild.mjs

# Verify build
if [ ! -f "$LSP_DIR/server/dist/server.js" ]; then
    echo "ERROR: Build failed - server.js not found"
    exit 1
fi
echo "✓ LSP server built successfully"

# Create .lsp.json with absolute paths
echo ""
echo "Creating .lsp.json configuration..."

# Determine the server path based on OS
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ -n "$WSL_DISTRO_NAME" ]]; then
    # Windows/WSL - convert to Windows path
    WIN_LSP_PATH=$(wslpath -w "$LSP_DIR/server/dist/server.js" 2>/dev/null || echo "$LSP_DIR/server/dist/server.js")
    SERVER_PATH="$WIN_LSP_PATH"
else
    SERVER_PATH="$LSP_DIR/server/dist/server.js"
fi

cat > "$PROJECT_ROOT/.lsp.json" << EOF
{
  "autohotkey2": {
    "command": "node",
    "args": ["$SERVER_PATH", "--stdio"],
    "extensionToLanguage": {
      ".ahk": "autohotkey2",
      ".ahk2": "autohotkey2",
      ".ah2": "autohotkey2"
    },
    "transport": "stdio",
    "initializationOptions": {
      "locale": "en-us",
      "AutoLibInclude": "Disabled",
      "CompleteFunctionParens": true,
      "Diagnostics": {
        "ClassStaticMemberCheck": true,
        "ParamsCheck": true
      },
      "ActionWhenV1IsDetected": "Warn",
      "Warn": {
        "VarUnset": true,
        "LocalSameAsGlobal": true,
        "CallWithoutParentheses": true
      }
    },
    "settings": {},
    "maxRestarts": 3
  }
}
EOF

echo "✓ Created $PROJECT_ROOT/.lsp.json"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To use the LSP in Claude Code:"
echo "  1. Set environment variable: export ENABLE_LSP_TOOL=1"
echo "  2. Restart Claude Code"
echo "  3. Open an .ahk file and use LSP operations"
echo ""
echo "Example LSP usage:"
echo "  LSP operation=documentSymbol filePath=script.ahk line=1 character=1"
echo ""
