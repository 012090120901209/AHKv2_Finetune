# AHK v2 Examples Collection

A curated collection of **1,750+ AutoHotkey v2 example scripts** organized by functionality for fine-tuning language models on AHK v2 syntax and patterns.

---

## 📁 Folder Structure

Scripts are organized into **38 category folders** based on their primary functionality:

### Core Language Features
| Folder | Description |
|--------|-------------|
| `BuiltIn/` | Built-in functions (MsgBox, FileRead, RegEx, etc.) |
| `String/` | String manipulation (StrReplace, SubStr, InStr, etc.) |
| `Array/` | Array operations (Push, Pop, Loop, sorting, etc.) |
| `Control/` | Control flow (#Include, ByRef, Loop, Switch, etc.) |
| `Flow/` | Sleep, Ternary operators |
| `Syntax/` | Language syntax examples |

### GUI & User Interface
| Folder | Description |
|--------|-------------|
| `GUI/` | GUI creation, controls, events, menus |
| `Hotkey/` | Keyboard shortcuts, key bindings |
| `Hotstring/` | Text expansion, auto-replace |

### System Operations
| Folder | Description |
|--------|-------------|
| `File/` | File/folder operations (read, write, copy, move) |
| `Window/` | Window management (WinActivate, WinMove, etc.) |
| `Process/` | Process control, OnMessage |
| `Registry/` | Windows Registry operations |
| `Screen/` | Screen capture, PixelSearch, ImageSearch |
| `Sound/` | Audio playback and control |
| `Env/` | Environment variables, system settings |

### Object-Oriented & Advanced
| Folder | Description |
|--------|-------------|
| `OOP/` | Classes, inheritance, design patterns |
| `Advanced/` | Complex scripts (GUI apps, data structures, etc.) |
| `Pattern/` | Design patterns (Observer, Factory, MVC, etc.) |
| `DataStructures/` | Stack, Queue implementations |
| `MetaFunction/` | Meta-functions (__Call, __Enum, etc.) |

### Libraries & External
| Folder | Description |
|--------|-------------|
| `Library/` | Popular library examples (UIA, OCR, ImagePut, JSON, HTTP) |
| `Lib/` | DllCall, COM, VarSetCapacity examples |
| `GitHub/` | Scripts sourced from GitHub repositories |

### Specialized
| Folder | Description |
|--------|-------------|
| `StdLib/` | Standard library function demonstrations |
| `Module/` | Module system examples |
| `Utility/` | Helper functions and utilities |
| `DateTime/` | Date/time operations |
| `Directive/` | Preprocessor directives (#Warn, #Requires, etc.) |
| `Hook/` | System hooks (WinEventHook, ShellHook) |
| `Iterator/` | Custom iterators and enumerators |
| `Maths/` | Mathematical operations |
| `Sync/` | Mutex, Semaphore synchronization |
| `Misc/` | Miscellaneous examples |

### Development & Testing
| Folder | Description |
|--------|-------------|
| `Integrity/` | Code integrity and edge case tests |
| `Failed/` | Known conversion issues (for reference) |
| `Functions/` | Function definition patterns |
| `v2/` | v2-specific syntax fixes |
| `testfiles/` | Test data files and folders used by scripts |

---

## 🎯 File Naming Convention

Files follow a consistent naming pattern:
```
[Category]_[Feature]_[Detail].ahk
```

**Examples:**
- `BuiltIn_FileRead_01_BasicReading.ahk`
- `String_StrReplace_ex01.ahk`
- `GUI_MsgBox_ex01.ahk`
- `OOP_Pattern_Observer.ahk`
- `Hotkey_01_Basic_F1.ahk`

---

## 🎓 Purpose

This collection serves as training data for fine-tuning LLMs on AutoHotkey v2:

1. **Syntax Learning** - Comprehensive coverage of v2 syntax and idioms
2. **Pattern Recognition** - Common coding patterns and best practices
3. **API Coverage** - Examples of most built-in functions and methods
4. **Real-World Usage** - Practical scripts from the AHK community

---

## 📊 Statistics

- **Total Scripts:** ~1,750 AHK v2 files
- **Categories:** 38 organized folders
- **Coverage:** Core language, GUI, system ops, OOP, libraries
- **Quality:** Verified v2 syntax, standalone examples

---

## 🔧 Test Data

The `testfiles/` folder contains supporting data files and folders used by various scripts:
- Text files for File I/O examples
- Folder structures for directory operations
- Attribute test files (readonly, hidden, etc.)

---

## 📚 Sources

Examples compiled from:
- Official AHK v2 documentation
- AHK v1→v2 Converter test suite
- Popular GitHub libraries (Descolada/UIA-v2, iseahound/ImagePut, etc.)
- Community contributions

---

## 📁 Quick Access

**Most Common Categories:**

**String Operations (68 files)**
- Look for: `String_Array_*.ahk`, `String_SubStr_*.ahk`, `String_InStr_*.ahk`
- Topics: Array manipulation, string functions, concatenation

**GUI Examples (51 files)**
- Look for: `Graphical_*.ahk`
- Topics: Window creation, controls, events

**File Operations (60 files)**
- Look for: `File_*.ahk`
- Topics: Reading/writing, directory management

**Hotkeys & Input (34 files)**
- Look for: `Mouse_*.ahk`
- Topics: Hotkey definition, input simulation

**Window Management (49 files)**
- Look for: `Window_*.ahk`
- Topics: Window detection, positioning, activation

---

## 💡 Tips

- **All files start with** `#Requires AutoHotkey v2.1-alpha.16` - This is correct v2 syntax
- **Files are immediately runnable** - No setup needed
- **Study in pairs** - For each `.ahk` file, the original `.ah1` file shows v1 syntax
- **Use as templates** - Copy patterns directly to your projects
- **Comprehensive coverage** - From simple statements to complex operations

---

## 📚 Related Files

For comparison with v1 syntax:
- Original test files: `AHK-v2-script-converter\tests\Test_Folder\[Category]\[Name].ah1`
- Comprehensive guide: `Training\AHK_v1_to_v2_Converter_Test_Guide.md`

---

**This collection represents 600+ conversion test pairs plus curated examples from top AHK v2 libraries. Examples include GUI automation, OCR, image processing, HTTP servers, and more!**

### 📦 Recent Additions (Nov 2025)
- **Library examples** from Descolada/UIA-v2, Descolada/OCR, iseahound/ImagePut
- **Official documentation** examples demonstrating v2 best practices
- **Advanced patterns** including async operations, GUI creation, string manipulation
- **Metadata catalog** with source URLs and categorization (`data/examples_catalog.json`)
