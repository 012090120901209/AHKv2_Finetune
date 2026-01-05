#!/usr/bin/env python3
"""
Validate that all AHK files have required headers.
"""
import os
import sys

def validate_headers(scripts_dir):
    """Check that all AHK files have #Requires and #SingleInstance headers."""
    missing_requires = []
    missing_singleinstance = []
    total_files = 0

    for root, dirs, files in os.walk(scripts_dir):
        for file in files:
            if not file.endswith(".ahk"):
                continue

            total_files += 1
            filepath = os.path.join(root, file)

            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
            except Exception as e:
                print(f"Error reading {filepath}: {e}")
                continue

            lines = content.split('\n')[:20]  # Check first 20 lines

            has_requires = any("#Requires AutoHotkey v2" in line for line in lines)
            has_singleinstance = any("#SingleInstance" in line for line in lines)

            if not has_requires:
                missing_requires.append(filepath)
            if not has_singleinstance:
                missing_singleinstance.append(filepath)

    print(f"{'='*60}")
    print(f"Validation Results:")
    print(f"  Total AHK files: {total_files}")
    print(f"  Files with #Requires: {total_files - len(missing_requires)}")
    print(f"  Files with #SingleInstance: {total_files - len(missing_singleinstance)}")
    print(f"{'='*60}")

    if missing_requires:
        print(f"\nFiles missing #Requires ({len(missing_requires)}):")
        for filepath in missing_requires[:10]:
            print(f"  - {filepath}")
        if len(missing_requires) > 10:
            print(f"  ... and {len(missing_requires) - 10} more")

    if missing_singleinstance:
        print(f"\nFiles missing #SingleInstance ({len(missing_singleinstance)}):")
        for filepath in missing_singleinstance[:10]:
            print(f"  - {filepath}")
        if len(missing_singleinstance) > 10:
            print(f"  ... and {len(missing_singleinstance) - 10} more")

    if not missing_requires and not missing_singleinstance:
        print("\n✓ All files have required headers!")
        return 0
    else:
        print("\n✗ Some files are missing headers")
        return 1

if __name__ == "__main__":
    scripts_dir = "/mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune/data/Scripts"
    sys.exit(validate_headers(scripts_dir))
