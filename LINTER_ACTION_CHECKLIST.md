# AHK v2 Corpus - Action Checklist

Based on linter analysis completed 2026-01-01

## Immediate Actions (Priority 1)

### 1. Exclude Integrity Directory from Training
- [ ] Move `data/Scripts/Integrity/` to `data/Scripts/TestCases/Integrity/`
- [ ] OR: Add metadata tag `category: test_cases` to these files
- [ ] Update dataset preparation scripts to exclude this directory
- **Files affected:** 5 files with 276 intentional errors

### 2. Tag Module Files with v2.1-alpha Metadata
- [ ] Add metadata field `ahk_version: v2.1-alpha` to 17 Module files
- [ ] Document alpha features used (#Module, Export)
- [ ] Create separate training subset for alpha syntax
- **Files affected:** 17 files in `data/Scripts/Module/`

### 3. Document Clean File Lists
- [ ] Export list of 1,678 clean files to `data/prepared/clean_files.txt`
- [ ] Export list of 547 gold-standard files to `data/prepared/gold_standard_files.txt`
- [ ] Use these for initial training dataset

**Command:**
```bash
cd /mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune
tail -n +2 linter_full_report.json | jq -r '.files[] | select(.summary.errors == 0 and .summary.warnings == 0) | .file' > data/prepared/clean_files.txt
```

## Short-term Actions (Priority 2)

### 4. Add Missing Library Dependencies
**Option A: Add library files to repository**
- [ ] Create `data/Scripts/Library/JSON.ahk` (affects 12 files)
- [ ] Create `data/Scripts/Library/Chrome.ahk` (affects 5 files)
- [ ] Create `data/Scripts/Library/Monitor.ahk` (affects 3 files)
- [ ] Create `data/Scripts/Library/Audio.ahk` (affects 2 files)

**Option B: Convert to standalone examples**
- [ ] Refactor 31 library-dependent files to be self-contained
- [ ] Remove #Include directives
- [ ] Inline necessary functionality

**Files affected:** 31 files in `data/Scripts/Library/`

### 5. Validate High-Error Files
**Manual review required for:**
- [ ] `GitHub/GitHub_03_APM_Counter.ahk` (204 errors)
- [ ] `BuiltIn/BuiltIn_RegEx_Match_04_Options.ahk` (176 errors)
- [ ] `BuiltIn/BuiltIn_RegEx_Match_05_Advanced.ahk` (165 errors)
- [ ] `BuiltIn/BuiltIn_RunWait_02.ahk` (42 errors)
- [ ] `GitHub/GitHub_DllCall_03_ClipboardHTML.ahk` (37 errors)

**Action for each file:**
1. Test runtime execution: Does it actually work?
2. If valid: Document as "complex syntax, LSP limitation"
3. If broken: Fix or exclude from training

**Files to review:** 13 files with 20+ errors (excluding Integrity)

### 6. Review String Directory Issues
- [ ] Manually validate 27 files in String directory with errors
- [ ] Focus on continuation section formatting
- [ ] Test runtime execution of flagged files
- [ ] Reformat or mark as false positives

**Files affected:** 27 of 111 files in `data/Scripts/String/`

## Long-term Improvements (Priority 3)

### 7. Add Automated Validation Pipeline
- [ ] Create pre-commit hook to run LSP linter on new files
- [ ] Set up CI/CD to validate pull requests
- [ ] Enforce 0-error policy for new additions

**Script location:** `tools/hooks/pre-commit-linter.sh`

### 8. Enhance Metadata System
- [ ] Add `ahk_version` field (v2.0, v2.1-alpha, etc.)
- [ ] Add `dependencies` field for #Include files
- [ ] Add `complexity` rating (basic, intermediate, advanced)
- [ ] Add `lsp_validated` timestamp

**Metadata file:** `data/Scripts/metadata.json`

### 9. Cross-validation Testing
- [ ] Runtime test sample of files with errors
- [ ] Compare with alternative AHK linters
- [ ] Document confirmed false positives
- [ ] Submit bug reports to THQBY LSP for parser improvements

### 10. Documentation Updates
- [ ] Add README to each major directory
- [ ] Document known LSP limitations
- [ ] Create contribution guidelines
- [ ] Update CLAUDE.md with linter findings

## Dataset Preparation

### Training Set Assembly

**Tier 1: Immediate Use (1,678 files)**
```bash
# Export clean files
tail -n +2 linter_full_report.json | \
  jq -r '.files[] | select(.summary.errors == 0) | .file' | \
  sed 's|/mnt/c/Users/uphol/Documents/Design/Coding/ahk-finetune/||' \
  > data/prepared/tier1_clean.txt
```

**Tier 2: Validated Files (~80 files)**
- [ ] Manual validation of 1-3 error files
- [ ] Document validation results
- [ ] Add to training set after approval

**Tier 3: Fixed Files (~20 files)**
- [ ] Fix genuine syntax issues
- [ ] Add to training set after fixes

**Exclusion List**
- [ ] Create `data/prepared/excluded_files.txt`
- [ ] Include Integrity directory (5 files)
- [ ] Include major error files (13 files)
- [ ] Document reason for each exclusion

## Quality Metrics Tracking

### Before Cleanup
- Total files: 1,873
- Clean files: 1,678 (89.6%)
- Files with errors: 195 (10.4%)
- Total errors: 1,589

### Target After Cleanup
- [ ] Clean files: >95% (1,779+ files)
- [ ] Files with errors: <5% (94 files)
- [ ] Total errors: <500
- [ ] All training files: 0 errors

### Measurement
```bash
# Re-run linter after changes
cd tools/ahk-linter
npx ts-node index.ts lint path=../../data/Scripts --recursive --format=json > ../../linter_report_after.json

# Compare results
python3 ../../tools/analyze_linter_report.py ../../linter_report_after.json
```

## Progress Tracking

| Task | Status | Files Affected | Priority | Owner | Due Date |
|------|--------|---------------|----------|-------|----------|
| Exclude Integrity directory | ⬜ | 5 | P1 | - | - |
| Tag Module files | ⬜ | 17 | P1 | - | - |
| Export clean file lists | ⬜ | 1,678 | P1 | - | - |
| Add library dependencies | ⬜ | 31 | P2 | - | - |
| Validate high-error files | ⬜ | 13 | P2 | - | - |
| Review String directory | ⬜ | 27 | P2 | - | - |
| Setup CI/CD validation | ⬜ | - | P3 | - | - |
| Add metadata system | ⬜ | 1,873 | P3 | - | - |
| Runtime testing | ⬜ | ~100 | P3 | - | - |
| Documentation updates | ⬜ | - | P3 | - | - |

## Success Criteria

- [x] Linter analysis completed
- [x] Reports generated (summary, detailed, findings)
- [x] Analysis script created
- [ ] Priority 1 actions completed
- [ ] 95%+ clean file rate achieved
- [ ] Training dataset assembled
- [ ] Validation pipeline established
- [ ] Documentation updated

## Notes

- Most errors are LSP parser limitations (false positives)
- Core corpus quality is excellent (89.6% clean)
- Focus efforts on high-value directories (BuiltIn, Library)
- Integrity files are intentionally broken (test cases)
- Module files use valid v2.1-alpha syntax

## Reference Files

- Full report: `LINTER_ANALYSIS_REPORT.md`
- Summary: `LINTER_SUMMARY.txt`
- Detailed findings: `LINTER_DETAILED_FINDINGS.md`
- Analysis script: `tools/analyze_linter_report.py`
- Raw data: `linter_full_report.json`

---

**Last Updated:** 2026-01-01
**Next Review:** After Priority 1 actions completed
