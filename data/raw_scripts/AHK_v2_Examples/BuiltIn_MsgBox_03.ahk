#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * MsgBox Integration Patterns - Part 3
 * ============================================================================
 *
 * Integration patterns and advanced use cases for MsgBox in AutoHotkey v2.
 *
 * @description This file covers MsgBox integration scenarios including:
 *              - Data validation workflows
 *              - System monitoring notifications
 *              - Batch processing feedback
 *              - Configuration management
 *              - User preference dialogs
 *              - Logging and debugging aids
 *
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/MsgBox.htm
 *
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: File Operations with User Feedback
; ============================================================================
/**
 * Demonstrates MsgBox integration with file operations.
 *
 * @description Shows how to provide user feedback during file processing
 *              operations with appropriate error handling.
 */
Example1_FileOperationsFeedback() {
    ; File processing simulation
    files := ["document1.txt", "document2.txt", "document3.txt", "document4.txt", "document5.txt"]
    processedCount := 0
    errorCount := 0
    errorFiles := []

    ; Process files with feedback
    for index, fileName in files {
        ; Simulate random success/failure
        success := (Random(0, 10) > 2)

        if (success) {
            processedCount++
        } else {
            errorCount++
            errorFiles.Push(fileName)
        }
    }

    ; Show results summary
    if (errorCount = 0) {
        MsgBox Format("File processing completed successfully!`n`n"
                    . "Files processed: {1}`n"
                    . "Errors: {2}",
                    processedCount,
                    errorCount),
               "Processing Complete",
               "Iconi"
    } else {
        errorList := ""
        for fileName in errorFiles {
            errorList .= "  • " . fileName . "`n"
        }

        response := MsgBox(Format("File processing completed with errors.`n`n"
                                . "Successfully processed: {1}`n"
                                . "Failed: {2}`n`n"
                                . "Failed files:`n{3}`n"
                                . "Would you like to retry failed files?",
                                processedCount,
                                errorCount,
                                errorList),
                          "Processing Completed with Errors",
                          "YesNo Icon!")

        if (response = "Yes") {
            MsgBox Format("Retrying {1} failed files...", errorCount),
                   "Retrying",
                   "Iconi"
        }
    }

    ; File size check before operation
    fileName := "largefile.dat"
    fileSize := 1500  ; MB (simulated)
    maxSize := 1000   ; MB

    if (fileSize > maxSize) {
        response := MsgBox(Format("File size exceeds recommended limit!`n`n"
                                . "File: {1}`n"
                                . "Size: {2} MB`n"
                                . "Limit: {3} MB`n`n"
                                . "Process anyway? This may take a long time.",
                                fileName,
                                fileSize,
                                maxSize),
                          "Large File Warning",
                          "YesNo Icon! 256")

        if (response = "No") {
            MsgBox "Operation cancelled.",
                   "Cancelled",
                   "Iconi"
        }
    }

    ; Backup confirmation
    backupPath := "C:\Backups\2024-01-15"
    itemCount := 127
    totalSize := 2.5  ; GB

    confirm := MsgBox(Format("Ready to create backup:`n`n"
                           . "Location: {1}`n"
                           . "Items: {2}`n"
                           . "Size: {3} GB`n`n"
                           . "This will take approximately 10 minutes.`n`n"
                           . "Start backup now?",
                           backupPath,
                           itemCount,
                           totalSize),
                     "Confirm Backup",
                     "YesNo Icon?")

    if (confirm = "Yes") {
        MsgBox "Backup started...`n`nYou will be notified when complete.",
               "Backup in Progress",
               "Iconi"
    }
}

; ============================================================================
; EXAMPLE 2: System Monitoring and Alerts
; ============================================================================
/**
 * Demonstrates system monitoring notifications using MsgBox.
 *
 * @description Shows how to implement system alerts for various
 *              monitoring scenarios.
 */
