/**
* @file BuiltIn_Pause_01.ahk
* @description Pause and resume script execution in AutoHotkey v2
* @author AutoHotkey v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*
* Pause temporarily halts the script's current thread. Useful for temporarily
* disabling hotkeys, controlling script execution, and creating pause/resume
* functionality in automation workflows.
*
* @syntax Pause [NewState]
* @param NewState - -1 (toggle), 0 (unpause), 1 (pause), or omit (toggle)
*
* @see https://www.autohotkey.com/docs/v2/lib/Pause.htm
* @requires AutoHotkey v2.0+
*/

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Basic Pause/Resume Control
; ============================================================================
/**
* Demonstrates basic Pause functionality
* Shows how to pause and resume script execution
*/
Example1_BasicPause() {
    myGui := Gui("+AlwaysOnTop", "Example 1: Basic Pause/Resume")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Script Pause/Resume Control")

    ; Status indicator
    myGui.SetFont("s16 Bold")
    statusText := myGui.Add("Text", "w500 Center vStatus", "Status: RUNNING")
    myGui.SetFont("s10 Norm")

    ; Activity counter
    counterText := myGui.Add("Text", "w500 Center vCounter", "Activity Count: 0")

    ; Log
    myGui.Add("Text", "xm", "Activity Log:")
    logBox := myGui.Add("Edit", "w500 h300 ReadOnly vLog")

    static activityCount := 0
    static isPaused := false

    ; Log helper
    LogActivity(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
        logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Background activity simulation
    BackgroundActivity() {
        if (isPaused)
        return

        activityCount++
        counterText.Value := "Activity Count: " activityCount
        LogActivity("Background activity #" activityCount " executed")
    }

    ; Start background activity
    SetTimer(BackgroundActivity, 1000)

    ; Control buttons
    pauseBtn := myGui.Add("Button", "xm w160", "Pause Script")
    resumeBtn := myGui.Add("Button", "w160 x+10", "Resume Script")
    toggleBtn := myGui.Add("Button", "w160 x+10", "Toggle Pause")

    myGui.Add("Text", "xm", "`nHotkey Info:")
    myGui.Add("Text", "w500", "Press Pause key to toggle pause state")

    ; Pause button
    pauseBtn.OnEvent("Click", (*) => PauseScript())
    PauseScript() {
        if (!isPaused) {
            Pause(1)  ; Pause on
            isPaused := true

            statusText.Value := "Status: PAUSED"
            statusText.SetFont("cRed")

            LogActivity(">>> Script PAUSED <<<")

            pauseBtn.Enabled := false
            resumeBtn.Enabled := true
        }
    }

    ; Resume button
    resumeBtn.OnEvent("Click", (*) => ResumeScript())
    ResumeScript() {
        if (isPaused) {
            Pause(0)  ; Pause off
            isPaused := false

            statusText.Value := "Status: RUNNING"
            statusText.SetFont("cGreen")

            LogActivity(">>> Script RESUMED <<<")

            pauseBtn.Enabled := true
            resumeBtn.Enabled := false
        }
    }

    ; Toggle button
    toggleBtn.OnEvent("Click", (*) => TogglePause())
    TogglePause() {
        if (isPaused) {
            ResumeScript()
        } else {
            PauseScript()
        }
    }

    ; Pause hotkey (Pause key)
    Pause:: {
        TogglePause()
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(BackgroundActivity, 0)
        myGui.Destroy()
    }

    resumeBtn.Enabled := false
    statusText.SetFont("cGreen")
    myGui.Show()

    LogActivity("Basic Pause/Resume demonstration started")
    LogActivity("Press Pause key or use buttons to control script")
}

; ============================================================================
; EXAMPLE 2: Selective Hotkey Pausing
; ============================================================================
/**
* Demonstrates pausing specific hotkeys while keeping others active
* Shows how to control which parts of script are paused
*/
Example2_SelectivePause() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Selective Hotkey Pausing")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Selective Hotkey Control")

    ; Status displays
    statusText := myGui.Add("Text", "w550 Center vStatus", "All Hotkeys: ACTIVE")

    myGui.Add("Text", "xm", "Hotkey Status:")
    hotkey1Text := myGui.Add("Text", "w270 Border vHK1", "F1 Hotkey: ACTIVE")
    hotkey2Text := myGui.Add("Text", "w270 x+10 Border vHK2", "F2 Hotkey: ACTIVE")

    ; Log
    myGui.Add("Text", "xm", "Hotkey Activity Log:")
    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

    static isF1Active := true
    static isF2Active := true
    static f1Count := 0
    static f2Count := 0

    ; Log helper
    LogHotkey(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
        logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; F1 hotkey handler
    F1Handler() {
        if (!isF1Active) {
            LogHotkey("F1 pressed but DISABLED")
            return
        }

        f1Count++
        LogHotkey("F1 triggered (count: " f1Count ")")
        ToolTip("F1 Hotkey Activated! Count: " f1Count)
        SetTimer(() => ToolTip(), -1000)
    }

    ; F2 hotkey handler
    F2Handler() {
        if (!isF2Active) {
            LogHotkey("F2 pressed but DISABLED")
            return
        }

        f2Count++
        LogHotkey("F2 triggered (count: " f2Count ")")
        ToolTip("F2 Hotkey Activated! Count: " f2Count)
        SetTimer(() => ToolTip(), -1000)
    }

    ; Register hotkeys
    Hotkey("F1", (*) => F1Handler())
    Hotkey("F2", (*) => F2Handler())

    ; Control buttons
    myGui.Add("Text", "xm", "`nHotkey Controls:")

    pauseF1Btn := myGui.Add("Button", "w130", "Disable F1")
    resumeF1Btn := myGui.Add("Button", "w130 x+10", "Enable F1")
    pauseF2Btn := myGui.Add("Button", "w130 x+10", "Disable F2")
    resumeF2Btn := myGui.Add("Button", "w130 x+10", "Enable F2")

    pauseAllBtn := myGui.Add("Button", "xm w270", "Disable All Hotkeys")
    resumeAllBtn := myGui.Add("Button", "w270 x+10", "Enable All Hotkeys")

    ; F1 controls
    pauseF1Btn.OnEvent("Click", (*) => DisableF1())
    DisableF1() {
        isF1Active := false
        hotkey1Text.Value := "F1 Hotkey: DISABLED"
        hotkey1Text.SetFont("cRed")
        LogHotkey("F1 hotkey disabled")

        pauseF1Btn.Enabled := false
        resumeF1Btn.Enabled := true
    }

    resumeF1Btn.OnEvent("Click", (*) => EnableF1())
    EnableF1() {
        isF1Active := true
        hotkey1Text.Value := "F1 Hotkey: ACTIVE"
        hotkey1Text.SetFont("cGreen")
        LogHotkey("F1 hotkey enabled")

        pauseF1Btn.Enabled := true
        resumeF1Btn.Enabled := false
    }

    ; F2 controls
    pauseF2Btn.OnEvent("Click", (*) => DisableF2())
    DisableF2() {
        isF2Active := false
        hotkey2Text.Value := "F2 Hotkey: DISABLED"
        hotkey2Text.SetFont("cRed")
        LogHotkey("F2 hotkey disabled")

        pauseF2Btn.Enabled := false
        resumeF2Btn.Enabled := true
    }

    resumeF2Btn.OnEvent("Click", (*) => EnableF2())
    EnableF2() {
        isF2Active := true
        hotkey2Text.Value := "F2 Hotkey: ACTIVE"
        hotkey2Text.SetFont("cGreen")
        LogHotkey("F2 hotkey enabled")

        pauseF2Btn.Enabled := true
        resumeF2Btn.Enabled := false
    }

    ; All hotkeys control
    pauseAllBtn.OnEvent("Click", (*) => DisableAll())
    DisableAll() {
        DisableF1()
        DisableF2()
        statusText.Value := "All Hotkeys: DISABLED"
        LogHotkey("=== All hotkeys disabled ===")
    }

    resumeAllBtn.OnEvent("Click", (*) => EnableAll())
    EnableAll() {
        EnableF1()
        EnableF2()
        statusText.Value := "All Hotkeys: ACTIVE"
        LogHotkey("=== All hotkeys enabled ===")
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        Hotkey("F1", "Off")
        Hotkey("F2", "Off")
        ToolTip()
        myGui.Destroy()
    }

    resumeF1Btn.Enabled := false
    resumeF2Btn.Enabled := false
    hotkey1Text.SetFont("cGreen")
    hotkey2Text.SetFont("cGreen")

    myGui.Show()

    LogHotkey("Selective Hotkey Pausing demonstration started")
    LogHotkey("Press F1 or F2 to test hotkeys")
}

