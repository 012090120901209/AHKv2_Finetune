"""
Fixer service - integration with agent-harness for AI-powered fixes.
"""

import asyncio
import shutil
from pathlib import Path
from typing import Dict, Any
from datetime import datetime


class FixerService:
    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.agent_harness = project_root / "tools" / "agent-harness" / "agent.py"

    async def fix_file(self, file_path: str, level: str) -> Dict[str, Any]:
        """Run AI fixer on a file at specified level"""
        file_path = Path(file_path)

        if not file_path.exists():
            return {"success": False, "error": "File not found"}

        # Read original content
        try:
            original_content = file_path.read_text(encoding="utf-8")
        except IOError as e:
            return {"success": False, "error": f"Could not read file: {e}"}

        # Create backup
        backup_path = file_path.with_suffix(file_path.suffix + f".backup-{datetime.now().strftime('%Y%m%d-%H%M%S')}")
        shutil.copy2(file_path, backup_path)

        try:
            # Run agent-harness
            cmd = f'python "{self.agent_harness}" fix "{file_path}" --level={level}'

            process = await asyncio.create_subprocess_shell(
                cmd,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
                cwd=str(self.project_root)
            )

            stdout, stderr = await process.communicate()

            # Read new content
            try:
                new_content = file_path.read_text(encoding="utf-8")
            except IOError:
                new_content = original_content

            # Check if content changed
            changed = original_content != new_content

            return {
                "success": True,
                "changed": changed,
                "original": original_content,
                "fixed": new_content,
                "backup": str(backup_path),
                "stdout": stdout.decode("utf-8")[:2000],
                "stderr": stderr.decode("utf-8")[:2000],
                "exit_code": process.returncode
            }

        except Exception as e:
            # Restore from backup on error
            shutil.copy2(backup_path, file_path)
            return {
                "success": False,
                "error": str(e),
                "original": original_content
            }

    async def preview_fix(self, file_path: str, level: str) -> Dict[str, Any]:
        """Preview what the fixer would do without applying"""
        # For now, just run the fix and show diff
        # A more sophisticated version could use --dry-run if agent-harness supports it
        return await self.fix_file(file_path, level)

    def restore_backup(self, file_path: str, backup_path: str) -> Dict[str, Any]:
        """Restore a file from its backup"""
        try:
            shutil.copy2(backup_path, file_path)
            return {"success": True}
        except IOError as e:
            return {"success": False, "error": str(e)}
