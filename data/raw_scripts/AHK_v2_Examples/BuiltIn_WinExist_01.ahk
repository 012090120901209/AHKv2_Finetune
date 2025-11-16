#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinExist Examples - Part 1: Check Window Existence
 * ============================================================================
 *
 * This script demonstrates how to use WinExist to check if windows exist.
 * WinExist is essential for conditional window operations and error prevention.
 *
 * @description Comprehensive examples of checking window existence
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Basic Window Existence Check
; ============================================================================

/**
 * Checks if a window exists before performing operations
 * This prevents errors when trying to interact with non-existent windows
 *
 * @hotkey F1 - Check if Notepad exists
 */
F1:: {
    try {
        if WinExist("ahk_class Notepad") {
            hwnd := WinExist()  ; Gets the HWND from the last WinExist call
            title := WinGetTitle(hwnd)
            MsgBox("Notepad window found!`nHWND: " hwnd "`nTitle: " title, "Window Exists", 64)
        } else {
            result := MsgBox("Notepad window not found. Would you like to launch it?",
                           "Window Not Found", 4)
            if result = "Yes" {
                Run("notepad.exe")
            }
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Check Multiple Windows
; ============================================================================

/**
 * Checks for multiple windows and reports their status
 * Useful for verifying application state
 *
 * @hotkey F2 - Check multiple applications
 */
F2:: {
    CheckMultipleWindows()
}

/**
 * Checks existence of multiple common applications
 */
CheckMultipleWindows() {
    applications := Map(
        "Notepad", "ahk_class Notepad",
        "Calculator", "ahk_exe ApplicationFrameHost.exe Calculator",
        "File Explorer", "ahk_class CabinetWClass",
        "Chrome", "ahk_exe chrome.exe",
        "Visual Studio Code", "ahk_exe Code.exe"
    )

    results := ""
    foundCount := 0
    notFoundCount := 0

    for appName, criteria in applications {
        if WinExist(criteria) {
            count := WinGetCount(criteria)
            results .= "[✓] " appName ": " count " window(s)`n"
            foundCount++
        } else {
            results .= "[✗] " appName ": Not running`n"
            notFoundCount++
        }
    }

    summary := "Window Status Report`n"
    summary .= "=" . StrRepeat("=", 40) . "`n"
    summary .= results
    summary .= "`nSummary: " foundCount " running, " notFoundCount " not running"

    MsgBox(summary, "Application Status", 64)
}

/**
 * Helper function to repeat a string
 */
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 3: Conditional Window Operations
; ============================================================================

/**
 * Performs different actions based on window existence
 * Demonstrates practical use of WinExist in conditional logic
 *
 * @hotkey F3 - Smart window operation
 */
F3:: {
    SmartWindowOperation()
}

/**
 * Performs context-aware window operations
 */
SmartWindowOperation() {
    try {
        ; Check if Notepad exists
        if WinExist("ahk_class Notepad") {
            ; Check if it's already active
            if WinActive("ahk_class Notepad") {
                MsgBox("Notepad is already active. Sending text...", "Info", 64)
                Send("This text was sent because Notepad was active!")
            } else {
                MsgBox("Notepad exists but isn't active. Activating now...", "Info", 64)
                WinActivate()
            }
        } else {
            MsgBox("Notepad doesn't exist. Launching and sending text...", "Info", 64)
            Run("notepad.exe")
            WinWait("ahk_class Notepad", , 5)
            WinActivate()
            Sleep(500)
            Send("Notepad was launched and this text was sent!")
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 4: Window Existence Monitor
; ============================================================================

/**
 * Monitors window existence in real-time
 * Shows how to track window state changes
 *
 * @hotkey F4 - Start window monitor
 */
F4:: {
    static monitoring := false
    static monitorTimer := 0

    if !monitoring {
        monitoring := true
        ShowMonitorGUI()
    } else {
        monitoring := false
        if monitorTimer {
            SetTimer(monitorTimer, 0)
        }
        MsgBox("Monitoring stopped.", "Monitor", 64)
    }
}

/**
 * Creates a real-time window monitoring GUI
 */
ShowMonitorGUI() {
    static monitorGui := ""
    static statusText := ""
    static lastStates := Map()

    if monitorGui {
        try monitorGui.Destroy()
    }

    monitorGui := Gui("+AlwaysOnTop", "Window Existence Monitor")
    monitorGui.SetFont("s9", "Consolas")

    monitorGui.Add("Text", "w500", "Monitoring window existence (updates every second):")
    statusText := monitorGui.Add("Edit", "w500 h300 ReadOnly vStatus")

    monitorGui.Add("Button", "w240 Default", "Stop Monitoring").OnEvent("Click", StopMonitor)
    monitorGui.Add("Button", "w240 x+20 yp", "Clear Log").OnEvent("Click", ClearLog)

    monitorGui.Show()

    ; Start monitoring timer
    SetTimer(UpdateMonitor, 1000)

    UpdateMonitor() {
        watchList := Map(
            "Notepad", "ahk_class Notepad",
            "Calculator", "ahk_exe ApplicationFrameHost.exe",
            "Chrome", "ahk_exe chrome.exe"
        )

        output := "Last Updated: " A_Now "`n`n"

        for appName, criteria in watchList {
            exists := WinExist(criteria) ? true : false
            currentState := exists ? "EXISTS" : "NOT FOUND"

            ; Check for state changes
            if lastStates.Has(appName) && lastStates[appName] != exists {
                stateChange := exists ? "APPEARED" : "DISAPPEARED"
                output .= "[" A_Hour ":" A_Min ":" A_Sec "] " appName " " stateChange "`n"
            }

            output .= appName ": " currentState

            if exists {
                count := WinGetCount(criteria)
                output .= " (" count " window" (count > 1 ? "s" : "") ")"
            }

            output .= "`n"
            lastStates[appName] := exists
        }

        statusText.Value := output
    }

    StopMonitor(*) {
        SetTimer(UpdateMonitor, 0)
        monitorGui.Destroy()
    }

    ClearLog(*) {
        lastStates := Map()
    }
}

; ============================================================================
; Example 5: Window Existence with Timeout
; ============================================================================

/**
 * Checks for window existence with a timeout mechanism
 * Useful for waiting for windows to appear with a time limit
 *
 * @hotkey F5 - Check with timeout
 */
F5:: {
    CheckWindowWithTimeout()
}

/**
 * Waits for a window to exist with timeout
 */
CheckWindowWithTimeout() {
    static checkGui := ""

    if checkGui {
        try checkGui.Destroy()
    }

    checkGui := Gui("+AlwaysOnTop", "Window Existence Checker")
    checkGui.SetFont("s10", "Segoe UI")

    checkGui.Add("Text", "w400", "Enter window title or criteria to check:")
    criteriaEdit := checkGui.Add("Edit", "w400 vCriteria", "ahk_class Notepad")

    checkGui.Add("Text", "w400", "Timeout (seconds):")
    timeoutEdit := checkGui.Add("Edit", "w400 vTimeout Number", "10")

    checkGui.Add("Button", "w195 Default", "Check Now").OnEvent("Click", CheckNow)
    checkGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => checkGui.Destroy())

    checkGui.Show()

    CheckNow(*) {
        criteria := criteriaEdit.Value
        timeoutSec := Integer(timeoutEdit.Value)

        if criteria = "" {
            MsgBox("Please enter a window criteria.", "Error", 16)
            return
        }

        checkGui.Destroy()

        ; Check immediately
        if WinExist(criteria) {
            MsgBox("Window found immediately!`nCriteria: " criteria, "Success", 64)
            return
        }

        ; Wait with timeout
        progressGui := Gui("+AlwaysOnTop +ToolWindow", "Waiting for Window")
        progressGui.Add("Text", "w300", "Waiting for window...`nCriteria: " criteria)
        progressText := progressGui.Add("Text", "w300", "Time remaining: " timeoutSec "s")
        progressGui.Add("Button", "w300", "Cancel").OnEvent("Click", (*) => progressGui.Destroy())
        progressGui.Show()

        startTime := A_TickCount
        found := false

        while ((A_TickCount - startTime) < (timeoutSec * 1000)) {
            if WinExist(criteria) {
                found := true
                break
            }

            elapsed := (A_TickCount - startTime) // 1000
            remaining := timeoutSec - elapsed
            progressText.Value := "Time remaining: " remaining "s"

            Sleep(100)
        }

        progressGui.Destroy()

        if found {
            MsgBox("Window found!`nCriteria: " criteria, "Success", 64)
        } else {
            MsgBox("Window not found within " timeoutSec " seconds.`nCriteria: " criteria, "Timeout", 48)
        }
    }
}

; ============================================================================
; Example 6: Advanced Existence Checking with Details
; ============================================================================

/**
 * Checks window existence and retrieves detailed information
 * Demonstrates comprehensive window analysis
 *
 * @hotkey F6 - Detailed window check
 */
F6:: {
    DetailedWindowCheck()
}

/**
 * Performs detailed analysis of window existence
 */
DetailedWindowCheck() {
    static detailGui := ""

    if detailGui {
        try detailGui.Destroy()
    }

    detailGui := Gui("+AlwaysOnTop", "Detailed Window Check")
    detailGui.SetFont("s10", "Segoe UI")

    detailGui.Add("Text", "w400", "Enter window criteria:")
    criteriaEdit := detailGui.Add("Edit", "w400 vCriteria", "ahk_class Notepad")

    detailGui.Add("Button", "w195 Default", "Analyze").OnEvent("Click", Analyze)
    detailGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => detailGui.Destroy())

    detailGui.Show()

    Analyze(*) {
        criteria := criteriaEdit.Value

        if criteria = "" {
            MsgBox("Please enter a window criteria.", "Error", 16)
            return
        }

        if !WinExist(criteria) {
            MsgBox("No window found matching criteria:`n" criteria, "Not Found", 48)
            return
        }

        ; Get detailed information
        hwnd := WinExist()
        title := WinGetTitle(hwnd)
        class := WinGetClass(hwnd)
        process := WinGetProcessName(hwnd)
        pid := WinGetPID(hwnd)
        WinGetPos(&x, &y, &width, &height, hwnd)
        minMax := WinGetMinMax(hwnd)
        isActive := WinActive(hwnd) ? "Yes" : "No"
        count := WinGetCount(criteria)

        minMaxText := (minMax = 1 ? "Maximized" : (minMax = -1 ? "Minimized" : "Normal"))

        info := "
        (
        Window Details
        ===============================================

        Existence: CONFIRMED
        Total Matching Windows: " count "

        Window Information:
        - Title: " title "
        - Class: " class "
        - HWND: " Format("0x{:X}", hwnd) "

        Process Information:
        - Process: " process "
        - PID: " pid "

        Position & Size:
        - X: " x " px
        - Y: " y " px
        - Width: " width " px
        - Height: " height " px
        - State: " minMaxText "

        Status:
        - Is Active: " isActive "
        )"

        MsgBox(info, "Window Analysis Complete", 64)
        detailGui.Destroy()
    }
}

; ============================================================================
; Example 7: Pattern Matching Existence Checker
; ============================================================================

/**
 * Uses various matching modes to check window existence
 * Demonstrates different ways to match windows
 *
 * @hotkey F7 - Pattern matching checker
 */
F7:: {
    PatternMatchingChecker()
}

/**
 * Creates GUI for testing different matching patterns
 */
PatternMatchingChecker() {
    static patternGui := ""

    if patternGui {
        try patternGui.Destroy()
    }

    patternGui := Gui("+AlwaysOnTop", "Pattern Matching Checker")
    patternGui.SetFont("s10", "Segoe UI")

    patternGui.Add("Text", "w400", "Window Title Pattern:")
    patternEdit := patternGui.Add("Edit", "w400 vPattern", "Notepad")

    patternGui.Add("Text", "w400", "Match Mode:")
    matchMode := patternGui.Add("DropDownList", "w400 vMatchMode Choose1",
        ["1 - Starts with", "2 - Contains (anywhere)", "3 - Exact match", "RegEx"])

    patternGui.Add("Text", "w400", "Case Sensitive:")
    caseSensitive := patternGui.Add("CheckBox", "vCaseSensitive", "Enabled")

    patternGui.Add("Button", "w195 Default", "Test Pattern").OnEvent("Click", TestPattern)
    patternGui.Add("Button", "w195 x+10 yp", "Close").OnEvent("Click", (*) => patternGui.Destroy())

    patternGui.Show()

    TestPattern(*) {
        pattern := patternEdit.Value
        mode := matchMode.Value
        caseSens := caseSensitive.Value

        ; Set match mode
        if mode = 4 {  ; RegEx
            SetTitleMatchMode("RegEx")
        } else {
            SetTitleMatchMode(mode)
        }

        ; Set case sensitivity
        SetTitleMatchMode(caseSens ? "On" : "Off")

        ; Test pattern
        if WinExist(pattern) {
            count := WinGetCount(pattern)
            matchingWindows := ""

            allMatches := WinGetList(pattern)
            for hwnd in allMatches {
                matchingWindows .= WinGetTitle(hwnd) "`n"
            }

            MsgBox("Pattern matched " count " window(s):`n`n" matchingWindows,
                 "Pattern Match Success", 64)
        } else {
            MsgBox("No windows match the pattern:`n" pattern,
                 "No Match", 48)
        }

        ; Reset to defaults
        SetTitleMatchMode(1)
        SetTitleMatchMode("Off")
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinExist Examples - Part 1
    ==========================

    Hotkeys:
    F1 - Check if Notepad exists
    F2 - Check multiple applications
    F3 - Smart window operation
    F4 - Start/stop window monitor
    F5 - Check window with timeout
    F6 - Detailed window check
    F7 - Pattern matching checker
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
