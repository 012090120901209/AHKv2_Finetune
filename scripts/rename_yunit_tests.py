"""Rename Yunit test AutoHotkey scripts to descriptive names.

This utility inspects each `Yunit_Test_*.ahk` file under
`data/raw_scripts/AHK_v2_Examples/`, extracts the primary AutoHotkey
command used in the snippet, derives a category, and proposes a
descriptive filename matching the naming conventions already present in
the repository (for example `File_FileAppend_ex1.ahk`).

Run the script with `--dry-run` (the default) to preview rename
operations. When satisfied, run again with `--apply` to perform the
renames on disk.

Usage:
    python scripts/rename_yunit_tests.py            # preview
    python scripts/rename_yunit_tests.py --apply    # rename files

"""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional


ROOT = Path(__file__).resolve().parents[1]
YUNIT_DIR = ROOT / "data" / "raw_scripts" / "AHK_v2_Examples"


LOWER_IGNORE = {
    "if",
    "else",
    "while",
    "for",
    "loop",
    "return",
    "break",
    "continue",
    "not",
    "try",
    "catch",
    "finally",
    "class",
    "switch",
    "case",
    "default",
    "method",
    "count",
    "index",
    "value",
    "var",
    "var1",
    "var2",
    "result",
    "source",
    "target",
    "text",
    "output",
    "msg",
}


TOKEN_CATEGORY_OVERRIDES: Dict[str, str] = {
    "FileAppend": "File",
    "FileRead": "File",
    "FileDelete": "File",
    "FileCopy": "File",
    "FileMove": "File",
    "FileOpen": "File",
    "FileExist": "File",
    "FileInstall": "File",
    "FileGetAttrib": "File",
    "FileGetSize": "File",
    "FileGetTime": "File",
    "FileGetVersion": "File",
    "FileCreateDir": "File",
    "FileCreateShortcut": "File",
    "FileRemoveDir": "File",
    "FileSetAttrib": "File",
    "FileSetTime": "File",
    "FileRecycle": "File",
    "FileRecycleEmpty": "File",
    "FileGetShortcut": "File",
    "FileSelectFile": "File",
    "FileSelectFolder": "File",
    "FormatTime": "DateTime",
    "DateAdd": "DateTime",
    "DateDiff": "DateTime",
    "DateParse": "DateTime",
    "MsgBox": "GUI",
    "InputBox": "GUI",
    "TrayTip": "GUI",
    "Tray_Add": "GUI",
    "Tray_Delete": "GUI",
    "Tray_Show": "GUI",
    "Menu_Add": "GUI",
    "Menu_Delete": "GUI",
    "Gui": "GUI",
    "GuiCreate": "GUI",
    "GuiAdd": "GUI",
    "GuiShow": "GUI",
    "GuiControl": "GUI",
    "GuiControlGet": "GUI",
    "GuiFromHwnd": "GUI",
    "GuiDestroy": "GUI",
    "WinExist": "Window",
    "WinActive": "Window",
    "WinWait": "Window",
    "WinWaitClose": "Window",
    "WinGetPos": "Window",
    "WinGet": "Window",
    "WinGetClass": "Window",
    "WinGetTitle": "Window",
    "ControlClick": "Window",
    "ControlSend": "Window",
    "ControlSetText": "Window",
    "ControlGetText": "Window",
    "ControlGet": "Window",
    "ControlFocus": "Window",
    "ControlHide": "Window",
    "ControlShow": "Window",
    "ControlMove": "Window",
    "ControlGetPos": "Window",
    "ControlGetSelected": "Window",
    "SoundBeep": "Sound",
    "SoundPlay": "Sound",
    "SoundGet": "Sound",
    "SoundSet": "Sound",
    "SoundGetWaveVolume": "Sound",
    "SoundSetWaveVolume": "Sound",
    "Hotkey": "Hotkey",
    "Hotstring": "Hotkey",
    "Send": "Hotkey",
    "SendEvent": "Hotkey",
    "SendInput": "Hotkey",
    "SendLevel": "Hotkey",
    "SendMode": "Hotkey",
    "SendText": "Hotkey",
    "SetTimer": "Flow",
    "Sleep": "Flow",
    "Loop": "Flow",
    "Switch": "Flow",
    "Continue": "Flow",
    "Break": "Flow",
    "Ternary": "Flow",
    "StrLen": "String",
    "StrUpper": "String",
    "StrLower": "String",
    "StrReplace": "String",
    "StrSplit": "String",
    "StrCompare": "String",
    "SubStr": "String",
    "InStr": "String",
    "RegExMatch": "String",
    "RegExReplace": "String",
    "Exception": "Flow",
    "Throw": "Flow",
    "MenuHandler": "GUI",
}


CATEGORY_FALLBACK_BY_PREFIX: List[tuple[str, str]] = [
    ("File", "File"),
    ("Dir", "File"),
    ("Msg", "GUI"),
    ("Gui", "GUI"),
    ("Tray", "GUI"),
    ("Menu", "GUI"),
    ("Win", "Window"),
    ("Control", "Window"),
    ("Sound", "Sound"),
    ("Reg", "Registry"),
    ("Env", "Env"),
    ("Clip", "Env"),
    ("Hot", "Hotkey"),
    ("Key", "Hotkey"),
    ("Mouse", "Hotkey"),
    ("Date", "DateTime"),
    ("Time", "DateTime"),
    ("Loop", "Flow"),
    ("Sleep", "Flow"),
    ("Set", "Flow"),
    ("Map", "Misc"),
]


def _normalize_token(raw: str) -> str:
    token = raw.strip()
    if token.startswith("&"):
        token = token[1:]
    return token.replace(".", "_")


