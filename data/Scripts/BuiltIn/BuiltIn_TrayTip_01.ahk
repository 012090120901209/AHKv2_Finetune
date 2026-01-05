#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * TrayTip Basic Examples - Part 1
 * ============================================================================
 * 
 * Comprehensive examples demonstrating TrayTip usage in AutoHotkey v2.
 * 
 * @description This file covers fundamental TrayTip functionality including:
 *              - Basic tray notifications
 *              - Icon types (info, warning, error)
 *              - Notification timeouts
 *              - Silent vs sound notifications
 *              - Removing notifications
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/TrayTip.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Basic TrayTip Notifications
; ============================================================================
/**
 * Demonstrates basic tray notification display.
 * 
 * @description Shows how to display simple tray notifications.
 */
Example1_BasicNotifications() {
    ; Simple notification
    TrayTip "Hello", "This is a basic tray notification!"
    Sleep 3000
    TrayTip  ; Remove notification

    ; Notification with title only
    TrayTip "Important Notice"
    Sleep 2000
    TrayTip

    ; Notification with text only
    TrayTip , "Your download is complete."
    Sleep 2000
    TrayTip

    ; Longer message
    TrayTip "System Update",
        "A new system update is available. Click here to learn more and install the update."
    Sleep 4000
    TrayTip

    ; Multi-line notification
    TrayTip "Backup Complete",
        "Your files have been backed up successfully.`n`nFiles: 1,234`nSize: 2.5 GB"
    Sleep 4000
    TrayTip

    ; Time-based notification
    currentTime := FormatTime(, "HH:mm:ss")
    TrayTip "Current Time", "The time is now: " . currentTime
    Sleep 3000
    TrayTip

    ; Variable content
    userName := "John Doe"
    TrayTip "Welcome", Format("Hello, {1}! Welcome to the application.", userName)
    Sleep 3000
    TrayTip
}

; ============================================================================
; EXAMPLE 2: Icon Types
; ============================================================================
/**
 * Shows different notification icon types.
 * 
 * @description Demonstrates all available icon types for notifications.
 * 
 * Icon Options:
 * - 1: Info icon (blue i)
 * - 2: Warning icon (yellow triangle)
 * - 3: Error icon (red X)
 * - 4: No icon
 */
Example2_IconTypes() {
    ; Info icon (default or 1)
    TrayTip "Information", "This is an informational message.", 1
    Sleep 3000
    TrayTip

    ; Warning icon (2)
    TrayTip "Warning", "Your disk space is running low!", 2
    Sleep 3000
    TrayTip

    ; Error icon (3)
    TrayTip "Error", "Failed to save file. Please try again.", 3
    Sleep 3000
    TrayTip

    ; No icon (4)
    TrayTip "Plain Notice", "This notification has no icon.", 4
    Sleep 3000
    TrayTip

    ; Using icon based on severity
    NotifyUser("Operation Successful", "The file was saved successfully.", "success")
    Sleep 3000

    NotifyUser("Disk Space Warning", "Less than 10% disk space remaining.", "warning")
    Sleep 3000

    NotifyUser("Critical Error", "System encountered a critical error.", "error")
    Sleep 3000

    NotifyUser("Update Available", "A new version is available for download.", "info")
    Sleep 3000
}

/**
 * Shows notification with appropriate icon.
 */
NotifyUser(title, message, type := "info") {
    Switch type {
        Case "info":
            TrayTip title, message, 1
        Case "warning":
            TrayTip title, message, 2
        Case "error":
            TrayTip title, message, 3
        Case "none":
            TrayTip title, message, 4
        Default:
            TrayTip title, message
    }
}

; ============================================================================
; EXAMPLE 3: Silent Notifications
; ============================================================================
/**
 * Demonstrates silent vs sound notifications.
 * 
 * @description Shows how to control notification sounds.
 * 
 * Options:
 * - 16: Silent notification (no sound)
 * - Combine with icon types using addition
 */
Example3_SilentNotifications() {
    ; Normal notification with sound
    TrayTip "New Message", "You have received a new email."
    Sleep 3000
    TrayTip

    ; Silent notification (16)
    TrayTip "Silent Notice", "This notification is silent.", 16
    Sleep 3000
    TrayTip

    ; Silent info notification (1 + 16 = 17)
    TrayTip "Silent Info", "Silent information notification.", 17
    Sleep 3000
    TrayTip

    ; Silent warning (2 + 16 = 18)
    TrayTip "Silent Warning", "Silent warning notification.", 18
    Sleep 3000
    TrayTip

    ; Silent error (3 + 16 = 19)
    TrayTip "Silent Error", "Silent error notification.", 19
    Sleep 3000
    TrayTip

    ; Silent with no icon (4 + 16 = 20)
    TrayTip "Silent Plain", "Silent plain notification.", 20
    Sleep 3000
    TrayTip

    ; Helper function for silent notifications
    ShowSilentNotification("Background Task", "Backup completed in the background.", "info")
    Sleep 3000
}

