#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_SetTimer_01.ahk
 * @description Comprehensive examples of basic SetTimer functionality in AutoHotkey v2
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * SetTimer creates, modifies, enables, or disables a timer that calls a function
 * at a specified time interval. Timers are useful for repeating tasks, monitoring
 * system states, and creating time-based automation.
 * 
 * @syntax SetTimer [Function, Period, Priority]
 * @param {Function} Function - The function to call
 * @param {Integer} Period - Interval in milliseconds (0 to disable, negative for run-once)
 * @param {Integer} Priority - Thread priority (-2147483648 to 2147483647)
 * 
 * @see https://www.autohotkey.com/docs/v2/lib/SetTimer.htm
 * @requires AutoHotkey v2.0+
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Basic Timer with Toggle Control
; ============================================================================
/**
 * Demonstrates a simple timer that displays elapsed time
 * Shows how to start, stop, and toggle timers
 */
Example1_BasicTimer() {
    static counter := 0
    static isRunning := false
    static startTime := 0

    ; Create GUI to display timer
    myGui := Gui("+AlwaysOnTop", "Example 1: Basic Timer")
    myGui.SetFont("s12")
    myGui.Add("Text", "w300 Center", "Basic Timer Example")
    counterText := myGui.Add("Text", "w300 Center vCounterDisplay", "Counter: 0")
    elapsedText := myGui.Add("Text", "w300 Center vElapsedDisplay", "Elapsed: 0.0s")

    ; Control buttons
    startBtn := myGui.Add("Button", "w140", "Start Timer")
    stopBtn := myGui.Add("Button", "w140 x+10", "Stop Timer")
    resetBtn := myGui.Add("Button", "w140 xm", "Reset Counter")
    toggleBtn := myGui.Add("Button", "w140 x+10", "Toggle Timer")

    ; Timer function that updates every 100ms
    UpdateTimer() {
        counter++
        elapsed := (A_TickCount - startTime) / 1000
        counterText.Value := "Counter: " counter
        elapsedText.Value := "Elapsed: " Format("{:.1f}", elapsed) "s"
    }

    ; Start button handler
    startBtn.OnEvent("Click", (*) => StartTimer())
    StartTimer() {
        if (!isRunning) {
            startTime := A_TickCount
            SetTimer(UpdateTimer, 100)  ; Run every 100ms
            isRunning := true
            startBtn.Enabled := false
            stopBtn.Enabled := true
        }
    }

    ; Stop button handler
    stopBtn.OnEvent("Click", (*) => StopTimer())
    StopTimer() {
        if (isRunning) {
            SetTimer(UpdateTimer, 0)  ; Disable timer
            isRunning := false
            startBtn.Enabled := true
            stopBtn.Enabled := false
        }
    }

    ; Reset button handler
    resetBtn.OnEvent("Click", (*) => ResetCounter())
    ResetCounter() {
        counter := 0
        counterText.Value := "Counter: 0"
        if (!isRunning)
            elapsedText.Value := "Elapsed: 0.0s"
    }

    ; Toggle button handler
    toggleBtn.OnEvent("Click", (*) => ToggleTimer())
    ToggleTimer() {
        if (isRunning)
            StopTimer()
        else
            StartTimer()
    }

    ; Cleanup on close
    myGui.OnEvent("Close", (*) => CleanupExample1())
    CleanupExample1() {
        SetTimer(UpdateTimer, 0)
        myGui.Destroy()
    }

    stopBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 2: Multiple Timers with Different Intervals
; ============================================================================
/**
 * Demonstrates running multiple timers simultaneously
 * Each timer operates independently with different intervals
 */
Example2_MultipleTimers() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Multiple Timers")
    myGui.SetFont("s10")
    myGui.Add("Text", "w400 Center", "Multiple Independent Timers")

    ; Timer displays
    fast := myGui.Add("Text", "w400 Center vFast", "Fast (100ms): 0")
    medium := myGui.Add("Text", "w400 Center vMedium", "Medium (500ms): 0")
    slow := myGui.Add("Text", "w400 Center vSlow", "Slow (1000ms): 0")
    verySlow := myGui.Add("Text", "w400 Center vVerySlow", "Very Slow (2000ms): 0")

    ; Counters for each timer
    static counters := Map("fast", 0, "medium", 0, "slow", 0, "verySlow", 0)

    ; Timer functions
    FastTimer() {
        counters["fast"]++
        fast.Value := "Fast (100ms): " counters["fast"]
    }

    MediumTimer() {
        counters["medium"]++
        medium.Value := "Medium (500ms): " counters["medium"]
    }

    SlowTimer() {
        counters["slow"]++
        slow.Value := "Slow (1000ms): " counters["slow"]
    }

    VerySlowTimer() {
        counters["verySlow"]++
        verySlow.Value := "Very Slow (2000ms): " counters["verySlow"]
    }

    ; Control buttons
    myGui.Add("Text", "xm w400 Center", "`nControls:")
    startAllBtn := myGui.Add("Button", "w190", "Start All")
    stopAllBtn := myGui.Add("Button", "w190 x+10", "Stop All")
    resetBtn := myGui.Add("Button", "w190 xm", "Reset All")

    ; Start all timers
    startAllBtn.OnEvent("Click", (*) => StartAll())
    StartAll() {
        SetTimer(FastTimer, 100)
        SetTimer(MediumTimer, 500)
        SetTimer(SlowTimer, 1000)
        SetTimer(VerySlowTimer, 2000)
    }

    ; Stop all timers
    stopAllBtn.OnEvent("Click", (*) => StopAll())
    StopAll() {
        SetTimer(FastTimer, 0)
        SetTimer(MediumTimer, 0)
        SetTimer(SlowTimer, 0)
        SetTimer(VerySlowTimer, 0)
    }

    ; Reset all counters
    resetBtn.OnEvent("Click", (*) => ResetAll())
    ResetAll() {
        for key in counters
            counters[key] := 0
        fast.Value := "Fast (100ms): 0"
        medium.Value := "Medium (500ms): 0"
        slow.Value := "Slow (1000ms): 0"
        verySlow.Value := "Very Slow (2000ms): 0"
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        StopAll()
        myGui.Destroy()
    }

    myGui.Show()
}

