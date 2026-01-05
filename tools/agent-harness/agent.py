"""
AHK Fixer Agent - Batch processor for fixing AHK v2 example scripts

Uses Claude API to analyze and fix scripts based on rules from AGENTS.md
and diagnostics from the THQBY LSP linter.

Usage:
    python agent.py fix path/to/script.ahk              # Fix single file
    python agent.py fix path/to/scripts --recursive     # Fix directory
    python agent.py analyze path/to/script.ahk          # Analyze only
    python agent.py report path/to/scripts --recursive  # Generate report
"""

import os
import sys
import json
import time
import argparse
import subprocess
from pathlib import Path
from dataclasses import dataclass, field, asdict
from typing import Optional
from datetime import datetime
from enum import Enum

try:
    import anthropic
except ImportError:
    anthropic = None

from rules_engine import RulesEngine


class FixLevel(Enum):
    FORMATTING = "formatting"       # Headers, whitespace, encoding only
    SYNTAX = "syntax"               # + v1→v2 syntax corrections
    SEMANTIC = "semantic"           # + comments, naming, clarity
    FULL = "full"                   # + generation/expansion of incomplete examples


@dataclass
class ScriptAnalysis:
    """Analysis results for a single script"""
    file_path: str
    original_content: str
    fixed_content: Optional[str] = None
    lsp_diagnostics: list[dict] = field(default_factory=list)
    rule_violations: list[dict] = field(default_factory=list)
    changes_made: list[str] = field(default_factory=list)
    status: str = "pending"  # pending, analyzed, fixed, failed, skipped
    error_message: Optional[str] = None
    tokens_used: int = 0
    processing_time: float = 0.0


@dataclass
class BatchReport:
    """Report for batch processing"""
    total_files: int = 0
    files_analyzed: int = 0
    files_fixed: int = 0
    files_failed: int = 0
    files_skipped: int = 0
    total_issues_found: int = 0
    total_issues_fixed: int = 0
    total_tokens_used: int = 0
    total_time: float = 0.0
    analyses: list[ScriptAnalysis] = field(default_factory=list)

    def to_dict(self) -> dict:
        return {
            "summary": {
                "total_files": self.total_files,
                "files_analyzed": self.files_analyzed,
                "files_fixed": self.files_fixed,
                "files_failed": self.files_failed,
                "files_skipped": self.files_skipped,
                "total_issues_found": self.total_issues_found,
                "total_issues_fixed": self.total_issues_fixed,
                "total_tokens_used": self.total_tokens_used,
                "total_time_seconds": round(self.total_time, 2)
            },
            "files": [asdict(a) for a in self.analyses]
        }


