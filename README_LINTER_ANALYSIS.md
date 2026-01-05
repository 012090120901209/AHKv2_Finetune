# AHK v2 Corpus Linter Analysis

**Analysis Date:** 2026-01-01  
**Tool:** ahk-linter (THQBY AutoHotkey2-LSP)  
**Files Analyzed:** 1,873

## Quick Summary

✅ **Quality Rating: EXCELLENT**

- **89.6%** of files are clean (0 errors, 0 warnings)
- **1,678 files** ready for immediate use in training
- **547 files** in perfect directories (gold standard)
- Only **195 files** (10.4%) need attention

## Reports Generated

| File | Description |
|------|-------------|
| **LINTER_SUMMARY.txt** | Quick overview, perfect for scanning |
| **LINTER_ANALYSIS_REPORT.md** | Comprehensive analysis with all details |
| **LINTER_DETAILED_FINDINGS.md** | Sample files, error patterns, recommendations |
| **LINTER_ACTION_CHECKLIST.md** | Step-by-step action items |
| **tools/analyze_linter_report.py** | Script to re-run analysis |
| **linter_full_report.json** | Raw linter output (800KB) |

## Key Findings

### Perfect Directories (100% Clean)
- **Alpha** (119 files) - Advanced patterns, data structures
- **File** (105 files) - File operations
- **StdLib** (95 files) - Standard library usage
- **Array** (83 files) - Array manipulation
- **GUI** (69 files) - GUI examples
- **Advanced** (51 files) - Advanced techniques

### High-Quality Directories (>89% Clean)
- **BuiltIn** (630 files, 89.4% clean) - Built-in functions
- **OOP** (81 files, 92.6% clean) - Object-oriented programming
- **Hotkey** (77 files, 98.7% clean) - Hotkey examples

### Directories Needing Attention
- **Integrity** (5 files, 80% errors) - **Intentional test cases**
- **Module** (17 files, 64.7% errors) - v2.1-alpha features
- **Library** (71 files, 43.7% errors) - Missing dependencies
- **String** (111 files, 24.3% errors) - Continuation section issues

## Top Error Types

| Count | Error | Likely Cause |
|-------|-------|--------------|
| 398 | Missing operand | LSP parser limitation |
| 198 | Unterminated string | Continuation sections |
| 169 | Unexpected ':' | Object literal formatting |
| 103 | Error in object literal | Multi-line syntax |

**Note:** Many errors appear to be LSP parser limitations, not genuine syntax issues.

## Immediate Actions

### Priority 1 (Required)
1. **Exclude Integrity directory** (5 files - intentional test cases)
2. **Tag Module files** (17 files - v2.1-alpha syntax)
3. **Export clean file lists** for training dataset

### Priority 2 (Recommended)
4. **Add missing libraries** OR convert to standalone (31 files)
5. **Validate high-error files** (13 files with 20+ errors)
6. **Review String directory** (27 files with continuation issues)

## Training Dataset Recommendations

### Use Immediately (1,678 files - 89.6%)
All files with 0 errors and 0 warnings. These are LSP-validated and ready for training.

### Review Before Use (~80 files)
Files with 1-3 errors. Likely false positives, but quick validation recommended.

### Exclude (~18 files)
- Integrity directory test cases (5 files)
- Highest-error outliers (13 files)

## Running the Analysis

### Full Linter Scan
```bash
cd tools/ahk-linter
npx ts-node index.ts lint path=../../data/Scripts --recursive --format=json > ../../linter_full_report.json
```

### Analyze Results
```bash
cd /mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune
python3 tools/analyze_linter_report.py linter_full_report.json
```

### Extract Clean Files
```bash
tail -n +2 linter_full_report.json | \
  jq -r '.files[] | select(.summary.errors == 0) | .file' | \
  sed 's|.*/data/Scripts/||' > data/prepared/clean_files.txt
```

## Statistics at a Glance

```
Total Files:           1,873
Clean Files:           1,678 (89.6%)
Files with Errors:       195 (10.4%)
Files with Warnings:      17 (0.9%)

Total Errors:          1,589
Total Warnings:           26

Perfect Directories:      11 (547 files total)
High-Quality Dirs:         5 (865 files total)
```

## Error Distribution

- Syntax/Parser Issues: 42.0%
- Unknown Tokens: 15.0%
- String Issues: 13.8%
- Object Literals: 6.5%
- Reserved Words: 4.7%
- Other: 17.9%

## Conclusion

The AHK v2 script corpus is in **excellent condition** with minimal cleanup required. The majority of errors are concentrated in a few directories and appear to be LSP parser limitations rather than genuine syntax problems.

**Bottom Line:**
- ✅ 1,678 files ready for immediate training use
- ✅ Core quality is excellent across most directories
- ✅ Issues are concentrated and addressable
- ✅ Training dataset can be assembled with minimal effort

## Next Steps

1. Review **LINTER_ACTION_CHECKLIST.md** for detailed tasks
2. Complete Priority 1 actions (exclude Integrity, tag Module files)
3. Assemble training dataset from clean files
4. Optionally: Validate and add files with minor errors

---

**For detailed analysis, see:** LINTER_ANALYSIS_REPORT.md  
**For quick overview, see:** LINTER_SUMMARY.txt  
**For action items, see:** LINTER_ACTION_CHECKLIST.md
