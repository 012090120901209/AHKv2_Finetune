# Popular AutoHotkey v2 GitHub Libraries & Repositories Guide

**A comprehensive compilation of the most popular and useful AHK v2 libraries available on GitHub**

---

## Table of Contents

1. [Quick Overview](#quick-overview)
2. [Repository Comparison Matrix](#repository-comparison-matrix)
3. [Detailed Repository Descriptions](#detailed-repository-descriptions)
4. [Libraries by Category](#libraries-by-category)
5. [Getting Started](#getting-started)
6. [Recommended Combinations](#recommended-combinations)

---

## Quick Overview

This guide compiles **11 major AutoHotkey v2 repositories** from the GitHub community, providing a centralized resource for finding libraries, utilities, and tools for your AHK v2 projects.

### Repository Statistics Summary

| Repository | Stars | Status | Primary Focus |
|------------|-------|--------|---------------|
| thqby/ahk2_lib | 410 | Active | Comprehensive utilities & system integration |
| Descolada/AHK-v2-libraries | ~100+ | Active | Utility functions & accessibility |
| Masonjar13/AHK-Library | 82 | Active | Standard library with 70+ functions |
| pa-0/ahk.v2libraries-classes | - | Active | Curated collection with documentation |
| Nich-Cebolla/AutoHotkey-LibV2 | - | Active | Well-documented reusable code |
| Autumn-one/ahk-standard-lib | 19 | Active | Enhanced data structure operations |
| hyaray/ahk_v2_lib | 25 | Maintained | Pre-compiled with built-in methods |
| pa-0/ahk.lib.user.v2 | - | Active | Personal utility collection |
| abgox/AHK_lib | 1 | Active | Array & string utilities |
| YooperTuber/AHK_lib-v2 | - | **NOT MAINTAINED** | Runner-style framework |
| flipeador/Library-AutoHotkey | - | **ARCHIVED (2020)** | Historical reference |

---

## Repository Comparison Matrix

### Feature Availability

| Feature Category | thqby | Descolada | Masonjar13 | pa-0 v2classes | Nich-Cebolla | Autumn-one | hyaray | pa-0 user | abgox |
|-----------------|-------|-----------|------------|----------------|--------------|------------|--------|-----------|-------|
| **Data Structures** | ✅✅ | ✅✅ | ✅ | ✅ | ✅ | ✅✅ | ✅ | ✅ | ✅ |
| **String Operations** | ✅ | ✅✅ | ✅✅ | ✅ | ✅✅ | ✅✅ | ✅ | ✅ | ✅✅ |
| **Array Functions** | ✅ | ✅✅ | ✅✅ | ✅ | ✅ | ✅✅ | ✅ | ✅ | ✅✅ |
| **GUI Components** | ✅ | ❌ | ✅ | ✅✅ | ✅✅ | ❌ | ❌ | ✅ | ❌ |
| **Network/HTTP** | ✅✅ | ❌ | ✅✅ | ✅✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **File Operations** | ✅✅ | ❌ | ✅✅ | ✅ | ✅✅ | ✅ | ❌ | ✅ | ❌ |
| **System/Windows API** | ✅✅ | ❌ | ✅✅ | ✅ | ✅ | ❌ | ✅ | ✅✅ | ❌ |
| **UI Automation** | ✅✅ | ✅✅ | ✅ | ✅✅ | ❌ | ❌ | ❌ | ✅✅ | ❌ |
| **Database** | ✅✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Graphics/Vision** | ✅✅ | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ | ✅✅ | ❌ |
| **Browser Automation** | ✅✅ | ❌ | ❌ | ✅✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **COM/CLR** | ✅✅ | ❌ | ✅ | ✅✅ | ❌ | ❌ | ❌ | ✅ | ❌ |

Legend: ✅✅ = Extensive support | ✅ = Basic support | ❌ = Not available

---

## Detailed Repository Descriptions

### 1. **thqby/ahk2_lib** ⭐ MOST COMPREHENSIVE

**GitHub**: https://github.com/thqby/ahk2_lib
**Stars**: 410 | **Files**: 73 | **License**: MIT

#### Overview
The most comprehensive utility library for AHK v2, providing extensive functionality across multiple domains.

#### Key Features

**Data Handling:**
- JSON parsing
- YAML processing
- Base64 encoding
- Deep cloning
- Struct definitions
- Heap & sorting algorithms

**Network & Communication:**
- HTTP server implementation
- WebSocket support
- Async downloads
- SMTP client
- TLS authentication
- Socket support

**System Integration:**
- Comprehensive WinAPI bindings
- UIAutomation framework
- DWM thumbnails
- Registry access
- Process management
- Directory watching

**Advanced Features:**
- SQLite integration
- OpenCV bindings
- RapidOcr support
- GDI+ wrapper (CGdip)
- Audio processing
- Chrome automation
- Promise implementation

#### Best For
Projects requiring deep system integration, advanced networking, database functionality, or computer vision capabilities.

---

### 2. **Descolada/AHK-v2-libraries** ⭐ BEST FOR FUNCTIONAL PROGRAMMING

**GitHub**: https://github.com/Descolada/AHK-v2-libraries
**Stars**: ~100+ | **License**: MIT

#### Overview
Collection of utility libraries focused on functional programming patterns and accessibility.

#### Key Libraries

**Misc.ahk** - Foundational utilities:
- `Range(start, stop, step)` - Python-like range iteration
- `RegExMatchAll()` - Get all regex matches as array
- `Swap(var1, var2)` - Exchange variable values
- `Print()` - Formatted output for any data type

**String.ahk** - Chainable string methods:
- Native operations: `ToUpper`, `Replace`, `Trim`
- Custom operations: `LineWrap`, `Reverse`, `Contains`
- Object-like method chaining

**Array.ahk** - Functional array operations:
- `Map`, `Filter`, `Reduce`
- `Slice`, `IndexOf`, `Sort`
- `Shuffle`, `Flat`, `Extend`

**Acc.ahk** - Accessibility support:
- Array-like element objects
- Object-oriented methods
- `FindFirst`, `FindAll` navigation
- Built-in AccViewer diagnostics

#### Submodules
- Acc-v2
- UIA-v2
- OCR libraries

#### Best For
Developers who prefer functional programming patterns, need accessibility automation, or want clean chainable APIs.

---

### 3. **Masonjar13/AHK-Library** ⭐ BEST ALL-AROUND STANDARD LIBRARY

**GitHub**: https://github.com/Masonjar13/AHK-Library
**Stars**: 82 | **Forks**: 20 | **License**: MIT

#### Overview
Personal standard library with 70+ functions, 4 classes, and extensive utility coverage.

#### Functions (70+)

**String Manipulation:**
- Binary search, case inversion, formatting
- String serialization and processing

**System Operations:**
- Window management (borderless, click-drag)
- DPI offset calculation
- Process monitoring and priority control

**Network:**
- IP retrieval
- Connectivity checks
- GitHub release downloads
- Network adapter control

**File Operations:**
- Image size retrieval
- File system utilities

**Audio:**
- Per-application volume mixing
- Mute toggling

#### Classes (4)

1. **Database** - Key-value storage management
2. **IE** - Internet Explorer COM wrapper with error handling
3. **Threading** - Multi-threading via AutoHotkey.dll
4. **AudioRouter** - Advanced audio control

#### Best For
General-purpose automation, audio control, window management, and network operations.

---

### 4. **pa-0/ahk.v2libraries-classes** ⭐ BEST CURATED COLLECTION

**GitHub**: https://github.com/pa-0/ahk.v2libraries-classes

#### Overview
Curated collection with added documentation, examples, and English translations.

#### Key Areas

**Data Processing:**
- JSON manipulation
- Array/object handling
- String operations

**Network:**
- HTTP requests
- Downloads
- Socket communication

**GUI Development:**
- WebView2 integration (Chromium-based)
- Neutron.ahk (HTML/CSS/JS GUIs)
- Easy AutoGUI
- Responsive layouts
- Theme customization

**Browser Automation:**
- Chrome.ahk - Full Chrome control

**System Integration:**
- UIAutomation v2
- .NET/CLR interoperability
- Clipboard management

**Development Tools:**
- AHKv1 to v2 script converter
- Comprehensive positioning guide

#### Notable Libraries
- JSON.ahk
- WinHttpRequest.ahk
- Socket.ahk
- DownloadAsync.ahk
- WebView2.ahk
- Chrome.ahk
- CLR.ahk

#### Best For
GUI development with modern web technologies, browser automation, and projects needing well-documented code.

---

### 5. **Nich-Cebolla/AutoHotkey-LibV2** ⭐ BEST DOCUMENTATION

**GitHub**: https://github.com/Nich-Cebolla/AutoHotkey-LibV2
**License**: MIT

#### Overview
Well-documented, working code designed for reuse across projects.

#### Core Utilities
- Align, FillStr, FilterWords
- Get, GetProps, MoveAdjacent
- PathObj, RGB, StrCompare

#### GUI & Window Management
- GuiResizer - Dynamic GUI resizing
- ListViewHelper - ListView utilities
- RectHighlight - Visual rectangles
- SelectControls - Control selection
- TreeViewEnum - TreeView operations
- WinSetParent - Window parenting
- ShowTooltip - Enhanced tooltips

#### Data Processing
- CompareObjects - Deep object comparison
- ParseJson, ValidateJson
- ContinuationSection parsing
- QuickParse, RemoveStringLiterals

#### File Operations
- DirectoryContent - Dir listing
- DirCreateEx - Enhanced mkdir
- GetRelativePath, ResolveRelativePath

#### Sorting & Data Structures
- Heapsort, QuickSort
- MapEx - Extended Map
- Indexer, ItemScroller

#### Advanced Features
- Win32 integrations
- GDI graphics operations
- Struct definitions
- Regex utilities
- Configuration management

#### Best For
Projects requiring well-documented, modular code with comprehensive inline documentation.

---

### 6. **Autumn-one/ahk-standard-lib** ⭐ BEST DATA STRUCTURE OPERATIONS

**GitHub**: https://github.com/Autumn-one/ahk-standard-lib
**Stars**: 19 | **Forks**: 1 | **License**: Open Source

#### Overview
Standard library designed to "provide better data structure operation experience."

#### String Methods (25+)
Split, trim, case conversion, Replace, Reverse, Wrap, searching, and manipulation

#### Array Methods
- Functional: `Map`, `Filter`, `Sort`, `Unique`, `Flat`
- Set operations: `Intersect`, `Union`
- Utility methods

#### Object Methods
- `Keys`, `Values`, `Items`
- `Merge`, `Has`, `Contains`
- Property checking

#### Additional Modules
- **time.ahk** - Time handling
- **number.ahk** - Number operations
- **path.ahk** - Path utilities
- **env.ahk** - Environment variables
- **utils.ahk** - General utilities
- **map.ahk** - Map/dictionary support

#### Project Stats
- 48 commits
- 3 releases
- 99.8% AutoHotkey code

#### Best For
Projects heavily focused on data manipulation, collection processing, and functional programming.

---

### 7. **hyaray/ahk_v2_lib**

**GitHub**: https://github.com/hyaray/ahk_v2_lib
**Stars**: 25 | **Language**: 100% AutoHotkey

#### Overview
Pre-compiled AutoHotkey v2-beta executables with built-in methods and functions.

#### Core Components
- 64-bit and 32-bit executables
- Pre-compiled definition file (`ahkDefine.ahk`)
- `lib/` directory with v2-beta libraries

#### Technical Foundation
- Built upon `thqby/AutoHotkey_H`
- Compiled with Ahk2Exe (resource ID #2)
- 49 commits

#### Best For
Users wanting enhanced AHK v2 functionality without compiling from source.

---

### 8. **pa-0/ahk.lib.user.v2** ⭐ BEST WINDOW MANAGEMENT

**GitHub**: https://github.com/pa-0/ahk.lib.user.v2
**License**: MIT

#### Overview
Personal collection of libraries with original and third-party code.

#### Window Management
- CenterWindow
- WindowGetRect
- Window enumeration functions

#### Monitor/DPI Handling
- EnumAllMonitorsDPI
- GetNearestMonitorInfo
- DPI awareness utilities

#### UI Automation
- Accessibility (Acc.ahk)
- Toolbar button enumeration
- Window spying tools

#### Text Processing
- AutoCorrect functionality
- Abbreviation expansion
- RichEdit manipulation

#### Graphics
- GDI+ integration (Gdip_All.ahk)
- Image utilities

#### System Integration
- COM object handling
- Process/thread enumeration
- Event hooks

#### Data Management
- JSON processing (jsongo.v2)
- Clipboard utilities
- File mapping

#### Additional Tools (78 items)
- DebugWindow
- EventLibrary
- HznPlus (shell hook integration)
- Multi-clipboard management
- Monitoring/enumeration tools

#### Best For
Window management, DPI handling, multi-monitor setups, and system-level automation.

---

### 9. **abgox/AHK_lib**

**GitHub**: https://github.com/abgox/AHK_lib
**Stars**: 1 | **Forks**: 1 | **License**: MIT

#### Overview
Utility functions for arrays and strings with parameter validation.

#### Features

**Array Functions:**
- Array manipulation utilities
- Slicing with interval notation `[left,right)`
- 1-based indexing
- Uses `Array.Length + 1` for inclusive bounds

**String Functions:**
- Text processing
- Manipulation tools

**Parameter Validation:**
- Built-in type and value checking
- Removed after compilation via Ahk2Exe.exe

#### Repository Stats
- 14 commits
- 100% AutoHotkey

#### Best For
Simple array and string operations with built-in validation.

---

### 10. **YooperTuber/AHK_lib-v2** ⚠️ NOT MAINTAINED

**GitHub**: https://github.com/YooperTuber/AHK_lib-v2
**Status**: **OLD - NOT MAINTAINED**
**License**: MIT

#### Overview
Collection aimed at building a "Runner" similar to YouTube creator Axlefublr's setup.

#### Structure (12 folders)
- Abstractions
- App
- Converters
- Directives
- Extensions
- Loaders
- Misc
- Scr (Screen)
- System
- Tests
- Tools
- Utils

#### Notable Contributors
- @thqby
- @Descolada

#### ⚠️ Warning
"Assume things will not work, and be surprised if they do."

#### Best For
Historical reference or code inspiration only. Not recommended for production use.

---

### 11. **flipeador/Library-AutoHotkey** ⚠️ ARCHIVED

**GitHub**: https://github.com/flipeador/Library-AutoHotkey
**Status**: **ARCHIVED (Aug 3, 2020)** - Read-only
**License**: Unlicense (public domain)

#### Overview
Historical AutoHotkey v2 library collection (now outdated).

#### Available Modules
- core_audio_interfaces
- crypt - Cryptographic operations
- device - Device management
- dlg - Dialog functionality
- fs - File system operations
- graphics
- gui - Interface components
- internet - Network utilities
- math
- memory
- obj - Object utilities
- process
- sound
- std - Standard library
- str - String manipulation
- sys - System utilities
- window

#### Additional Components
- IUIAutomation.ahk
- MCode.ahk

#### ⚠️ Warning
Not maintained for current AutoHotkey versions. Use as historical reference only.

---

## Libraries by Category

### 🎯 Core Utilities & Data Structures

**Best Choice**: `Descolada/AHK-v2-libraries` or `Autumn-one/ahk-standard-lib`

| Feature | Descolada | Autumn-one | thqby | Masonjar13 |
|---------|-----------|------------|-------|------------|
| Array operations | ✅✅ | ✅✅ | ✅ | ✅✅ |
| String methods | ✅✅ | ✅✅ | ✅ | ✅✅ |
| Functional programming | ✅✅ | ✅✅ | ❌ | ✅ |
| Object utilities | ✅ | ✅✅ | ✅ | ✅ |

---

### 🌐 Network & HTTP

**Best Choice**: `thqby/ahk2_lib`

| Feature | thqby | Masonjar13 | pa-0 v2classes |
|---------|-------|------------|----------------|
| HTTP server | ✅ | ❌ | ❌ |
| WebSocket | ✅ | ❌ | ❌ |
| HTTP client | ✅✅ | ✅ | ✅✅ |
| SMTP | ✅ | ❌ | ❌ |
| Async downloads | ✅ | ✅ | ✅ |

---

### 🎨 GUI Development

**Best Choice**: `pa-0/ahk.v2libraries-classes` or `Nich-Cebolla/AutoHotkey-LibV2`

| Feature | pa-0 v2classes | Nich-Cebolla | thqby |
|---------|----------------|--------------|-------|
| WebView2 (Chromium) | ✅✅ | ❌ | ❌ |
| HTML/CSS/JS GUIs | ✅✅ | ❌ | ❌ |
| GUI resizing | ✅ | ✅✅ | ❌ |
| ListView helpers | ❌ | ✅✅ | ❌ |
| TreeView helpers | ❌ | ✅✅ | ❌ |

---

### 🤖 UI Automation & Accessibility

**Best Choice**: `Descolada/AHK-v2-libraries` or `pa-0/ahk.v2libraries-classes`

| Feature | Descolada | pa-0 v2classes | thqby | pa-0 user |
|---------|-----------|----------------|-------|-----------|
| Acc.ahk | ✅✅ | ✅ | ❌ | ✅✅ |
| UIA-v2 | ✅✅ | ✅✅ | ✅✅ | ❌ |
| AccViewer | ✅ | ❌ | ❌ | ❌ |
| Element navigation | ✅✅ | ✅ | ✅ | ✅ |

---

### 🪟 Window & System Management

**Best Choice**: `pa-0/ahk.lib.user.v2` or `thqby/ahk2_lib`

| Feature | pa-0 user | thqby | Masonjar13 |
|---------|-----------|-------|------------|
| Window enumeration | ✅✅ | ✅ | ✅ |
| DPI awareness | ✅✅ | ❌ | ✅ |
| Multi-monitor | ✅✅ | ❌ | ❌ |
| WinAPI bindings | ✅ | ✅✅ | ✅ |
| Process management | ✅✅ | ✅✅ | ✅✅ |

---

### 🗄️ Database

**Best Choice**: `thqby/ahk2_lib` (only option)

| Feature | thqby | Masonjar13 |
|---------|-------|------------|
| SQLite | ✅✅ | ❌ |
| Key-value store | ❌ | ✅ |

---

### 🎬 Browser Automation

**Best Choice**: `pa-0/ahk.v2libraries-classes` or `thqby/ahk2_lib`

| Feature | pa-0 v2classes | thqby |
|---------|----------------|-------|
| Chrome automation | ✅✅ | ✅✅ |
| WebView2 | ✅✅ | ❌ |

---

### 📁 File Operations

**Best Choice**: `thqby/ahk2_lib` or `Nich-Cebolla/AutoHotkey-LibV2`

| Feature | thqby | Nich-Cebolla | Masonjar13 |
|---------|-------|--------------|------------|
| Directory watching | ✅ | ❌ | ❌ |
| Path utilities | ✅ | ✅✅ | ✅ |
| Archive handling | ✅✅ | ❌ | ❌ |
| Compression | ✅ | ❌ | ❌ |

---

### 🎨 Graphics & Vision

**Best Choice**: `thqby/ahk2_lib` or `pa-0/ahk.lib.user.v2`

| Feature | thqby | pa-0 user |
|---------|-------|-----------|
| OpenCV | ✅ | ❌ |
| OCR | ✅ | ❌ |
| GDI+ | ✅ | ✅✅ |
| Image utilities | ✅ | ✅ |

---

### 🔧 Development Tools

| Feature | Repository | Notes |
|---------|------------|-------|
| v1 to v2 converter | pa-0/ahk.v2libraries-classes | ✅ Available |
| Parameter validation | abgox/AHK_lib | ✅ Built-in |
| Documentation | Nich-Cebolla/AutoHotkey-LibV2 | ✅✅ Excellent |
| Testing frameworks | YooperTuber/AHK_lib-v2 | ⚠️ Not maintained |

---

## Getting Started

### Installation Methods

#### Method 1: Direct Download
```autohotkey
; Download the library file and place in your Lib folder
; Standard locations:
; - %A_MyDocuments%\AutoHotkey\Lib
; - %A_ScriptDir%\Lib
; - AutoHotkey installation Lib folder

#Include <LibraryName>
```

#### Method 2: Git Clone
```bash
# Clone into your Lib directory
cd %USERPROFILE%\Documents\AutoHotkey\Lib
git clone https://github.com/username/repository.git
```

#### Method 3: Git Submodule (for projects)
```bash
# Add as submodule to your project
git submodule add https://github.com/username/repository.git lib/repository
git submodule update --init --recursive
```

### Basic Usage Examples

#### Example 1: Using Descolada's Array Methods
```autohotkey
#Include <Array>

; Functional programming with arrays
numbers := [1, 2, 3, 4, 5]
doubled := numbers.Map((x) => x * 2)
evens := numbers.Filter((x) => Mod(x, 2) = 0)
sum := numbers.Reduce((acc, x) => acc + x, 0)

MsgBox("Doubled: " doubled.Join(", "))
MsgBox("Evens: " evens.Join(", "))
MsgBox("Sum: " sum)
```

#### Example 2: Using thqby's JSON Parser
```autohotkey
#Include <JSON>

; Parse JSON
jsonStr := '{"name": "Alice", "age": 30, "skills": ["AHK", "Python"]}'
obj := JSON.Parse(jsonStr)

MsgBox("Name: " obj.name)
MsgBox("Age: " obj.age)
MsgBox("Skills: " obj.skills.Join(", "))

; Convert back to JSON
newJson := JSON.Stringify(obj)
MsgBox(newJson)
```

#### Example 3: Using pa-0's WebView2
```autohotkey
#Include <WebView2>

; Create modern web-based GUI
wv := WebView2.Create(hwnd)
wv.Navigate("https://example.com")

; Or load local HTML
wv.NavigateToString("<h1>Hello from WebView2!</h1>")
```

#### Example 4: Using Nich-Cebolla's GuiResizer
```autohotkey
#Include <GuiResizer>

; Create resizable GUI
MyGui := Gui()
MyGui.Add("Edit", "w300 h200 vMyEdit", "Content")
MyGui.Add("Button", "w100 vMyButton", "Click Me")

; Enable automatic resizing
resizer := GuiResizer(MyGui)
resizer.Add("MyEdit", {width: 1, height: 1})
resizer.Add("MyButton", {y: 1})

MyGui.Show()
```

---

## Recommended Combinations

### For General Purpose Automation

**Core Stack:**
1. `Descolada/AHK-v2-libraries` - String/Array utilities
2. `Masonjar13/AHK-Library` - Standard functions
3. `pa-0/ahk.lib.user.v2` - Window management

**Why:** Covers most common automation needs with well-tested, stable code.

---

### For GUI-Heavy Applications

**Core Stack:**
1. `pa-0/ahk.v2libraries-classes` - WebView2 & modern GUIs
2. `Nich-Cebolla/AutoHotkey-LibV2` - GUI helpers & resizing
3. `pa-0/ahk.lib.user.v2` - GDI+ graphics

**Why:** Modern web-based UIs with comprehensive GUI utilities.

---

### For System Integration & Advanced Features

**Core Stack:**
1. `thqby/ahk2_lib` - Comprehensive system access
2. `pa-0/ahk.v2libraries-classes` - UIAutomation & CLR
3. `Masonjar13/AHK-Library` - Process/window management

**Why:** Deep system integration with networking, database, and API access.

---

### For Data Processing & Functional Programming

**Core Stack:**
1. `Autumn-one/ahk-standard-lib` - Enhanced data structures
2. `Descolada/AHK-v2-libraries` - Functional operations
3. `thqby/ahk2_lib` - JSON/YAML parsing

**Why:** Best tools for collection manipulation and functional programming patterns.

---

### For Browser & Web Automation

**Core Stack:**
1. `pa-0/ahk.v2libraries-classes` - Chrome automation & WebView2
2. `thqby/ahk2_lib` - HTTP/WebSocket/networking
3. `Masonjar13/AHK-Library` - Network utilities

**Why:** Complete browser automation with HTTP client capabilities.

---

### For Accessibility & UI Testing

**Core Stack:**
1. `Descolada/AHK-v2-libraries` - Acc.ahk with AccViewer
2. `pa-0/ahk.v2libraries-classes` - UIAutomation v2
3. `thqby/ahk2_lib` - UIAutomation framework

**Why:** Multiple approaches to accessibility with excellent navigation tools.

---

## Tips & Best Practices

### 1. **Version Compatibility**
Always check which AutoHotkey v2 version the library targets:
- Most libraries work with v2.0 final release
- Some may require v2.1-alpha for newer features
- Check repository's last update date

### 2. **Dependency Management**
```autohotkey
; Document your dependencies at the top
; #Include <Library1>  ; Required: version 2.0+
; #Include <Library2>  ; Optional: for feature X
```

### 3. **Testing New Libraries**
```autohotkey
; Test in isolation first
#SingleInstance Force

try {
    #Include <NewLibrary>
    TestFunction()
} catch Error as e {
    MsgBox("Error: " e.Message)
}
```

### 4. **Performance Considerations**
- Only include what you need
- Some libraries like `thqby/ahk2_lib` are comprehensive but large
- Consider function-level includes when possible

### 5. **Documentation**
- `Nich-Cebolla/AutoHotkey-LibV2` has excellent inline documentation
- `pa-0/ahk.v2libraries-classes` includes examples
- Check repository Issues/Wiki for usage tips

### 6. **Contributing Back**
- Report bugs via GitHub Issues
- Submit pull requests for fixes
- Share your own libraries
- Star repositories you find useful

---

## Quick Reference Table

### Need to...? → Use this library:

| Task | Primary Choice | Alternative | Notes |
|------|----------------|-------------|-------|
| Parse JSON | thqby/ahk2_lib | pa-0/ahk.lib.user.v2 | thqby has most features |
| Array manipulation | Descolada | Autumn-one | Both excellent, pick style preference |
| Modern GUI | pa-0/ahk.v2libraries-classes | Nich-Cebolla | WebView2 vs traditional |
| Window management | pa-0/ahk.lib.user.v2 | Masonjar13 | pa-0 better for multi-monitor |
| HTTP requests | thqby/ahk2_lib | pa-0/ahk.v2libraries-classes | thqby has HTTP server too |
| Accessibility | Descolada | pa-0/ahk.v2libraries-classes | Descolada has AccViewer |
| String operations | Descolada | Autumn-one | Similar features, different syntax |
| File operations | thqby/ahk2_lib | Nich-Cebolla | thqby more comprehensive |
| Database | thqby/ahk2_lib | Masonjar13 | SQLite vs key-value |
| Browser automation | pa-0/ahk.v2libraries-classes | thqby/ahk2_lib | Chrome control |
| Graphics/GDI+ | pa-0/ahk.lib.user.v2 | thqby/ahk2_lib | Both have Gdip |
| OCR/Vision | thqby/ahk2_lib | - | Only option |
| Audio control | Masonjar13 | - | Per-app volume |
| Multi-threading | Masonjar13 | - | Via AutoHotkey.dll |

---

## Repository Links Summary

### ✅ Active & Recommended

1. **thqby/ahk2_lib**
   https://github.com/thqby/ahk2_lib

2. **Descolada/AHK-v2-libraries**
   https://github.com/Descolada/AHK-v2-libraries

3. **Masonjar13/AHK-Library**
   https://github.com/Masonjar13/AHK-Library

4. **pa-0/ahk.v2libraries-classes**
   https://github.com/pa-0/ahk.v2libraries-classes

5. **Nich-Cebolla/AutoHotkey-LibV2**
   https://github.com/Nich-Cebolla/AutoHotkey-LibV2

6. **Autumn-one/ahk-standard-lib**
   https://github.com/Autumn-one/ahk-standard-lib

7. **hyaray/ahk_v2_lib**
   https://github.com/hyaray/ahk_v2_lib

8. **pa-0/ahk.lib.user.v2**
   https://github.com/pa-0/ahk.lib.user.v2

9. **abgox/AHK_lib**
   https://github.com/abgox/AHK_lib

### ⚠️ Not Maintained / Archived

10. **YooperTuber/AHK_lib-v2** (Not Maintained)
    https://github.com/YooperTuber/AHK_lib-v2

11. **flipeador/Library-AutoHotkey** (Archived 2020)
    https://github.com/flipeador/Library-AutoHotkey

---

## Additional Resources

### Official Documentation
- **AutoHotkey v2 Docs**: https://www.autohotkey.com/docs/v2/
- **AutoHotkey Forum**: https://www.autohotkey.com/boards/

### Community Resources
- **AutoHotkey Discord**: Active community for questions
- **r/AutoHotkey**: Reddit community
- **Awesome AutoHotkey**: https://github.com/ahkscript/awesome-AutoHotkey

### Related Guides
- [AHK v2 Examples Feature Guide](./AHK_v2_Examples_Feature_Guide.md)
- [AHK v2 Examples Classification Guide](./AHK_v2_Examples_Classification_Guide.md)

---

## Changelog

**Version 1.0** (2025-01-05)
- Initial compilation of 11 repositories
- Comprehensive feature comparison matrix
- Category-based organization
- Usage examples and recommendations

---

## Contributing to This Guide

Found a library that should be included? Have corrections or updates?

This guide is part of the AHKv2_Finetune repository. Contributions welcome!

**Repository**: https://github.com/012090120901209/AHKv2_Finetune

---

## License

This guide is provided as-is for informational purposes. Each library has its own license:
- Most use MIT License (permissive)
- Some use Unlicense (public domain)
- Always check the specific repository for license details

---

**Last Updated**: January 2025
**Total Repositories**: 11 (9 active, 2 archived/unmaintained)
**Total Stars**: ~750+

---

*This guide is maintained as part of the AHKv2_Finetune project, which includes 900 AHK v2 examples across 21 categories.*
