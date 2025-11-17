#Requires AutoHotkey v2.0
/**
 * BuiltIn_MonitorGetCount_02_Detection.ahk
 *
 * DESCRIPTION:
 * Advanced monitor count detection and change monitoring. Demonstrates
 * real-time detection of monitor configuration changes, hotplug events,
 * and dynamic adaptation to display changes.
 *
 * FEATURES:
 * - Real-time monitor count monitoring
 * - Hotplug event detection
 * - Configuration change notifications
 * - Historical count tracking
 * - Change event logging
 * - Automatic UI adaptation
 * - Monitor connect/disconnect handling
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/MonitorGetCount.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Timer-based monitoring
 * - Event callback functions
 * - Dynamic GUI updates
 * - Array/Map data structures
 * - Custom event system
 * - OnMessage for system events
 *
 * LEARNING POINTS:
 * 1. Monitor count can change during runtime
 * 2. Hotplug events require continuous monitoring
 * 3. Cache count to detect changes efficiently
 * 4. Configuration changes may affect existing windows
 * 5. Applications should adapt to monitor changes
 * 6. WM_DISPLAYCHANGE message indicates monitor changes
 * 7. Re-query count after display change events
 */

;=============================================================================
; EXAMPLE 1: Real-Time Monitor Count Monitor
;=============================================================================
; Continuously monitors and displays current monitor count
Example1_RealTimeMonitor() {
    ; Create GUI
    g := Gui("+AlwaysOnTop", "Real-Time Monitor Count Monitor")
    g.SetFont("s12 Bold")

    txtCount := g.Add("Text", "w300 h50 +Center +Border", "")
    g.SetFont("s9 Norm")

    txtStatus := g.Add("Text", "xm w300 h30 +Center")
    txtLastUpdate := g.Add("Text", "xm w300 +Center", "")

    g.Add("Button", "xm w140", "Pause").OnEvent("Click", ToggleMonitoring)
    g.Add("Button", "x+20 w140", "Close").OnEvent("Click", (*) => Cleanup())

    isPaused := false
    updateCount := 0

    ; Initial update
    UpdateDisplay()

    ; Set up timer
    SetTimer(UpdateDisplay, 1000)

    g.OnEvent("Close", (*) => Cleanup())
    g.Show()

    UpdateDisplay() {
        if isPaused
            return

        MonCount := MonitorGetCount()
        updateCount++

        ; Update display
        txtCount.Value := MonCount " Monitor(s)"
        txtStatus.Value := "Status: Monitoring Active"
        txtLastUpdate.Value := "Updated: " A_Hour ":" A_Min ":" A_Sec " (Check #" updateCount ")"
    }

    ToggleMonitoring(*) {
        isPaused := !isPaused
        if isPaused {
            txtStatus.Value := "Status: Paused"
        } else {
            txtStatus.Value := "Status: Monitoring Active"
            UpdateDisplay()
        }
    }

    Cleanup() {
        SetTimer(UpdateDisplay, 0)
        g.Destroy()
    }
}

;=============================================================================
; EXAMPLE 2: Monitor Change Detector
;=============================================================================
; Detects and logs changes in monitor count
Example2_ChangeDetector() {
    ; Create GUI
    g := Gui(, "Monitor Change Detector")
    g.SetFont("s10")

    g.Add("Text", , "Monitor Change Log:")
    lv := g.Add("ListView", "w600 h300", ["Time", "Event", "Old Count", "New Count", "Change"])

    txtCurrent := g.Add("Text", "xm w600 +Border")
    g.Add("Button", "xm w120", "Clear Log").OnEvent("Click", (*) => lv.Delete())

    ; Track current count
    currentCount := MonitorGetCount()
    changeCount := 0

    ; Log initial state
    LogEvent("Started", 0, currentCount, "Initial")
    UpdateStatus()

    ; Set up monitoring timer
    SetTimer(CheckForChanges, 500)

    g.OnEvent("Close", (*) => (SetTimer(CheckForChanges, 0), g.Destroy()))
    g.Show()

    CheckForChanges() {
        newCount := MonitorGetCount()

        if newCount != currentCount {
            ; Count changed!
            change := newCount - currentCount
            changeType := change > 0 ? "Monitor Added" : "Monitor Removed"

            LogEvent(changeType, currentCount, newCount, (change > 0 ? "+" : "") change)

            currentCount := newCount
            changeCount++
            UpdateStatus()

            ; Show notification
            TrayTip("Monitor Configuration Changed",
                    "Count changed from " (newCount - change) " to " newCount,
                    "Mute")
        }
    }

    LogEvent(eventType, oldCount, newCount, changeStr) {
        timestamp := FormatTime(, "HH:mm:ss")
        lv.Add("", timestamp, eventType, oldCount, newCount, changeStr)
        lv.ModifyCol()  ; Auto-size all columns
    }

    UpdateStatus() {
        status := "Current: " currentCount " monitor(s) | "
        status .= "Changes Detected: " changeCount " | "
        status .= "Last Check: " A_Hour ":" A_Min ":" A_Sec
        txtCurrent.Value := status
    }
}