class AHKFixerAgent:
    """Main agent for analyzing and fixing AHK v2 scripts"""

    def __init__(
        self,
        project_root: Path,
        fix_level: FixLevel = FixLevel.FULL,
        model: str = "claude-sonnet-4-20250514",
        dry_run: bool = False,
        backup: bool = True
    ):
        self.project_root = Path(project_root)
        self.fix_level = fix_level
        self.model = model
        self.dry_run = dry_run
        self.backup = backup

        # Initialize components
        self.rules_engine = RulesEngine(project_root)
        self.rules_engine.load_all_rules()

        # Claude client
        self.client = None
        if anthropic:
            api_key = os.environ.get("ANTHROPIC_API_KEY")
            if api_key:
                self.client = anthropic.Anthropic(api_key=api_key)

        # LSP linter path
        self.linter_path = project_root / "tools" / "ahk-linter"

        # Backup directory
        self.backup_dir = project_root / "backup" / datetime.now().strftime("%Y%m%d_%H%M%S")

    def run_lsp_linter(self, file_path: Path) -> list[dict]:
        """Run the LSP linter and get diagnostics"""
        # For now, use the quick validation since LSP requires Node.js setup
        # In production, this would call the Node.js linter CLI
        try:
            content = file_path.read_text(encoding='utf-8')
            return self.rules_engine.validate_script_quick(content)
        except Exception as e:
            return [{"message": str(e), "severity": "error", "line": 1}]

    def _build_system_prompt(self) -> str:
        """Build the system prompt for Claude"""
        base_prompt = self.rules_engine.generate_system_prompt()

        level_instructions = {
            FixLevel.FORMATTING: """
Focus ONLY on:
- Adding/fixing #Requires AutoHotkey v2.0 header
- Adding #SingleInstance Force if missing
- Ensuring clear description comment at top
- Fixing file encoding issues
- Removing trailing whitespace

Do NOT change:
- Variable or function names
- Code logic or structure
- Comment content beyond the header
""",
            FixLevel.SYNTAX: """
Focus on:
- All formatting fixes
- Converting any v1 syntax to v2 (MsgBox, -> MsgBox(), etc.)
- Fixing function call syntax (adding parentheses)
- Correcting := vs = assignment usage
- Fixing GUI syntax to v2 object style

Do NOT change:
- Variable or function names (unless clearly wrong)
- Overall code structure
- Comment content beyond corrections
""",
            FixLevel.SEMANTIC: """
Focus on:
- All formatting and syntax fixes
- Improving unclear variable/function names
- Enhancing comments for educational value
- Removing hardcoded paths or credentials
- Removing conversion artifacts (V1toV2, Issue #, etc.)
- Making code more idiomatic for v2
""",
            FixLevel.FULL: """
Apply all fixes:
- Formatting, syntax, and semantic improvements
- Expand incomplete or truncated examples
- Add missing error handling where appropriate
- Improve code structure for clarity
- Ensure the example is genuinely educational
- Make the example a good training sample for fine-tuning
"""
        }

        return f"""{base_prompt}

## Fix Level: {self.fix_level.value}

{level_instructions[self.fix_level]}

## Response Format

Respond with a JSON object containing:
{{
    "issues_found": [
        {{"rule_id": "string", "description": "string", "line": number}}
    ],
    "fixed_script": "string (the complete corrected script)",
    "changes_made": ["list of changes made"],
    "needs_review": boolean,
    "review_notes": "string (if needs_review is true)"
}}

IMPORTANT: Return ONLY valid JSON. No markdown code blocks or explanations outside the JSON.
"""

    def analyze_script(self, file_path: Path) -> ScriptAnalysis:
        """Analyze a single script and optionally fix it"""
        start_time = time.time()
        analysis = ScriptAnalysis(
            file_path=str(file_path),
            original_content=""
        )

        try:
            # Read the file
            content = file_path.read_text(encoding='utf-8')
            analysis.original_content = content

            # Run quick validation
            analysis.rule_violations = self.rules_engine.validate_script_quick(content)

            # Get LSP diagnostics (when available)
            analysis.lsp_diagnostics = self.run_lsp_linter(file_path)

            # If no issues found, skip
            total_issues = len(analysis.rule_violations) + len(analysis.lsp_diagnostics)
            if total_issues == 0:
                analysis.status = "skipped"
                analysis.processing_time = time.time() - start_time
                return analysis

            analysis.status = "analyzed"

            # If we have a Claude client, get AI-powered fixes
            if self.client:
                analysis = self._get_ai_fix(analysis)

        except Exception as e:
            analysis.status = "failed"
            analysis.error_message = str(e)

        analysis.processing_time = time.time() - start_time
        return analysis

    def _get_ai_fix(self, analysis: ScriptAnalysis) -> ScriptAnalysis:
        """Use Claude to fix the script"""
        if not self.client:
            return analysis

        try:
            # Build the prompt
            user_prompt = self.rules_engine.generate_fix_prompt(
                analysis.original_content,
                analysis.lsp_diagnostics + analysis.rule_violations
            )

            # Call Claude
            response = self.client.messages.create(
                model=self.model,
                max_tokens=4096,
                system=self._build_system_prompt(),
                messages=[{"role": "user", "content": user_prompt}]
            )

            # Parse response
            response_text = response.content[0].text
            analysis.tokens_used = response.usage.input_tokens + response.usage.output_tokens

            # Try to parse as JSON
            try:
                # Handle potential markdown code blocks
                if "```json" in response_text:
                    response_text = response_text.split("```json")[1].split("```")[0]
                elif "```" in response_text:
                    response_text = response_text.split("```")[1].split("```")[0]

                result = json.loads(response_text.strip())
                analysis.fixed_content = result.get("fixed_script", "")
                analysis.changes_made = result.get("changes_made", [])
                analysis.status = "fixed" if analysis.fixed_content else "analyzed"

            except json.JSONDecodeError:
                # If not valid JSON, try to extract the script
                if "#Requires AutoHotkey" in response_text:
                    # Looks like raw script content
                    analysis.fixed_content = response_text
                    analysis.changes_made = ["AI provided fixed script (raw format)"]
                    analysis.status = "fixed"
                else:
                    analysis.error_message = "Failed to parse AI response as JSON"
                    analysis.status = "failed"

        except Exception as e:
            analysis.error_message = f"AI fix failed: {str(e)}"
            analysis.status = "failed"

        return analysis

    def apply_fix(self, analysis: ScriptAnalysis) -> bool:
        """Apply the fix to the file"""
        if analysis.status != "fixed" or not analysis.fixed_content:
            return False

        if self.dry_run:
            return True

        file_path = Path(analysis.file_path)

        try:
            # Create backup
            if self.backup:
                self.backup_dir.mkdir(parents=True, exist_ok=True)
                backup_path = self.backup_dir / file_path.name
                backup_path.write_text(analysis.original_content, encoding='utf-8')

            # Write fixed content
            file_path.write_text(analysis.fixed_content, encoding='utf-8')
            return True

        except Exception as e:
            analysis.error_message = f"Failed to write file: {str(e)}"
            analysis.status = "failed"
            return False

    def process_batch(
        self,
        paths: list[Path],
        recursive: bool = False,
        apply_fixes: bool = False
    ) -> BatchReport:
        """Process multiple files or directories"""
        report = BatchReport()
        start_time = time.time()

        # Collect all .ahk files
        all_files: list[Path] = []
        for p in paths:
            path = Path(p)
            if path.is_dir():
                pattern = "**/*.ahk" if recursive else "*.ahk"
                all_files.extend(path.glob(pattern))
            elif path.suffix.lower() == ".ahk":
                all_files.append(path)

        report.total_files = len(all_files)
        print(f"Processing {report.total_files} files...")

        for i, file_path in enumerate(all_files):
            print(f"  [{i+1}/{report.total_files}] {file_path.name}...", end=" ", flush=True)

            analysis = self.analyze_script(file_path)
            report.analyses.append(analysis)

            if analysis.status == "skipped":
                report.files_skipped += 1
                print("OK (no issues)")
            elif analysis.status == "failed":
                report.files_failed += 1
                print(f"FAILED: {analysis.error_message}")
            elif analysis.status == "fixed" and apply_fixes:
                if self.apply_fix(analysis):
                    report.files_fixed += 1
                    print(f"FIXED ({len(analysis.changes_made)} changes)")
                else:
                    report.files_failed += 1
                    print(f"FAILED to apply fix")
            else:
                report.files_analyzed += 1
                issues = len(analysis.rule_violations) + len(analysis.lsp_diagnostics)
                print(f"ANALYZED ({issues} issues)")

            report.total_issues_found += len(analysis.rule_violations) + len(analysis.lsp_diagnostics)
            report.total_tokens_used += analysis.tokens_used

        report.total_time = time.time() - start_time
        return report


