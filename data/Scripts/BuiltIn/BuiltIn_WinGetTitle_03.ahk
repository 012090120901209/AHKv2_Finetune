#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinGetTitle Examples - Part 3: Monitor Title Changes
 * ============================================================================
 * 
 * This script demonstrates real-time monitoring of window title changes.
 * Useful for tracking dynamic content, notifications, and window states.
 * 
 * @description Monitor and respond to window title changes
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Track Browser Tab Changes
; ============================================================================

/**
 * Monitors browser window titles to track tab changes
 * Demonstrates real-time title change detection
 * 
 * @hotkey F1 - Monitor browser tabs
 */
F1:: {
    MonitorBrowserTabs()
}

/**
 * Tracks browser tab changes
 */
MonitorBrowserTabs() {
    static monGui := ""
    static lastTitle := ""

    if monGui {
        try monGui.Destroy()
    }

    ; Find browser window
    browserFound := false
    browserCriteria := ""

    browsers := [{
        name: "Chrome", criteria: "ahk_exe chrome.exe" }, {
            name: "Firefox", criteria: "ahk_exe firefox.exe" }, {
                name: "Edge", criteria: "ahk_exe msedge.exe"
            }
    ]

    for browser in browsers {
        if WinExist(browser.criteria) {
            browserFound := true
            browserCriteria := browser.criteria
            browserName := browser.name
            break
        }
    }

    if !browserFound {
        MsgBox("No supported browser found. Please open Chrome, Firefox, or Edge.", "Error", 16)
        return
    }

    monGui := Gui("+AlwaysOnTop", "Browser Tab Monitor - " browserName)
    monGui.SetFont("s9", "Consolas")

    monGui.Add("Text", "w600", "Monitoring browser tabs. Switch tabs to see updates:")

    historyEdit := monGui.Add("Edit", "w600 h350 ReadOnly vHistory")

    monGui.Add("Button", "w290 Default", "Stop Monitor").OnEvent("Click", StopMon)
    monGui.Add("Button", "w290 x+20 yp", "Clear History").OnEvent("Click", ClearHist)

    monGui.Show()

    history := []
    lastTitle := WinGetTitle(browserCriteria)
    history.Push("[" A_Hour ":" A_Min ":" A_Sec "] Started monitoring: " lastTitle)
    UpdateHistory()

    ; Monitor title changes
    SetTimer(CheckBrowserTitle, 250)

    CheckBrowserTitle() {
        try {
            if !WinExist(browserCriteria) {
                history.Push("[" A_Hour ":" A_Min ":" A_Sec "] Browser closed")
                UpdateHistory()
                SetTimer(CheckBrowserTitle, 0)
                return
            }

            currentTitle := WinGetTitle(browserCriteria)

            if currentTitle != lastTitle {
                history.Push("[" A_Hour ":" A_Min ":" A_Sec "] Changed to: " currentTitle)
                lastTitle := currentTitle
                UpdateHistory()
            }
        }
    }

    UpdateHistory() {
        output := ""
        ; Show most recent first
        Loop Min(50, history.Length) {
            output := history[history.Length - A_Index + 1] "`n" output
        }
        historyEdit.Value := output
    }

    StopMon(*) {
        SetTimer(CheckBrowserTitle, 0)
        monGui.Destroy()
    }

    ClearHist(*) {
        history := []
        historyEdit.Value := ""
    }
}

; ============================================================================
; Example 2: Title Change Notification System
; ============================================================================

/**
 * Creates notifications when specific title patterns appear
 * Useful for monitoring important window events
 * 
 * @hotkey F2 - Setup title notifications
 */
F2:: {
    SetupTitleNotifications()
}

/**
 * Creates notification system for title changes
 */
