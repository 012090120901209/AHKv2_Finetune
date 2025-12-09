# Validate AHK v2 scripts by compiling them with AutoHotkey's /ErrorStdOut flag.
# Usage examples:
#   pwsh tools/validate_ahk.ps1                           # validate all .ahk under data/raw_scripts
#   pwsh tools/validate_ahk.ps1 data/raw_scripts/foo.ahk  # validate a specific file
# The script prints a concise summary; nonzero exit when any file fails.

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Targets,
    [string]$AhkPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Find-AhkExe {
    param([string]$Override)

    if ($Override) {
        $resolved = Resolve-Path $Override -ErrorAction SilentlyContinue
        if (-not $resolved) {
            Write-Error "Provided AHK path not found: $Override"
        }
        return $resolved.Path
    }

    $defaultPaths = @(
        "$env:ProgramFiles\\AutoHotkey\\v2\\AutoHotkey64.exe",
        "$env:ProgramFiles\\AutoHotkey\\v2\\AutoHotkey.exe",
        "$env:ProgramFiles\\AutoHotkey\\AutoHotkey64.exe",
        "$env:ProgramFiles\\AutoHotkey\\AutoHotkey.exe"
    )

    $candidates = @()
    $cmds = @(
        (Get-Command AutoHotkey64.exe -ErrorAction SilentlyContinue),
        (Get-Command AutoHotkey.exe -ErrorAction SilentlyContinue)
    ) | Where-Object { $_ -ne $null }
    foreach ($cmd in $cmds) {
        if ($cmd -and $cmd.Source) {
            $candidates += $cmd.Source
        }
    }

    foreach ($path in $defaultPaths) {
        if (Test-Path $path) {
            $candidates += $path
        }
    }

    $candidates = $candidates | Select-Object -Unique

    if (@($candidates).Count -eq 0) {
        Write-Error "AutoHotkey v2 executable not found in PATH. Install AHK v2 and ensure AutoHotkey64.exe is reachable."
    }

    # Prefer the 64-bit binary if present.
    return @($candidates)[0]
}

function Get-TargetFiles {
    param([string[]]$Targets)

    if ($Targets -and $Targets.Count -gt 0) {
        return $Targets | ForEach-Object { Resolve-Path $_ } | ForEach-Object { $_.Path }
    }

    return Get-ChildItem -Recurse -File data/raw_scripts -Filter *.ahk |
        Select-Object -ExpandProperty FullName
}

$ahkExe = Find-AhkExe -Override $AhkPath
if (-not (Test-Path $ahkExe)) {
    Write-Error "Resolved AutoHotkey path does not exist: $ahkExe"
}
$files = Get-TargetFiles -Targets $Targets

$failures = @()

foreach ($file in $files) {
    Write-Host "Checking $file" -ForegroundColor Cyan

    $global:LASTEXITCODE = 0
    $stdout = & $ahkExe /ErrorStdOut $file 2>&1
    $exitCode = $LASTEXITCODE
    if ($null -eq $exitCode) { $exitCode = 0 }
    $stdoutText = ($stdout | Out-String).Trim()

    if ($exitCode -ne 0 -or $stdoutText) {
        $failures += [PSCustomObject]@{
            File    = $file
            ExitCode = $exitCode
            StdOut  = $stdoutText
            StdErr  = ''
        }
        Write-Warning "❌ Failed: $file"
        if ($stdoutText) { Write-Host "  Output: $stdoutText" -ForegroundColor Yellow }
    } else {
        Write-Host "✅ Passed" -ForegroundColor Green
    }
}

if ($failures.Count -gt 0) {
    Write-Host "`nSummary: $($failures.Count) file(s) failed." -ForegroundColor Red
    exit 1
}

Write-Host "`nSummary: all files passed." -ForegroundColor Green
exit 0
