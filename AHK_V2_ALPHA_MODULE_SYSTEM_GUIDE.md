# AutoHotkey v2-alpha Module System - Complete Guide

**Last Updated:** 2025-11-15
**Version:** AutoHotkey v2.1-alpha.17+
**Total Examples:** 30+ module-focused files

---

## Table of Contents

1. [Overview](#overview)
2. [Why Use Modules?](#why-use-modules)
3. [Module System Tiers](#module-system-tiers)
4. [Tier 1: Module Fundamentals](#tier-1-module-fundamentals)
5. [Tier 2: Selective Imports and Aliases](#tier-2-selective-imports-and-aliases)
6. [Tier 3: Advanced Patterns](#tier-3-advanced-patterns)
7. [Complete Examples](#complete-examples)
8. [Best Practices](#best-practices)
9. [Common Patterns](#common-patterns)
10. [Troubleshooting](#troubleshooting)

---

## Overview

The AutoHotkey v2-alpha introduces a **module system** that enables:

- **Code Reusability** - Share utilities across multiple scripts
- **Namespace Management** - Avoid name collisions
- **Clean APIs** - Export only what consumers need
- **Dependency Management** - Explicit import/export relationships
- **Better Organization** - Structure large projects effectively

### Key Directives

```autohotkey
#Module ModuleName          ; Declare a module
Export FunctionName() { }   ; Export a symbol
Import ModuleName           ; Import entire module
Import { Func } from Mod    ; Selective import
Import "path/to/file.ahk"   ; Import by path
```

### Critical Rules

1. **Declare `#Module` BEFORE defining exports** - Every helper needs an explicit module scope
2. **Use `Export` on EVERY symbol** you want to expose - Functions, classes, or variables
3. **Keep side effects idempotent** - Provide setup routines that can be called multiple times safely
4. **Structure matters** - Place reusable modules under `scripts/v2/` or `Lib/`

---

## Why Use Modules?

### Without Modules (Old Way)

```autohotkey
; MyScript.ahk
#Include Utils.ahk
#Include StringHelpers.ahk
#Include ArrayHelpers.ahk

; All functions from all files are now in global scope
; Risk of name collisions!
; Which file did "Capitalize" come from?
result := Capitalize("hello")  ; ❌ Unclear origin
```

### With Modules (New Way)

```autohotkey
; MyScript.ahk
#Requires AutoHotkey v2.1-alpha.17

Import StringHelpers
Import ArrayHelpers

; Clear namespace and origin
result := StringHelpers.Capitalize("hello")  ; ✅ Explicit
array := ArrayHelpers.Chunk([1,2,3,4], 2)   ; ✅ Clear
```

**Benefits:**
- ✅ No name collisions
- ✅ Clear dependency tracking
- ✅ Selective imports (import only what you need)
- ✅ Better code organization
- ✅ Easier maintenance

---

## Module System Tiers

The module system has three tiers of complexity:

| Tier | Focus | Use When |
|------|-------|----------|
| **Tier 1** | Module basics | Creating first reusable module |
| **Tier 2** | Selective imports & aliases | Managing multiple modules, avoiding conflicts |
| **Tier 3** | Re-exports & search paths | Building module bundles, complex projects |

---

## Tier 1: Module Fundamentals

### 1.1 Basic Module Definition

**File: `scripts/v2/MathHelpers.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module MathHelpers

; Export individual functions
Export Add(a, b) {
    return a + b
}

Export Multiply(a, b) {
    return a * b
}

Export Square(n) {
    return n * n
}

; Private helper (NOT exported)
InternalHelper() {
    ; Only available within this module
    return "private"
}
```

**Consumer: `test_math.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

Import MathHelpers as Math

; Use module functions with namespace
result1 := Math.Add(5, 3)        ; 8
result2 := Math.Multiply(4, 7)   ; 28
result3 := Math.Square(5)        ; 25

MsgBox("Add: " result1 "`nMultiply: " result2 "`nSquare: " result3)
```

### 1.2 Module with Classes

**File: `scripts/v2/DataStructures.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module DataStructures

Export class Stack {
    items := []

    Push(value) {
        this.items.Push(value)
    }

    Pop() {
        if this.items.Length = 0
            throw Error("Stack is empty")
        return this.items.Pop()
    }

    Peek() {
        if this.items.Length = 0
            throw Error("Stack is empty")
        return this.items[this.items.Length]
    }

    IsEmpty() {
        return this.items.Length = 0
    }
}

Export class Queue {
    items := []

    Enqueue(value) {
        this.items.Push(value)
    }

    Dequeue() {
        if this.items.Length = 0
            throw Error("Queue is empty")
        return this.items.RemoveAt(1)
    }

    IsEmpty() {
        return this.items.Length = 0
    }
}
```

**Consumer:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
Import DataStructures as DS

; Create and use Stack
stack := DS.Stack()
stack.Push(1)
stack.Push(2)
stack.Push(3)
MsgBox("Popped: " stack.Pop())  ; 3

; Create and use Queue
queue := DS.Queue()
queue.Enqueue("First")
queue.Enqueue("Second")
MsgBox("Dequeued: " queue.Dequeue())  ; "First"
```

### 1.3 Module with Constants

**File: `scripts/v2/Constants.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Constants

; Export constants
Export PI := 3.14159265359
Export E := 2.71828182846
Export GOLDEN_RATIO := 1.61803398875

; Export configuration
Export class Config {
    static APP_NAME := "MyApp"
    static VERSION := "1.0.0"
    static DEBUG := true
}
```

**Consumer:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
Import Constants

; Use exported constants
circleArea := Constants.PI * (5 ** 2)
MsgBox("Circle area: " circleArea)
MsgBox("App: " Constants.Config.APP_NAME " v" Constants.Config.VERSION)
```

---

## Tier 2: Selective Imports and Aliases

### 2.1 Selective Imports

Instead of importing the entire module, import only specific functions.

**File: `scripts/v2/StringHelpers.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module StringHelpers

Export CollapseWhitespace(text) {
    if text = ""
        return ""
    cleaned := RegExReplace(text, "\s+", " ")
    return Trim(cleaned)
}

Export ToTitleCase(text) {
    text := CollapseWhitespace(text)
    if text = ""
        return ""

    words := StrSplit(text, " ")
    for index, word in words {
        if word = ""
            continue
        words[index] := Format("{1:U}{2:L}", SubStr(word, 1, 1), SubStr(word, 2))
    }
    return words.Join(" ")
}

Export ToCamelCase(text) {
    text := ToTitleCase(text)
    text := StrReplace(text, " ", "")
    if text = ""
        return ""
    return Format("{1:L}{2}", SubStr(text, 1, 1), SubStr(text, 2))
}

Export ToSnakeCase(text) {
    text := CollapseWhitespace(text)
    text := StrLower(text)
    return StrReplace(text, " ", "_")
}
```

**Consumer with Selective Imports:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Import only specific functions
Import { ToTitleCase, ToSnakeCase } from StringHelpers

; Use imported functions directly (no namespace needed)
title := ToTitleCase("hello world from ahk")
snake := ToSnakeCase("Hello World From AHK")

MsgBox("Title: " title "`nSnake: " snake)
```

### 2.2 Import Aliases

Use aliases to avoid name collisions or improve readability.

**Multiple modules with similar names:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17

Import { Join as JoinArray } from ArrayHelpers
Import { Join as JoinString } from StringHelpers

; Clear which Join we're using
array := JoinArray([1, 2, 3], "-")      ; "1-2-3"
str := JoinString(["a", "b", "c"], "|") ; "a|b|c"
```

**Renaming for clarity:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17

Import {
    ToTitleCase as Title,
    ToCamelCase as Camel,
    ToSnakeCase as Snake
} from StringHelpers

input := "hello world"
MsgBox("Title: " Title(input)
     . "`nCamel: " Camel(input)
     . "`nSnake: " Snake(input))
```

### 2.3 Mixing Module and Selective Imports

**File: `scripts/v2/ArrayHelpers.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module ArrayHelpers

SetupArrayHelpers()

Export EnsureArrayHelpers() {
    SetupArrayHelpers()
}

Export Join(array, sep := ",") {
    SetupArrayHelpers()
    return array.Join(sep)
}

Export Split(text, sep := ",", target := unset) {
    SetupArrayHelpers()
    if !IsSet(target)
        target := []
    target.Split(text, sep)
    return target
}

Export Chunk(array, size) {
    result := []
    Loop {
        start := (A_Index - 1) * size + 1
        if start > array.Length
            break
        chunk := []
        Loop size {
            idx := start + A_Index - 1
            if idx > array.Length
                break
            chunk.Push(array[idx])
        }
        result.Push(chunk)
    }
    return result
}

SetupArrayHelpers() {
    static applied := false
    if applied
        return

    applied := true

    if !ObjHasOwnProp(Array.Prototype, "Join") {
        Array.Prototype.DefineProp("Join", {
            call: (array, sep := ",") => {
                result := ""
                for index, value in array
                    result .= value (index < array.Length ? sep : "")
                return result
            }
        })
    }

    if !ObjHasOwnProp(Array.Prototype, "Split") {
        Array.Prototype.DefineProp("Split", {
            call: (array, text, sep := ",") => {
                for value in StrSplit(text, sep)
                    array.Push(value)
                return array
            }
        })
    }
}
```

**Consumer mixing approaches:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Import entire module
Import ArrayHelpers

; Also import specific functions with aliases
Import { Join as JoinArray, Chunk } from ArrayHelpers

; Initialize (important for prototype extensions!)
ArrayHelpers.EnsureArrayHelpers()

; Use module namespace
values := ["one", "two", "three"]
result1 := ArrayHelpers.Join(values, " - ")

; Use selective import
result2 := JoinArray(values, " | ")

; Use another selective import
chunks := Chunk([1,2,3,4,5,6], 2)

MsgBox("Module: " result1
     . "`nSelective: " result2
     . "`nChunks: " chunks.Length " chunks")
```

### 2.4 Idempotent Setup Patterns

When modules need to perform initialization (like prototype extensions), make it safe to call multiple times.

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module MyModule

; Setup function with guard
SetupModule() {
    static initialized := false
    if initialized
        return  ; Already done, skip

    initialized := true

    ; Safe to perform initialization here
    ; This will only run once even if called multiple times

    ; Example: Add prototype methods
    if !ObjHasOwnProp(Array.Prototype, "CustomMethod") {
        Array.Prototype.DefineProp("CustomMethod", {
            call: (arr) => {
                ; Custom logic
            }
        })
    }
}

; Export the setup function
Export EnsureSetup() {
    SetupModule()
}

; Call setup on module load
SetupModule()

; Export other functions that depend on setup
Export DoSomething() {
    SetupModule()  ; Ensure setup is done
    ; ... your logic
}
```

---

## Tier 3: Advanced Patterns

### 3.1 Re-exports (Module Bundles)

Create aggregate modules that bundle related functionality.

**File: `scripts/v2/Helpers.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Helpers

; Import sub-modules
Import ArrayHelpers
Import StringHelpers
Import MathHelpers

; Initialize any needed setup
ArrayHelpers.EnsureArrayHelpers()

; Export a bundle object with easy access
Export HelpersReady() {
    return {
        ; Array helpers
        JoinArray: ArrayHelpers.Join,
        ChunkArray: ArrayHelpers.Chunk,

        ; String helpers
        TitleCase: StringHelpers.ToTitleCase,
        SnakeCase: StringHelpers.ToSnakeCase,

        ; Math helpers
        Add: MathHelpers.Add,
        Square: MathHelpers.Square
    }
}

; Re-export entire sub-modules
Export { ArrayHelpers, StringHelpers, MathHelpers }
```

**Consumer:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

Import Helpers

; Get bundled helpers
H := Helpers.HelpersReady()

; Use bundled functions
result := H.TitleCase("hello world")
chunks := H.ChunkArray([1,2,3,4,5,6], 2)

MsgBox("Title: " result "`nChunks: " chunks.Length)

; Or access sub-modules directly
direct := Helpers.StringHelpers.ToSnakeCase("Hello World")
MsgBox("Snake: " direct)
```

### 3.2 Path-based Imports

Import modules by explicit file path (useful for build systems or non-standard locations).

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Import by relative path
Import "scripts/v2/Helpers.ahk" as HelpersModule

; Import by absolute path
Import "C:\MyProject\lib\CustomModule.ahk" as Custom

; Use them
bundle := HelpersModule.HelpersReady()
MsgBox(bundle.TitleCase("path based import"))
```

### 3.3 Search Path Configuration

Set up environment variable to find modules automatically.

**Setup script:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17

; Configure search path
EnvSet("AhkImportPath", A_ScriptDir "\scripts\v2")

; Now imports will search this path automatically
Import Helpers  ; Finds scripts/v2/Helpers.ahk
Import ArrayHelpers  ; Finds scripts/v2/ArrayHelpers.ahk

bundle := Helpers.HelpersReady()
MsgBox(bundle.TitleCase("auto discovery works"))
```

### 3.4 Conditional Exports

Export different implementations based on conditions.

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Platform

; Detect platform
IS_64BIT := (A_PtrSize = 8)
IS_WINDOWS_10_PLUS := (VerCompare(A_OSVersion, "10.0") >= 0)

; Export platform-specific implementations
if IS_64BIT {
    Export GetSystemInfo() {
        return "64-bit system info"
    }
} else {
    Export GetSystemInfo() {
        return "32-bit system info"
    }
}

; Export platform detection
Export IsPlatform64Bit() {
    return IS_64BIT
}

Export IsWindows10Plus() {
    return IS_WINDOWS_10_PLUS
}
```

### 3.5 Nested Module Namespaces

Organize complex projects with nested namespaces.

**File: `scripts/v2/UI/Components.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module UI.Components

Export class Button {
    text := ""
    __New(text) {
        this.text := text
    }
    Render() {
        return "Button: " this.text
    }
}

Export class Input {
    placeholder := ""
    __New(placeholder) {
        this.placeholder := placeholder
    }
    Render() {
        return "Input: " this.placeholder
    }
}
```

**File: `scripts/v2/UI/Layout.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module UI.Layout

Export class Grid {
    rows := 0
    cols := 0
    __New(rows, cols) {
        this.rows := rows
        this.cols := cols
    }
    Render() {
        return "Grid: " this.rows "x" this.cols
    }
}
```

**File: `scripts/v2/UI/index.ahk`** (Bundle)

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module UI

Import UI.Components
Import UI.Layout

Export { Components, Layout }
```

**Consumer:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
Import UI

; Access nested modules
btn := UI.Components.Button("Click Me")
grid := UI.Layout.Grid(3, 4)

MsgBox(btn.Render() "`n" grid.Render())
```

---

## Complete Examples

### Example 1: Full-Stack Utility Library

**Structure:**
```
MyProject/
├── scripts/v2/
│   ├── ArrayUtils.ahk
│   ├── StringUtils.ahk
│   ├── FileUtils.ahk
│   └── Utils.ahk (bundle)
└── app.ahk
```

**ArrayUtils.ahk:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module ArrayUtils

Export Chunk(arr, size) {
    result := []
    Loop {
        start := (A_Index - 1) * size + 1
        if start > arr.Length
            break
        chunk := []
        Loop size {
            idx := start + A_Index - 1
            if idx > arr.Length
                break
            chunk.Push(arr[idx])
        }
        result.Push(chunk)
    }
    return result
}

Export Flatten(arr) {
    result := []
    for value in arr {
        if (IsObject(value) && value is Array)
            for item in value
                result.Push(item)
        else
            result.Push(value)
    }
    return result
}

Export Unique(arr) {
    seen := Map()
    result := []
    for value in arr {
        key := String(value)
        if !seen.Has(key) {
            seen[key] := true
            result.Push(value)
        }
    }
    return result
}
```

**StringUtils.ahk:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module StringUtils

Export Truncate(text, maxLen, suffix := "...") {
    if StrLen(text) <= maxLen
        return text
    return SubStr(text, 1, maxLen - StrLen(suffix)) suffix
}

Export Capitalize(text) {
    if text = ""
        return ""
    return Format("{1:U}{2:L}", SubStr(text, 1, 1), SubStr(text, 2))
}

Export Reverse(text) {
    result := ""
    Loop Parse, text
        result := A_LoopField result
    return result
}

Export WordCount(text) {
    text := Trim(RegExReplace(text, "\s+", " "))
    if text = ""
        return 0
    return StrSplit(text, " ").Length
}
```

**FileUtils.ahk:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module FileUtils

Export ReadLines(filePath) {
    if !FileExist(filePath)
        throw Error("File not found: " filePath)
    content := FileRead(filePath)
    return StrSplit(content, "`n", "`r")
}

Export WriteLines(filePath, lines) {
    content := ""
    for line in lines
        content .= line "`n"
    FileDelete(filePath)
    FileAppend(content, filePath)
}

Export EnsureDir(dirPath) {
    if !DirExist(dirPath)
        DirCreate(dirPath)
    return dirPath
}

Export GetExtension(filePath) {
    SplitPath(filePath, , , &ext)
    return ext
}
```

**Utils.ahk (Bundle):**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Utils

Import ArrayUtils
Import StringUtils
Import FileUtils

Export Ready() {
    return {
        Array: ArrayUtils,
        String: StringUtils,
        File: FileUtils
    }
}

Export { ArrayUtils, StringUtils, FileUtils }
```

**app.ahk (Consumer):**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

Import Utils

; Get bundled utilities
U := Utils.Ready()

; Array operations
numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9]
chunks := U.Array.Chunk(numbers, 3)
MsgBox("Chunks: " chunks.Length)  ; 3 chunks

; String operations
text := "hello world from autohotkey modules"
title := U.String.Capitalize(text)
words := U.String.WordCount(text)
MsgBox("Title: " title "`nWords: " words)

; File operations (example)
testFile := A_ScriptDir "\test.txt"
U.File.WriteLines(testFile, ["Line 1", "Line 2", "Line 3"])
lines := U.File.ReadLines(testFile)
MsgBox("Read " lines.Length " lines")
FileDelete(testFile)
```

### Example 2: GUI Component Library

**File: `scripts/v2/GuiComponents.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module GuiComponents

Export class Dialog {
    static Info(message, title := "Information") {
        return MsgBox(message, title, "Icon!")
    }

    static Error(message, title := "Error") {
        return MsgBox(message, title, "Icon!")
    }

    static Confirm(message, title := "Confirm") {
        result := MsgBox(message, title, "YesNo Icon?")
        return result = "Yes"
    }

    static Input(prompt, title := "Input", default := "") {
        ib := InputBox(prompt, title, , default)
        if ib.Result = "Cancel"
            return ""
        return ib.Value
    }
}

Export class Toast {
    static Show(message, duration := 2000) {
        ToolTip(message)
        SetTimer(() => ToolTip(), -duration)
    }
}

Export CreateSimpleGui(title, width := 300, height := 200) {
    g := Gui("+AlwaysOnTop", title)
    g.Show("w" width " h" height)
    return g
}
```

**Consumer:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

Import { Dialog, Toast, CreateSimpleGui } from GuiComponents

; Show dialog
Dialog.Info("Module system is working!")

; Get user input
name := Dialog.Input("Enter your name:", "Greeting", "User")
if name != ""
    Toast.Show("Hello, " name "!")

; Confirm action
if Dialog.Confirm("Do you want to continue?", "Confirmation") {
    Toast.Show("Continuing...")
} else {
    Toast.Show("Cancelled")
}
```

### Example 3: Validation Module

**File: `scripts/v2/Validators.ahk`**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Validators

Export class Validator {
    static IsEmail(text) {
        pattern := "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
        return RegExMatch(text, pattern) > 0
    }

    static IsURL(text) {
        pattern := "^https?://[^\s]+$"
        return RegExMatch(text, pattern) > 0
    }

    static IsNumeric(text) {
        return IsNumber(text)
    }

    static IsInRange(value, min, max) {
        if !IsNumber(value)
            return false
        return value >= min && value <= max
    }

    static MinLength(text, length) {
        return StrLen(text) >= length
    }

    static MaxLength(text, length) {
        return StrLen(text) <= length
    }

    static Matches(text, pattern) {
        return RegExMatch(text, pattern) > 0
    }
}

Export Validate(value, rules*) {
    errors := []

    for rule in rules {
        if !rule.test(value)
            errors.Push(rule.message)
    }

    return {
        isValid: errors.Length = 0,
        errors: errors
    }
}

Export Rule(test, message) {
    return {
        test: test,
        message: message
    }
}
```

**Consumer:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
Import { Validator, Validate, Rule } from Validators

; Simple validation
email := "test@example.com"
if Validator.IsEmail(email)
    MsgBox("Valid email!")
else
    MsgBox("Invalid email!")

; Complex validation with rules
password := "abc"
result := Validate(password,
    Rule((v) => Validator.MinLength(v, 8), "Password must be at least 8 characters"),
    Rule((v) => Validator.Matches(v, "[A-Z]"), "Password must contain uppercase letter"),
    Rule((v) => Validator.Matches(v, "[0-9]"), "Password must contain number")
)

if result.isValid {
    MsgBox("Password is valid!")
} else {
    errors := ""
    for error in result.errors
        errors .= "• " error "`n"
    MsgBox("Password validation failed:`n`n" errors)
}
```

---

## Best Practices

### 1. Module File Organization

```
YourProject/
├── scripts/
│   └── v2/
│       ├── core/
│       │   ├── Arrays.ahk
│       │   ├── Strings.ahk
│       │   └── Objects.ahk
│       ├── ui/
│       │   ├── Components.ahk
│       │   └── Layout.ahk
│       ├── utils/
│       │   ├── Validators.ahk
│       │   └── Formatters.ahk
│       └── index.ahk (main bundle)
└── app.ahk
```

### 2. Naming Conventions

- **Module files:** PascalCase - `StringHelpers.ahk`, `ArrayUtils.ahk`
- **Module names:** Match filename - `#Module StringHelpers`
- **Exported functions:** PascalCase - `Export ToTitleCase()`
- **Private functions:** camelCase or PascalCase (not exported)

### 3. Documentation

Always document your modules:

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module StringHelpers

/**
 * StringHelpers Module
 * Provides utility functions for string manipulation
 *
 * @example
 *   Import StringHelpers
 *   result := StringHelpers.ToTitleCase("hello world")
 */

/**
 * Convert string to title case
 * @param text {String} - Input text
 * @returns {String} - Title cased text
 * @example ToTitleCase("hello world") => "Hello World"
 */
Export ToTitleCase(text) {
    ; Implementation
}
```

### 4. Avoid Side Effects

❌ **Bad:**

```autohotkey
#Module BadModule

; This runs immediately on import - BAD!
MsgBox("Module loaded!")  ; ❌ Side effect

; Modifies global state without guard
Array.Prototype.DefineProp("BadMethod", { })  ; ❌ Runs every import
```

✅ **Good:**

```autohotkey
#Module GoodModule

; Setup function with guard
SetupModule() {
    static initialized := false
    if initialized
        return
    initialized := true

    ; Safe to run once
    Array.Prototype.DefineProp("GoodMethod", { })
}

Export EnsureSetup() {
    SetupModule()
}

; Optionally auto-setup
SetupModule()
```

### 5. Clear Dependencies

Make dependencies explicit:

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module MyModule

; Declare dependencies at the top
Import ArrayHelpers
Import StringHelpers

; Document what you need
Export ProcessData(data) {
    ; Uses ArrayHelpers.Chunk
    ; Uses StringHelpers.ToTitleCase
    ; ...
}
```

### 6. Test Your Modules

Create test files for each module:

```
scripts/v2/
├── StringHelpers.ahk
├── ArrayHelpers.ahk
└── tests/
    ├── test_StringHelpers.ahk
    └── test_ArrayHelpers.ahk
```

**test_StringHelpers.ahk:**

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

Import StringHelpers

; Test ToTitleCase
result1 := StringHelpers.ToTitleCase("hello world")
expected1 := "Hello World"
if result1 != expected1
    MsgBox("FAIL: ToTitleCase - got " result1 ", expected " expected1)
else
    MsgBox("PASS: ToTitleCase")

; Test ToSnakeCase
result2 := StringHelpers.ToSnakeCase("Hello World")
expected2 := "hello_world"
if result2 != expected2
    MsgBox("FAIL: ToSnakeCase - got " result2 ", expected " expected2)
else
    MsgBox("PASS: ToSnakeCase")
```

---

## Common Patterns

### Pattern 1: Functional Utilities Module

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Functional

Export Compose(functions*) {
    return (value) => {
        for func in functions
            value := func(value)
        return value
    }
}

Export Pipe(functions*) {
    return (value) => {
        reversedFuncs := []
        Loop functions.Length
            reversedFuncs.Push(functions[functions.Length - A_Index + 1])
        for func in reversedFuncs
            value := func(value)
        return value
    }
}

Export Curry(fn, args*) {
    return (nextArgs*) => {
        allArgs := args.Clone()
        for arg in nextArgs
            allArgs.Push(arg)
        return fn(allArgs*)
    }
}

Export Memoize(fn) {
    cache := Map()
    return (args*) => {
        key := JSON.Stringify(args)
        if !cache.Has(key)
            cache[key] := fn(args*)
        return cache[key]
    }
}
```

### Pattern 2: Builder Pattern Module

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Builders

Export class QueryBuilder {
    query := ""

    Select(fields*) {
        this.query := "SELECT " fields.Join(", ")
        return this
    }

    From(table) {
        this.query .= " FROM " table
        return this
    }

    Where(condition) {
        this.query .= " WHERE " condition
        return this
    }

    Build() {
        return this.query
    }
}

Export class UrlBuilder {
    protocol := "https"
    host := ""
    path := ""
    params := Map()

    SetProtocol(protocol) {
        this.protocol := protocol
        return this
    }

    SetHost(host) {
        this.host := host
        return this
    }

    SetPath(path) {
        this.path := path
        return this
    }

    AddParam(key, value) {
        this.params[key] := value
        return this
    }

    Build() {
        url := this.protocol "://" this.host this.path
        if this.params.Count > 0 {
            url .= "?"
            first := true
            for key, value in this.params {
                if !first
                    url .= "&"
                url .= key "=" value
                first := false
            }
        }
        return url
    }
}
```

### Pattern 3: Event System Module

```autohotkey
#Requires AutoHotkey v2.1-alpha.17
#Module Events

Export class EventEmitter {
    listeners := Map()

    On(event, handler) {
        if !this.listeners.Has(event)
            this.listeners[event] := []
        this.listeners[event].Push(handler)
        return this
    }

    Off(event, handler) {
        if !this.listeners.Has(event)
            return this

        handlers := this.listeners[event]
        newHandlers := []
        for h in handlers {
            if h != handler
                newHandlers.Push(h)
        }
        this.listeners[event] := newHandlers
        return this
    }

    Emit(event, args*) {
        if !this.listeners.Has(event)
            return this

        for handler in this.listeners[event]
            handler(args*)
        return this
    }
}

Export CreateEventBus() {
    return EventEmitter()
}
```

---

## Troubleshooting

### Issue 1: "Module not found"

**Problem:**
```autohotkey
Import MyModule  ; Error: Module not found
```

**Solutions:**

1. **Check file location** - Module file must be in include path
2. **Set AhkImportPath**:
   ```autohotkey
   EnvSet("AhkImportPath", A_ScriptDir "\scripts\v2")
   ```
3. **Use explicit path**:
   ```autohotkey
   Import "scripts/v2/MyModule.ahk" as MyModule
   ```

### Issue 2: "Function not found" after import

**Problem:**
```autohotkey
Import MyModule
MyModule.MyFunc()  ; Error: Function not found
```

**Solutions:**

1. **Check export**:
   ```autohotkey
   Export MyFunc() { }  ; Must have Export keyword
   ```
2. **Check module name matches**:
   ```autohotkey
   #Module MyModule  ; Must match import name
   ```

### Issue 3: Name collision

**Problem:**
```autohotkey
Import Module1
Import Module2
Module1.Init()  ; Which Init?
Module2.Init()  ; Confusing!
```

**Solutions:**

1. **Use aliases**:
   ```autohotkey
   Import Module1 as M1
   Import Module2 as M2
   M1.Init()
   M2.Init()
   ```

2. **Selective imports with aliases**:
   ```autohotkey
   Import { Init as Init1 } from Module1
   Import { Init as Init2 } from Module2
   Init1()
   Init2()
   ```

### Issue 4: Prototype extensions not working

**Problem:**
```autohotkey
Import ArrayHelpers
[1,2,3].CustomMethod()  ; Error: Method not found
```

**Solutions:**

1. **Call setup function**:
   ```autohotkey
   Import ArrayHelpers
   ArrayHelpers.EnsureSetup()  ; Initialize
   [1,2,3].CustomMethod()  ; Now works
   ```

2. **Auto-setup in module**:
   ```autohotkey
   #Module ArrayHelpers

   SetupPrototypes()  ; Auto-run on load

   Export EnsureSetup() {
       SetupPrototypes()
   }

   SetupPrototypes() {
       static initialized := false
       if initialized
           return
       initialized := true
       ; ... prototype extensions
   }
   ```

### Issue 5: Circular dependencies

**Problem:**
```autohotkey
; ModuleA.ahk
Import ModuleB
Export FuncA() { ModuleB.FuncB() }

; ModuleB.ahk
Import ModuleA
Export FuncB() { ModuleA.FuncA() }  ; Circular!
```

**Solutions:**

1. **Refactor to shared module**:
   ```autohotkey
   ; SharedModule.ahk
   Export SharedFunc() { }

   ; ModuleA.ahk
   Import SharedModule
   Export FuncA() { SharedModule.SharedFunc() }

   ; ModuleB.ahk
   Import SharedModule
   Export FuncB() { SharedModule.SharedFunc() }
   ```

2. **Use dependency injection**:
   ```autohotkey
   ; ModuleA.ahk
   Export FuncA(funcB) {  ; Pass dependency
       funcB()
   }

   ; Consumer
   Import ModuleA, ModuleB
   ModuleA.FuncA(ModuleB.FuncB)
   ```

---

## Summary

The AutoHotkey v2-alpha module system provides:

✅ **Clean code organization** with explicit modules
✅ **Namespace management** to avoid collisions
✅ **Selective imports** for better control
✅ **Reusable code** across projects
✅ **Clear dependencies** with import declarations
✅ **Professional structure** for large projects

### Quick Reference Card

```autohotkey
; Module definition
#Module ModuleName

; Export function
Export MyFunc() { }

; Export class
Export class MyClass { }

; Export variable
Export MyVar := "value"

; Import entire module
Import ModuleName

; Import with alias
Import ModuleName as Alias

; Selective import
Import { Func1, Func2 } from ModuleName

; Selective with alias
Import { Func as MyFunc } from ModuleName

; Path import
Import "path/to/Module.ahk" as Mod

; Set search path
EnvSet("AhkImportPath", "path")
```

### Next Steps

1. **Start simple** - Create your first module with Tier 1 patterns
2. **Practice selective imports** - Use Tier 2 for better control
3. **Build bundles** - Use Tier 3 to organize complex projects
4. **Study examples** - Review the 30+ example files in this guide
5. **Write tests** - Ensure your modules work as expected

---

**End of Guide**

For more examples, see the companion example files in:
- `data/raw_scripts/AHK_v2_Examples/Module_*`

For questions or contributions, refer to the repository documentation.