; ============================================================================
; EXAMPLE 3: Timed Pause/Resume
; ============================================================================
/**
* Demonstrates automatic pause and resume with timers
* Useful for scheduled script suspension
*/
Example3_TimedPause() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Timed Pause/Resume")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Scheduled Pause/Resume Operations")

    ; Status
    myGui.SetFont("s14 Bold")
    statusText := myGui.Add("Text", "w500 Center vStatus", "Status: RUNNING")
    myGui.SetFont("s10 Norm")

    ; Countdown display
    countdownText := myGui.Add("Text", "w500 Center vCountdown", "Next Event: --")

    ; Activity monitor
    activityText := myGui.Add("Text", "w500 Center vActivity", "Activities: 0")

    ; Log
    myGui.Add("Text", "xm", "Event Log:")
    logBox := myGui.Add("Edit", "w500 h250 ReadOnly vLog")

    static activityCount := 0
    static isPaused := false
    static nextEventTime := 0
    static eventType := ""

    ; Log helper
    LogEvent(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
        logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Background activity
    BackgroundActivity() {
        if (isPaused)
        return

        activityCount++
        activityText.Value := "Activities: " activityCount
    }

    SetTimer(BackgroundActivity, 500)

    ; Update countdown
    UpdateCountdown() {
        if (nextEventTime = 0) {
            countdownText.Value := "Next Event: --"
            return
        }

        remaining := Round((nextEventTime - A_TickCount) / 1000)

        if (remaining <= 0) {
            countdownText.Value := "Next Event: NOW!"
        } else {
            countdownText.Value := "Next Event: " eventType " in " remaining "s"
        }
    }

    SetTimer(UpdateCountdown, 100)

    ; Pause for duration
    PauseForDuration(seconds) {
        LogEvent("Scheduling pause for " seconds " seconds")

        nextEventTime := A_TickCount + (seconds * 1000)
        eventType := "PAUSE"

        SetTimer(() => ExecutePause(), -(seconds * 1000))
    }

    ExecutePause() {
        Pause(1)
        isPaused := true

        statusText.Value := "Status: PAUSED"
        statusText.SetFont("cRed")

        LogEvent(">>> PAUSED by timer <<<")

        nextEventTime := 0
        eventType := ""
    }

    ; Resume after duration
    ResumeAfterDuration(seconds) {
        LogEvent("Scheduling resume for " seconds " seconds")

        nextEventTime := A_TickCount + (seconds * 1000)
        eventType := "RESUME"

        SetTimer(() => ExecuteResume(), -(seconds * 1000))
    }

    ExecuteResume() {
        Pause(0)
        isPaused := false

        statusText.Value := "Status: RUNNING"
        statusText.SetFont("cGreen")

        LogEvent(">>> RESUMED by timer <<<")

        nextEventTime := 0
        eventType := ""
    }

    ; Pause/Resume cycle
    PauseResumeCycle(pauseDuration, resumeDuration, cycles) {
        LogEvent("Starting pause/resume cycle: " cycles " cycles")
        LogEvent("Pause: " pauseDuration "s, Resume: " resumeDuration "s")

        currentCycle := 0

        CycleStep() {
            currentCycle++

            if (currentCycle > cycles * 2) {
                LogEvent("=== Cycle complete ===")
                return
            }

            if (Mod(currentCycle, 2) = 1) {
                ; Pause phase
                ExecutePause()
                SetTimer(CycleStep, -(pauseDuration * 1000))
            } else {
                ; Resume phase
                ExecuteResume()

                if (currentCycle < cycles * 2) {
                    SetTimer(CycleStep, -(resumeDuration * 1000))
                }
            }
        }

        CycleStep()
    }

    ; Control buttons
    myGui.Add("Text", "xm", "`nTimed Operations:")

    pause5sBtn := myGui.Add("Button", "w160", "Pause for 5s")
    pause10sBtn := myGui.Add("Button", "w160 x+10", "Pause for 10s")
    resume5sBtn := myGui.Add("Button", "w160 x+10", "Resume in 5s")

    myGui.Add("Text", "xm", "`nCycle Operations:")
    cycle3Btn := myGui.Add("Button", "w240", "Cycle: 3x (3s pause / 3s run)")
    cycle5Btn := myGui.Add("Button", "w240 x+10", "Cycle: 5x (2s pause / 4s run)")

    manualPauseBtn := myGui.Add("Button", "xm w240", "Manual Pause")
    manualResumeBtn := myGui.Add("Button", "w240 x+10", "Manual Resume")

    ; Button handlers
    pause5sBtn.OnEvent("Click", (*) => PauseForDuration(5))
    pause10sBtn.OnEvent("Click", (*) => PauseForDuration(10))
    resume5sBtn.OnEvent("Click", (*) => ResumeAfterDuration(5))

    cycle3Btn.OnEvent("Click", (*) => PauseResumeCycle(3, 3, 3))
    cycle5Btn.OnEvent("Click", (*) => PauseResumeCycle(2, 4, 5))

    manualPauseBtn.OnEvent("Click", (*) => ManualPause())
    ManualPause() {
        ExecutePause()
        manualPauseBtn.Enabled := false
        manualResumeBtn.Enabled := true
    }

    manualResumeBtn.OnEvent("Click", (*) => ManualResume())
    ManualResume() {
        ExecuteResume()
        manualPauseBtn.Enabled := true
        manualResumeBtn.Enabled := false
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(BackgroundActivity, 0)
        SetTimer(UpdateCountdown, 0)
        myGui.Destroy()
    }

    manualResumeBtn.Enabled := false
    statusText.SetFont("cGreen")
    myGui.Show()

    LogEvent("Timed Pause/Resume demonstration started")
}

