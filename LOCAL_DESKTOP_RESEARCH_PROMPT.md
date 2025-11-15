# Local Desktop Research Prompt: AutoHotkey v2 Script Collection

**Objective:** Scan local AutoHotkey scripts from `C:\Users\uphol\Documents\Design\Coding\AHK\!Running\` and extract high-quality AutoHotkey v2 examples for LLM training, saving them to `C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\`.

---

## Project Context

This is a **desktop file research project** that analyzes your personal/local AutoHotkey script collection to:
- Identify v2-compatible scripts
- Extract educational examples
- Categorize by functionality
- Create training dataset from real-world code you've already written

**Source Directory:** `C:\Users\uphol\Documents\Design\Coding\AHK\!Running\`
**Output Directory:** `C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\`

---

## Your Task

### Phase 1: Scan and Inventory Local Scripts

1. **Recursively scan source directory** for all `.ahk` files:
   ```bash
   # PowerShell
   Get-ChildItem -Path "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\" -Filter "*.ahk" -Recurse

   # Command Prompt
   dir "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\*.ahk" /s /b

   # Using AutoHotkey itself
   Loop Files, C:\Users\uphol\Documents\Design\Coding\AHK\!Running\*.ahk, R
       FileList .= A_LoopFileFullPath "`n"
   ```

2. **Create initial inventory:**
   - Count total .ahk files found
   - Get file sizes
   - Check last modified dates
   - List file paths

3. **Quick filter for v2 scripts:**
   - Search for `#Requires AutoHotkey v2`
   - Look for v2 syntax markers: `Gui(`, `Map(`, `class ClassName {`
   - Flag v1 syntax: `Gui, Add`, `MsgBox,`, `StringSplit,`

---

### Phase 2: Analyze Each Script

For each `.ahk` file found, analyze:

#### **Version Detection**

**✅ AutoHotkey v2 indicators:**
- Contains: `#Requires AutoHotkey v2.0` or `v2.1-alpha`
- Uses: `Gui()`, `Map()`, `MsgBox()` (with parentheses)
- Has: `class ClassName {` with methods using `this.`
- Uses: `=>` (fat arrow functions)
- Has: `#HotIf` (not `#If`)

**❌ AutoHotkey v1 indicators:**
- Contains: `Gui, Add,`, `MsgBox,`, `StringSplit,`
- Uses: `#If` (old syntax)
- Has: Commands without parentheses
- Uses: `%variables%` everywhere
- Has: `:=` for expressions but `,` for commands

**⚠️ Hybrid/Convertible:**
- Can be easily converted to v2
- Minimal v1-specific syntax
- Worth converting and including

#### **Quality Assessment**

**Size:**
- ✅ Small (10-100 lines): Perfect for single-concept examples
- ✅ Medium (100-300 lines): Good for complete utilities
- ⚠️ Large (300-1000 lines): Extract specific functions/classes
- ❌ Very Large (1000+ lines): Too complex, skip or extract key parts

**Documentation:**
- ✅ Has comments explaining functionality
- ✅ Has function/class documentation
- ⚠️ Minimal comments but code is clear
- ❌ No comments and unclear purpose

**Code Quality:**
- ✅ Clean, well-organized code
- ✅ Proper error handling
- ✅ Good variable/function names
- ⚠️ Works but could be cleaner
- ❌ Messy, hard to understand

**Educational Value:**
- ✅ Demonstrates specific v2 features
- ✅ Shows real-world problem-solving
- ✅ Uses interesting patterns/techniques
- ⚠️ Basic but useful
- ❌ Too simple or redundant

#### **Feature Detection**

Scan for these features to categorize:

**GUI Features:**
- `Gui()`, `AddButton`, `AddEdit`, `AddListView`, `AddTreeView`
- `OnEvent(`, `Show(`, `Destroy(`
- Custom GUI classes

