#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinHide Examples - Part 3
 * ============================================================================
 * 
 * Demonstrates window hiding techniques.
 * 
 * @description Window hiding examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Hide Active Window
; ============================================================================

/**
 * Hides the active window
 * 
 * @hotkey F1 - Hide active window
 */
F1:: {
    if WinExist("A") {
        WinHide("A")
        ToolTip("Window hidden (press F8 to show)")
        SetTimer(() => ToolTip(), -2000)
    }
}

; ============================================================================
; Example 2: Hide Window to Tray
; ============================================================================

/**
 * Hides window to system tray concept
 * 
 * @hotkey F2 - Hide to tray
 */
F2:: {
    if WinExist("A") {
        global hiddenWindow := WinGetID("A")
        WinHide(hiddenWindow)
        TrayTip("Window hidden to tray", "Press F8 to restore")
    }
}

; ============================================================================
; Example 3: Toggle Window Visibility
; ============================================================================

/**
 * Toggles visibility of specific window
 * 
 * @hotkey F3 - Toggle Notepad visibility
 */
F3:: {
    if WinExist("ahk_class Notepad") {
        if WinGetStyle("ahk_class Notepad") & 0x10000000 {  ; WS_VISIBLE
            WinHide("ahk_class Notepad")
            ToolTip("Notepad hidden")
        } else {
            WinShow("ahk_class Notepad")
            WinActivate("ahk_class Notepad")
            ToolTip("Notepad shown")
        }
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 4: Hide Multiple Windows
; ============================================================================

/**
 * Hides all windows of a process
 * 
 * @hotkey F4 - Hide all Notepad windows
 */
F4:: {
    windows := WinGetList("ahk_exe notepad.exe")

    for hwnd in windows {
        try {
            WinHide(hwnd)
        }
    }

    MsgBox("Hidden " windows.Length " Notepad window(s).", "Success", 64)
}

; ============================================================================
; Example 5: Hide Except Active
; ============================================================================

/**
 * Hides all windows except active
 * 
 * @hotkey F5 - Hide all except active
 */
F5:: {
    activeHwnd := WinGetID("A")
    allWindows := WinGetList()
    hidden := 0

    for hwnd in allWindows {
        if hwnd != activeHwnd {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    WinHide(hwnd)
                    hidden++
                }
            }
        }
    }

    MsgBox("Hidden " hidden " window(s).", "Success", 64)
}

; ============================================================================
; Example 6: Temporary Hide
; ============================================================================

/**
 * Hides window temporarily then shows again
 * 
 * @hotkey F6 - Temporary hide
 */
F6:: {
    if !WinExist("A") {
        return
    }

    hwnd := WinGetID("A")
    WinHide(hwnd)
    ToolTip("Hidden for 5 seconds...")

    SetTimer(() => RestoreWindow(hwnd), 5000)
}

RestoreWindow(hwnd) {
    if WinExist(hwnd) {
        WinShow(hwnd)
        WinActivate(hwnd)
        ToolTip("Window restored")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 7: Hide Window Group
; ============================================================================

/**
 * Hides a group of windows
 * 
 * @hotkey F7 - Hide window group
 */
F7:: {
    ; Hide all browser windows
    browsers := ["chrome.exe", "firefox.exe", "msedge.exe"]
    hidden := 0

    for browser in browsers {
        windows := WinGetList("ahk_exe " browser)
        for hwnd in windows {
            try {
                WinHide(hwnd)
                hidden++
            }
        }
    }

    MsgBox("Hidden " hidden " browser window(s).", "Success", 64)
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinHide Examples - Part 3
    =============================

    Hotkeys:
    F1 - Hide active window
    F2 - Hide to tray
    F3 - Toggle Notepad visibility
    F4 - Hide all Notepad windows
    F5 - Hide all except active
    F6 - Temporary hide (5 sec)
    F7 - Hide browser windows
    F8 - Show hidden window
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}

; Show hidden window
F8:: {
    if IsSet(hiddenWindow) && WinExist(hiddenWindow) {
        WinShow(hiddenWindow)
        WinActivate(hiddenWindow)
        ToolTip("Window shown")
        SetTimer(() => ToolTip(), -1500)
    }
}
