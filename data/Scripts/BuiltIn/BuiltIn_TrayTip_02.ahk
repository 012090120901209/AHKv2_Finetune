#Requires AutoHotkey v2.0

/**
* ============================================================================
* TrayTip Advanced Applications - Part 2
* ============================================================================
*
* Advanced TrayTip applications and notification systems in AutoHotkey v2.
*
* @description This file covers advanced TrayTip usage including:
*              - Notification scheduling
*              - Event-driven notifications
*              - System monitoring alerts
*              - Application status updates
*              - User interaction notifications
*              - Custom notification systems
*
* @author AutoHotkey Foundation
* @version 2.0
* @see https://www.autohotkey.com/docs/v2/lib/TrayTip.htm
*
* ============================================================================
*/

; ============================================================================
; EXAMPLE 1: Scheduled Notifications
; ============================================================================
/**
* Creates scheduled notification system.
*
* @description Demonstrates time-based notification scheduling.
*/
Example1_ScheduledNotifications() {
    ; Hourly reminder
    ScheduleHourlyReminder()

    ; Time-specific notifications
    ScheduleTimeBasedNotifications()

    ; Countdown notifications
    ShowCountdownNotifications(5)

    ; Interval notifications
    ShowIntervalNotifications(3, 2)
}

/**
* Schedules hourly reminders.
*/
ScheduleHourlyReminder() {
    MsgBox "Simulating hourly reminder (will show 3 reminders)"

    Loop 3 {
        currentTime := FormatTime(, "HH:mm")
        TrayTip "Hourly Reminder",
        Format("Time: {1}`n`nRemember to save your work!", currentTime),
        1
        Sleep 2000
        TrayTip
        Sleep 1000
    }
}

/**
* Time-based notifications.
*/
ScheduleTimeBasedNotifications() {
    ; Morning notification
    TrayTip "Good Morning!",
    "Start your day with productivity.`n`nTasks for today: 5",
    1
    Sleep 2000
    TrayTip

    Sleep 500

    ; Afternoon notification
    TrayTip "Afternoon Break",
    "Time for a quick break.`n`nYou've been working for 4 hours.",
    1
    Sleep 2000
    TrayTip

    Sleep 500

    ; Evening notification
    TrayTip "End of Day",
    "Great work today!`n`nDon't forget to clock out.",
    1
    Sleep 2000
    TrayTip
}

/**
* Countdown notifications.
*/
ShowCountdownNotifications(seconds) {
    Loop seconds {
        remaining := seconds - A_Index + 1

        if (remaining <= 3) {
            TrayTip "Countdown",
            Format("Starting in {1} second(s)...", remaining),
            2
            Sleep 1000
            TrayTip
        }
    }

    TrayTip "Started!",
    "Process has begun.",
    1
    Sleep 2000
    TrayTip
}

/**
* Interval-based notifications.
*/
ShowIntervalNotifications(count, intervalSeconds) {
    Loop count {
        TrayTip "Periodic Reminder",
        Format("Reminder #{1} of {2}`n`nTime: {3}",
        A_Index,
        count,
        FormatTime(, "HH:mm:ss")),
        1
        Sleep 2000
        TrayTip

        if (A_Index < count)
        Sleep intervalSeconds * 1000
    }
}

; ============================================================================
; EXAMPLE 2: Event-Driven Notifications
; ============================================================================
/**
* Shows notifications based on events.
*
* @description Demonstrates event-triggered notifications.
*/
Example2_EventDrivenNotifications() {
    ; Simulated events
    TriggerFileEvent("created", "document.txt")
    Sleep 1000

    TriggerFileEvent("modified", "config.ini")
    Sleep 1000

    TriggerFileEvent("deleted", "temp.tmp")
    Sleep 1000

    ; User action events
    TriggerUserEvent("login", "JohnDoe")
    Sleep 1000

    TriggerUserEvent("logout", "JohnDoe")
    Sleep 1000

    ; System events
    TriggerSystemEvent("startup")
    Sleep 1000

    TriggerSystemEvent("shutdown")
    Sleep 1000

    ; Application events
    TriggerAppEvent("update_available", "1.2.0")
    Sleep 1000

    TriggerAppEvent("backup_complete", "2.5 GB")
    Sleep 1000
}

/**
* Triggers file event notification.
*/
TriggerFileEvent(eventType, fileName) {
    Switch eventType {
        Case "created":
        TrayTip "File Created",
        Format("New file: {1}", fileName),
        1
        Case "modified":
        TrayTip "File Modified",
        Format("Updated: {1}", fileName),
        1
        Case "deleted":
        TrayTip "File Deleted",
        Format("Removed: {1}", fileName),
        2
    }

    Sleep 2000
    TrayTip
}