;=============================================================================
; EXAMPLE 3: Display Change Event Handler
;=============================================================================
; Uses WM_DISPLAYCHANGE to detect monitor configuration changes
Example3_DisplayChangeHandler() {
    ; Create GUI
    g := Gui(, "Display Change Event Handler")
    g.SetFont("s9")

    g.Add("Text", , "Listening for WM_DISPLAYCHANGE events...")

    lv := g.Add("ListView", "w700 h300", [
        "Time", "Event", "Monitor Count", "Resolution", "Color Depth"
    ])

    txtStats := g.Add("Text", "xm w700 +Border")

    eventCount := 0
    currentCount := MonitorGetCount()

    ; Register for display change messages
    OnMessage(0x007E, OnDisplayChange)  ; WM_DISPLAYCHANGE

    ; Log initial state
    LogDisplayChange("Initial State")

    g.OnEvent("Close", (*) => (OnMessage(0x007E, OnDisplayChange, 0), g.Destroy()))
    g.Show()

    OnDisplayChange(wParam, lParam, msg, hwnd) {
        ; wParam contains color depth
        ; lParam contains resolution (LOWORD=width, HIWORD=height)

        colorDepth := wParam
        width := lParam & 0xFFFF
        height := (lParam >> 16) & 0xFFFF

        LogDisplayChange("Display Changed", width, height, colorDepth)

        return 0
    }

    LogDisplayChange(eventType, width := 0, height := 0, depth := 0) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(A_TickCount, -2)
        newCount := MonitorGetCount()

        resolution := (width && height) ? width "x" height : "N/A"
        colorInfo := depth ? depth " bits" : "N/A"

        lv.Add("", timestamp, eventType, newCount, resolution, colorInfo)
        lv.ModifyCol()

        eventCount++

        if newCount != currentCount {
            lv.Modify(lv.GetCount(), "Select Focus")
            currentCount := newCount
        }

        UpdateStats()
    }

    UpdateStats() {
        stats := "Total Events: " eventCount " | "
        stats .= "Current Monitors: " currentCount " | "
        stats .= "Monitoring Since: " A_Hour ":" A_Min

        MonitorGet(1, &L, &T, &R, &B)
        stats .= " | Primary: " (R-L) "x" (B-T)

        txtStats.Value := stats
    }
}