; ============================================================================
; EXAMPLE 4: Pause with User Notification
; ============================================================================
/**
* Demonstrates pause with visual and audio notifications
* Provides clear feedback when script is paused
*/
Example4_PauseNotifications() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Pause Notifications")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Pause with Visual/Audio Feedback")

    ; Visual status indicator
    myGui.SetFont("s24 Bold")
    indicatorText := myGui.Add("Text", "w500 h80 Center Border vIndicator", "● RUNNING")
    myGui.SetFont("s10 Norm")

    ; Statistics
    statsText := myGui.Add("Text", "w500 Center vStats",
    "Total Pauses: 0 | Total Resume: 0 | Pause Time: 0s")

    ; Log
    myGui.Add("Text", "xm", "Activity Log:")
    logBox := myGui.Add("Edit", "w500 h250 ReadOnly vLog")

    static isPaused := false
    static pauseCount := 0
    static resumeCount := 0
    static pauseStartTime := 0
    static totalPauseTime := 0

    ; Log helper
    LogMsg(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
        logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Update statistics
    UpdateStats() {
        pauseTimeSeconds := Round(totalPauseTime / 1000)
        statsText.Value := "Total Pauses: " pauseCount
        . " | Total Resumes: " resumeCount
        . " | Total Pause Time: " pauseTimeSeconds "s"
    }

    ; Pause with notification
    PauseWithNotification() {
        if (isPaused)
        return

        Pause(1)
        isPaused := true
        pauseCount++
        pauseStartTime := A_TickCount

        ; Visual feedback
        indicatorText.Value := "⏸ PAUSED"
        indicatorText.SetFont("cRed")
        indicatorText.Opt("BackgroundFFCCCC")

        ; Audio feedback
        SoundBeep(800, 200)
        Sleep(100)
        SoundBeep(600, 200)

        ; Tray tip notification
        TrayTip("Script Paused", "The script has been paused.", "Icon!")

        ; Tooltip
        ToolTip("SCRIPT PAUSED", A_ScreenWidth - 200, 50)

        LogMsg(">>> SCRIPT PAUSED with notifications <<<")
        UpdateStats()
    }

    ; Resume with notification
    ResumeWithNotification() {
        if (!isPaused)
        return

        Pause(0)
        isPaused := false
        resumeCount++

        ; Calculate pause duration
        pauseDuration := A_TickCount - pauseStartTime
        totalPauseTime += pauseDuration

        ; Visual feedback
        indicatorText.Value := "● RUNNING"
        indicatorText.SetFont("cGreen")
        indicatorText.Opt("BackgroundCCFFCC")

        ; Audio feedback
        SoundBeep(600, 200)
        Sleep(100)
        SoundBeep(800, 200)

        ; Tray tip notification
        TrayTip("Script Resumed", "The script is now running.", "Icon!")

        ; Clear tooltip
        ToolTip()

        LogMsg(">>> SCRIPT RESUMED (was paused for " Round(pauseDuration / 1000, 1) "s) <<<")
        UpdateStats()
    }

    ; Toggle with notification
    ToggleWithNotification() {
        if (isPaused) {
            ResumeWithNotification()
        } else {
            PauseWithNotification()
        }
    }

    ; Control buttons
    pauseBtn := myGui.Add("Button", "xm w160", "Pause")
    resumeBtn := myGui.Add("Button", "w160 x+10", "Resume")
    toggleBtn := myGui.Add("Button", "w160 x+10", "Toggle")

    resetStatsBtn := myGui.Add("Button", "xm w500", "Reset Statistics")

    pauseBtn.OnEvent("Click", (*) => PauseWithNotification())
    resumeBtn.OnEvent("Click", (*) => ResumeWithNotification())
    toggleBtn.OnEvent("Click", (*) => ToggleWithNotification())

    resetStatsBtn.OnEvent("Click", (*) => ResetStats())
    ResetStats() {
        pauseCount := 0
        resumeCount := 0
        totalPauseTime := 0
        UpdateStats()
        LogMsg("Statistics reset")
    }

    ; Hotkey
    Pause:: {
        ToggleWithNotification()
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        ToolTip()
        TrayTip()
        myGui.Destroy()
    }

    indicatorText.SetFont("cGreen")
    indicatorText.Opt("BackgroundCCFFCC")
    myGui.Show()

    LogMsg("Pause Notifications demonstration started")
    LogMsg("Press Pause key or use buttons to control")
}

