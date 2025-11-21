# Research Prompt: AutoHotkey v2 Script Collection and Example Generation

**Objective:** Research, identify, and extract high-quality AutoHotkey v2 scripts from GitHub and other sources to create additional training examples for LLM fine-tuning.

---

## Project Context

This project is building a comprehensive dataset of AutoHotkey v2 examples for LLM training. We currently have:

- **1,015+ existing .ahk example files** covering:
  - Arrays (82 files: library usage, standalone, advanced patterns)
  - Standard Library (95 files: complete built-in function coverage)
  - Hotkeys (74 files: basic to context-sensitive)
  - Hotstrings (10 files: text expansion)
  - Strings (105 files: comprehensive string manipulation)
  - GUI (64 files: graphical interfaces)
  - OOP (72 files: object-oriented patterns)
  - Files (83 files: file system operations)
  - Windows (63 files: window management)
  - Advanced (50 files: design patterns)
  - Module System (17 files: v2-alpha import/export)

- **Comprehensive guides:**
  - `AHK_V2_EXAMPLES_COMPLETE_GUIDE.md`
  - `AHK_V2_ALPHA_MODULE_SYSTEM_GUIDE.md`
  - `GITHUB_SCRAPING_GUIDE.md`

**What we need:** More real-world examples demonstrating AutoHotkey v2 features, especially:
- COM automation (Excel, Word, IE, Chrome automation)
- DllCall patterns (Windows API usage)
- Advanced GUI patterns (modern Gui() class usage)
- HTTP/REST API interactions
- JSON/XML parsing
- Database operations
- Advanced hotkey patterns (#HotIf context-sensitive)
- Automation workflows
- System utilities
- Clipboard management
- Image/screen automation

---

## Your Task

### Phase 1: Research and Identify Sources

1. **Search GitHub repositories** containing AutoHotkey v2 scripts:

   **Primary search queries:**
   ```
   #Requires AutoHotkey v2 language:AutoHotkey
   #Requires AutoHotkey v2.0 language:AutoHotkey
   #Requires AutoHotkey v2.1-alpha language:AutoHotkey
   Gui( language:AutoHotkey
   Map( language:AutoHotkey stars:>5
   class extends Gui language:AutoHotkey
   ```

   **GitHub Code Search URLs:**
   ```
   https://github.com/search?q=%23Requires+AutoHotkey+v2+language%3AAutoHotkey
   https://github.com/search?q=Gui%28+language%3AAutoHotkey+NOT+v1
   https://github.com/search?q=Map%28+language%3AAutoHotkey+stars%3A%3E5
   ```

   **GitHub API Search:**
   ```bash
   curl -H "Accept: application/vnd.github.v3+json" \
     "https://api.github.com/search/code?q=%23Requires+AutoHotkey+v2+language:AutoHotkey&per_page=100"
   ```

2. **Target repositories** (check these first):

   **High-Priority Repositories:**
   - `thqby/ahk2_lib` - Extensive library collection (JSON, HTTP, WebSocket, Chrome)
   - `jNizM/ahk-scripts-v2` - 100+ system utilities and DllCall examples
   - `Descolada/UIA-v2` - UI Automation library with 30+ examples
   - `xypha/AHK-v2-scripts` - 20+ productivity automation scripts
   - `AutoHotkey/AutoHotkeyUX` - Official examples
   - `Lexikos/AutoHotkey_L-Docs` - Documentation with embedded examples
   - `G33kDude/Chrome.ahk` - Chrome automation (check v2 branch)
   - `Pa-0/workingexamples-ah2` - Working v2 examples collection

   **Medium-Priority Repositories:**
   - Search for: `"#Requires AutoHotkey v2" stars:>10`
   - Filter by: Recently updated (2023-2025)
   - Look for: Complete applications that can be broken into examples

3. **Use Google/DuckDuckGo for supplementary searches:**
   ```
   site:github.com "#Requires AutoHotkey v2" filetype:ahk
   site:github.com "AutoHotkey v2" "DllCall" filetype:ahk
   site:github.com "AutoHotkey v2" "ComObject" filetype:ahk
   site:github.com "AutoHotkey v2" "Gui(" filetype:ahk
   site:autohotkey.com/boards "v2" "example"
   ```

### Phase 2: Quality Assessment

For each script/repository found, evaluate:

#### ✅ Include if:
- **Version:** Uses `#Requires AutoHotkey v2.0` or `v2.1-alpha`
- **Syntax:** Pure v2 syntax (Gui(), Map(), class, methods with parentheses)
- **Documentation:** Has comments explaining what it does
- **Size:** 10-500 lines (extractable/focused examples)
- **Completeness:** Self-contained or has clear dependencies
- **Educational Value:** Demonstrates specific v2 features clearly
- **Uniqueness:** Covers features not well-represented in existing examples
- **Quality:** Clean code, good naming, proper error handling

#### ❌ Exclude if:
- **V1 Legacy:** Uses v1 syntax (GUI, GuiControl, no parentheses on commands)
- **Hybrid:** Mixes v1 and v2 syntax inconsistently
- **Too Large:** Full applications >500 lines (unless extractable)
- **Incomplete:** Work-in-progress, non-functional, missing dependencies
- **Undocumented:** No comments, unclear purpose
- **Redundant:** Duplicates existing examples without adding value
- **Poor Quality:** Messy code, bad practices, insecure patterns

### Phase 3: Extract and Categorize

For each high-quality script found:

1. **Download/Clone the repository**
   ```bash
   git clone <repo-url>
   cd <repo-name>
   find . -name "*.ahk" -type f | xargs grep -l "#Requires AutoHotkey v2"
   ```

2. **Categorize by feature** (match existing categories):
   - **COM_** - COM automation (Excel, Word, IE)
   - **DllCall_** - Windows API calls
   - **GUI_Advanced_** - Complex GUI patterns
   - **HTTP_** - Web requests, REST APIs
   - **JSON_** - JSON parsing/generation
   - **Automation_** - Workflow automation
   - **Clipboard_** - Clipboard management
   - **Image_** - Image/screen operations
   - **Database_** - Database operations
   - **RegEx_** - Regular expression patterns
   - **Timer_** - SetTimer patterns
   - **Persistence_** - INI files, settings
   - **Security_** - Encryption, hashing
   - **Networking_** - Socket operations
   - **Threading_** - Async patterns

3. **Extract focused examples:**
   - If script is >200 lines, break into smaller examples
   - Each example should demonstrate 1-3 related features
   - Add educational comments explaining v2-specific patterns
   - Include usage examples in comments

### Phase 4: Create Example Files

For each extracted pattern, create a file following this template:

```autohotkey
#Requires AutoHotkey v2.0
/**
 * [Category]_[Number]_[Description].ahk
 *
 * This example demonstrates:
 * - [Feature 1]
 * - [Feature 2]
 * - [Feature 3]
 *
 * SOURCE: [Repository name/URL]
 * AUTHOR: [Original author if credited]
 * LICENSE: [License if specified]
 *
 * KEY V2 FEATURES USED:
 * - [V2 syntax/feature]
 * - [V2 syntax/feature]
 */

; Clear, self-contained example code here
; With educational comments explaining the patterns

/**
 * USAGE NOTES:
 * - [How to run]
 * - [Expected behavior]
 * - [Any prerequisites]
 */

/**
 * LEARNING POINTS:
 * 1. [What this teaches about AHK v2]
 * 2. [Important pattern or technique]
 * 3. [Common pitfall avoided]
 */
```

---

## Specific Research Tasks

### Task 1: COM Automation Examples (Target: 10-15 examples)

**What to find:**
- Excel automation (create spreadsheets, read/write cells, formatting)
- Word automation (create documents, mail merge)
- Outlook automation (send emails, read inbox)
- Internet Explorer/Edge automation (web scraping, form filling)

**Where to look:**
- Search: `ComObject Excel language:AutoHotkey v2`
- Search: `ComObject Word language:AutoHotkey v2`
- Check: `jNizM/ahk-scripts-v2` COM examples folder

**Expected output:**
```
COM_01_Excel_CreateSpreadsheet.ahk
COM_02_Excel_ReadWriteCells.ahk
COM_03_Excel_Formatting.ahk
COM_04_Word_CreateDocument.ahk
COM_05_Outlook_SendEmail.ahk
COM_06_IE_WebScraping.ahk
...
```

### Task 2: DllCall Windows API Examples (Target: 15-20 examples)

**What to find:**
- System information (GetSystemMetrics, GetVersionEx)
- Window manipulation (SetWindowLong, GetWindowRect)
- Clipboard operations (OpenClipboard, SetClipboardData)
- Registry operations (RegOpenKey, RegQueryValue)
- File operations (CreateFile, ReadFile)
- Keyboard/Mouse hooks
- Buffer management patterns

**Where to look:**
- Repository: `jNizM/ahk-scripts-v2` (has 100+ DllCall examples)
- Search: `DllCall kernel32 language:AutoHotkey v2`
- Search: `Buffer NumPut NumGet language:AutoHotkey`

**Expected output:**
```
DllCall_01_GetSystemMetrics.ahk
DllCall_02_MessageBox.ahk
DllCall_03_PlaySound.ahk
DllCall_04_ClipboardHTML.ahk
DllCall_05_WindowTransparency.ahk
...
```

### Task 3: Advanced GUI Examples (Target: 15-20 examples)

**What to find:**
- Custom controls (owner-drawn buttons, custom listviews)
- Tab controls with dynamic content
- Treeview with icons and drag-drop
- ListView with sorting, filtering, virtual mode
- Modern flat UI designs
- Dark mode implementation
- Custom title bars
- Splash screens with progress
- System tray menus
- Borderless windows with drag
- Multi-monitor support

**Where to look:**
- Search: `class extends Gui language:AutoHotkey v2`
- Search: `AddTreeView AddListView language:AutoHotkey v2`
- Check: `Pa-0/workingexamples-ah2`

**Expected output:**
```
GUI_Advanced_10_CustomControls.ahk
GUI_Advanced_11_TabControlDynamic.ahk
GUI_Advanced_12_TreeViewIcons.ahk
GUI_Advanced_13_ListViewSorting.ahk
GUI_Advanced_14_DarkMode.ahk
GUI_Advanced_15_CustomTitleBar.ahk
...
```

### Task 4: HTTP/REST API Examples (Target: 10 examples)

**What to find:**
- GET/POST/PUT/DELETE requests
- JSON API consumption
- Authentication (API keys, OAuth)
- File uploads/downloads
- WebSocket connections
- Rate limiting patterns

**Where to look:**
- Repository: `thqby/ahk2_lib` - WinHttpRequest examples
- Search: `WinHttpRequest language:AutoHotkey v2`
- Search: `REST API language:AutoHotkey v2`

**Expected output:**
```
HTTP_01_GetRequest.ahk
HTTP_02_PostJSON.ahk
HTTP_03_Authentication.ahk
HTTP_04_FileDownload.ahk
HTTP_05_WebSocket.ahk
...
```

### Task 5: Automation Workflow Examples (Target: 10-15 examples)

**What to find:**
- File batch processing
- Automated backups
- Text file processing
- Screen automation (ImageSearch, PixelSearch)
- Scheduled tasks
- Application launchers
- Window managers

**Where to look:**
- Repository: `xypha/AHK-v2-scripts`
- Search: `automation workflow language:AutoHotkey v2`

**Expected output:**
```
Automation_01_FileBatchRename.ahk
Automation_02_AutoBackup.ahk
Automation_03_TextFileProcessor.ahk
Automation_04_ScreenAutomation.ahk
Automation_05_AppLauncher.ahk
...
```

### Task 6: Context-Sensitive Hotkey Examples (Target: 10 examples)

**What to find:**
- #HotIf WinActive patterns
- #HotIf custom conditions
- Application-specific hotkeys
- Context menus
- Hotkey toggles and modes

**Where to look:**
- Search: `#HotIf WinActive language:AutoHotkey v2`
- Search: `#HotIf GetKeyState language:AutoHotkey v2`

**Expected output:**
```
Hotkey_Advanced_01_AppSpecific.ahk
Hotkey_Advanced_02_CustomConditions.ahk
Hotkey_Advanced_03_HotkeyModes.ahk
Hotkey_Advanced_04_ContextMenus.ahk
...
```

---

## Output Format

### Research Report

Create a markdown file: `AHK_V2_RESEARCH_REPORT_[DATE].md`

```markdown
# AutoHotkey v2 Script Research Report

**Date:** [Date]
**Researcher:** [Name/AI]
**Repositories Analyzed:** [Count]
**Scripts Found:** [Count]
**Examples Created:** [Count]

---

## Summary Statistics

| Category | Scripts Found | Examples Created | Source Repositories |
|----------|---------------|------------------|---------------------|
| COM Automation | X | Y | repo1, repo2 |
| DllCall/WinAPI | X | Y | repo1, repo2 |
| GUI Advanced | X | Y | repo1, repo2 |
| HTTP/API | X | Y | repo1, repo2 |
| ... | ... | ... | ... |

---

## Repository Analysis

### Repository: thqby/ahk2_lib
- **URL:** https://github.com/thqby/ahk2_lib
- **Stars:** [count]
- **Last Updated:** [date]
- **Quality:** ⭐⭐⭐⭐⭐
- **Scripts Found:** [count]
- **Notable Features:**
  - [Feature 1]
  - [Feature 2]
- **Examples Extracted:**
  - `HTTP_01_GetRequest.ahk` (source: lib/WinHttpRequest.ahk)
  - `JSON_01_Parse.ahk` (source: lib/JSON.ahk)
  - ...

### Repository: jNizM/ahk-scripts-v2
- **URL:** https://github.com/jNizM/ahk-scripts-v2
- **Stars:** [count]
- **Last Updated:** [date]
- **Quality:** ⭐⭐⭐⭐⭐
- **Scripts Found:** [count]
- **Notable Features:**
  - [Feature 1]
  - [Feature 2]
- **Examples Extracted:**
  - `DllCall_01_GetSystemMetrics.ahk` (source: src/SystemMetrics.ahk)
  - ...

---

## Examples Created

### COM Automation (X files)
1. `COM_01_Excel_CreateSpreadsheet.ahk` - Creates Excel spreadsheet with formatting
2. `COM_02_Excel_ReadWriteCells.ahk` - Reads/writes Excel cells
3. ...

### DllCall/WinAPI (X files)
1. `DllCall_01_GetSystemMetrics.ahk` - Retrieves system metrics
2. ...

---

## Coverage Gaps Identified

Based on this research, we still need examples for:
- [ ] Advanced clipboard formats (HTML, RTF)
- [ ] Thread/async patterns
- [ ] Advanced regex with callbacks
- [ ] Custom protocols
- ...

---

## Recommendations

1. **Priority 1:** Focus on COM and DllCall examples (high educational value)
2. **Priority 2:** Modern GUI patterns (Gui() class usage)
3. **Priority 3:** HTTP/API examples (real-world applications)

---

## Source Attribution

All examples include proper attribution:
- Source repository URL
- Original author (if credited)
- License information
- Modifications made for educational purposes
```

### Example Files Created

Save files to: `data/raw_scripts/AHK_v2_Examples/`

**Naming Convention:**
```
[Category]_[Number]_[Description].ahk
```

**Examples:**
```
COM_01_Excel_CreateSpreadsheet.ahk
COM_02_Excel_ReadWriteCells.ahk
COM_03_Word_CreateDocument.ahk
DllCall_01_GetSystemMetrics.ahk
DllCall_02_WindowTransparency.ahk
GUI_Advanced_10_DarkMode.ahk
HTTP_01_GetRequest.ahk
Automation_01_FileBatchRename.ahk
```

---

## Quality Checklist

Before submitting each example, verify:

- [ ] **Syntax:** Pure v2 syntax, no v1 legacy code
- [ ] **Header:** Includes `#Requires AutoHotkey v2.0`
- [ ] **Documentation:** Clear JSDoc-style comments
- [ ] **Attribution:** Source repository and author credited
- [ ] **Standalone:** Can run independently or has clear dependencies noted
- [ ] **Educational:** Explains WHY, not just WHAT
- [ ] **Size:** 10-300 lines (sweet spot for learning)
- [ ] **Tested:** Code has been verified to work (or marked as reference)
- [ ] **Unique:** Doesn't duplicate existing examples exactly
- [ ] **Clean:** No hardcoded paths, credentials, or personal data

---

## Success Metrics

**Target Goals:**
- [ ] Find and analyze 20+ repositories
- [ ] Extract 50-100 new examples
- [ ] Cover 10+ categories not well-represented
- [ ] Achieve 80%+ code coverage of major v2 features
- [ ] Document all sources and attributions

**Deliverables:**
1. Research report (markdown)
2. 50-100 example files (.ahk)
3. Updated EXAMPLES_SUMMARY.md with new counts
4. Source attribution document

---

## Tools and Resources

### GitHub Search Tools
- GitHub web interface: https://github.com/search
- GitHub CLI: `gh search code`
- GitHub API: https://api.github.com/search/code

### Analysis Tools
- `ripgrep` for searching: `rg "#Requires AutoHotkey v2" --type ahk`
- `find` for locating: `find . -name "*.ahk"`
- `wc -l` for counting lines: `wc -l *.ahk`

### Reference Documentation
- Official v2 docs: https://www.autohotkey.com/docs/v2/
- Migration guide: https://www.autohotkey.com/docs/v2/v2-changes.htm
- Forums: https://www.autohotkey.com/boards/

---

## Example Research Workflow

1. **Search GitHub:**
   ```bash
   # Clone promising repository
   git clone https://github.com/thqby/ahk2_lib
   cd ahk2_lib

   # Find all v2 scripts
   find . -name "*.ahk" | xargs grep -l "#Requires AutoHotkey v2" > v2_scripts.txt

   # Count lines per script
   while read file; do
     lines=$(wc -l < "$file")
     echo "$lines $file"
   done < v2_scripts.txt | sort -n
   ```

2. **Analyze script quality:**
   - Read through script
   - Check for clear documentation
   - Verify v2 syntax
   - Assess educational value
   - Determine if extractable/self-contained

3. **Extract example:**
   - Copy relevant code
   - Add educational comments
   - Add source attribution
   - Format following template
   - Test if possible
   - Save with proper naming

4. **Document in report:**
   - Add to repository analysis section
   - Update statistics
   - Note any unique features
   - Add to examples created list

---

## Advanced Search Queries

### GitHub Code Search

**Find COM examples:**
```
ComObject("Excel.Application") language:AutoHotkey
ComObject("Word.Application") language:AutoHotkey
ComObjCreate language:AutoHotkey v2
```

**Find DllCall examples:**
```
DllCall("kernel32\") language:AutoHotkey v2
Buffer(, 0) NumPut language:AutoHotkey
VarSetStrCapacity language:AutoHotkey v2
```

**Find GUI examples:**
```
class extends Gui language:AutoHotkey
AddButton AddEdit AddText language:AutoHotkey v2
OnEvent("Click" language:AutoHotkey
```

**Find modern patterns:**
```
Map() language:AutoHotkey v2 stars:>5
class has Prototype language:AutoHotkey
=> { language:AutoHotkey v2
```

### Google Search Queries

```
site:github.com "AutoHotkey v2" "COM automation"
site:github.com "AutoHotkey v2" "DllCall" "Windows API"
site:github.com "#Requires AutoHotkey v2" "class"
site:autohotkey.com/boards "v2" "example" "working"
```

---

## Notes for AI Researchers

If you're an AI conducting this research:

1. **Use WebSearch and WebFetch tools** to find and retrieve scripts
2. **Clone repositories** when needed using Bash tool
3. **Read files** using Read tool to analyze scripts
4. **Create examples** using Write tool with proper templates
5. **Track progress** using TodoWrite tool
6. **Generate report** as markdown file
7. **Commit results** with clear messages

**Suggested workflow:**
```
1. WebSearch for repositories
2. WebFetch repository READMEs
3. Bash to clone repositories
4. Glob to find .ahk files
5. Grep to filter for v2 scripts
6. Read to analyze quality
7. Write to create examples
8. Update research report
9. Commit and push results
```

---

## Final Deliverables Checklist

- [ ] Research report markdown file
- [ ] 50-100 new example files
- [ ] All examples properly attributed
- [ ] Examples categorized and numbered
- [ ] Quality verified for each example
- [ ] Documentation headers complete
- [ ] Updated EXAMPLES_SUMMARY.md
- [ ] Git commit with clear message
- [ ] No duplicate examples
- [ ] No v1 syntax in examples

---

**Ready to Start?**

Begin with Phase 1: Research repositories, focusing on the high-priority list.
Document everything you find.
Extract examples systematically.
Maintain quality over quantity.

Good luck! 🚀
