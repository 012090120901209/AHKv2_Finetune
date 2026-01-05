#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Window Detection Patterns
 * Source: github.com/PillowD/autohotkey
 * 
 * Demonstrates:
 * - WinExist() for window detection
 * - Three ways to negate conditions in AHK v2
 * - MsgBox with timeout (T2 = 2 seconds)
 * - Hotkey definition (Esc::ExitApp)
 */

; Method 1: Using ! (logical NOT)
if !WinExist("Notepad") {
    MsgBox("Notepad is NOT open", "Method 1: ! operator", "T2")
} else {
    MsgBox("Notepad IS open", "Method 1: ! operator", "T2")
}

Sleep(500)

; Method 2: Using not() function
if not (WinExist("Notepad")) {
    MsgBox("Notepad is NOT open", "Method 2: not() function", "T2")
} else {
    MsgBox("Notepad IS open", "Method 2: not() function", "T2")
}

Sleep(500)

; Method 3: Positive check (standard)
if WinExist("Notepad") {
    MsgBox("Notepad IS open", "Method 3: Positive check", "T2")
} else {
    MsgBox("Notepad is NOT open", "Method 3: Positive check", "T2")
}

; All three methods are equivalent - use whichever is most readable

; Exit on Escape key
Esc:: ExitApp