SetupTitleNotifications() {
    static setupGui := ""

    if setupGui {
        try setupGui.Destroy()
    }

    setupGui := Gui("+AlwaysOnTop", "Title Change Notifications")
    setupGui.SetFont("s10", "Segoe UI")

    setupGui.Add("Text", "w500", "Enter text to watch for in window titles:")
    watchText := setupGui.Add("Edit", "w500 vWatchText", "")

    setupGui.Add("Text", "w500", "Notification settings:")
    notifySound := setupGui.Add("CheckBox", "vSound Checked", "Play sound")
    notifyToolTip := setupGui.Add("CheckBox", "vToolTip Checked", "Show tooltip")
    notifyMsgBox := setupGui.Add("CheckBox", "vMsgBox", "Show message box")

    setupGui.Add("Button", "w240 Default", "Start Monitoring").OnEvent("Click", StartNotify)
    setupGui.Add("Button", "w240 x+20 yp", "Cancel").OnEvent("Click", (*) => setupGui.Destroy())

    setupGui.Show()

    StartNotify(*) {
        submitted := setupGui.Submit()

        if submitted.WatchText = "" {
            MsgBox("Please enter text to watch for.", "Error", 16)
            return
        }

        setupGui.Destroy()

        ; Create monitoring window
        monGui := Gui("+AlwaysOnTop", "Title Monitor Active")
        monGui.SetFont("s9", "Segoe UI")

        monGui.Add("Text", "w400", "Watching for: " submitted.WatchText)
        statusText := monGui.Add("Text", "w400 vStatus", "Status: Monitoring...")
        countText := monGui.Add("Text", "w400 vCount", "Matches found: 0")
        logEdit := monGui.Add("Edit", "w400 h200 ReadOnly vLog")

        monGui.Add("Button", "w400", "Stop Monitoring").OnEvent("Click", (*) => (SetTimer(CheckTitles, 0), monGui.Destroy()))

        monGui.Show()

        matchCount := 0
        seenMatches := Map()

        SetTimer(CheckTitles, 500)

        CheckTitles() {
            allWindows := WinGetList()

            for hwnd in allWindows {
                try {
                    title := WinGetTitle(hwnd)

                    if title != "" && InStr(title, submitted.WatchText) {
                        key := Format("0x{:X}", hwnd) "|" title

                        if !seenMatches.Has(key) {
                            seenMatches[key] := true
                            matchCount++

                            ; Notifications
                            if submitted.Sound {
                                SoundBeep(750, 100)
                            }

                            if submitted.ToolTip {
                                ToolTip("Match found: " title)
                                SetTimer(() => ToolTip(), -3000)
                            }

                            if submitted.MsgBox {
                                MsgBox("Window title contains: " submitted.WatchText "`n`nTitle: " title, "Match Found", 64)
                            }

                            ; Log
                            timestamp := A_Hour ":" A_Min ":" A_Sec
                            logEdit.Value := "[" timestamp "] " title "`n" logEdit.Value
                            countText.Value := "Matches found: " matchCount
                        }
                    }
                }
            }

            statusText.Value := "Status: Monitoring... (Last check: " A_Hour ":" A_Min ":" A_Sec ")"
        }
    }
}

; ============================================================================
; Example 3: Title Change Frequency Analyzer
; ============================================================================

/**
 * Analyzes how frequently window titles change
 * Identifies highly dynamic windows
 * 
 * @hotkey F3 - Analyze title change frequency
 */
F3:: {
    AnalyzeTitleChangeFrequency()
}

/**
 * Monitors and analyzes title change frequency
 */
AnalyzeTitleChangeFrequency() {
    static anaGui := ""

    if anaGui {
        try anaGui.Destroy()
    }

    MsgBox("This will monitor window title changes for 30 seconds.`n`nClick OK to start.", "Info", 64)

    anaGui := Gui("+AlwaysOnTop", "Title Change Frequency Analyzer")
    anaGui.SetFont("s9", "Consolas")

    anaGui.Add("Text", "w650", "Monitoring title changes for 30 seconds...")

    progressBar := anaGui.Add("Progress", "w650 h20 vProgress")
    lv := anaGui.Add("ListView", "w650 h300 vResults", ["Process", "Changes", "Avg Interval", "Last Title"])

    anaGui.Show()

    ; Track changes
    changeData := Map()
    startTime := A_TickCount
    duration := 30000  ; 30 seconds

    SetTimer(Monitor, 200)

    Monitor() {
        elapsed := A_TickCount - startTime

        if elapsed >= duration {
            SetTimer(Monitor, 0)
            ShowResults()
            return
        }

        ; Update progress
        progressBar.Value := (elapsed / duration) * 100

        ; Check all windows
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)

                if title != "" {
                    process := WinGetProcessName(hwnd)

                    if !changeData.Has(process) {
                        changeData[process] := {
                            count: 0,
                            lastTitle: title,
                            lastChange: A_TickCount,
                            intervals: [],
                            currentTitle: title
                        }
                    }

                    data := changeData[process]

                    if title != data.lastTitle {
                        data.count++
                        interval := A_TickCount - data.lastChange
                        data.intervals.Push(interval)
                        data.lastTitle := title
                        data.lastChange := A_TickCount
                        data.currentTitle := title
                    }
                }
            }
        }
    }

    ShowResults() {
        lv.Delete()

        ; Calculate and display results
        for process, data in changeData {
            if data.count > 0 {
                avgInterval := 0
                if data.intervals.Length > 0 {
                    total := 0
                    for interval in data.intervals {
                        total += interval
                    }
                    avgInterval := Round(total / data.intervals.Length / 1000, 1)
                }

                lv.Add("", process, data.count, avgInterval "s", SubStr(data.currentTitle, 1, 50))
            }
        }

        ; Sort by changes (descending)
        lv.ModifyCol(1, "AutoHdr")
        lv.ModifyCol(2, "AutoHdr")
        lv.ModifyCol(3, "AutoHdr")
        lv.ModifyCol(4, 300)

        anaGui.Add("Text", "w650", "Analysis complete! Most dynamic windows listed above.")
        anaGui.Add("Button", "w650 Default", "Close").OnEvent("Click", (*) => anaGui.Destroy())
    }
}