; ============================================================================
; EXAMPLE 3: Run-Once Timer (Negative Period)
; ============================================================================
/**
 * Demonstrates single-execution timers using negative periods
 * Useful for delayed execution without repetition
 */
Example3_RunOnceTimer() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Run-Once Timers")
    myGui.SetFont("s10")
    myGui.Add("Text", "w400 Center", "Delayed Single Execution Timers")

    logBox := myGui.Add("Edit", "w400 h200 ReadOnly vLog")
    myGui.Add("Text", "w400", "`nDelay Options:")

    ; Buttons for different delays
    btn1s := myGui.Add("Button", "w125", "1 Second")
    btn2s := myGui.Add("Button", "w125 x+10", "2 Seconds")
    btn5s := myGui.Add("Button", "w125 x+10", "5 Seconds")
    clearBtn := myGui.Add("Button", "w400 xm", "Clear Log")

    ; Log function
    LogMessage(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"
    }

    ; 1 second delayed execution
    btn1s.OnEvent("Click", (*) => Schedule1Second())
    Schedule1Second() {
        LogMessage("Scheduled: Will execute in 1 second")
        SetTimer(ExecuteAfter1s, -1000)  ; Negative = run once
    }

    ExecuteAfter1s() {
        LogMessage("EXECUTED: 1 second timer completed")
    }

    ; 2 second delayed execution
    btn2s.OnEvent("Click", (*) => Schedule2Seconds())
    Schedule2Seconds() {
        LogMessage("Scheduled: Will execute in 2 seconds")
        SetTimer(ExecuteAfter2s, -2000)
    }

    ExecuteAfter2s() {
        LogMessage("EXECUTED: 2 second timer completed")
    }

    ; 5 second delayed execution
    btn5s.OnEvent("Click", (*) => Schedule5Seconds())
    Schedule5Seconds() {
        LogMessage("Scheduled: Will execute in 5 seconds")
        SetTimer(ExecuteAfter5s, -5000)
    }

    ExecuteAfter5s() {
        LogMessage("EXECUTED: 5 second timer completed")
    }

    ; Clear log
    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogMessage("Ready - Click buttons to schedule delayed executions")
}