Example2_SystemMonitoring() {
    ; CPU usage alert
    cpuUsage := 85
    cpuThreshold := 80

    if (cpuUsage > cpuThreshold) {
        MsgBox Format("High CPU usage detected!`n`n"
                    . "Current: {1}%`n"
                    . "Threshold: {2}%`n`n"
                    . "Consider closing some applications.",
                    cpuUsage,
                    cpuThreshold),
               "System Alert - CPU",
               "Icon! 262144"  ; Always on top
    }

    ; Memory usage warning
    memoryUsed := 7.2    ; GB
    memoryTotal := 8.0   ; GB
    memoryPercent := Round((memoryUsed / memoryTotal) * 100)

    if (memoryPercent > 85) {
        response := MsgBox(Format("Memory usage is critical!`n`n"
                                . "Used: {1} GB / {2} GB ({3}%)`n"
                                . "Available: {4} GB`n`n"
                                . "Would you like to see which programs are using memory?",
                                memoryUsed,
                                memoryTotal,
                                memoryPercent,
                                Round(memoryTotal - memoryUsed, 1)),
                          "System Alert - Memory",
                          "YesNo Iconx 262144")

        if (response = "Yes") {
            MsgBox "Top Memory Consumers:`n`n"
                 . "1. Chrome.exe - 2.1 GB`n"
                 . "2. Code.exe - 1.8 GB`n"
                 . "3. Firefox.exe - 1.4 GB`n"
                 . "4. System - 0.9 GB`n"
                 . "5. Other - 1.0 GB",
                   "Memory Usage Details",
                   "Iconi"
        }
    }

    ; Disk space monitoring
    drives := ["C:", "D:", "E:"]
    lowSpaceDrives := []

    ; Simulate disk space check
    driveInfo := Map(
        "C:", {used: 450, total: 500, percent: 90},
        "D:", {used: 800, total: 1000, percent: 80},
        "E:", {used: 50, total: 500, percent: 10}
    )

    for drive in drives {
        info := driveInfo[drive]
        if (info.percent > 85) {
            lowSpaceDrives.Push(drive . " (" . info.percent . "% full)")
        }
    }

    if (lowSpaceDrives.Length > 0) {
        driveList := ""
        for driveInfo in lowSpaceDrives {
            driveList .= "  • " . driveInfo . "`n"
        }

        MsgBox Format("Low disk space warning!`n`n{1}`n"
                    . "Consider cleaning up files or moving data to another drive.",
                    driveList),
               "Disk Space Alert",
               "Icon! 262144"
    }

    ; Temperature monitoring (simulated)
    temperature := 82
    maxTemp := 75

    if (temperature > maxTemp) {
        severity := (temperature > 85) ? "CRITICAL" : "WARNING"
        icon := (temperature > 85) ? "Iconx" : "Icon!"

        MsgBox Format("{1}: High temperature detected!`n`n"
                    . "Current: {2}°C`n"
                    . "Maximum: {3}°C`n`n"
                    . "System may throttle performance or shut down to prevent damage.",
                    severity,
                    temperature,
                    maxTemp),
               "Temperature Alert",
               icon . " 262144"
    }

    ; Network connectivity check
    isConnected := false

    if (!isConnected) {
        response := MsgBox("No internet connection detected.`n`n"
                         . "Please check your network settings.`n`n"
                         . "Retry connection?",
                         "Network Status",
                         "RetryCancel Iconx")

        if (response = "Retry") {
            MsgBox "Attempting to reconnect...",
                   "Reconnecting",
                   "Iconi"
        }
    }
}

; ============================================================================
; EXAMPLE 3: Batch Processing Progress
; ============================================================================
/**
 * Shows batch processing with milestone notifications.
 *
 * @description Demonstrates progress reporting during batch operations
 *              using strategic MsgBox placements.
 */
Example3_BatchProcessing() {
    totalItems := 100
    batchSize := 25
    processedItems := 0

    ; Process in batches
    Loop 4 {
        batchNumber := A_Index
        startItem := (batchNumber - 1) * batchSize + 1
        endItem := batchNumber * batchSize

        ; Process batch (simulated)
        Sleep 500

        processedItems := endItem
        percentComplete := (processedItems / totalItems) * 100

        ; Show milestone messages
        if (Mod(batchNumber, 1) = 0) {  ; After each batch
            MsgBox Format("Batch {1} of 4 complete`n`n"
                        . "Progress: {2}%`n"
                        . "Processed: {3}/{4} items",
                        batchNumber,
                        percentComplete,
                        processedItems,
                        totalItems),
                   "Batch Processing",
                   "Iconi T2"
        }
    }

    ; Final summary
    MsgBox Format("Batch processing complete!`n`n"
                . "Total items processed: {1}`n"
                . "Batches completed: 4`n"
                . "Success rate: 100%",
                totalItems),
           "Processing Complete",
           "Iconi"

    ; Error handling in batch processing
    ProcessBatchWithErrors()
}

