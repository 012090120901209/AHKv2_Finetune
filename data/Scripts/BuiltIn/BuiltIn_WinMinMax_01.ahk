#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * WinMinMax Examples: Minimize, Maximize, and Restore
 * ============================================================================
 * 
 * Demonstrates window state management: minimize, maximize, and restore.
 * Essential for window organization and workflow optimization.
 * 
 * @description Window minimize/maximize/restore examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Basic Minimize/Maximize/Restore
; ============================================================================

/**
 * Cycles through window states
 * 
 * @hotkey F1 - Cycle window state
 */
F1:: {
    CycleWindowState()
}

CycleWindowState() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    state := WinGetMinMax("A")

    switch state {
        case 0:  ; Normal - maximize it
            WinMaximize("A")
            ToolTip("Window maximized")
        case 1:  ; Maximized - restore it
            WinRestore("A")
            ToolTip("Window restored")
        case -1:  ; Minimized - restore it
            WinRestore("A")
            ToolTip("Window restored from minimized")
    }

    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 2: Minimize All Except Active
; ============================================================================

/**
 * Minimizes all windows except the active one
 * 
 * @hotkey F2 - Minimize all except active
 */
F2:: {
    MinimizeAllExceptActive()
}

MinimizeAllExceptActive() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    activeHwnd := WinGetID("A")
    allWindows := WinGetList()
    minimized := 0

    for hwnd in allWindows {
        if hwnd != activeHwnd {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    WinMinimize(hwnd)
                    minimized++
                }
            }
        }
    }

    MsgBox("Minimized " minimized " window(s).", "Success", 64)
}

; ============================================================================
; Example 3: Restore All Minimized Windows
; ============================================================================

/**
 * Restores all minimized windows
 * 
 * @hotkey F3 - Restore all minimized
 */
F3:: {
    RestoreAllMinimized()
}

RestoreAllMinimized() {
    allWindows := WinGetList()
    restored := 0

    for hwnd in allWindows {
        try {
            if WinGetMinMax(hwnd) = -1 {  ; Minimized
                WinRestore(hwnd)
                restored++
            }
        }
    }

    MsgBox("Restored " restored " minimized window(s).", "Success", 64)
}

; ============================================================================
; Example 4: Maximize to Specific Monitor
; ============================================================================

/**
 * Maximizes window to specific monitor
 * 
 * @hotkey F4 - Maximize to monitor
 */
F4:: {
    MaximizeToMonitor()
}

MaximizeToMonitor() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    monCount := MonitorGetCount()

    if monCount < 2 {
        WinMaximize("A")
        return
    }

    result := InputBox("Enter monitor number (1-" monCount "):", "Maximize to Monitor", "w300 h130", "1")

    if result.Result != "OK" || !IsNumber(result.Value) {
        return
    }

    monNum := Integer(result.Value)

    if monNum < 1 || monNum > monCount {
        MsgBox("Invalid monitor number.", "Error", 16)
        return
    }

    ; Get monitor work area
    MonitorGetWorkArea(monNum, &left, &top, &right, &bottom)

    ; Move and maximize
    WinRestore("A")  ; Restore first
    WinMove(left, top, right - left, bottom - top, "A")

    MsgBox("Window maximized to monitor " monNum ".", "Success", 64)
}

; ============================================================================
; Example 5: Smart Restore
; ============================================================================

/**
 * Smart restore - activates and restores if minimized
 * 
 * @hotkey F5 - Smart restore Notepad
 */
F5:: {
    SmartRestore("ahk_class Notepad", "Notepad")
}

