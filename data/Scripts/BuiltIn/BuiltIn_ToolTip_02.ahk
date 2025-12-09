#Requires AutoHotkey v2.0

/**
* ============================================================================
* ToolTip Advanced Applications - Part 2
* ============================================================================
*
* Advanced ToolTip applications and patterns in AutoHotkey v2.
*
* @description This file covers advanced ToolTip usage including:
*              - Dynamic updating tooltips
*              - Progress tracking
*              - Data monitoring
*              - Notification systems
*              - Debug overlays
*
* @author AutoHotkey Foundation
* @version 2.0
* @see https://www.autohotkey.com/docs/v2/lib/ToolTip.htm
*
* ============================================================================
*/

; ============================================================================
; EXAMPLE 1: Dynamic Progress Tracking
; ============================================================================
/**
* Creates dynamic progress indicators using tooltips.
*
* @description Shows real-time progress updates with various
*              visualization styles.
*/
Example1_ProgressTracking() {
    ; Simple percentage progress
    Loop 100 {
        ToolTip "Progress: " . A_Index . "%"
        Sleep 50
    }
    ToolTip

    ; Progress bar visualization
    Loop 100 {
        percent := A_Index
        bar := CreateProgressBar(percent, 30)
        ToolTip Format("Loading: {1}%`n{2}", percent, bar)
        Sleep 30
    }
    ToolTip

    ; Multi-step progress
    steps := ["Initializing", "Loading data", "Processing", "Saving", "Complete"]

    for index, step in steps {
        Loop 100 {
            percent := A_Index
            bar := CreateProgressBar(percent, 25)

            ToolTip Format("Step {1}/{2}: {3}`n{4}`n{5}%",
            index,
            steps.Length,
            step,
            bar,
            percent)
            Sleep 10
        }
    }
    ToolTip

    ; File processing progress
    SimulateFileProcessing(50)

    ; Download progress simulation
    SimulateDownload(10485760)  ; 10 MB

    ; Time-based progress
    ShowCountdown(5)
}

/**
* Creates a text-based progress bar.
*/
CreateProgressBar(percent, width := 20, fillChar := "█", emptyChar := "░") {
    filled := Round((percent / 100) * width)
    bar := ""

    Loop width {
        bar .= (A_Index <= filled) ? fillChar : emptyChar
    }

    return bar
}

/**
* Simulates file processing with progress.
*/
SimulateFileProcessing(fileCount) {
    Loop fileCount {
        fileName := "file_" . A_Index . ".txt"
        percent := (A_Index / fileCount) * 100
        bar := CreateProgressBar(percent, 25)

        ToolTip Format("Processing Files`n`n"
        . "Current: {1}`n"
        . "Progress: {2}/{3}`n"
        . "{4}`n"
        . "{5}%",
        fileName,
        A_Index,
        fileCount,
        bar,
        Round(percent))

        Sleep 100
    }
    ToolTip
}

/**
* Simulates download progress.
*/
SimulateDownload(totalBytes) {
    Loop 100 {
        downloaded := Round((A_Index / 100) * totalBytes)
        percent := A_Index
        speed := Random(512000, 2048000)  ; Random speed
        remaining := Round((totalBytes - downloaded) / speed)

        ToolTip Format("Downloading...`n`n"
        . "Downloaded: {1} / {2}`n"
        . "Progress: {3}%`n"
        . "Speed: {4}/s`n"
        . "Time remaining: {5}s",
        FormatBytes(downloaded),
        FormatBytes(totalBytes),
        percent,
        FormatBytes(speed),
        remaining)

        Sleep 50
    }
    ToolTip
}

/**
* Formats bytes to human-readable format.
*/
FormatBytes(bytes) {
    if (bytes < 1024)
    return bytes . " B"
    else if (bytes < 1048576)
    return Round(bytes / 1024, 1) . " KB"
    else if (bytes < 1073741824)
    return Round(bytes / 1048576, 1) . " MB"
    else
    return Round(bytes / 1073741824, 1) . " GB"
}

/**
* Shows countdown timer.
*/
ShowCountdown(seconds) {
    Loop seconds {
        remaining := seconds - A_Index + 1
        ToolTip Format("Starting in {1} seconds...", remaining)
        Sleep 1000
    }
    ToolTip "Go!", A_ScreenWidth // 2, A_ScreenHeight // 2
    Sleep 1000
    ToolTip
}