; ============================================================================
; Example 4: Download Progress Monitor
; ============================================================================

/**
 * Monitors window titles for download progress indicators
 * Extracts and displays download percentages
 * 
 * @hotkey F4 - Monitor download progress
 */
F4:: {
    MonitorDownloadProgress()
}

/**
 * Monitors titles for download progress
 */
MonitorDownloadProgress() {
    static progGui := ""

    if progGui {
        try progGui.Destroy()
    }

    progGui := Gui("+AlwaysOnTop", "Download Progress Monitor")
    progGui.SetFont("s9", "Segoe UI")

    progGui.Add("Text", "w500", "Monitoring window titles for download progress...")

    lv := progGui.Add("ListView", "w500 h250 vDownloads", ["Window", "Progress", "Status"])

    progGui.Add("Button", "w240 Default", "Stop Monitor").OnEvent("Click", StopProg)
    progGui.Add("Button", "w240 x+20 yp", "Close").OnEvent("Click", (*) => progGui.Destroy())

    progGui.Show()

    SetTimer(CheckProgress, 1000)

    CheckProgress() {
        lv.Delete()

        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)

                if title != "" {
                    ; Look for percentage patterns
                    if RegExMatch(title, "(\d+)%", &match) {
                        percentage := match[1]
                        process := WinGetProcessName(hwnd)

                        status := ""
                        if percentage = "100" {
                            status := "Complete"
                        } else if Integer(percentage) > 0 {
                            status := "Downloading"
                        }

                        lv.Add("", SubStr(title, 1, 40), percentage "%", status)
                    }
                }
            }
        }

        lv.ModifyCol(1, 250)
        lv.ModifyCol(2, "AutoHdr")
        lv.ModifyCol(3, "AutoHdr")
    }

    StopProg(*) {
        SetTimer(CheckProgress, 0)
        progGui.Destroy()
    }
}

; ============================================================================
; Example 5: Window Title History Database
; ============================================================================

/**
 * Builds a database of window title history
 * Stores all seen titles with timestamps
 * 
 * @hotkey F5 - Start title database
 */
F5:: {
    static recording := false

    if !recording {
        recording := true
        StartTitleDatabase()
    } else {
        recording := false
        MsgBox("Title database recording stopped.", "Info", 64)
    }
}

; Global database
global titleDatabase := []

/**
 * Records window title history
 */
