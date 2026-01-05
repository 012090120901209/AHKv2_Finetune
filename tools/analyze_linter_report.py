#!/usr/bin/env python3
"""
Analyze AHK Linter Report

This script analyzes the JSON output from the ahk-linter tool and generates
detailed statistics and recommendations for the AHK v2 script corpus.

Usage:
    python3 analyze_linter_report.py <linter_report.json>

    Or run from tools/ahk-linter directory:
    npx ts-node index.ts lint path=../../data/Scripts --recursive --format=json | python3 ../../tools/analyze_linter_report.py -
"""

import json
import sys
from collections import defaultdict, Counter
from pathlib import Path


def load_report(filepath):
    """Load and parse linter report JSON"""
    if filepath == '-':
        # Skip first line if reading from stdin (it contains "Using root: ...")
        sys.stdin.readline()
        data = json.load(sys.stdin)
    else:
        with open(filepath, 'r') as f:
            # Skip first line
            f.readline()
            data = json.load(f)
    return data


def analyze_by_directory(data):
    """Analyze errors grouped by directory"""
    dir_stats = defaultdict(lambda: {
        'total': 0,
        'with_errors': 0,
        'with_warnings': 0,
        'total_errors': 0,
        'total_warnings': 0,
        'clean': 0
    })

    for file_data in data['files']:
        file_path = file_data['file']
        parts = file_path.replace('/mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune/data/Scripts/', '').split('/')
        dir_name = parts[0] if len(parts) > 1 else 'ROOT'

        stats = dir_stats[dir_name]
        stats['total'] += 1
        stats['total_errors'] += file_data['summary']['errors']
        stats['total_warnings'] += file_data['summary']['warnings']

        if file_data['summary']['errors'] > 0:
            stats['with_errors'] += 1
        if file_data['summary']['warnings'] > 0:
            stats['with_warnings'] += 1
        if file_data['summary']['errors'] == 0 and file_data['summary']['warnings'] == 0:
            stats['clean'] += 1

    return dir_stats


def analyze_error_types(data):
    """Categorize and count error types"""
    error_messages = []
    error_by_file = defaultdict(list)

    for file_data in data['files']:
        file_path = file_data['file'].replace('/mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune/data/Scripts/', '')
        for diag in file_data.get('diagnostics', []):
            msg = diag.get('message', '')
            if msg:
                error_messages.append(msg)
                error_by_file[msg].append(file_path)

    return Counter(error_messages), error_by_file


def categorize_errors(error_counts):
    """Group errors into logical categories"""
    categories = {
        "Missing/Unexpected Operators": [],
        "String Issues": [],
        "Object/Literal Issues": [],
        "Reserved Words": [],
        "Unknown Tokens": [],
        "Hotkey/Hotstring Issues": [],
        "File/Include Issues": [],
        "Alpha Features (Export/Module)": [],
        "Other": []
    }

    for msg in error_counts.keys():
        msg_lower = msg.lower()

        if 'missing operand' in msg or ('unexpected' in msg and any(x in msg for x in ["')'", "'}'", "':'", "'{'", "']'"])):
            categories["Missing/Unexpected Operators"].append(msg)
        elif 'string' in msg_lower or 'unterminated' in msg:
            categories["String Issues"].append(msg)
        elif 'object literal' in msg_lower:
            categories["Object/Literal Issues"].append(msg)
        elif 'reserved word' in msg_lower:
            categories["Reserved Words"].append(msg)
        elif 'unknown' in msg:
            categories["Unknown Tokens"].append(msg)
        elif 'hotkey' in msg_lower or 'hotstring' in msg_lower:
            categories["Hotkey/Hotstring Issues"].append(msg)
        elif 'does not exist' in msg_lower or 'invalid file path' in msg:
            categories["File/Include Issues"].append(msg)
        elif 'export' in msg_lower or 'module' in msg_lower:
            categories["Alpha Features (Export/Module)"].append(msg)
        else:
            categories["Other"].append(msg)

    return categories


def print_summary(data):
    """Print executive summary"""
    summary = data['summary']
    print("\n" + "=" * 80)
    print("AHK V2 SCRIPT CORPUS - LINTER ANALYSIS")
    print("=" * 80)
    print(f"\nTotal Files Analyzed: {summary['totalFiles']}")
    print(f"Files with Errors: {summary['filesWithErrors']} ({summary['filesWithErrors']/summary['totalFiles']*100:.1f}%)")
    print(f"Files with Warnings: {summary['filesWithWarnings']} ({summary['filesWithWarnings']/summary['totalFiles']*100:.1f}%)")
    print(f"Total Errors: {summary['totalErrors']}")
    print(f"Total Warnings: {summary['totalWarnings']}")

    clean_files = summary['totalFiles'] - summary['filesWithErrors']
    print(f"\n✓ Clean Files (0 errors): {clean_files} ({clean_files/summary['totalFiles']*100:.1f}%)")


