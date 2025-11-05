# AutoHotkey v2 Function Corrections & Examples Guide

**Complete reference for corrected AHK v2 functions with working examples**

---

## Table of Contents

1. [System Settings Functions](#system-settings-functions)
2. [Mouse & Keyboard Functions](#mouse--keyboard-functions)
3. [Control Functions](#control-functions)
4. [Process & Command Execution](#process--command-execution)
5. [Drive Functions](#drive-functions)
6. [Utility Functions](#utility-functions)
7. [Quick Reference](#quick-reference)

---

## System Settings Functions

**File**: `v2_Fixed_SystemSettings.ahk`

### BlockInput(option)

Prevents or allows user input (keyboard/mouse).

```autohotkey
BlockInput(true)   ; Block all input
BlockInput(false)  ; Unblock input
BlockInput("Send") ; Block everything except Send commands
```

**Parameters:**
- `true` - Block all input
- `false` - Unblock input
- `"Send"`, `"Mouse"`, `"SendAndMouse"`, `"Default"` - Specific blocking modes

### CoordMode(targetType, relativeTo)

Sets coordinate system for various commands.

```autohotkey
CoordMode("Mouse", "Screen")  ; Mouse coords relative to screen
CoordMode("Mouse", "Window")  ; Relative to active window
CoordMode("Pixel", "Client")  ; Pixel search in client area
```

**Target Types:** `"Mouse"`, `"Pixel"`, `"Caret"`, `"Menu"`, `"ToolTip"`
**Relative To:** `"Screen"`, `"Window"`, `"Client"`

### Critical(onOffNumeric)

Prevents current thread from being interrupted.

```autohotkey
Critical()         ; Enable critical
Critical(false)    ; Disable critical
Critical(1000)     ; Critical for 1000ms
```

### DetectHiddenWindows(onOff)

Controls whether hidden windows are detected.

```autohotkey
DetectHiddenWindows(true)   ; Detect hidden windows
DetectHiddenWindows(false)  ; Ignore hidden windows
```

### DetectHiddenText(onOff)

Controls whether hidden text in windows is detected.

```autohotkey
DetectHiddenText(true)
DetectHiddenText(false)
```

### SetWinDelay(delay)

Sets delay between window commands.

```autohotkey
SetWinDelay(100)   ; 100ms delay
SetWinDelay(-1)    ; No delay (fastest)
```

### SetControlDelay(delay)

Sets delay between control commands.

```autohotkey
SetControlDelay(50)  ; 50ms delay
SetControlDelay(-1)  ; No delay
```

---

## Mouse & Keyboard Functions

**File**: `v2_Fixed_MouseKeyboard.ahk`

### Click(params*)

Clicks the mouse.

```autohotkey
Click()                    ; Click at current position
Click(100, 200)            ; Click at coordinates
Click("Right")             ; Right click
Click(2)                   ; Double click
Click("WheelUp", 3)        ; Scroll wheel up 3 times
```

### MouseMove(x, y, speed)

Moves the mouse cursor.

```autohotkey
MouseMove(500, 500)       ; Move instantly
MouseMove(500, 500, 50)   ; Move with speed 50
```

### MouseGetPos(&x, &y, &winId, &ctrlId)

Gets mouse position and window/control under cursor.

```autohotkey
MouseGetPos(&xPos, &yPos)                    ; Position only
MouseGetPos(&xPos, &yPos, &winId)            ; + Window ID
MouseGetPos(&xPos, &yPos, &winId, &ctrlId)   ; + Control ID
```

### Send(keys)

Sends keystrokes and mouse clicks.

```autohotkey
Send("Hello World")   ; Send text
Send("^c")            ; Ctrl+C
Send("!{Tab}")        ; Alt+Tab
Send("+a")            ; Shift+A
```

### SendText(text)

Sends raw text without interpreting special characters.

```autohotkey
SendText("This {will} not ^interpret !special +characters")
```

### SendInput(keys)

Faster, more reliable version of Send.

```autohotkey
SendInput("Fast typing!")
SendInput("^v")  ; Ctrl+V
```

### ClipWait(timeout, mode)

Waits for clipboard to contain data.

```autohotkey
A_Clipboard := ""
Send("^c")
if ClipWait(1)              ; Wait 1 second
    MsgBox(A_Clipboard)
```

**Returns:** `true` if data arrived, `false` if timeout

### KeyWait(keyName, options)

Waits for key to be pressed or released.

```autohotkey
KeyWait("Space", "D T5")    ; Wait for press, 5 sec timeout
KeyWait("Space")            ; Wait for release
```

**Options:**
- `D` - Wait for key down
- `T5` - 5 second timeout
- `L` - Wait for logical state

### GetKeyState(keyName, mode)

Checks if key is pressed.

```autohotkey
if GetKeyState("Shift", "P")      ; Physical state
    MsgBox("Shift is pressed")

if GetKeyState("CapsLock", "T")   ; Toggle state
    MsgBox("CapsLock is ON")
```

### MouseClickDrag(button, x1, y1, x2, y2, speed)

Clicks and drags.

```autohotkey
MouseClickDrag("Left", 100, 100, 300, 300)     ; Drag
MouseClickDrag("Left", 100, 100, 300, 300, 50) ; Slower
```

---

## Control Functions

**File**: `v2_Fixed_ControlFunctions.ahk`

### ControlGetHwnd(control, winTitle)

Gets handle of a control.

```autohotkey
hwnd := ControlGetHwnd("Edit1", "A")
```

### ControlGetText(control, winTitle)

Gets text from a control.

```autohotkey
text := ControlGetText("Edit1", "ahk_class Notepad")
```

### ControlSetText(newText, control, winTitle)

Sets text in a control.

```autohotkey
ControlSetText("Hello!", "Edit1", "A")
```

### ControlClick(control, winTitle, whichButton, clickCount, options)

Clicks a control.

```autohotkey
ControlClick("Button1", "A")                ; Left click
ControlClick("Button1", "A", "Right")       ; Right click
ControlClick("X50 Y50", "A")                ; Click coordinates
```

### ControlSend(keys, control, winTitle)

Sends keystrokes to a control.

```autohotkey
ControlSend("Hello!{Enter}", "Edit1", "A")
```

### ControlFocus(control, winTitle)

Focuses a control.

```autohotkey
ControlFocus("Edit1", "A")
```

### ControlGetPos(&x, &y, &w, &h, control, winTitle)

Gets position and size of control.

```autohotkey
ControlGetPos(&x, &y, &w, &h, "Edit1", "A")
MsgBox("Position: " x ", " y "`nSize: " w " x " h)
```

### ControlMove(x, y, width, height, control, winTitle)

Moves/resizes a control.

```autohotkey
ControlMove(10, 10, , , "Edit1", "A")  ; Move only
ControlMove(, , 300, 200, "Edit1", "A") ; Resize only
```

### ControlGetFocus(winTitle)

Gets ClassNN of focused control.

```autohotkey
focused := ControlGetFocus("A")
MsgBox("Focused control: " focused)
```

### ControlGetItems(control, winTitle)

Gets array of items from ListBox/ComboBox.

```autohotkey
items := ControlGetItems("ListBox1", "A")
for item in items
    MsgBox(item)
```

### ControlGetChoice(control, winTitle)

Gets selected item from ListBox/ComboBox.

```autohotkey
selected := ControlGetChoice("ComboBox1", "A")
```

### ControlChooseString(string, control, winTitle)

Selects item by text.

```autohotkey
ControlChooseString("Apple", "ComboBox1", "A")
```

### ControlChooseIndex(index, control, winTitle)

Selects item by position (1-based).

```autohotkey
ControlChooseIndex(3, "ListBox1", "A")
```

### ControlHide(control, winTitle)

Hides a control.

```autohotkey
ControlHide("Button1", "A")
```

### ControlShow(control, winTitle)

Shows a hidden control.

```autohotkey
ControlShow("Button1", "A")
```

### ControlSetEnabled(enabled, control, winTitle)

Enables or disables a control.

```autohotkey
ControlSetEnabled(false, "Button1", "A")  ; Disable
ControlSetEnabled(true, "Button1", "A")   ; Enable
```

---

## Process & Command Execution

**File**: `v2_Fixed_ProcessCommand.ahk`

### StdOutToVar(sCmd)

Executes command and returns complete stdout output.

```autohotkey
result := StdOutToVar("ping 1.1.1.1")
MsgBox(result)

result := StdOutToVar("dir " A_ScriptDir)
MsgBox(result)
```

**Use Cases:**
- Execute command-line programs
- Capture output from batch files
- Run PowerShell commands
- Execute Python/Node.js scripts

**Examples:**

```autohotkey
; Get system info
info := StdOutToVar("systeminfo")

; List processes
processes := StdOutToVar("tasklist")

; Execute PowerShell
ps := StdOutToVar('powershell -Command "Get-Process"')

; Run Python
python := StdOutToVar('python -c "print(2+2)"')
```

### StdOutStream(sCmd, Callback)

Executes command and streams output to callback function.

```autohotkey
; Callback receives each chunk of output
callback := (text, lineNumber) {
    if (lineNumber > 0)
        ToolTip("Line " lineNumber ": " text)
    else
        ToolTip()  ; Command complete
}

StdOutStream("ping -n 10 localhost", callback)
```

**Parameters:**
- `sCmd` - Command to execute
- `Callback` - Function called for each output chunk
  - `Callback(text, lineNumber)` - Called during execution
  - `Callback("", 0)` - Called when complete

**Use Cases:**
- Real-time output display
- Progress monitoring
- Long-running commands
- Interactive command execution

---

## Drive Functions

**File**: `v2_Fixed_DriveFunctions.ahk`

### DriveEject(drive)

Ejects a CD/DVD drive.

```autohotkey
DriveEject("D:")
```

### DriveRetract(drive)

Retracts (closes) a CD/DVD drive.

```autohotkey
DriveRetract("D:")
```

### DriveLock(drive)

Locks a drive (prevents ejection).

```autohotkey
DriveLock("D:")
```

### DriveUnlock(drive)

Unlocks a drive.

```autohotkey
DriveUnlock("D:")
```

### DriveGetType(path)

Gets drive type.

```autohotkey
type := DriveGetType("C:")
; Returns: "Unknown", "Removable", "Fixed", "Network", "CDROM", "RAMDisk"
```

### DriveGetLabel(drive)

Gets drive label (volume name).

```autohotkey
label := DriveGetLabel("C:")
```

### DriveSetLabel(drive, newLabel)

Sets drive label.

```autohotkey
DriveSetLabel("D:", "MyDrive")
```

### DriveGetFilesystem(drive)

Gets filesystem type.

```autohotkey
fs := DriveGetFilesystem("C:")
; Returns: "NTFS", "FAT32", "exFAT", etc.
```

### DriveGetSerial(drive)

Gets drive serial number.

```autohotkey
serial := DriveGetSerial("C:")
```

### DriveGetCapacity(drive)

Gets drive capacity in bytes.

```autohotkey
capacity := DriveGetCapacity("C:")
MsgBox("Capacity: " Round(capacity / 1073741824, 2) " GB")
```

### DriveGetSpaceFree(drive)

Gets free space in bytes.

```autohotkey
free := DriveGetSpaceFree("C:")
MsgBox("Free: " Round(free / 1073741824, 2) " GB")
```

### DriveGetStatus(drive)

Gets drive status.

```autohotkey
status := DriveGetStatus("C:")
; Returns: "Ready", "NotReady", "Invalid"
```

### DriveGetList(type)

Gets list of drives.

```autohotkey
all := DriveGetList()          ; All drives
fixed := DriveGetList("FIXED") ; Only fixed drives

; Returns string of drive letters: "ACD"
for drive in StrSplit(all)
    MsgBox(drive ":")
```

**Drive Types:**
- `"CDROM"` - CD/DVD drives
- `"REMOVABLE"` - Removable drives
- `"FIXED"` - Fixed drives
- `"NETWORK"` - Network drives
- `"RAMDISK"` - RAM disks
- `"UNKNOWN"` - Unknown type

---

## Utility Functions

**File**: `v2_Fixed_UtilityFunctions.ahk`

### binSearch(arr, match, r, l)

Binary search algorithm for sorted arrays.

```autohotkey
numbers := [1, 3, 5, 7, 9, 11, 13, 15]

index := binSearch(numbers, 7)    ; Returns 4
index := binSearch(numbers, 10)   ; Returns -1 (not found)
```

**Parameters:**
- `arr` - Sorted array to search
- `match` - Value to find
- `r` - Right index (optional, defaults to array length)
- `l` - Left index (optional, defaults to 0)

**Returns:** Index of match (1-based), or -1 if not found

**Performance:** O(log n) - very fast for large arrays

**Example Use Cases:**

```autohotkey
; Search numbers
numbers := [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
index := binSearch(numbers, 50)

; Search strings (must be sorted alphabetically)
words := ["apple", "banana", "cherry", "date", "fig"]
index := binSearch(words, "cherry")

; Large datasets
largeArray := []
loop 100000
    largeArray.Push(A_Index * 2)
index := binSearch(largeArray, 50000)  ; Very fast!
```

### borderlessMode(winId, onOff)

Toggle borderless mode for a window (removes title bar and borders).

```autohotkey
borderlessMode("A", "t")       ; Toggle on active window
borderlessMode("A", 1)         ; Enable borderless
borderlessMode("A", 0)         ; Disable borderless
borderlessMode("ahk_class Notepad", "t")  ; Toggle on Notepad
```

**Parameters:**
- `winId` - Window identifier (default: `"A"` for active window)
- `onOff` - `"t"` = toggle, `1`/`true` = on, `0`/`false` = off

**Features:**
- Removes title bar and window borders
- Can toggle always-on-top
- Automatically refreshes window
- Works with any window

**Use Cases:**
- Gaming overlays
- Minimalist window appearance
- Custom window decorations
- Fullscreen-like mode

### borderlessMove(winId, key)

Enable click-and-drag to move borderless windows.

```autohotkey
; Hold left mouse button and drag to move window
borderlessMove("A", "LButton")

; Use right button to drag
borderlessMove("A", "RButton")
```

**Parameters:**
- `winId` - Window identifier (default: `"A"`)
- `key` - Mouse button to use (default: `"LButton"`)

**Usage Pattern:**

```autohotkey
; Make window borderless and draggable
borderlessMode("A", 1)
Hotkey("~LButton", (*) => borderlessMove("A", "LButton"))
```

**Features:**
- Works on any part of window
- Respects borderless check
- Smooth dragging
- Won't move fullscreen windows

---

## Quick Reference

### Common Patterns

**Get window text:**
```autohotkey
text := WinGetText("A")
```

**Get window position:**
```autohotkey
WinGetPos(&x, &y, &w, &h, "A")
```

**Activate window:**
```autohotkey
WinActivate("ahk_class Notepad")
```

**Wait for window:**
```autohotkey
WinWait("ahk_class Notepad", , 5)
```

**Check if window exists:**
```autohotkey
if WinExist("ahk_class Notepad")
    MsgBox("Notepad is open")
```

**Loop through windows:**
```autohotkey
for hwnd in WinGetList("ahk_class Notepad")
    MsgBox("Window: " hwnd)
```

### Error Handling

All functions use try/catch for proper error handling:

```autohotkey
try {
    result := ControlGetText("Edit1", "A")
    MsgBox(result)
} catch Error as e {
    MsgBox("Error: " e.Message)
}
```

### Performance Tips

1. **Use SetWinDelay(-1)** for faster window commands
2. **Use SetControlDelay(-1)** for faster control commands
3. **Use SendInput** instead of Send for faster, more reliable input
4. **Use Critical** for uninterruptible code sections
5. **Use binary search** for large sorted datasets

### Migration Notes

**Key Changes:**

1. **ByRef** → `&` for output parameters
2. **ErrorLevel** → Return values or exceptions
3. **%var%** → `var` (no percent signs in expressions)
4. **Command style** → Function style with parentheses
5. **ControlGet** → Multiple specific functions

**Parameter Order Changes:**

```autohotkey
; Control: different now
ControlGetText("Edit1", "A")     ; control, then window

; WinGet: different now
WinGetPos(&x, &y, &w, &h, "A")  ; outputs first, window last
```

---

## File Organization

All corrected functions are organized into separate files:

1. **v2_Fixed_SystemSettings.ahk** - System and script settings
2. **v2_Fixed_MouseKeyboard.ahk** - Mouse and keyboard input
3. **v2_Fixed_ControlFunctions.ahk** - Control manipulation
4. **v2_Fixed_ProcessCommand.ahk** - Command execution
5. **v2_Fixed_DriveFunctions.ahk** - Drive operations
6. **v2_Fixed_UtilityFunctions.ahk** - Helper functions

Each file contains:
- JSDoc-style documentation
- Multiple working examples
- Proper error handling
- Performance optimizations

---

## Additional Resources

### Official Documentation
- **AutoHotkey v2 Docs**: https://www.autohotkey.com/docs/v2/
- **Command List**: https://www.autohotkey.com/docs/v2/lib/
- **Migration Guide**: https://www.autohotkey.com/docs/v2/v2-changes.htm

### Related Guides in This Repository
- [AHK v2 Examples Feature Guide](./AHK_v2_Examples_Feature_Guide.md)
- [AHK v2 Examples Classification Guide](./AHK_v2_Examples_Classification_Guide.md)
- [Popular AHK v2 GitHub Libraries](./Popular_AHK_v2_GitHub_Libraries_Guide.md)

---

**Last Updated**: January 2025
**Total Functions**: 50+
**Total Examples**: 100+

*This guide is part of the AHKv2_Finetune project with 900+ examples.*
