#!/usr/bin/env python3
"""
AHK Training Data Web Reviewer
FastAPI server for reviewing and curating AHK v2 training scripts.
"""

import asyncio
import subprocess
import os
from pathlib import Path
from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import Optional
import uvicorn

from services.scripts import ScriptService
from services.linter import LinterService
from services.fixer import FixerService

# Paths
BASE_DIR = Path(__file__).parent
PROJECT_ROOT = BASE_DIR.parent.parent
SCRIPTS_DIR = PROJECT_ROOT / "data" / "Scripts"
REVIEW_STATUS_FILE = PROJECT_ROOT / "data" / "review_status.json"

# AHK v2 executable paths (Windows)
AHK_PATHS = [
    Path(r"C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"),
    Path(r"C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe"),
    Path(r"C:\Program Files\AutoHotkey\AutoHotkey64.exe"),
    Path(r"C:\Program Files\AutoHotkey\AutoHotkey32.exe"),
    Path(os.environ.get("AHK_PATH", "")) if os.environ.get("AHK_PATH") else None,
]

def find_ahk_exe() -> Optional[Path]:
    """Find the AHK v2 executable"""
    for path in AHK_PATHS:
        if path and path.exists():
            return path
    return None

# Initialize FastAPI
app = FastAPI(title="AHK Training Reviewer")
app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")
templates = Jinja2Templates(directory=BASE_DIR / "templates")

# Initialize services
script_service = ScriptService(SCRIPTS_DIR, REVIEW_STATUS_FILE)
linter_service = LinterService(PROJECT_ROOT)
fixer_service = FixerService(PROJECT_ROOT)


# --- Models ---

class ReviewStatus(BaseModel):
    status: str  # approved, needs_fix, rejected, reviewed_ok, skip

class FixRequest(BaseModel):
    level: str  # formatting, syntax, semantic, full

class ScriptUpdate(BaseModel):
    content: str


# --- Routes ---

@app.get("/", response_class=HTMLResponse)
async def index(request: Request):
    """Main page"""
    return templates.TemplateResponse("index.html", {"request": request})


@app.get("/api/scripts")
async def get_scripts(
    category: Optional[str] = None,
    status: Optional[str] = None,
    quality: Optional[str] = None
):
    """Get list of scripts with optional filters"""
    scripts = script_service.get_scripts(category=category, status=status, quality=quality)
    return {"scripts": scripts, "total": len(scripts)}


@app.get("/api/script-content/{script_id:path}")
async def get_script_content(script_id: str):
    """Get script source code"""
    content = script_service.get_script_content(script_id)
    if content is None:
        raise HTTPException(status_code=404, detail="Script not found")
    return {"content": content}


@app.put("/api/script-content/{script_id:path}")
async def update_script_content(script_id: str, update: ScriptUpdate):
    """Update script source code"""
    success = script_service.update_script_content(script_id, update.content)
    if not success:
        raise HTTPException(status_code=404, detail="Script not found")
    return {"success": True}


@app.post("/api/script-status/{script_id:path}")
async def set_review_status(script_id: str, review: ReviewStatus):
    """Set review status for a script"""
    valid_statuses = ["approved", "needs_fix", "rejected", "reviewed_ok", "skip"]
    if review.status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of: {valid_statuses}")

    script_service.set_status(script_id, review.status)
    return {"success": True, "status": review.status}


@app.post("/api/script-lint/{script_id:path}")
async def lint_script(script_id: str):
    """Run linter on a script"""
    script = script_service.get_script(script_id)
    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    result = await linter_service.lint_file(script["absolute_path"])

    # Update script quality based on lint results
    script_service.update_quality(script_id, result)

    return result


@app.post("/api/script-fix/{script_id:path}")
async def fix_script(script_id: str, fix_request: FixRequest):
    """Run AI fixer on a script"""
    script = script_service.get_script(script_id)
    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    valid_levels = ["formatting", "syntax", "semantic", "full"]
    if fix_request.level not in valid_levels:
        raise HTTPException(status_code=400, detail=f"Invalid level. Must be one of: {valid_levels}")

    result = await fixer_service.fix_file(script["absolute_path"], fix_request.level)
    return result


@app.post("/api/script-run/{script_id:path}")
async def run_script(script_id: str):
    """Run script with local AHK v2"""
    script = script_service.get_script(script_id)
    if not script:
        raise HTTPException(status_code=404, detail="Script not found")

    ahk_exe = find_ahk_exe()
    if not ahk_exe:
        raise HTTPException(
            status_code=500,
            detail="AutoHotkey v2 not found. Set AHK_PATH environment variable or install to default location."
        )

    script_path = script["absolute_path"]

    try:
        # Run the script (non-blocking, just launch it)
        # Use subprocess.Popen to launch without waiting
        process = subprocess.Popen(
            [str(ahk_exe), script_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if os.name == 'nt' else 0
        )
        return {
            "success": True,
            "message": f"Script launched with PID {process.pid}",
            "pid": process.pid,
            "ahk_exe": str(ahk_exe)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to run script: {str(e)}")


@app.get("/api/scripts/{script_id:path}")
async def get_script(script_id: str):
    """Get single script with full details"""
    script = script_service.get_script(script_id)
    if not script:
        raise HTTPException(status_code=404, detail="Script not found")
    return script


@app.get("/api/categories")
async def get_categories():
    """Get list of categories with counts"""
    return {"categories": script_service.get_categories()}


@app.get("/api/stats")
async def get_stats():
    """Get overall statistics"""
    return script_service.get_stats()


# --- Main ---

if __name__ == "__main__":
    print(f"Starting AHK Training Reviewer...")
    print(f"Scripts directory: {SCRIPTS_DIR}")
    print(f"Open http://localhost:8000 in your browser")
    uvicorn.run(app, host="0.0.0.0", port=8000)
