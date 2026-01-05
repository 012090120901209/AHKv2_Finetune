#!/usr/bin/env python3
"""
Organize AHK example files into their corresponding category folders.

Files are moved based on their filename prefix:
- String_*.ahk -> String/
- Array_*.ahk -> Array/
- Advanced_*.ahk -> Advanced/
- BuiltIn_*.ahk -> BuiltIn/
- Control_*.ahk -> Control/
- File_*.ahk -> File/
- GUI_*.ahk -> GUI/
- OOP_*.ahk -> OOP/
- StdLib_*.ahk -> StdLib/
"""

import os
import shutil
from pathlib import Path

# Base directory containing the AHK examples
BASE_DIR = Path(r"C:\Users\uphol\Documents\Design\Coding\ahk-finetune\data\raw_scripts\AHK_v2_Examples")

# Mapping of filename prefixes to target folders
PREFIX_TO_FOLDER = {
    # Original folders
    "String": "String",
    "Strings": "String",  # Alias
    "Array": "Array",
    "Advanced": "Advanced",
    "BuiltIn": "BuiltIn",
    "Control": "Control",
    "File": "File",
    "GUI": "GUI",
    "OOP": "OOP",
    "StdLib": "StdLib",
    # New folders based on scan
    "Hotkey": "Hotkey",
    "Hotstring": "Hotstring",
    "Window": "Window",
    "Library": "Library",
    "Lib": "Library",  # Alias - merge Lib into Library
    "Misc": "Misc",
    "Process": "Process",
    "Directive": "Directive",
    "Env": "Env",
    "GitHub": "GitHub",
    "Module": "Module",
    "Xypha": "Xypha",
    "Pattern": "Pattern",
    "Syntax": "Syntax",
    "Registry": "Registry",
    "Failed": "Failed",
    "Utility": "Utility",
    "DateTime": "DateTime",
    "v2": "v2",
    "Integrity": "Integrity",
    "Screen": "Screen",
    "Sound": "Sound",
    "Flow": "Flow",
    "Hook": "Hook",
    "MetaFunction": "MetaFunction",
    "DataStructures": "DataStructures",
    "Functions": "Functions",
    "Iterator": "Iterator",
    "Maths": "Maths",
    "Sync": "Sync",
    # Control-related (merge into Control)
    "ControlFocus": "Control",
    "ControlGetFocus": "Control",
    "ControlGetPos": "Control",
    "ControlGetText": "Control",
    "ControlMove": "Control",
    "ControlSend": "Control",
    "ControlSetText": "Control",
    "ControlGetHwnd": "Control",
    # Dir/Drive operations (merge into File)
    "DirCopy": "File",
    "DirCreate": "File",
    "DirMove": "File",
    "DirDelete": "File",
    "DirExist": "File",
    "DriveEject": "File",
    "DriveGet": "File",
    "DriveInfo": "File",
    "DriveList": "File",
    "DriveSet": "File",
    # Misc items
    "Base64": "Misc",
    "ChildProcess": "Process",
    "Crypt": "Misc",
    "Descolada": "Misc",
    "JSON": "Misc",
    "Local": "Misc",
}

def get_target_folder(filename: str) -> str | None:
    """
    Determine the target folder based on filename prefix.

    Args:
        filename: Name of the file (without path)

    Returns:
        Target folder name or None if no match
    """
    # Check each prefix
    for prefix, folder in PREFIX_TO_FOLDER.items():
        # Match prefix followed by underscore or directly
        if filename.startswith(f"{prefix}_") or filename.startswith(f"{prefix}-"):
            return folder
    return None


def organize_files(dry_run: bool = True) -> dict:
    """
    Move AHK files to their corresponding category folders.

    Args:
        dry_run: If True, only report what would be done without moving files

    Returns:
        Dictionary with move statistics
    """
    stats = {
        "moved": [],
        "skipped": [],
        "already_in_folder": [],
        "no_match": [],
        "errors": []
    }

    # Get all .ahk files in the base directory (not in subdirectories)
    ahk_files = [f for f in BASE_DIR.iterdir() if f.is_file() and f.suffix.lower() == ".ahk"]

    print(f"Found {len(ahk_files)} .ahk files in base directory")
    print(f"{'DRY RUN - ' if dry_run else ''}Processing files...\n")

    for file_path in sorted(ahk_files):
        filename = file_path.name
        target_folder = get_target_folder(filename)

        if target_folder is None:
            stats["no_match"].append(filename)
            continue

        target_dir = BASE_DIR / target_folder
        target_path = target_dir / filename

        # Check if file already exists in target
        if target_path.exists():
            stats["already_in_folder"].append(filename)
            continue

        # Create target directory if it doesn't exist
        if not target_dir.exists():
            if not dry_run:
                target_dir.mkdir(parents=True)
            print(f"  Creating directory: {target_folder}/")

        # Move the file
        try:
            if not dry_run:
                shutil.move(str(file_path), str(target_path))
            stats["moved"].append((filename, target_folder))
            print(f"  {'Would move' if dry_run else 'Moved'}: {filename} -> {target_folder}/")
        except Exception as e:
            stats["errors"].append((filename, str(e)))
            print(f"  ERROR moving {filename}: {e}")

    return stats


def print_summary(stats: dict):
    """Print a summary of the organization results."""
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)

    print(f"\nFiles moved: {len(stats['moved'])}")
    if stats['moved']:
        # Group by folder
        by_folder = {}
        for filename, folder in stats['moved']:
            by_folder.setdefault(folder, []).append(filename)
        for folder, files in sorted(by_folder.items()):
            print(f"  {folder}/: {len(files)} files")

    print(f"\nFiles already in target folder: {len(stats['already_in_folder'])}")

    print(f"\nFiles with no matching prefix: {len(stats['no_match'])}")
    if stats['no_match']:
        print("  Examples (first 20):")
        for f in stats['no_match'][:20]:
            print(f"    - {f}")
        if len(stats['no_match']) > 20:
            print(f"    ... and {len(stats['no_match']) - 20} more")

    if stats['errors']:
        print(f"\nErrors: {len(stats['errors'])}")
        for filename, error in stats['errors']:
            print(f"  - {filename}: {error}")


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Organize AHK example files into category folders")
    parser.add_argument("--execute", action="store_true",
                       help="Actually move files (default is dry-run)")
    parser.add_argument("--list-unmatched", action="store_true",
                       help="List all files that don't match any prefix")

    args = parser.parse_args()

    if not BASE_DIR.exists():
        print(f"Error: Base directory does not exist: {BASE_DIR}")
        return 1

    dry_run = not args.execute

    if dry_run:
        print("=" * 60)
        print("DRY RUN MODE - No files will be moved")
        print("Use --execute to actually move files")
        print("=" * 60)
    else:
        print("=" * 60)
        print("EXECUTING - Files will be moved!")
        print("=" * 60)

    print(f"\nBase directory: {BASE_DIR}")
    print(f"Target folders: {', '.join(PREFIX_TO_FOLDER.values())}\n")

    stats = organize_files(dry_run=dry_run)
    print_summary(stats)

    if args.list_unmatched and stats['no_match']:
        print("\n" + "=" * 60)
        print("ALL UNMATCHED FILES")
        print("=" * 60)
        for f in sorted(stats['no_match']):
            print(f"  {f}")

    return 0


if __name__ == "__main__":
    exit(main())