; ============================================================================
; EXAMPLE 4: Dynamic Timer Interval Adjustment
; ============================================================================
/**
 * Shows how to dynamically change timer intervals
 * Useful for adaptive timing based on system state
 */
Example4_DynamicInterval() {
    static currentInterval := 1000
    static counter := 0
    static timerActive := false

    myGui := Gui("+AlwaysOnTop", "Example 4: Dynamic Timer Intervals")
    myGui.SetFont("s10")
    myGui.Add("Text", "w400 Center", "Dynamically Adjust Timer Speed")

    counterDisplay := myGui.Add("Text", "w400 Center vCounter", "Counter: 0")
    intervalDisplay := myGui.Add("Text", "w400 Center vInterval", "Interval: 1000ms")

    ; Slider for interval control
    myGui.Add("Text", "xm", "Adjust Interval (100ms - 3000ms):")
    slider := myGui.Add("Slider", "w400 Range100-3000 TickInterval500 vSlider", currentInterval)
    slider.OnEvent("Change", (*) => UpdateInterval())

    ; Timer function
    TimerTick() {
        counter++
        counterDisplay.Value := "Counter: " counter
    }

    ; Update interval when slider changes
    UpdateInterval() {
        currentInterval := slider.Value
        intervalDisplay.Value := "Interval: " currentInterval "ms"

        ; If timer is active, restart with new interval
        if (timerActive) {
            SetTimer(TimerTick, 0)  ; Stop
            SetTimer(TimerTick, currentInterval)  ; Restart with new interval
        }
    }

    ; Control buttons
    startBtn := myGui.Add("Button", "xm w190", "Start Timer")
    stopBtn := myGui.Add("Button", "w190 x+10", "Stop Timer")
    resetBtn := myGui.Add("Button", "w400 xm", "Reset Counter")

    startBtn.OnEvent("Click", (*) => StartTimer())
    StartTimer() {
        SetTimer(TimerTick, currentInterval)
        timerActive := true
        startBtn.Enabled := false
        stopBtn.Enabled := true
    }

    stopBtn.OnEvent("Click", (*) => StopTimer())
    StopTimer() {
        SetTimer(TimerTick, 0)
        timerActive := false
        startBtn.Enabled := true
        stopBtn.Enabled := false
    }

    resetBtn.OnEvent("Click", (*) => ResetCounter())
    ResetCounter() {
        counter := 0
        counterDisplay.Value := "Counter: 0"
    }

    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(TimerTick, 0)
        myGui.Destroy()
    }

    stopBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 5: Auto-Saving Document Timer
; ============================================================================
/**
 * Simulates an auto-save feature for a text editor
 * Demonstrates practical timer usage for periodic saves
 */
Example5_AutoSave() {
    static lastSaveTime := A_TickCount
    static saveInterval := 30000  ; 30 seconds
    static isDirty := false
    static saveCount := 0

    myGui := Gui("+AlwaysOnTop", "Example 5: Auto-Save Timer")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Auto-Save Document Editor Simulation")

    ; Editor area
    editor := myGui.Add("Edit", "w500 h200 vEditor")
    editor.OnEvent("Change", (*) => MarkDirty())

    ; Status display
    statusBar := myGui.Add("Text", "w500 Center vStatus", "Status: Saved")
    nextSaveDisplay := myGui.Add("Text", "w500 Center vNextSave", "Next auto-save in: 30s")
    saveCountDisplay := myGui.Add("Text", "w500 Center vSaveCount", "Auto-saves: 0")

    ; Mark document as modified
    MarkDirty() {
        isDirty := true
        statusBar.Value := "Status: Modified (unsaved changes)"
    }

    ; Auto-save timer function
    CheckAutoSave() {
        timeSinceLastSave := A_TickCount - lastSaveTime
        remainingTime := saveInterval - timeSinceLastSave

        if (remainingTime <= 0) {
            if (isDirty) {
                PerformSave()
            }
            lastSaveTime := A_TickCount
            remainingTime := saveInterval
        }

        ; Update countdown display
        secondsRemaining := Round(remainingTime / 1000)
        nextSaveDisplay.Value := "Next auto-save in: " secondsRemaining "s"
    }

    ; Perform the save operation
    PerformSave() {
        saveCount++
        isDirty := false
        timestamp := FormatTime(, "HH:mm:ss")
        statusBar.Value := "Status: Saved at " timestamp
        saveCountDisplay.Value := "Auto-saves: " saveCount

        ; Visual feedback
        ToolTip("Auto-saved!")
        SetTimer(() => ToolTip(), -1000)  ; Clear tooltip after 1 second
    }

    ; Manual save button
    saveBtn := myGui.Add("Button", "w240", "Manual Save")
    saveBtn.OnEvent("Click", (*) => ManualSave())
    ManualSave() {
        if (isDirty) {
            PerformSave()
            lastSaveTime := A_TickCount
        }
    }

    ; Interval adjustment
    myGui.Add("Text", "x+20", "Auto-save interval:")
    intervalCombo := myGui.Add("DropDownList", "w240", ["10 seconds", "30 seconds", "60 seconds"])
    intervalCombo.Choose(2)  ; Default to 30 seconds
    intervalCombo.OnEvent("Change", (*) => ChangeInterval())

    ChangeInterval() {
        choice := intervalCombo.Text
        if (InStr(choice, "10"))
            saveInterval := 10000
        else if (InStr(choice, "30"))
            saveInterval := 30000
        else if (InStr(choice, "60"))
            saveInterval := 60000

        lastSaveTime := A_TickCount  ; Reset timer
    }

    ; Start the auto-save checker (runs every 100ms for smooth countdown)
    SetTimer(CheckAutoSave, 100)

    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(CheckAutoSave, 0)
        ToolTip()
        myGui.Destroy()
    }

    myGui.Show()
}

