@echo off
REM AHK Agent Harness - Windows wrapper

set SCRIPT_DIR=%~dp0
set AGENT_DIR=%SCRIPT_DIR%tools\agent-harness

REM Try python, then python3
where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    python "%AGENT_DIR%\agent.py" %*
    exit /b %ERRORLEVEL%
)

where python3 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    python3 "%AGENT_DIR%\agent.py" %*
    exit /b %ERRORLEVEL%
)

echo Error: Python not found
exit /b 1