def print_directory_analysis(dir_stats):
    """Print directory-level statistics"""
    print("\n" + "=" * 80)
    print("DIRECTORY ANALYSIS")
    print("=" * 80)

    print(f"\n{'Directory':<20} {'Total':>7} {'Errors':>7} {'Error%':>8} {'Quality':>8}")
    print("-" * 70)

    sorted_dirs = sorted(dir_stats.items(), key=lambda x: (x[1]['clean'] / x[1]['total'], x[1]['total']), reverse=True)

    perfect_dirs = []
    for dir_name, stats in sorted_dirs:
        if stats['total'] >= 5:
            error_pct = (stats['with_errors'] / stats['total']) * 100
            quality_pct = (stats['clean'] / stats['total']) * 100

            status = "✓" if stats['clean'] == stats['total'] else " "
            print(f"{status} {dir_name:<18} {stats['total']:>7} {stats['with_errors']:>7} {error_pct:>7.1f}% {quality_pct:>7.1f}%")

            if stats['clean'] == stats['total']:
                perfect_dirs.append((dir_name, stats['total']))

    print(f"\n{len(perfect_dirs)} directories with 100% clean files ({sum(x[1] for x in perfect_dirs)} total files)")


def print_error_analysis(error_counts, categories, error_by_file):
    """Print error type analysis"""
    print("\n" + "=" * 80)
    print("ERROR TYPE ANALYSIS")
    print("=" * 80)

    print("\nTop 20 Most Common Errors:")
    print(f"{'Count':>6}  {'Error Message'}")
    print("-" * 70)
    for msg, count in error_counts.most_common(20):
        print(f"{count:>6}  {msg}")

    print("\n" + "-" * 70)
    print("Error Categories:")
    print("-" * 70)

    for category, messages in categories.items():
        if messages:
            total = sum(error_counts[msg] for msg in messages)
            pct = (total / sum(error_counts.values())) * 100
            print(f"\n{category}: {total} errors ({pct:.1f}%)")
            for msg in sorted(messages, key=lambda x: error_counts[x], reverse=True)[:3]:
                print(f"  [{error_counts[msg]:>4}x] {msg}")


def print_problematic_files(data):
    """Print files with most errors"""
    print("\n" + "=" * 80)
    print("MOST PROBLEMATIC FILES (20+ errors)")
    print("=" * 80)

    problematic = []
    for file_data in data['files']:
        if file_data['summary']['errors'] >= 20:
            file_path = file_data['file'].replace('/mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune/data/Scripts/', '')
            problematic.append((file_path, file_data['summary']['errors']))

    problematic.sort(key=lambda x: x[1], reverse=True)

    print(f"\n{'Errors':>6}  File")
    print("-" * 70)
    for file_path, error_count in problematic:
        print(f"{error_count:>6}  {file_path}")

    print(f"\nTotal: {len(problematic)} files with 20+ errors")


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 analyze_linter_report.py <linter_report.json>")
        print("       python3 analyze_linter_report.py -  (read from stdin)")
        sys.exit(1)

    # Load report
    data = load_report(sys.argv[1])

    # Analyze
    dir_stats = analyze_by_directory(data)
    error_counts, error_by_file = analyze_error_types(data)
    categories = categorize_errors(error_counts)

    # Print results
    print_summary(data)
    print_directory_analysis(dir_stats)
    print_error_analysis(error_counts, categories, error_by_file)
    print_problematic_files(data)

    print("\n" + "=" * 80)
    print("RECOMMENDATIONS")
    print("=" * 80)
    print("""
1. Exclude Integrity directory (intentional test cases with errors)
2. Add missing library files (JSON.ahk, Chrome.ahk, etc.)
3. Tag files using v2.1-alpha features (#Module, Export)
4. Manually review files with 20+ errors
5. Focus cleanup on Library, Module, and String directories

For training data:
- Use immediately: 1,678 files with 0 errors (89.6% of corpus)
- Review before use: Files with 1-10 errors (likely false positives)
- Exclude or fix: Files with 20+ errors and Integrity directory
""")
    print("=" * 80)


if __name__ == '__main__':
    main()