**Hotkeys/Hotstrings:**
- `::` hotkey definitions
- `#HotIf` context-sensitive hotkeys
- `Hotkey()` function
- Hotstring definitions

**File Operations:**
- `FileRead`, `FileAppend`, `FileOpen`
- `DirCreate`, `DirCopy`, `DirMove`
- `Loop Files`, `Loop Read`

**Window/Process:**
- `WinActivate`, `WinWait`, `WinMove`
- `ProcessExist`, `ProcessClose`, `Run`
- Window manipulation

**COM Automation:**
- `ComObject(`, `ComObjCreate(`
- Excel, Word, Outlook, IE automation

**DllCall/Windows API:**
- `DllCall("kernel32\`, `DllCall("user32\`
- `Buffer(`, `NumPut`, `NumGet`
- Windows API integration

**Advanced Features:**
- Classes and OOP
- Events and callbacks
- Async patterns
- Module system (`#Module`, `Import`, `Export`)

---

### Phase 3: Extract and Categorize

#### **Categorization System**

Based on features detected, categorize into:

| Category | Prefix | Examples |
|----------|--------|----------|
| **Hotkeys** | `Hotkey_Local_` | Context-sensitive, app-specific |
| **Hotstrings** | `Hotstring_Local_` | Text expansion, auto-correct |
| **GUI Applications** | `GUI_Local_` | Complete GUI apps |
| **File Automation** | `File_Local_` | File processing, batch operations |
| **Window Management** | `Window_Local_` | Window arranging, always-on-top |
| **COM Automation** | `COM_Local_` | Excel, Word, Outlook |
| **DllCall/WinAPI** | `DllCall_Local_` | Windows API calls |
| **Clipboard Tools** | `Clipboard_Local_` | Clipboard management |
| **System Utilities** | `System_Local_` | System info, settings |
| **Automation** | `Automation_Local_` | Workflows, batch tasks |
| **OOP Examples** | `OOP_Local_` | Class-based designs |
| **Module Examples** | `Module_Local_` | v2-alpha modules |
| **Productivity** | `Productivity_Local_` | Personal productivity tools |
| **Web/HTTP** | `Web_Local_` | HTTP requests, APIs |
| **Games/Fun** | `Fun_Local_` | Games, experiments |

#### **Extraction Rules**

**For small scripts (10-100 lines):**
1. Copy entire script
2. Add documentation header
3. Note source file path
4. Save to Training folder

**For medium scripts (100-300 lines):**
1. Copy entire script if self-contained
2. OR extract main functionality into focused example
3. Add documentation
4. Save to Training folder

**For large scripts (300+ lines):**
1. Extract individual functions/classes
2. Create separate examples for each major feature
3. Document extracted context
4. Save multiple files to Training folder

---

### Phase 4: Create Training Examples

#### **File Naming Convention**

```
[Category]_Local_[Number]_[Description].ahk
```

**Examples:**
```
Hotkey_Local_01_WindowSnapToCorners.ahk
GUI_Local_01_QuickNotepad.ahk
File_Local_01_BatchRenamer.ahk
COM_Local_01_ExcelReporter.ahk
Automation_Local_01_DailyBackup.ahk
```

#### **Standard Header Template**

```autohotkey
#Requires AutoHotkey v2.0
/**
 * [Category]_Local_[Number]_[Description].ahk
 *
 * DESCRIPTION:
 * [What this script does]
 *
 * FEATURES:
 * - [Feature 1]
 * - [Feature 2]
 * - [Feature 3]
 *
 * SOURCE:
 * Extracted from: [Original file path]
 * Original filename: [Original filename]
 * Date extracted: [Date]
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - [V2 syntax/feature used]
 * - [V2 syntax/feature used]
 *
 * USAGE:
 * [How to use this script]
 *
 * NOTES:
 * [Any important notes or modifications made]
 */

; Script code here
```

#### **Conversion Notes**

If script was v1 and converted:
```autohotkey
/**
 * CONVERSION NOTES:
 * - Converted from v1 to v2
 * - Changed [specific v1 syntax] to [v2 equivalent]
 * - Modernized [specific pattern]
 * - Tested on: [date]
 */
```

---

### Phase 5: Generate Research Report

Create: `C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\RESEARCH_REPORT.md`

```markdown
# Local AutoHotkey Script Research Report

**Date:** [Date]
**Source Directory:** C:\Users\uphol\Documents\Design\Coding\AHK\!Running\
**Output Directory:** C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\

---

## Summary Statistics

| Metric | Count |
|--------|-------|
| Total .ahk files found | X |
| AutoHotkey v2 scripts | X |
| AutoHotkey v1 scripts | X |
| Hybrid/Convertible scripts | X |
| Examples extracted | X |
| Categories covered | X |

---

## File Inventory

### All Scripts Found

| File Path | Size (lines) | Version | Quality | Status |
|-----------|--------------|---------|---------|--------|
| path/to/script1.ahk | 150 | v2 | ⭐⭐⭐⭐⭐ | ✅ Extracted |
| path/to/script2.ahk | 45 | v2 | ⭐⭐⭐⭐ | ✅ Extracted |
| path/to/script3.ahk | 500 | v1 | ⭐⭐⭐ | ⚠️ Converted |
| path/to/script4.ahk | 1200 | v2 | ⭐⭐⭐⭐ | ⚠️ Partial extract |
| path/to/script5.ahk | 30 | v1 | ⭐⭐ | ❌ Skipped |

---

## Category Breakdown

### Hotkeys (X examples extracted)
1. `Hotkey_Local_01_WindowSnapToCorners.ahk` (from: scripts/window-snap.ahk)
2. `Hotkey_Local_02_AppLauncher.ahk` (from: productivity/launcher.ahk)
...

### GUI Applications (X examples extracted)
1. `GUI_Local_01_QuickNotepad.ahk` (from: tools/notepad.ahk)
...

### File Automation (X examples extracted)
...

---

## Notable Scripts

### High-Quality Examples
- **path/to/excellent-script.ahk**
  - Features: [features]
  - Why notable: [reason]
  - Extracted as: [output files]

### Conversion Candidates
- **path/to/v1-script.ahk**
  - Currently v1
  - Conversion effort: Easy/Medium/Hard
  - Worth converting: Yes/No
  - Reason: [reason]

---

## Feature Coverage

| Feature Category | Examples Found |
|------------------|----------------|
| GUI (Gui class) | X |
| Hotkeys (#HotIf) | X |
| File Operations | X |
| COM Automation | X |
| DllCall/WinAPI | X |
| Classes/OOP | X |
| Module System | X |
| HTTP/Web | X |
| Clipboard | X |
| System Utils | X |

---

## Conversion Summary

### Scripts Converted from v1 to v2

| Original File | Output File | Conversion Notes |
|---------------|-------------|------------------|
| old-script.ahk | Hotkey_Local_03.ahk | Changed Gui, to Gui() |
| ... | ... | ... |

---

## Quality Distribution

| Quality Rating | Count | Percentage |
|----------------|-------|------------|
| ⭐⭐⭐⭐⭐ (Excellent) | X | X% |
| ⭐⭐⭐⭐ (Good) | X | X% |
| ⭐⭐⭐ (Average) | X | X% |
| ⭐⭐ (Below Average) | X | X% |
| ⭐ (Poor) | X | X% |

---

## Directory Structure Created

```
C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\
├── RESEARCH_REPORT.md
├── Hotkey_Local_01_WindowSnapToCorners.ahk
├── Hotkey_Local_02_AppLauncher.ahk
├── GUI_Local_01_QuickNotepad.ahk
├── File_Local_01_BatchRenamer.ahk
├── COM_Local_01_ExcelReporter.ahk
└── ... (additional examples)
```

---

## Recommendations

### Scripts Worth Expanding
- [Script name]: Could be broken into [X] separate examples
- [Script name]: Demonstrates [feature], should be documented better

### Conversion Priorities
1. [v1 script]: Easy conversion, high educational value
2. [v1 script]: Medium effort, unique features

### Gaps Identified
Based on local scripts, we have good coverage of:
- [Category]
- [Category]

We are missing or weak in:
- [Category]
- [Category]

---

## Next Steps

1. Review extracted examples for quality
2. Test converted v1 scripts
3. Add missing documentation where needed
4. Consider converting high-value v1 scripts
5. Integrate with main training dataset
```

---

## Automation Script

Create this script to automate the process:

**File:** `C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\_ResearchScanner.ahk`

```autohotkey
#Requires AutoHotkey v2.0
/**
 * Local Script Research Scanner
 *
 * Scans local AHK scripts and extracts v2 examples
 */

#SingleInstance Force

; Configuration
SOURCE_DIR := "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\"
OUTPUT_DIR := "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\"

; Ensure output directory exists
if !DirExist(OUTPUT_DIR)
    DirCreate(OUTPUT_DIR)

; Results tracking
totalFiles := 0
v2Files := 0
v1Files := 0
extractedCount := 0
results := []

; Scan directory
MsgBox("Scanning: " SOURCE_DIR "`n`nThis may take a moment...", "Script Scanner", "Icon!")

Loop Files, SOURCE_DIR "*.ahk", "R"
{
    totalFiles++

    ; Read file
    try {
        content := FileRead(A_LoopFileFullPath)
    } catch {
        continue
    }

    ; Detect version
    isV2 := InStr(content, "#Requires AutoHotkey v2")
         || InStr(content, "Gui(")
         || InStr(content, "Map(")

    isV1 := InStr(content, "Gui, Add,")
         || InStr(content, "MsgBox,")
         || RegExMatch(content, "i)\b(StringSplit|IfEqual|SetEnv)\b")

    ; Categorize
    version := isV2 ? "v2" : (isV1 ? "v1" : "unknown")

    if version = "v2"
        v2Files++
    else if version = "v1"
        v1Files++

    ; Get file info
    lines := CountLines(content)

    ; Determine quality (simple heuristic)
    hasComments := InStr(content, "/**") || InStr(content, ";")
    quality := hasComments ? 4 : 3

    ; Store result
    results.Push({
        path: A_LoopFileFullPath,
        filename: A_LoopFileName,
        size: lines,
        version: version,
        quality: quality,
        content: content
    })
}

; Generate report
report := "# Local AutoHotkey Script Research Report`n`n"
report .= "**Date:** " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
report .= "**Source Directory:** " SOURCE_DIR "`n"
report .= "**Output Directory:** " OUTPUT_DIR "`n`n"
report .= "---`n`n"
report .= "## Summary Statistics`n`n"
report .= "| Metric | Count |`n"
report .= "|--------|-------|`n"
report .= "| Total .ahk files found | " totalFiles " |`n"
report .= "| AutoHotkey v2 scripts | " v2Files " |`n"
report .= "| AutoHotkey v1 scripts | " v1Files " |`n"
report .= "| Examples extracted | " extractedCount " |`n`n"
report .= "---`n`n"
report .= "## File Inventory`n`n"
report .= "| File Path | Size (lines) | Version | Quality |`n"
report .= "|-----------|--------------|---------|---------|`n"

for result in results {
    stars := ""
    Loop result.quality
        stars .= "⭐"

    report .= "| " result.path " | " result.size " | " result.version " | " stars " |`n"
}

; Save report
reportPath := OUTPUT_DIR "RESEARCH_REPORT.md"
try {
    FileDelete(reportPath)
} catch {
}
FileAppend(report, reportPath)

; Show results
MsgBox("Scan Complete!`n`n"
     . "Total files: " totalFiles "`n"
     . "V2 scripts: " v2Files "`n"
     . "V1 scripts: " v1Files "`n`n"
     . "Report saved to:`n" reportPath,
     "Scan Results", "Icon!")

; Open report
Run(reportPath)

CountLines(text) {
    count := 1
    Loop Parse, text, "`n", "`r"
        count++
    return count
}
```

---

## Manual Execution Steps

If running manually (not using automation script):

### **Step 1: Find All Scripts**
```powershell
# PowerShell - Get file list
$files = Get-ChildItem -Path "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\" -Filter "*.ahk" -Recurse
$files | Export-Csv -Path "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\file_list.csv"
```

### **Step 2: Check Each Script**
```powershell
# PowerShell - Check for v2 syntax
foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "#Requires AutoHotkey v2") {
        Write-Host "V2: $($file.Name)" -ForegroundColor Green
    } elseif ($content -match "Gui, Add,|MsgBox,") {
        Write-Host "V1: $($file.Name)" -ForegroundColor Yellow
    } else {
        Write-Host "Unknown: $($file.Name)" -ForegroundColor Gray
    }
}
```

### **Step 3: Extract Examples**
For each quality v2 script:
1. Open in editor
2. Copy content
3. Add documentation header
4. Save to Training folder with proper naming
5. Update research report

---

## Quality Checklist

Before saving each extracted example:

- [ ] **Version verified:** Is it v2 or properly converted?
- [ ] **Header added:** Documentation template filled out
- [ ] **Source attributed:** Original file path noted
- [ ] **Self-contained:** Runs independently or dependencies noted
- [ ] **Categorized:** Saved with correct category prefix
- [ ] **Named properly:** Follows naming convention
- [ ] **Tested:** Verified to work (if possible)
- [ ] **Documented:** Comments explain key features
- [ ] **Clean:** Removed personal paths, passwords, sensitive data

---

## Success Metrics

**Target Goals:**
- [ ] Scan entire source directory (recursive)
- [ ] Identify all v2 scripts
- [ ] Extract 20-50 quality examples
- [ ] Cover 5+ categories
- [ ] Generate complete research report
- [ ] All examples properly documented and categorized

**Deliverables:**
1. Research report (RESEARCH_REPORT.md)
2. 20-50 extracted example files
3. File inventory with version and quality ratings
4. Category breakdown

---

## Tips for Best Results

1. **Start with v2 scripts** - Easiest to extract
2. **Look for small utilities** - Best learning examples
3. **Extract from large scripts** - Break down complex apps into focused examples
4. **Convert high-value v1 scripts** - If educational and not too complex
5. **Document everything** - Future you will thank you
6. **Test when possible** - Ensure examples actually work
7. **Clean up code** - Remove personal data, improve comments
8. **Organize by category** - Makes dataset more useful

---

## Common Issues and Solutions

**Issue:** Script uses hardcoded paths
- **Solution:** Replace with `A_ScriptDir` or add note in documentation

**Issue:** Script has external dependencies
- **Solution:** Note dependencies in header, or include them if small

**Issue:** Script is too large
- **Solution:** Extract key functions/classes into separate examples

**Issue:** Unclear what script does
- **Solution:** Run it (carefully) or skip if too risky

**Issue:** Script is v1 but valuable
- **Solution:** Convert to v2 using migration guide, document conversion

---

## Final Output Structure

```
C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\
│
├── RESEARCH_REPORT.md                          (Main research report)
├── _ResearchScanner.ahk                        (Automation script)
│
├── Hotkey_Local_01_[Description].ahk
├── Hotkey_Local_02_[Description].ahk
├── GUI_Local_01_[Description].ahk
├── File_Local_01_[Description].ahk
├── COM_Local_01_[Description].ahk
├── Automation_Local_01_[Description].ahk
└── ... (more examples organized by category)
```

---

**Ready to Start!**

Run the automation script or follow manual steps to begin extracting your local AutoHotkey scripts into a training dataset.

Your personal scripts are valuable training data - let's preserve and organize them! 🚀
