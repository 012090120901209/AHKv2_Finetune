"""Utility for normalising AutoHotkey v2 snippets prior to dataset export.

Designed to strip conversion artefacts (e.g., `V1toV2_*` identifiers) and
rewrite comment text so examples read like production-quality automation
recipes. The tool supports a dry-run mode and produces a structured report so
changes can be reviewed before committing.

Example usage:

    python -m scripts.normalize_snippets \
        --root data/raw_scripts \
        --pattern "V1toV2_GblCode_001=GlobalInitBlock" \
        --pattern "Issue #=Legacy bug" \
        --dry-run

"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Iterator, Sequence


DEFAULT_PATTERNS: Sequence[tuple[str, str]] = (
    # Common converter artefacts → meaningful identifiers.
    (r"V1toV2_GblCode_001", "GlobalInitBlock"),
    (r"V1toV2_GblCode_002", "GlobalInitBlock2"),
    (r"HotkeyStressTest", "HotkeyDemo"),
    # Comment clean-up.
    (r"converter stress test", "Demonstration"),
    (r"Issue #(\d+)", r"Legacy issue reference (Issue #\g<1>)"),
)


@dataclass
class Replacement:
    pattern: re.Pattern[str]
    replacement: str


@dataclass
class EditRecord:
    path: str
    replacements: list[str]


def compile_replacements(pairs: Sequence[tuple[str, str]]) -> list[Replacement]:
    compiled = []
    for source, target in pairs:
        compiled.append(Replacement(pattern=re.compile(source), replacement=target))
    return compiled


def apply_replacements(text: str, replacements: Sequence[Replacement]) -> tuple[str, list[str]]:
    edits: list[str] = []
    updated = text
    for repl in replacements:
        new_text, count = repl.pattern.subn(repl.replacement, updated)
        if count:
            edits.append(f"{repl.pattern.pattern!r} -> {repl.replacement!r} ({count}x)")
            updated = new_text
    return updated, edits


def iter_files(root: Path) -> Iterator[Path]:
    for path in sorted(root.rglob("*.ah2")):
        if path.is_file():
            yield path


def load_patterns(args: argparse.Namespace) -> list[Replacement]:
    pairs: list[tuple[str, str]] = list(DEFAULT_PATTERNS)
    for pair in args.pattern:
        if "=" not in pair:
            raise ValueError(f"Invalid pattern specification: {pair!r}")
        lhs, rhs = pair.split("=", 1)
        pairs.append((lhs.strip(), rhs.strip()))
    return compile_replacements(pairs)


def render_report(edits: Iterable[EditRecord]) -> str:
    structured = [edit.__dict__ for edit in edits if edit.replacements]
    return json.dumps(structured, indent=2, ensure_ascii=False)


def process_file(path: Path, replacements: Sequence[Replacement], dry_run: bool) -> EditRecord:
    original = path.read_text(encoding="utf-8")
    updated, notes = apply_replacements(original, replacements)
    if notes and not dry_run:
        path.write_text(updated, encoding="utf-8")
    return EditRecord(path=path.as_posix(), replacements=notes)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Normalize raw AutoHotkey snippets.")
    parser.add_argument("--root", type=Path, default=Path("data/raw_scripts"), help="Root directory to scan.")
    parser.add_argument(
        "--pattern",
        action="append",
        default=[],
        help="Additional search/replace pairs in the form 'regex=replacement'.",
    )
    parser.add_argument("--dry-run", action="store_true", help="Preview changes without writing files.")
    parser.add_argument("--report", type=Path, help="Optional path to write JSON report of edits.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    replacements = load_patterns(args)

    root = args.root
    if not root.exists():
        raise FileNotFoundError(f"Root directory not found: {root}")

    edits: list[EditRecord] = []
    for path in iter_files(root):
        record = process_file(path, replacements, dry_run=args.dry_run)
        if record.replacements:
            print(f"[+] {path}:")
            for note in record.replacements:
                print(f"    - {note}")
        edits.append(record)

    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(render_report(edits), encoding="utf-8")
        print(f"Wrote report to {args.report}")

    if args.dry_run:
        print("Dry run complete; no files written.")
    else:
        print("Normalization complete.")


if __name__ == "__main__":
    main()

