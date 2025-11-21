# AutoHotkey v2 Examples - Comprehensive Feature Guide

**Generated:** November 5, 2025
**Based on:** 1,719 AHK v2 example files from `data/raw_scripts/AHK_v2_Examples/`

---

## Table of Contents

1. [Introduction](#introduction)
2. [Core Language Features](#core-language-features)
3. [Flow Control](#flow-control)
4. [String Operations](#string-operations)
5. [File and Directory Operations](#file-and-directory-operations)
6. [GUI (Graphical User Interface)](#gui-graphical-user-interface)
7. [Window Management](#window-management)
8. [Mouse and Keyboard Input](#mouse-and-keyboard-input)
9. [Directives](#directives)
10. [Date and Time Operations](#date-and-time-operations)
11. [Environment Variables](#environment-variables)
12. [Process Management](#process-management)
13. [Registry Operations](#registry-operations)
14. [External Libraries and DLL Calls](#external-libraries-and-dll-calls)
15. [Sound Operations](#sound-operations)
16. [Screen Operations](#screen-operations)
17. [Mathematical Operations](#mathematical-operations)
18. [Code Integrity and Testing](#code-integrity-and-testing)
19. [Migration from v1 to v2](#migration-from-v1-to-v2)

---

## Introduction

This guide documents all AutoHotkey v2 features covered by the 1,719 example files in this repository. Each example has been converted from AHK v1 and validated for correctness. All examples begin with:

```ahk
#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
```

### Key Changes in AHK v2

- **Mandatory parentheses** for all function calls: `MsgBox("text")` instead of `MsgBox, text`
- **Expression-based syntax** throughout
- **Object-oriented GUI creation** with the `Gui()` constructor
- **Reference operator** `&` for passing by reference
- **Proper function/method syntax** with dot notation

---

## Core Language Features

### 1. Variable Assignment and Declaration

**Examples:** `String_Assignment_ex1.ahk` through `String_Assignment_ex13.ahk`

```ahk
; Basic assignment
var := "value"
number := 42

; Multiple assignments
a := 1
b := 2
c := a + b

; Empty string assignment
emptyVar := ""
```

**Key Points:**
- Use `:=` for assignment (always expression mode)
- Variables are dynamically typed
- No need for variable declaration keywords in most cases

### 2. Functions and Parameters

**Examples:** `Misc_MyFunc_ex01.ahk`, `Misc_MyFunc_ex02.ahk`

```ahk
; Basic function
MyFunction(param1, param2) {
    return param1 + param2
}

result := MyFunction(5, 10)
```

### 3. ByRef Parameters (Pass by Reference)

**Examples:** `Control_ByRef_ex1.ahk` through `Control_ByRef_ex5.ahk`

```ahk
; Using the & operator for references in v2
a := 1
b := 2
Swap(&a, &b)  ; Pass by reference

Swap(&Left, &Right) {
    temp := Left
    Left := Right
    Right := temp
}
```

**Key Points:**
- v2 uses `&` before variable names to pass by reference
- Use `&` in both function definition AND function call
- Essential for functions that need to modify multiple variables

### 4. Classes and Properties

**Examples:** `Misc_Class-Property.ahk`

```ahk
class MyClass {
    MyMethod1 {
        Get {
            return "Method 1"
        }
    }
}

MsgBox(MyClass.MyMethod1)
```

**Key Points:**
- Object-oriented programming support
- Property getters and setters
- Class methods and static methods

### 5. Arrays and Collections

**Examples:** `String_Array_ex1.ahk` through `String_Array_ex5.ahk`

```ahk
; Creating arrays
arr := ["1", "2", "3"]

; Array methods
arr.Push("My Value")                    ; Add to end
arr.InsertAt(2, "Val 1", "Val 2")      ; Insert at position
arr.Pop()                               ; Remove from end
arr.RemoveAt(5)                         ; Remove at position
arr.RemoveAt(4, 3)                      ; Remove 3 items starting at position 4

; Accessing array properties
length := arr.Length
item := arr[1]  ; Arrays are 1-indexed in v2
```

**Key Points:**
- Arrays are 1-indexed (first element is `arr[1]`)
- Use `.Length` property instead of `.MaxIndex()`
- Rich set of array methods: Push, Pop, InsertAt, RemoveAt

### 6. Associative Arrays (Objects/Maps)

**Examples:** `Syntax_Associative_Arrays_ex1.ahk`, `Syntax_Associative_Arrays_key-types.ahk`

```ahk
; Creating associative arrays
myMap := Map()
myMap["key1"] := "value1"
myMap["key2"] := "value2"

; Object literal syntax
obj := {name: "John", age: 30}
```

---

## Flow Control

### 1. If Statements

**Examples:** `Control_IfEqual_ex1.ahk`, `Control_IfEqual_ex2.ahk`, `Control_if_traditional_ex1.ahk`

```ahk
; Expression-based if
var := "value"
if (var = "value") {
    MsgBox("Match found")
}

; Single-line if
if (var = 2)
    FileAppend(var, "*")

; If-else
if WinExist("Untitled - Notepad")
    WinActivate()
else
    WinActivate("Calculator")
```

**Key Points:**
- Always use expression syntax: `if (condition)`
- Use `=` for comparison (not `==`)
- Traditional commands are replaced with functions

### 2. If with Operators

**Examples:** `Control_if_between_ex1.ahk`, `Control_ifVarContains_ex1.ahk`

```ahk
; Between check
if (var >= min && var <= max)
    MsgBox("In range")

; String contains (use InStr)
if InStr(haystack, needle)
    MsgBox("Found")

; Blank check
if (var = "")
    MsgBox("Variable is blank")
```

### 3. Switch Statements

**Examples:** `Control_Switch_ex1.ahk`, `Control_Switch_ex2.ahk`

```ahk
num := Random(0, 5)
Switch num {
    Case 0:
        MsgBox("Chose letter A")
    Case 1:
        MsgBox("Chose letter B")
    Case 2:
        MsgBox("Chose letter C")
    Default:
        MsgBox("Chose letter F")
}
```

**Key Points:**
- Clean multi-way branching
- No need for `break` statements (no fall-through by default)
- `Default` case for unmatched values

### 4. Ternary Operator

**Examples:** `Control_Ternary_ex1.ahk`, `String_Ternary_ex2.ahk` through `String_Ternary_ex4.ahk`

```ahk
; Ternary: condition ? valueIfTrue : valueIfFalse
result := (x > 0) ? "positive" : "non-positive"
a := "" , b ? c : ""
```

### 5. Loops

#### Loop Files

**Examples:** `Control_LoopFiles_ex1.ahk` through `Control_LoopFiles_ex3.ahk`

```ahk
; Loop through files
Loop Files, A_ProgramFiles "\*.txt", "R"  ; R = Recurse
{
    msgResult := MsgBox("Filename = " A_LoopFilePath "`n`nContinue?", , 4)
    if (msgResult = "No")
        break
}
```

**Loop Variables:**
- `A_LoopFilePath` - Full path of current file
- `A_LoopFileName` - Name only
- `A_LoopFileExt` - Extension
- `A_LoopFileSize` - Size in bytes
- `A_LoopFileDir` - Directory path

#### Loop Parse

**Examples:** `Control_LoopParse_ex1.ahk` through `Control_LoopParse_ex4.ahk`

```ahk
; Parse a string
Loop Parse, "Item1,Item2,Item3", ","
{
    MsgBox(A_LoopField)
}
```

#### Loop Read (File Lines)

**Examples:** `Control_LoopReadFile_ex1.ahk`, `Control_LoopReadFile_ex2.ahk`

```ahk
; Read file line by line
Loop Read, "C:\My File.txt"
{
    MsgBox("Line " A_Index " is " A_LoopReadLine)
}
```

### 6. Try-Catch-Finally

**Examples:** `Control_Catch_ex1.ahk`, `Control_Exception_ex1.ahk`

```ahk
try {
    ; Code that might throw an error
    aefiojpiojeefaaf  ; This will error
}
Catch Error as err {
    MsgBox(err.Message)
}
```

**Key Points:**
- Modern exception handling
- `Catch Error as err` captures error object
- Error object has properties: `.Message`, `.What`, `.Extra`, `.File`, `.Line`

### 7. Return Statements

**Examples:** `Control_Return_ex1-2.ahk` through `Control_Return_ex4.ahk`

```ahk
; Return value from function
GetValue() {
    return 42
}

; Return from hotkey
F1::
{
    MsgBox("F1 pressed")
    return
}
```

### 8. Timers

**Examples:** `Control_SetTimer_ex1.ahk`, `Control_SetTimer_ex2.ahk`

```ahk
; Set up a timer
Persistent  ; Keep script running
SetTimer(CloseMailWarnings, 250)  ; Run every 250ms

CloseMailWarnings() {
    WinClose("Microsoft Outlook", "A timeout occured")
    WinClose("Microsoft Outlook", "A connection to the server")
}
```

**Key Points:**
- Pass function reference (not string) to SetTimer
- Interval in milliseconds
- Use `Persistent` to keep script running with only timers

### 9. Goto and Labels

**Examples:** `Env_Goto_ex1.ahk` through `Env_Goto_ex4.ahk`

```ahk
Goto, MyLabel

MyLabel:
MsgBox("Reached label")
```

**Note:** Goto is generally discouraged in v2; use functions and structured flow control instead.

---

## String Operations

### 1. SubStr (Substring Extraction)

**Examples:** `String_SubStr_ex01.ahk` through `String_SubStr_ex40.ahk`

```ahk
Str := "This is a test."
OutputVar := SubStr(Str, 1, 4)  ; "This"
OutputVar := SubStr(Str, 6)      ; "is a test."
OutputVar := SubStr(Str, -4)     ; "test."
```

**Parameters:**
- `SubStr(String, StartPos, Length := "")`
- Negative StartPos counts from end
- Omit Length to get rest of string

### 2. InStr (Find Substring)

**Examples:** `String_InStr_ex01.ahk` through `String_InStr_ex38.ahk`

```ahk
; Basic search
Haystack := "The Quick Brown Fox"
Pos := InStr(Haystack, "Fox")  ; Returns 17

; Case-sensitive search
Pos := InStr(Haystack, "fox", true)  ; Returns 0 (not found)

; Starting position
Pos := InStr(Haystack, "o", , 10)  ; Start searching at position 10
```

**Parameters:**
- `InStr(Haystack, Needle, CaseSensitive := false, StartingPos := 1)`
- Returns position (1-indexed) or 0 if not found

### 3. StrReplace (String Replacement)

**Examples:** `String_StrReplace_ex01.ahk` through `String_StrReplace_ex13.ahk`

```ahk
NewStr := StrReplace("Hello World", "World", "Universe")
; Result: "Hello Universe"

; Get replacement count
NewStr := StrReplace(Str, "old", "new", , &Count)
MsgBox("Made " Count " replacements")
```

### 4. String Comparison

**Examples:** `String_StrCompare_ex01.ahk` through `String_StrCompare_ex10.ahk`

```ahk
; Basic comparison
if (str1 = str2)
    MsgBox("Equal")

; Case-sensitive comparison
if (StrCompare(str1, str2, true) = 0)
    MsgBox("Equal (case-sensitive)")
```

### 5. String Case Conversion

**Examples:** `String_StrUpper_ex01.ahk`, `String_StrTitle_ex01.ahk`

```ahk
Upper := StrUpper("hello")      ; "HELLO"
Lower := StrLower("HELLO")      ; "hello"
Title := StrTitle("hello world") ; "Hello World"
```

### 6. String Length

**Examples:** `String_StrLen_ex01.ahk`, `String_StrLen_ex02.ahk`

```ahk
Length := StrLen("Hello")  ; 5
```

### 7. String Splitting

**Examples:** `String_StringSplit_ex1.ahk`, `String_StringSplit_ex2.ahk`

```ahk
; Split string into array
arr := StrSplit("Red,Green,Blue", ",")
; arr[1] = "Red", arr[2] = "Green", arr[3] = "Blue"
```

### 8. Continuation Sections (Multi-line Strings)

**Examples:** `String_ContinuationWithVar.ahk` through `String_ContinuationWithVar5.ahk`

```ahk
; Multi-line string with variable interpolation
user := "defaultuser0"
script := (
    "document.querySelector('#userId').value = '" user "'"
)
MsgBox(script)

; Long text continuation
longText := (
    "This is a very long string that spans"
    " multiple lines for better readability."
)
```

**Key Points:**
- Use `(` and `)` for continuation sections
- Variables are automatically interpolated
- Leading/trailing whitespace is trimmed by default

### 9. Escaped Characters

**Examples:** `String_EscapedLiteralChars_01.ahk`

```ahk
; Escape sequences
text := "Line 1`nLine 2"     ; Newline
text := "Column 1`tColumn 2" ; Tab
text := "Quote: `"text`""    ; Embedded quote
text := "Backtick: ``"       ; Literal backtick
```

**Common Escapes:**
- `` `n`` - Newline
- `` `r`` - Carriage return
- `` `t`` - Tab
- `` `"`` - Literal quote
- `` ```` - Literal backtick

### 10. String Concatenation

**Examples:** `Misc_Concat_ex01.ahk` through `Misc_Concat_ex11.ahk`

```ahk
; Space concatenation (automatic)
result := "Hello" " " "World"  ; "Hello World"

; Variable concatenation
name := "John"
greeting := "Hello, " name "!"

; No comma in concatenation
text := var1 var2 var3
```

---

## File and Directory Operations

### 1. FileAppend (Write to File)

**Examples:** `File_FileAppend_ex01.ahk` through `File_FileAppend_ex66.ahk`, `File_Append_ex1.ahk`

```ahk
; Append to file
FileAppend("Text to append`n", "C:\MyFile.txt")

; Append to stdout (console)
FileAppend("Output to console", "*")

; Create/overwrite file by deleting first
FileDelete("C:\MyFile.txt")
FileAppend("New content", "C:\MyFile.txt")
```

**Parameters:**
- `FileAppend(Text, Filename, Encoding := "")`
- Special filename `"*"` sends to stdout
- Encoding: "UTF-8", "UTF-16", etc.

### 2. FileRead (Read File Contents)

**Examples:** `File_Read_ex1.ahk`

```ahk
Contents := FileRead("C:\MyFile.txt")
MsgBox(Contents)

; Read with specific encoding
Contents := FileRead("C:\MyFile.txt", "UTF-8")
```

### 3. File Operations (Copy, Move, Delete)

**Examples:** `File_Copy_ex1.ahk`, `File_Move_ex1.ahk`, `File_Delete_ex1.ahk`

```ahk
; Copy file
FileCopy("Source.txt", "Dest.txt", true)  ; true = overwrite

; Move file
FileMove("OldName.txt", "NewName.txt", true)

; Delete file
FileDelete("FileToDelete.txt")
```

### 4. Directory Operations

**Examples:** `File_DirCreate_ex01.ahk`, `File_DirDelete_ex01.ahk`, `File_DirCopy_ex01.ahk`

```ahk
; Create directory
DirCreate("C:\MyFolder")

; Delete directory
DirDelete("C:\MyFolder", true)  ; true = recursive

; Copy directory
DirCopy("C:\Source", "C:\Dest", true)  ; true = overwrite

; Move directory
DirMove("C:\OldPath", "C:\NewPath", "R")  ; R = rename existing
```

### 5. File Existence Check

**Examples:** `File_FileExist_ex01.ahk` through `File_FileExist_ex04.ahk`

```ahk
; Check if file exists
if FileExist("C:\MyFile.txt")
    MsgBox("File exists")

; Get file attributes
attrs := FileExist("C:\MyFile.txt")
; D = Directory, A = Archive, R = ReadOnly, H = Hidden, S = System
```

### 6. File Attributes

**Examples:** `File_GetAttrib_ex1.ahk`, `File_SetAttrib_ex1.ahk`

```ahk
; Get attributes
attrs := FileGetAttrib("C:\MyFile.txt")

; Set attributes
FileSetAttrib("+R", "C:\MyFile.txt")  ; Add readonly
FileSetAttrib("-R", "C:\MyFile.txt")  ; Remove readonly
FileSetAttrib("+H", "C:\MyFile.txt")  ; Hide file
```

### 7. File Size

**Examples:** `File_FileGetSize_ex01.ahk`, `File_GetSize_ex1.ahk`

```ahk
Size := FileGetSize("C:\MyFile.txt")  ; Bytes
SizeKB := FileGetSize("C:\MyFile.txt", "K")  ; Kilobytes
SizeMB := FileGetSize("C:\MyFile.txt", "M")  ; Megabytes
```

### 8. File Time

**Examples:** `File_GetTime_ex1.ahk`, `File_SetTime_ex1.ahk`

```ahk
; Get file modification time
ModTime := FileGetTime("C:\MyFile.txt")

; Get creation time
CreateTime := FileGetTime("C:\MyFile.txt", "C")

; Set modification time
FileSetTime("20240315120000", "C:\MyFile.txt")  ; YYYYMMDDHH24MISS
```

### 9. File Version Info

**Examples:** `File_GetVersion_ex1.ahk`

```ahk
Version := FileGetVersion("C:\Windows\notepad.exe")
MsgBox("Version: " Version)
```

### 10. SplitPath (Parse File Path)

**Examples:** `File_SplitPath_ex1.ahk`, `Misc_SplitPath_ex01.ahk`

```ahk
FullPath := "C:\Folder\Subfolder\MyFile.txt"
SplitPath(FullPath, &Name, &Dir, &Ext, &NameNoExt, &Drive)
; Name = "MyFile.txt"
; Dir = "C:\Folder\Subfolder"
; Ext = "txt"
; NameNoExt = "MyFile"
; Drive = "C:"
```

### 11. Working Directory

**Examples:** `File_SetWorkingDir_ex1.ahk`

```ahk
; Change working directory
SetWorkingDir("C:\MyFolder")

; Get current directory
CurrentDir := A_WorkingDir
```

### 12. File Dialogs

**Examples:** `File_SelectFile_ex1.ahk`, `File_DirSelect_ex01.ahk`

```ahk
; Select file
SelectedFile := FileSelect(3, , "Open a file", "Text Files (*.txt)")
; 3 = Allow multiselect

; Select directory
SelectedDir := DirSelect(, 3, "Select a folder")
```

### 13. Shortcuts

**Examples:** `File_CreateShortcut_ex1.ahk`, `File_GetShortcut.ahk`

```ahk
; Create shortcut
FileCreateShortcut("C:\Target.exe", "C:\MyShortcut.lnk", "C:\WorkDir", "args", "Description")

; Read shortcut
FileGetShortcut("C:\MyShortcut.lnk", &Target, &Dir, &Args)
```

### 14. Drive Operations

**Examples:** `File_Drive_ex1.ahk`, `File_DriveGet_ex1.ahk`, `File_DriveSpaceFree_ex1.ahk`

```ahk
; Get free space
FreeSpace := DriveGetSpaceFree("C:")  ; MB

; Get drive status
DriveStatus := DriveGetStatus("D:")  ; Ready, NotReady, etc.

; Eject CD/DVD
DriveEject("D:")
```

### 15. Recycle Bin

**Examples:** `File_Recycle_ex1.ahk`, `File_RecycleEmpty_ex1.ahk`

```ahk
; Send to recycle bin
FileRecycle("C:\FileToRecycle.txt")

; Empty recycle bin
FileRecycleEmpty("C:\")
```

### 16. INI Files

**Examples:** `File_IniDelete_ex1.ahk`

```ahk
; Read INI value
Value := IniRead("C:\Config.ini", "Section", "Key", "Default")

; Write INI value
IniWrite("NewValue", "C:\Config.ini", "Section", "Key")

; Delete INI key
IniDelete("C:\Config.ini", "Section", "Key")
```

### 17. File Installation

**Examples:** `File_Install_ex1.ahk`

```ahk
; Include file in compiled script
FileInstall("SourceFile.txt", "C:\DestFile.txt", 1)
```

---

## GUI (Graphical User Interface)

### 1. Basic GUI Creation

**Examples:** `GUI_Gui_ex01.ahk`, `GUI_Gui_ex02.ahk`

```ahk
; Create GUI object
myGui := Gui()

; Set options
myGui.Opt("+AlwaysOnTop +Disabled -SysMenu +Owner")

; Add controls
myGui.Add("Text", , "Some text to display.")
myGui.Add("Button", , "Click Me")

; Set title
myGui.Title := "Title of Window"

; Show GUI
myGui.Show("NoActivate")
```

**Key Points:**
- GUI is now an object created with `Gui()` constructor
- Use dot notation for methods: `.Add()`, `.Show()`, `.Opt()`
- Set properties: `.Title`, `.BackColor`, etc.

### 2. GUI Controls

**Examples:** Various `GUI_GuiControl_*.ahk` files

```ahk
; Add various controls
myGui.Add("Text", "x10 y10", "Label:")
myGui.Add("Edit", "x100 y10 w200 vUserInput", "Default text")
myGui.Add("Button", "x100 y40", "Submit").OnEvent("Click", ButtonClick)
myGui.Add("Checkbox", , "Enable feature")
myGui.Add("Radio", , "Option 1")
myGui.Add("DropDownList", , ["Option 1", "Option 2", "Option 3"])
myGui.Add("ListBox", , ["Item 1", "Item 2", "Item 3"])
myGui.Add("ListView", "r10 w300", ["Column1", "Column2"])
myGui.Add("TreeView", "r10 w300")

; Add items to ListView
LV := myGui.Add("ListView", "r10", ["Name", "Size", "Modified"])
LV.Add(, "File1.txt", "1024", "2025-01-15")
```

### 3. GUI Events

**Examples:** `GUI_gLabel_ex1.ahk`, `GUI_Anti-gLabel_ex1.ahk`

```ahk
; Modern event handling (v2)
myGui := Gui()
btn := myGui.Add("Button", , "Click Me")
btn.OnEvent("Click", ButtonClick)

ButtonClick(GuiCtrl, Info) {
    MsgBox("Button clicked!")
}

; GUI close event
myGui.OnEvent("Close", GuiClose)
GuiClose(*) {
    ExitApp
}
```

**Key Points:**
- Use `.OnEvent()` instead of g-labels
- Event handlers receive GuiCtrl and Info parameters
- Common events: Click, Change, Focus, Escape, Close

### 4. MsgBox (Message Boxes)

**Examples:** `GUI_MsgBox_ex01.ahk` through `GUI_MsgBox_ex69.ahk`

```ahk
; Simple message
MsgBox("Hello, World!")

; With title and options
result := MsgBox("Continue?", "Confirmation", "YesNo")
if (result = "Yes")
    MsgBox("You clicked Yes")

; With icon and buttons
MsgBox("Error occurred!", "Error", "IconX")  ; X icon
MsgBox("Warning!", "Warning", "IconExclaim")  ; ! icon
MsgBox("Info", "Information", "Icon64")       ; i icon

; With timeout
MsgBox("Auto-close in 3 seconds", , "T3")
```

**Button Options:**
- `OK` (default), `OKCancel`, `YesNo`, `YesNoCancel`, `RetryCancel`, `AbortRetryIgnore`

**Icon Options:**
- `Icon16` or `IconX` - Stop/Error
- `Icon32` or `Icon?` - Question
- `Icon48` or `Icon!` - Exclamation/Warning
- `Icon64` or `IconI` - Information

### 5. InputBox

**Examples:** `GUI_InputBox_ex01.ahk`, `GUI_Inputbox_ex1.ahk`

```ahk
; Get user input
result := InputBox("Please enter your name:", "Name Input")
if (result.Result = "OK")
    MsgBox("Hello, " result.Value)

; With default value
result := InputBox("Enter value:", "Input", , "DefaultValue")

; With password masking
result := InputBox("Enter password:", "Password", "Password")
```

### 6. ListView Control

**Examples:** `GUI_Listview_1.ahk`, `GUI_Listview_2.ahk`

```ahk
myGui := Gui()
LV := myGui.Add("ListView", "r10 w500", ["Name", "Size", "Type"])

; Add rows
LV.Add(, "File1.txt", "1024 bytes", "Text")
LV.Add(, "File2.doc", "2048 bytes", "Document")

; Modify rows
LV.Modify(1, , "Modified.txt", "2048 bytes", "Text")

; Get selected row
RowNum := LV.GetNext()

myGui.Show()
```

### 7. TreeView Control

**Examples:** `GUI_Treeview_1.ahk`

```ahk
myGui := Gui()
TV := myGui.Add("TreeView")

; Add items
ParentID := TV.Add("Parent Item")
ChildID := TV.Add("Child Item", ParentID)

myGui.Show()
```

### 8. Menu Bars and Context Menus

**Examples:** `GUI_GuiMenu_ex1.ahk`, `GUI_MenuGetHandle_ex1.ahk`

```ahk
; Create menu
MyMenu := Menu()
MyMenu.Add("Item 1", MenuHandler)
MyMenu.Add("Item 2", MenuHandler)
MyMenu.Add()  ; Separator

; Add to GUI
myGui := Gui()
myGui.MenuBar := MyMenu

MenuHandler(ItemName, ItemPos, MyMenu) {
    MsgBox("You selected " ItemName)
}
```

### 9. Tray Icon Menu

**Examples:** `GUI_Tray_Add_ex01.ahk`, `GUI_Tray_Add_ex02.ahk`

```ahk
; Add tray menu items
A_TrayMenu.Add("My Custom Item", TrayClick)

TrayClick(*) {
    MsgBox("Tray item clicked")
}
```

### 10. Status Bar

**Examples:** `GUI_SB_SetParts_ex1.ahk`

```ahk
myGui := Gui()
SB := myGui.Add("StatusBar")
SB.SetParts(100, 200)  ; Create sections
SB.SetText("Ready", 1)
SB.SetText("Status: OK", 2)
myGui.Show()
```

---

## Window Management

### 1. Window Detection and Activation

**Examples:** `Window_WinExist_ex01.ahk`, `Window_WinActivate_1.ahk`

```ahk
; Check if window exists
if WinExist("Untitled - Notepad")
    WinActivate()  ; Activate the found window
else
    MsgBox("Window not found")

; Direct activation
WinActivate("Calculator")

; Activate by ID
WinActivate("ahk_id " . WinID)
```

**Window Title Matching:**
- Partial match by default
- `"ahk_class ClassName"` - Match by class
- `"ahk_id " . ID` - Match by window ID
- `"ahk_pid " . PID` - Match by process ID
- `"ahk_exe ProcessName.exe"` - Match by executable

### 2. Getting Window Information

**Examples:** `Window_WinGetTitle_ex1.ahk`, `Window_WinGetPos_ex1.ahk`, `Window_WinGetClass_ex1.ahk`

```ahk
; Get window title
Title := WinGetTitle("A")  ; "A" = active window

; Get window position and size
WinGetPos(&X, &Y, &Width, &Height, "A")
MsgBox("X:" X " Y:" Y " W:" Width " H:" Height)

; Get window class
Class := WinGetClass("A")

; Get window text (all visible text)
Text := WinGetText("A")

; Get window ID
ID := WinGetID("Notepad")
```

### 3. Window Manipulation

**Examples:** `Window_WinMove_ex1.ahk`, `Window_WinMaximize_test1.ahk`, `Window_WinMinimize_ex1.ahk`

```ahk
; Move window
WinMove(100, 100, 800, 600, "Notepad")  ; X, Y, Width, Height

; Maximize window
WinMaximize("A")

; Minimize window
WinMinimize("A")

; Restore window
WinRestore("A")

; Hide window
WinHide("Notepad")

; Show window
WinShow("Notepad")
```

### 4. Window Closing and Killing

**Examples:** `Window_WinClose_ex1.ahk`, `Window_WinKill_ex1.ahk`

```ahk
; Close window gracefully
WinClose("Notepad")

; Force close window
WinKill("Notepad")

; Close all instances
WinClose("ahk_exe chrome.exe")
```

### 5. Window Settings

**Examples:** `Window_WinSet_ex1.ahk` through `Window_WinSet_ex10.ahk`

```ahk
; Set always on top
WinSetAlwaysOnTop(1, "A")  ; 1 = on, 0 = off, -1 = toggle

; Set transparency
WinSetTransparent(150, "A")  ; 0-255

; Set window title
WinSetTitle("New Title", "Old Title")

; Enable/disable window
WinSetEnabled(0, "A")  ; Disable
```

### 6. Waiting for Windows

**Examples:** `Window_WinWait_ex1.ahk`, `Window_WinWaitActive_ex1.ahk`, `Window_WinWaitClose_ex1.ahk`

```ahk
; Wait for window to exist
WinWait("Notepad", , 5)  ; 5 second timeout

; Wait for window to become active
WinWaitActive("Notepad")

; Wait for window to close
WinWaitClose("Notepad")
```

### 7. Window State Detection

**Examples:** `Window_WinActive_ex1.ahk` through `Window_WinActive_ex07.ahk`

```ahk
; Check if window is active
if WinActive("Notepad")
    MsgBox("Notepad is active")

; Get active window's stats
WinGetActiveStats(&Title, &Width, &Height, &X, &Y)
```

### 8. Title Match Mode

**Examples:** `Window_SetTitleMatchMode_ex1.ahk`, `Window_SetTitleMatchMode_ex2.ahk`

```ahk
; Set matching mode
SetTitleMatchMode(1)  ; 1 = start, 2 = contains, 3 = exact, "RegEx" = regex

; Set matching speed
SetTitleMatchMode("Fast")  ; or "Slow"
```

### 9. Window Delay

**Examples:** `Window_SetWinDelay_ex1.ahk`

```ahk
; Set delay after window commands
SetWinDelay(100)  ; milliseconds
```

### 10. Status Bar Reading

**Examples:** `Window_StatusbargetText_ex1.ahk`, `Window_StatusbarWait_ex1.ahk`

```ahk
; Read status bar text
StatusText := StatusBarGetText(1, "A")  ; Part 1 of active window

; Wait for status bar text
StatusBarWait("Ready", 5, 1, "A")  ; Wait up to 5 seconds
```

### 11. Hidden Window Detection

**Examples:** `Window_DetectHiddenWindows_ex1.ahk`, `Window_DetectHiddenText_ex1.ahk`

```ahk
; Detect hidden windows
DetectHiddenWindows(true)

; Detect hidden text in windows
DetectHiddenText(true)
```

---

## Mouse and Keyboard Input

### 1. Mouse Clicks

**Examples:** `Hotkey_Click_ex1.ahk`, `Hotkey_Click_ex2.ahk`, `Hotkey_MouseClick_examples.ahk`

```ahk
; Simple click
Click()

; Click at coordinates
Click(100, 200)

; Right click
Click("Right")

; Double click
Click(2)

; Click and drag
Click(100, 200, "Left", , "Down")
MouseMove(300, 400)
Click(300, 400, "Left", , "Up")
```

### 2. Mouse Click Drag

**Examples:** `Hotkey_MouseClickDrag_ex1.ahk`, `Hotkey_MouseClickDrag_ex2.ahk`

```ahk
; Drag from point to point
MouseClickDrag("Left", 100, 100, 200, 200)
```

### 3. Mouse Position

**Examples:** `Hotkey_MouseGetPos_ex1.ahk`, `Hotkey_MouseGetPos_ex2.ahk`

```ahk
; Get mouse coordinates
MouseGetPos(&X, &Y)
MsgBox("Mouse at " X ", " Y)

; Get window and control under mouse
MouseGetPos(&X, &Y, &WinID, &CtrlHwnd)
```

### 4. Mouse Settings

**Examples:** `Hotkey_SetDefaultMouseSpeed_ex1.ahk`

```ahk
; Set mouse movement speed
SetDefaultMouseSpeed(50)  ; 0 (fastest) to 100 (slowest)
```

### 5. Coordinate Modes

**Examples:** `Hotkey_CoordMode_ex1.ahk`, `Hotkey_CoordMode_ex2.ahk`

```ahk
; Set coordinate mode for mouse
CoordMode("Mouse", "Screen")   ; Relative to entire screen
CoordMode("Mouse", "Window")   ; Relative to active window
CoordMode("Mouse", "Client")   ; Relative to active window's client area

; Set coordinate mode for pixel commands
CoordMode("Pixel", "Screen")
```

### 6. Send (Keyboard Input)

**Examples:** `Hotkey_Send_ex1.ahk`

```ahk
; Send keystrokes
Send("Hello World")

; Send special keys
Send("{Enter}")
Send("{Tab}")
Send("{Escape}")
Send("{F1}")

; Send key combinations
Send("^c")   ; Ctrl+C
Send("^v")   ; Ctrl+V
Send("+a")   ; Shift+A
Send("!f")   ; Alt+F

; Send raw text (no special interpretation)
SendText("This is {literal} text")
```

**Modifier Keys:**
- `^` - Ctrl
- `!` - Alt
- `+` - Shift
- `#` - Win

### 7. Send Mode

**Examples:** `Hotkey_SendMode_ex1.ahk`

```ahk
; Set send mode
SendMode("Input")   ; Recommended for reliability
SendMode("Event")   ; Default
SendMode("Play")    ; For games
```

### 8. Send Level

**Examples:** `Hotkey_SendLevel_ex1.ahk`

```ahk
; Set send level (for hotkey layering)
SendLevel(1)  ; 0-100
```

### 9. Control Send (Send to Specific Window)

**Examples:** `Hotkey_controlSend_ex1.ahk`, `Hotkey_controlSend_ex2.ahk`

```ahk
; Send to specific control
ControlSend("Hello", "Edit1", "Notepad")

; Send to window
ControlSend("Hello", , "Notepad")
```

### 10. Control Click

**Examples:** `Hotkey_controlclick_ex1.ahk` through `Hotkey_controlclick_ex3.ahk`

```ahk
; Click a control
ControlClick("Button1", "Some Window")

; Click at specific position within control
ControlClick("Edit1", "Window", , "Left", 1, "X50 Y10")
```

### 11. Key State

**Examples:** `Hotkey_GetKeyState_ex1.ahk`

```ahk
; Check if key is pressed
if GetKeyState("Shift")
    MsgBox("Shift is pressed")

; Get toggle state
CapsState := GetKeyState("CapsLock", "T")  ; True/False

; Get physical state
PhysState := GetKeyState("LButton", "P")  ; Left mouse button
```

### 12. Key Name

**Examples:** `Hotkey_GetKeyName_ex1.ahk`

```ahk
; Get key name from VK code
Name := GetKeyName("vk41")  ; "A"

; Get key VK code
VK := GetKeyVK("A")  ; 65
```

### 13. Key Wait

**Examples:** `Hotkey_KeyWait_ex5.ahk` through `Hotkey_KeyWait_ex7.ahk`

```ahk
; Wait for key to be released
KeyWait("Ctrl")

; Wait for key to be pressed
KeyWait("Ctrl", "D")  ; D = Down

; Wait with timeout
if !KeyWait("Ctrl", "D T3")  ; 3 second timeout
    MsgBox("Timeout")
```

### 14. Lock Keys

**Examples:** `Hotkey_SetCapsLockState_ex1.ahk`, `Hotkey_SetNumLockState_ex1.ahk`

```ahk
; Set CapsLock state
SetCapsLockState("On")
SetCapsLockState("Off")
SetCapsLockState("AlwaysOff")  ; Prevent toggling

; Set NumLock state
SetNumLockState("On")

; Set ScrollLock state
SetScrollLockState("On")
```

### 15. Input

**Examples:** `Hotkey_Input_ex1.ahk` through `Hotkey_Input_ex3.ahk`

```ahk
; Capture user input
ih := InputHook("L4")  ; Limit to 4 characters
ih.Start()
ih.Wait()
MsgBox("You entered: " ih.Input)

; Input with end keys
ih := InputHook()
ih.KeyOpt("{Enter}", "E")  ; End key
ih.Start()
ih.Wait()
```

### 16. Block Input

**Examples:** `Hotkey_BlockInput_ex1.ahk`

```ahk
; Block user input
BlockInput(true)
; ... do something ...
BlockInput(false)
```

### 17. Key Delay

**Examples:** `Hotkey_SetKeyDelay_ex_1.ahk`

```ahk
; Set delay between keystrokes
SetKeyDelay(10, 10)  ; delay, press duration (ms)
```

### 18. Store CapsLock Mode

**Examples:** `Hotkey_SetStoreCapsLockMode_ex1.ahk`

```ahk
; Preserve CapsLock state during Send
SetStoreCapsLockMode(true)
```

---

## Directives

### 1. #Requires

**Examples:** `Directive_Requires_ex1.ahk`

```ahk
; Require specific AHK version
#Requires AutoHotkey v2.1-alpha.16

; Require specific minimum version
#Requires AutoHotkey >=2.0
```

### 2. #SingleInstance

All examples include:
```ahk
#SingleInstance Force  ; Replace old instance automatically
```

Options:
- `Force` - Replace automatically
- `Ignore` - Keep old instance
- `Prompt` - Ask user

### 3. #HotIf (Context-Sensitive Hotkeys)

**Examples:** `Directive_#If_ex1.ahk`, `Directive_#If_ex3.ahk`

```ahk
; Hotkeys active only when condition is true
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp:: Send("{Volume_Up}")
WheelDown:: Send("{Volume_Down}")
#HotIf  ; End context

MouseIsOver(WinTitle) {
    MouseGetPos(, , &Win)
    return WinExist(WinTitle . " ahk_id " . Win)
}

; Window-specific hotkeys
#HotIf WinActive("ahk_exe notepad.exe")
^s:: MsgBox("Saving in Notepad")
#HotIf
```

### 4. #Hotstring

**Examples:** `Directive_#Hotstring_ex1.ahk`

```ahk
; Set hotstring options
#Hotstring NoMouse  ; Don't reset on mouse clicks
#Hotstring C        ; Case-sensitive
#Hotstring *        ; No ending character needed

; Define hotstrings
::btw::by the way
::omw::on my way
```

### 5. #Include

**Examples:** `Control_#Include_ex1.ahk` through `Control_#Include_ex3.ahk`

```ahk
; Include another script
#Include "LibraryFunctions.ahk"

; Include from lib folder
#Include <MyLib>
```

### 6. #Warn

**Examples:** `Directive_#Warn_ex1.ahk`

```ahk
; Enable warnings
#Warn All         ; All warnings
#Warn VarUnset    ; Unset variables
#Warn UseUnsetLocal  ; Unset local variables
```

### 7. #NoEnv (Deprecated in v2)

**Examples:** `Directive_#NoEnv_ex1.ahk`

```ahk
; No longer needed in v2 (environment variables don't interfere)
```

### 8. #WinActivateForce

**Examples:** `Directive_#WinActivateForce_ex1.ahk`

```ahk
; Force windows to activate
#WinActivateForce
```

### 9. #HotkeyInterval and #MaxHotkeysPerInterval

**Examples:** `Directive_#HotkeyInterval_ex1.ahk`

```ahk
; Adjust hotkey rate limits
#HotkeyInterval 2000  ; Check interval in ms
#MaxHotkeysPerInterval 200  ; Max hotkeys allowed in interval
```

### 10. #HotkeyModifierTimeout

**Examples:** `Directive_#HotkeyModifierTimeout_ex1.ahk`

```ahk
; Time to wait for next key when modifier is pressed
#HotkeyModifierTimeout 50  ; milliseconds
```

### 11. #InputLevel

**Examples:** `Directive_#InputLevel.ahk`

```ahk
; Set input level for generated events
#InputLevel 1  ; 0-100
```

### 12. Legacy Directives (Removed in v2)

**Examples:** `Directive_#Delimiter_ex1.ahk`, `Directive_#EscapeChar_ex1.ahk`

These directives existed in v1 but are removed or changed in v2:
- `#Delimiter` - No longer needed (use commas)
- `#EscapeChar` - Backtick (`) is always the escape character
- `#AllowSameLineComments` - Always allowed in v2
- `#CommentFlag` - Semicolon (;) is always the comment character

---

## Date and Time Operations

### 1. FormatTime

**Examples:** `DateTime_FormatTime_ex01.ahk`, `DateTime_FormatTime_ex02.ahk`

```ahk
; Format current time
TimeString := FormatTime(, "yyyy-MM-dd HH:mm:ss")

; Format specific timestamp
TimeString := FormatTime("20250315120000", "MMMM dd, yyyy")

; Get A_Now
TimeString := A_Now  ; Current time as YYYYMMDDHH24MISS
```

**Format Codes:**
- `yyyy` - 4-digit year
- `yy` - 2-digit year
- `MM` - Month (01-12)
- `MMM` - Abbreviated month name
- `MMMM` - Full month name
- `dd` - Day (01-31)
- `HH` - Hour 24-hour format
- `hh` - Hour 12-hour format
- `mm` - Minutes
- `ss` - Seconds
- `tt` - AM/PM

### 2. DateAdd

**Examples:** `DateTime_DateAdd_ex01.ahk`, `DateTime_DateAdd_ex02.ahk`

```ahk
; Add time to date
NewDate := DateAdd(A_Now, 7, "Days")  ; Add 7 days
NewDate := DateAdd(A_Now, 3, "Months")  ; Add 3 months
NewDate := DateAdd(A_Now, -1, "Years")  ; Subtract 1 year
```

**Time Units:**
- `Seconds`, `Minutes`, `Hours`, `Days`, `Months`, `Years`

### 3. DateDiff

**Examples:** `DateTime_DateDiff_ex01.ahk`, `DateTime_DateDiff_ex02.ahk`

```ahk
; Calculate difference between dates
DaysDiff := DateDiff(Date1, Date2, "Days")
HoursDiff := DateDiff(Date1, Date2, "Hours")
```

### 4. Built-in Date/Time Variables

```ahk
A_Now         ; Current timestamp (YYYYMMDDHH24MISS)
A_Year        ; Current 4-digit year
A_Mon         ; Current month (01-12)
A_MDay        ; Current day of month (01-31)
A_WDay        ; Current day of week (1-7, Sun=1)
A_YDay        ; Current day of year (1-366)
A_Hour        ; Current hour (00-23)
A_Min         ; Current minute (00-59)
A_Sec         ; Current second (00-59)
A_MSec        ; Current millisecond (000-999)
```

---

## Environment Variables

### 1. EnvGet (Read Environment Variable)

**Examples:** `Env_EnvGet_ex1.ahk`, `Env_EnvGet_ex2.ahk`

```ahk
; Get environment variable
Path := EnvGet("PATH")
UserProfile := EnvGet("USERPROFILE")

; With default value if not found
Value := EnvGet("MY_VAR") || "default"
```

### 2. EnvSet (Set Environment Variable)

**Examples:** `Env_EnvSet_ex1.ahk`

```ahk
; Set environment variable
EnvSet("MY_VAR", "MyValue")

; Delete environment variable
EnvSet("MY_VAR", "")
```

### 3. SysGet (System Metrics)

**Examples:** `Env_SysGet_ex1.ahk` through `Env_SysGet_ex3.ahk`

```ahk
; Get screen dimensions
ScreenWidth := SysGet(78)   ; SM_CXVIRTUALSCREEN
ScreenHeight := SysGet(79)  ; SM_CYVIRTUALSCREEN

; Get monitor count
MonitorCount := SysGet(80)  ; SM_CMONITORS

; Get monitor info
MonitorGet(1, &Left, &Top, &Right, &Bottom)
MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)
```

### 4. Clipboard

**Examples:** `Env_Clipboard_ex1.ahk`

```ahk
; Set clipboard text
A_Clipboard := "Text to copy"

; Get clipboard text
Text := A_Clipboard

; Clear clipboard
A_Clipboard := ""

; Append to clipboard
A_Clipboard := A_Clipboard . "`nNew line"
```

### 5. ClipWait

**Examples:** `Env_ClipWait_ex1.ahk`

```ahk
; Copy and wait for clipboard
A_Clipboard := ""
Send("^c")
if ClipWait(2)  ; Wait up to 2 seconds
    MsgBox("Copied: " A_Clipboard)
else
    MsgBox("Clipboard timeout")
```

### 6. OnClipboardChange

**Examples:** `Env_OnClipboardChange_ex1.ahk`

```ahk
; Monitor clipboard changes
OnClipboardChange(ClipChanged)

ClipChanged(Type) {
    ; Type: 0=empty, 1=text, 2=non-text
    MsgBox("Clipboard changed: Type " Type)
}
```

### 7. Caret Position

**Examples:** `Env_CaretXY_ex1.ahk` through `Env_CaretXY_ex3.ahk`

```ahk
; Get caret position
X := A_CaretX
Y := A_CaretY
```

### 8. IP Address

**Examples:** `Env_IPAddress_ex1-4.ahk`

```ahk
; Get IP addresses
IP1 := A_IPAddress1
IP2 := A_IPAddress2
IP3 := A_IPAddress3
IP4 := A_IPAddress4
```

### 9. Batch Lines (Execution Speed)

**Examples:** `Env_BatchLines_ex1.ahk`

```ahk
; Set script execution speed
SetBatchLines(10)  ; 10ms sleep between lines
SetBatchLines(-1)  ; No sleep (fastest)
```

---

## Process Management

### 1. Run (Execute Programs)

**Examples:** `Process_Run_ex1.ahk` through `Process_Run_ex7.ahk`

```ahk
; Run a program
Run("notepad.exe")

; Run with parameters
Run("notepad.exe C:\MyFile.txt")

; Run and get PID
PID := Run("calc.exe")

; Run with working directory and options
Run("notepad.exe", "C:\MyFolder", "Max")  ; Max = maximized

; Run and wait
RunWait("cmd.exe /c dir > output.txt")
```

**Options:**
- `Min` - Minimized
- `Max` - Maximized
- `Hide` - Hidden

### 2. Process Commands

**Examples:** `Process_Process_ex1.ahk`, `Process_Process_ex2.ahk`, `Process_Process_close.ahk`

```ahk
; Check if process exists
if ProcessExist("notepad.exe")
    MsgBox("Notepad is running")

; Get process ID
PID := ProcessExist("notepad.exe")

; Close process
ProcessClose("notepad.exe")
ProcessClose(PID)  ; By PID

; Set process priority
ProcessSetPriority("High", "notepad.exe")
; Options: Low, BelowNormal, Normal, AboveNormal, High, Realtime

; Wait for process
ProcessWait("notepad.exe", 5)  ; Wait up to 5 seconds

; Wait for process to close
ProcessWaitClose("notepad.exe", 5)
```

### 3. RunAs

**Examples:** `Process_Runas_ex1.ahk`

```ahk
; Run as different user
RunAs("Username", "Password", "Domain")
Run("notepad.exe")
RunAs()  ; Turn off RunAs
```

### 4. Shutdown

**Examples:** `Process_Shutdown_ex1.ahk`, `Process_Shutdown_ex2.ahk`

```ahk
; Shutdown computer
Shutdown(1)  ; 1 = Shutdown

; Options:
; 0 = Logoff
; 1 = Shutdown
; 2 = Reboot
; 4 = Force
; 8 = Power down

; Forced reboot
Shutdown(2 + 4)  ; Reboot + Force
```

### 5. OnMessage (Window Message Handler)

**Examples:** `Process_OnMessage_ex2.ahk` through `Process_OnMessage_ex8.ahk`

```ahk
; Register message handler
OnMessage(0x0201, WM_LBUTTONDOWN)  ; Left mouse button down

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    MsgBox("Left button clicked in window")
    return 0
}

; Unregister handler
OnMessage(0x0201, WM_LBUTTONDOWN, 0)
```

---

## Registry Operations

### 1. RegRead

**Examples:** `Registry_RegRead_ex1.ahk`, `Registry_RegRead_ex2.ahk`

```ahk
; Read registry value
Value := RegRead("HKEY_LOCAL_MACHINE\Software\MyApp", "Setting")

; Read default value
Value := RegRead("HKEY_CURRENT_USER\Software\MyApp")

; Short key names
Value := RegRead("HKLM\Software\MyApp", "Setting")
Value := RegRead("HKCU\Software\MyApp", "Setting")
```

**Registry Root Keys:**
- `HKEY_LOCAL_MACHINE` or `HKLM`
- `HKEY_CURRENT_USER` or `HKCU`
- `HKEY_CLASSES_ROOT` or `HKCR`
- `HKEY_USERS` or `HKU`
- `HKEY_CURRENT_CONFIG` or `HKCC`

### 2. RegWrite

**Examples:** `Registry_RegWrite_ex1.ahk` through `Registry_RegWrite_ex3.ahk`

```ahk
; Write string value
RegWrite("Hello", "REG_SZ", "HKCU\Software\MyApp", "Setting")

; Write DWORD value
RegWrite(42, "REG_DWORD", "HKCU\Software\MyApp", "Number")

; Write to default value
RegWrite("Value", "REG_SZ", "HKCU\Software\MyApp")
```

**Value Types:**
- `REG_SZ` - String
- `REG_EXPAND_SZ` - Expandable string
- `REG_MULTI_SZ` - Multi-string
- `REG_DWORD` - 32-bit number
- `REG_QWORD` - 64-bit number
- `REG_BINARY` - Binary data

### 3. RegDelete

**Examples:** `Registry_RegDelete_ex1.ahk`

```ahk
; Delete registry value
RegDelete("HKCU\Software\MyApp", "Setting")

; Delete entire key
RegDeleteKey("HKCU\Software\MyApp")
```

### 4. Loop Registry

**Examples:** `Registry_Loop_regestry_ex1.ahk`

```ahk
; Loop through registry keys
Loop Reg, "HKCU\Software\MyApp", "KV"  ; K=keys, V=values
{
    if (A_LoopRegType = "KEY")
        MsgBox("Key: " A_LoopRegName)
    else
        MsgBox("Value: " A_LoopRegName " = " A_LoopRegValue)
}
```

**Loop Variables:**
- `A_LoopRegName` - Name of current item
- `A_LoopRegType` - "KEY" or value type
- `A_LoopRegValue` - Value data
- `A_LoopRegKey` - Full path to current key

### 5. SetRegView

**Examples:** `Registry_SetRegView_ex1.ahk`

```ahk
; Set registry view for 64-bit systems
SetRegView(64)  ; View 64-bit registry
SetRegView(32)  ; View 32-bit registry (default on 32-bit script)
SetRegView("Default")  ; Reset to default
```

---

## External Libraries and DLL Calls

### 1. DllCall

**Examples:** `Lib_DllCall_ex5.ahk`, `Lib_DllCall_ex7.ahk`, `Lib_DllCall_ex11.ahk`

```ahk
; Call Windows API function
Result := DllCall("MessageBox", "UInt", 0, "Str", "Text", "Str", "Title", "UInt", 0)

; Get performance counter
DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)
DllCall("QueryPerformanceCounter", "Int64*", &counter := 0)

; Call with return value
RetVal := DllCall("User32.dll\GetSystemMetrics", "Int", 0)
```

**Type Specifiers:**
- `Str` - String
- `Int` - 32-bit integer
- `Int64` - 64-bit integer
- `UInt` - Unsigned 32-bit integer
- `Ptr` - Pointer
- `*` suffix - Pass by reference (e.g., `Int*`)

### 2. NumPut

**Examples:** `Lib_Numput.ahk`, `Lib_Numput_ex2.ahk`

```ahk
; Write number to memory buffer
VarSetStrCapacity(&Buffer, 16)
NumPut("UInt", 123, Buffer, 0)
NumPut("UInt", 456, Buffer, 4)
```

### 3. NumGet

```ahk
; Read number from memory buffer
Value := NumGet(Buffer, 0, "UInt")
```

### 4. VarSetCapacity (Allocate Buffer)

**Examples:** `Lib_VarSetCapacity_ex1.ahk` through `Lib_VarSetCapacity_ex12.ahk`

```ahk
; Allocate buffer (v2: VarSetStrCapacity)
VarSetStrCapacity(&Buffer, 1024)  ; 1024 characters

; Or use Buffer() object
Buf := Buffer(1024)  ; 1024 bytes
```

### 5. COM Objects

**Examples:** `Lib_ComObjError_ex1.ahk`, `Lib_ComObjParameter_ex1.ahk`

```ahk
; Create COM object
xl := ComObject("Excel.Application")
xl.Visible := true

; ComObjMissing for optional parameters
xl.Cells(1, 1).Value := ComObjMissing()

; Error handling
ComObjError(false)  ; Suppress COM errors
ComObjError(true)   ; Enable COM errors
```

---

## Sound Operations

**Examples:** `Sound_SoundBeeb_ex1.ahk`, `Sound_SoundPlay_ex1.ahk`, `Sound_SoundGet_ex1.ahk`

### 1. Sound Playback

```ahk
; Play system beep
SoundBeep(750, 500)  ; Frequency 750 Hz, duration 500 ms

; Play sound file
SoundPlay("C:\Windows\Media\notify.wav")

; Play and wait
SoundPlay("sound.wav", "Wait")
```

### 2. Sound Volume

```ahk
; Get volume
Volume := SoundGetVolume()

; Set volume
SoundSetVolume(50)  ; 0-100

; Mute/unmute
SoundSetMute(true)
SoundSetMute(false)
```

---

## Screen Operations

**Examples:** `Screen_PixelGetColor_ex1.ahk`, `Screen_PixelSearch_ex1.ahk`, `Screen_ImageSearch_ex1.ahk`

### 1. Pixel Operations

```ahk
; Get pixel color
Color := PixelGetColor(100, 200)
MsgBox("Color at 100,200 is " Color)

; Search for pixel color
if PixelSearch(&FoundX, &FoundY, 0, 0, 1000, 1000, 0xFF0000)
    MsgBox("Red pixel found at " FoundX ", " FoundY)
```

### 2. Image Search

```ahk
; Search for image on screen
if ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "C:\image.png")
    MsgBox("Image found at " FoundX ", " FoundY)

; With variation tolerance
if ImageSearch(&FoundX, &FoundY, 0, 0, 1000, 1000, "*50 C:\image.png")
    ; *50 = 50 shades of variation allowed
```

---

## Mathematical Operations

**Examples:** `Maths_Transform_BitMath.ahk`, `Maths_Transform_NumberMath.ahk`

### 1. Basic Math

```ahk
; Arithmetic operators
result := 10 + 5    ; 15
result := 10 - 5    ; 5
result := 10 * 5    ; 50
result := 10 / 5    ; 2
result := 10 // 3   ; 3 (integer division)
result := 10 ** 2   ; 100 (power)
result := Mod(10, 3) ; 1 (modulo)
```

### 2. Bitwise Operations

```ahk
; Bitwise operators
result := 5 & 3     ; Bitwise AND
result := 5 | 3     ; Bitwise OR
result := 5 ^ 3     ; Bitwise XOR
result := ~5        ; Bitwise NOT
result := 5 << 1    ; Left shift
result := 5 >> 1    ; Right shift
```

### 3. Math Functions

```ahk
; Math functions
result := Abs(-5)           ; 5
result := Ceil(4.3)         ; 5
result := Floor(4.7)        ; 4
result := Round(4.5)        ; 5
result := Sqrt(16)          ; 4
result := Exp(1)            ; e
result := Ln(10)            ; Natural log
result := Log(100)          ; Base-10 log
result := Sin(1.5708)       ; 1
result := Cos(0)            ; 1
result := Tan(0.7854)       ; 1

; Random
Random := Random(1, 100)    ; Random integer 1-100
Random := Random()          ; Random float 0.0-1.0
```

### 4. Type Checking

**Examples:** `Misc_isFloat_ex01.ahk` through `Misc_isFloat_ex04.ahk`

```ahk
; Check if float
if IsFloat(value)
    MsgBox("Is a float")

; Check if integer
if IsInteger(value)
    MsgBox("Is an integer")

; Check if number
if IsNumber(value)
    MsgBox("Is a number")
```

### 5. Number Formatting

```ahk
; Format number
Formatted := Format("{:.2f}", 3.14159)  ; "3.14"
Formatted := Format("{:06d}", 42)       ; "000042"
```

---

## Code Integrity and Testing

**Examples:** `Integrity_*.ahk` files, `Yunit_tests\Y_Test_*.ahk` files (163 examples)

### 1. Unit Testing Framework (Yunit)

The repository contains 163 Yunit test examples demonstrating:

```ahk
; Basic test structure
class MyTests {
    TestMethod1() {
        ; Assertions
        Assert.Equal(expected, actual)
        Assert.True(condition)
        Assert.False(condition)
    }
}
```

### 2. Code Integrity Checks

**Examples:** `Integrity_Accumulated Errors 01.ahk`, `Integrity_Class&Func_Mask_01.ahk`

These examples test:
- Proper error accumulation
- Class and function masking
- Continuation section handling
- Output formatting issues
- Logical correctness

### 3. Persistent Directive

```ahk
; Keep script running
Persistent

; Or in v2
#Requires AutoHotkey v2.0
; Script stays running if it has hotkeys, timers, or GUI
```

---

## Migration from v1 to v2

### Key Syntax Changes

#### 1. Function Calls

```ahk
; v1
MsgBox, Hello
FileAppend, Text, File.txt
WinActivate, Notepad

; v2
MsgBox("Hello")
FileAppend("Text", "File.txt")
WinActivate("Notepad")
```

#### 2. Variable References

```ahk
; v1
var = value
var := "expression"

; v2
var := "value"  ; Always use :=
```

#### 3. Arrays

```ahk
; v1
arr := []
arr[1] := "first"
max := arr.MaxIndex()

; v2
arr := []
arr[1] := "first"  ; Still 1-indexed
length := arr.Length
```

#### 4. ByRef

```ahk
; v1
Swap(ByRef a, ByRef b)

; v2
Swap(&a, &b)  ; Use & operator
```

#### 5. GUI

```ahk
; v1
Gui, Add, Text,, Hello
Gui, Show

; v2
myGui := Gui()
myGui.Add("Text", , "Hello")
myGui.Show()
```

#### 6. Commands vs Functions

Most v1 commands become functions in v2:
- `StringLen` → `StrLen()`
- `StringUpper` → `StrUpper()`
- `IfWinExist` → `if WinExist()`
- `Loop, Parse` → `Loop Parse`

### Failed Conversions

**Examples:** `Failed_*.ahk` files

These examples document known conversion issues and workarounds for:
- Complex delimiter scenarios
- Global GUI variables
- Menu edge cases
- Process commands edge cases
- String case sensitivity issues
- Ternary operator edge cases

---

## Built-in Variables Reference

### A_Variables (System Information)

```ahk
; Script info
A_ScriptName          ; Script filename
A_ScriptDir           ; Script directory
A_ScriptFullPath      ; Full path to script
A_LineNumber          ; Current line number
A_LineFile            ; Current file name
A_ThisFunc            ; Current function name

; System info
A_ComputerName        ; Computer name
A_UserName            ; Username
A_IsAdmin             ; Is admin (true/false)
A_AhkVersion          ; AHK version
A_OSVersion           ; Windows version

; Screen
A_ScreenWidth         ; Primary monitor width
A_ScreenHeight        ; Primary monitor height
A_ScreenDPI           ; Screen DPI

; Directories
A_WorkingDir          ; Current working directory
A_ScriptDir           ; Script's directory
A_AppData             ; %APPDATA%
A_AppDataCommon       ; %ALLUSERSPROFILE%
A_Desktop             ; Desktop folder
A_DesktopCommon       ; All users desktop
A_StartMenu           ; Start menu folder
A_Programs            ; Programs folder
A_Startup             ; Startup folder
A_Temp                ; Temp folder
A_WinDir              ; Windows directory
A_ProgramFiles        ; Program Files
```

### Loop Variables

```ahk
A_Index               ; Current loop iteration (1-based)
A_LoopField           ; Current field in Loop Parse
A_LoopFileName        ; Current filename in Loop Files
A_LoopFilePath        ; Current full path in Loop Files
A_LoopFileDir         ; Current file's directory
A_LoopFileExt         ; Current file's extension
A_LoopFileFullPath    ; Current file's full path
A_LoopFileSize        ; Current file's size
A_LoopReadLine        ; Current line in Loop Read
A_LoopRegName         ; Current registry name
A_LoopRegType         ; Current registry type
A_LoopRegValue        ; Current registry value
```

---

## Best Practices for v2

### 1. Always Use Expression Mode

```ahk
; Good
var := "value"
if (condition)

; Avoid (legacy v1 style)
var = value
if var = value
```

### 2. Use Object-Oriented GUI

```ahk
; Good
myGui := Gui()
myGui.Add("Button", , "Click").OnEvent("Click", ButtonClick)

; Avoid (legacy v1 style with g-labels)
Gui, Add, Button, gButtonClick
```

### 3. Pass by Reference with &

```ahk
; Good
Function(&param)
Function(&variable)

; Avoid (v1 style)
Function(ByRef param)
```

### 4. Use Modern Error Handling

```ahk
; Good
try {
    ; code
} catch Error as err {
    MsgBox(err.Message)
}

; Avoid (v1 style)
ErrorLevel checks
```

### 5. Use Arrays and Maps Properly

```ahk
; Arrays (indexed)
arr := ["item1", "item2"]
arr.Push("item3")
length := arr.Length

; Maps (associative)
map := Map()
map["key"] := "value"
```

---

## Summary of Coverage

This repository's 1,719 examples comprehensively cover:

### ✅ **Extensively Covered** (50+ examples each)
- String operations and manipulation
- File and directory I/O
- GUI creation and controls
- Window management and detection
- Flow control structures

### ✅ **Well Covered** (20-50 examples)
- Mouse and keyboard input
- Directives and script settings
- Process management
- Message boxes and dialogs

### ✅ **Adequately Covered** (10-20 examples)
- Date/time operations
- Environment variables
- Registry operations
- External libraries and DLL calls

### ✅ **Covered** (5-10 examples)
- Sound operations
- Screen/pixel operations
- Mathematical operations
- Code integrity and testing

### ✅ **Documented** (Failed conversions)
- Edge cases and known issues
- Migration challenges
- Workarounds for tricky scenarios

---

## Learning Path Recommendation

### Beginner (Start Here)
1. Variable assignment (`String_Assignment_*.ahk`)
2. Basic functions (`Misc_MyFunc_*.ahk`)
3. If statements (`Control_if_*.ahk`)
4. Loops (`Control_Loop*.ahk`)
5. MsgBox (`GUI_MsgBox_*.ahk`)

### Intermediate
1. Arrays (`String_Array_*.ahk`)
2. String operations (`String_SubStr_*.ahk`, `String_InStr_*.ahk`)
3. File operations (`File_*.ahk`)
4. Window management (`Window_*.ahk`)
5. GUI creation (`GUI_Gui_*.ahk`)

### Advanced
1. ByRef parameters (`Control_ByRef_*.ahk`)
2. Classes and objects (`Misc_Class-*.ahk`)
3. Error handling (`Control_Catch_*.ahk`)
4. DLL calls (`Lib_DllCall_*.ahk`)
5. OnMessage handlers (`Process_OnMessage_*.ahk`)

---

## Additional Resources

- **AHK v2 Documentation**: https://www.autohotkey.com/docs/v2/
- **Migration Guide**: https://www.autohotkey.com/docs/v2/v2-changes.htm
- **Example Files**: `/data/raw_scripts/AHK_v2_Examples/`
- **Failed Conversions**: Study `Failed_*.ahk` files for edge cases

---

**Last Updated:** November 5, 2025
**Total Examples Documented:** 1,719
**Categories Covered:** 19
