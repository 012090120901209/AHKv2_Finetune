#Requires AutoHotkey v2.0

/**
* ============================================================================
* WinGetTitle Examples - Part 1: Get Window Title
* ============================================================================
*
* This script demonstrates how to retrieve window titles using WinGetTitle.
* Window titles are essential for identification, logging, and display purposes.
*
* @description Comprehensive examples of retrieving window titles
* @author AutoHotkey Community
* @version 2.0.0
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Get Active Window Title
; ============================================================================

/**
* Retrieves and displays the title of the currently active window
* Most basic use case for WinGetTitle
*
* @hotkey F1 - Get active window title
*/
F1:: {
    try {
        title := WinGetTitle("A")

        if title != "" {
            MsgBox("Active Window Title:`n`n" title, "Window Title", 64)
        } else {
            MsgBox("No active window or window has no title.", "No Title", 48)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Get Title of Window Under Mouse
; ============================================================================

/**
* Gets the title of the window currently under the mouse cursor
* Useful for window inspection and debugging
*
* @hotkey F2 - Get window title under mouse
*/
F2:: {
    try {
        ; Get window under mouse
        MouseGetPos(, , &hwnd)

        if hwnd {
            title := WinGetTitle(hwnd)
            class := WinGetClass(hwnd)
            process := WinGetProcessName(hwnd)

            info := "Window Under Mouse`n"
            info .= StrRepeat("=", 40) . "`n`n"
            info .= "Title: " (title != "" ? title : "(no title)") "`n"
            info .= "Class: " class "`n"
            info .= "Process: " process "`n"
            info .= "HWND: " Format("0x{:X}", hwnd)

            MsgBox(info, "Window Information", 64)
        } else {
            MsgBox("No window found under mouse cursor.", "Error", 16)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

/**
* Helper to repeat strings
*/
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 3: Title Clipboard Tool
; ============================================================================

/**
* Copies window titles to clipboard for easy sharing
* Useful for documentation and bug reports
*
* @hotkey F3 - Copy window title to clipboard
*/
F3:: {
    ShowTitleClipboardTool()
}

/**
* Creates GUI for copying window titles
*/
ShowTitleClipboardTool() {
    static toolGui := ""

    if toolGui {
        try toolGui.Destroy()
    }

    toolGui := Gui("+AlwaysOnTop", "Title Clipboard Tool")
    toolGui.SetFont("s10", "Segoe UI")

    toolGui.Add("Text", "w500", "Select window to copy title:")

    ; List all windows with titles
    windowList := toolGui.Add("ListBox", "w500 h250 vSelectedWindow")

    windows := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                process := WinGetProcessName(hwnd)
                display := title " [" process "]"
                windows.Push({hwnd: hwnd, title: title, display: display})
                windowList.Add([display])
            }
        }
    }

    if windows.Length > 0 {
        windowList.Choose(1)
    }

    toolGui.Add("Button", "w160 Default", "Copy Title").OnEvent("Click", CopyTitle)
    toolGui.Add("Button", "w160 x+10 yp", "Copy All Info").OnEvent("Click", CopyAll)
    toolGui.Add("Button", "w160 x+10 yp", "Close").OnEvent("Click", (*) => toolGui.Destroy())

    toolGui.Show()

    CopyTitle(*) {
        selectedIdx := windowList.Value
        if selectedIdx > 0 && selectedIdx <= windows.Length {
            A_Clipboard := windows[selectedIdx].title
            ToolTip("Title copied to clipboard!")
            SetTimer(() => ToolTip(), -1500)
        }
    }

    CopyAll(*) {
        selectedIdx := windowList.Value
        if selectedIdx > 0 && selectedIdx <= windows.Length {
            win := windows[selectedIdx]
            hwnd := win.hwnd

            class := WinGetClass(hwnd)
            process := WinGetProcessName(hwnd)
            pid := WinGetPID(hwnd)

            allInfo := "Title: " win.title "`n"
            allInfo .= "Class: " class "`n"
            allInfo .= "Process: " process "`n"
            allInfo .= "PID: " pid "`n"
            allInfo .= "HWND: " Format("0x{:X}", hwnd)

            A_Clipboard := allInfo
            ToolTip("All information copied to clipboard!")
            SetTimer(() => ToolTip(), -1500)
        }
    }
}

; ============================================================================
; Example 4: Window Title Logger
; ============================================================================

/**
* Logs window titles over time
* Useful for tracking window usage and activity
*
* @hotkey F4 - Start/stop title logger
*/
F4:: {
    static logging := false
    static logTimer := 0

    if !logging {
        logging := true
        StartTitleLogger()
    } else {
        logging := false
        if logTimer {
            SetTimer(logTimer, 0)
        }
        MsgBox("Title logging stopped.", "Logger", 64)
    }
}

/**
* Creates a title logging GUI
*/
StartTitleLogger() {
    static logGui := ""
    static logEdit := ""
    static lastTitle := ""

    if logGui {
        try logGui.Destroy()
    }

    logGui := Gui("+AlwaysOnTop +Resize", "Window Title Logger")
    logGui.SetFont("s9", "Consolas")

    logGui.Add("Text", "w600", "Logging active window titles (logs when title changes):")
    logEdit := logGui.Add("Edit", "w600 h350 ReadOnly vLog")

    logGui.Add("Button", "w195 Default", "Stop Logging").OnEvent("Click", StopLog)
    logGui.Add("Button", "w195 x+10 yp", "Clear Log").OnEvent("Click", ClearLog)
    logGui.Add("Button", "w195 x+10 yp", "Save Log").OnEvent("Click", SaveLog)

    logGui.Show()

    LogEntry("Logger started at " A_Hour ":" A_Min ":" A_Sec)

    ; Start logging timer
    SetTimer(CheckTitle, 1000)

    CheckTitle() {
        try {
            currentTitle := WinGetTitle("A")

            if currentTitle != lastTitle && currentTitle != "" {
                timestamp := A_Hour ":" A_Min ":" A_Sec
                process := WinGetProcessName("A")

                LogEntry("[" timestamp "] " currentTitle " (" process ")")
                lastTitle := currentTitle
            }
        }
    }

    LogEntry(message) {
        logEdit.Value := message "`n" logEdit.Value
    }

    StopLog(*) {
        SetTimer(CheckTitle, 0)
        LogEntry("Logger stopped at " A_Hour ":" A_Min ":" A_Sec)
        logGui.Destroy()
    }

    ClearLog(*) {
        logEdit.Value := ""
        LogEntry("Log cleared at " A_Hour ":" A_Min ":" A_Sec)
    }

    SaveLog(*) {
        fileName := "WindowTitleLog_" A_YYYY A_MM A_DD "_" A_Hour A_Min A_Sec ".txt"
        filePath := A_Desktop "\" fileName

        try {
            FileAppend(logEdit.Value, filePath)
            MsgBox("Log saved to:`n" filePath, "Saved", 64)
        } catch Error as err {
            MsgBox("Error saving log: " err.Message, "Error", 16)
        }
    }
}

; ============================================================================
; Example 5: Title Pattern Matcher
; ============================================================================

/**
* Finds windows matching title patterns
* Demonstrates pattern matching and filtering
*
* @hotkey F5 - Find windows by title pattern
*/
F5:: {
    ShowTitleMatcher()
}

/**
* Creates GUI for pattern matching
*/
ShowTitleMatcher() {
    static matcherGui := ""

    if matcherGui {
        try matcherGui.Destroy()
    }

    matcherGui := Gui("+AlwaysOnTop", "Title Pattern Matcher")
    matcherGui.SetFont("s10", "Segoe UI")

    matcherGui.Add("Text", "w500", "Enter pattern to match in window titles:")
    patternEdit := matcherGui.Add("Edit", "w500 vPattern", "")

    matcherGui.Add("CheckBox", "vCaseSensitive", "Case sensitive")
    matcherGui.Add("CheckBox", "vRegEx", "Use Regular Expression")

    resultBox := matcherGui.Add("Edit", "w500 h200 ReadOnly vResults")

    matcherGui.Add("Button", "w160 Default", "Find Matches").OnEvent("Click", FindMatches)
    matcherGui.Add("Button", "w160 x+10 yp", "Activate First").OnEvent("Click", ActivateFirst)
    matcherGui.Add("Button", "w160 x+10 yp", "Close").OnEvent("Click", (*) => matcherGui.Destroy())

    matcherGui.Show()

    global foundMatches := []

    FindMatches(*) {
        pattern := patternEdit.Value
        submitted := matcherGui.Submit(false)
        caseSens := submitted.CaseSensitive
        useRegEx := submitted.RegEx

        if pattern = "" {
            resultBox.Value := "Please enter a pattern."
            return
        }

        foundMatches := []
        allWindows := WinGetList()
        results := "Matching Windows:`n" StrRepeat("=", 50) "`n`n"

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                matched := false

                if useRegEx {
                    matched := RegExMatch(title, pattern)
                } else {
                    searchTitle := caseSens ? title : StrLower(title)
                    searchPattern := caseSens ? pattern : StrLower(pattern)
                    matched := InStr(searchTitle, searchPattern)
                }

                if matched && title != "" {
                    process := WinGetProcessName(hwnd)
                    foundMatches.Push({hwnd: hwnd, title: title})
                    results .= title "`n[" process "]`n`n"
                }
            }
        }

        if foundMatches.Length = 0 {
            results := "No windows found matching pattern: " pattern
        } else {
            results := "Found " foundMatches.Length " matching window(s):`n`n" results
        }

        resultBox.Value := results
    }

    ActivateFirst(*) {
        if foundMatches.Length > 0 {
            WinActivate(foundMatches[1].hwnd)
            ToolTip("Activated: " foundMatches[1].title)
            SetTimer(() => ToolTip(), -2000)
        }
    }
}

; ============================================================================
; Example 6: Title Comparison Tool
; ============================================================================

/**
* Compares titles of two windows
* Useful for finding similar or duplicate windows
*
* @hotkey F6 - Compare window titles
*/
F6:: {
    CompareWindowTitles()
}

/**
* Creates tool for comparing window titles
*/
CompareWindowTitles() {
    static compareGui := ""

    if compareGui {
        try compareGui.Destroy()
    }

    compareGui := Gui("+AlwaysOnTop", "Title Comparison Tool")
    compareGui.SetFont("s10", "Segoe UI")

    ; Get all windows
    windows := []
    windowTitles := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                windows.Push(hwnd)
                windowTitles.Push(title)
            }
        }
    }

    compareGui.Add("Text", "w500", "First window:")
    win1Drop := compareGui.Add("DropDownList", "w500 vWin1 Choose1", windowTitles)

    compareGui.Add("Text", "w500", "Second window:")
    win2Drop := compareGui.Add("DropDownList", "w500 vWin2 Choose" (windowTitles.Length > 1 ? "2" : "1"), windowTitles)

    resultEdit := compareGui.Add("Edit", "w500 h150 ReadOnly vResults")

    compareGui.Add("Button", "w240 Default", "Compare").OnEvent("Click", Compare)
    compareGui.Add("Button", "w240 x+20 yp", "Close").OnEvent("Click", (*) => compareGui.Destroy())

    compareGui.Show()

    Compare(*) {
        idx1 := win1Drop.Value
        idx2 := win2Drop.Value

        if idx1 = idx2 {
            MsgBox("Please select two different windows.", "Error", 16)
            return
        }

        title1 := WinGetTitle(windows[idx1])
        title2 := WinGetTitle(windows[idx2])

        results := "Comparison Results:`n`n"
        results .= "Window 1: " title1 "`n"
        results .= "Window 2: " title2 "`n`n"

        ; Check for similarities
        if title1 = title2 {
            results .= "Result: IDENTICAL`n"
        } else if InStr(title1, title2) || InStr(title2, title1) {
            results .= "Result: PARTIAL MATCH (one contains the other)`n"
        } else {
            results .= "Result: DIFFERENT`n"
        }

        results .= "`nLength 1: " StrLen(title1) " chars`n"
        results .= "Length 2: " StrLen(title2) " chars"

        resultEdit.Value := results
    }
}

