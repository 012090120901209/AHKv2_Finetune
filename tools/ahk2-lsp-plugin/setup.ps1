# AHK2 LSP Plugin Setup Script (PowerShell)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)
$LspDir = Join-Path $ProjectRoot "vscode-autohotkey2-lsp"

Write-Host "=== AHK2 LSP Plugin Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Node.js not found. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check LSP directory
if (-not (Test-Path $LspDir)) {
    Write-Host "ERROR: LSP directory not found at $LspDir" -ForegroundColor Red
    exit 1
}
Write-Host "✓ LSP directory found" -ForegroundColor Green

# Install dependencies
Write-Host ""
Write-Host "Installing LSP dependencies..." -ForegroundColor Yellow
Push-Location $LspDir
npm install
Pop-Location

# Build LSP
Write-Host ""
Write-Host "Building LSP server..." -ForegroundColor Yellow
Push-Location $LspDir
node esbuild.mjs
Pop-Location

# Verify build
$ServerPath = Join-Path $LspDir "server\dist\server.js"
if (-not (Test-Path $ServerPath)) {
    Write-Host "ERROR: Build failed - server.js not found" -ForegroundColor Red
    exit 1
}
Write-Host "✓ LSP server built successfully" -ForegroundColor Green

# Create .lsp.json
Write-Host ""
Write-Host "Creating .lsp.json configuration..." -ForegroundColor Yellow

$LspConfig = @{
    autohotkey2 = @{
        command = "node"
        args = @($ServerPath.Replace('\', '/'), "--stdio")
        extensionToLanguage = @{
            ".ahk" = "autohotkey2"
            ".ahk2" = "autohotkey2"
            ".ah2" = "autohotkey2"
        }
        transport = "stdio"
        initializationOptions = @{
            locale = "en-us"
            AutoLibInclude = "Disabled"
            CompleteFunctionParens = $true
            Diagnostics = @{
                ClassStaticMemberCheck = $true
                ParamsCheck = $true
            }
            ActionWhenV1IsDetected = "Warn"
            Warn = @{
                VarUnset = $true
                LocalSameAsGlobal = $true
                CallWithoutParentheses = $true
            }
        }
        settings = @{}
        maxRestarts = 3
    }
}

$LspJsonPath = Join-Path $ProjectRoot ".lsp.json"
$LspConfig | ConvertTo-Json -Depth 10 | Set-Content $LspJsonPath -Encoding UTF8

Write-Host "✓ Created $LspJsonPath" -ForegroundColor Green

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "To use the LSP in Claude Code:" -ForegroundColor White
Write-Host "  1. Set environment variable: `$env:ENABLE_LSP_TOOL=1" -ForegroundColor Gray
Write-Host "  2. Restart Claude Code" -ForegroundColor Gray
Write-Host "  3. Open an .ahk file and use LSP operations" -ForegroundColor Gray
Write-Host ""
Write-Host "Example LSP usage:" -ForegroundColor White
Write-Host "  LSP operation=documentSymbol filePath=script.ahk line=1 character=1" -ForegroundColor Gray
Write-Host ""
