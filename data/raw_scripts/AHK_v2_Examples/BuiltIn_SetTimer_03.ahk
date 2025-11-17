/**
 * @file BuiltIn_SetTimer_03.ahk
 * @description Countdown timers and time-limited operations with SetTimer in AutoHotkey v2
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Advanced countdown timer examples including stopwatches, pomodoro timers,
 * session timers, and time-limited task execution.
 *
 * @syntax SetTimer [Function, Period, Priority]
 * @see https://www.autohotkey.com/docs/v2/lib/SetTimer.htm
 * @requires AutoHotkey v2.0+
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Basic Countdown Timer
; ============================================================================
/**
 * Simple countdown timer with hours, minutes, and seconds
 * Demonstrates time calculation and display formatting
 */
Example1_BasicCountdown() {
    myGui := Gui("+AlwaysOnTop", "Example 1: Countdown Timer")
    myGui.SetFont("s12")
    myGui.Add("Text", "w400 Center", "Countdown Timer")

    ; Time display
    myGui.SetFont("s36 Bold")
    timeDisplay := myGui.Add("Text", "w400 Center vTimeDisplay", "00:00:00")

    myGui.SetFont("s10 Norm")
    progressBar := myGui.Add("Progress", "w400 h30 vProgress", 0)

    ; Time input
    myGui.Add("Text", "xm Section", "`nSet Time:")
    hoursEdit := myGui.Add("Edit", "w60 Number vHours", "0")
    myGui.Add("UpDown", "Range0-23", 0)
    myGui.Add("Text", "x+5", ":")

    minutesEdit := myGui.Add("Edit", "w60 x+5 Number vMinutes", "5")
    myGui.Add("UpDown", "Range0-59", 5)
    myGui.Add("Text", "x+5", ":")

    secondsEdit := myGui.Add("Edit", "w60 x+5 Number vSeconds", "0")
    myGui.Add("UpDown", "Range0-59", 0)

    ; Control buttons
    startBtn := myGui.Add("Button", "xm w125", "Start")
    pauseBtn := myGui.Add("Button", "w125 x+10", "Pause")
    resetBtn := myGui.Add("Button", "w125 x+10", "Reset")

    static totalSeconds := 0
    static remainingSeconds := 0
    static isRunning := false
    static isPaused := false

    ; Update display
    UpdateDisplay() {
        hours := remainingSeconds // 3600
        minutes := Mod(remainingSeconds // 60, 60)
        seconds := Mod(remainingSeconds, 60)

        timeDisplay.Value := Format("{:02d}:{:02d}:{:02d}", hours, minutes, seconds)

        ; Update progress bar
        if (totalSeconds > 0) {
            percentage := ((totalSeconds - remainingSeconds) / totalSeconds) * 100
            progressBar.Value := percentage
        }
    }

    ; Countdown tick
    CountdownTick() {
        if (!isRunning || isPaused)
            return

        remainingSeconds--
        UpdateDisplay()

        if (remainingSeconds <= 0) {
            SetTimer(CountdownTick, 0)
            isRunning := false
            MsgBox("Countdown Complete!", "Timer", "Icon!")
            SoundBeep(1000, 500)
            startBtn.Enabled := true
            pauseBtn.Enabled := false
        }
    }

    ; Start countdown
    startBtn.OnEvent("Click", (*) => StartCountdown())
    StartCountdown() {
        if (isRunning && !isPaused) {
            isPaused := false
            return
        }

        if (!isPaused) {
            hours := Integer(hoursEdit.Value)
            minutes := Integer(minutesEdit.Value)
            seconds := Integer(secondsEdit.Value)

            totalSeconds := (hours * 3600) + (minutes * 60) + seconds
            remainingSeconds := totalSeconds

            if (totalSeconds <= 0) {
                MsgBox("Please set a valid time!", "Error", "Icon!")
                return
            }
        }

        isRunning := true
        isPaused := false
        SetTimer(CountdownTick, 1000)

        startBtn.Enabled := false
        pauseBtn.Enabled := true
        UpdateDisplay()
    }

    ; Pause countdown
    pauseBtn.OnEvent("Click", (*) => PauseCountdown())
    PauseCountdown() {
        isPaused := !isPaused
        pauseBtn.Text := isPaused ? "Resume" : "Pause"

        if (isPaused) {
            SetTimer(CountdownTick, 0)
        } else {
            SetTimer(CountdownTick, 1000)
        }
    }

    ; Reset countdown
    resetBtn.OnEvent("Click", (*) => ResetCountdown())
    ResetCountdown() {
        SetTimer(CountdownTick, 0)
        isRunning := false
        isPaused := false
        remainingSeconds := 0
        totalSeconds := 0

        timeDisplay.Value := "00:00:00"
        progressBar.Value := 0
        pauseBtn.Text := "Pause"

        startBtn.Enabled := true
        pauseBtn.Enabled := false
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(CountdownTick, 0)
        myGui.Destroy()
    }

    pauseBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 2: Pomodoro Timer
; ============================================================================
/**
 * Implements the Pomodoro Technique timer
 * Work sessions followed by short and long breaks
 */
Example2_PomodoroTimer() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Pomodoro Timer")
    myGui.SetFont("s12")
    myGui.Add("Text", "w450 Center", "Pomodoro Productivity Timer")

    ; Status and timer display
    statusText := myGui.Add("Text", "w450 Center vStatus", "Ready to Start")
    myGui.SetFont("s48 Bold")
    timeDisplay := myGui.Add("Text", "w450 Center vTimeDisplay", "25:00")

    myGui.SetFont("s10 Norm")
    progressBar := myGui.Add("Progress", "w450 h30 vProgress BackgroundGreen", 0)

    ; Statistics
    myGui.Add("Text", "xm", "`nSession Statistics:")
    pomodorosText := myGui.Add("Text", "w220 vPomodoros", "Completed: 0/4")
    totalTimeText := myGui.Add("Text", "w220 x+10 vTotalTime", "Total Focus: 0m")

    ; Session log
    myGui.Add("Text", "xm", "`nSession History:")
    logBox := myGui.Add("ListBox", "w450 h120 vLog")

    ; Controls
    startBtn := myGui.Add("Button", "xm w140", "Start Pomodoro")
    pauseBtn := myGui.Add("Button", "w140 x+10", "Pause")
    skipBtn := myGui.Add("Button", "w140 x+10", "Skip Break")

    ; Configuration
    static workDuration := 25 * 60      ; 25 minutes
    static shortBreak := 5 * 60         ; 5 minutes
    static longBreak := 15 * 60         ; 15 minutes
    static pomodorosUntilLongBreak := 4

    static remainingSeconds := workDuration
    static currentMode := "work"        ; work, shortbreak, longbreak
    static isRunning := false
    static isPaused := false
    static completedPomodoros := 0
    static totalFocusTime := 0

    ; Update display
    UpdateDisplay() {
        minutes := remainingSeconds // 60
        seconds := Mod(remainingSeconds, 60)
        timeDisplay.Value := Format("{:02d}:{:02d}", minutes, seconds)

        ; Update progress
        maxTime := (currentMode = "work") ? workDuration :
                   (currentMode = "shortbreak") ? shortBreak : longBreak

        percentage := ((maxTime - remainingSeconds) / maxTime) * 100
        progressBar.Value := percentage
    }

    ; Timer tick
    PomodoroTick() {
        if (!isRunning || isPaused)
            return

        remainingSeconds--
        UpdateDisplay()

        if (remainingSeconds <= 0) {
            CompleteSession()
        }
    }

    ; Complete current session
    CompleteSession() {
        SetTimer(PomodoroTick, 0)
        isRunning := false

        timestamp := FormatTime(, "HH:mm:ss")

        if (currentMode = "work") {
            ; Work session completed
            completedPomodoros++
            totalFocusTime += workDuration

            logBox.Add(timestamp " - Work session " completedPomodoros " completed")
            pomodorosText.Value := "Completed: " completedPomodoros "/" pomodorosUntilLongBreak
            totalTimeText.Value := "Total Focus: " (totalFocusTime // 60) "m"

            MsgBox("Work session complete!`nTime for a break.", "Pomodoro", "Icon!")
            SoundBeep(800, 300)

            ; Determine break type
            if (Mod(completedPomodoros, pomodorosUntilLongBreak) = 0) {
                StartBreak("longbreak")
            } else {
                StartBreak("shortbreak")
            }

        } else {
            ; Break completed
            breakType := (currentMode = "shortbreak") ? "Short break" : "Long break"
            logBox.Add(timestamp " - " breakType " completed")

            MsgBox(breakType " complete!`nReady for next session?", "Pomodoro", "Icon!")
            SoundBeep(600, 300)

            StartWork()
        }
    }

    ; Start work session
    StartWork() {
        currentMode := "work"
        remainingSeconds := workDuration
        statusText.Value := "Work Session - Focus Time!"
        progressBar.Opt("BackgroundGreen")
        UpdateDisplay()

        startBtn.Enabled := false
        pauseBtn.Enabled := true
        skipBtn.Enabled := false
    }

    ; Start break
    StartBreak(breakType) {
        currentMode := breakType
        remainingSeconds := (breakType = "shortbreak") ? shortBreak : longBreak

        if (breakType = "shortbreak") {
            statusText.Value := "Short Break - Relax!"
            progressBar.Opt("BackgroundBlue")
        } else {
            statusText.Value := "Long Break - Great Job!"
            progressBar.Opt("BackgroundPurple")
        }

        UpdateDisplay()
        skipBtn.Enabled := true
    }

    ; Start button
    startBtn.OnEvent("Click", (*) => StartPomodoro())
    StartPomodoro() {
        if (!isRunning) {
            StartWork()
        }

        isRunning := true
        isPaused := false
        SetTimer(PomodoroTick, 1000)

        startBtn.Enabled := false
        pauseBtn.Enabled := true
    }

    ; Pause button
    pauseBtn.OnEvent("Click", (*) => TogglePause())
    TogglePause() {
        isPaused := !isPaused
        pauseBtn.Text := isPaused ? "Resume" : "Pause"

        if (!isPaused) {
            SetTimer(PomodoroTick, 1000)
        } else {
            SetTimer(PomodoroTick, 0)
        }
    }

    ; Skip break
    skipBtn.OnEvent("Click", (*) => SkipBreak())
    SkipBreak() {
        if (currentMode != "work") {
            SetTimer(PomodoroTick, 0)
            isRunning := false
            StartWork()
            StartPomodoro()
        }
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(PomodoroTick, 0)
        myGui.Destroy()
    }

    pauseBtn.Enabled := false
    skipBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 3: Multi-Timer Manager
; ============================================================================
/**
 * Manage multiple countdown timers simultaneously
 * Each timer can have a different duration and label
 */
Example3_MultiTimer() {
    myGui := Gui("+AlwaysOnTop +Resize", "Example 3: Multi-Timer Manager")
    myGui.SetFont("s10")
    myGui.Add("Text", "w600 Center", "Multiple Countdown Timer Manager")

    ; Timer list
    myGui.Add("Text", "xm", "Active Timers:")
    timerList := myGui.Add("ListView", "w600 h200 vTimerList", ["Name", "Remaining", "Progress", "Status"])

    ; Add timer controls
    myGui.Add("Text", "xm Section", "`nAdd New Timer:")
    nameEdit := myGui.Add("Edit", "w200 vName", "Timer Name")
    durationEdit := myGui.Add("Edit", "w100 x+10 vDuration", "60")
    myGui.Add("Text", "x+5", "seconds")
    addBtn := myGui.Add("Button", "x+10 w100", "Add Timer")

    ; Log
    myGui.Add("Text", "xm", "`nTimer Events:")
    logBox := myGui.Add("Edit", "w600 h120 ReadOnly vLog")

    static timers := []

    ; Log helper
    LogEvent(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 5000)
            logBox.Value := SubStr(logBox.Value, -4000)
    }

    ; Format time
    FormatTime(seconds) {
        minutes := seconds // 60
        secs := Mod(seconds, 60)
        return Format("{:02d}:{:02d}", minutes, secs)
    }

    ; Update timer display
    UpdateTimer(idx) {
        if (idx > timers.Length)
            return

        timer := timers[idx]

        if (!timer.isRunning)
            return

        timer.remaining--

        ; Calculate progress
        progress := ((timer.duration - timer.remaining) / timer.duration) * 100

        ; Update ListView
        timerList.Modify(idx, , timer.name, FormatTime(timer.remaining),
                        Format("{:.0f}%", progress), "Running")

        if (timer.remaining <= 0) {
            ; Timer completed
            SetTimer(timer.func, 0)
            timer.isRunning := false
            timerList.Modify(idx, , timer.name, "00:00", "100%", "Complete")
            LogEvent("COMPLETED: " timer.name)

            ; Notification
            MsgBox("Timer '" timer.name "' has completed!", "Timer Alert", "Icon!")
            SoundBeep(1000, 300)
        }
    }

    ; Add new timer
    addBtn.OnEvent("Click", (*) => AddTimer())
    AddTimer() {
        name := nameEdit.Value
        duration := Integer(durationEdit.Value)

        if (name = "" || duration < 1) {
            MsgBox("Invalid timer parameters!", "Error", "Icon!")
            return
        }

        ; Create timer object
        timer := {
            name: name,
            duration: duration,
            remaining: duration,
            isRunning: false,
            func: ""
        }

        timers.Push(timer)
        idx := timers.Length

        ; Create timer function
        timer.func := (*) => UpdateTimer(idx)

        ; Add to ListView
        timerList.Add("", name, FormatTime(duration), "0%", "Ready")

        LogEvent("Timer added: " name " (" duration "s)")

        ; Clear inputs
        nameEdit.Value := ""
        durationEdit.Value := "60"
    }

    ; Control buttons
    startBtn := myGui.Add("Button", "xm w140", "Start Selected")
    stopBtn := myGui.Add("Button", "w140 x+10", "Stop Selected")
    resetBtn := myGui.Add("Button", "w140 x+10", "Reset Selected")
    removeBtn := myGui.Add("Button", "w140 x+10", "Remove Selected")

    ; Start timer
    startBtn.OnEvent("Click", (*) => StartTimer())
    StartTimer() {
        row := timerList.GetNext()
        if (!row || row > timers.Length)
            return

        timer := timers[row]

        if (!timer.isRunning) {
            timer.isRunning := true
            SetTimer(timer.func, 1000)
            timerList.Modify(row, , timer.name, FormatTime(timer.remaining), "", "Running")
            LogEvent("Started: " timer.name)
        }
    }

    ; Stop timer
    stopBtn.OnEvent("Click", (*) => StopTimer())
    StopTimer() {
        row := timerList.GetNext()
        if (!row || row > timers.Length)
            return

        timer := timers[row]

        if (timer.isRunning) {
            SetTimer(timer.func, 0)
            timer.isRunning := false
            timerList.Modify(row, , timer.name, FormatTime(timer.remaining), "", "Stopped")
            LogEvent("Stopped: " timer.name)
        }
    }

    ; Reset timer
    resetBtn.OnEvent("Click", (*) => ResetTimer())
    ResetTimer() {
        row := timerList.GetNext()
        if (!row || row > timers.Length)
            return

        timer := timers[row]

        SetTimer(timer.func, 0)
        timer.isRunning := false
        timer.remaining := timer.duration

        timerList.Modify(row, , timer.name, FormatTime(timer.remaining), "0%", "Ready")
        LogEvent("Reset: " timer.name)
    }

    ; Remove timer
    removeBtn.OnEvent("Click", (*) => RemoveTimer())
    RemoveTimer() {
        row := timerList.GetNext()
        if (!row || row > timers.Length)
            return

        timer := timers[row]

        SetTimer(timer.func, 0)
        LogEvent("Removed: " timer.name)

        timers.RemoveAt(row)
        timerList.Delete(row)
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        for timer in timers {
            if (timer.isRunning)
                SetTimer(timer.func, 0)
        }
        myGui.Destroy()
    }

    myGui.Show()
    LogEvent("Multi-Timer Manager initialized")
}

; ============================================================================
; EXAMPLE 4: Stopwatch with Lap Times
; ============================================================================
/**
 * Precision stopwatch with lap time recording
 * Demonstrates upward counting timer
 */
Example4_Stopwatch() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Stopwatch")
    myGui.SetFont("s12")
    myGui.Add("Text", "w450 Center", "Precision Stopwatch")

    ; Main time display
    myGui.SetFont("s48 Bold")
    timeDisplay := myGui.Add("Text", "w450 Center vTimeDisplay", "00:00.000")

    myGui.SetFont("s10 Norm")

    ; Controls
    startBtn := myGui.Add("Button", "xm w140", "Start")
    lapBtn := myGui.Add("Button", "w140 x+10", "Lap")
    resetBtn := myGui.Add("Button", "w140 x+10", "Reset")

    ; Lap times list
    myGui.Add("Text", "xm", "`nLap Times:")
    lapList := myGui.Add("ListView", "w450 h250", ["#", "Lap Time", "Total Time"])

    static startTime := 0
    static elapsedTime := 0
    static isRunning := false
    static lapCount := 0
    static lastLapTime := 0

    ; Format milliseconds to MM:SS.mmm
    FormatTimeMs(ms) {
        totalSeconds := ms // 1000
        milliseconds := Mod(ms, 1000)
        minutes := totalSeconds // 60
        seconds := Mod(totalSeconds, 60)

        return Format("{:02d}:{:02d}.{:03d}", minutes, seconds, milliseconds)
    }

    ; Update stopwatch
    UpdateStopwatch() {
        if (!isRunning)
            return

        elapsedTime := A_TickCount - startTime
        timeDisplay.Value := FormatTimeMs(elapsedTime)
    }

    ; Start/Stop toggle
    startBtn.OnEvent("Click", (*) => ToggleStopwatch())
    ToggleStopwatch() {
        if (!isRunning) {
            ; Start
            startTime := A_TickCount - elapsedTime
            isRunning := true
            SetTimer(UpdateStopwatch, 10)  ; Update every 10ms for precision

            startBtn.Text := "Stop"
            lapBtn.Enabled := true
        } else {
            ; Stop
            isRunning := false
            SetTimer(UpdateStopwatch, 0)

            startBtn.Text := "Start"
            lapBtn.Enabled := false
        }
    }

    ; Record lap
    lapBtn.OnEvent("Click", (*) => RecordLap())
    RecordLap() {
        if (!isRunning)
            return

        lapCount++
        currentTime := elapsedTime
        lapTime := currentTime - lastLapTime
        lastLapTime := currentTime

        lapList.Add("", lapCount, FormatTimeMs(lapTime), FormatTimeMs(currentTime))
    }

    ; Reset stopwatch
    resetBtn.OnEvent("Click", (*) => ResetStopwatch())
    ResetStopwatch() {
        SetTimer(UpdateStopwatch, 0)
        isRunning := false
        elapsedTime := 0
        lapCount := 0
        lastLapTime := 0

        timeDisplay.Value := "00:00.000"
        startBtn.Text := "Start"
        lapBtn.Enabled := false

        lapList.Delete()
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(UpdateStopwatch, 0)
        myGui.Destroy()
    }

    lapBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 5: Session Timer with Warnings
; ============================================================================
/**
 * Session timer with configurable warning notifications
 * Useful for time-limited tasks with reminders
 */
Example5_SessionTimer() {
    myGui := Gui("+AlwaysOnTop", "Example 5: Session Timer")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Time-Limited Session Manager")

    ; Session info
    myGui.SetFont("s24 Bold")
    timeDisplay := myGui.Add("Text", "w500 Center vTimeDisplay", "30:00")

    myGui.SetFont("s10 Norm")
    statusText := myGui.Add("Text", "w500 Center vStatus", "Session not started")
    progressBar := myGui.Add("Progress", "w500 h30 vProgress", 0)

    ; Configuration
    myGui.Add("Text", "xm Section", "`nSession Duration:")
    durationSlider := myGui.Add("Slider", "w400 Range1-60 TickInterval5 vDuration", 30)
    durationText := myGui.Add("Text", "w400 vDurationText", "30 minutes")

    durationSlider.OnEvent("Change", (*) => UpdateDurationText())
    UpdateDurationText() {
        durationText.Value := durationSlider.Value " minutes"
        if (!isRunning)
            timeDisplay.Value := Format("{:02d}:00", durationSlider.Value)
    }

    ; Warning settings
    myGui.Add("Text", "xm", "`nWarning Notifications:")
    warning1 := myGui.Add("Checkbox", "xm Checked", "Warning at 50% remaining")
    warning2 := myGui.Add("Checkbox", "xm Checked", "Warning at 25% remaining")
    warning3 := myGui.Add("Checkbox", "xm Checked", "Warning at 5 minutes remaining")
    warning4 := myGui.Add("Checkbox", "xm Checked", "Warning at 1 minute remaining")

    ; Event log
    myGui.Add("Text", "xm", "`nSession Events:")
    logBox := myGui.Add("Edit", "w500 h120 ReadOnly vLog")

    static totalSeconds := 0
    static remainingSeconds := 0
    static isRunning := false
    static warnings := Map()

    ; Log event
    LogEvent(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"
    }

    ; Update display
    UpdateDisplay() {
        minutes := remainingSeconds // 60
        seconds := Mod(remainingSeconds, 60)
        timeDisplay.Value := Format("{:02d}:{:02d}", minutes, seconds)

        ; Update progress
        if (totalSeconds > 0) {
            percentage := ((totalSeconds - remainingSeconds) / totalSeconds) * 100
            progressBar.Value := percentage

            ; Change color based on remaining time
            if (percentage < 50)
                progressBar.Opt("BackgroundGreen")
            else if (percentage < 75)
                progressBar.Opt("BackgroundYellow")
            else
                progressBar.Opt("BackgroundRed")
        }
    }

    ; Session tick
    SessionTick() {
        if (!isRunning)
            return

        remainingSeconds--
        UpdateDisplay()

        ; Check warnings
        CheckWarnings()

        if (remainingSeconds <= 0) {
            CompleteSession()
        }
    }

    ; Check and trigger warnings
    CheckWarnings() {
        percentage := (remainingSeconds / totalSeconds) * 100

        ; 50% warning
        if (warning1.Value && !warnings.Has("50%") && percentage <= 50) {
            warnings["50%"] := true
            LogEvent("WARNING: 50% time remaining")
            TrayTip("Session Timer", "50% of session time remaining", "Icon!")
            SoundBeep(600, 200)
        }

        ; 25% warning
        if (warning2.Value && !warnings.Has("25%") && percentage <= 25) {
            warnings["25%"] := true
            LogEvent("WARNING: 25% time remaining")
            TrayTip("Session Timer", "25% of session time remaining", "Icon!")
            SoundBeep(700, 200)
        }

        ; 5 minutes warning
        if (warning3.Value && !warnings.Has("5min") && remainingSeconds <= 300 && remainingSeconds > 299) {
            warnings["5min"] := true
            LogEvent("WARNING: 5 minutes remaining")
            TrayTip("Session Timer", "5 minutes remaining!", "Icon!")
            SoundBeep(800, 300)
        }

        ; 1 minute warning
        if (warning4.Value && !warnings.Has("1min") && remainingSeconds <= 60 && remainingSeconds > 59) {
            warnings["1min"] := true
            LogEvent("WARNING: 1 minute remaining")
            TrayTip("Session Timer", "Only 1 minute left!", "Icon!")
            SoundBeep(900, 400)
        }
    }

    ; Complete session
    CompleteSession() {
        SetTimer(SessionTick, 0)
        isRunning := false

        statusText.Value := "Session completed!"
        LogEvent("Session completed successfully")

        MsgBox("Session time has ended!", "Session Complete", "Icon!")
        SoundBeep(1000, 500)

        startBtn.Text := "Start Session"
        startBtn.Enabled := true
    }

    ; Controls
    startBtn := myGui.Add("Button", "xm w160", "Start Session")
    endBtn := myGui.Add("Button", "w160 x+10", "End Session")
    clearLogBtn := myGui.Add("Button", "w160 x+10", "Clear Log")

    ; Start session
    startBtn.OnEvent("Click", (*) => StartSession())
    StartSession() {
        duration := durationSlider.Value
        totalSeconds := duration * 60
        remainingSeconds := totalSeconds

        warnings := Map()  ; Reset warnings

        isRunning := true
        SetTimer(SessionTick, 1000)

        statusText.Value := "Session in progress..."
        LogEvent("Session started: " duration " minutes")

        startBtn.Text := "Session Active"
        startBtn.Enabled := false
        UpdateDisplay()
    }

    ; End session early
    endBtn.OnEvent("Click", (*) => EndSession())
    EndSession() {
        if (isRunning) {
            result := MsgBox("End session early?", "Confirm", "YesNo Icon?")
            if (result = "Yes") {
                SetTimer(SessionTick, 0)
                isRunning := false
                statusText.Value := "Session ended early"
                LogEvent("Session ended manually")
                startBtn.Text := "Start Session"
                startBtn.Enabled := true
            }
        }
    }

    ; Clear log
    clearLogBtn.OnEvent("Click", (*) => logBox.Value := "")

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(SessionTick, 0)
        TrayTip()
        myGui.Destroy()
    }

    myGui.Show()
    LogEvent("Session Timer initialized")
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "SetTimer Examples - Countdown Timers")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Countdown Timers")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Basic Countdown Timer").OnEvent("Click", (*) => Example1_BasicCountdown())
MainMenu.Add("Button", "w450", "Example 2: Pomodoro Timer").OnEvent("Click", (*) => Example2_PomodoroTimer())
MainMenu.Add("Button", "w450", "Example 3: Multi-Timer Manager").OnEvent("Click", (*) => Example3_MultiTimer())
MainMenu.Add("Button", "w450", "Example 4: Stopwatch with Laps").OnEvent("Click", (*) => Example4_Stopwatch())
MainMenu.Add("Button", "w450", "Example 5: Session Timer").OnEvent("Click", (*) => Example5_SessionTimer())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
