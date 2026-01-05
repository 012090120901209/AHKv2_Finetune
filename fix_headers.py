#!/usr/bin/env python3
"""
Fix missing #Requires and #SingleInstance directives in AHK v2 files.
"""
import os
import re

def fix_ahk_headers(scripts_dir):
    """Add missing #Requires and #SingleInstance headers to AHK files."""
    fixed_count = 0
    requires_added = 0
    singleinstance_added = 0

    for root, dirs, files in os.walk(scripts_dir):
        for file in files:
            if not file.endswith(".ahk"):
                continue

            filepath = os.path.join(root, file)

            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
            except Exception as e:
                print(f"Error reading {filepath}: {e}")
                continue

            lines = content.split('\n')
            modified = False

            # Check if #Requires is present
            has_requires = any("#Requires AutoHotkey v2" in line for line in lines[:15])

            # Check if #SingleInstance is present
            has_singleinstance = any("#SingleInstance" in line for line in lines[:15])

            if not has_requires or not has_singleinstance:
                new_lines = []
                requires_inserted = False
                singleinstance_inserted = False

                # Process lines
                for i, line in enumerate(lines):
                    # If we haven't inserted #Requires yet
                    if not has_requires and not requires_inserted:
                        # Insert at the very beginning (before any comments)
                        if i == 0:
                            new_lines.append("#Requires AutoHotkey v2.0")
                            requires_inserted = True
                            requires_added += 1
                            modified = True

                    # Add the original line
                    new_lines.append(line)

                    # If we just added #Requires, add #SingleInstance next
                    if requires_inserted and not has_singleinstance and not singleinstance_inserted:
                        new_lines.append("#SingleInstance Force")
                        singleinstance_inserted = True
                        singleinstance_added += 1
                        modified = True
                    # If #Requires already exists, insert #SingleInstance after it
                    elif not requires_inserted and "#Requires AutoHotkey v2" in line and not has_singleinstance and not singleinstance_inserted:
                        new_lines.append("#SingleInstance Force")
                        singleinstance_inserted = True
                        singleinstance_added += 1
                        modified = True

                if modified:
                    try:
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write('\n'.join(new_lines))
                        fixed_count += 1
                        print(f"Fixed: {filepath}")
                    except Exception as e:
                        print(f"Error writing {filepath}: {e}")

    print(f"\n{'='*60}")
    print(f"Summary:")
    print(f"  Files modified: {fixed_count}")
    print(f"  #Requires added: {requires_added}")
    print(f"  #SingleInstance added: {singleinstance_added}")
    print(f"{'='*60}")

if __name__ == "__main__":
    scripts_dir = "/mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune/data/Scripts"
    print(f"Scanning {scripts_dir} for AHK files...")
    fix_ahk_headers(scripts_dir)