;=============================================================================
; EXAMPLE 4: Monitor Count History Tracker
;=============================================================================
; Maintains detailed history of monitor count changes over time
Example4_HistoryTracker() {
    ; Create GUI
    g := Gui("+Resize", "Monitor Count History Tracker")
    g.SetFont("s9")

    g.Add("Text", , "Monitor Count Change History:")

    ; Timeline view
    lv := g.Add("ListView", "w700 h250", [
        "#", "Timestamp", "Count", "Duration", "Change Type", "Notes"
    ])

    ; Statistics panel
    g.Add("Text", "xm Section", "Statistics:")
    txtStats := g.Add("Text", "xs w700 h100 +Border")

    g.Add("Button", "xs w120", "Export History").OnEvent("Click", ExportHistory)
    g.Add("Button", "x+10 w120", "Clear History").OnEvent("Click", ClearHistory)

    ; History data
    history := []
    currentCount := MonitorGetCount()
    sessionStart := A_Now

    ; Add initial entry
    AddHistoryEntry(currentCount, "Initial")

    ; Monitor for changes
    SetTimer(CheckChanges, 1000)

    g.OnEvent("Close", (*) => (SetTimer(CheckChanges, 0), g.Destroy()))
    g.Show()

    CheckChanges() {
        newCount := MonitorGetCount()

        if newCount != currentCount {
            changeType := newCount > currentCount ? "Added" : "Removed"
            AddHistoryEntry(newCount, changeType)
            currentCount := newCount
        }
    }

    AddHistoryEntry(count, changeType) {
        timestamp := A_Now
        entryNum := history.Length + 1

        ; Calculate duration since last entry
        duration := "N/A"
        if history.Length > 0 {
            lastTime := history[history.Length].Timestamp
            seconds := DateDiff(timestamp, lastTime, "Seconds")

            if seconds < 60
                duration := seconds " seconds"
            else if seconds < 3600
                duration := Round(seconds / 60, 1) " minutes"
            else
                duration := Round(seconds / 3600, 1) " hours"
        }

        ; Store entry
        entry := {
            Num: entryNum,
            Timestamp: timestamp,
            Count: count,
            Duration: duration,
            ChangeType: changeType,
            Notes: ""
        }

        history.Push(entry)

        ; Add to ListView
        timeStr := FormatTime(timestamp, "yyyy-MM-dd HH:mm:ss")
        lv.Add("", entryNum, timeStr, count, duration, changeType, "")
        lv.ModifyCol()

        ; Scroll to bottom
        lv.Modify(lv.GetCount(), "Vis")

        UpdateStats()
    }

    UpdateStats() {
        if history.Length = 0
            return

        ; Calculate statistics
        totalChanges := history.Length - 1  ; Exclude initial entry
        minCount := 999
        maxCount := 0
        totalDuration := DateDiff(A_Now, sessionStart, "Seconds")

        for entry in history {
            minCount := Min(minCount, entry.Count)
            maxCount := Max(maxCount, entry.Count)
        }

        stats := "Session Duration: " Round(totalDuration / 60) " minutes`n"
        stats .= "Total Configuration Changes: " totalChanges "`n"
        stats .= "Current Monitor Count: " currentCount "`n"
        stats .= "Range: " minCount " - " maxCount " monitors`n"
        stats .= "Average Change Frequency: "

        if totalChanges > 0 && totalDuration > 0
            stats .= Round(totalDuration / totalChanges / 60, 1) " minutes between changes"
        else
            stats .= "N/A (no changes yet)"

        txtStats.Value := stats
    }

    ExportHistory(*) {
        if history.Length = 0 {
            MsgBox("No history to export", "Export", "Icon!")
            return
        }

        export := "Monitor Count Change History`n"
        export .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

        for entry in history {
            export .= "#" entry.Num " - "
            export .= FormatTime(entry.Timestamp, "yyyy-MM-dd HH:mm:ss") " - "
            export .= "Count: " entry.Count " - "
            export .= "Duration: " entry.Duration " - "
            export .= entry.ChangeType "`n"
        }

        A_Clipboard := export
        MsgBox("History exported to clipboard", "Export Complete", "Icon!")
    }

    ClearHistory(*) {
        result := MsgBox("Clear all history?", "Confirm", "YesNo Icon?")
        if result = "Yes" {
            history := []
            lv.Delete()
            currentCount := MonitorGetCount()
            AddHistoryEntry(currentCount, "Reset")
        }
    }
}