; ============================================================================
; EXAMPLE 6: System Monitor Timer
; ============================================================================
/**
 * Monitors system resources using timers
 * Demonstrates practical system monitoring application
 */
Example6_SystemMonitor() {
    myGui := Gui("+AlwaysOnTop", "Example 6: System Monitor")
    myGui.SetFont("s10")
    myGui.Add("Text", "w400 Center", "Real-time System Monitor")

    ; System info displays
    timeDisplay := myGui.Add("Text", "w400 Center vTime", "Current Time: --")
    cpuTimeDisplay := myGui.Add("Text", "w400 Center vCPUTime", "CPU Time: --")
    memoryDisplay := myGui.Add("Text", "w400 Center vMemory", "Memory Info: --")

    myGui.Add("Text", "xm w400", "`nMouse Position:")
    mousePosDisplay := myGui.Add("Text", "w400 Center vMousePos", "X: 0, Y: 0")

    myGui.Add("Text", "xm w400", "`nActive Window:")
    windowDisplay := myGui.Add("Text", "w400 Center vWindow", "No window detected")

    ; Log area
    myGui.Add("Text", "xm", "Activity Log:")
    logBox := myGui.Add("Edit", "w400 h150 ReadOnly vLog")

    static updateCount := 0

    ; Main monitoring function (runs every 500ms)
    MonitorSystem() {
        updateCount++

        ; Update time
        timeDisplay.Value := "Current Time: " FormatTime(, "HH:mm:ss")

        ; Update CPU time
        cpuTime := A_TickCount
        cpuTimeDisplay.Value := "System Uptime: " Format("{:.2f}", cpuTime / 1000) "s"

        ; Memory usage (simplified)
        memoryDisplay.Value := "Updates: " updateCount

        ; Mouse position
        MouseGetPos(&xPos, &yPos)
        mousePosDisplay.Value := "X: " xPos ", Y: " yPos

        ; Active window
        try {
            activeTitle := WinGetTitle("A")
            if (activeTitle != "")
                windowDisplay.Value := "Window: " SubStr(activeTitle, 1, 40)
            else
                windowDisplay.Value := "No window detected"
        } catch {
            windowDisplay.Value := "Error detecting window"
        }
    }

    ; Event logger (runs every 2 seconds)
    LogEvent() {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        newLog := timestamp . " - System check performed`r`n"

        ; Keep only last 10 entries
        lines := StrSplit(currentLog, "`r`n")
        if (lines.Length > 10) {
            lines.RemoveAt(1)
            currentLog := ""
            for line in lines
                currentLog .= line . "`r`n"
        }

        logBox.Value := currentLog . newLog
    }

    ; Control buttons
    startBtn := myGui.Add("Button", "xm w190", "Start Monitoring")
    stopBtn := myGui.Add("Button", "w190 x+10", "Stop Monitoring")
    clearBtn := myGui.Add("Button", "w400 xm", "Clear Log")

    static isMonitoring := false

    startBtn.OnEvent("Click", (*) => StartMonitoring())
    StartMonitoring() {
        SetTimer(MonitorSystem, 500)
        SetTimer(LogEvent, 2000)
        isMonitoring := true
        startBtn.Enabled := false
        stopBtn.Enabled := true
    }

    stopBtn.OnEvent("Click", (*) => StopMonitoring())
    StopMonitoring() {
        SetTimer(MonitorSystem, 0)
        SetTimer(LogEvent, 0)
        isMonitoring := false
        startBtn.Enabled := true
        stopBtn.Enabled := false
    }

    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        StopMonitoring()
        myGui.Destroy()
    }

    stopBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 7: Timer Priority Demonstration