def main():
    parser = argparse.ArgumentParser(
        description="AHK Fixer Agent - Fix AHK v2 example scripts using AI"
    )
    parser.add_argument(
        "command",
        choices=["fix", "analyze", "report", "validate"],
        help="Command to run"
    )
    parser.add_argument(
        "paths",
        nargs="+",
        help="Files or directories to process"
    )
    parser.add_argument(
        "--recursive", "-r",
        action="store_true",
        help="Process directories recursively"
    )
    parser.add_argument(
        "--level",
        choices=["formatting", "syntax", "semantic", "full"],
        default="full",
        help="Fix level (default: full)"
    )
    parser.add_argument(
        "--model",
        default="claude-sonnet-4-20250514",
        help="Claude model to use"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Don't actually modify files"
    )
    parser.add_argument(
        "--no-backup",
        action="store_true",
        help="Don't create backups"
    )
    parser.add_argument(
        "--output", "-o",
        help="Output report file (JSON)"
    )

    args = parser.parse_args()

    # Find project root
    project_root = Path(__file__).parent.parent.parent

    # Create agent
    agent = AHKFixerAgent(
        project_root=project_root,
        fix_level=FixLevel(args.level),
        model=args.model,
        dry_run=args.dry_run,
        backup=not args.no_backup
    )

    # Check for API key
    if args.command in ["fix", "analyze"] and not agent.client:
        print("Warning: ANTHROPIC_API_KEY not set. AI-powered fixes disabled.")
        print("Install anthropic: pip install anthropic")
        print("Set key: export ANTHROPIC_API_KEY=your-key")
        print()

    # Process files
    paths = [Path(p) for p in args.paths]
    apply_fixes = args.command == "fix"

    if args.command == "validate":
        # Quick validation only (no AI)
        for path in paths:
            if path.is_file():
                content = path.read_text(encoding='utf-8')
                issues = agent.rules_engine.validate_script_quick(content)
                print(f"\n{path}:")
                if issues:
                    for issue in issues:
                        print(f"  [{issue.get('severity', 'error')}] Line {issue.get('line', '?')}: {issue.get('message', 'Unknown')}")
                else:
                    print("  No issues found")
        return

    report = agent.process_batch(paths, args.recursive, apply_fixes)

    # Print summary
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Total files:     {report.total_files}")
    print(f"Files analyzed:  {report.files_analyzed}")
    print(f"Files fixed:     {report.files_fixed}")
    print(f"Files skipped:   {report.files_skipped}")
    print(f"Files failed:    {report.files_failed}")
    print(f"Total issues:    {report.total_issues_found}")
    print(f"Tokens used:     {report.total_tokens_used}")
    print(f"Time elapsed:    {report.total_time:.2f}s")

    # Save report
    if args.output:
        output_path = Path(args.output)
        output_path.write_text(json.dumps(report.to_dict(), indent=2), encoding='utf-8')
        print(f"\nReport saved to: {output_path}")


if __name__ == "__main__":
    main()
