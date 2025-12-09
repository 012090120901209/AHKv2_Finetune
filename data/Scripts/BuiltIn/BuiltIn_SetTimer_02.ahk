/**
* @file BuiltIn_SetTimer_02.ahk
* @description Recurring tasks and scheduled operations with SetTimer in AutoHotkey v2
* @author AutoHotkey v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*
* Advanced SetTimer examples focusing on recurring tasks, scheduled operations,
* task schedulers, periodic maintenance, and automated workflows.
*
* @syntax SetTimer [Function, Period, Priority]
* @see https://www.autohotkey.com/docs/v2/lib/SetTimer.htm
* @requires AutoHotkey v2.0+
*/

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Task Scheduler with Multiple Jobs
; ============================================================================
/**
* Implements a task scheduler that manages multiple recurring jobs
* Each job can have different intervals and enable/disable states
*/
Example1_TaskScheduler() {
    ; Task registry
    static tasks := Map()
    static nextTaskId := 1

    myGui := Gui("+AlwaysOnTop +Resize", "Example 1: Task Scheduler")
    myGui.SetFont("s10")
    myGui.Add("Text", "w600 Center", "Multi-Task Scheduler System")

    ; Task list display
    myGui.Add("Text", "xm", "Active Tasks:")
    taskList := myGui.Add("ListView", "w600 h200 vTaskList", ["ID", "Name", "Interval", "Status", "Runs"])

    ; Log display
    myGui.Add("Text", "xm", "Execution Log:")
    logBox := myGui.Add("Edit", "w600 h150 ReadOnly vLog")

    ; Add task controls
    myGui.Add("Text", "xm Section", "Add New Task:")
    nameEdit := myGui.Add("Edit", "w200 vName", "Task Name")
    intervalEdit := myGui.Add("Edit", "w100 x+10 vInterval", "1000")
    myGui.Add("Text", "x+5", "ms")
    addBtn := myGui.Add("Button", "x+10 w100", "Add Task")

    ; Task control buttons
    myGui.Add("Text", "xm", "`nTask Controls:")
    startBtn := myGui.Add("Button", "w140", "Start Selected")
    stopBtn := myGui.Add("Button", "w140 x+10", "Stop Selected")
    removeBtn := myGui.Add("Button", "w140 x+10", "Remove Selected")
    clearLogBtn := myGui.Add("Button", "w140 x+10", "Clear Log")

    ; Log message helper
    LogMsg(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        ; Auto-scroll by limiting to last 1000 chars
        if (StrLen(logBox.Value) > 10000)
        logBox.Value := SubStr(logBox.Value, -9000)
    }

    ; Add new task
    addBtn.OnEvent("Click", (*) => AddTask())
    AddTask() {
        name := nameEdit.Value
        interval := Integer(intervalEdit.Value)

        if (name = "" || interval < 100) {
            MsgBox("Invalid task parameters!", "Error", "Icon!")
            return
        }

        taskId := nextTaskId++

        ; Create task object
        task := {
            id: taskId,
            name: name,
            interval: interval,
            isActive: false,
            runCount: 0,
            func: (*) => ExecuteTask(taskId)
        }

        tasks[taskId] := task

        ; Add to ListView
        taskList.Add("", taskId, name, interval "ms", "Stopped", 0)
        LogMsg("Task added: " name " (ID: " taskId ")")

        ; Clear inputs
        nameEdit.Value := ""
        intervalEdit.Value := "1000"
    }

    ; Execute task
    ExecuteTask(taskId) {
        if (!tasks.Has(taskId))
        return

        task := tasks[taskId]
        task.runCount++

        ; Update ListView
        Loop taskList.GetCount() {
            if (taskList.GetText(A_Index, 1) = String(taskId)) {
                taskList.Modify(A_Index, , taskId, task.name, task.interval "ms", "Running", task.runCount)
                break
            }
        }

        LogMsg("EXECUTED: " task.name " (Run #" task.runCount ")")
    }

    ; Start selected task
    startBtn.OnEvent("Click", (*) => StartSelectedTask())
    StartSelectedTask() {
        row := taskList.GetNext()
        if (!row) {
            MsgBox("Please select a task!", "Info", "Icon!")
            return
        }

        taskId := Integer(taskList.GetText(row, 1))
        if (!tasks.Has(taskId))
        return

        task := tasks[taskId]
        if (!task.isActive) {
            SetTimer(task.func, task.interval)
            task.isActive := true
            taskList.Modify(row, , taskId, task.name, task.interval "ms", "Running", task.runCount)
            LogMsg("Task started: " task.name)
        }
    }

    ; Stop selected task
    stopBtn.OnEvent("Click", (*) => StopSelectedTask())
    StopSelectedTask() {
        row := taskList.GetNext()
        if (!row)
        return

        taskId := Integer(taskList.GetText(row, 1))
        if (!tasks.Has(taskId))
        return

        task := tasks[taskId]
        if (task.isActive) {
            SetTimer(task.func, 0)
            task.isActive := false
            taskList.Modify(row, , taskId, task.name, task.interval "ms", "Stopped", task.runCount)
            LogMsg("Task stopped: " task.name)
        }
    }

    ; Remove selected task
    removeBtn.OnEvent("Click", (*) => RemoveSelectedTask())
    RemoveSelectedTask() {
        row := taskList.GetNext()
        if (!row)
        return

        taskId := Integer(taskList.GetText(row, 1))
        if (!tasks.Has(taskId))
        return

        task := tasks[taskId]

        ; Stop timer if active
        if (task.isActive)
        SetTimer(task.func, 0)

        tasks.Delete(taskId)
        taskList.Delete(row)
        LogMsg("Task removed: " task.name)
    }

    ; Clear log
    clearLogBtn.OnEvent("Click", (*) => logBox.Value := "")

    ; Cleanup on close
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        for taskId, task in tasks {
            if (task.isActive)
            SetTimer(task.func, 0)
        }
        myGui.Destroy()
    }

    myGui.Show()
    LogMsg("Task Scheduler initialized")
}