; ============================================================================
; EXAMPLE 2: Real-Time Data Monitoring
; ============================================================================
/**
* Monitors and displays real-time data.
*
* @description Shows system and application metrics in real-time.
*/
Example2_DataMonitoring() {
    ; CPU/Memory monitor (simulated)
    MonitorSystemResources(5)

    ; Network activity monitor
    MonitorNetworkActivity(5)

    ; Process monitor
    MonitorProcesses(5)

    ; Temperature monitor
    MonitorTemperature(5)

    ; Multi-metric dashboard
    ShowDashboard(5)
}

/**
* Monitors system resources.
*/
MonitorSystemResources(duration) {
    startTime := A_TickCount

    Loop {
        ; Simulated values
        cpu := Random(20, 80)
        memory := Random(40, 75)
        disk := Random(10, 90)

        cpuBar := CreateProgressBar(cpu, 20)
        memBar := CreateProgressBar(memory, 20)
        diskBar := CreateProgressBar(disk, 20)

        ToolTip Format("=== System Monitor ===`n`n"
        . "CPU Usage:`n{1} {2}%`n`n"
        . "Memory Usage:`n{3} {4}%`n`n"
        . "Disk Activity:`n{5} {6}%",
        cpuBar, cpu,
        memBar, memory,
        diskBar, disk)

        Sleep 500

        if ((A_TickCount - startTime) > (duration * 1000))
        break
    }
    ToolTip
}

/**
* Monitors network activity.
*/
MonitorNetworkActivity(duration) {
    startTime := A_TickCount
    totalDown := 0
    totalUp := 0

    Loop {
        ; Simulated network activity
        downSpeed := Random(10240, 1048576)
        upSpeed := Random(5120, 524288)
        totalDown += downSpeed
        totalUp += upSpeed

        ToolTip Format("=== Network Monitor ===`n`n"
        . "Download: {1}/s`n"
        . "Upload: {2}/s`n`n"
        . "Total Downloaded: {3}`n"
        . "Total Uploaded: {4}`n`n"
        . "Status: Connected",
        FormatBytes(downSpeed),
        FormatBytes(upSpeed),
        FormatBytes(totalDown),
        FormatBytes(totalUp))

        Sleep 500

        if ((A_TickCount - startTime) > (duration * 1000))
        break
    }
    ToolTip
}

/**
* Monitors running processes.
*/
MonitorProcesses(duration) {
    startTime := A_TickCount

    Loop {
        ; Simulated process data
        processCount := Random(100, 150)
        threadCount := Random(1000, 2000)
        handles := Random(20000, 40000)

        ToolTip Format("=== Process Monitor ===`n`n"
        . "Processes: {1}`n"
        . "Threads: {2}`n"
        . "Handles: {3}`n`n"
        . "Top Process: System`n"
        . "CPU: 5%",
        processCount,
        threadCount,
        handles)

        Sleep 500

        if ((A_TickCount - startTime) > (duration * 1000))
        break
    }
    ToolTip
}

/**
* Monitors temperature.
*/
MonitorTemperature(duration) {
    startTime := A_TickCount

    Loop {
        ; Simulated temperatures
        cpuTemp := Random(40, 75)
        gpuTemp := Random(35, 70)

        cpuStatus := (cpuTemp > 70) ? "⚠️ High" : "✓ Normal"
        gpuStatus := (gpuTemp > 65) ? "⚠️ High" : "✓ Normal"

        ToolTip Format("=== Temperature Monitor ===`n`n"
        . "CPU: {1}°C {2}`n"
        . "GPU: {3}°C {4}`n`n"
        . "Fan Speed: {5} RPM",
        cpuTemp, cpuStatus,
        gpuTemp, gpuStatus,
        Random(1200, 2500))

        Sleep 500

        if ((A_TickCount - startTime) > (duration * 1000))
        break
    }
    ToolTip
}

/**
* Shows multi-metric dashboard.
*/
ShowDashboard(duration) {
    startTime := A_TickCount

    Loop {
        cpu := Random(20, 80)
        mem := Random(40, 75)
        temp := Random(40, 70)
        network := Random(102400, 1048576)

        ToolTip Format("╔════════════════════════╗`n"
        . "║   System Dashboard     ║`n"
        . "╠════════════════════════╣`n"
        . "║ CPU:  {1:3}% {2}`n"
        . "║ RAM:  {3:3}% {4}`n"
        . "║ Temp: {5:3}°C          ║`n"
        . "║ Net:  {6:12}  ║`n"
        . "╠════════════════════════╣`n"
        . "║ Time: {7}        ║`n"
        . "╚════════════════════════╝",
        cpu, GetStatusIcon(cpu, 80),
        mem, GetStatusIcon(mem, 80),
        temp,
        FormatBytes(network),
        FormatTime(, "HH:mm:ss"))

        Sleep 500

        if ((A_TickCount - startTime) > (duration * 1000))
        break
    }
    ToolTip
}