StartTitleDatabase() {
    static dbGui := ""

    if dbGui {
        try dbGui.Destroy()
    }

    dbGui := Gui("+AlwaysOnTop +Resize", "Window Title Database")
    dbGui.SetFont("s9", "Consolas")

    dbGui.Add("Text", "w700", "Recording window title history...")

    lv := dbGui.Add("ListView", "w700 h350 vDatabase", ["Timestamp", "Process", "Title"])

    dbGui.Add("Text", "w700 vStats", "Total entries: 0")

    dbGui.Add("Button", "w170 Default", "Stop Recording").OnEvent("Click", StopRec)
    dbGui.Add("Button", "w170 x+10 yp", "Export to CSV").OnEvent("Click", ExportDB)
    dbGui.Add("Button", "w170 x+10 yp", "Clear Database").OnEvent("Click", ClearDB)
    dbGui.Add("Button", "w170 x+10 yp", "Close").OnEvent("Click", (*) => dbGui.Destroy())

    dbGui.Show()

    titleDatabase := []
    seenTitles := Map()

    SetTimer(RecordTitles, 2000)

    RecordTitles() {
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)

                if title != "" {
                    process := WinGetProcessName(hwnd)
                    key := process "|" title

                    if !seenTitles.Has(key) {
                        seenTitles[key] := true

                        timestamp := A_YYYY "-" A_MM "-" A_DD " " A_Hour ":" A_Min ":" A_Sec

                        entry := {
                            timestamp: timestamp,
                            process: process,
                            title: title
                        }

                        titleDatabase.Push(entry)

                        lv.Add("", timestamp, process, title)
                    }
                }
            }
        }

        lv.ModifyCol(1, "AutoHdr")
        lv.ModifyCol(2, "AutoHdr")
        lv.ModifyCol(3, 400)

        dbGui["Stats"].Value := "Total entries: " titleDatabase.Length
    }

    StopRec(*) {
        SetTimer(RecordTitles, 0)
        MsgBox("Recording stopped. Database contains " titleDatabase.Length " entries.", "Stopped", 64)
    }

    ExportDB(*) {
        if titleDatabase.Length = 0 {
            MsgBox("Database is empty.", "Error", 16)
            return
        }

        fileName := "TitleDatabase_" A_YYYY A_MM A_DD "_" A_Hour A_Min A_Sec ".csv"
        filePath := A_Desktop "\" fileName

        content := "Timestamp,Process,Title`n"

        for entry in titleDatabase {
            content .= entry.timestamp ',"' entry.process '","' entry.title '"`n'
        }

        try {
            FileAppend(content, filePath)
            MsgBox("Database exported to:`n" filePath "`n`nEntries: " titleDatabase.Length, "Exported", 64)
        } catch Error as err {
            MsgBox("Error exporting: " err.Message, "Error", 16)
        }
    }

    ClearDB(*) {
        titleDatabase := []
        lv.Delete()
        seenTitles := Map()
        dbGui["Stats"].Value := "Total entries: 0"
    }
}

; ============================================================================
; Example 6: Multi-Window Title Correlation
; ============================================================================

/**
 * Correlates title changes across multiple windows
 * Finds patterns in simultaneous title updates
 * 
 * @hotkey F6 - Correlate title changes
 */
F6:: {
    CorrelateTitleChanges()
}

/**
 * Analyzes correlated title changes
 */
CorrelateTitleChanges() {
    static corGui := ""

    if corGui {
        try corGui.Destroy()
    }

    MsgBox("Monitoring for 20 seconds to detect correlated title changes...`n`nClick OK to start.", "Info", 64)

    corGui := Gui("+AlwaysOnTop", "Title Change Correlation")
    corGui.SetFont("s9", "Consolas")

    corGui.Add("Text", "w650", "Detecting simultaneous title changes...")

    progressBar := corGui.Add("Progress", "w650 h20 vProgress")
    logEdit := corGui.Add("Edit", "w650 h300 ReadOnly vLog")

    corGui.Show()

    correlations := []
    lastTitles := Map()
    startTime := A_TickCount
    duration := 20000

    SetTimer(CheckCorrelation, 500)

    CheckCorrelation() {
        elapsed := A_TickCount - startTime

        if elapsed >= duration {
            SetTimer(CheckCorrelation, 0)
            ShowCorrelations()
            return
        }

        progressBar.Value := (elapsed / duration) * 100

        ; Check for simultaneous changes
        changedWindows := []
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)

                if title != "" {
                    hwndKey := Format("0x{:X}", hwnd)

                    if lastTitles.Has(hwndKey) && lastTitles[hwndKey] != title {
                        process := WinGetProcessName(hwnd)
                        changedWindows.Push({ process: process, oldTitle: lastTitles[hwndKey], newTitle: title })
                    }

                    lastTitles[hwndKey] := title
                }
            }
        }

        ; If multiple windows changed at once, record correlation
        if changedWindows.Length > 1 {
            timestamp := A_Hour ":" A_Min ":" A_Sec
            correlations.Push({ time: timestamp, windows: changedWindows })

            log := "[" timestamp "] " changedWindows.Length " windows changed simultaneously:`n"
            for win in changedWindows {
                log .= "  - " win.process ": " SubStr(win.newTitle, 1, 50) "`n"
            }
            logEdit.Value := log "`n" logEdit.Value
        }
    }

    ShowCorrelations() {
        if correlations.Length = 0 {
            logEdit.Value := "No correlated title changes detected.`n" logEdit.Value
        } else {
            logEdit.Value := "`nAnalysis complete: " correlations.Length " correlated events found.`n" logEdit.Value
        }

        corGui.Add("Button", "w650 Default", "Close").OnEvent("Click", (*) => corGui.Destroy())
    }
}