SmartRestore(criteria, appName) {
    if !WinExist(criteria) {
        MsgBox(appName " is not running.", "Info", 64)
        return
    }

    state := WinGetMinMax(criteria)

    if state = -1 {  ; Minimized
        WinRestore(criteria)
    }

    WinActivate(criteria)

    ToolTip(appName " activated")
    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 6: Batch Window State Manager
; ============================================================================

/**
 * Manages state of multiple windows
 * 
 * @hotkey F6 - Batch state manager
 */
F6:: {
    BatchStateManager()
}

BatchStateManager() {
    static stateGui := ""

    if stateGui {
        try stateGui.Destroy()
    }

    stateGui := Gui("+AlwaysOnTop", "Batch State Manager")
    stateGui.SetFont("s10", "Segoe UI")

    stateGui.Add("Text", "w450", "Select windows:")

    lv := stateGui.Add("ListView", "w450 h250 Checked vWinList", ["Title", "State"])

    windows := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                state := WinGetMinMax(hwnd)
                stateText := (state = 1 ? "Maximized" : (state = -1 ? "Minimized" : "Normal"))
                lv.Add("", title, stateText)
                windows.Push(hwnd)
            }
        }
    }

    lv.ModifyCol(1, 300)
    lv.ModifyCol(2, "AutoHdr")

    stateGui.Add("Button", "w140", "Minimize Selected").OnEvent("Click", (*) => ChangeState("min"))
    stateGui.Add("Button", "w140 x+10 yp", "Maximize Selected").OnEvent("Click", (*) => ChangeState("max"))
    stateGui.Add("Button", "w140 x+10 yp", "Restore Selected").OnEvent("Click", (*) => ChangeState("restore"))

    stateGui.Add("Button", "w450 xm", "Close").OnEvent("Click", (*) => stateGui.Destroy())

    stateGui.Show()

    ChangeState(action) {
        count := 0

        Loop lv.GetCount() {
            if lv.GetNext(A_Index - 1, "Checked") = A_Index {
                try {
                    switch action {
                        case "min": WinMinimize(windows[A_Index])
                        case "max": WinMaximize(windows[A_Index])
                        case "restore": WinRestore(windows[A_Index])
                    }
                    count++
                }
            }
        }

        MsgBox("Applied state change to " count " window(s).", "Success", 64)
        stateGui.Destroy()
    }
}

; ============================================================================
; Example 7: Window State Monitor
; ============================================================================

/**
 * Monitors and logs window state changes
 * 
 * @hotkey F7 - State monitor
 */
F7:: {
    static monitoring := false

    if !monitoring {
        monitoring := true
        StartStateMonitor()
    } else {
        monitoring := false
    }
}

StartStateMonitor() {
    static monGui := ""
    static lastStates := Map()

    if monGui {
        try monGui.Destroy()
    }

    monGui := Gui("+AlwaysOnTop", "Window State Monitor")
    monGui.SetFont("s9", "Consolas")

    monGui.Add("Text", "w500", "Monitoring window state changes:")

    logEdit := monGui.Add("Edit", "w500 h300 ReadOnly vLog")

    monGui.Add("Button", "w240 Default", "Stop Monitor").OnEvent("Click", StopMon)
    monGui.Add("Button", "w240 x+20 yp", "Clear Log").OnEvent("Click", ClearLog)

    monGui.Show()

    LogEvent("Monitor started at " A_Hour ":" A_Min ":" A_Sec)

    SetTimer(CheckStates, 1000)

    CheckStates() {
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    state := WinGetMinMax(hwnd)
                    hwndKey := Format("0x{:X}", hwnd)

                    if lastStates.Has(hwndKey) {
                        if lastStates[hwndKey] != state {
                            stateText := (state = 1 ? "MAXIMIZED" : (state = -1 ? "MINIMIZED" : "RESTORED"))
                            LogEvent("[" hwndKey "] " title " -> " stateText)
                            lastStates[hwndKey] := state
                        }
                    } else {
                        lastStates[hwndKey] := state
                    }
                }
            }
        }
    }

    LogEvent(message) {
        timestamp := A_Hour ":" A_Min ":" A_Sec
        logEdit.Value := "[" timestamp "] " message "`n" logEdit.Value
    }

    StopMon(*) {
        SetTimer(CheckStates, 0)
        monGui.Destroy()
    }

    ClearLog(*) {
        logEdit.Value := ""
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinMinMax Examples
    ==================

    Hotkeys:
    F1 - Cycle window state (normal/max/min)
    F2 - Minimize all except active
    F3 - Restore all minimized windows
    F4 - Maximize to specific monitor
    F5 - Smart restore Notepad
    F6 - Batch state manager
    F7 - Start/stop state monitor
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
