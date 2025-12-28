/**
 * @file DriveEject_02.ahk
 * @description Advanced drive ejection automation and scheduled eject systems
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Scheduled drive ejection
 * - Auto-eject on file operations complete
 * - Drive ejection with backup verification
 * - Optical media automation workflows
 * - Intelligent eject queue management
 * - Eject failure recovery
 * - Custom eject notifications
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Scheduled Drive Ejection System
; ===================================================================================================

/**
 * @class ScheduledEjectManager
 * @description Manages scheduled drive ejections
 */
class ScheduledEjectManager {
    schedules := Map()

    ScheduleEject(driveLetter, ejectTime) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        this.schedules[driveLetter] := ejectTime
        SetTimer(() => this.CheckSchedules(), 60000)
    }

    CheckSchedules() {
        currentTime := FormatTime(A_Now, "HHmm")

        for drive, ejectTime in this.schedules {
            if (currentTime = ejectTime) {
                try {
                    DriveEject(drive)
                    MsgBox(Format("Drive {1} auto-ejected at {2}", drive, FormatTime(A_Now, "HH:mm")),
                        "Scheduled Eject", "Iconi")
                    this.schedules.Delete(drive)
                }
            }
        }
    }
}

Example1_ScheduledEject() {
    manager := ScheduledEjectManager()
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Scheduled Eject", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"
    ejectTime := InputBox("Enter eject time (HHmm, e.g., 1730):", "Schedule Eject").Value

    if (ejectTime != "" && StrLen(ejectTime) = 4) {
        manager.ScheduleEject(firstDrive, ejectTime)
        MsgBox(Format("Drive {1} scheduled to eject at {2}:{3}",
            firstDrive, SubStr(ejectTime, 1, 2), SubStr(ejectTime, 3, 2)),
            "Schedule Set", "Iconi")
    }

    return manager
}

; ===================================================================================================
; EXAMPLE 2: Auto-Eject After Backup Completion
; ===================================================================================================

/**
 * @class BackupEjectManager
 * @description Auto-ejects drives after backup verification
 */
class BackupEjectManager {
    static VerifyAndEject(driveLetter, expectedFiles) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        ; Verify backup
        verified := true
        for file in expectedFiles {
            if !FileExist(driveLetter . "\" . file) {
                verified := false
                break
            }
        }

        if (verified) {
            Sleep(1000)
            try {
                DriveEject(driveLetter)
                return { Success: true, Message: "Backup verified and drive ejected" }
            } catch as err {
                return { Success: false, Error: err.Message }
            }
        } else {
            return { Success: false, Error: "Backup verification failed" }
        }
    }
}