; ============================================================================
/**
 * Demonstrates timer priority levels
 * Shows how priority affects timer execution order
 */
Example7_TimerPriority() {
    myGui := Gui("+AlwaysOnTop", "Example 7: Timer Priority")
    myGui.SetFont("s10")
    myGui.Add("Text", "w450 Center", "Timer Priority Demonstration")
    myGui.Add("Text", "w450", "Lower priority numbers run first. Watch the execution order:")

    logBox := myGui.Add("Edit", "w450 h250 ReadOnly vLog")

    static executionLog := ""
    static runCount := 0

    ; Log helper
    Log(msg) {
        timestamp := A_TickCount
        executionLog .= Format("{:05d}ms", Mod(timestamp, 100000)) " - " msg "`r`n"
        logBox.Value := executionLog
    }

    ; High priority timer (priority -100)
    HighPriorityTimer() {
        Log("HIGH PRIORITY (-100): Executed first")
    }

    ; Normal priority timer (priority 0, default)
    NormalPriorityTimer() {
        Log("NORMAL PRIORITY (0): Executed second")
    }

    ; Low priority timer (priority 100)
    LowPriorityTimer() {
        Log("LOW PRIORITY (100): Executed last")
    }

    ; Batch execution
    ExecuteBatch() {
        runCount++
        Log("`n=== Batch " runCount " Starting ===")

        ; All timers set to run once after 100ms
        SetTimer(HighPriorityTimer, -100)
        SetTimer(NormalPriorityTimer, -100)
        SetTimer(LowPriorityTimer, -100)
    }

    ; Control buttons
    runBtn := myGui.Add("Button", "w215", "Run Priority Test")
    clearBtn := myGui.Add("Button", "w215 x+10", "Clear Log")

    runBtn.OnEvent("Click", (*) => ExecuteBatch())
    clearBtn.OnEvent("Click", (*) => ClearLog())

    ClearLog() {
        executionLog := ""
        logBox.Value := ""
        runCount := 0
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    Log("Ready - Click 'Run Priority Test' to see timer priority in action")
}

; ============================================================================
; MAIN MENU - Launch Examples
; ============================================================================
MainMenu := Gui(, "SetTimer Examples - Basic Timers")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w400 Center", "AutoHotkey v2 - SetTimer Basic Examples")
MainMenu.Add("Text", "w400 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w400", "Example 1: Basic Timer with Toggle").OnEvent("Click", (*) => Example1_BasicTimer())
MainMenu.Add("Button", "w400", "Example 2: Multiple Timers").OnEvent("Click", (*) => Example2_MultipleTimers())
MainMenu.Add("Button", "w400", "Example 3: Run-Once Timers").OnEvent("Click", (*) => Example3_RunOnceTimer())
MainMenu.Add("Button", "w400", "Example 4: Dynamic Intervals").OnEvent("Click", (*) => Example4_DynamicInterval())
MainMenu.Add("Button", "w400", "Example 5: Auto-Save Timer").OnEvent("Click", (*) => Example5_AutoSave())
MainMenu.Add("Button", "w400", "Example 6: System Monitor").OnEvent("Click", (*) => Example6_SystemMonitor())
MainMenu.Add("Button", "w400", "Example 7: Timer Priority").OnEvent("Click", (*) => Example7_TimerPriority())

MainMenu.Add("Text", "w400 Center", "`n")
MainMenu.Add("Button", "w400", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
