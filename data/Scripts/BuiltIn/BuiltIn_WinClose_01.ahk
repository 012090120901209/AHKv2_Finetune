#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinClose Examples - Part 1: Close Gracefully
 * ============================================================================
 * 
 * Demonstrates graceful window closing techniques.
 * Handles confirmation, saving, and proper shutdown.
 * 
 * @description Graceful window closing examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Close Active Window with Confirmation
; ============================================================================

/**
 * Closes active window with user confirmation
 * 
 * @hotkey F1 - Close with confirmation
 */
F1:: {
    CloseWithConfirmation()
}

CloseWithConfirmation() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    title := WinGetTitle("A")

    result := MsgBox("Close window?`n`n" title, "Confirm Close", 4)

    if result = "Yes" {
        WinClose("A")
        ToolTip("Window closed")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 2: Close All Windows of an Application
; ============================================================================

/**
 * Closes all windows of a specific application
 * 
 * @hotkey F2 - Close all of app
 */
F2:: {
    CloseAllOfApp()
}

CloseAllOfApp() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    process := WinGetProcessName("A")

    result := MsgBox("Close ALL windows of " process "?", "Confirm", 4)

    if result = "Yes" {
        windows := WinGetList("ahk_exe " process)
        count := windows.Length

        for hwnd in windows {
            try {
                WinClose(hwnd)
            }
        }

        MsgBox("Closed " count " window(s) of " process, "Success", 64)
    }
}

; ============================================================================
; Example 3: Close Window After Delay
; ============================================================================

/**
 * Closes window after specified delay
 * 
 * @hotkey F3 - Close with timer
 */
F3:: {
    CloseWithDelay()
}

CloseWithDelay() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    result := InputBox("Seconds until close:", "Delayed Close", "w250 h130", "10")

    if result.Result != "OK" || !IsNumber(result.Value) {
        return
    }

    hwnd := WinGetID("A")
    title := WinGetTitle(hwnd)
    seconds := Integer(result.Value)

    global remainingSecs := seconds

    ToolTip("Window will close in " seconds " seconds...")

    SetTimer(Countdown, 1000)

    Countdown() {
        if remainingSecs <= 0 {
            SetTimer(Countdown, 0)
            try {
                WinClose(hwnd)
                ToolTip("Window closed")
                SetTimer(() => ToolTip(), -2000)
            }
            return
        }

        ToolTip("Closing '" title "' in " remainingSecs " second(s)...")
        remainingSecs--
    }
}

; ============================================================================
; Example 4: Smart Close (Handle Unsaved Changes)
; ============================================================================

/**
 * Intelligently closes window, handling unsaved changes
 * 
 * @hotkey F4 - Smart close
 */
F4:: {
    SmartClose()
}

SmartClose() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    title := WinGetTitle("A")

    ; Check if title indicates unsaved changes
    if InStr(title, "*") || InStr(title, "unsaved") {
        result := MsgBox("This window may have unsaved changes.`n`nClose anyway?", "Warning", 52)

        if result = "No" {
            return
        }
    }

    WinClose("A")
    ToolTip("Window closed")
    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 5: Close All Except Active
; ============================================================================

/**
 * Closes all windows except the active one
 * 
 * @hotkey F5 - Close all except active
 */
F5:: {
    CloseAllExceptActive()
}

CloseAllExceptActive() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    activeHwnd := WinGetID("A")

    result := MsgBox("Close all windows EXCEPT the active one?", "Confirm", 4)

    if result != "Yes" {
        return
    }

    allWindows := WinGetList()
    closed := 0

    for hwnd in allWindows {
        if hwnd != activeHwnd {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    WinClose(hwnd)
                    closed++
                }
            }
        }
    }

    MsgBox("Closed " closed " window(s).", "Success", 64)
}

; ============================================================================
; Example 6: Close Windows by Age
; ============================================================================

/**
 * Closes windows that have been open for specified time
 * 
 * @hotkey F6 - Close old windows
 */
F6:: {
    ; This is a simplified version
    ; Real implementation would track window creation times
    MsgBox("This feature would close windows open longer than X minutes.", "Info", 64)
}

; ============================================================================
; Example 7: Close Empty/Blank Windows
; ============================================================================

/**
 * Closes windows with no title (blank windows)
 * 
 * @hotkey F7 - Close blank windows
 */
F7:: {
    CloseBlankWindows()
}

CloseBlankWindows() {
    allWindows := WinGetList()
    closed := 0

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title = "" || Trim(title) = "" {
                WinClose(hwnd)
                closed++
            }
        }
    }

    MsgBox("Closed " closed " blank window(s).", "Success", 64)
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinClose Examples - Part 1 (Close Gracefully)
    ==============================================

    Hotkeys:
    F1 - Close with confirmation
    F2 - Close all windows of application
    F3 - Close with timer/delay
    F4 - Smart close (handle unsaved)
    F5 - Close all except active
    F6 - Close old windows
    F7 - Close blank/empty windows
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
