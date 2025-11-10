# GitHub Scraping Guide for AHK v2 Examples

## Summary of Current Results

Successfully extracted **6 real-world examples** from GitHub repositories:

1. **CreateGUID** - Windows API calls, Buffer management
2. **WinExist Patterns** - Window detection, negation syntaxes
3. **Notification GUI** - Custom borderless windows, timers
4. **CSV Parser** - Class structure, string processing
5. **Buffer Management** - Memory allocation, NumPut/NumGet
6. **Timer Patterns** - SetTimer variations, closures

## GitHub Search Strategies

### Method 1: GitHub Code Search (Web Interface)

**Search Query:**
```
#Requires AutoHotkey v2 language:AutoHotkey
```

**Filters:**
- File extension: `.ahk`
- Sort by: Recently indexed, Most stars, Best match
- Advanced: `size:<1000` for smaller, focused examples

### Method 2: GitHub API Search

**API Endpoint:**
```
https://api.github.com/search/code?q=%23Requires+AutoHotkey+v2+extension:ahk
```

**Additional Parameters:**
- `sort=indexed` - Recently added files
- `per_page=100` - Max results per page
- `q=path:examples` - Files in examples directories

### Method 3: Google Search

**Search Queries:**
```
site:github.com "#Requires AutoHotkey v2.0" filetype:ahk
site:raw.githubusercontent.com "#Requires AutoHotkey v2"
"#SingleInstance Force" "#Requires AutoHotkey v2" site:github.com
```

### Method 4: Specific Repository Patterns

**Target Repositories:**
```
jNizM/ahk-scripts-v2 - 100+ utility functions
Descolada/UIA-v2 - UI Automation examples
thqby/ahk2_lib - Advanced libraries
G33kDude repositories - Web/network examples
mmikeww/AHK-v2-script-converter - Migration examples
```

## Useful Search Terms by Category

### GUI Examples:
```
"#Requires AutoHotkey v2" "Gui(" OR "Gui.Add"
"#Requires AutoHotkey v2" "MyGui.Show"
```

### Hotkey Examples:
```
"#Requires AutoHotkey v2" "::" hotkey
"#Requires AutoHotkey v2" "#HotIf"
```

### Class Examples:
```
"#Requires AutoHotkey v2" "class " "__New"
"#Requires AutoHotkey v2" "class " "static"
```

### DllCall Examples:
```
"#Requires AutoHotkey v2" "DllCall("
"#Requires AutoHotkey v2" "ComCall("
```

### File Operations:
```
"#Requires AutoHotkey v2" "FileRead" OR "FileOpen"
"#Requires AutoHotkey v2" "Loop Files"
```

## Repositories with Rich Examples

| Repository | Focus Area | Example Count |
|------------|------------|---------------|
| jNizM/ahk-scripts-v2 | System utilities | 100+ |
| thqby/ahk2_lib | Advanced libraries | 50+ |
| Descolada/UIA-v2 | UI Automation | 30+ |
| xypha/AHK-v2-scripts | Practical automation | 20+ |
| AutoHotkey/AutoHotkeyUX | Official installer | 10+ |

## Automated Scraping Approach

### Step 1: Get Repository List
```bash
# Search GitHub API for repos with AHK v2 files
curl "https://api.github.com/search/repositories?q=autohotkey+v2+language:AutoHotkey&sort=stars"
```

### Step 2: Clone Target Repositories
```bash
git clone https://github.com/jNizM/ahk-scripts-v2
git clone https://github.com/thqby/ahk2_lib
git clone https://github.com/Descolada/UIA-v2
```

### Step 3: Find v2 Scripts
```bash
# Find all AHK v2 scripts in cloned repos
find . -name "*.ahk" -exec grep -l "#Requires AutoHotkey v2" {} \;

# Get file sizes to find focused examples (not full applications)
find . -name "*.ahk" -exec grep -l "#Requires AutoHotkey v2" {} \; -exec wc -l {} \; | awk '$1 < 200'
```

### Step 4: Extract by Pattern

**For GUI examples:**
```bash
grep -r "#Requires AutoHotkey v2" --include="*.ahk" -l | xargs grep -l "Gui("
```

**For DllCall examples:**
```bash
grep -r "#Requires AutoHotkey v2" --include="*.ahk" -l | xargs grep -l "DllCall("
```

## Quality Filters

**Prefer files that:**
- Have clear comments/documentation
- Are < 200 lines (focused examples)
- Include practical use cases
- Show modern AHK v2 syntax
- Have minimal dependencies

**Avoid files that:**
- Are full applications (>500 lines)
- Have many includes/dependencies
- Are incomplete or experimental
- Lack documentation
- Are v1 compatibility scripts

## Extraction Categories

### High Priority:
1. **Window Management** - WinExist, WinActivate, WinMove patterns
2. **Hotkeys** - Modern hotkey syntax, #HotIf conditionals
3. **GUI Creation** - Gui() class, events, controls
4. **File I/O** - FileRead, FileOpen, Loop Files patterns
5. **DllCall** - Windows API usage patterns

### Medium Priority:
6. **String Manipulation** - StrSplit, RegEx, Format()
7. **Array Operations** - Modern array methods
8. **Object/Map** - Map(), object literals, iteration
9. **Timers** - SetTimer patterns, callbacks
10. **COM Objects** - ComObject, ComCall usage

### Lower Priority:
11. **Network** - HTTP requests, WebSocket
12. **Database** - SQL, SQLite patterns
13. **Advanced OOP** - Inheritance, static methods
14. **UI Automation** - UIA library examples

## Next Steps for Automation

### Option 1: Manual Curation
- Review top 10 repositories
- Extract 5-10 examples from each
- Create standalone example files
- Document patterns found

### Option 2: Semi-Automated
- Clone repositories to `Lib/` folder
- Use grep to find specific patterns
- Extract matching code blocks
- Create examples with attribution

### Option 3: Fully Automated (Future)
- GitHub API integration
- Pattern recognition
- Automatic categorization
- Example generation

## Example Statistics

**Current Collection:**
- Standard library: 95 examples
- Array operations: 82 examples (basic + standalone + advanced)
- GitHub extracted: 6 examples
- **Total: 183 examples**

**GitHub Examples Found:**
- jNizM repository: 100+ functions available
- Other sources: 200+ potential examples
- **Potential: 300+ more examples**

## Recommended Immediate Actions

1. **Clone jNizM/ahk-scripts-v2** - Richest source of utilities
2. **Extract 20 focused examples** from different categories
3. **Create DllCall pattern examples** - Advanced Windows API usage
4. **Add COM examples** - Excel, IE automation patterns
5. **Extract GUI builder patterns** - Modern Gui() usage

## Search Commands Quick Reference

```bash
# Find small focused examples
find . -name "*.ahk" -size -10k -exec grep -l "#Requires AutoHotkey v2" {} \;

# Find by category
grep -r "DllCall(" --include="*.ahk" -A 5 -B 2

# Count examples per category
grep -r "#Requires AutoHotkey v2" --include="*.ahk" | wc -l
```
