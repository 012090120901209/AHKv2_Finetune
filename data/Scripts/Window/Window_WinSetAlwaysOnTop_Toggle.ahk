#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Window Always-On-Top Toggle
 * 
 * Demonstrates toggling the always-on-top state of windows,
 * useful for keeping reference windows visible while working.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Always-On-Top Toggle Demo`n`n"
    . "Hotkey: Alt+T`n`n"
    . "Open Notepad and press Alt+T to toggle always-on-top.`n"
    . "The window will stay on top of other windows.", , "T5")

; Open Notepad for demo
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")

MsgBox("Press Alt+T to toggle always-on-top for this window!", , "T3")

; Hotkey to toggle always-on-top
!t:: ToggleAlwaysOnTop()

/**
 * Toggle always-on-top for active window
 */
ToggleAlwaysOnTop() {
    ; Get active window
    hwnd := WinExist("A")
    if (!hwnd)
        return

    ; Get window title
    title := WinGetTitle("ahk_id " hwnd)

    ; Check current state
    exStyle := WinGetExStyle("ahk_id " hwnd)
    isOnTop := (exStyle & 0x8)  ; WS_EX_TOPMOST = 0x8

    ; Toggle state
    if (isOnTop) {
        WinSetAlwaysOnTop(0, "ahk_id " hwnd)
        state := "OFF"
        ToolTip("Always-On-Top: OFF`n" title)
    } else {
        WinSetAlwaysOnTop(1, "ahk_id " hwnd)
        state := "ON"
        ToolTip("Always-On-Top: ON`n" title)
    }

    SetTimer(() => ToolTip(), -2000)
}

/*
* Key Concepts:
*
* 1. Always-On-Top:
*    Window stays above others
*    WS_EX_TOPMOST extended style
*    Useful for reference windows
*
* 2. Window Styles:
*    WinGetExStyle() - Get extended styles
*    0x8 = WS_EX_TOPMOST flag
*    Bitwise AND to check state
*
* 3. Toggle Pattern:
*    Check current state
*    Switch to opposite
*    Provide feedback
*
* 4. Use Cases:
*    ✅ Reference documents
*    ✅ Calculator while working
*    ✅ Chat windows
*    ✅ Video players
*    ✅ System monitors
*
* 5. WinSetAlwaysOnTop:
*    WinSetAlwaysOnTop(1) - Enable
*    WinSetAlwaysOnTop(0) - Disable
*    WinSetAlwaysOnTop(-1) - Toggle
*
* 6. Window Identification:
*    WinExist("A") - Active window
*    ahk_id hwnd - Specific window
*    Stable reference
*
* 7. Extended Styles:
*    WS_EX_TOPMOST = 0x8
*    WS_EX_TOOLWINDOW = 0x80
*    WS_EX_TRANSPARENT = 0x20
*    Many other flags
*
* 8. Best Practices:
*    ✅ Show visual feedback
*    ✅ Display window title
*    ✅ Check if window exists
*    ✅ Easy toggle hotkey
*
* 9. Related Operations:
*    - Window transparency
*    - Minimize to tray
*    - Window pinning
*    - Workspace management
*
* 10. Common Hotkeys:
*     Alt+T - Toggle (non-conflicting)
*     Ctrl+Space - Alternative
*     Win+P - Pin window
*
* 11. Enhanced Version:
*     - Remember pinned windows
*     - Visual indicator (border)
*     - Group pinning
*     - Per-app defaults
*
* 12. Limitations:
*     ⚠ Doesn't work on UAC dialogs
*     ⚠ Some apps override style
*     ⚠ May interfere with full-screen
*/