; ============================================================================
; Example 7: Title Change Event Logger
; ============================================================================

/**
 * Comprehensive event logger for all title changes
 * Creates detailed logs with full context
 * 
 * @hotkey F7 - Start event logger
 */
F7:: {
    static logging := false

    if !logging {
        logging := true
        StartEventLogger()
    } else {
        logging := false
    }
}

/**
 * Logs all title change events
 */
StartEventLogger() {
    static logGui := ""

    if logGui {
        try logGui.Destroy()
    }

    logGui := Gui("+AlwaysOnTop +Resize", "Title Change Event Logger")
    logGui.SetFont("s9", "Consolas")

    logGui.Add("Text", "w750", "Comprehensive title change logging:")

    logEdit := logGui.Add("Edit", "w750 h400 ReadOnly vLog")

    logGui.Add("Button", "w180 Default", "Stop Logging").OnEvent("Click", StopLog)
    logGui.Add("Button", "w180 x+10 yp", "Clear Log").OnEvent("Click", ClearLog)
    logGui.Add("Button", "w180 x+10 yp", "Save Log").OnEvent("Click", SaveLog)
    logGui.Add("Button", "w180 x+10 yp", "Close").OnEvent("Click", (*) => logGui.Destroy())

    logGui.Show()

    eventLog := []
    windowStates := Map()

    LogEvent("Event logger started at " A_Hour ":" A_Min ":" A_Sec)

    SetTimer(LogChanges, 250)

    LogChanges() {
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)

                if title != "" {
                    hwndKey := Format("0x{:X}", hwnd)

                    if windowStates.Has(hwndKey) {
                        if windowStates[hwndKey].title != title {
                            process := WinGetProcessName(hwnd)
                            pid := WinGetPID(hwnd)

                            event := "[" A_Hour ":" A_Min ":" A_Sec "." A_MSec "] CHANGE`n"
                            event .= "  Process: " process " (PID: " pid ")`n"
                            event .= "  From: " windowStates[hwndKey].title "`n"
                            event .= "  To: " title

                            LogEvent(event)

                            windowStates[hwndKey].title := title
                        }
                    } else {
                        windowStates[hwndKey] := { title: title }
                    }
                }
            }
        }
    }

    LogEvent(message) {
        eventLog.Push(message)

        ; Keep only last 100 events
        if eventLog.Length > 100 {
            eventLog.RemoveAt(1)
        }

        UpdateLog()
    }

    UpdateLog() {
        output := ""
        Loop eventLog.Length {
            output := eventLog[eventLog.Length - A_Index + 1] "`n`n" output
        }
        logEdit.Value := output
    }

    StopLog(*) {
        SetTimer(LogChanges, 0)
        LogEvent("Event logger stopped at " A_Hour ":" A_Min ":" A_Sec)
    }

    ClearLog(*) {
        eventLog := []
        logEdit.Value := ""
        LogEvent("Log cleared at " A_Hour ":" A_Min ":" A_Sec)
    }

    SaveLog(*) {
        if eventLog.Length = 0 {
            MsgBox("Log is empty.", "Error", 16)
            return
        }

        fileName := "TitleChangeLog_" A_YYYY A_MM A_DD "_" A_Hour A_Min A_Sec ".txt"
        filePath := A_Desktop "\" fileName

        content := "Title Change Event Log`n"
        content .= StrRepeat("=", 70) "`n`n"

        for event in eventLog {
            content .= event "`n`n"
        }

        try {
            FileAppend(content, filePath)
            MsgBox("Log saved to:`n" filePath, "Saved", 64)
        } catch Error as err {
            MsgBox("Error saving: " err.Message, "Error", 16)
        }
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
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
            (
            WinGetTitle Examples - Part 3 (Monitor Changes)
            ================================================

            Hotkeys:
            F1 - Monitor browser tabs
            F2 - Setup title notifications
            F3 - Analyze title change frequency
            F4 - Monitor download progress
            F5 - Start/stop title database
            F6 - Correlate title changes
            F7 - Start/stop event logger
            Esc - Exit script

            Ctrl+F1 - Show this help
            )"

    MsgBox(help, "Help", 64)
}