/**
 * Simulates batch processing with error handling.
 */
ProcessBatchWithErrors() {
    items := []
    Loop 50 {
        items.Push("Item" . A_Index)
    }

    successCount := 0
    errorCount := 0
    errors := []

    for index, item in items {
        ; Simulate random failures
        success := (Random(0, 10) > 1)

        if (success) {
            successCount++
        } else {
            errorCount++
            errors.Push(item . " - Error code: " . Random(100, 999))
        }

        ; Check if errors exceed threshold
        if (errorCount > 5) {
            response := MsgBox(Format("Multiple errors detected!`n`n"
                                    . "Successful: {1}`n"
                                    . "Failed: {2}`n"
                                    . "Remaining: {3}`n`n"
                                    . "Continue processing?",
                                    successCount,
                                    errorCount,
                                    items.Length - index),
                              "Error Threshold Exceeded",
                              "YesNo Iconx")

            if (response = "No") {
                MsgBox "Processing aborted by user.",
                       "Aborted",
                       "Iconi"
                return
            } else {
                errorCount := 0  ; Reset error counter
            }
        }
    }

    ; Final report
    if (errors.Length > 0) {
        errorList := ""
        for error in errors {
            errorList .= "  • " . error . "`n"
        }

        MsgBox Format("Processing complete with errors.`n`n"
                    . "Successful: {1}`n"
                    . "Failed: {2}`n`n"
                    . "Error details:`n{3}",
                    successCount,
                    errors.Length,
                    SubStr(errorList, 1, 500)),  ; Limit error list length
               "Batch Complete",
               "Icon!"
    }
}

; ============================================================================
; EXAMPLE 4: Configuration Management
; ============================================================================
/**
 * Demonstrates configuration dialogs using MsgBox.
 *
 * @description Shows how to create simple configuration interfaces
 *              using MsgBox for settings management.
 */
Example4_ConfigurationManagement() {
    ; Settings object
    global Settings := {
        autoSave: false,
        notifications: true,
        theme: "light",
        language: "en"
    }

    ; Auto-save setting
    response := MsgBox(Format("Auto-save is currently: {1}`n`nEnable auto-save?",
                             Settings.autoSave ? "ENABLED" : "DISABLED"),
                      "Auto-Save Setting",
                      "YesNo Icon?")

    Settings.autoSave := (response = "Yes")
    MsgBox Format("Auto-save {1}.",
                 Settings.autoSave ? "enabled" : "disabled"),
           "Setting Updated",
           "Iconi"

    ; Notification preferences
    response := MsgBox("Receive desktop notifications?`n`n"
                     . "Yes - Show all notifications`n"
                     . "No - Disable notifications`n"
                     . "Cancel - Keep current setting",
                     "Notification Preferences",
                     "YesNoCancel Icon?")

    Switch response {
        Case "Yes":
            Settings.notifications := true
            MsgBox "Notifications enabled.",
                   "Setting Updated",
                   "Iconi"
        Case "No":
            Settings.notifications := false
            MsgBox "Notifications disabled.",
                   "Setting Updated",
                   "Iconi"
        Case "Cancel":
            MsgBox "Setting unchanged.",
                   "Cancelled",
                   "Iconi"
    }

    ; Theme selection
    response := MsgBox(Format("Current theme: {1}`n`nSwitch to dark theme?",
                             Settings.theme),
                      "Theme Selection",
                      "YesNo Icon?")

    if (response = "Yes") {
        Settings.theme := "dark"
        MsgBox "Theme changed to dark.`n`nRestart may be required for full effect.",
               "Theme Changed",
               "Iconi"
    }

    ; Show all settings
    ShowCurrentSettings()
}

/**
 * Displays current configuration settings.
 */
