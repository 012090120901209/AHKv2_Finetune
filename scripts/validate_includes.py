#!/usr/bin/env python3
"""Validate #Include references in AutoHotkey v2 files.

This script scans all .ahk files for #Include directives and checks if the
referenced files exist. It reports broken references and statistics.

Usage:
    python scripts/validate_includes.py [--root data/raw_scripts]
    python scripts/validate_includes.py --fix  # Auto-comment broken includes
"""

import argparse
import re
from pathlib import Path
from typing import Iterator, NamedTuple, List
from dataclasses import dataclass


@dataclass
class IncludeReference:
    """Represents an #Include directive in a file."""
    source_file: Path
    line_number: int
    line_content: str
    include_path: str
    is_library: bool  # True if #Include <library>, False if #Include "file"


@dataclass
class ValidationResult:
    """Results of validating an #Include reference."""
    reference: IncludeReference
    exists: bool
    resolved_path: Path | None
    error_message: str | None = None


# Regex patterns for #Include directives
INCLUDE_PATTERN = re.compile(
    r'^\s*#Include\s+(?:'
    r'<([^>]+)>|'  # Library include: <name>
    r'"([^"]+)"|'  # Quoted include: "path"
    r"'([^']+)'|"  # Single-quoted: 'path'
    r'([^\s;]+)'   # Unquoted: path
    r')',
    re.IGNORECASE
)


def find_ahk_files(root: Path) -> Iterator[Path]:
    """Find all .ahk files in the given root directory."""
    for path in sorted(root.rglob("*.ahk")):
        if path.is_file():
            yield path


def extract_includes(file_path: Path) -> List[IncludeReference]:
    """Extract all #Include directives from a file."""
    includes = []

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, start=1):
                match = INCLUDE_PATTERN.match(line)
                if match:
                    # Extract the include path from whichever group matched
                    groups = match.groups()
                    include_path = next((g for g in groups if g), None)

                    if include_path:
                        is_library = groups[0] is not None  # First group is <library>
                        includes.append(IncludeReference(
                            source_file=file_path,
                            line_number=line_num,
                            line_content=line.rstrip(),
                            include_path=include_path,
                            is_library=is_library
                        ))
    except (UnicodeDecodeError, PermissionError) as e:
        print(f"Warning: Could not read {file_path}: {e}")

    return includes


def resolve_include_path(ref: IncludeReference, root: Path) -> Path | None:
    """Resolve an #Include path to an actual file path.

    Resolution rules:
    - Library includes (<name>) look for /Lib/<name>.ahk relative to script or A_MyDocuments
    - Relative includes are resolved relative to the source file's directory
    - Absolute paths are used as-is
    """
    include_path = ref.include_path

    if ref.is_library:
        # Library includes: check in Lib subdirectory
        lib_candidates = [
            ref.source_file.parent / "Lib" / f"{include_path}.ahk",
            ref.source_file.parent / "Lib" / include_path,
            root / "Lib" / f"{include_path}.ahk",
            root / "Lib" / include_path,
        ]

        for candidate in lib_candidates:
            if candidate.exists():
                return candidate
        return None

    else:
        # Regular file includes
        # Try relative to source file first
        relative_to_source = ref.source_file.parent / include_path
        if relative_to_source.exists():
            return relative_to_source

        # Try relative to root
        relative_to_root = root / include_path
        if relative_to_root.exists():
            return relative_to_root

        # Try as absolute path
        absolute = Path(include_path)
        if absolute.is_absolute() and absolute.exists():
            return absolute

        return None


def validate_include(ref: IncludeReference, root: Path) -> ValidationResult:
    """Validate a single #Include reference."""
    resolved = resolve_include_path(ref, root)

    if resolved:
        return ValidationResult(
            reference=ref,
            exists=True,
            resolved_path=resolved
        )
    else:
        error_msg = f"Cannot find included file: {ref.include_path}"
        if ref.is_library:
            error_msg += " (library include - expected in Lib/ subdirectory)"

        return ValidationResult(
            reference=ref,
            exists=False,
            resolved_path=None,
            error_message=error_msg
        )