/**
* Gets status icon based on value.
*/
GetStatusIcon(value, threshold) {
    return (value > threshold) ? "⚠️" : "✓"
}

; ============================================================================
; EXAMPLE 3: Notification System
; ============================================================================
/**
* Creates a notification system using tooltips.
*
* @description Shows various notification patterns and styles.
*/
Example3_NotificationSystem() {
    ; Info notification
    ShowNotification("ℹ️ Information", "This is an informational message.", 2000)

    Sleep 2500

    ; Success notification
    ShowNotification("✓ Success", "Operation completed successfully!", 2000)

    Sleep 2500

    ; Warning notification
    ShowNotification("⚠️ Warning", "Please review your settings.", 2000)

    Sleep 2500

    ; Error notification
    ShowNotification("❌ Error", "An error occurred. Please try again.", 2000)

    Sleep 2500

    ; Sequential notifications
    notifications := [
    {
        type: "ℹ️", title: "Starting", msg: "Process initiated"},
        {
            type: "⚙️", title: "Processing", msg: "Please wait..."},
            {
                type: "✓", title: "Complete", msg: "Process finished successfully"
            }
            ]

            for notif in notifications {
                ShowNotification(notif.type . " " . notif.title, notif.msg, 1500)
                Sleep 2000
            }

            ; Notification queue
            ShowNotificationQueue()
        }

        /**
        * Shows a notification tooltip.
        */
        ShowNotification(title, message, duration := 3000, x := "", y := "") {
            if (x = "")
            x := A_ScreenWidth - 350

            if (y = "")
            y := 50

            notification := title . "`n" . message

            ToolTip notification, x, y

            if (duration > 0) {
                ClearFunc := (*) => ToolTip()
                SetTimer ClearFunc, -duration
            }
        }

        /**
        * Shows multiple notifications in queue.
        */
        ShowNotificationQueue() {
            messages := [
            "Email received from support@example.com",
            "Download complete: report.pdf",
            "Reminder: Meeting in 15 minutes",
            "System update available",
            "Backup completed successfully"
            ]

            yPos := 50

            for index, msg in messages {
                ShowNotification("📬 Notification " . index, msg, 1500, , yPos)
                yPos += 100
                Sleep 1800
            }

            Sleep 2000
            ToolTip
        }

        ; ============================================================================
        ; EXAMPLE 4: Debugging Overlay
        ; ============================================================================
        /**
        * Creates debugging overlays using tooltips.
        *
        * @description Shows variable values and program state for debugging.
        */
        Example4_DebuggingOverlay() {
            ; Variable watcher
            WatchVariables()

            ; Function call tracker
            TrackFunctionCalls()

            ; State monitor
            MonitorProgramState()

            ; Performance metrics
            ShowPerformanceMetrics()
        }

        /**
        * Watches multiple variables.
        */
        WatchVariables() {
            counter := 0
            status := "idle"
            items := []

            Loop 20 {
                counter++
                status := (counter <= 10) ? "processing" : "complete"
                items.Push("item_" . counter)

                debug := Format("=== Debug Watch ===`n`n"
                . "counter = {1}`n"
                . "status = '{2}'`n"
                . "items.Length = {3}`n"
                . "A_Index = {4}",
                counter,
                status,
                items.Length,
                A_Index)

                ToolTip debug, 10, 10, 1
                Sleep 200
            }
            ToolTip , , , 1
        }

        /**
        * Tracks function execution.
        */
        TrackFunctionCalls() {
            functions := ["InitializeSystem", "LoadConfig", "ConnectDatabase", "StartServer"]

            for index, funcName in functions {
                startTime := A_TickCount

                ; Simulate function execution
                ToolTip Format("Calling: {1}()`nStatus: Running...", funcName), 10, 10
                Sleep Random(500, 1500)

                endTime := A_TickCount
                duration := endTime - startTime

                ToolTip Format("Completed: {1}()`nDuration: {2}ms", funcName, duration), 10, 10
                Sleep 1000
            }
            ToolTip
        }

        /**
        * Monitors program state.
        */
        MonitorProgramState() {
            states := ["idle", "loading", "processing", "saving", "idle"]

            for state in states {
                StateDisplay(state, Random(1000, 3000))
            }
        }

        /**
        * Displays current state.
        */
        StateDisplay(state, duration) {
            startTime := A_TickCount

            Loop {
                elapsed := A_TickCount - startTime
                remaining := duration - elapsed

                ToolTip Format("=== Program State ===`n`n"
                . "Current State: {1}`n"
                . "Elapsed: {2}ms`n"
                . "Remaining: {3}ms",
                StrUpper(state),
                elapsed,
                Max(0, remaining))

                Sleep 100

                if (elapsed >= duration)
                break
            }
        }

        /**
        * Shows performance metrics.
        */
        ShowPerformanceMetrics() {
            iterations := 0
            startTime := A_TickCount

            Loop 50 {
                iterations++
                elapsed := A_TickCount - startTime
                iterPerSec := (elapsed > 0) ? Round((iterations / elapsed) * 1000) : 0

                ToolTip Format("=== Performance ===`n`n"
                . "Iterations: {1}`n"
                . "Elapsed: {2}ms`n"
                . "Rate: {3} iter/s`n"
                . "Avg: {4}ms/iter",
                iterations,
                elapsed,
                iterPerSec,
                (iterations > 0) ? Round(elapsed / iterations, 2) : 0)

                Sleep 100
            }
            ToolTip
        }

        ; ============================================================================
        ; EXAMPLE 5: Contextual Help System
        ; ============================================================================
        /**
        * Creates context-sensitive help tooltips.
        *
        * @description Shows help information based on context.
        */
        Example5_ContextualHelp() {
            ; Hover help simulation
            controls := [
            {
                name: "Button1", help: "Click to submit form"},
                {
                    name: "TextBox1", help: "Enter your email address"},
                    {
                        name: "Checkbox1", help: "Check to accept terms"},
                        {
                            name: "Dropdown1", help: "Select your country"
                        }
                        ]

                        for control in controls {
                            ShowControlHelp(control.name, control.help)
                            Sleep 2000
                        }

                        ; Feature explanation
                        ShowFeatureHelp("Auto-Save", "Automatically saves your work every 5 minutes`nCan be disabled in Settings > General")
                        Sleep 3000

                        ; Keyboard shortcuts
                        ShowKeyboardShortcuts()
                    }

                    /**
                    * Shows control-specific help.
                    */
                    ShowControlHelp(controlName, helpText) {
                        ToolTip Format("💡 Help: {1}`n`n{2}", controlName, helpText)
                    }

                    /**
                    * Shows feature help.
                    */
                    ShowFeatureHelp(featureName, description) {
                        ToolTip Format("=== {1} ===`n`n{2}", featureName, description)
                    }

                    /**
                    * Shows keyboard shortcuts.
                    */
                    ShowKeyboardShortcuts() {
                        shortcuts := "╔═══════════════════════════╗`n"
                        . "║  Keyboard Shortcuts       ║`n"
                        . "╠═══════════════════════════╣`n"
                        . "║ Ctrl+N    New File        ║`n"
                        . "║ Ctrl+O    Open File       ║`n"
                        . "║ Ctrl+S    Save            ║`n"
                        . "║ Ctrl+Z    Undo            ║`n"
                        . "║ Ctrl+Y    Redo            ║`n"
                        . "║ F1        Help            ║`n"
                        . "╚═══════════════════════════╝"

                        ToolTip shortcuts
                        Sleep 3000
                        ToolTip
                    }

                    ; ============================================================================
                    ; EXAMPLE 6: Game/Animation Status
                    ; ============================================================================
                    /**
                    * Shows game-style status displays.
                    *
                    * @description Demonstrates game HUD-style tooltips.
                    */
                    Example6_GameStatus() {
                        ; Health/Status bars
                        ShowGameHUD(10)

                        ; Score counter
                        ShowScoreCounter(5)

                        ; Level progress
                        ShowLevelProgress()
                    }

                    /**
                    * Shows game HUD.
                    */
                    ShowGameHUD(duration) {
                        health := 100
                        mana := 100
                        startTime := A_TickCount

                        Loop {
                            ; Simulate damage/recovery
                            health := Max(0, Min(100, health + Random(-5, 3)))
                            mana := Max(0, Min(100, mana + Random(-3, 5)))

                            healthBar := CreateProgressBar(health, 20, "❤", "♡")
                            manaBar := CreateProgressBar(mana, 20, "★", "☆")

                            ToolTip Format("╔════════════════════╗`n"
                            . "║   Player Status    ║`n"
                            . "╠════════════════════╣`n"
                            . "║ HP {1} {2:3}% ║`n"
                            . "║ MP {3} {4:3}% ║`n"
                            . "╠════════════════════╣`n"
                            . "║ Level: 10          ║`n"
                            . "║ XP: 1234/2000      ║`n"
                            . "╚════════════════════╝",
                            healthBar, health,
                            manaBar, mana),
                            10, 10

                            Sleep 200

                            if ((A_TickCount - startTime) > (duration * 1000))
                            break
                        }
                        ToolTip
                    }

                    /**
                    * Shows score counter.
                    */
                    ShowScoreCounter(duration) {
                        score := 0
                        combo := 0
                        startTime := A_TickCount

                        Loop {
                            ; Simulate scoring
                            points := Random(10, 100)
                            score += points
                            combo := (combo < 10) ? combo + 1 : combo

                            ToolTip Format("════════════════`n"
                            . "  SCORE: {1:6}`n"
                            . "  COMBO: x{2}`n"
                            . "════════════════`n"
                            . "  +{3} points!`n"
                            . "════════════════",
                            score,
                            combo,
                            points),
                            A_ScreenWidth - 250, 50

                            Sleep 500

                            if ((A_TickCount - startTime) > (duration * 1000))
                            break
                        }
                        ToolTip
                    }

                    /**
                    * Shows level progress.
                    */
                    ShowLevelProgress() {
                        currentXP := 0
                        requiredXP := 1000

                        Loop 100 {
                            currentXP += 10
                            percent := (currentXP / requiredXP) * 100
                            bar := CreateProgressBar(percent, 30)

                            ToolTip Format("Level 5 → Level 6`n`n"
                            . "XP: {1}/{2}`n"
                            . "{3}`n"
                            . "{4}%",
                            currentXP,
                            requiredXP,
                            bar,
                            Round(percent))

                            Sleep 50
                        }

                        ToolTip "✨ LEVEL UP! ✨`n`nYou are now Level 6!", A_ScreenWidth // 2 - 100, A_ScreenHeight // 2
                        Sleep 2000
                        ToolTip
                    }

                    ; ============================================================================
                    ; EXAMPLE 7: Multi-Zone Status Display
                    ; ============================================================================
                    /**
                    * Creates multiple tooltip zones for different information.
                    *
                    * @description Shows how to use multiple tooltips for organized display.
                    */
                    Example7_MultiZoneDisplay() {
                        ; Create multi-zone display
                        duration := 5000
                        startTime := A_TickCount

                        Loop {
                            ; Top-left: Time
                            ToolTip FormatTime(, "HH:mm:ss"), 10, 10, 1

                            ; Top-right: System
                            cpu := Random(20, 60)
                            mem := Random(40, 70)
                            ToolTip Format("CPU: {1}%`nRAM: {2}%", cpu, mem),
                            A_ScreenWidth - 150, 10, 2

                            ; Bottom-left: Status
                            status := (Mod(A_Index, 2) = 0) ? "Active" : "Idle"
                            ToolTip "Status: " . status, 10, A_ScreenHeight - 80, 3

                            ; Bottom-right: Counter
                            ToolTip "Count: " . A_Index, A_ScreenWidth - 150, A_ScreenHeight - 80, 4

                            Sleep 500

                            if ((A_TickCount - startTime) > duration)
                            break
                        }

                        ; Clear all tooltips
                        Loop 4 {
                            ToolTip , , , A_Index
                        }
                    }

                    ; ============================================================================
                    ; Hotkey Triggers
                    ; ============================================================================

                    ^1::Example1_ProgressTracking()
                    ^2::Example2_DataMonitoring()
                    ^3::Example3_NotificationSystem()
                    ^4::Example4_DebuggingOverlay()
                    ^5::Example5_ContextualHelp()
                    ^6::Example6_GameStatus()
                    ^7::Example7_MultiZoneDisplay()
                    ^0::ExitApp

                    /**
                    * ============================================================================
                    * SUMMARY
                    * ============================================================================
                    *
                    * Advanced ToolTip patterns:
                    * 1. Dynamic progress tracking with visualizations
                    * 2. Real-time data monitoring (CPU, memory, network)
                    * 3. Notification system with different types
                    * 4. Debugging overlays for development
                    * 5. Contextual help system
                    * 6. Game/animation status displays
                    * 7. Multi-zone status displays
                    *
                    * ============================================================================
                    */