/**
* Triggers user event notification.
*/
TriggerUserEvent(eventType, userName) {
    Switch eventType {
        Case "login":
        TrayTip "User Login",
        Format("Welcome back, {1}!", userName),
        1
        Case "logout":
        TrayTip "User Logout",
        Format("Goodbye, {1}!", userName),
        1
    }

    Sleep 2000
    TrayTip
}

/**
* Triggers system event notification.
*/
TriggerSystemEvent(eventType) {
    Switch eventType {
        Case "startup":
        TrayTip "System Started",
        "All services are running.",
        1
        Case "shutdown":
        TrayTip "Shutting Down",
        "Closing all applications...",
        2
    }

    Sleep 2000
    TrayTip
}

/**
* Triggers application event notification.
*/
TriggerAppEvent(eventType, data) {
    Switch eventType {
        Case "update_available":
        TrayTip "Update Available",
        Format("Version {1} is ready to install.", data),
        1
        Case "backup_complete":
        TrayTip "Backup Complete",
        Format("Backed up {1} of data.", data),
        1
    }

    Sleep 2000
    TrayTip
}

; ============================================================================
; EXAMPLE 3: System Monitoring Alerts
; ============================================================================
/**
* Creates system monitoring notification system.
*
* @description Monitors system resources and shows alerts.
*/
Example3_SystemMonitoring() {
    ; CPU monitoring
    MonitorCPU()

    ; Memory monitoring
    MonitorMemory()

    ; Disk space monitoring
    MonitorDiskSpace()

    ; Temperature monitoring
    MonitorTemperature()

    ; Network monitoring
    MonitorNetwork()
}

/**
* Monitors CPU usage.
*/
MonitorCPU() {
    ; Simulated CPU values
    cpuValues := [45, 72, 88, 95, 82]

    for cpu in cpuValues {
        if (cpu > 90) {
            TrayTip "CPU Alert",
            Format("CPU usage: {1}%`n`nCritical level reached!", cpu),
            3
        } else if (cpu > 80) {
            TrayTip "CPU Warning",
            Format("CPU usage: {1}%`n`nHigh usage detected.", cpu),
            2
        }

        Sleep 1500
        TrayTip
        Sleep 500
    }
}

/**
* Monitors memory usage.
*/
MonitorMemory() {
    memoryUsed := 7.2
    memoryTotal := 8.0
    memoryPercent := Round((memoryUsed / memoryTotal) * 100)

    if (memoryPercent > 85) {
        TrayTip "Memory Alert",
        Format("Memory usage: {1}%`n`nUsing {2} GB of {3} GB",
        memoryPercent, memoryUsed, memoryTotal),
        2

        Sleep 2000
        TrayTip
    }
}