; ============================================================================
; Example 7: Title History Tracker
; ============================================================================

/**
* Tracks title changes of a specific window
* Useful for monitoring dynamic window titles
*
* @hotkey F7 - Track title changes
*/
F7:: {
    TrackTitleChanges()
}

/**
* Tracks and displays title changes
*/
TrackTitleChanges() {
    static trackGui := ""

    if !WinExist("A") {
        MsgBox("No active window to track.", "Error", 16)
        return
    }

    trackedHwnd := WinGetID("A")
    initialTitle := WinGetTitle(trackedHwnd)

    if trackGui {
        try trackGui.Destroy()
    }

    trackGui := Gui("+AlwaysOnTop", "Title Change Tracker")
    trackGui.SetFont("s9", "Consolas")

    trackGui.Add("Text", "w600", "Tracking window: " initialTitle)
    trackGui.Add("Text", "w600", "HWND: " Format("0x{:X}", trackedHwnd))

    historyEdit := trackGui.Add("Edit", "w600 h300 ReadOnly vHistory")

    trackGui.Add("Button", "w290 Default", "Stop Tracking").OnEvent("Click", StopTracking)
    trackGui.Add("Button", "w290 x+20 yp", "Clear History").OnEvent("Click", ClearHistory)

    trackGui.Show()

    history := []
    lastTitle := initialTitle

    history.Push("[" A_Hour ":" A_Min ":" A_Sec "] Initial: " initialTitle)
    UpdateHistory()

    ; Start tracking timer
    SetTimer(CheckForChanges, 500)

    CheckForChanges() {
        try {
            if !WinExist(trackedHwnd) {
                history.Push("[" A_Hour ":" A_Min ":" A_Sec "] Window closed")
                UpdateHistory()
                SetTimer(CheckForChanges, 0)
                return
            }

            currentTitle := WinGetTitle(trackedHwnd)

            if currentTitle != lastTitle {
                history.Push("[" A_Hour ":" A_Min ":" A_Sec "] Changed to: " currentTitle)
                lastTitle := currentTitle
                UpdateHistory()
            }
        }
    }

    UpdateHistory() {
        output := ""
        for entry in history {
            output := entry "`n" output
        }
        historyEdit.Value := output
    }

    StopTracking(*) {
        SetTimer(CheckForChanges, 0)
        trackGui.Destroy()
    }

    ClearHistory(*) {
        history := []
        historyEdit.Value := ""
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinGetTitle Examples - Part 1
    ==============================

    Hotkeys:
    F1 - Get active window title
    F2 - Get window title under mouse
    F3 - Copy window title to clipboard
    F4 - Start/stop title logger
    F5 - Find windows by title pattern
    F6 - Compare window titles
    F7 - Track title changes
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