ShowCurrentSettings() {
    global Settings

    settingsText := "Current Settings:`n`n"
                 . Format("Auto-Save: {1}`n", Settings.autoSave ? "Enabled" : "Disabled")
                 . Format("Notifications: {1}`n", Settings.notifications ? "Enabled" : "Disabled")
                 . Format("Theme: {1}`n", Settings.theme)
                 . Format("Language: {1}", Settings.language)

    response := MsgBox(settingsText . "`n`nWould you like to reset to defaults?",
                      "Settings Summary",
                      "YesNo Iconi")

    if (response = "Yes") {
        confirm := MsgBox("Reset all settings to default values?`n`nThis cannot be undone.",
                         "Confirm Reset",
                         "YesNo Icon! 256")

        if (confirm = "Yes") {
            Settings.autoSave := false
            Settings.notifications := true
            Settings.theme := "light"
            Settings.language := "en"

            MsgBox "Settings reset to defaults.",
                   "Reset Complete",
                   "Iconi"
        }
    }
}

; ============================================================================
; EXAMPLE 5: User Preference Wizard
; ============================================================================
/**
 * Creates a preference configuration wizard.
 *
 * @description Multi-step wizard for collecting user preferences.
 */
Example5_PreferenceWizard() {
    preferences := Map()

    ; Step 1: Experience level
    MsgBox "Welcome to the Preference Wizard!`n`n"
         . "This wizard will help you configure the application.`n`n"
         . "Click OK to begin.",
           "Preference Wizard",
           "Iconi"

    level := MsgBox("What is your experience level?`n`n"
                  . "Yes - Beginner (show helpful tips)`n"
                  . "No - Advanced (minimal assistance)`n"
                  . "Cancel - Skip wizard",
                  "Experience Level",
                  "YesNoCancel Icon?")

    if (level = "Cancel") {
        MsgBox "Wizard cancelled. Using default settings.",
               "Cancelled",
               "Iconi"
        return
    }

    preferences["level"] := (level = "Yes") ? "beginner" : "advanced"

    ; Step 2: Update frequency
    updates := MsgBox("Check for updates automatically?`n`n"
                    . "Yes - Check daily`n"
                    . "No - Manual updates only",
                    "Update Preferences",
                    "YesNo Icon?")

    preferences["updates"] := (updates = "Yes") ? "auto" : "manual"

    ; Step 3: Data collection
    telemetry := MsgBox("Help improve the application by sending anonymous usage data?`n`n"
                      . "No personal information will be collected.",
                      "Usage Statistics",
                      "YesNo Icon?")

    preferences["telemetry"] := (telemetry = "Yes") ? "enabled" : "disabled"

    ; Step 4: Startup behavior
    startup := MsgBox("Launch application at system startup?",
                     "Startup Behavior",
                     "YesNo Icon?")

    preferences["startup"] := (startup = "Yes") ? "enabled" : "disabled"

    ; Summary
    summary := "Preferences Summary:`n`n"
             . Format("Experience Level: {1}`n", preferences["level"])
             . Format("Auto-Updates: {1}`n", preferences["updates"])
             . Format("Usage Data: {1}`n", preferences["telemetry"])
             . Format("Start with Windows: {1}`n`n", preferences["startup"])
             . "Save these preferences?"

    confirm := MsgBox(summary, "Confirm Preferences", "YesNo Icon?")

    if (confirm = "Yes") {
        MsgBox "Preferences saved successfully!`n`nYou can change these anytime in Settings.",
               "Setup Complete",
               "Iconi"
    } else {
        MsgBox "Preferences not saved. Using defaults.",
               "Cancelled",
               "Iconi"
    }
}

; ============================================================================
; EXAMPLE 6: Debugging and Development Aids
; ============================================================================
/**
 * Uses MsgBox for debugging and development.
 *
 * @description Shows how to use MsgBox for quick debugging and
 *              variable inspection during development.
 */
Example6_DebuggingAids() {
    ; Variable inspection
    DebugVariable("userName", "JohnDoe")
    DebugVariable("userAge", 30)
    DebugVariable("isActive", true)

    ; Array inspection
    myArray := ["apple", "banana", "cherry", "date"]
    DebugArray("fruits", myArray)

    ; Map inspection
    myMap := Map("name", "John", "age", 30, "city", "New York")
    DebugMap("userData", myMap)

    ; Function execution checkpoint
    CheckPoint("Before processing", {step: 1, data: "initialized"})

    ; Conditional debugging
    ConditionalDebug(true, "This will show")
    ConditionalDebug(false, "This will not show")
}

/**
 * Shows variable value in debug message.
 */