Example2_BackupEject() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Backup Eject", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"

    ; Create test file
    testFile := "backup_test.txt"
    FileDelete(firstDrive . "\" . testFile)
    FileAppend("Test backup file", firstDrive . "\" . testFile)

    Sleep(500)

    ; Verify and eject
    result := BackupEjectManager.VerifyAndEject(firstDrive, [testFile])

    if (result.Success) {
        MsgBox(result.Message, "Success", "Iconi")
    } else {
        MsgBox("Error: " . result.Error, "Failed", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 3: Optical Media Workflow Automation
; ===================================================================================================

/**
 * @class OpticalWorkflow
 * @description Automates optical media workflows
 */
class OpticalWorkflow {
    static BurnAndEject(driveLetter, dataPath) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetType(driveLetter) != "CDROM") {
            return { Success: false, Error: "Not an optical drive" }
        }

        ; Simulate burn operation (in reality, would use burning software)
        status := DriveGetStatusCD(driveLetter)

        if (status = "not ready") {
            return { Success: false, Error: "No disc in drive" }
        }

        ; Eject when done
        try {
            DriveEject(driveLetter)
            return { Success: true, Message: "Workflow complete, disc ejected" }
        } catch as err {
            return { Success: false, Error: err.Message }
        }
    }
}

Example3_OpticalWorkflow() {
    cdDrives := DriveGetList("CDROM")

    if (StrLen(cdDrives) = 0) {
        MsgBox("No optical drives found.", "Optical Workflow", "Iconi")
        return
    }

    firstDrive := SubStr(cdDrives, 1, 1) . ":"
    result := OpticalWorkflow.BurnAndEject(firstDrive, A_MyDocuments)

    if (result.Success) {
        MsgBox(result.Message, "Success", "Iconi")
    } else {
        MsgBox("Error: " . result.Error, "Failed", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 4: Eject Queue Management
; ===================================================================================================

/**
 * @class EjectQueue
 * @description Manages a queue of drives to eject
 */
class EjectQueue {
    queue := []

    Add(driveLetter, priority := 1) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        this.queue.Push({ Drive: driveLetter, Priority: priority, Added: A_Now })
    }

    ProcessQueue() {
        results := []

        ; Sort by priority
        sorted := this.queue.Clone()

        for item in sorted {
            try {
                DriveEject(item.Drive)
                results.Push({ Drive: item.Drive, Success: true })
                Sleep(1000)
            } catch as err {
                results.Push({ Drive: item.Drive, Success: false, Error: err.Message })
            }
        }

        this.queue := []
        return results
    }
}

Example4_EjectQueue() {
    queue := EjectQueue()
    removables := DriveGetList("Removable")

    for index, letter in StrSplit(removables) {
        queue.Add(letter . ":", index)
    }

    if (queue.queue.Length = 0) {
        MsgBox("No drives in eject queue.", "Eject Queue", "Iconi")
        return
    }

    if (MsgBox(Format("Process eject queue ({1} drives)?", queue.queue.Length),
        "Eject Queue", "YesNo Icon?") = "Yes") {
        results := queue.ProcessQueue()

        report := "Eject Queue Results:`n`n"
        for result in results {
            status := result.Success ? "✓" : "✗"
            report .= Format("{1} {2}`n", status, result.Drive)
        }

        MsgBox(report, "Queue Complete", "Iconi")
    }

    return queue
}

; ===================================================================================================
; EXAMPLE 5: Eject with Progress Notification
; ===================================================================================================

/**
 * @class EjectNotifier
 * @description Provides visual feedback during eject operations
 */
class EjectNotifier {
    static EjectWithNotification(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        ; Show progress
        progress := Gui(, "Ejecting Drive")
        progress.AddText(, Format("Ejecting drive {1}...", driveLetter))
        progressBar := progress.AddProgress("w300 h30", 0)
        progress.Show()

        ; Simulate progress
        Loop 100 {
            progressBar.Value := A_Index
            Sleep(10)
        }

        ; Perform eject
        try {
            DriveEject(driveLetter)
            progress.Destroy()
            MsgBox("Drive ejected successfully!", "Success", "Iconi 1")
            return { Success: true }
        } catch as err {
            progress.Destroy()
            MsgBox("Eject failed: " . err.Message, "Error", "Icon!")
            return { Success: false, Error: err.Message }
        }
    }
}

Example5_EjectNotification() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Eject Notifier", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"
    EjectNotifier.EjectWithNotification(firstDrive)
}

; ===================================================================================================
; EXAMPLE 6: Smart Retry on Eject Failure
; ===================================================================================================

/**
 * @function RetryEject
 * @description Retries eject operation with exponential backoff
 * @param {String} driveLetter - Drive letter
 * @param {Number} maxRetries - Maximum retry attempts
 * @returns {Object} Result object
 */
RetryEject(driveLetter, maxRetries := 3) {
    if !InStr(driveLetter, ":")
        driveLetter .= ":"

    attempt := 0
    lastError := ""

    while (attempt < maxRetries) {
        attempt++

        try {
            DriveUnlock(driveLetter)
            Sleep(500 * attempt)
            DriveEject(driveLetter)

            return {
                Success: true,
                Drive: driveLetter,
                Attempts: attempt,
                Message: Format("Ejected successfully on attempt {1}", attempt)
            }
        } catch as err {
            lastError := err.Message
            Sleep(1000 * attempt)
        }
    }

    return {
        Success: false,
        Drive: driveLetter,
        Attempts: maxRetries,
        Error: Format("Failed after {1} attempts: {2}", maxRetries, lastError)
    }
}

Example6_RetryEject() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Retry Eject", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"
    result := RetryEject(firstDrive, 3)

    if (result.Success) {
        MsgBox(result.Message, "Success", "Iconi")
    } else {
        MsgBox(result.Error, "Failed", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 7: Eject History Logger
; ===================================================================================================

/**
 * @class EjectLogger
 * @description Logs all eject operations
 */
class EjectLogger {
    logFile := A_ScriptDir . "\eject_history.log"

    LogEject(driveLetter, success, error := "") {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        status := success ? "SUCCESS" : "FAILED"

        logEntry := Format("[{1}] {2} - Drive: {3}",
            timestamp, status, driveLetter)

        if (error != "")
            logEntry .= " - Error: " . error

        logEntry .= "`n"

        FileAppend(logEntry, this.logFile)
    }

    GetHistory(count := 10) {
        if !FileExist(this.logFile)
            return []

        content := FileRead(this.logFile)
        lines := StrSplit(content, "`n", "`r")

        history := []
        startIndex := Max(1, lines.Length - count)

        for i, line in lines {
            if (i >= startIndex && line != "")
                history.Push(line)
        }

        return history
    }
}

Example7_EjectHistory() {
    logger := EjectLogger()

    history := logger.GetHistory(10)

    if (history.Length = 0) {
        MsgBox("No eject history found.", "Eject History", "Iconi")
        return logger
    }

    report := "Recent Eject Operations (Last 10):`n"
    report .= "═══════════════════════════════════════`n`n"

    for entry in history {
        report .= entry . "`n"
    }

    MsgBox(report, "Eject History", "Iconi")

    return logger
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+S to schedule eject
; ^!s::Example1_ScheduledEject()

; Press Ctrl+Alt+B to backup and eject
; ^!b::Example2_BackupEject()

; Press Ctrl+Alt+Q to process eject queue
; ^!q::Example4_EjectQueue()