/**
 * Shows a silent notification.
 */
ShowSilentNotification(title, message, type := "info") {
    iconValue := 0

    Switch type {
        Case "info": iconValue := 1
        Case "warning": iconValue := 2
        Case "error": iconValue := 3
        Case "none": iconValue := 4
    }

    ; Add 16 for silent
    TrayTip title, message, iconValue + 16
}

; ============================================================================
; EXAMPLE 4: Large Icon Notifications
; ============================================================================
/**
 * Shows notifications with large icons.
 * 
 * @description Demonstrates using larger notification icons.
 * 
 * Options:
 * - 32: Use large icon version
 */
Example4_LargeIcons() {
    ; Regular size info icon
    TrayTip "Regular Icon", "This uses the standard icon size.", 1
    Sleep 3000
    TrayTip

    ; Large info icon (1 + 32 = 33)
    TrayTip "Large Icon", "This uses a large icon.", 33
    Sleep 3000
    TrayTip

    ; Large warning icon (2 + 32 = 34)
    TrayTip "Large Warning", "Large warning icon notification.", 34
    Sleep 3000
    TrayTip

    ; Large error icon (3 + 32 = 35)
    TrayTip "Large Error", "Large error icon notification.", 35
    Sleep 3000
    TrayTip

    ; Large silent info (1 + 16 + 32 = 49)
    TrayTip "Large Silent", "Large silent notification.", 49
    Sleep 3000
    TrayTip

    ; Helper function with large icon option
    ShowNotificationEx("Update Available", "A new version is ready to install.", "info", true, false)
    Sleep 3000
}

/**
 * Shows notification with options.
 */
ShowNotificationEx(title, message, type := "info", large := false, silent := false) {
    iconValue := 0

    Switch type {
        Case "info": iconValue := 1
        Case "warning": iconValue := 2
        Case "error": iconValue := 3
        Case "none": iconValue := 4
    }

    if (silent)
        iconValue += 16

    if (large)
        iconValue += 32

    TrayTip title, message, iconValue
}

; ============================================================================
; EXAMPLE 5: Notification Management
; ============================================================================
/**
 * Shows how to manage and remove notifications.
 * 
 * @description Demonstrates notification lifecycle management.
 */
Example5_NotificationManagement() {
    ; Show and remove immediately
    TrayTip "Quick Notice", "This will disappear quickly."
    Sleep 1000
    TrayTip  ; Remove

    ; Multiple sequential notifications
    Loop 3 {
        TrayTip "Notification " . A_Index, "Processing step " . A_Index . " of 3"
        Sleep 2000
        TrayTip
        Sleep 500
    }

    ; Replace notification (new one automatically replaces old)
    TrayTip "First Message", "This is the first message."
    Sleep 1500
    TrayTip "Second Message", "This replaces the first message."
    Sleep 2000
    TrayTip

    ; Timed notifications
    ShowTimedNotification("Timed Notice", "This will auto-hide in 3 seconds.", 3000)
    Sleep 4000

    ; Auto-removing notification sequence
    notifications := [{
        title: "Step 1", msg: "Initializing...", duration: 1500 }, {
            title: "Step 2", msg: "Processing...", duration: 2000 }, {
                title: "Step 3", msg: "Complete!", duration: 1500
            }
    ]

    for notif in notifications {
        ShowTimedNotification(notif.title, notif.msg, notif.duration)
        Sleep notif.duration + 500
    }
}

/**
 * Shows notification for specified duration.
 */
ShowTimedNotification(title, message, duration := 3000, options := 1) {
    TrayTip title, message, options

    ; Set timer to remove notification
    ClearFunc := (*) => TrayTip()
    SetTimer ClearFunc, -duration
}

; ============================================================================
; EXAMPLE 6: Practical Notification Scenarios
; ============================================================================
/**
 * Real-world notification scenarios.
 * 
 * @description Practical examples for common use cases.
 */
