#Requires AutoHotkey v2.0

/**
* ============================================================================
* WinActivate Examples - Part 1: Activate by Title
* ============================================================================
*
* This script demonstrates how to use WinActivate to bring windows to the
* foreground by their window title. WinActivate is one of the most commonly
* used window management functions in AutoHotkey.
*
* @description Comprehensive examples of activating windows using title matching
* @author AutoHotkey Community
* @version 2.0.0
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Basic Window Activation by Exact Title
; ============================================================================

/**
* Activates a window with an exact title match
*
* @hotkey F1 - Activate Notepad window
* @example WinActivate("Untitled - Notepad")
*/
F1:: {
    try {
        ; Activate Notepad with exact title
        if WinExist("Untitled - Notepad") {
            WinActivate("Untitled - Notepad")
            MsgBox("Notepad activated successfully!", "Success", 64)
        } else {
            MsgBox("Notepad window not found. Please open Notepad first.", "Error", 16)
        }
    } catch Error as err {
        MsgBox("Error activating window: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Partial Title Matching
; ============================================================================

/**
* Activates windows using partial title matching
* This is useful when the full title is dynamic or unknown
*
* @hotkey F2 - Activate any Chrome window
* @example WinActivate("ahk_exe chrome.exe")
*/
F2:: {
    try {
        ; Activate any window with "Chrome" in the title
        if WinExist("ahk_exe chrome.exe") {
            WinActivate()  ; Activate the window found by WinExist
            ToolTip("Chrome window activated")
            SetTimer(() => ToolTip(), -2000)  ; Hide tooltip after 2 seconds
        } else {
            MsgBox("No Chrome window found.", "Info", 64)
        }
    }
}

; ============================================================================
; Example 3: Cycling Through Multiple Windows with Same Title
; ============================================================================

/**
* Cycles through multiple windows that match the same title pattern
* Useful for navigating between multiple instances of the same application
*
* @hotkey F3 - Cycle through Notepad windows
*/
F3:: {
    static lastActivated := ""

    try {
        ; Get all windows matching the criteria
        if WinExist("ahk_exe notepad.exe") {
            currentWindow := WinGetID()

            ; If we're already on a matching window, activate the next one
            if (lastActivated = currentWindow) {
                ; Activate next matching window
                if WinExist("ahk_exe notepad.exe") {
                    ; Move to next window in the list
                    Send("!{Esc}")  ; Alt+Escape to cycle
                    Sleep(100)
                    lastActivated := WinGetID("A")
                }
            } else {
                WinActivate()
                lastActivated := WinGetID("A")
            }

            ; Show which window is now active
            title := WinGetTitle("A")
            ToolTip("Active: " title)
            SetTimer(() => ToolTip(), -2000)
        } else {
            MsgBox("No Notepad windows found.", "Info", 64)
            lastActivated := ""
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 4: Smart Window Activator with Fallback
; ============================================================================

/**
* Attempts to activate a window, and if it doesn't exist, launches the application
* This is a common pattern for productivity scripts
*
* @hotkey F4 - Activate or launch Calculator
*/
F4:: {
    try {
        ; Try to activate existing Calculator window
        if WinExist("Calculator ahk_exe ApplicationFrameHost.exe") {
            WinActivate()
            ToolTip("Calculator activated")
            SetTimer(() => ToolTip(), -1500)
        }
        ; If Calculator isn't running, launch it
        else {
            Run("calc.exe")
            ToolTip("Launching Calculator...")
            SetTimer(() => ToolTip(), -2000)

            ; Wait for the window to appear and activate it
            if WinWait("Calculator ahk_exe ApplicationFrameHost.exe", , 5) {
                WinActivate()
            } else {
                MsgBox("Calculator failed to launch within timeout.", "Error", 16)
            }
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 5: Activate Window by Title with RegEx Pattern
; ============================================================================

/**
* Uses regular expressions for advanced title matching
* Useful when dealing with dynamic window titles
*
* @hotkey F5 - Activate window with pattern matching
*/
F5:: {
    try {
        ; Find windows with titles containing numbers (like "Document 1 - Word")
        SetTitleMatchMode("RegEx")

        pattern := ".*\d+.*Notepad.*"  ; Match titles with numbers and "Notepad"

        if WinExist(pattern) {
            WinActivate()
            title := WinGetTitle("A")
            MsgBox("Activated window: " title, "Success", 64)
        } else {
            MsgBox("No window found matching pattern: " pattern, "Info", 64)
        }

        ; Reset to default matching mode
        SetTitleMatchMode(1)
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 6: Window Switcher with GUI Selection
; ============================================================================

/**
* Creates a GUI list of windows and activates the selected one
* Demonstrates integration of WinActivate with GUI controls
*
* @hotkey F6 - Show window switcher GUI
*/
F6:: {
    ShowWindowSwitcher()
}

/**
* Creates and displays a window switcher GUI
*/
ShowWindowSwitcher() {
    static windowSwitcherGui := ""

    ; Close existing GUI if open
    if windowSwitcherGui {
        try windowSwitcherGui.Destroy()
    }

    ; Create new GUI
    windowSwitcherGui := Gui("+AlwaysOnTop", "Window Switcher")
    windowSwitcherGui.SetFont("s10", "Segoe UI")

    ; Add instructions
    windowSwitcherGui.Add("Text", "w400", "Select a window to activate:")

    ; Create list box for windows
    windowList := windowSwitcherGui.Add("ListBox", "w400 h300 vSelectedWindow")

    ; Collect all visible windows
    windows := Map()
    windowTitles := []

    ; Enumerate all windows
    allWindows := WinGetList()
    for hwnd in allWindows {
        try {
            ; Only include visible windows with titles
            if WinGetTitle(hwnd) != "" && WinGetStyle(hwnd) & 0x10000000 {  ; WS_VISIBLE
            title := WinGetTitle(hwnd)
            exe := WinGetProcessName(hwnd)
            displayText := title " [" exe "]"
            windows[displayText] := hwnd
            windowTitles.Push(displayText)
        }
    }
}

; Populate list box
if windowTitles.Length > 0 {
    windowList.Add(windowTitles)
    windowList.Choose(1)
} else {
    windowList.Add(["No windows found"])
}

; Add buttons
windowSwitcherGui.Add("Button", "w195 Default", "Activate").OnEvent("Click", ActivateSelectedWindow)
windowSwitcherGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => windowSwitcherGui.Destroy())

; Show GUI centered
windowSwitcherGui.Show()

/**
* Activates the window selected in the list
*/
ActivateSelectedWindow(*) {
    try {
        selected := windowList.Text
        if windows.Has(selected) {
            hwnd := windows[selected]
            WinActivate(hwnd)
            windowSwitcherGui.Destroy()
            ToolTip("Activated: " selected)
            SetTimer(() => ToolTip(), -2000)
        }
    } catch Error as err {
        MsgBox("Error activating window: " err.Message, "Error", 16)
    }
}
}

; ============================================================================
; Example 7: Multi-Monitor Window Activation Helper
; ============================================================================

/**
* Activates windows on specific monitors
* Useful for multi-monitor setups where you want to focus on a particular screen
*
* @hotkey F7 - Activate window on primary monitor
*/
F7:: {
    ActivateWindowOnMonitor(1)
}

/**
* Activates the topmost window on a specific monitor
*
* @param {Integer} monitorNum - Monitor number (1-based)
*/
ActivateWindowOnMonitor(monitorNum) {
    try {
        ; Get monitor bounds
        MonitorGet(monitorNum, &left, &top, &right, &bottom)
        centerX := (left + right) // 2
        centerY := (top + bottom) // 2

        ; Find window at monitor center
        hwnd := DllCall("WindowFromPoint", "Int64", centerX | (centerY << 32), "Ptr")

        if hwnd {
            ; Get the root window (not a child control)
            while (parent := DllCall("GetParent", "Ptr", hwnd, "Ptr")) {
                hwnd := parent
            }

            WinActivate(hwnd)
            title := WinGetTitle(hwnd)
            MsgBox("Activated window on monitor " monitorNum ": " title, "Success", 64)
        } else {
            MsgBox("No window found on monitor " monitorNum, "Info", 64)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Gets the monitor number where a window is primarily located
*
* @param {String|Integer} winTitle - Window title or HWND
* @returns {Integer} Monitor number (1-based)
*/
GetWindowMonitor(winTitle := "A") {
    try {
        WinGetPos(&x, &y, &width, &height, winTitle)
        centerX := x + (width // 2)
        centerY := y + (height // 2)

        monitorCount := MonitorGetCount()
        Loop monitorCount {
            MonitorGet(A_Index, &left, &top, &right, &bottom)
            if (centerX >= left && centerX <= right && centerY >= top && centerY <= bottom) {
                return A_Index
            }
        }
        return 1  ; Default to primary monitor
    } catch {
        return 1
    }
}

; ============================================================================
; Cleanup and Exit
; ============================================================================

; Press Escape to exit the script
Esc::ExitApp()

/**
* Script information display
*/
^F1:: {
    info := "
    (
    WinActivate Examples - Part 1
    ==============================

    Hotkeys:
    F1  - Activate Notepad by exact title
    F2  - Activate Chrome using process name
    F3  - Cycle through Notepad windows
    F4  - Activate or launch Calculator
    F5  - Activate window using RegEx pattern
    F6  - Show window switcher GUI
    F7  - Activate window on primary monitor
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(info, "WinActivate Examples - Help", 64)
}
