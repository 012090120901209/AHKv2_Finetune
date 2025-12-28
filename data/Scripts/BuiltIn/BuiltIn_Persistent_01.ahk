/**
 * @file BuiltIn_Persistent_01.ahk
 * @description Keeping scripts running persistently in AutoHotkey v2
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Persistent keeps a script running even when it has no hotkeys, timers, or
 * GUI windows. Essential for daemon scripts, background services, monitoring
 * applications, and server-like functionality.
 * 
 * @syntax Persistent [NewValue]
 * @param NewValue - true (persistent), false (not persistent), or omit (toggle)
 * 
 * @see https://www.autohotkey.com/docs/v2/lib/Persistent.htm
 * @requires AutoHotkey v2.0+
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Basic Persistent Daemon
; ============================================================================
/**
 * Demonstrates a basic persistent daemon script
 * Runs continuously in the background monitoring system
 */
Example1_BasicDaemon() {
    ; Make script persistent
    Persistent(true)

    ; Create system tray icon with menu
    A_IconTip := "Example 1: Basic Daemon`nRunning persistently in background"

    ; Tray menu
    TrayMenu := A_TrayMenu
    TrayMenu.Delete()  ; Remove default menu items
    TrayMenu.Add("Show Status Window", (*) => ShowStatusWindow())
    TrayMenu.Add("View Activity Log", (*) => ShowActivityLog())
    TrayMenu.Add()  ; Separator
    TrayMenu.Add("Restart Daemon", (*) => Reload())
    TrayMenu.Add("Exit Daemon", (*) => ExitApp())
    TrayMenu.Default := "Show Status Window"

    ; Status tracking
    static startTime := A_TickCount
    static activityLog := []
    static eventCount := 0

    ; Log activity
    LogActivity(event) {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        activityLog.Push(timestamp . " - " . event)

        ; Keep only last 100 events
        if (activityLog.Length > 100)
            activityLog.RemoveAt(1)

        eventCount++
    }

    ; Background monitoring function
    MonitorSystem() {
        ; Monitor system changes
        currentTitle := WinGetTitle("A")

        static lastTitle := ""

        if (currentTitle != lastTitle && currentTitle != "") {
            LogActivity("Window changed: " currentTitle)
            lastTitle := currentTitle
        }
    }

    ; Set up monitoring timer
    SetTimer(MonitorSystem, 2000)

    ; Show status window
    ShowStatusWindow() {
        uptime := Round((A_TickCount - startTime) / 1000)
        hours := uptime // 3600
        minutes := Mod(uptime // 60, 60)
        seconds := Mod(uptime, 60)

        statusGui := Gui("+AlwaysOnTop", "Daemon Status")
        statusGui.SetFont("s10")
        statusGui.Add("Text", "w400 Center", "Basic Persistent Daemon")

        statusGui.Add("Text", "xm Section", "Status:")
        statusGui.Add("Text", "xs", "State: RUNNING")
        statusGui.Add("Text", "xs", "Uptime: " Format("{:02d}:{:02d}:{:02d}", hours, minutes, seconds))
        statusGui.Add("Text", "xs", "Events Logged: " eventCount)
        statusGui.Add("Text", "xs", "Started: " FormatTime(, "yyyy-MM-dd HH:mm:ss"))

        statusGui.Add("Button", "xs w400", "Close").OnEvent("Click", (*) => statusGui.Destroy())

        statusGui.Show()
    }

    ; Show activity log
    ShowActivityLog() {
        logGui := Gui("+AlwaysOnTop +Resize", "Activity Log")
        logGui.SetFont("s10")
        logGui.Add("Text", "w500 Center", "Daemon Activity Log")

        logText := ""
        Loop activityLog.Length {
            idx := activityLog.Length - A_Index + 1  ; Reverse order (newest first)
            logText .= activityLog[idx] . "`n"
        }

        logBox := logGui.Add("Edit", "w500 h400 ReadOnly", logText)
        logGui.Add("Button", "w500", "Close").OnEvent("Click", (*) => logGui.Destroy())

        logGui.Show()
    }

    ; Initialization
    LogActivity("Daemon started")
    TrayTip("Daemon Started", "Basic persistent daemon is now running in background.", "Icon!")
}

; ============================================================================
; EXAMPLE 2: Background File Watcher
; ============================================================================
/**
 * Implements a persistent file monitoring daemon
 * Watches directory for changes and logs them
 */
Example2_FileWatcher() {
    Persistent(true)

    A_IconTip := "Example 2: File Watcher`nMonitoring directory changes"

    ; Configuration
    static watchDir := A_ScriptDir
    static lastScan := Map()
    static changes := []

    ; Tray menu
    TrayMenu := A_TrayMenu
    TrayMenu.Delete()
    TrayMenu.Add("Show Watcher Status", (*) => ShowStatus())
    TrayMenu.Add("View Changes", (*) => ViewChanges())
    TrayMenu.Add("Change Directory", (*) => ChangeDirectory())
    TrayMenu.Add()
    TrayMenu.Add("Exit Watcher", (*) => ExitApp())
    TrayMenu.Default := "Show Watcher Status"

    ; Scan directory
    ScanDirectory() {
        currentScan := Map()

        try {
            Loop Files watchDir "\*.*" {
                currentScan[A_LoopFileName] := {
                    size: A_LoopFileSize,
                    modified: A_LoopFileTimeModified
                }
            }
        } catch {
            return
        }

        ; Compare with last scan
        if (lastScan.Count > 0) {
            ; Check for new/modified files
            for fileName, fileInfo in currentScan {
                if (!lastScan.Has(fileName)) {
                    LogChange("NEW: " fileName)
                } else {
                    oldInfo := lastScan[fileName]
                    if (fileInfo.modified != oldInfo.modified) {
                        LogChange("MODIFIED: " fileName)
                    }
                }
            }

            ; Check for deleted files
            for fileName, fileInfo in lastScan {
                if (!currentScan.Has(fileName)) {
                    LogChange("DELETED: " fileName)
                }
            }
        }

        lastScan := currentScan
    }

    ; Log change
    LogChange(change) {
        timestamp := FormatTime(, "HH:mm:ss")
        changes.Push(timestamp . " - " . change)

        ; Keep only last 100 changes
        if (changes.Length > 100)
            changes.RemoveAt(1)

        ; Show notification
        TrayTip("File Change Detected", change, "Icon!")
    }

    ; Start monitoring
    SetTimer(ScanDirectory, 2000)  ; Scan every 2 seconds

    ; Show status
    ShowStatus() {
        statusGui := Gui("+AlwaysOnTop", "File Watcher Status")
        statusGui.SetFont("s10")
        statusGui.Add("Text", "w500 Center", "File System Watcher")

        statusGui.Add("Text", "xm Section", "Configuration:")
        statusGui.Add("Text", "xs w500", "Watched Directory: " watchDir)
        statusGui.Add("Text", "xs", "Files Tracked: " lastScan.Count)
        statusGui.Add("Text", "xs", "Changes Detected: " changes.Length)

        statusGui.Add("Button", "xs w500", "Close").OnEvent("Click", (*) => statusGui.Destroy())

        statusGui.Show()
    }

    ; View changes
    ViewChanges() {
        changesGui := Gui("+AlwaysOnTop +Resize", "Recent Changes")
        changesGui.SetFont("s10")
        changesGui.Add("Text", "w500 Center", "File System Changes")

        changeText := ""
        if (changes.Length = 0) {
            changeText := "No changes detected yet."
        } else {
            Loop changes.Length {
                idx := changes.Length - A_Index + 1
                changeText .= changes[idx] . "`n"
            }
        }

        changesGui.Add("Edit", "w500 h400 ReadOnly", changeText)
        changesGui.Add("Button", "w500", "Close").OnEvent("Click", (*) => changesGui.Destroy())

        changesGui.Show()
    }

    ; Change directory
    ChangeDirectory() {
        newDir := DirSelect(watchDir, 0, "Select directory to watch:")

        if (newDir != "") {
            watchDir := newDir
            lastScan := Map()
            changes := []
            LogChange("Watching new directory: " watchDir)
            A_IconTip := "File Watcher`nMonitoring: " watchDir
        }
    }

    ; Initial scan
    ScanDirectory()
    TrayTip("File Watcher Started", "Monitoring: " watchDir, "Icon!")
}

; ============================================================================
; EXAMPLE 3: Periodic Task Scheduler
; ============================================================================
/**
 * Implements a persistent task scheduler daemon
 * Executes scheduled tasks at specified intervals
 */
Example3_TaskScheduler() {
    Persistent(true)

    A_IconTip := "Example 3: Task Scheduler`nPersistent background scheduler"

    ; Task registry
    static tasks := []
    static taskHistory := []

    ; Tray menu
    TrayMenu := A_TrayMenu
    TrayMenu.Delete()
    TrayMenu.Add("Manage Tasks", (*) => ShowTaskManager())
    TrayMenu.Add("View History", (*) => ViewHistory())
    TrayMenu.Add()
    TrayMenu.Add("Exit Scheduler", (*) => ExitApp())
    TrayMenu.Default := "Manage Tasks"

    ; Task class

    ; Log task execution
    LogTaskHistory(taskName, result) {
        timestamp := FormatTime(, "HH:mm:ss")
        taskHistory.Push(timestamp . " - " . taskName . " - " . result)

        if (taskHistory.Length > 100)
            taskHistory.RemoveAt(1)
    }

    ; Task checker (runs frequently)
    CheckTasks() {
        for task in tasks {
            if (task.ShouldRun()) {
                task.Execute()
            }
        }
    }

    SetTimer(CheckTasks, 5000)  ; Check every 5 seconds

    ; Sample tasks
    tasks.Push(ScheduledTask("Cleanup Temp", 30, () => CleanupTemp()))
    tasks.Push(ScheduledTask("System Check", 15, () => SystemCheck()))
    tasks.Push(ScheduledTask("Backup Config", 60, () => BackupConfig()))

    ; Task implementations
    CleanupTemp() {
        ; Simulate cleanup
        Sleep(100)
        TrayTip("Task Executed", "Temp cleanup completed", "Icon!")
    }

    SystemCheck() {
        ; Simulate system check
        Sleep(100)
        TrayTip("Task Executed", "System check completed", "Icon!")
    }

    BackupConfig() {
        ; Simulate backup
        Sleep(100)
        TrayTip("Task Executed", "Config backup completed", "Icon!")
    }

    ; Show task manager
    ShowTaskManager() {
        tmGui := Gui("+AlwaysOnTop", "Task Manager")
        tmGui.SetFont("s10")
        tmGui.Add("Text", "w600 Center", "Scheduled Tasks")

        tmGui.Add("Text", "xm", "Active Tasks:")
        taskList := tmGui.Add("ListView", "w600 h200", ["Task Name", "Interval", "Runs", "Status"])

        for task in tasks {
            intervalMin := Round(task.interval / 60000)
            status := task.enabled ? "Enabled" : "Disabled"
            taskList.Add("", task.name, intervalMin . " min", task.runCount, status)
        }

        tmGui.Add("Button", "xm w600", "Close").OnEvent("Click", (*) => tmGui.Destroy())

        tmGui.Show()
    }

    ; View history
    ViewHistory() {
        histGui := Gui("+AlwaysOnTop +Resize", "Task Execution History")
        histGui.SetFont("s10")
        histGui.Add("Text", "w500 Center", "Recent Task Executions")

        histText := ""
        if (taskHistory.Length = 0) {
            histText := "No tasks executed yet."
        } else {
            Loop taskHistory.Length {
                idx := taskHistory.Length - A_Index + 1
                histText .= taskHistory[idx] . "`n"
            }
        }

        histGui.Add("Edit", "w500 h400 ReadOnly", histText)
        histGui.Add("Button", "w500", "Close").OnEvent("Click", (*) => histGui.Destroy())

        histGui.Show()
    }

    TrayTip("Task Scheduler Started", tasks.Length . " tasks loaded and active", "Icon!")
}

; ============================================================================
; EXAMPLE 4: System Monitor Daemon
; ============================================================================
/**
 * Implements persistent system monitoring
 * Continuously monitors and logs system metrics
 */
Example4_SystemMonitor() {
    Persistent(true)

    A_IconTip := "Example 4: System Monitor`nMonitoring system metrics"

    ; Metrics storage
    static metrics := Map(
        "samples", 0,
        "startTime", A_TickCount,
        "windowChanges", 0,
        "mouseMovement", 0
    )

    static metricHistory := []

    ; Tray menu
    TrayMenu := A_TrayMenu
    TrayMenu.Delete()
    TrayMenu.Add("Show Dashboard", (*) => ShowDashboard())
    TrayMenu.Add("View Metrics", (*) => ViewMetrics())
    TrayMenu.Add("Reset Metrics", (*) => ResetMetrics())
    TrayMenu.Add()
    TrayMenu.Add("Exit Monitor", (*) => ExitApp())
    TrayMenu.Default := "Show Dashboard"

    ; Collect metrics
    static lastWindowTitle := ""
    static lastMouseX := 0
    static lastMouseY := 0

    CollectMetrics() {
        metrics["samples"]++

        ; Window tracking
        currentWindow := WinGetTitle("A")
        if (currentWindow != lastWindowTitle && currentWindow != "") {
            metrics["windowChanges"]++
            lastWindowTitle := currentWindow
            LogMetric("Window changed: " currentWindow)
        }

        ; Mouse movement tracking
        MouseGetPos(&currentX, &currentY)
        if (currentX != lastMouseX || currentY != lastMouseY) {
            distance := Sqrt((currentX - lastMouseX) ** 2 + (currentY - lastMouseY) ** 2)
            metrics["mouseMovement"] += distance
            lastMouseX := currentX
            lastMouseY := currentY
        }

        ; Periodic metric snapshot
        if (Mod(metrics["samples"], 60) = 0) {  ; Every 60 samples
            TakeSnapshot()
        }
    }

    ; Take metric snapshot
    TakeSnapshot() {
        uptime := Round((A_TickCount - metrics["startTime"]) / 1000)

        snapshot := {
            timestamp: FormatTime(, "HH:mm:ss"),
            uptime: uptime,
            samples: metrics["samples"],
            windowChanges: metrics["windowChanges"],
            mouseMovement: Round(metrics["mouseMovement"])
        }

        metricHistory.Push(snapshot)

        if (metricHistory.Length > 100)
            metricHistory.RemoveAt(1)
    }

    ; Log metric event
    LogMetric(event) {
        ; Could log to file or database
        ; For demo, we'll just use TrayTip occasionally
        if (Mod(metrics["samples"], 100) = 0) {
            TrayTip("Monitor Active", "Collected " metrics["samples"] " samples", "Icon!")
        }
    }

    ; Start monitoring
    SetTimer(CollectMetrics, 1000)  ; Every second

    ; Show dashboard
    ShowDashboard() {
        uptime := Round((A_TickCount - metrics["startTime"]) / 1000)
        hours := uptime // 3600
        minutes := Mod(uptime // 60, 60)
        seconds := Mod(uptime, 60)

        dashGui := Gui("+AlwaysOnTop", "System Monitor Dashboard")
        dashGui.SetFont("s10")
        dashGui.Add("Text", "w400 Center", "System Monitoring Dashboard")

        dashGui.Add("Text", "xm Section", "System Metrics:")
        dashGui.Add("Text", "xs", "Uptime: " Format("{:02d}:{:02d}:{:02d}", hours, minutes, seconds))
        dashGui.Add("Text", "xs", "Samples Collected: " metrics["samples"])
        dashGui.Add("Text", "xs", "Window Changes: " metrics["windowChanges"])
        dashGui.Add("Text", "xs", "Mouse Movement: " Round(metrics["mouseMovement"]) " pixels")
        dashGui.Add("Text", "xs", "Snapshots Saved: " metricHistory.Length)

        dashGui.Add("Button", "xs w400", "Close").OnEvent("Click", (*) => dashGui.Destroy())

        dashGui.Show()
    }

    ; View metrics history
    ViewMetrics() {
        metricsGui := Gui("+AlwaysOnTop +Resize", "Metrics History")
        metricsGui.SetFont("s10")
        metricsGui.Add("Text", "w600 Center", "Metric Snapshots")

        metricsGui.Add("Text", "xm", "Recent Snapshots:")
        listView := metricsGui.Add("ListView", "w600 h300",
            ["Time", "Uptime", "Samples", "Windows", "Mouse Px"])

        for snapshot in metricHistory {
            listView.Add("",
                snapshot.timestamp,
                snapshot.uptime . "s",
                snapshot.samples,
                snapshot.windowChanges,
                snapshot.mouseMovement)
        }

        metricsGui.Add("Button", "xm w600", "Close").OnEvent("Click", (*) => metricsGui.Destroy())

        metricsGui.Show()
    }

    ; Reset metrics
    ResetMetrics() {
        result := MsgBox("Reset all metrics?", "Confirm Reset", "YesNo Icon?")

        if (result = "Yes") {
            metrics["samples"] := 0
            metrics["startTime"] := A_TickCount
            metrics["windowChanges"] := 0
            metrics["mouseMovement"] := 0
            metricHistory := []

            TrayTip("Metrics Reset", "All metrics have been reset", "Icon!")
        }
    }

    TrayTip("System Monitor Started", "Now monitoring system activity", "Icon!")
}

; ============================================================================
; EXAMPLE 5: Auto-Restart Persistent Service
; ============================================================================
/**
 * Implements a self-healing persistent service
 * Monitors its own health and restarts if needed
 */
Example5_SelfHealing() {
    Persistent(true)

    A_IconTip := "Example 5: Self-Healing Service`nPersistent with auto-recovery"

    ; Health tracking
    static healthStatus := Map(
        "healthy", true,
        "lastHealthCheck", A_TickCount,
        "errorCount", 0,
        "restartCount", 0,
        "startTime", A_TickCount
    )

    static healthLog := []

    ; Tray menu
    TrayMenu := A_TrayMenu
    TrayMenu.Delete()
    TrayMenu.Add("Health Status", (*) => ShowHealthStatus())
    TrayMenu.Add("View Health Log", (*) => ViewHealthLog())
    TrayMenu.Add("Force Health Check", (*) => PerformHealthCheck())
    TrayMenu.Add()
    TrayMenu.Add("Simulate Error", (*) => SimulateError())
    TrayMenu.Add()
    TrayMenu.Add("Exit Service", (*) => ExitApp())
    TrayMenu.Default := "Health Status"

    ; Perform health check
    PerformHealthCheck() {
        LogHealth("Performing health check...")

        try {
            ; Check 1: Verify we're still running
            if (!ProcessExist(ProcessExist())) {
                throw Error("Process not found")
            }

            ; Check 2: Check memory (simulated)
            ; In real app, could check actual memory usage

            ; Check 3: Verify timers are running
            ; Simulated check

            ; All checks passed
            healthStatus["healthy"] := true
            healthStatus["lastHealthCheck"] := A_TickCount
            healthStatus["errorCount"] := 0

            LogHealth("Health check PASSED")

        } catch Error as err {
            ; Health check failed
            healthStatus["healthy"] := false
            healthStatus["errorCount"]++

            LogHealth("Health check FAILED: " err.Message)

            ; Auto-restart if too many errors
            if (healthStatus["errorCount"] >= 3) {
                LogHealth("Multiple failures detected - initiating restart...")
                RestartService()
            }
        }
    }

    ; Restart service
    RestartService() {
        healthStatus["restartCount"]++

        LogHealth("Restarting service (restart #" healthStatus["restartCount"] ")")

        TrayTip("Service Restarting", "Auto-recovery in progress...", "Icon!")

        Sleep(1000)
        Reload()
    }

    ; Log health event
    LogHealth(event) {
        timestamp := FormatTime(, "HH:mm:ss")
        healthLog.Push(timestamp . " - " . event)

        if (healthLog.Length > 100)
            healthLog.RemoveAt(1)
    }

    ; Periodic health checks
    SetTimer(PerformHealthCheck, 30000)  ; Every 30 seconds

    ; Show health status
    ShowHealthStatus() {
        uptime := Round((A_TickCount - healthStatus["startTime"]) / 1000)
        lastCheck := Round((A_TickCount - healthStatus["lastHealthCheck"]) / 1000)

        statusGui := Gui("+AlwaysOnTop", "Service Health Status")
        statusGui.SetFont("s10")
        statusGui.Add("Text", "w400 Center", "Self-Healing Service Status")

        ; Health indicator
        statusGui.SetFont("s16 Bold")
        healthText := statusGui.Add("Text", "w400 Center Border",
            healthStatus["healthy"] ? "● HEALTHY" : "⚠ UNHEALTHY")

        if (healthStatus["healthy"]) {
            healthText.SetFont("cGreen")
        } else {
            healthText.SetFont("cRed")
        }

        statusGui.SetFont("s10 Norm")

        statusGui.Add("Text", "xm Section", "Service Information:")
        statusGui.Add("Text", "xs", "Uptime: " uptime . " seconds")
        statusGui.Add("Text", "xs", "Last Health Check: " lastCheck . " seconds ago")
        statusGui.Add("Text", "xs", "Error Count: " healthStatus["errorCount"])
        statusGui.Add("Text", "xs", "Restart Count: " healthStatus["restartCount"])

        statusGui.Add("Button", "xs w400", "Close").OnEvent("Click", (*) => statusGui.Destroy())

        statusGui.Show()
    }

    ; View health log
    ViewHealthLog() {
        logGui := Gui("+AlwaysOnTop +Resize", "Health Log")
        logGui.SetFont("s10")
        logGui.Add("Text", "w500 Center", "Service Health Log")

        logText := ""
        if (healthLog.Length = 0) {
            logText := "No health events logged yet."
        } else {
            Loop healthLog.Length {
                idx := healthLog.Length - A_Index + 1
                logText .= healthLog[idx] . "`n"
            }
        }

        logGui.Add("Edit", "w500 h400 ReadOnly", logText)
        logGui.Add("Button", "w500", "Close").OnEvent("Click", (*) => logGui.Destroy())

        logGui.Show()
    }

    ; Simulate error for testing
    SimulateError() {
        LogHealth("SIMULATED ERROR for testing")
        healthStatus["errorCount"]++

        if (healthStatus["errorCount"] >= 3) {
            LogHealth("Error threshold reached - will restart on next check")
        }

        TrayTip("Error Simulated", "Error count: " healthStatus["errorCount"], "Icon!")
    }

    ; Startup
    LogHealth("Service started")
    PerformHealthCheck()  ; Initial health check

    TrayTip("Self-Healing Service Started",
        "Persistent service with auto-recovery is active", "Icon!")
}

; ============================================================================
; MAIN MENU - Launch Examples
; ============================================================================
MainMenu := Gui(, "Persistent Examples")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Persistent Script Examples")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Basic Daemon").OnEvent("Click", (*) => (MainMenu.Destroy(), Example1_BasicDaemon()))
MainMenu.Add("Button", "w450", "Example 2: File Watcher").OnEvent("Click", (*) => (MainMenu.Destroy(), Example2_FileWatcher()))
MainMenu.Add("Button", "w450", "Example 3: Task Scheduler").OnEvent("Click", (*) => (MainMenu.Destroy(), Example3_TaskScheduler()))
MainMenu.Add("Button", "w450", "Example 4: System Monitor").OnEvent("Click", (*) => (MainMenu.Destroy(), Example4_SystemMonitor()))
MainMenu.Add("Button", "w450", "Example 5: Self-Healing Service").OnEvent("Click", (*) => (MainMenu.Destroy(), Example5_SelfHealing()))

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()

; Moved class ScheduledTask from nested scope
class ScheduledTask {
    __New(name, intervalMinutes, action) {
        this.name := name
        this.interval := intervalMinutes * 60000  ; Convert to ms
        this.action := action
        this.lastRun := 0
        this.runCount := 0
        this.enabled := true
    }

    ShouldRun() {
        if (!this.enabled)
            return false

        if (this.lastRun = 0)
            return true

        return (A_TickCount - this.lastRun) >= this.interval
    }

    Execute() {
        this.lastRun := A_TickCount
        this.runCount++

        try {
            this.action.Call()
            LogTaskHistory(this.name, "SUCCESS")
            return true
        } catch Error as err {
            LogTaskHistory(this.name, "FAILED: " err.Message)
            return false
        }
    }
}
