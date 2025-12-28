import json
import os
import re
from collections import defaultdict

def read_file_list(file_path):
    """Read the list of AHK files from the text file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        files = [line.strip() for line in f if line.strip()]
    return files

def check_indentation(lines):
    """Check indentation consistency and standards."""
    issues = []
    indent_type = None
    indent_size = 4  # standard 4 spaces

    for i, line in enumerate(lines, 1):
        stripped = line.lstrip()
        if not stripped:  # empty line
            continue
        indent = line[:len(line) - len(stripped)]

        if indent:
            if indent_type is None:
                if '\t' in indent:
                    indent_type = 'tab'
                else:
                    indent_type = 'space'

            # Check consistency
            if indent_type == 'tab' and ' ' in indent:
                issues.append({
                    'line': i,
                    'description': 'Mixed indentation: spaces found in tab-indented file'
                })
            elif indent_type == 'space' and '\t' in indent:
                issues.append({
                    'line': i,
                    'description': 'Mixed indentation: tabs found in space-indented file'
                })

            # Check multiples
            if indent_type == 'space':
                if len(indent) % indent_size != 0:
                    issues.append({
                        'line': i,
                        'description': f'Indentation not multiple of {indent_size} spaces'
                    })
            elif indent_type == 'tab':
                # For tabs, check if consistent (all tabs)
                if indent != '\t' * (len(indent) // len('\t')):
                    issues.append({
                        'line': i,
                        'description': 'Inconsistent tab usage'
                    })

    return issues

def check_line_endings(content):
    """Check line ending consistency."""
    issues = []
    lines = content.splitlines(keepends=True)
    if not lines:
        return issues

    # Detect first line ending
    first_ending = None
    for line in lines:
        if line.endswith('\r\n'):
            ending = 'CRLF'
        elif line.endswith('\n'):
            ending = 'LF'
        else:
            continue  # no ending or just \r
        if first_ending is None:
            first_ending = ending
        elif ending != first_ending:
            issues.append({
                'line': lines.index(line) + 1,
                'description': f'Inconsistent line ending: {ending} found, expected {first_ending}'
            })
            break  # only report first inconsistency

    return issues

def check_comments(lines):
    """Check comment formatting."""
    issues = []

    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if not stripped.startswith(';'):
            continue

        # Check single-line comments
        if ';' in line:
            comment_start = line.find(';')
            if comment_start > 0:
                # Inline comment
                before_comment = line[:comment_start].rstrip()
                if before_comment and not line[comment_start - 1].isspace():
                    issues.append({
                        'line': i,
                        'description': 'Missing space before inline comment'
                    })
            # Check space after ;
            if len(line) > comment_start + 1 and line[comment_start + 1] != ' ':
                issues.append({
                    'line': i,
                    'description': 'Missing space after ; in comment'
                })

    # Check multi-line comments /* */
    content = '\n'.join(lines)
    # Simple check for balanced /* */
    open_count = content.count('/*')
    close_count = content.count('*/')
    if open_count != close_count:
        issues.append({
            'line': 1,  # approximate
            'description': f'Unbalanced multi-line comments: {open_count} /* vs {close_count} */'
        })

    return issues

def check_syntax(content):
    """Check basic syntax: balanced delimiters."""
    issues = []
    stack = []
    delimiters = {'{': '}', '[': ']', '(': ')'}
    closers = {v: k for k, v in delimiters.items()}

    lines = content.splitlines()
    for i, line in enumerate(lines, 1):
        for char in line:
            if char in delimiters:
                stack.append((char, i))
            elif char in closers:
                if not stack:
                    issues.append({
                        'line': i,
                        'description': f'Unmatched closing delimiter: {char}'
                    })
                else:
                    opener, open_line = stack.pop()
                    if closers[char] != opener:
                        issues.append({
                            'line': i,
                            'description': f'Mismatched delimiter: expected {delimiters[opener]}, found {char}'
                        })

    while stack:
        opener, open_line = stack.pop()
        issues.append({
            'line': open_line,
            'description': f'Unmatched opening delimiter: {opener}'
        })

    return issues

def check_structure(lines):
    """Check structural elements: functions and classes indentation."""
    issues = []
    indent_size = 4
    in_function = False
    in_class = False
    expected_indent = 0

    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        if not stripped or stripped.startswith(';'):
            continue

        indent = len(line) - len(line.lstrip())

        # Detect function/class start
        if re.match(r'^\w+\s*\([^)]*\)\s*\{', stripped):
            in_function = True
            expected_indent = indent + indent_size
        elif stripped.startswith('class ') and '{' in stripped:
            in_class = True
            expected_indent = indent + indent_size
        elif stripped == '}':
            if in_function:
                in_function = False
                expected_indent = max(0, expected_indent - indent_size)
            elif in_class:
                in_class = False
                expected_indent = max(0, expected_indent - indent_size)
        elif in_function or in_class:
            if indent != expected_indent:
                issues.append({
                    'line': i,
                    'description': f'Incorrect indentation in {"function" if in_function else "class"}: expected {expected_indent} spaces, found {indent}'
                })

    return issues

def check_file(file_path):
    """Check a single AHK file and return issues."""
    issues = defaultdict(list)

    try:
        with open(file_path, 'r', encoding='utf-8', newline='') as f:
            content = f.read()
            lines = content.splitlines()

        # Indentation
        issues['indentation'] = check_indentation(lines)

        # Line endings
        issues['line_endings'] = check_line_endings(content)

        # Comments
        issues['comments'] = check_comments(lines)

        # Syntax
        issues['syntax'] = check_syntax(content)

        # Structure
        issues['structure'] = check_structure(lines)

    except Exception as e:
        issues['errors'] = [{'line': 1, 'description': f'Error reading file: {str(e)}'}]

    return dict(issues)

def main():
    file_list_path = 'ahk_files_list.txt'
    report_path = 'formatting_issues_report.json'

    files = read_file_list(file_list_path)
    report = {}
    total_issues = 0
    category_counts = defaultdict(int)

    for file_path in files:
        if not os.path.exists(file_path):
            print(f"Warning: File not found: {file_path}")
            continue

        print(f"Checking: {file_path}")
        file_issues = check_file(file_path)
        if any(file_issues.values()):  # only include files with issues
            report[file_path] = file_issues
            for category, issues in file_issues.items():
                total_issues += len(issues)
                category_counts[category] += len(issues)

    # Write report
    with open(report_path, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2)

    # Summary
    print("\n=== Formatting Check Summary ===")
    print(f"Total files checked: {len(files)}")
    print(f"Files with issues: {len(report)}")
    print(f"Total issues: {total_issues}")
    print("\nIssues by category:")
    for category, count in sorted(category_counts.items()):
        print(f"  {category}: {count}")

if __name__ == '__main__':
    main()