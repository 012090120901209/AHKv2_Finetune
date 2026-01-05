"""
Script management service - loading, metadata, and status tracking.
"""

import json
from pathlib import Path
from typing import Optional, Dict, List, Any
from datetime import datetime


class ScriptService:
    def __init__(self, scripts_dir: Path, status_file: Path):
        self.scripts_dir = scripts_dir
        self.status_file = status_file
        self.scripts: Dict[str, Dict[str, Any]] = {}
        self.statuses: Dict[str, str] = {}
        self.qualities: Dict[str, Dict[str, Any]] = {}
        self._load_scripts()
        self._load_statuses()

    def _load_scripts(self):
        """Load all scripts from the scripts directory"""
        self.scripts = {}

        if not self.scripts_dir.exists():
            return

        for ahk_file in self.scripts_dir.rglob("*.ahk"):
            relative_path = ahk_file.relative_to(self.scripts_dir)
            script_id = str(relative_path).replace("\\", "/")

            # Determine category from first directory level
            parts = relative_path.parts
            category = parts[0] if len(parts) > 1 else "Uncategorized"

            self.scripts[script_id] = {
                "id": script_id,
                "filename": ahk_file.name,
                "category": category,
                "relative_path": script_id,
                "absolute_path": str(ahk_file),
                "size": ahk_file.stat().st_size,
                "modified": datetime.fromtimestamp(ahk_file.stat().st_mtime).isoformat()
            }

    def _load_statuses(self):
        """Load review statuses from file"""
        if self.status_file.exists():
            try:
                with open(self.status_file, "r") as f:
                    data = json.load(f)
                    self.statuses = data.get("statuses", {})
                    self.qualities = data.get("qualities", {})
            except (json.JSONDecodeError, IOError):
                self.statuses = {}
                self.qualities = {}

    def _save_statuses(self):
        """Save review statuses to file"""
        self.status_file.parent.mkdir(parents=True, exist_ok=True)
        with open(self.status_file, "w") as f:
            json.dump({
                "statuses": self.statuses,
                "qualities": self.qualities,
                "updated": datetime.now().isoformat()
            }, f, indent=2)

    def get_scripts(
        self,
        category: Optional[str] = None,
        status: Optional[str] = None,
        quality: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """Get filtered list of scripts"""
        result = []

        for script_id, script in self.scripts.items():
            # Apply category filter
            if category and script["category"] != category:
                continue

            # Apply status filter
            script_status = self.statuses.get(script_id, "pending")
            if status and script_status != status:
                continue

            # Apply quality filter
            script_quality = self.qualities.get(script_id, {}).get("quality", "unknown")
            if quality and script_quality != quality:
                continue

            result.append({
                **script,
                "status": script_status,
                "quality": script_quality,
                "errors": self.qualities.get(script_id, {}).get("errors", 0),
                "warnings": self.qualities.get(script_id, {}).get("warnings", 0)
            })

        # Sort by category, then filename
        result.sort(key=lambda x: (x["category"], x["filename"]))
        return result

    def get_script(self, script_id: str) -> Optional[Dict[str, Any]]:
        """Get single script with full details"""
        script = self.scripts.get(script_id)
        if not script:
            return None

        script_status = self.statuses.get(script_id, "pending")
        quality_info = self.qualities.get(script_id, {})

        return {
            **script,
            "status": script_status,
            "quality": quality_info.get("quality", "unknown"),
            "errors": quality_info.get("errors", 0),
            "warnings": quality_info.get("warnings", 0),
            "lint_results": quality_info.get("lint_results", [])
        }

    def get_script_content(self, script_id: str) -> Optional[str]:
        """Get script source code"""
        script = self.scripts.get(script_id)
        if not script:
            return None

        try:
            with open(script["absolute_path"], "r", encoding="utf-8") as f:
                return f.read()
        except IOError:
            return None

    def update_script_content(self, script_id: str, content: str) -> bool:
        """Update script source code"""
        script = self.scripts.get(script_id)
        if not script:
            return False

        try:
            # Create backup
            backup_path = Path(script["absolute_path"] + ".bak")
            original = Path(script["absolute_path"]).read_text(encoding="utf-8")
            backup_path.write_text(original, encoding="utf-8")

            # Write new content
            with open(script["absolute_path"], "w", encoding="utf-8") as f:
                f.write(content)

            # Update size
            script["size"] = len(content.encode("utf-8"))
            script["modified"] = datetime.now().isoformat()

            return True
        except IOError:
            return False

    def set_status(self, script_id: str, status: str):
        """Set review status for a script"""
        self.statuses[script_id] = status
        self._save_statuses()

    def update_quality(self, script_id: str, lint_result: Dict[str, Any]):
        """Update quality info based on lint results"""
        errors = lint_result.get("errors", 0)
        warnings = lint_result.get("warnings", 0)

        if errors > 0:
            quality = "error"
        elif warnings > 0:
            quality = "warning"
        else:
            quality = "good"

        self.qualities[script_id] = {
            "quality": quality,
            "errors": errors,
            "warnings": warnings,
            "lint_results": lint_result.get("diagnostics", []),
            "linted_at": datetime.now().isoformat()
        }
        self._save_statuses()

    def get_categories(self) -> List[Dict[str, Any]]:
        """Get list of categories with counts"""
        categories: Dict[str, Dict[str, int]] = {}

        for script_id, script in self.scripts.items():
            cat = script["category"]
            if cat not in categories:
                categories[cat] = {"name": cat, "total": 0, "pending": 0, "reviewed": 0}

            categories[cat]["total"] += 1

            status = self.statuses.get(script_id, "pending")
            if status == "pending":
                categories[cat]["pending"] += 1
            else:
                categories[cat]["reviewed"] += 1

        return sorted(categories.values(), key=lambda x: x["name"])

    def get_stats(self) -> Dict[str, Any]:
        """Get overall statistics"""
        total = len(self.scripts)

        status_counts = {"pending": 0, "approved": 0, "needs_fix": 0, "rejected": 0, "reviewed_ok": 0, "skip": 0}
        for script_id in self.scripts:
            status = self.statuses.get(script_id, "pending")
            status_counts[status] = status_counts.get(status, 0) + 1

        quality_counts = {"good": 0, "warning": 0, "error": 0, "unknown": 0}
        for script_id in self.scripts:
            quality = self.qualities.get(script_id, {}).get("quality", "unknown")
            quality_counts[quality] = quality_counts.get(quality, 0) + 1

        return {
            "total": total,
            "by_status": status_counts,
            "by_quality": quality_counts,
            "reviewed": total - status_counts["pending"],
            "review_progress": round((total - status_counts["pending"]) / total * 100, 1) if total > 0 else 0
        }
