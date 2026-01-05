"""
Linter service - integration with ahk-linter.
"""

import asyncio
import json
from pathlib import Path
from typing import Dict, Any


class LinterService:
    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.linter_dir = project_root / "tools" / "ahk-linter"

    async def lint_file(self, file_path: str) -> Dict[str, Any]:
        """Run linter on a single file"""
        try:
            # Run the linter via npx
            cmd = f'npx ts-node index.ts lint path="{file_path}" --format=json'

            process = await asyncio.create_subprocess_shell(
                cmd,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
                cwd=str(self.linter_dir)
            )

            stdout, stderr = await process.communicate()

            if process.returncode != 0:
                # Linter might still output valid JSON even with non-zero exit
                pass

            # Parse output
            output = stdout.decode("utf-8").strip()

            if not output:
                return {"errors": 0, "warnings": 0, "diagnostics": []}

            # Try to parse JSON output
            try:
                result = json.loads(output)

                # Handle different output formats
                if isinstance(result, list):
                    # Array of diagnostics
                    diagnostics = result
                elif isinstance(result, dict):
                    # Object with diagnostics array
                    diagnostics = result.get("diagnostics", result.get("results", []))
                else:
                    diagnostics = []

                # Count errors and warnings
                errors = sum(1 for d in diagnostics if d.get("severity", 1) == 1)
                warnings = sum(1 for d in diagnostics if d.get("severity", 2) == 2)

                return {
                    "errors": errors,
                    "warnings": warnings,
                    "diagnostics": diagnostics[:50]  # Limit to first 50
                }

            except json.JSONDecodeError:
                # If not JSON, try to parse text output
                lines = output.split("\n")
                errors = sum(1 for line in lines if "error" in line.lower())
                warnings = sum(1 for line in lines if "warning" in line.lower())

                return {
                    "errors": errors,
                    "warnings": warnings,
                    "diagnostics": [],
                    "raw_output": output[:2000]
                }

        except Exception as e:
            return {
                "errors": 0,
                "warnings": 0,
                "diagnostics": [],
                "error": str(e)
            }

    async def lint_files(self, file_paths: list) -> Dict[str, Dict[str, Any]]:
        """Lint multiple files"""
        results = {}
        for path in file_paths:
            results[path] = await self.lint_file(path)
        return results