/**
* Monitors disk space.
*/
MonitorDiskSpace() {
    drives := [
    {
        letter: "C:", used: 450, total: 500},
        {
            letter: "D:", used: 180, total: 200
        }
        ]

        for drive in drives {
            percent := Round((drive.used / drive.total) * 100)
            free := drive.total - drive.used

            if (percent > 85) {
                TrayTip "Low Disk Space",
                Format("Drive {1}`n`n{2}% full`n{3} GB free",
                drive.letter, percent, free),
                2

                Sleep 2000
                TrayTip
            }
        }
    }

    /**
    * Monitors temperature.
    */
    MonitorTemperature() {
        temps := [65, 78, 85, 92]

        for temp in temps {
            if (temp > 90) {
                TrayTip "Critical Temperature",
                Format("System temp: {1}°C`n`nImmediate action required!", temp),
                3
            } else if (temp > 80) {
                TrayTip "High Temperature",
                Format("System temp: {1}°C`n`nCooling recommended.", temp),
                2
            }

            Sleep 1500
            TrayTip
            Sleep 500
        }
    }

    /**
    * Monitors network connectivity.
    */
    MonitorNetwork() {
        states := [
        {
            status: "connected", speed: "1 Gbps"},
            {
                status: "disconnected", speed: "N/A"},
                {
                    status: "reconnected", speed: "100 Mbps"
                }
                ]

                for state in states {
                    Switch state.status {
                        Case "connected":
                        TrayTip "Network Connected",
                        Format("Connection established`n`nSpeed: {1}", state.speed),
                        1
                        Case "disconnected":
                        TrayTip "Network Disconnected",
                        "Connection lost`n`nAttempting to reconnect...",
                        2
                        Case "reconnected":
                        TrayTip "Network Restored",
                        Format("Connection restored`n`nSpeed: {1}", state.speed),
                        1
                    }

                    Sleep 2000
                    TrayTip
                    Sleep 500
                }
            }

            ; ============================================================================
            ; EXAMPLE 4: Application Status Updates
            ; ============================================================================
            /**
            * Shows application lifecycle notifications.
            *
            * @description Notifies users of application state changes.
            */
            Example4_ApplicationStatus() {
                ; Application lifecycle
                ShowAppLifecycle()

                ; Task completion notifications
                ShowTaskCompletions()

                ; Error and recovery notifications
                ShowErrorRecovery()

                ; Update notifications
                ShowUpdateProcess()
            }

            /**
            * Shows app lifecycle notifications.
            */
            ShowAppLifecycle() {
                states := [
                {
                    state: "Starting", msg: "Initializing application..."},
                    {
                        state: "Ready", msg: "Application is ready to use."},
                        {
                            state: "Busy", msg: "Processing your request..."},
                            {
                                state: "Idle", msg: "Waiting for input."
                            }
                            ]

                            for state in states {
                                TrayTip state.state, state.msg, 1
                                Sleep 1500
                                TrayTip
                                Sleep 500
                            }
                        }

                        /**
                        * Shows task completion notifications.
                        */
                        ShowTaskCompletions() {
                            tasks := [
                            {
                                name: "Data Export", time: "2 minutes"},
                                {
                                    name: "Report Generation", time: "45 seconds"},
                                    {
                                        name: "Email Sent", time: "instant"
                                    }
                                    ]

                                    for task in tasks {
                                        TrayTip "Task Complete",
                                        Format("{1}`n`nCompleted in: {2}", task.name, task.time),
                                        1

                                        Sleep 1500
                                        TrayTip
                                        Sleep 500
                                    }
                                }

                                /**
                                * Shows error and recovery flow.
                                */
                                ShowErrorRecovery() {
                                    ; Error
                                    TrayTip "Operation Failed",
                                    "Unable to save file`n`nError: Access denied",
                                    3
                                    Sleep 2000
                                    TrayTip

                                    Sleep 500

                                    ; Recovery attempt
                                    TrayTip "Retrying",
                                    "Attempting to save with elevated privileges...",
                                    1
                                    Sleep 1500
                                    TrayTip

                                    Sleep 500

                                    ; Success
                                    TrayTip "Success",
                                    "File saved successfully!",
                                    1
                                    Sleep 2000
                                    TrayTip
                                }

                                /**
                                * Shows update process.
                                */
                                ShowUpdateProcess() {
                                    steps := [
                                    {
                                        phase: "Checking", msg: "Checking for updates..."},
                                        {
                                            phase: "Downloading", msg: "Downloading update (2.5 MB)..."},
                                            {
                                                phase: "Installing", msg: "Installing update..."},
                                                {
                                                    phase: "Complete", msg: "Update installed successfully!"
                                                }
                                                ]

                                                for step in steps {
                                                    TrayTip "Update " . step.phase, step.msg, 1
                                                    Sleep 1500
                                                    TrayTip
                                                    Sleep 500
                                                }
                                            }

                                            ; ============================================================================
                                            ; EXAMPLE 5: User Interaction Notifications
                                            ; ============================================================================
                                            /**
                                            * Notifies users of required interactions.
                                            *
                                            * @description Shows notifications prompting user action.
                                            */
                                            Example5_UserInteraction() {
                                                ; Action required notifications
                                                ShowActionRequired()

                                                ; Confirmation requests
                                                ShowConfirmationRequests()

                                                ; Input needed notifications
                                                ShowInputNeeded()

                                                ; Decision prompts
                                                ShowDecisionPrompts()
                                            }

                                            /**
                                            * Shows action required notifications.
                                            */
                                            ShowActionRequired() {
                                                actions := [
                                                "Please review and approve pending changes",
                                                "Your password will expire in 3 days",
                                                "License agreement requires acceptance"
                                                ]

                                                for action in actions {
                                                    TrayTip "Action Required",
                                                    action . "`n`nClick for details.",
                                                    2

                                                    Sleep 2000
                                                    TrayTip
                                                    Sleep 500
                                                }
                                            }

                                            /**
                                            * Shows confirmation requests.
                                            */
                                            ShowConfirmationRequests() {
                                                requests := [
                                                "Confirm email address change",
                                                "Verify payment method",
                                                "Approve security update"
                                                ]

                                                for request in requests {
                                                    TrayTip "Confirmation Needed",
                                                    request . "`n`nClick to confirm.",
                                                    1

                                                    Sleep 2000
                                                    TrayTip
                                                    Sleep 500
                                                }
                                            }

                                            /**
                                            * Shows input needed notifications.
                                            */
                                            ShowInputNeeded() {
                                                inputs := [
                                                "Enter project name to continue",
                                                "Provide feedback on recent changes",
                                                "Complete profile information"
                                                ]

                                                for input in inputs {
                                                    TrayTip "Input Required",
                                                    input . "`n`nClick to provide.",
                                                    1

                                                    Sleep 2000
                                                    TrayTip
                                                    Sleep 500
                                                }
                                            }

                                            /**
                                            * Shows decision prompts.
                                            */
                                            ShowDecisionPrompts() {
                                                decisions := [
                                                {
                                                    question: "Save changes before closing?", default: "Yes"},
                                                    {
                                                        question: "Enable automatic updates?", default: "Recommended"},
                                                        {
                                                            question: "Join beta program?", default: "Optional"
                                                        }
                                                        ]

                                                        for decision in decisions {
                                                            TrayTip "Decision Required",
                                                            Format("{1}`n`nDefault: {2}", decision.question, decision.default),
                                                            1

                                                            Sleep 2000
                                                            TrayTip
                                                            Sleep 500
                                                        }
                                                    }

                                                    ; ============================================================================
                                                    ; EXAMPLE 6: Notification Queue System
                                                    ; ============================================================================
                                                    /**
                                                    * Creates a notification queue system.
                                                    *
                                                    * @description Manages multiple notifications in sequence.
                                                    */
                                                    Example6_NotificationQueue() {
                                                        ; Create notification queue
                                                        queue := [
                                                        {
                                                            title: "Message 1", msg: "First notification", type: 1},
                                                            {
                                                                title: "Message 2", msg: "Second notification", type: 1},
                                                                {
                                                                    title: "Message 3", msg: "Third notification", type: 1},
                                                                    {
                                                                        title: "Message 4", msg: "Fourth notification", type: 1},
                                                                        {
                                                                            title: "Message 5", msg: "Fifth notification", type: 1
                                                                        }
                                                                        ]

                                                                        ProcessNotificationQueue(queue)

                                                                        ; Priority queue
                                                                        priorityQueue := [
                                                                        {
                                                                            title: "Low Priority", msg: "Can wait", type: 1, priority: 1},
                                                                            {
                                                                                title: "Normal", msg: "Standard message", type: 1, priority: 2},
                                                                                {
                                                                                    title: "High Priority", msg: "Important!", type: 2, priority: 3},
                                                                                    {
                                                                                        title: "Critical", msg: "Urgent action needed!", type: 3, priority: 4
                                                                                    }
                                                                                    ]

                                                                                    ProcessPriorityQueue(priorityQueue)
                                                                                }

                                                                                /**
                                                                                * Processes notification queue.
                                                                                */
                                                                                ProcessNotificationQueue(queue) {
                                                                                    MsgBox Format("Processing {1} notifications in queue", queue.Length)

                                                                                    for notification in queue {
                                                                                        TrayTip notification.title, notification.msg, notification.type
                                                                                        Sleep 1500
                                                                                        TrayTip
                                                                                        Sleep 300
                                                                                    }
                                                                                }

                                                                                /**
                                                                                * Processes priority queue (sorts by priority first).
                                                                                */
                                                                                ProcessPriorityQueue(queue) {
                                                                                    ; Sort by priority (highest first)
                                                                                    SortByPriority(queue)

                                                                                    MsgBox "Processing notifications by priority"

                                                                                    for notification in queue {
                                                                                        TrayTip notification.title, notification.msg, notification.type
                                                                                        Sleep 1500
                                                                                        TrayTip
                                                                                        Sleep 300
                                                                                    }
                                                                                }

                                                                                /**
                                                                                * Sorts queue by priority (simple bubble sort).
                                                                                */
                                                                                SortByPriority(queue) {
                                                                                    n := queue.Length
                                                                                    Loop n - 1 {
                                                                                        i := A_Index
                                                                                        Loop n - i {
                                                                                            j := A_Index
                                                                                            if (queue[j].priority < queue[j + 1].priority) {
                                                                                                temp := queue[j]
                                                                                                queue[j] := queue[j + 1]
                                                                                                queue[j + 1] := temp
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }

                                                                                ; ============================================================================
                                                                                ; EXAMPLE 7: Custom Notification Templates
                                                                                ; ============================================================================
                                                                                /**
                                                                                * Creates reusable notification templates.
                                                                                *
                                                                                * @description Shows notification template patterns.
                                                                                */
                                                                                Example7_NotificationTemplates() {
                                                                                    ; Success template
                                                                                    NotifySuccess("File Saved", "document.txt has been saved successfully.")
                                                                                    Sleep 2000

                                                                                    ; Warning template
                                                                                    NotifyWarning("Low Battery", "Battery level is at 15%. Connect charger.")
                                                                                    Sleep 2000

                                                                                    ; Error template
                                                                                    NotifyError("Connection Failed", "Unable to reach server. Check network.")
                                                                                    Sleep 2000

                                                                                    ; Info template
                                                                                    NotifyInfo("New Feature", "Check out the new dark mode in settings!")
                                                                                    Sleep 2000

                                                                                    ; Custom template
                                                                                    NotifyCustom("Download", "report.pdf", "Complete", "2.5 MB")
                                                                                    Sleep 2000

                                                                                    ; Rich notification
                                                                                    NotifyRich("System Report", [
                                                                                    "CPU: 45%",
                                                                                    "RAM: 60%",
                                                                                    "Disk: 75%",
                                                                                    "Status: Normal"
                                                                                    ])
                                                                                    Sleep 3000
                                                                                }

                                                                                /**
                                                                                * Success notification template.
                                                                                */
                                                                                NotifySuccess(title, message) {
                                                                                    TrayTip "✓ " . title, message, 1
                                                                                    SetTimer (*) => TrayTip(), -2000
                                                                                }

                                                                                /**
                                                                                * Warning notification template.
                                                                                */
                                                                                NotifyWarning(title, message) {
                                                                                    TrayTip "⚠️ " . title, message, 2
                                                                                    SetTimer (*) => TrayTip(), -3000
                                                                                }

                                                                                /**
                                                                                * Error notification template.
                                                                                */
                                                                                NotifyError(title, message) {
                                                                                    TrayTip "❌ " . title, message, 3
                                                                                    SetTimer (*) => TrayTip(), -3000
                                                                                }

                                                                                /**
                                                                                * Info notification template.
                                                                                */
                                                                                NotifyInfo(title, message) {
                                                                                    TrayTip "ℹ️ " . title, message, 1
                                                                                    SetTimer (*) => TrayTip(), -2000
                                                                                }

                                                                                /**
                                                                                * Custom notification template.
                                                                                */
                                                                                NotifyCustom(action, item, status, details := "") {
                                                                                    msg := Format("{1}: {2}", action, item)
                                                                                    if (details != "")
                                                                                    msg .= "`n" . details

                                                                                    TrayTip status, msg, 1
                                                                                    SetTimer (*) => TrayTip(), -2500
                                                                                }

                                                                                /**
                                                                                * Rich notification with multiple data points.
                                                                                */
                                                                                NotifyRich(title, dataLines) {
                                                                                    message := ""
                                                                                    for line in dataLines {
                                                                                        message .= line
                                                                                        if (A_Index < dataLines.Length)
                                                                                        message .= "`n"
                                                                                    }

                                                                                    TrayTip title, message, 1
                                                                                    SetTimer (*) => TrayTip(), -4000
                                                                                }

                                                                                ; ============================================================================
                                                                                ; Hotkey Triggers
                                                                                ; ============================================================================

                                                                                ^1::Example1_ScheduledNotifications()
                                                                                ^2::Example2_EventDrivenNotifications()
                                                                                ^3::Example3_SystemMonitoring()
                                                                                ^4::Example4_ApplicationStatus()
                                                                                ^5::Example5_UserInteraction()
                                                                                ^6::Example6_NotificationQueue()
                                                                                ^7::Example7_NotificationTemplates()
                                                                                ^0::ExitApp

                                                                                /**
                                                                                * ============================================================================
                                                                                * SUMMARY
                                                                                * ============================================================================
                                                                                *
                                                                                * Advanced TrayTip applications:
                                                                                * 1. Scheduled notifications (hourly, time-based, countdown)
                                                                                * 2. Event-driven notifications (file, user, system events)
                                                                                * 3. System monitoring alerts (CPU, memory, disk, temperature)
                                                                                * 4. Application status updates (lifecycle, tasks, errors)
                                                                                * 5. User interaction notifications (actions, confirmations, input)
                                                                                * 6. Notification queue system with priorities
                                                                                * 7. Custom notification templates (success, warning, error, info)
                                                                                *
                                                                                * Best Practices:
                                                                                * - Use appropriate icons for message severity
                                                                                * - Keep messages concise and actionable
                                                                                * - Don't overwhelm users with too many notifications
                                                                                * - Provide clear next steps or actions
                                                                                * - Use silent notifications for background events
                                                                                * - Implement notification queuing for multiple alerts
                                                                                * - Create reusable templates for consistency
                                                                                *
                                                                                * ============================================================================
                                                                                */