; ============================================================================
; EXAMPLE 2: Periodic Backup System
; ============================================================================
/**
* Simulates a periodic backup system with configurable intervals
* Demonstrates file backup automation using timers
*/
Example2_PeriodicBackup() {
    static backupCount := 0
    static lastBackupTime := ""
    static isEnabled := false
    static backupInterval := 5000  ; 5 seconds for demo

    myGui := Gui("+AlwaysOnTop", "Example 2: Periodic Backup System")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Automated Backup System")

    ; Status display
    statusText := myGui.Add("Text", "w500 Center vStatus", "Status: Idle")
    lastBackupText := myGui.Add("Text", "w500 Center vLastBackup", "Last Backup: Never")
    backupCountText := myGui.Add("Text", "w500 Center vBackupCount", "Total Backups: 0")
    nextBackupText := myGui.Add("Text", "w500 Center vNextBackup", "Next Backup: --")

    ; Configuration
    myGui.Add("Text", "xm Section", "`nBackup Configuration:")
    myGui.Add("Text", "xs", "Backup Interval:")
    intervalCombo := myGui.Add("DropDownList", "w200", ["5 seconds", "10 seconds", "30 seconds", "1 minute", "5 minutes"])
    intervalCombo.Choose(1)

    myGui.Add("Text", "xs", "`nBackup Location:")
    locationEdit := myGui.Add("Edit", "w400 ReadOnly", A_ScriptDir "\backups")
    browseBtn := myGui.Add("Button", "x+10 w80", "Browse")

    ; Backup log
    myGui.Add("Text", "xm", "`nBackup History:")
    logBox := myGui.Add("Edit", "w500 h200 ReadOnly vLog")

    ; Control buttons
    enableBtn := myGui.Add("Button", "xm w160", "Enable Auto-Backup")
    disableBtn := myGui.Add("Button", "w160 x+10", "Disable Auto-Backup")
    manualBtn := myGui.Add("Button", "w160 x+10", "Manual Backup Now")

    ; Log helper
    LogBackup(msg) {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"
    }

    ; Timer countdown updater
    UpdateCountdown() {
        if (!isEnabled)
        return

        if (lastBackupTime = "") {
            nextBackupText.Value := "Next Backup: Calculating..."
            return
        }

        ; Calculate time until next backup
        elapsed := A_TickCount - Integer(lastBackupTime)
        remaining := backupInterval - elapsed

        if (remaining < 0)
        remaining := 0

        seconds := Round(remaining / 1000)
        nextBackupText.Value := "Next Backup: " seconds "s"
    }

    ; Perform backup
    PerformBackup() {
        backupCount++
        timestamp := FormatTime(, "yyyy-MM-dd_HHmmss")
        lastBackupTime := A_TickCount

        ; Update displays
        backupCountText.Value := "Total Backups: " backupCount
        lastBackupText.Value := "Last Backup: " FormatTime(, "HH:mm:ss")
        statusText.Value := "Status: Backup completed successfully"

        ; Log the backup
        LogBackup("Backup #" backupCount " completed - backup_" timestamp ".bak")

        ; Reset status after 2 seconds
        SetTimer(() => ResetStatus(), -2000)
    }

    ResetStatus() {
        if (isEnabled)
        statusText.Value := "Status: Auto-backup enabled"
        else
        statusText.Value := "Status: Idle"
    }

    ; Enable auto-backup
    enableBtn.OnEvent("Click", (*) => EnableBackup())
    EnableBackup() {
        if (isEnabled)
        return

        isEnabled := true
        lastBackupTime := A_TickCount

        ; Parse interval
        intervalText := intervalCombo.Text
        if (InStr(intervalText, "5 seconds"))
        backupInterval := 5000
        else if (InStr(intervalText, "10 seconds"))
        backupInterval := 10000
        else if (InStr(intervalText, "30 seconds"))
        backupInterval := 30000
        else if (InStr(intervalText, "1 minute"))
        backupInterval := 60000
        else if (InStr(intervalText, "5 minutes"))
        backupInterval := 300000

        SetTimer(PerformBackup, backupInterval)
        SetTimer(UpdateCountdown, 100)

        statusText.Value := "Status: Auto-backup enabled"
        LogBackup("Auto-backup enabled (interval: " intervalText ")")

        enableBtn.Enabled := false
        disableBtn.Enabled := true
    }

    ; Disable auto-backup
    disableBtn.OnEvent("Click", (*) => DisableBackup())
    DisableBackup() {
        if (!isEnabled)
        return

        isEnabled := false
        SetTimer(PerformBackup, 0)
        SetTimer(UpdateCountdown, 0)

        statusText.Value := "Status: Idle"
        nextBackupText.Value := "Next Backup: --"
        LogBackup("Auto-backup disabled")

        enableBtn.Enabled := true
        disableBtn.Enabled := false
    }

    ; Manual backup
    manualBtn.OnEvent("Click", (*) => ManualBackup())
    ManualBackup() {
        LogBackup("Manual backup triggered")
        PerformBackup()
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(PerformBackup, 0)
        SetTimer(UpdateCountdown, 0)
        myGui.Destroy()
    }

    disableBtn.Enabled := false
    myGui.Show()
    LogBackup("Backup system initialized")
}

