import json
import os
import shutil
import re

def main():
    report_path = 'formatting_issues_report.json'
    backup_dir = 'backup'

    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)

    try:
        with open(report_path, 'r', encoding='utf-8') as f:
            report = json.load(f)
    except FileNotFoundError:
        print(f"Error: {report_path} not found.")
        return
    except json.JSONDecodeError as e:
        print(f"Error reading {report_path}: {str(e)}")
        return

    fixed_files = 0
    errors = []

    for file_path, issues in report.items():
        if 'indentation' in issues and issues['indentation']:
            try:
                # Backup
                backup_path = os.path.join(backup_dir, os.path.basename(file_path))
                shutil.copy2(file_path, backup_path)

                # Read file
                with open(file_path, 'r', encoding='utf-8') as f:
                    lines = f.readlines()

                # Fix indentation
                fixed_lines = []
                for line in lines:
                    match = re.match(r'^([ \t]*)(.*)$', line)
                    indent = match.group(1)
                    rest = match.group(2)
                    if indent:
                        # Calculate indent level in spaces (treating tabs as 4 spaces)
                        indent_spaces = indent.replace('\t', '    ')
                        indent_len = len(indent_spaces)
                        tabs = indent_len // 4
                        spaces = indent_len % 4
                        new_indent = '\t' * tabs + ' ' * spaces
                    else:
                        new_indent = ''
                    fixed_lines.append(new_indent + rest)

                # Write back
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.writelines(fixed_lines)

                fixed_files += 1
                print(f"Fixed: {file_path}")

            except Exception as e:
                errors.append(f"Error fixing {file_path}: {str(e)}")

    # Summary
    print(f"\n=== Fix Summary ===")
    print(f"Files fixed: {fixed_files}")
    if errors:
        print("Errors encountered:")
        for error in errors:
            print(f"  {error}")
    else:
        print("No errors encountered.")

if __name__ == '__main__':
    main()