def format_validation_report(results: List[ValidationResult]) -> str:
    """Format validation results into a human-readable report."""
    total = len(results)
    broken = [r for r in results if not r.exists]
    valid = [r for r in results if r.exists]

    report = []
    report.append("=" * 80)
    report.append("AutoHotkey #Include Validation Report")
    report.append("=" * 80)
    report.append("")
    report.append(f"Total #Include directives found: {total}")
    report.append(f"Valid references: {len(valid)} ({len(valid)*100//total if total else 0}%)")
    report.append(f"Broken references: {len(broken)} ({len(broken)*100//total if total else 0}%)")
    report.append("")

    if broken:
        report.append("-" * 80)
        report.append("BROKEN REFERENCES:")
        report.append("-" * 80)

        # Group by source file
        by_file = {}
        for result in broken:
            file_path = result.reference.source_file
            if file_path not in by_file:
                by_file[file_path] = []
            by_file[file_path].append(result)

        for file_path, file_results in sorted(by_file.items()):
            report.append("")
            report.append(f"File: {file_path}")
            for result in file_results:
                ref = result.reference
                report.append(f"  Line {ref.line_number}: {ref.line_content}")
                report.append(f"    → {result.error_message}")

    else:
        report.append("✓ All #Include references are valid!")

    report.append("")
    report.append("=" * 80)

    return "\n".join(report)


def fix_broken_includes(results: List[ValidationResult], dry_run: bool = False) -> int:
    """Comment out broken #Include directives.

    Returns the number of files modified.
    """
    broken = [r for r in results if not r.exists]
    if not broken:
        return 0

    # Group by file
    by_file = {}
    for result in broken:
        file_path = result.reference.source_file
        if file_path not in by_file:
            by_file[file_path] = []
        by_file[file_path].append(result)

    files_modified = 0

    for file_path, file_results in by_file.items():
        # Read the file
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()

            # Comment out broken includes
            broken_lines = {r.reference.line_number for r in file_results}
            modified = False

            for i in range(len(lines)):
                line_num = i + 1
                if line_num in broken_lines:
                    # Comment out the line if not already commented
                    if not lines[i].lstrip().startswith(';'):
                        lines[i] = f"; [BROKEN INCLUDE] {lines[i]}"
                        modified = True

            # Write back if modified
            if modified:
                if dry_run:
                    print(f"Would modify: {file_path}")
                else:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.writelines(lines)
                    print(f"Fixed: {file_path}")
                files_modified += 1

        except Exception as e:
            print(f"Error processing {file_path}: {e}")

    return files_modified


def main():
    parser = argparse.ArgumentParser(
        description="Validate #Include references in AutoHotkey v2 files"
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path("data/raw_scripts"),
        help="Root directory to scan (default: data/raw_scripts)"
    )
    parser.add_argument(
        "--fix",
        action="store_true",
        help="Comment out broken #Include directives"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be fixed without modifying files"
    )
    parser.add_argument(
        "--report",
        type=Path,
        help="Write report to file instead of stdout"
    )

    args = parser.parse_args()

    if not args.root.exists():
        print(f"Error: Root directory not found: {args.root}")
        return 1

    print(f"Scanning {args.root} for .ahk files...")

    # Find all .ahk files
    ahk_files = list(find_ahk_files(args.root))
    print(f"Found {len(ahk_files)} .ahk files")

    # Extract all #Include directives
    all_includes = []
    for file_path in ahk_files:
        includes = extract_includes(file_path)
        all_includes.extend(includes)

    print(f"Found {len(all_includes)} #Include directives")

    # Validate all includes
    print("Validating references...")
    results = []
    for include_ref in all_includes:
        result = validate_include(include_ref, args.root)
        results.append(result)

    # Generate report
    report = format_validation_report(results)

    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(report, encoding='utf-8')
        print(f"Report written to: {args.report}")
    else:
        print(report)

    # Fix broken includes if requested
    if args.fix or args.dry_run:
        print("\nFixing broken includes...")
        files_modified = fix_broken_includes(results, dry_run=args.dry_run)

        if args.dry_run:
            print(f"\nDry run: Would modify {files_modified} files")
        else:
            print(f"\nModified {files_modified} files")

    # Return exit code based on validation results
    broken_count = sum(1 for r in results if not r.exists)
    return 0 if broken_count == 0 else 1


if __name__ == "__main__":
    exit(main())