; ============================================================================
; EXAMPLE 3: Health Check Monitor
; ============================================================================
/**
* Periodic health check system for monitoring application status
* Demonstrates recurring diagnostic tasks
*/
Example3_HealthCheck() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Health Check Monitor")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Application Health Check Monitor")

    ; Service status displays
    myGui.Add("Text", "xm", "Service Status:")
    service1 := myGui.Add("Progress", "w550 h30 vService1 Background00AA00", 100)
    myGui.Add("Text", "xm vService1Text", "Database Connection: OK")

    service2 := myGui.Add("Progress", "w550 h30 vService2 Background00AA00", 100)
    myGui.Add("Text", "xm vService2Text", "API Endpoint: OK")

    service3 := myGui.Add("Progress", "w550 h30 vService3 Background00AA00", 100)
    myGui.Add("Text", "xm vService3Text", "File System: OK")

    ; Overall health
    overallHealth := myGui.Add("Text", "w550 Center vOverall", "Overall Health: HEALTHY")

    ; Statistics
    myGui.Add("Text", "xm", "`nHealth Check Statistics:")
    checksText := myGui.Add("Text", "w550 vChecks", "Total Checks: 0")
    failuresText := myGui.Add("Text", "w550 vFailures", "Failures Detected: 0")
    uptimeText := myGui.Add("Text", "w550 vUptime", "Monitoring Uptime: 0s")

    ; Event log
    myGui.Add("Text", "xm", "`nEvent Log:")
    logBox := myGui.Add("Edit", "w550 h150 ReadOnly vLog")

    static checkCount := 0
    static failureCount := 0
    static startTime := 0
    static isMonitoring := false

    ; Service health states (randomized for demo)
    static serviceStates := Map(
    "database", {healthy: true, failRate: 0.05},
    "api", {healthy: true, failRate: 0.03},
    "filesystem", {healthy: true, failRate: 0.02}
    )

    ; Log helper
    LogEvent(msg, isError := false) {
        timestamp := FormatTime(, "HH:mm:ss")
        prefix := isError ? "ERROR" : "INFO"
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " [" . prefix . "] " . msg . "`r`n"

        if (StrLen(logBox.Value) > 10000)
        logBox.Value := SubStr(logBox.Value, -9000)
    }

    ; Perform health check
    PerformHealthCheck() {
        checkCount++
        checksText.Value := "Total Checks: " checkCount

        ; Update uptime
        if (startTime > 0) {
            uptime := Round((A_TickCount - startTime) / 1000)
            uptimeText.Value := "Monitoring Uptime: " uptime "s"
        }

        allHealthy := true

        ; Check database
        dbState := serviceStates["database"]
        if (Random(0.0, 1.0) < dbState.failRate) {
            dbState.healthy := false
            service1.Opt("BackgroundAA0000")
            myGui["Service1Text"].Value := "Database Connection: FAILED"
            LogEvent("Database connection check failed!", true)
            failureCount++
            allHealthy := false
        } else {
            dbState.healthy := true
            service1.Opt("Background00AA00")
            myGui["Service1Text"].Value := "Database Connection: OK"
        }

        ; Check API
        apiState := serviceStates["api"]
        if (Random(0.0, 1.0) < apiState.failRate) {
            apiState.healthy := false
            service2.Opt("BackgroundAA0000")
            myGui["Service2Text"].Value := "API Endpoint: TIMEOUT"
            LogEvent("API endpoint check timeout!", true)
            failureCount++
            allHealthy := false
        } else {
            apiState.healthy := true
            service2.Opt("Background00AA00")
            myGui["Service2Text"].Value := "API Endpoint: OK"
        }

        ; Check filesystem
        fsState := serviceStates["filesystem"]
        if (Random(0.0, 1.0) < fsState.failRate) {
            fsState.healthy := false
            service3.Opt("BackgroundAA0000")
            myGui["Service3Text"].Value := "File System: ERROR"
            LogEvent("File system check failed!", true)
            failureCount++
            allHealthy := false
        } else {
            fsState.healthy := true
            service3.Opt("Background00AA00")
            myGui["Service3Text"].Value := "File System: OK"
        }

        ; Update overall health
        if (allHealthy) {
            overallHealth.Value := "Overall Health: HEALTHY"
            overallHealth.SetFont("cGreen")
        } else {
            overallHealth.Value := "Overall Health: DEGRADED"
            overallHealth.SetFont("cRed")
        }

        failuresText.Value := "Failures Detected: " failureCount
    }

    ; Controls
    startBtn := myGui.Add("Button", "xm w170", "Start Monitoring")
    stopBtn := myGui.Add("Button", "w170 x+10", "Stop Monitoring")
    checkNowBtn := myGui.Add("Button", "w170 x+10", "Check Now")

    startBtn.OnEvent("Click", (*) => StartMonitoring())
    StartMonitoring() {
        if (isMonitoring)
        return

        isMonitoring := true
        startTime := A_TickCount
        SetTimer(PerformHealthCheck, 3000)  ; Check every 3 seconds
        LogEvent("Health monitoring started")

        startBtn.Enabled := false
        stopBtn.Enabled := true
    }

    stopBtn.OnEvent("Click", (*) => StopMonitoring())
    StopMonitoring() {
        if (!isMonitoring)
        return

        isMonitoring := false
        SetTimer(PerformHealthCheck, 0)
        LogEvent("Health monitoring stopped")

        startBtn.Enabled := true
        stopBtn.Enabled := false
    }

    checkNowBtn.OnEvent("Click", (*) => PerformHealthCheck())

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(PerformHealthCheck, 0)
        myGui.Destroy()
    }

    stopBtn.Enabled := false
    myGui.Show()
    LogEvent("Health Check Monitor initialized")
}