DebugVariable(varName, varValue) {
    MsgBox Format("DEBUG: Variable Info`n`n"
                . "Name: {1}`n"
                . "Value: {2}`n"
                . "Type: {3}",
                varName,
                varValue,
                Type(varValue)),
           "Debug - Variable",
           "Iconi"
}

/**
 * Shows array contents in debug message.
 */
DebugArray(arrayName, arrayValue) {
    content := ""
    for index, value in arrayValue {
        content .= Format("[{1}] = {2}`n", index, value)
    }

    MsgBox Format("DEBUG: Array Info`n`n"
                . "Name: {1}`n"
                . "Length: {2}`n"
                . "Contents:`n{3}",
                arrayName,
                arrayValue.Length,
                content),
           "Debug - Array",
           "Iconi"
}

/**
 * Shows map contents in debug message.
 */
DebugMap(mapName, mapValue) {
    content := ""
    for key, value in mapValue {
        content .= Format("{1}: {2}`n", key, value)
    }

    MsgBox Format("DEBUG: Map Info`n`n"
                . "Name: {1}`n"
                . "Count: {2}`n"
                . "Contents:`n{3}",
                mapName,
                mapValue.Count,
                content),
           "Debug - Map",
           "Iconi"
}

/**
 * Shows execution checkpoint.
 */
CheckPoint(location, data := "") {
    dataStr := ""
    if (IsObject(data)) {
        for key, value in data {
            dataStr .= Format("{1}: {2}`n", key, value)
        }
    }

    MsgBox Format("CHECKPOINT: {1}`n`n{2}",
                location,
                dataStr),
           "Checkpoint",
           "Iconi"
}

/**
 * Conditional debug message.
 */
ConditionalDebug(condition, message) {
    if (condition) {
        MsgBox Format("CONDITIONAL DEBUG:`n`n{1}", message),
               "Debug",
               "Iconi"
    }
}

; ============================================================================
; EXAMPLE 7: Data Validation Summary
; ============================================================================
/**
 * Comprehensive data validation with detailed feedback.
 *
 * @description Shows validation results with actionable feedback.
 */
Example7_DataValidation() {
    ; Collect data
    formData := Map(
        "name", "",
        "email", "invalid-email",
        "age", -5,
        "phone", "123",
        "zipcode", "ABCD"
    )

    ; Validate
    validationErrors := []

    if (formData["name"] = "")
        validationErrors.Push("Name is required")

    if (!RegExMatch(formData["email"], "^[\w\.-]+@[\w\.-]+\.\w+$"))
        validationErrors.Push("Email format is invalid")

    if (formData["age"] < 0 || formData["age"] > 150)
        validationErrors.Push("Age must be between 0 and 150")

    if (StrLen(formData["phone"]) < 10)
        validationErrors.Push("Phone number must be at least 10 digits")

    if (!RegExMatch(formData["zipcode"], "^\d{5}$"))
        validationErrors.Push("ZIP code must be 5 digits")

    ; Show results
    if (validationErrors.Length > 0) {
        errorList := ""
        for error in validationErrors {
            errorList .= "  • " . error . "`n"
        }

        response := MsgBox(Format("Form validation failed ({1} errors):`n`n{2}`nCorrect errors and try again?",
                                validationErrors.Length,
                                errorList),
                          "Validation Errors",
                          "RetryCancel Iconx")

        if (response = "Retry") {
            MsgBox "Please correct the errors and resubmit.",
                   "Retry",
                   "Iconi"
        }
    } else {
        MsgBox "All fields validated successfully!`n`nForm submitted.",
               "Validation Success",
               "Iconi"
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1::Example1_FileOperationsFeedback()
^2::Example2_SystemMonitoring()
^3::Example3_BatchProcessing()
^4::Example4_ConfigurationManagement()
^5::Example5_PreferenceWizard()
^6::Example6_DebuggingAids()
^7::Example7_DataValidation()
^0::ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 *
 * Integration patterns demonstrated:
 * 1. File operation feedback with error summaries
 * 2. System monitoring alerts (CPU, memory, disk, network)
 * 3. Batch processing with milestone notifications
 * 4. Configuration management dialogs
 * 5. Multi-step preference wizards
 * 6. Debugging aids and variable inspection
 * 7. Data validation with detailed error reporting
 *
 * ============================================================================
 */