;=============================================================================
; EXAMPLE 5: Adaptive Application Responder
;=============================================================================
; Automatically adapts application behavior when monitor count changes
Example5_AdaptiveResponder() {
    ; Create GUI
    g := Gui(, "Adaptive Application Responder")
    g.SetFont("s10")

    g.Add("Text", , "Automatic Adaptation Settings:")

    chkReposition := g.Add("Checkbox", "Checked", "Reposition windows on change")
    chkResize := g.Add("Checkbox", "Checked", "Resize windows on change")
    chkNotify := g.Add("Checkbox", "Checked", "Show notifications")

    g.Add("Text", "xm Section", "Activity Log:")
    txtLog := g.Add("Edit", "xs w500 h250 ReadOnly +Multi")

    txtStatus := g.Add("Text", "xs w500 +Border")

    currentCount := MonitorGetCount()
    Log("System started with " currentCount " monitor(s)")

    SetTimer(MonitorChanges, 1000)

    g.OnEvent("Close", (*) => (SetTimer(MonitorChanges, 0), g.Destroy()))
    g.Show()

    MonitorChanges() {
        newCount := MonitorGetCount()

        if newCount != currentCount {
            HandleCountChange(currentCount, newCount)
            currentCount := newCount
        }
    }

    HandleCountChange(oldCount, newCount) {
        change := newCount - oldCount
        action := change > 0 ? "added" : "removed"

        Log("Monitor count changed: " oldCount " → " newCount " (" Abs(change) " " action ")")

        ; Notification
        if chkNotify.Value {
            TrayTip("Display Configuration Changed",
                    "Monitors " action ": " oldCount " → " newCount,
                    "Mute")
            Log("Notification sent to user")
        }

        ; Reposition windows
        if chkReposition.Value {
            RepositionWindows(newCount)
        }

        ; Resize windows
        if chkResize.Value {
            ResizeWindows(newCount)
        }

        UpdateStatus()
    }

    RepositionWindows(monCount) {
        ; Move windows to ensure they're visible
        windowList := WinGetList(, , "Program Manager")
        repositioned := 0

        for winID in windowList {
            try {
                if !WinExist(winID)
                    continue

                WinGetPos(&X, &Y, &W, &H, winID)

                ; Check if window is off-screen
                isVisible := false
                Loop monCount {
                    MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                    if (X >= Left && X < Right && Y >= Top && Y < Bottom) {
                        isVisible := true
                        break
                    }
                }

                if !isVisible {
                    ; Move to primary monitor
                    MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)
                    NewX := Left + 50
                    NewY := Top + 50
                    WinMove(NewX, NewY, , , winID)
                    repositioned++
                }
            }
        }

        if repositioned > 0
            Log("Repositioned " repositioned " window(s) to visible area")
    }

    ResizeWindows(monCount) {
        ; Adjust window sizes based on new configuration
        Log("Window resize adaptation: Adjusting for " monCount " monitor(s)")

        ; Example: Resize active window
        try {
            if WinExist("A") {
                MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)

                factor := monCount = 1 ? 0.8 : 0.6
                NewW := Round((Right - Left) * factor)
                NewH := Round((Bottom - Top) * factor)

                WinMove(, , NewW, NewH, "A")
                Log("Resized active window to " NewW "x" NewH)
            }
        }
    }

    Log(message) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " message "`r`n"

        ; Scroll to bottom
        SendMessage(0x115, 7, 0, txtLog)  ; WM_VSCROLL, SB_BOTTOM
    }

    UpdateStatus() {
        status := "Current: " currentCount " monitor(s) | "
        status .= "Auto-Adapt: " (chkReposition.Value || chkResize.Value ? "ON" : "OFF")
        txtStatus.Value := status
    }

    UpdateStatus()
}