; ============================================================================
; EXAMPLE 4: Notification Reminder System
; ============================================================================
/**
* Recurring reminder system with snooze functionality
* Demonstrates notification scheduling and management
*/
Example4_ReminderSystem() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Reminder System")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Periodic Reminder & Notification System")

    ; Active reminders list
    myGui.Add("Text", "xm", "Active Reminders:")
    reminderList := myGui.Add("ListView", "w500 h150", ["Time", "Message", "Interval", "Count"])

    ; Add reminder form
    myGui.Add("Text", "xm Section", "`nAdd New Reminder:")
    messageEdit := myGui.Add("Edit", "w350 vMessage", "Reminder message")

    myGui.Add("Text", "xs", "Repeat every:")
    intervalEdit := myGui.Add("Edit", "w100 vInterval", "60")
    myGui.Add("Text", "x+5", "seconds")

    addBtn := myGui.Add("Button", "xs w150", "Add Reminder")
    removeBtn := myGui.Add("Button", "w150 x+10", "Remove Selected")

    ; Activity log
    myGui.Add("Text", "xm", "`nNotification Log:")
    logBox := myGui.Add("Edit", "w500 h120 ReadOnly vLog")

    static reminders := []
    static reminderFuncs := Map()

    ; Log helper
    LogNotification(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 5000)
        logBox.Value := SubStr(logBox.Value, -4000)
    }

    ; Add reminder
    addBtn.OnEvent("Click", (*) => AddReminder())
    AddReminder() {
        message := messageEdit.Value
        interval := Integer(intervalEdit.Value) * 1000

        if (message = "" || interval < 1000) {
            MsgBox("Invalid reminder parameters!", "Error", "Icon!")
            return
        }

        startTime := FormatTime(, "HH:mm:ss")

        ; Create reminder object
        reminder := {
            message: message,
            interval: interval,
            count: 0,
            startTime: startTime
        }

        reminders.Push(reminder)
        idx := reminders.Length

        ; Add to list
        reminderList.Add("", startTime, message, interval // 1000 . "s", 0)

        ; Create and start timer
        timerFunc := (*) => TriggerReminder(idx)
        reminderFuncs[idx] := timerFunc
        SetTimer(timerFunc, interval)

        LogNotification("Reminder added: " message)

        ; Clear form
        messageEdit.Value := ""
        intervalEdit.Value := "60"
    }

    ; Trigger reminder
    TriggerReminder(idx) {
        if (idx > reminders.Length)
        return

        reminder := reminders[idx]
        reminder.count++

        ; Update list
        reminderList.Modify(idx, , reminder.startTime, reminder.message,
        reminder.interval // 1000 . "s", reminder.count)

        ; Show notification
        ToolTip("REMINDER: " reminder.message, 100, 100)
        SetTimer(() => ToolTip(), -3000)

        LogNotification("Triggered: " reminder.message " (Count: " reminder.count ")")

        ; Optional: Sound notification
        SoundBeep(800, 200)
    }

    ; Remove reminder
    removeBtn.OnEvent("Click", (*) => RemoveReminder())
    RemoveReminder() {
        row := reminderList.GetNext()
        if (!row)
        return

        ; Stop timer
        if (reminderFuncs.Has(row)) {
            SetTimer(reminderFuncs[row], 0)
            reminderFuncs.Delete(row)
        }

        message := reminders[row].message
        reminders.RemoveAt(row)
        reminderList.Delete(row)

        LogNotification("Reminder removed: " message)
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        for idx, func in reminderFuncs
        SetTimer(func, 0)
        ToolTip()
        myGui.Destroy()
    }

    myGui.Show()
    LogNotification("Reminder system ready")
}

; ============================================================================
; EXAMPLE 5: Data Synchronization Timer
; ============================================================================
/**
* Simulates periodic data synchronization with conflict detection
* Demonstrates coordinated recurring tasks
*/
Example5_DataSync() {
    myGui := Gui("+AlwaysOnTop", "Example 5: Data Synchronization")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Automatic Data Synchronization System")

    ; Sync status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Status: Idle")
    progressBar := myGui.Add("Progress", "w550 h30 vProgress", 0)
    lastSyncText := myGui.Add("Text", "w550 Center vLastSync", "Last Sync: Never")

    ; Statistics
    myGui.Add("Text", "xm", "`nStatistics:")
    totalSyncsText := myGui.Add("Text", "w270 vTotalSyncs", "Total Syncs: 0")
    successText := myGui.Add("Text", "w270 x+10 vSuccess", "Successful: 0")
    uploadedText := myGui.Add("Text", "w270 xm vUploaded", "Items Uploaded: 0")
    downloadedText := myGui.Add("Text", "w270 x+10 vDownloaded", "Items Downloaded: 0")

    ; Configuration
    myGui.Add("Text", "xm", "`nSync Settings:")
    myGui.Add("Text", "xm", "Sync Interval:")
    intervalCombo := myGui.Add("DropDownList", "w200", ["10 seconds", "30 seconds", "1 minute"])
    intervalCombo.Choose(1)

    ; Log
    myGui.Add("Text", "xm", "`nSync Log:")
    logBox := myGui.Add("Edit", "w550 h150 ReadOnly vLog")

    static totalSyncs := 0
    static successfulSyncs := 0
    static totalUploaded := 0
    static totalDownloaded := 0
    static isSyncing := false
    static syncInterval := 10000

    ; Log helper
    LogSync(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
        logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Simulate sync operation
    PerformSync() {
        if (isSyncing)
        return

        isSyncing := true
        totalSyncs++

        statusText.Value := "Status: Synchronizing..."
        progressBar.Value := 0

        ; Simulate sync phases
        LogSync("Starting synchronization cycle #" totalSyncs)

        ; Phase 1: Check for updates (0-25%)
        SetTimer(() => SyncPhase1(), -500)
    }

    SyncPhase1() {
        progressBar.Value := 25
        LogSync("Checking for remote updates...")
        SetTimer(() => SyncPhase2(), -500)
    }

    SyncPhase2() {
        ; Phase 2: Download (25-50%)
        downloaded := Random(0, 10)
        totalDownloaded += downloaded
        progressBar.Value := 50
        LogSync("Downloaded " downloaded " items")
        downloadedText.Value := "Items Downloaded: " totalDownloaded
        SetTimer(() => SyncPhase3(), -500)
    }

    SyncPhase3() {
        ; Phase 3: Upload (50-75%)
        uploaded := Random(0, 8)
        totalUploaded += uploaded
        progressBar.Value := 75
        LogSync("Uploaded " uploaded " items")
        uploadedText.Value := "Items Uploaded: " totalUploaded
        SetTimer(() => SyncPhase4(), -500)
    }

    SyncPhase4() {
        ; Phase 4: Finalize (75-100%)
        progressBar.Value := 100

        ; Random success/failure (95% success rate)
        success := Random(0.0, 1.0) > 0.05

        if (success) {
            successfulSyncs++
            statusText.Value := "Status: Sync completed successfully"
            LogSync("Synchronization completed successfully")
        } else {
            statusText.Value := "Status: Sync failed - will retry"
            LogSync("ERROR: Synchronization failed!")
        }

        lastSyncText.Value := "Last Sync: " FormatTime(, "HH:mm:ss")
        totalSyncsText.Value := "Total Syncs: " totalSyncs
        successText.Value := "Successful: " successfulSyncs

        isSyncing := false

        ; Reset status after 2 seconds
        SetTimer(() => ResetStatus(), -2000)
    }

    ResetStatus() {
        statusText.Value := "Status: Auto-sync enabled"
        progressBar.Value := 0
    }

    ; Controls
    startBtn := myGui.Add("Button", "xm w170", "Start Auto-Sync")
    stopBtn := myGui.Add("Button", "w170 x+10", "Stop Auto-Sync")
    syncNowBtn := myGui.Add("Button", "w170 x+10", "Sync Now")

    static autoSyncEnabled := false

    startBtn.OnEvent("Click", (*) => StartAutoSync())
    StartAutoSync() {
        if (autoSyncEnabled)
        return

        ; Get interval
        intervalText := intervalCombo.Text
        if (InStr(intervalText, "10 seconds"))
        syncInterval := 10000
        else if (InStr(intervalText, "30 seconds"))
        syncInterval := 30000
        else if (InStr(intervalText, "1 minute"))
        syncInterval := 60000

        SetTimer(PerformSync, syncInterval)
        autoSyncEnabled := true
        statusText.Value := "Status: Auto-sync enabled"
        LogSync("Auto-sync enabled (interval: " intervalText ")")

        startBtn.Enabled := false
        stopBtn.Enabled := true
    }

    stopBtn.OnEvent("Click", (*) => StopAutoSync())
    StopAutoSync() {
        if (!autoSyncEnabled)
        return

        SetTimer(PerformSync, 0)
        autoSyncEnabled := false
        statusText.Value := "Status: Idle"
        LogSync("Auto-sync disabled")

        startBtn.Enabled := true
        stopBtn.Enabled := false
    }

    syncNowBtn.OnEvent("Click", (*) => PerformSync())

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(PerformSync, 0)
        SetTimer(SyncPhase1, 0)
        SetTimer(SyncPhase2, 0)
        SetTimer(SyncPhase3, 0)
        SetTimer(SyncPhase4, 0)
        SetTimer(ResetStatus, 0)
        myGui.Destroy()
    }

    stopBtn.Enabled := false
    myGui.Show()
    LogSync("Data synchronization system initialized")
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "SetTimer Examples - Recurring Tasks")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - SetTimer Recurring Tasks")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Task Scheduler").OnEvent("Click", (*) => Example1_TaskScheduler())
MainMenu.Add("Button", "w450", "Example 2: Periodic Backup System").OnEvent("Click", (*) => Example2_PeriodicBackup())
MainMenu.Add("Button", "w450", "Example 3: Health Check Monitor").OnEvent("Click", (*) => Example3_HealthCheck())
MainMenu.Add("Button", "w450", "Example 4: Reminder System").OnEvent("Click", (*) => Example4_ReminderSystem())
MainMenu.Add("Button", "w450", "Example 5: Data Synchronization").OnEvent("Click", (*) => Example5_DataSync())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
