#!/usr/bin/env python3
"""
Validate AHK v2 training samples against AGENTS.md rules.

This script checks all .ahk files in data/Scripts/ directory against
the rules defined in data/Scripts/AGENTS.md.
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Dict, Tuple


class AHKValidator:
    """Validator for AHK v2 example files."""

    def __init__(self, scripts_dir: str):
        self.scripts_dir = Path(scripts_dir)
        self.issues = []
        self.stats = {
            'total_files': 0,
            'missing_requires': 0,
            'missing_singleinstance': 0,
            'missing_description': 0,
            'problematic_names': 0,
            'bom_encoding': 0,
            'issue_references': 0,
            'converter_artifacts': 0,
        }

    def validate_all(self) -> Dict:
        """Validate all .ahk files in the scripts directory."""
        ahk_files = list(self.scripts_dir.rglob('*.ahk'))
        self.stats['total_files'] = len(ahk_files)

        for ahk_file in ahk_files:
            self.validate_file(ahk_file)

        return {
            'stats': self.stats,
            'issues': self.issues
        }

    def validate_file(self, file_path: Path):
        """Validate a single AHK file."""
        relative_path = file_path.relative_to(self.scripts_dir)

        # Check file name
        self.check_filename(file_path, relative_path)

        # Read file content
        try:
            with open(file_path, 'rb') as f:
                raw_content = f.read()

            # Check encoding
            self.check_encoding(file_path, relative_path, raw_content)

            # Decode content
            content = raw_content.decode('utf-8-sig')  # Handle BOM if present

            # Check required directives
            self.check_requires_directive(file_path, relative_path, content)
            self.check_singleinstance_directive(file_path, relative_path, content)
            self.check_description(file_path, relative_path, content)
            self.check_content_artifacts(file_path, relative_path, content)

        except Exception as e:
            self.add_issue(relative_path, 'ERROR', f'Failed to read file: {e}')

    def check_filename(self, file_path: Path, relative_path: Path):
        """Check for problematic file naming patterns."""
        filename = file_path.name

        # Check for problematic patterns
        problematic_patterns = [
            r'V1toV2',
            r'Issue[_#]?\d+',
            r'StressTest',
            r'converter',
            r'Issue_#\d+',
        ]

        for pattern in problematic_patterns:
            if re.search(pattern, filename, re.IGNORECASE):
                self.stats['problematic_names'] += 1
                self.add_issue(
                    relative_path,
                    'NAMING',
                    f'Problematic filename pattern: {pattern}'
                )

    def check_encoding(self, file_path: Path, relative_path: Path, raw_content: bytes):
        """Check file encoding (should be UTF-8 without BOM)."""
        # Check for BOM
        if raw_content.startswith(b'\xef\xbb\xbf'):
            self.stats['bom_encoding'] += 1
            self.add_issue(
                relative_path,
                'ENCODING',
                'File has UTF-8 BOM (should be UTF-8 without BOM)'
            )

    def check_requires_directive(self, file_path: Path, relative_path: Path, content: str):
        """Check for #Requires AutoHotkey v2 directive."""
        if not re.search(r'^\s*#Requires\s+AutoHotkey\s+v2', content, re.MULTILINE):
            self.stats['missing_requires'] += 1
            self.add_issue(
                relative_path,
                'REQUIRED',
                'Missing #Requires AutoHotkey v2.0 directive'
            )

    def check_singleinstance_directive(self, file_path: Path, relative_path: Path, content: str):
        """Check for #SingleInstance directive."""
        if not re.search(r'^\s*#SingleInstance', content, re.MULTILINE):
            self.stats['missing_singleinstance'] += 1
            self.add_issue(
                relative_path,
                'CONVENTION',
                'Missing #SingleInstance Force directive'
            )

    def check_description(self, file_path: Path, relative_path: Path, content: str):
        """Check for clear description at the top of the file."""
        # Get first 20 lines
        lines = content.split('\n')[:20]

        # Look for description patterns
        has_comment_description = any(
            line.strip().startswith(';') and len(line.strip()) > 5
            for line in lines
        )

        has_docblock = '/**' in content[:500] or '/*' in content[:500]

        if not (has_comment_description or has_docblock):
            self.stats['missing_description'] += 1
            self.add_issue(
                relative_path,
                'REQUIRED',
                'Missing clear description at top of file'
            )

    def check_content_artifacts(self, file_path: Path, relative_path: Path, content: str):
        """Check for converter artifacts and issue references in content."""
        # Check for issue references in comments
        if re.search(r';.*[Ii]ssue\s*#?\d+', content):
            self.stats['issue_references'] += 1
            self.add_issue(
                relative_path,
                'CONTENT',
                'Contains issue reference in comments (should be narrative)'
            )

        # Check for converter artifacts
        converter_patterns = [
            r'V1toV2',
            r'converter\s+test',
            r'conversion\s+artifact',
        ]

        for pattern in converter_patterns:
            if re.search(pattern, content, re.IGNORECASE):
                self.stats['converter_artifacts'] += 1
                self.add_issue(
                    relative_path,
                    'CONTENT',
                    f'Contains converter artifact: {pattern}'
                )
                break

    def add_issue(self, file_path: Path, severity: str, message: str):
        """Add an issue to the issues list."""
        self.issues.append({
            'file': str(file_path),
            'severity': severity,
            'message': message
        })

    def generate_report(self) -> str:
        """Generate a human-readable report."""
        report = []
        report.append("=" * 80)
        report.append("AHK v2 Training Sample Validation Report")
        report.append("=" * 80)
        report.append("")

        # Summary statistics
        report.append("SUMMARY STATISTICS")
        report.append("-" * 80)
        report.append(f"Total files scanned:              {self.stats['total_files']}")
        report.append(f"Files missing #Requires:          {self.stats['missing_requires']}")
        report.append(f"Files missing #SingleInstance:    {self.stats['missing_singleinstance']}")
        report.append(f"Files missing description:        {self.stats['missing_description']}")
        report.append(f"Files with problematic names:     {self.stats['problematic_names']}")
        report.append(f"Files with UTF-8 BOM:             {self.stats['bom_encoding']}")
        report.append(f"Files with issue references:      {self.stats['issue_references']}")
        report.append(f"Files with converter artifacts:   {self.stats['converter_artifacts']}")
        report.append("")

        # Issues by severity
        report.append("ISSUES BY SEVERITY")
        report.append("-" * 80)

        severity_counts = {}
        for issue in self.issues:
            severity = issue['severity']
            severity_counts[severity] = severity_counts.get(severity, 0) + 1

        for severity, count in sorted(severity_counts.items()):
            report.append(f"{severity:15} {count:5} issues")

        report.append("")

        # Detailed issues
        if self.issues:
            report.append("DETAILED ISSUES")
            report.append("-" * 80)

            # Group by severity
            for severity in ['ERROR', 'REQUIRED', 'CONVENTION', 'NAMING', 'CONTENT', 'ENCODING']:
                severity_issues = [i for i in self.issues if i['severity'] == severity]
                if severity_issues:
                    report.append(f"\n{severity}:")
                    for issue in severity_issues[:50]:  # Limit to first 50 per category
                        report.append(f"  {issue['file']}")
                        report.append(f"    → {issue['message']}")

                    if len(severity_issues) > 50:
                        report.append(f"  ... and {len(severity_issues) - 50} more")

        report.append("")
        report.append("=" * 80)

        return "\n".join(report)


def main():
    """Main entry point."""
    scripts_dir = Path(__file__).parent.parent / 'data' / 'Scripts'

    if not scripts_dir.exists():
        print(f"Error: Scripts directory not found: {scripts_dir}")
        sys.exit(1)

    print("Validating AHK v2 training samples...")
    print(f"Scripts directory: {scripts_dir}")
    print()

    validator = AHKValidator(scripts_dir)
    results = validator.validate_all()

    # Generate report
    report = validator.generate_report()
    print(report)

    # Save report to file
    report_file = Path(__file__).parent.parent / 'VALIDATION_REPORT.md'
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write(report)

    print(f"\nReport saved to: {report_file}")

    # Exit with error code if critical issues found
    if results['stats']['missing_requires'] > 0:
        sys.exit(1)


if __name__ == '__main__':
    main()