Example6_PracticalScenarios() {
    ; File download complete
    fileName := "report.pdf"
    fileSize := "2.5 MB"
    TrayTip "Download Complete",
        Format("File: {1}`nSize: {2}`n`nClick to open folder.", fileName, fileSize),
        1
    Sleep 3000
    TrayTip

    ; Low battery warning
    batteryLevel := 15
    TrayTip "Low Battery",
        Format("Battery at {1}%`n`nPlease connect charger.", batteryLevel),
        2
    Sleep 3000
    TrayTip

    ; Update notification
    currentVersion := "1.0.0"
    newVersion := "1.1.0"
    TrayTip "Update Available",
        Format("Version {1} is available.`nCurrent version: {2}`n`nClick to update.", newVersion, currentVersion),
        1
    Sleep 4000
    TrayTip

    ; Reminder notification
    eventName := "Team Meeting"
    eventTime := "2:00 PM"
    TrayTip "Upcoming Event",
        Format("{1}`nStarts at: {2}`n`n15 minutes remaining", eventName, eventTime),
        2
    Sleep 3000
    TrayTip

    ; Security alert
    TrayTip "Security Alert",
        "Suspicious activity detected on your account.`n`nClick for details.",
        3
    Sleep 3000
    TrayTip

    ; Backup notification
    backupTime := FormatTime(, "HH:mm:ss")
    filesCount := 1234
    TrayTip "Backup Successful",
        Format("Backup completed at {1}`n`nFiles backed up: {2}", backupTime, filesCount),
        1
    Sleep 3000
    TrayTip

    ; Network status
    TrayTip "Network Connected",
        "Connection established successfully.`n`nIP: 192.168.1.100",
        1
    Sleep 3000
    TrayTip
}

; ============================================================================
; EXAMPLE 7: Notification Patterns
; ============================================================================
/**
 * Common notification patterns and workflows.
 * 
 * @description Shows notification design patterns.
 */
Example7_NotificationPatterns() {
    ; Progress notifications
    ShowProgressNotifications()

    ; Status change notifications
    ShowStatusChangeNotifications()

    ; Error recovery workflow
    ShowErrorRecoveryWorkflow()

    ; Multi-step process notifications
    ShowMultiStepProcess()
}

/**
 * Shows progress through notifications.
 */
ShowProgressNotifications() {
    stages := ["Starting", "Processing", "Finalizing", "Complete"]

    for index, stage in stages {
        percent := (index / stages.Length) * 100
        TrayTip "Progress Update",
            Format("{1}... ({2}%)", stage, Round(percent)),
            1
        Sleep 1500
        TrayTip
        Sleep 500
    }
}

/**
 * Shows status change notifications.
 */
ShowStatusChangeNotifications() {
    statuses := [{
        state: "Offline", icon: 2 }, {
            state: "Connecting", icon: 1 }, {
                state: "Online", icon: 1
            }
    ]

    for status in statuses {
        TrayTip "Connection Status",
            "Status changed to: " . status.state,
            status.icon
        Sleep 2000
        TrayTip
        Sleep 500
    }
}

/**
 * Shows error recovery workflow.
 */
ShowErrorRecoveryWorkflow() {
    ; Error
    TrayTip "Connection Error",
        "Failed to connect to server.",
        3
    Sleep 2000
    TrayTip

    ; Retry
    TrayTip "Retrying",
        "Attempting to reconnect...",
        1
    Sleep 2000
    TrayTip

    ; Success
    TrayTip "Connected",
        "Connection established successfully.",
        1
    Sleep 2000
    TrayTip
}

/**
 * Shows multi-step process.
 */
ShowMultiStepProcess() {
    steps := [{
        title: "Step 1/4", msg: "Validating input...", type: "info" }, {
            title: "Step 2/4", msg: "Processing data...", type: "info" }, {
                title: "Step 3/4", msg: "Saving results...", type: "info" }, {
                    title: "Step 4/4", msg: "Process complete!", type: "info"
                }
    ]

    for step in steps {
        iconValue := (step.type = "info") ? 1 : (step.type = "warning") ? 2 : 3
        TrayTip step.title, step.msg, iconValue
        Sleep 1500
        TrayTip
        Sleep 500
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_BasicNotifications()
^2:: Example2_IconTypes()
^3:: Example3_SilentNotifications()
^4:: Example4_LargeIcons()
^5:: Example5_NotificationManagement()
^6:: Example6_PracticalScenarios()
^7:: Example7_NotificationPatterns()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * TrayTip fundamentals covered:
 * 1. Basic tray notifications with title and message
 * 2. Icon types (Info, Warning, Error, None)
 * 3. Silent notifications (no sound)
 * 4. Large icon notifications
 * 5. Notification management and removal
 * 6. Practical real-world scenarios
 * 7. Common notification patterns and workflows
 * 
 * Key Points:
 * - TrayTip shows balloon notifications in system tray
 * - Options combine with + (e.g., 1 + 16 + 32 for large silent info)
 * - Call TrayTip with no parameters to remove notification
 * - New notifications automatically replace existing ones
 * - Use SetTimer for auto-removing notifications
 * - Choose appropriate icons based on message severity
 * 
 * Option Values:
 * - 1: Info icon
 * - 2: Warning icon
 * - 3: Error icon
 * - 4: No icon
 * - 16: Silent (add to icon value)
 * - 32: Large icon (add to icon value)
 * 
 * ============================================================================
 */

