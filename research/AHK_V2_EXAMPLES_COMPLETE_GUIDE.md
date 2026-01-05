# AutoHotkey v2 Examples - Complete Guide

**Last Updated:** 2025-11-08
**Total Examples:** 940 files
**Version:** AutoHotkey v2.0+

---

## Table of Contents

1. [Overview](#overview)
2. [Quick Statistics](#quick-statistics)
3. [Core Features](#core-features)
   - [Hotkeys](#1-hotkeys-74-files)
   - [Hotstrings](#2-hotstrings-10-files)
4. [Data Structures](#data-structures)
   - [Arrays](#3-arrays-82-files)
5. [Standard Library](#standard-library)
   - [StdLib Functions](#4-stdlib-95-files)
6. [Advanced Libraries](#advanced-libraries)
   - [Third-Party Libraries](#5-library-examples-10-files)
   - [GitHub Real-World Examples](#6-github-examples-6-files)
7. [Language Features](#language-features)
   - [String Operations](#7-string-105-files)
   - [File Operations](#8-file-83-files)
   - [GUI Development](#9-gui-64-files)
   - [Object-Oriented Programming](#10-oop-72-files)
   - [Window Management](#11-window-63-files)
   - [Advanced Features](#12-advanced-50-files)
   - [Control Flow](#13-control-flow-43-files)
   - [Miscellaneous](#14-misc-35-files)
   - [Process Management](#15-process-20-files)
   - [Registry Operations](#16-registry-10-files)
   - [Flow Control](#17-flow-4-files)
8. [How to Use This Guide](#how-to-use-this-guide)
9. [File Naming Conventions](#file-naming-conventions)
10. [Learning Paths](#learning-paths)

---

## Overview

This dataset contains **940 comprehensive examples** for AutoHotkey v2, covering everything from basic syntax to advanced patterns. All examples are:

- ✅ **Self-contained** - Each file runs independently
- ✅ **Well-documented** - JSDoc-style comments explain concepts
- ✅ **Version 2 syntax** - All use `#Requires AutoHotkey v2.0`
- ✅ **Practical** - Real-world use cases and patterns
- ✅ **Progressive** - From beginner to advanced

### Purpose

This dataset is designed for:
- **LLM Training** - Teaching AI models AutoHotkey v2 syntax and patterns
- **Reference Documentation** - Quick lookup of AHK v2 capabilities
- **Learning Resource** - Progressive examples for humans learning AHK v2
- **Code Templates** - Starting points for common automation tasks

---

## Quick Statistics

| Category | Files | Coverage |
|----------|-------|----------|
| **Core Automation** | | |
| Hotkeys | 74 | Complete |
| Hotstrings | 10 | Complete |
| **Data Structures** | | |
| Arrays | 82 | Complete |
| **Built-in Functions** | | |
| Standard Library | 95 | Complete |
| **Third-Party** | | |
| Library Examples | 10 | Selective |
| GitHub Examples | 6 | Selective |
| **Language Features** | | |
| Strings | 105 | Extensive |
| Files | 83 | Extensive |
| GUI | 64 | Extensive |
| OOP | 72 | Extensive |
| Windows | 63 | Extensive |
| Advanced | 50 | Extensive |
| Control Flow | 43 | Complete |
| Misc | 35 | Varied |
| Process | 20 | Core features |
| Registry | 10 | Core features |
| Flow | 4 | Basic |
| **TOTAL** | **940** | **Comprehensive** |

---

## Core Features

### 1. Hotkeys (74 files)

**Location:** `Hotkey_*.ahk`
**Count:** 74 files
**Difficulty:** Beginner to Advanced

Hotkeys are AutoHotkey's signature feature - keyboard shortcuts that trigger actions.

#### Coverage

**Basic Hotkeys (Files 01-10)**
- Single key triggers (`F1::`, `Space::`)
- Modifier keys (Ctrl `^`, Alt `!`, Shift `+`, Win `#`)
- Mouse buttons (`MButton::`, `XButton1::`, `WheelUp::`)
- Function keys and special keys

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Ctrl+J to show message
^j::MsgBox("You pressed Ctrl+J!")

; F5 with multiple actions
F5:: {
    currentTime := FormatTime(, "HH:mm:ss")
    MsgBox("F5 pressed at " currentTime)
}
```

**Advanced Modifiers (Files 11-20)**
- Left/Right modifier distinction (`<^` vs `>^`)
- Wildcard prefix `*` - fires with any modifiers
- Tilde prefix `~` - passes key through
- Dollar prefix `$` - prevents Send loops
- Up suffix - fires on key release
- Custom combinations with `&` operator
- Numpad keys, media keys, gamepad buttons

**Example:**
```autohotkey
; Left Ctrl+J vs Right Ctrl+J
<^j::MsgBox("Left Ctrl+J")
>^j::MsgBox("Right Ctrl+J")

; Tilde lets native function work
~^c::ToolTip("Copied!")

; Custom modifier: a as modifier for b
a & b::MsgBox("Custom combo: A+B")
```

**Dynamic Hotkeys (Files 21-30)**
- `Hotkey()` function - create at runtime
- Toggle, enable, disable hotkeys
- MaxThreads option (simultaneous instances)
- Priority and InputLevel options
- Suspend/resume functionality
- Buffering options
- Dynamic remapping
- Variant hotkeys

**Example:**
```autohotkey
; Create hotkey dynamically
Hotkey("F6", MyFunction)
MyFunction(*) {
    MsgBox("F6 works!")
}

; Disable it
F7::Hotkey("F6", "Off")

; Enable it
F8::Hotkey("F6", "On")
```

**Context-Sensitive (Files 31-40)**
- `#HotIf WinActive()` - window-specific
- `#HotIf WinExist()` - based on existence
- Mouse position detection
- GetKeyState conditions
- Time-based activation
- Custom function conditions
- Caret position detection
- Global variable states
- File system conditions
- Key sequence detection

**Example:**
```autohotkey
; Only works in Notepad
#HotIf WinActive("ahk_exe notepad.exe")
^n::MsgBox("Ctrl+N in Notepad only!")
#HotIf

; Only during work hours
#HotIf (A_Hour >= 9 and A_Hour < 17)
F7::MsgBox("Work hours hotkey")
#HotIf

; Custom condition
IsTextEditor() {
    return WinActive("ahk_exe notepad.exe")
        or WinActive("ahk_exe Code.exe")
}

#HotIf IsTextEditor()
^!f::MsgBox("Ctrl+Alt+F in text editor")
#HotIf
```

#### Key Files

- `Hotkey_01_Basic_F1.ahk` - Simplest hotkey
- `Hotkey_12_Wildcard_Modifier.ahk` - `*` prefix
- `Hotkey_21_Hotkey_Function.ahk` - Dynamic creation
- `Hotkey_31_HotIf_WinActive.ahk` - Context-sensitive

#### Learning Path

1. Start with `Hotkey_01` through `Hotkey_10` (basics)
2. Learn modifiers with `Hotkey_11` through `Hotkey_20`
3. Master dynamic control with `Hotkey_21` through `Hotkey_30`
4. Advanced context with `Hotkey_31` through `Hotkey_40`

---

### 2. Hotstrings (10 files)

**Location:** `Hotstring_*.ahk`
**Count:** 10 files
**Difficulty:** Beginner to Intermediate

Hotstrings auto-replace text as you type - perfect for text expansion and auto-correction.

#### Coverage

**Files 41-50:**
- Basic replacements (`::btw::by the way`)
- Asterisk `*` option - immediate trigger
- Question mark `?` - trigger inside words
- Case-sensitive `C` option
- Raw text `T` mode - special characters
- Backspace `B0` option - no deletion
- Dynamic hotstrings with functions
- Multi-option combinations
- Context-sensitive hotstrings
- Advanced interactive replacements

**Basic Examples:**
```autohotkey
; Simple replacement
::btw::by the way
::omw::on my way

; Email shortcut
::@@::yourname@email.com

; Multi-line expansion
::addr::
(
123 Main Street
City, State 12345
)
```

**Options:**
```autohotkey
; * = Immediate (no ending character needed)
:*:teh::the

; ? = Works inside words
:?:1st::1ˢᵗ

; C = Case-sensitive
:C:SQL::Structured Query Language

; T = Raw text mode (literal characters)
:T:forloop::for (let i = 0; i < length; i++) { }

; Combine options
:*C:AHK::AutoHotkey
```

**Dynamic Hotstrings:**
```autohotkey
; Current date
::ddate::{
    Send(FormatTime(, "yyyy-MM-dd"))
}

; Random number
::rand::{
    Send(Random(1, 100))
}
```

**Context-Sensitive:**
```autohotkey
; Only in VS Code
#HotIf WinActive("ahk_exe Code.exe")
::log::console.log();
::func::function () {`n    `n}
#HotIf
```

#### Key Files

- `Hotstring_41_Basic.ahk` - Simple replacements
- `Hotstring_42_Asterisk_Option.ahk` - Immediate trigger
- `Hotstring_47_Dynamic_Hotstrings.ahk` - Functions
- `Hotstring_50_Advanced_Replacement.ahk` - Interactive

---

## Data Structures

### 3. Arrays (82 files)

**Location:** `Array_*.ahk`
**Count:** 82 files (32 + 32 + 18)
**Difficulty:** Beginner to Advanced

Comprehensive array manipulation examples in three distinct series.

#### Coverage Overview

This section includes **82 files** split into three complementary series:

1. **Array_01 to Array_32** (32 files) - Library usage with `adash`
2. **Array_Standalone_01 to Array_Standalone_32** (32 files) - Pure implementations
3. **Array_Advanced_01 to Array_Advanced_18** (18 files) - Professional patterns

#### Series 1: Array Library Usage (32 files)

**Files:** `Array_01_*.ahk` through `Array_32_*.ahk`
**Purpose:** Learn how to USE the adash library
**Requires:** `#Include <adash>`

These demonstrate library-based array manipulation using the adash library (Lodash-style for AHK).

**Methods Covered:**
- Chunk, Compact, DepthOf, Difference, Drop, DropRight
- Fill, FindIndex, FindLastIndex, Flatten, FlattenDeep
- FromPairs, IndexOf, Initial, Intersection, Join
- Last, LastIndexOf, Nth, Pull, Reverse
- Slice, SortedIndex, Take, TakeRight, Union
- Uniq, Without, Zip, ZipObject
- And more...

**Example - Array_01_Chunk.ahk:**
```autohotkey
#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

; Split array into chunks of size 2
result1 := _.chunk(["a", "b", "c", "d"], 2)
; => [["a", "b"], ["c", "d"]]

result2 := _.chunk([1, 2, 3, 4, 5], 3)
; => [[1, 2, 3], [4, 5]]

MsgBox("Chunk [a,b,c,d] by 2: " JSON.stringify(result1))
```

#### Series 2: Standalone Implementations (32 files)

**Files:** `Array_Standalone_01_*.ahk` through `Array_Standalone_32_*.ahk`
**Purpose:** Learn HOW to implement array utilities from scratch
**Requires:** Nothing - pure AHK v2 code

These show the internal implementation of array functions without external dependencies.

**Educational Value:**
- Understand algorithm internals
- Learn AHK v2 patterns
- No library dependencies
- Copy/paste into your scripts

**Example - Array_Standalone_09_FlattenDeep.ahk:**
```autohotkey
#Requires AutoHotkey v2.0

FlattenDeep(array) {
    result := []
    for value in array {
        if (IsObject(value) && value is Array) {
            flattened := FlattenDeep(value)
            for item in flattened {
                result.Push(item)
            }
        } else {
            result.Push(item)
        }
    }
    return result
}

; Deep flatten nested arrays
nested := [1, [2, [3, [4]], 5]]
flat := FlattenDeep(nested)
; => [1, 2, 3, 4, 5]

MsgBox("Deep flattened: " JSON.stringify(flat))
```

#### Series 3: Advanced Patterns (18 files)

**Files:** `Array_Advanced_01_*.ahk` through `Array_Advanced_18_*.ahk`
**Purpose:** Learn professional production-quality patterns
**Source:** Based on Lodash-style professional code

These demonstrate advanced techniques and best practices.

**Features Demonstrated:**
- Binary search with bit-shift optimization
- Deep recursive traversal
- Map-based Sets for O(1) lookups
- Immutable vs mutable operations
- Helper functions and closures
- Algorithm efficiency (O(n) vs O(n²))
- By-reference parameters
- State tracking patterns

**Example - Array_Advanced_04_SortedIndex.ahk:**
```autohotkey
#Requires AutoHotkey v2.0

SortedIndex(arr, value) {
    arr := ToArray(arr)
    lo := 1, hi := arr.Length + 1

    ; Binary search with bit shift optimization
    while lo < hi {
        mid := (lo + hi) >> 1  ; Bit shift = divide by 2 (faster)
        if (arr.Length >= mid && arr[mid] < value)
            lo := mid + 1
        else
            hi := mid
    }
    return lo
}

ToArray(value) {
    if (!IsObject(value))
        return []
    if (value is Array)
        return value
    return [value]
}

; Find insertion index in sorted array
sorted := [1, 3, 5, 7, 9]
index := SortedIndex(sorted, 6)
; => 4 (insert 6 at position 4)

MsgBox("Insert 6 at index: " index)
```

#### Why Three Series?

Each series serves a distinct educational purpose:

- **Array_XX** → "I want to USE array utilities quickly"
- **Array_Standalone_XX** → "I want to LEARN how these work internally"
- **Array_Advanced_XX** → "I want to see PROFESSIONAL patterns and optimizations"

#### Complete Method List

All 32 methods (covered in both library and standalone versions):

1. Chunk - Split into chunks
2. Compact - Remove falsy values
3. DepthOf - Get nesting depth
4. Difference - Array A without B
5. Drop - Remove from start
6. DropRight - Remove from end
7. Fill - Fill with value
8. FindIndex - First matching index
9. FindLastIndex - Last matching index
10. Flatten - Flatten one level
11. FlattenDeep - Flatten all levels
12. FromPairs - Object from pairs
13. IndexOf - Find first occurrence
14. Initial - All but last
15. Intersection - Common elements
16. Join - Join with separator
17. Last - Get last element
18. LastIndexOf - Find last occurrence
19. Nth - Get nth element
20. Pull - Remove specific values
21. Reverse - Reverse array
22. Slice - Extract portion
23. SortedIndex - Binary search insertion
24. Take - Take from start
25. TakeRight - Take from end
26. Union - Combine unique
27. Uniq - Remove duplicates
28. Without - Filter out values
29. Xor - Symmetric difference
30. Zip - Zip arrays together
31. ZipObject - Create object
32. And more advanced patterns...

#### Key Files

- `Array_01_Chunk.ahk` - Basic library usage
- `Array_Standalone_09_FlattenDeep.ahk` - Recursive algorithm
- `Array_Advanced_04_SortedIndex.ahk` - Binary search
- `Array_Advanced_18_Complete_Example.ahk` - Comprehensive patterns

---

## Standard Library

### 4. StdLib (95 files)

**Location:** `StdLib_*.ahk`
**Count:** 95 files
**Difficulty:** Beginner to Intermediate

Complete coverage of AutoHotkey v2's built-in functions.

#### Coverage

**Files 01-95** cover all major built-in functions:

**File Operations (01-20)**
- FileRead, FileAppend, FileOpen
- FileExist, FileDelete, FileCopy, FileMove
- FileGetAttrib, FileSetAttrib
- FileGetSize, FileGetTime, FileSetTime
- DirCreate, DirDelete, DirExist
- DirCopy, DirMove
- FileSelect, FileSelectFolder
- And more...

**String/Text (21-40)**
- SubStr, InStr, StrLen, StrReplace
- StrSplit, StrLower, StrUpper, StrTitle
- Trim, LTrim, RTrim
- RegEx functions
- Format, FormatTime
- Ord, Chr
- And more...

**Math & Types (41-65)**
- Abs, Ceil, Floor, Round, Mod
- Min, Max, Sqrt, Exp, Log, Ln
- Sin, Cos, Tan, ASin, ACos, ATan
- Random
- Type, IsNumber, IsInteger, IsFloat
- Integer, Float, Number, String
- And more...

**Windows & System (66-95)**
- MsgBox, InputBox, ToolTip
- Run, RunWait, RunAs
- WinExist, WinActive, WinWait
- WinClose, WinKill, WinMove, WinGetPos
- WinGetTitle, WinSetTitle
- ProcessExist, ProcessClose, ProcessWait
- Send, SendInput, SendPlay, SendEvent
- Click, MouseMove, MouseClick
- ControlSend, ControlClick
- Clipboard operations
- And more...

**Example - StdLib_01_FileRead.ahk:**
```autohotkey
#Requires AutoHotkey v2.0

/**
 * FileRead() - Read entire file
 * Reads the entire contents of a file into a variable.
 */

testFile := A_ScriptDir "\test.txt"
FileDelete(testFile)
FileAppend("Line 1`nLine 2`nLine 3", testFile)

content := FileRead(testFile)
MsgBox("File content:`n" content)

FileDelete(testFile)
```

**Example - StdLib_42_Random.ahk:**
```autohotkey
#Requires AutoHotkey v2.0

/**
 * Random() - Generate random numbers
 * Returns a random number between min and max (inclusive)
 */

; Random number 1-100
num1 := Random(1, 100)
MsgBox("Random 1-100: " num1)

; Random float 0.0-1.0
num2 := Random(0.0, 1.0)
MsgBox("Random float: " num2)

; Coin flip
coin := Random(0, 1) ? "Heads" : "Tails"
MsgBox("Coin flip: " coin)
```

#### Key Files

- `StdLib_01_FileRead.ahk` - File reading
- `StdLib_22_StrReplace.ahk` - String replacement
- `StdLib_42_Random.ahk` - Random numbers
- `StdLib_66_MsgBox.ahk` - Message boxes
- `StdLib_84_WinMove.ahk` - Window manipulation

---

## Advanced Libraries

### 5. Library Examples (10 files)

**Location:** `Library_*.ahk`
**Count:** 10 files
**Difficulty:** Intermediate to Advanced

Examples using third-party libraries from thqby/ahk2_lib.

#### Coverage

**Libraries Demonstrated:**
- JSON parsing and generation
- HTTP requests (GET, POST, PUT, DELETE)
- Promises and async operations
- Socket programming
- Chrome automation
- And more...

**Example - Library_JSON_15Examples.ahk:**
```autohotkey
#Requires AutoHotkey v2.0
#Include <JSON>

; Parse JSON string
jsonStr := '{"name": "John", "age": 30}'
obj := JSON.parse(jsonStr)
MsgBox("Name: " obj.name "`nAge: " obj.age)

; Create JSON from object
data := Map("name", "Jane", "age", 25, "city", "NYC")
json := JSON.stringify(data)
MsgBox("JSON: " json)
```

**Example - Library_HTTP_15Examples.ahk:**
```autohotkey
#Requires AutoHotkey v2.0
#Include <WinHttpRequest>

; GET request
http := WinHttpRequest()
http.Open("GET", "https://api.github.com")
http.Send()
response := http.ResponseText

MsgBox("Status: " http.Status "`n`nResponse: " SubStr(response, 1, 200))
```

#### Key Files

- `Library_JSON_15Examples.ahk` - JSON operations
- `Library_HTTP_15Examples.ahk` - HTTP requests
- `Library_Promise_15Examples.ahk` - Async patterns

---

### 6. GitHub Examples (6 files)

**Location:** `GitHub_Example_*.ahk`
**Count:** 6 files
**Difficulty:** Intermediate to Advanced

Real-world code patterns extracted from actual GitHub repositories.

#### Coverage

**Files 01-06:**
1. CreateGUID - Windows GUID generation with DllCall
2. SystemMetrics - Get screen/system information
3. Notification_GUI - Custom toast notifications
4. WindowSpy - Get window information
5. ClipboardHistory - Clipboard manager
6. ProcessList - Enumerate running processes

**Example - GitHub_Example_01_CreateGUID.ahk:**
```autohotkey
#Requires AutoHotkey v2.0

/**
 * CreateGUID() - Generate Windows GUID
 * Source: jNizM/ahk-scripts-v2
 * Demonstrates: DllCall, Buffer management, static variables
 */

CreateGUID() {
    static S_OK := 0
    GUID := Buffer(16, 0)

    if (DllCall("ole32\CoCreateGuid", "Ptr", GUID) != S_OK) {
        return ""
    }

    VarSetStrCapacity(&sGUID := "", 39)
    if (DllCall("ole32\StringFromGUID2", "Ptr", GUID, "Str", sGUID, "Int", 39) != 39) {
        return ""
    }

    return sGUID
}

guid := CreateGUID()
MsgBox("Generated GUID:`n" guid)
```

#### Key Files

- `GitHub_Example_01_CreateGUID.ahk` - DllCall mastery
- `GitHub_Example_03_Notification_GUI.ahk` - Custom GUI patterns

---

## Language Features

### 7. String (105 files)

**Location:** `String_*.ahk`
**Count:** 105 files
**Difficulty:** Beginner to Advanced

Comprehensive string manipulation and text processing.

#### Coverage

**Methods/Functions:**
- SubStr - Extract substring
- InStr - Find substring position
- StrReplace - Replace text
- StrSplit - Split into array
- StrLen - Get length
- StrLower/StrUpper/StrTitle - Case conversion
- Trim/LTrim/RTrim - Whitespace removal
- Format - String formatting
- RegEx operations - Pattern matching
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

text := "  Hello World  "

; Trim whitespace
trimmed := Trim(text)  ; "Hello World"

; Convert case
upper := StrUpper(trimmed)  ; "HELLO WORLD"
lower := StrLower(trimmed)  ; "hello world"

; Replace
replaced := StrReplace(trimmed, "World", "AHK")  ; "Hello AHK"

; Extract substring
sub := SubStr(trimmed, 1, 5)  ; "Hello"

MsgBox("Original: '" text "'`n"
     . "Trimmed: '" trimmed "'`n"
     . "Upper: '" upper "'`n"
     . "Replaced: '" replaced "'")
```

---

### 8. File (83 files)

**Location:** `File_*.ahk`
**Count:** 83 files
**Difficulty:** Beginner to Intermediate

File system operations and file I/O.

#### Coverage

**Operations:**
- Reading files (FileRead, Loop Files)
- Writing files (FileAppend, FileOpen)
- File operations (Copy, Move, Delete)
- Directory operations (Create, Delete, Copy, Move)
- File attributes (Get/Set)
- File selection dialogs
- Path manipulation
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Write to file
filePath := A_ScriptDir "\test.txt"
FileAppend("Hello World`nLine 2", filePath)

; Read from file
content := FileRead(filePath)
MsgBox("Content:`n" content)

; Check if exists
if FileExist(filePath)
    MsgBox("File exists!")

; Delete file
FileDelete(filePath)
```

---

### 9. GUI (64 files)

**Location:** `GUI_*.ahk`
**Count:** 64 files
**Difficulty:** Beginner to Advanced

Graphical User Interface creation and manipulation.

#### Coverage

**Components:**
- Windows and dialogs
- Buttons, Edit controls, Text
- ListBox, ListView, TreeView
- DropDownList, ComboBox
- CheckBox, Radio buttons
- Progress bars, Sliders
- Menus and context menus
- Event handling
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Create GUI window
MyGui := Gui("+AlwaysOnTop", "My Application")

; Add controls
MyGui.AddText(, "Enter your name:")
NameEdit := MyGui.AddEdit("w200")
SubmitBtn := MyGui.AddButton("w200", "Submit")

; Event handler
SubmitBtn.OnEvent("Click", (*) => MsgBox("Hello, " NameEdit.Value "!"))

; Show GUI
MyGui.Show()
```

---

### 10. OOP (72 files)

**Location:** `OOP_*.ahk`
**Count:** 72 files
**Difficulty:** Intermediate to Advanced

Object-Oriented Programming patterns and techniques.

#### Coverage

**Concepts:**
- Class definitions
- Constructors (`__New`)
- Properties (get/set)
- Methods (instance and static)
- Inheritance
- Encapsulation
- Factory patterns
- Event emitters
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

class Person {
    name := ""
    age := 0

    __New(name, age) {
        this.name := name
        this.age := age
    }

    Greet() {
        return "Hello, I'm " this.name " and I'm " this.age " years old."
    }

    Birthday() {
        this.age++
        return "Happy birthday! Now " this.age " years old."
    }
}

john := Person("John", 30)
MsgBox(john.Greet())
MsgBox(john.Birthday())
```

---

### 11. Window (63 files)

**Location:** `Window_*.ahk`
**Count:** 63 files
**Difficulty:** Beginner to Intermediate

Window detection, manipulation, and automation.

#### Coverage

**Operations:**
- WinExist/WinActive - Detect windows
- WinWait/WinWaitActive - Wait for windows
- WinMove/WinGetPos - Position windows
- WinMinimize/WinMaximize/WinRestore - Window states
- WinClose/WinKill - Close windows
- WinSetTitle/WinGetTitle - Window titles
- WinSetAlwaysOnTop - Pin windows
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Wait for Notepad to exist
WinWait("ahk_exe notepad.exe")

; Activate it
WinActivate("ahk_exe notepad.exe")

; Move to top-left corner
WinMove(0, 0, 800, 600, "ahk_exe notepad.exe")

; Set always on top
WinSetAlwaysOnTop(1, "ahk_exe notepad.exe")

MsgBox("Notepad window manipulated!")
```

---

### 12. Advanced (50 files)

**Location:** `Advanced_*.ahk`
**Count:** 50 files
**Difficulty:** Advanced

Advanced programming patterns and techniques.

#### Coverage

**Topics:**
- Closures and nested functions
- Callbacks and delegates
- Error handling (try/catch/throw)
- Memory management
- DllCall and Windows API
- COM objects
- Asynchronous patterns
- Performance optimization
- Design patterns
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Closure example
MakeCounter() {
    count := 0

    return (*) => {
        count++
        return count
    }
}

counter1 := MakeCounter()
counter2 := MakeCounter()

MsgBox("Counter1: " counter1())  ; 1
MsgBox("Counter1: " counter1())  ; 2
MsgBox("Counter2: " counter2())  ; 1 (separate state)
```

---

### 13. Control Flow (43 files)

**Location:** `Control_*.ahk`
**Count:** 43 files
**Difficulty:** Beginner to Intermediate

Flow control structures and logic.

#### Coverage

**Structures:**
- If/Else conditionals
- Switch/Case statements
- Loop (For, While, Until)
- Loop Files - Iterate files
- Loop Parse - Parse strings
- Loop Read - Read file lines
- Break and Continue
- Return values
- Error handling
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; If/Else
age := 25
if (age >= 18)
    MsgBox("Adult")
else
    MsgBox("Minor")

; Switch/Case
day := A_WDay
switch day {
    case 1: MsgBox("Sunday")
    case 7: MsgBox("Saturday")
    default: MsgBox("Weekday")
}

; Loop
Loop 5 {
    MsgBox("Iteration " A_Index)
}

; Loop Files
Loop Files, A_ScriptDir "\*.ahk" {
    MsgBox("Found: " A_LoopFileName)
    break  ; Show only first one
}
```

---

### 14. Misc (35 files)

**Location:** `Misc_*.ahk`
**Count:** 35 files
**Difficulty:** Varied

Miscellaneous utilities and functions that don't fit other categories.

#### Coverage

**Topics:**
- SplitPath - Parse file paths
- A_Variables - Built-in variables
- EnvGet/EnvSet - Environment variables
- IniRead/IniWrite - INI files
- ComObject - COM automation
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Split file path
fullPath := "C:\Users\John\Documents\file.txt"
SplitPath(fullPath, &name, &dir, &ext, &nameNoExt, &drive)

MsgBox("File: " name "`n"
     . "Dir: " dir "`n"
     . "Ext: " ext "`n"
     . "Name (no ext): " nameNoExt "`n"
     . "Drive: " drive)
```

---

### 15. Process (20 files)

**Location:** `Process_*.ahk`
**Count:** 20 files
**Difficulty:** Beginner to Intermediate

Process management and automation.

#### Coverage

**Operations:**
- ProcessExist - Check if running
- ProcessWait - Wait for process
- ProcessClose - Terminate process
- Run/RunWait - Launch programs
- Process priority
- Process listing
- And more...

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Check if Notepad is running
if ProcessExist("notepad.exe")
    MsgBox("Notepad is running")
else
    MsgBox("Notepad is not running")

; Launch Notepad
Run("notepad.exe")

; Wait for it to exist
ProcessWait("notepad.exe")
MsgBox("Notepad has started!")
```

---

### 16. Registry (10 files)

**Location:** `Registry_*.ahk`
**Count:** 10 files
**Difficulty:** Intermediate

Windows Registry operations.

#### Coverage

**Operations:**
- RegRead - Read registry values
- RegWrite - Write registry values
- RegDelete - Delete registry values
- RegDeleteKey - Delete registry keys
- Registry key types (REG_SZ, REG_DWORD, etc.)

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Read registry value
try {
    value := RegRead("HKEY_CURRENT_USER\Software\AutoHotkey", "Version")
    MsgBox("AutoHotkey Version: " value)
} catch {
    MsgBox("Could not read registry")
}

; Write registry value (use with caution!)
; RegWrite("My Value", "REG_SZ", "HKEY_CURRENT_USER\Software\MyApp", "MyKey")
```

---

### 17. Flow (4 files)

**Location:** `Flow_*.ahk`
**Count:** 4 files
**Difficulty:** Beginner

Basic flow control and timing.

#### Coverage

**Functions:**
- Sleep - Pause execution
- SetTimer - Timed callbacks
- Timing patterns

**Example:**
```autohotkey
#Requires AutoHotkey v2.0

; Simple sleep
MsgBox("Starting...")
Sleep(2000)  ; 2 seconds
MsgBox("2 seconds later!")

; Timer
count := 0
ShowCount(*) {
    global count
    count++
    ToolTip("Count: " count)
    if (count >= 5)
        SetTimer(ShowCount, 0)  ; Stop timer
}

SetTimer(ShowCount, 1000)  ; Every 1 second
```

---

## How to Use This Guide

### For LLM Training

1. **Sequential Learning:**
   - Start with Hotkeys (core feature)
   - Move to Hotstrings (text automation)
   - Learn data structures (Arrays)
   - Master built-in functions (StdLib)
   - Explore advanced topics

2. **Pattern Recognition:**
   - Each file demonstrates specific patterns
   - Comments explain the "why" not just "what"
   - Examples progress from simple to complex

3. **Complete Coverage:**
   - 940 examples cover nearly all AHK v2 features
   - Multiple examples of the same concept (different contexts)
   - Real-world patterns from GitHub

### For Human Learners

1. **Start Here:**
   - `Hotkey_01_Basic_F1.ahk` - Your first hotkey
   - `Hotstring_41_Basic.ahk` - Text expansion basics
   - `StdLib_66_MsgBox.ahk` - User interaction

2. **Practice Path:**
   - Create 5 personal hotkeys
   - Create 5 personal hotstrings
   - Manipulate files and folders
   - Build a simple GUI
   - Automate a window

3. **Advanced Topics:**
   - Study Array_Advanced_* for algorithms
   - Review OOP_* for object-oriented patterns
   - Explore Advanced_* for professional techniques

### For Reference

Use the [Quick Statistics](#quick-statistics) table to find:
- Total files in each category
- Coverage level (Complete, Extensive, etc.)
- Jump to relevant section

---

## File Naming Conventions

### Pattern

`Category_Number_Description.ahk`

### Examples

- `Hotkey_01_Basic_F1.ahk`
- `Array_Standalone_09_FlattenDeep.ahk`
- `StdLib_42_Random.ahk`
- `Library_JSON_15Examples.ahk`

### Categories

- `Hotkey_` - Keyboard shortcuts
- `Hotstring_` - Text replacement
- `Array_` - Array operations (library)
- `Array_Standalone_` - Array operations (pure)
- `Array_Advanced_` - Advanced array patterns
- `StdLib_` - Built-in functions
- `Library_` - Third-party libraries
- `GitHub_Example_` - Real-world code
- `String_` - String manipulation
- `File_` - File operations
- `GUI_` - Graphical interfaces
- `OOP_` - Object-oriented programming
- `Window_` - Window management
- `Advanced_` - Advanced patterns
- `Control_` - Flow control
- `Misc_` - Miscellaneous
- `Process_` - Process management
- `Registry_` - Registry operations
- `Flow_` - Timing and flow

---

## Learning Paths

### Path 1: Absolute Beginner (10 files)

Start here if you've never used AutoHotkey:

1. `Hotkey_01_Basic_F1.ahk` - Your first hotkey
2. `Hotkey_03_Ctrl_Modifier.ahk` - Modifier keys
3. `Hotstring_41_Basic.ahk` - Text replacement
4. `StdLib_66_MsgBox.ahk` - Show messages
5. `StdLib_01_FileRead.ahk` - Read files
6. `StdLib_84_WinMove.ahk` - Move windows
7. `Control_If_01.ahk` - Conditionals
8. `Control_Loop_01.ahk` - Loops
9. `Array_01_Chunk.ahk` - Arrays basics
10. `GUI_Simple.ahk` - Create a window

### Path 2: Hotkey Master (20 files)

Master keyboard automation:

1. Files `Hotkey_01` through `Hotkey_10` - Basics
2. Files `Hotkey_11` through `Hotkey_20` - Advanced modifiers
3. Files `Hotkey_21` through `Hotkey_30` - Dynamic control
4. Files `Hotkey_31` through `Hotkey_40` - Context-sensitive

### Path 3: Text Automation (15 files)

Become a text expansion expert:

1. Files `Hotstring_41` through `Hotstring_50` - All hotstring techniques
2. `String_SubStr_*.ahk` - String extraction
3. `String_InStr_*.ahk` - String searching
4. `String_Replace_*.ahk` - String replacement
5. `StdLib_22_StrReplace.ahk` - Built-in replacement

### Path 4: GUI Developer (25 files)

Build graphical applications:

1. `GUI_Basic_*.ahk` - Basic windows
2. `GUI_Controls_*.ahk` - Buttons, text, edits
3. `GUI_Events_*.ahk` - Handle user input
4. `GUI_Advanced_*.ahk` - Complex layouts
5. `GitHub_Example_03_Notification_GUI.ahk` - Real-world pattern

### Path 5: Professional Coder (30 files)

Write production-quality code:

1. Files `Array_Advanced_01` through `Array_Advanced_18` - Algorithms
2. Files `Advanced_*` - Design patterns
3. Files `OOP_*` - Object-oriented architecture
4. `GitHub_Example_01_CreateGUID.ahk` - DllCall mastery
5. `Library_*` - External libraries

### Path 6: Windows Automation (20 files)

Automate Windows applications:

1. `Window_Exist_*.ahk` - Detect windows
2. `Window_Move_*.ahk` - Position windows
3. `Window_Control_*.ahk` - Manipulate windows
4. `Process_*.ahk` - Manage processes
5. `StdLib_Send_*.ahk` - Send keystrokes
6. `StdLib_Click_*.ahk` - Automate mouse

---

## Statistics Summary

**Dataset Composition:**

| Type | Count | Percentage |
|------|-------|------------|
| Language Features | 667 | 71.0% |
| Core Automation (Hotkeys/Hotstrings) | 84 | 8.9% |
| Data Structures (Arrays) | 82 | 8.7% |
| Standard Library | 95 | 10.1% |
| External Libraries | 16 | 1.7% |
| **TOTAL** | **940** | **100%** |

**Coverage Quality:**

- ✅ Complete: Hotkeys, Hotstrings, Arrays, StdLib, Control Flow
- ✅ Extensive: Strings, Files, GUI, OOP, Windows, Advanced
- ✅ Core Features: Process, Registry, Flow
- ✅ Selective: External Libraries, GitHub Examples

**Educational Value:**

- 🎯 **Beginner-friendly:** 300+ files
- 🎯 **Intermediate:** 400+ files
- 🎯 **Advanced:** 240+ files

---

## Version Information

- **AutoHotkey Version:** v2.0+
- **All files include:** `#Requires AutoHotkey v2.0`
- **Syntax:** Expression-based (v2 syntax)
- **Compatibility:** Windows 7+

---

## Additional Resources

### Documentation References

For detailed official documentation, visit:
- https://www.autohotkey.com/docs/v2/

### Community Resources

- Forums: https://www.autohotkey.com/boards/
- GitHub: https://github.com/topics/autohotkey

### Related Files

- `PRUNING_RECOMMENDATIONS.md` - Dataset quality analysis
- `EXAMPLES_SUMMARY.md` - Project statistics
- `GITHUB_SCRAPING_GUIDE.md` - Finding more examples

---

## Maintenance

**Last Audit:** 2025-11-08
**Dataset Version:** 2.0
**Status:** Active development

### Recent Changes

1. Added 50 Hotkey/Hotstring examples (2025-11-08)
2. Pruned 214 redundant examples (2025-11-08)
3. Added 95 StdLib examples (2025-11-07)
4. Added 82 Array examples (2025-11-07)

---

**End of Guide** - 940 examples documented

For questions or contributions, refer to the repository documentation.