def _token_candidates(text: str) -> List[str]:
    call_tokens: List[str] = []
    command_tokens: List[str] = []
    seen: set[str] = set()

    for line in text.splitlines():
        parts = line.split(";")
        for part in parts:
            fragment = part.strip()
            if not fragment:
                continue
            if fragment.startswith("#Requires") or fragment.startswith("#SingleInstance"):
                continue

            fragment = re.sub(r'"[^"\\]*(?:\\.[^"\\]*)*"', "", fragment)

            for obj, method in re.findall(r'([A-Za-z_][A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)\s*\(', fragment):
                if obj.lower() in LOWER_IGNORE or method.lower() in LOWER_IGNORE:
                    continue
                candidate = _normalize_token(f"{obj}.{method}")
                if candidate not in seen and candidate:
                    call_tokens.append(candidate)
                    seen.add(candidate)

            for match in re.findall(r'([A-Za-z_][A-Za-z0-9_]*)\s*\(', fragment):
                lower = match.lower()
                if lower in LOWER_IGNORE:
                    continue
                candidate = _normalize_token(match)
                if candidate not in seen and candidate:
                    call_tokens.append(candidate)
                    seen.add(candidate)

            head_match = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)\b', fragment)
            if head_match:
                head = head_match.group(1)
                rest = fragment[head_match.end():].lstrip()
                is_valid_head = True
                if head.lower() in LOWER_IGNORE:
                    is_valid_head = False
                if rest.startswith(':='):
                    is_valid_head = False
                if not rest:
                    is_valid_head = False
                if rest and rest[0] not in {',', '(', '.', '%', '['}:
                    is_valid_head = False
                if head.startswith('A_'):
                    is_valid_head = False
                if is_valid_head and head and head[0].isupper():
                    candidate = _normalize_token(head)
                    if candidate not in seen and candidate:
                        command_tokens.append(candidate)
                        seen.add(candidate)

            for match in re.findall(r'([A-Za-z_][A-Za-z0-9_]*)\s*,', fragment):
                lower = match.lower()
                if lower in LOWER_IGNORE:
                    continue
                if match.startswith('A_'):
                    continue
                if match and match[0].isupper():
                    candidate = _normalize_token(match)
                    if candidate not in seen and candidate:
                        command_tokens.append(candidate)
                        seen.add(candidate)

    return call_tokens + command_tokens


def derive_category(token: Optional[str]) -> str:
    if not token:
        return "Misc"

    token_clean = token.replace("_", "")

    if token in TOKEN_CATEGORY_OVERRIDES:
        return TOKEN_CATEGORY_OVERRIDES[token]

    if "Str" in token_clean:
        return "String"
    if "Loop" in token_clean or token_clean.startswith("For"):
        return "Flow"

    for prefix, category in CATEGORY_FALLBACK_BY_PREFIX:
        if token_clean.startswith(prefix):
            return category

    return "Misc"


def slugify(name: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9_]+", "_", name)
    slug = re.sub(r"_+", "_", slug)
    return slug.strip("_")


@dataclass
class RenamePlan:
    source: Path
    target: Path
    token: Optional[str]
    category: str


def plan_renames(files: Iterable[Path]) -> List[RenamePlan]:
    counts_by_token: Dict[str, int] = {}
    existing_max_by_slug: Dict[str, int] = defaultdict(int)
    name_pattern = re.compile(r'^[A-Za-z]+_([A-Za-z0-9_]+)_ex(\d+)\.ahk$')

    for existing in YUNIT_DIR.glob('*.ahk'):
        if existing.name.startswith('Yunit_Test_'):
            continue
        match = name_pattern.match(existing.name)
        if match:
            slug = match.group(1)
            index = int(match.group(2))
            if index > existing_max_by_slug[slug]:
                existing_max_by_slug[slug] = index

    plans: List[RenamePlan] = []

    for src in sorted(files, key=lambda p: p.name.lower()):
        text = src.read_text(encoding="utf-8", errors="ignore")
        tokens = _token_candidates(text)
        if not tokens:
            normalized = text.replace(" ", "")
            if "?" in normalized and ":" in normalized:
                tokens.append("Ternary")
        primary = tokens[0] if tokens else None
        category = derive_category(primary)

        if primary:
            base = slugify(primary)
            if primary not in counts_by_token:
                counts_by_token[primary] = existing_max_by_slug.get(base, 0)
            counts_by_token[primary] += 1
            suffix = f"ex{counts_by_token[primary]:02d}"
            new_name = f"{category}_{base}_{suffix}.ahk"
        else:
            base = slugify(src.stem)
            new_name = f"Misc_{base}.ahk"

        target = src.with_name(new_name)
        plans.append(RenamePlan(source=src, target=target, token=primary, category=category))

    return plans


def perform_renames(plans: Iterable[RenamePlan]) -> None:
    for plan in plans:
        if plan.source == plan.target:
            continue
        if plan.target.exists():
            raise FileExistsError(f"Target already exists: {plan.target}")
        plan.source.rename(plan.target)


def main() -> None:
    parser = argparse.ArgumentParser(description="Rename Yunit test scripts to descriptive names.")
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Apply the renames in place instead of performing a dry run.",
    )
    args = parser.parse_args()

    files = list(YUNIT_DIR.glob("Yunit_Test_*.ahk"))
    if not files:
        raise SystemExit("No Yunit test files found.")

    plans = plan_renames(files)

    print("Proposed renames:\n")
    for plan in plans:
        token = plan.token or "<unknown>"
        print(f"{plan.source.name:>24}  ->  {plan.target.name:<32}  (token: {token}, category: {plan.category})")

    if args.apply:
        perform_renames(plans)
        print("\nRenames applied.")
    else:
        print("\nDry run; no files were renamed. Re-run with --apply to commit the changes.")


if __name__ == "__main__":
    main()