;=============================================================================
; EXAMPLE 6: Monitor Count Alert System
;=============================================================================
; Alert system for unexpected monitor count changes
Example6_AlertSystem() {
    ; Create GUI
    g := Gui(, "Monitor Count Alert System")
    g.SetFont("s10")

    g.Add("Text", , "Alert Configuration:")

    g.Add("Text", "xm w150", "Expected Count:")
    edtExpected := g.Add("Edit", "x+10 w60", MonitorGetCount())

    g.Add("Text", "xm w150", "Check Interval (ms):")
    edtInterval := g.Add("Edit", "x+10 w60", "2000")

    chkSound := g.Add("Checkbox", "xm Checked", "Play sound on mismatch")
    chkPopup := g.Add("Checkbox", "xm Checked", "Show popup on mismatch")
    chkLog := g.Add("Checkbox", "xm Checked", "Log all checks")

    g.Add("Button", "xm w120", "Start Monitoring").OnEvent("Click", StartMonitoring)
    btnStop := g.Add("Button", "x+10 w120 Disabled", "Stop Monitoring")
    btnStop.OnEvent("Click", StopMonitoring)

    txtLog := g.Add("Edit", "xm w400 h200 ReadOnly +Multi")

    isMonitoring := false
    checkCount := 0

    g.Show()

    StartMonitoring(*) {
        expectedCount := Integer(edtExpected.Value)
        interval := Integer(edtInterval.Value)

        isMonitoring := true
        checkCount := 0

        SetTimer(CheckCount, interval)

        LogMessage("Monitoring started - Expecting " expectedCount " monitor(s)")
        btnStop.Enabled := true
    }

    StopMonitoring(*) {
        SetTimer(CheckCount, 0)
        isMonitoring := false
        LogMessage("Monitoring stopped after " checkCount " checks")
        btnStop.Enabled := false
    }

    CheckCount() {
        if !isMonitoring
            return

        checkCount++
        expectedCount := Integer(edtExpected.Value)
        actualCount := MonitorGetCount()

        if chkLog.Value
            LogMessage("Check #" checkCount ": " actualCount " monitor(s)")

        if actualCount != expectedCount {
            ; Alert!
            LogMessage("⚠ ALERT: Expected " expectedCount ", found " actualCount)

            if chkSound.Value
                SoundBeep(750, 200)

            if chkPopup.Value {
                MsgBox("Monitor count mismatch!`n`nExpected: " expectedCount "`nActual: " actualCount,
                       "Monitor Alert", "Icon! T3")
            }
        }
    }

    LogMessage(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 7: Monitor Configuration Validator
;=============================================================================
; Validates that required monitor count is met for application
Example7_ConfigurationValidator() {
    ; Create GUI
    g := Gui(, "Monitor Configuration Validator")
    g.SetFont("s10")

    g.Add("Text", "w400", "Application Requirements Validator")

    ; Define requirements
    requirements := [
        {Name: "Standard Mode", MinMonitors: 1, Recommended: 1},
        {Name: "Extended Mode", MinMonitors: 2, Recommended: 2},
        {Name: "Pro Mode", MinMonitors: 3, Recommended: 3},
        {Name: "Studio Mode", MinMonitors: 4, Recommended: 4}
    ]

    g.Add("Text", "xm Section", "Select Application Mode:")

    cmbMode := g.Add("ComboBox", "xs w250")
    for req in requirements
        cmbMode.Add([req.Name])
    cmbMode.Choose(1)

    g.Add("Button", "xs w200", "Validate Configuration").OnEvent("Click", Validate)

    txtResult := g.Add("Text", "xs w400 h250 +Border")

    g.Show()

    Validate(*) {
        currentCount := MonitorGetCount()
        selectedMode := cmbMode.Value
        req := requirements[selectedMode]

        result := "CONFIGURATION VALIDATION`n"
        result .= "========================`n`n"

        result .= "Mode: " req.Name "`n"
        result .= "Current Monitors: " currentCount "`n"
        result .= "Required: " req.MinMonitors "`n"
        result .= "Recommended: " req.Recommended "`n`n"

        if currentCount >= req.Recommended {
            result .= "Status: ✓ OPTIMAL`n"
            result .= "Your configuration meets all recommendations.`n"
        } else if currentCount >= req.MinMonitors {
            result .= "Status: ⚠ ACCEPTABLE`n"
            result .= "Minimum requirements met, but not optimal.`n"
            result .= "Consider adding " (req.Recommended - currentCount) " more monitor(s).`n"
        } else {
            result .= "Status: ✗ INSUFFICIENT`n"
            result .= "Configuration does not meet minimum requirements.`n"
            result .= "You need " (req.MinMonitors - currentCount) " more monitor(s).`n"
        }

        result .= "`nRECOMMENDATIONS:`n"
        if currentCount < req.MinMonitors {
            result .= "• Add " (req.MinMonitors - currentCount) " monitor(s) to use this mode`n"
            result .= "• Or select a mode requiring fewer monitors`n"
        } else if currentCount < req.Recommended {
            result .= "• Add " (req.Recommended - currentCount) " monitor(s) for optimal experience`n"
            result .= "• Current setup will work but may be limiting`n"
        } else {
            result .= "• Configuration is optimal for this mode`n"
            result .= "• All features fully supported`n"
        }

        txtResult.Value := result
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGetCount Detection Examples")
    g.SetFont("s10")

    g.Add("Text", "w450", "Monitor Count Detection & Change Monitoring:")

    g.Add("Button", "w450", "Example 1: Real-Time Monitor").OnEvent("Click", (*) => Example1_RealTimeMonitor())
    g.Add("Button", "w450", "Example 2: Change Detector").OnEvent("Click", (*) => Example2_ChangeDetector())
    g.Add("Button", "w450", "Example 3: Display Change Handler").OnEvent("Click", (*) => Example3_DisplayChangeHandler())
    g.Add("Button", "w450", "Example 4: History Tracker").OnEvent("Click", (*) => Example4_HistoryTracker())
    g.Add("Button", "w450", "Example 5: Adaptive Responder").OnEvent("Click", (*) => Example5_AdaptiveResponder())
    g.Add("Button", "w450", "Example 6: Alert System").OnEvent("Click", (*) => Example6_AlertSystem())
    g.Add("Button", "w450", "Example 7: Configuration Validator").OnEvent("Click", (*) => Example7_ConfigurationValidator())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