; ============================================================================
; EXAMPLE 5: Conditional Pause System
; ============================================================================
/**
* Implements conditional pausing based on system state
* Automatically pauses during specific conditions
*/
Example5_ConditionalPause() {
    myGui := Gui("+AlwaysOnTop", "Example 5: Conditional Pause")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Conditional Auto-Pause System")

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Status: RUNNING (monitoring)")

    ; Conditions
    myGui.Add("Text", "xm", "Auto-Pause Conditions:")
    cond1 := myGui.Add("Checkbox", "xm Checked vCond1", "Pause when specific window is active")
    cond2 := myGui.Add("Checkbox", "xm Checked vCond2", "Pause when idle for > 30 seconds")
    cond3 := myGui.Add("Checkbox", "xm Checked vCond3", "Pause during specific time range")

    ; Settings
    myGui.Add("Text", "xm", "`nWindow Title to Monitor:")
    windowEdit := myGui.Add("Edit", "w400", "Notepad")

    myGui.Add("Text", "xm", "Pause Time Range:")
    startTimeEdit := myGui.Add("Edit", "w100", "22:00")
    myGui.Add("Text", "x+5", "to")
    endTimeEdit := myGui.Add("Edit", "w100 x+5", "08:00")

    ; Log
    myGui.Add("Text", "xm", "Condition Log:")
    logBox := myGui.Add("Edit", "w550 h200 ReadOnly vLog")

    static isPaused := false
    static isMonitoring := false
    static lastActivityTime := A_TickCount

    ; Log helper
    LogCondition(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
        logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Check conditions
    CheckConditions() {
        if (!isMonitoring)
        return

        shouldPause := false
        reason := ""

        ; Check window condition
        if (cond1.Value) {
            windowTitle := windowEdit.Value
            if (WinExist(windowTitle)) {
                shouldPause := true
                reason := "Monitored window active: " windowTitle
            }
        }

        ; Check idle condition
        if (cond2.Value && !shouldPause) {
            idleTime := A_TickCount - lastActivityTime
            if (idleTime > 30000) {  ; 30 seconds
            shouldPause := true
            reason := "System idle for " Round(idleTime / 1000) " seconds"
        }
    }

    ; Check time range condition
    if (cond3.Value && !shouldPause) {
        currentTime := FormatTime(, "HH:mm")
        startTime := startTimeEdit.Value
        endTime := endTimeEdit.Value

        ; Simple time range check (doesn't handle midnight wrap perfectly)
        if (startTime > endTime) {
            ; Range crosses midnight
            if (currentTime >= startTime || currentTime <= endTime) {
                shouldPause := true
                reason := "Current time in pause range (" startTime " - " endTime ")"
            }
        } else {
            ; Normal range
            if (currentTime >= startTime && currentTime <= endTime) {
                shouldPause := true
                reason := "Current time in pause range (" startTime " - " endTime ")"
            }
        }
    }

    ; Apply pause state
    if (shouldPause && !isPaused) {
        AutoPause(reason)
    } else if (!shouldPause && isPaused) {
        AutoResume()
    }
}

; Auto pause
AutoPause(reason) {
    Pause(1)
    isPaused := true

    statusText.Value := "Status: AUTO-PAUSED"
    LogCondition("AUTO-PAUSED: " reason)
}

; Auto resume
AutoResume() {
    Pause(0)
    isPaused := false

    statusText.Value := "Status: RUNNING (monitoring)"
    LogCondition("AUTO-RESUMED: Conditions no longer met")
}

; Start/stop monitoring
startMonitorBtn := myGui.Add("Button", "xm w270", "Start Monitoring")
stopMonitorBtn := myGui.Add("Button", "w270 x+10", "Stop Monitoring")

startMonitorBtn.OnEvent("Click", (*) => StartMonitoring())
StartMonitoring() {
    isMonitoring := true
    SetTimer(CheckConditions, 1000)  ; Check every second

    statusText.Value := "Status: RUNNING (monitoring)"
    LogCondition("Conditional monitoring started")

    startMonitorBtn.Enabled := false
    stopMonitorBtn.Enabled := true
}

stopMonitorBtn.OnEvent("Click", (*) => StopMonitoring())
StopMonitoring() {
    isMonitoring := false
    SetTimer(CheckConditions, 0)

    if (isPaused) {
        Pause(0)
        isPaused := false
    }

    statusText.Value := "Status: RUNNING (not monitoring)"
    LogCondition("Conditional monitoring stopped")

    startMonitorBtn.Enabled := true
    stopMonitorBtn.Enabled := false
}

; Simulate activity (resets idle timer)
activityBtn := myGui.Add("Button", "xm w550", "Simulate Activity (Reset Idle Timer)")
activityBtn.OnEvent("Click", (*) => SimulateActivity())

SimulateActivity() {
    lastActivityTime := A_TickCount
    LogCondition("Activity detected - idle timer reset")
}

; Cleanup
myGui.OnEvent("Close", (*) => Cleanup())
Cleanup() {
    SetTimer(CheckConditions, 0)
    myGui.Destroy()
}

stopMonitorBtn.Enabled := false
myGui.Show()

LogCondition("Conditional Pause system ready")
LogCondition("Click 'Start Monitoring' to begin automatic pause checks")
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "Pause Examples")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Pause/Resume Examples")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Basic Pause/Resume").OnEvent("Click", (*) => Example1_BasicPause())
MainMenu.Add("Button", "w450", "Example 2: Selective Hotkey Pausing").OnEvent("Click", (*) => Example2_SelectivePause())
MainMenu.Add("Button", "w450", "Example 3: Timed Pause/Resume").OnEvent("Click", (*) => Example3_TimedPause())
MainMenu.Add("Button", "w450", "Example 4: Pause Notifications").OnEvent("Click", (*) => Example4_PauseNotifications())
MainMenu.Add("Button", "w450", "Example 5: Conditional Pause").OnEvent("Click", (*) => Example5_ConditionalPause())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
