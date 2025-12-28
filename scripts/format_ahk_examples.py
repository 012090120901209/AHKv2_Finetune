#!/usr/bin/env python3
"""Audit and (optionally) format AutoHotkey v2 examples with low-context checks.

This tool is designed to quickly validate and normalize the *formatting surface*
of the example corpus without doing semantic analysis:
- UTF-8 decode / UTF-8 BOM detection
- #Requires / #SingleInstance header hygiene (pattern-based)
- Trailing whitespace + final newline

Optionally, it can run the THQBY formatter (vscode-autohotkey2-lsp) to perform
real formatting via the extension's Lexer.beautify().

Examples:
  # Fast checks only
  python scripts/format_ahk_examples.py --root data/Scripts --check

  # Apply safe text normalizations (BOM, whitespace, header ordering)
  python scripts/format_ahk_examples.py --root data/Scripts --fix

  # Format using THQBY (will clone/build into .cache unless --no-bootstrap)
  python scripts/format_ahk_examples.py --root data/Scripts --thqby --fix
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable, Iterator, Literal

import re

UTF8_BOM = b"\xef\xbb\xbf"

IS_WINDOWS = sys.platform.startswith("win")
NPM_CMD = "npm.cmd" if IS_WINDOWS else "npm"
NODE_CMD = "node.exe" if IS_WINDOWS else "node"

RE_REQUIRES_V2 = re.compile(r"^\s*#requires\s+autohotkey\s+v2", re.IGNORECASE)
RE_SINGLE_INSTANCE = re.compile(r"^\s*#singleinstance\b", re.IGNORECASE)
RE_INCLUDE = re.compile(r"^\s*#include\b", re.IGNORECASE)


Severity = Literal["error", "warning"]


@dataclass(frozen=True)
class Finding:
    path: str
    severity: Severity
    code: str
    message: str
    line: int | None = None


@dataclass(frozen=True)
class FileResult:
    path: str
    changed: bool
    findings: list[Finding]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Audit/format AutoHotkey v2 examples with lightweight checks."
    )
    parser.add_argument(
        "--root",
        type=Path,
        default=Path("data/Scripts"),
        help="Root directory to scan (default: data/Scripts).",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Check only (default unless --fix is set).",
    )
    parser.add_argument(
        "--fix",
        action="store_true",
        help="Apply safe fixes in-place (BOM, whitespace, header ordering).",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Treat warnings as errors (non-zero exit if any warning).",
    )
    parser.add_argument(
        "--thqby",
        action="store_true",
        help="Run THQBY formatter (vscode-autohotkey2-lsp) and report/apply diffs.",
    )
    parser.add_argument(
        "--thqby-strict",
        action="store_true",
        help="Fail the run if the THQBY formatter errors or returns empty output.",
    )
    parser.add_argument(
        "--no-bootstrap",
        action="store_true",
        help="Do not auto-clone/build THQBY formatter; fail if missing.",
    )
    parser.add_argument(
        "--cache-dir",
        type=Path,
        default=Path(".cache") / "thqby",
        help="Cache dir used for THQBY clone/build (default: .cache/thqby).",
    )
    parser.add_argument(
        "--indent",
        type=str,
        default="    ",
        help="Indent string for THQBY formatting (default: 4 spaces).",
    )
    parser.add_argument(
        "--line-endings",
        choices=("preserve", "lf", "crlf"),
        default="preserve",
        help="Line ending policy when writing files (default: preserve).",
    )
    parser.add_argument(
        "--json-report",
        type=Path,
        help="Optional path to write a JSON report.",
    )
    parser.add_argument(
        "--show",
        type=int,
        default=20,
        help="Max files to list per severity (default: 20, set 0 to disable).",
    )
    parser.add_argument(
        "--limit",
        type=int,
        help="Optional max number of files to process.",
    )
    return parser.parse_args()


def iter_ahk_files(root: Path) -> Iterator[Path]:
    for path in sorted(root.rglob("*.ahk")):
        # Keep tooling deterministic; skip non-files.
        if not path.is_file():
            continue
        # Avoid accidental scans of editor history snapshots.
        if any(part in {".git", ".history", ".local-history"} for part in path.parts):
            continue
        yield path


def detect_newline_policy(raw: bytes) -> str:
    if b"\r\n" in raw:
        return "\r\n"
    return "\n"


def normalize_newlines(text: str, newline: str) -> str:
    normalized = text.replace("\r\n", "\n").replace("\r", "\n")
    if newline == "\n":
        return normalized
    return normalized.replace("\n", newline)


def run_cmd(
    cmd: list[str],
    *,
    cwd: Path | None = None,
    check: bool = True,
) -> subprocess.CompletedProcess[str]:
    result = subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
    )
    if check and result.returncode != 0:
        stderr = result.stderr.strip()
        stdout = result.stdout.strip()
        details = "\n".join(
            part for part in [stdout and f"stdout:\n{stdout}", stderr and f"stderr:\n{stderr}"] if part
        )
        raise RuntimeError(f"Command failed: {' '.join(cmd)}\n{details}".strip())
    return result


def truncate_text(text: str, limit: int = 500) -> str:
    text = text.strip()
    if len(text) <= limit:
        return text
    return text[: limit - 3] + "..."


def patch_thqby_cli_ts(repo_dir: Path) -> bool:
    """Patch upstream THQBY cli.ts to handle values containing '='.

    The upstream CLI splits args with `s.split('=')`, which breaks for file paths
    containing '=' (e.g., `String_!= Conversion.ahk`). We patch the local cached
    copy in `.cache/` and rebuild the CLI bundle.
    """
    cli_ts = repo_dir / "server" / "cli" / "cli.ts"
    if not cli_ts.exists():
        return False

    text = cli_ts.read_text(encoding="utf-8", errors="replace")
    if "s.split('='')" not in text:
        return False

    lines = text.splitlines(keepends=True)
    patched = False
    for idx, line in enumerate(lines):
        if "const arr = s.split('=');" not in line:
            continue
        newline = "\r\n" if line.endswith("\r\n") else "\n"
        indent = re.match(r"^(\s*)", line).group(1) if re.match(r"^(\s*)", line) else ""
        indent2 = indent + ("    " if "\t" not in indent else "\t")
        replacement = [
            f"{indent}const eq = s.indexOf('=');{newline}",
            f"{indent}if (eq <= 0){newline}",
            f"{indent2}return;{newline}",
            f"{indent}const key = s.slice(0, eq);{newline}",
            r"{indent}const value = s.slice(eq + 1).replace(/^([\'\"])(.*)\\1$/, \'$2\');{newline}",
            f"{indent}options[key] = value;{newline}",
        ]
        # Replace the `const arr ...` line and the next `options[arr[0]] ...` line.
        end = idx + 2 if idx + 1 < len(lines) else idx + 1
        lines[idx:end] = replacement
        patched = True
        break

    if not patched:
        return False

    cli_ts.write_text("".join(lines), encoding="utf-8", newline="")
    return True


def ensure_thqby_cli(cache_dir: Path, *, allow_bootstrap: bool) -> Path:
    """Ensure THQBY CLI formatter exists; clone/build if allowed."""
    repo_dir = cache_dir / "vscode-autohotkey2-lsp"
    cli_js = repo_dir / "server" / "cli" / "cli.js"

    if not repo_dir.exists():
        if not allow_bootstrap:
            raise FileNotFoundError(
                f"THQBY formatter not found at {cli_js}. Re-run without --no-bootstrap."
            )
        cache_dir.mkdir(parents=True, exist_ok=True)
        run_cmd(
            [
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/thqby/vscode-autohotkey2-lsp",
                str(repo_dir),
            ]
        )

    needs_rebuild = patch_thqby_cli_ts(repo_dir) or not cli_js.exists()
    if not needs_rebuild:
        return cli_js

    # Install deps + build the bundled CLI into server/cli/cli.js
    # Some upstream repos ship a package-lock that isn't always npm-ci clean; fall back to npm install.
    try:
        run_cmd([NPM_CMD, "ci", "--no-audit", "--fund=false"], cwd=repo_dir)
    except RuntimeError:
        run_cmd([NPM_CMD, "install", "--no-audit", "--fund=false"], cwd=repo_dir)
    run_cmd([NPM_CMD, "run", "build-cli"], cwd=repo_dir)

    if not cli_js.exists():
        raise FileNotFoundError(f"THQBY CLI build did not produce {cli_js}")
    return cli_js


def thqby_format_file(cli_js: Path, file_path: Path, *, indent: str) -> str:
    # Pass args as a list to preserve literal spaces in indent_string.
    cli_js_abs = cli_js.resolve()
    file_abs = file_path.resolve()
    result = run_cmd(
        [NODE_CMD, str(cli_js_abs), f"path={file_abs}", f"indent_string={indent}"],
        cwd=cli_js.parent,
        check=True,
    )
    # console.log adds a trailing newline; keep it for stable diffs.
    return result.stdout or ""


def find_header_end(lines: list[str]) -> int:
    """Heuristic: header ends at first non-comment, non-directive code line."""
    in_block_comment = False
    for idx, line in enumerate(lines):
        stripped = line.lstrip()
        if in_block_comment:
            if "*/" in stripped:
                in_block_comment = False
            continue
        if not stripped:
            continue
        if stripped.startswith(";"):
            continue
        if stripped.startswith("/*"):
            in_block_comment = True
            continue
        if stripped.startswith("#"):
            continue
        return idx
    return len(lines)


def find_comment_prefix_end(lines: list[str]) -> int:
    """Return index after leading comment/blank prefix.

    Many examples start with a docblock header (/** ... */) before directives.
    Keep that prefix in-place when normalizing directive ordering.
    """
    in_block_comment = False
    for idx, line in enumerate(lines):
        stripped = line.lstrip()
        if in_block_comment:
            if "*/" in stripped:
                in_block_comment = False
            continue
        if not stripped:
            continue
        if stripped.startswith(";"):
            continue
        if stripped.startswith("/*"):
            in_block_comment = True
            continue
        return idx
    return len(lines)


def first_non_comment_line(lines: list[str]) -> str:
    idx = find_comment_prefix_end(lines)
    for line in lines[idx:]:
        if line.strip():
            return line
    return ""


def reorder_header(lines: list[str]) -> list[str]:
    header_end = find_header_end(lines)
    header = lines[:header_end]
    rest = lines[header_end:]

    prefix_end = find_comment_prefix_end(header)
    prefix = header[:prefix_end]
    reorderable = header[prefix_end:]

    requires_idx = next((i for i, l in enumerate(reorderable) if RE_REQUIRES_V2.match(l)), None)
    single_idx = next((i for i, l in enumerate(reorderable) if RE_SINGLE_INSTANCE.match(l)), None)
    include_idxs = [i for i, l in enumerate(reorderable) if RE_INCLUDE.match(l)]

    moved: set[int] = set()
    new_header: list[str] = []

    if requires_idx is not None:
        new_header.append(reorderable[requires_idx].rstrip())
        moved.add(requires_idx)
    if single_idx is not None:
        new_header.append(reorderable[single_idx].rstrip())
        moved.add(single_idx)

    for i in include_idxs:
        if i in moved:
            continue
        new_header.append(reorderable[i].rstrip())
        moved.add(i)

    for i, line in enumerate(reorderable):
        if i in moved:
            continue
        new_header.append(line.rstrip())

    # Preserve original line content for rest of file.
    return prefix + new_header + rest


def split_singleinstance_inline_hotkey(lines: list[str]) -> tuple[list[str], bool]:
    changed = False
    updated: list[str] = []
    for line in lines:
        if not RE_SINGLE_INSTANCE.match(line):
            updated.append(line)
            continue
        before_comment = line.split(";", 1)[0]
        if "::" not in before_comment:
            updated.append(line)
            continue
        idx = before_comment.find("::")
        token_start = idx
        while token_start > 0 and not before_comment[token_start - 1].isspace():
            token_start -= 1
        directive_part = before_comment[:token_start].rstrip()
        trailing = before_comment[token_start:].strip()
        comment = ""
        if ";" in line:
            comment = ";" + line.split(";", 1)[1].rstrip()
        if directive_part and trailing:
            updated.append((directive_part + (" " + comment if comment else "")).rstrip())
            updated.append(trailing)
            changed = True
        else:
            updated.append(line)
    return updated, changed


def apply_text_fixes(
    path: Path,
    *,
    line_endings: Literal["preserve", "lf", "crlf"],
) -> FileResult:
    findings: list[Finding] = []
    raw = path.read_bytes()

    newline = detect_newline_policy(raw)
    if line_endings == "lf":
        newline = "\n"
    elif line_endings == "crlf":
        newline = "\r\n"

    had_bom = raw.startswith(UTF8_BOM)
    if had_bom:
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="utf8_bom",
                message="UTF-8 BOM present (prefer UTF-8 without BOM).",
            )
        )
        raw = raw[len(UTF8_BOM) :]

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        return FileResult(
            path=str(path),
            changed=False,
            findings=[
                Finding(
                    path=str(path),
                    severity="error",
                    code="utf8_decode",
                    message=f"Cannot decode as UTF-8: {exc}",
                )
            ],
        )

    normalized = normalize_newlines(text, "\n")
    lines = normalized.split("\n")

    has_requires = any(RE_REQUIRES_V2.match(line) for line in lines)
    if not has_requires:
        findings.append(
            Finding(
                path=str(path),
                severity="error",
                code="missing_requires",
                message="Missing '#Requires AutoHotkey v2...' directive.",
            )
        )
    else:
        first_stmt = first_non_comment_line(lines)
        if first_stmt and not RE_REQUIRES_V2.match(first_stmt):
            findings.append(
                Finding(
                    path=str(path),
                    severity="warning",
                    code="requires_not_first",
                    message="First non-comment line is not '#Requires AutoHotkey v2...'.",
                )
            )

    if not any(RE_SINGLE_INSTANCE.match(line) for line in lines):
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="missing_singleinstance",
                message="Missing '#SingleInstance ...' (recommended for runnable examples).",
            )
        )

    trailing_ws_lines = [i + 1 for i, line in enumerate(lines) if line.endswith((" ", "\t"))]
    for line_no in trailing_ws_lines[:50]:
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="trailing_whitespace",
                message="Trailing whitespace.",
                line=line_no,
            )
        )
    if len(trailing_ws_lines) > 50:
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="trailing_whitespace",
                message=f"Trailing whitespace (and {len(trailing_ws_lines) - 50} more lines).",
            )
        )

    needs_final_newline = not text.endswith(("\n", "\r\n", "\r"))
    if needs_final_newline:
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="missing_final_newline",
                message="File does not end with a newline.",
            )
        )

    # Fixes
    fixed_lines = [line.rstrip(" \t") for line in lines]
    fixed_lines, split_changed = split_singleinstance_inline_hotkey(fixed_lines)
    fixed_lines = reorder_header(fixed_lines)
    fixed_text = "\n".join(fixed_lines)
    if needs_final_newline:
        fixed_text += "\n"

    fixed_text = normalize_newlines(fixed_text, newline)
    if fixed_text.endswith(newline):
        pass

    changed = had_bom or split_changed or fixed_text != normalize_newlines(text, newline)
    if changed:
        path.write_text(fixed_text, encoding="utf-8", newline="")
    return FileResult(path=str(path), changed=changed, findings=findings)


def check_only(path: Path) -> FileResult:
    raw = path.read_bytes()
    findings: list[Finding] = []

    if raw.startswith(UTF8_BOM):
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="utf8_bom",
                message="UTF-8 BOM present (prefer UTF-8 without BOM).",
            )
        )
        raw = raw[len(UTF8_BOM) :]

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        return FileResult(
            path=str(path),
            changed=False,
            findings=[
                Finding(
                    path=str(path),
                    severity="error",
                    code="utf8_decode",
                    message=f"Cannot decode as UTF-8: {exc}",
                )
            ],
        )

    lines = text.replace("\r\n", "\n").replace("\r", "\n").split("\n")

    has_requires = any(RE_REQUIRES_V2.match(line) for line in lines)
    if not has_requires:
        findings.append(
            Finding(
                path=str(path),
                severity="error",
                code="missing_requires",
                message="Missing '#Requires AutoHotkey v2...' directive.",
            )
        )
    else:
        first_stmt = first_non_comment_line(lines)
        if first_stmt and not RE_REQUIRES_V2.match(first_stmt):
            findings.append(
                Finding(
                    path=str(path),
                    severity="warning",
                    code="requires_not_first",
                    message="First non-comment line is not '#Requires AutoHotkey v2...'.",
                )
            )

    if not any(RE_SINGLE_INSTANCE.match(line) for line in lines):
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="missing_singleinstance",
                message="Missing '#SingleInstance ...' (recommended for runnable examples).",
            )
        )

    trailing_ws_lines = [i + 1 for i, line in enumerate(lines) if line.endswith((" ", "\t"))]
    for line_no in trailing_ws_lines[:50]:
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="trailing_whitespace",
                message="Trailing whitespace.",
                line=line_no,
            )
        )
    if len(trailing_ws_lines) > 50:
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="trailing_whitespace",
                message=f"Trailing whitespace (and {len(trailing_ws_lines) - 50} more lines).",
            )
        )

    if not text.endswith(("\n", "\r\n", "\r")):
        findings.append(
            Finding(
                path=str(path),
                severity="warning",
                code="missing_final_newline",
                message="File does not end with a newline.",
            )
        )

    for line_no, line in enumerate(lines, start=1):
        if not RE_SINGLE_INSTANCE.match(line):
            continue
        if "::" in line.split(";", 1)[0]:
            findings.append(
                Finding(
                    path=str(path),
                    severity="warning",
                    code="singleinstance_inline_hotkey",
                    message="Line mixes '#SingleInstance' with a hotkey/label (split onto separate lines).",
                    line=line_no,
                )
            )

    return FileResult(path=str(path), changed=False, findings=findings)


def apply_thqby(
    results: list[FileResult],
    *,
    cli_js: Path,
    fix: bool,
    indent: str,
    line_endings: Literal["preserve", "lf", "crlf"],
    strict_backend: bool,
) -> list[FileResult]:
    updated: list[FileResult] = []
    total = len(results)
    for idx, item in enumerate(results, start=1):
        path = Path(item.path)
        if not path.exists():
            updated.append(item)
            continue

        if idx == 1 or idx % 200 == 0 or idx == total:
            print(f"THQBY format pass: {idx}/{total}")

        raw = path.read_bytes()
        newline = detect_newline_policy(raw)
        if line_endings == "lf":
            newline = "\n"
        elif line_endings == "crlf":
            newline = "\r\n"

        try:
            formatted = thqby_format_file(cli_js, path, indent=indent)
        except RuntimeError as exc:
            finding = Finding(
                path=item.path,
                severity="error" if strict_backend else "warning",
                code="thqby_failed",
                message=truncate_text(str(exc)),
            )
            updated.append(
                FileResult(path=item.path, changed=item.changed, findings=[*item.findings, finding])
            )
            continue

        # Normalize formatter output (console.log adds a trailing newline).
        formatted = formatted.replace("\r\n", "\n").replace("\r", "\n")
        original = raw
        if original.startswith(UTF8_BOM):
            original = original[len(UTF8_BOM) :]
        try:
            original_text = original.decode("utf-8").replace("\r\n", "\n").replace("\r", "\n")
        except UnicodeDecodeError:
            # Already flagged by main pass.
            updated.append(item)
            continue

        if not formatted.strip() and original_text.strip():
            finding = Finding(
                path=item.path,
                severity="error" if strict_backend else "warning",
                code="thqby_empty_output",
                message="THQBY formatter returned empty output; file left unchanged.",
            )
            updated.append(
                FileResult(path=item.path, changed=item.changed, findings=[*item.findings, finding])
            )
            continue

        if formatted != original_text and formatted.rstrip("\n") != original_text.rstrip("\n"):
            finding = Finding(
                path=item.path,
                severity="warning",
                code="thqby_diff",
                message="THQBY formatter would change this file.",
            )
            findings = [*item.findings, finding]
            changed = item.changed
            if fix:
                final_text = formatted
                if not final_text.endswith("\n"):
                    final_text += "\n"
                final_text = normalize_newlines(final_text, newline)
                path.write_text(final_text, encoding="utf-8", newline="")
                changed = True
            updated.append(FileResult(path=item.path, changed=changed, findings=findings))
        else:
            updated.append(item)
    return updated


def write_json_report(path: Path, results: Iterable[FileResult]) -> None:
    payload = []
    for result in results:
        payload.append(
            {
                "path": result.path,
                "changed": result.changed,
                "findings": [asdict(f) for f in result.findings],
            }
        )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")


def main() -> None:
    args = parse_args()
    # Default to check-only unless the user explicitly asks to write changes.
    mode_check_only = not args.fix

    if not args.root.exists():
        raise FileNotFoundError(f"Root directory not found: {args.root}")

    files = list(iter_ahk_files(args.root))
    if args.limit is not None:
        files = files[: args.limit]

    results: list[FileResult] = []
    if mode_check_only:
        for path in files:
            results.append(check_only(path))
    else:
        for path in files:
            results.append(apply_text_fixes(path, line_endings=args.line_endings))

    if args.thqby:
        cli_js = ensure_thqby_cli(args.cache_dir, allow_bootstrap=not args.no_bootstrap)
        results = apply_thqby(
            results,
            cli_js=cli_js,
            fix=args.fix,
            indent=args.indent,
            line_endings=args.line_endings,
            strict_backend=args.thqby_strict,
        )

    total_findings = sum(len(r.findings) for r in results)
    changed_files = sum(1 for r in results if r.changed)
    error_findings = [
        f for r in results for f in r.findings if f.severity == "error"
    ]
    warning_findings = [
        f for r in results for f in r.findings if f.severity == "warning"
    ]

    if total_findings:
        print(f"Scanned {len(results)} files: {len(error_findings)} errors, {len(warning_findings)} warnings.")
    else:
        print(f"Scanned {len(results)} files: no findings.")

    if args.show:
        error_files = sorted({r.path for r in results if any(f.severity == "error" for f in r.findings)})
        warning_files = sorted({r.path for r in results if any(f.severity == "warning" for f in r.findings)})
        if error_files:
            print("Error files:")
            for path in error_files[: args.show]:
                print(f"  - {path}")
            if len(error_files) > args.show:
                print(f"  ... and {len(error_files) - args.show} more")
        if warning_files:
            print("Warning files:")
            for path in warning_files[: args.show]:
                print(f"  - {path}")
            if len(warning_files) > args.show:
                print(f"  ... and {len(warning_files) - args.show} more")

    if args.fix:
        print(f"Modified {changed_files} files.")

    if args.json_report:
        write_json_report(args.json_report, results)
        print(f"Wrote JSON report to {args.json_report}")

    exit_code = 0
    if error_findings:
        exit_code = 1
    elif args.strict and warning_findings:
        exit_code = 1
    sys.exit(exit_code)


if __name__ == "__main__":
    main()
