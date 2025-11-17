/**
 * @file DriveSet_01.ahk
 * @description Comprehensive examples of DriveSetLabel, DriveLock, and DriveUnlock functions in AutoHotkey v2
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 *
 * This file demonstrates:
 * - Setting and changing drive volume labels
 * - Locking drives to prevent removal
 * - Unlocking drives for safe removal
 * - Automated drive label management
 * - Safe drive lock/unlock procedures
 * - Drive label validation and sanitization
 * - Batch label operations
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic Drive Label Management
; ===================================================================================================

/**
 * @function SetDriveLabel
 * @description Sets a volume label for a drive with validation
 * @param {String} driveLetter - The drive letter
 * @param {String} newLabel - The new label (max 32 characters for NTFS, 11 for FAT32)
 * @returns {Object} Result object with success status
 *
 * @example
 * result := SetDriveLabel("D:", "MyData")
 * MsgBox(result.Success ? "Label set" : "Failed")
 */
SetDriveLabel(driveLetter, newLabel) {
    if !InStr(driveLetter, ":")
        driveLetter .= ":"

    ; Validate drive exists and is ready
    if (DriveGetStatus(driveLetter) != "Ready") {
        return {
            Success: false,
            Error: "Drive is not ready or does not exist"
        }
    }

    ; Get file system to check label length limits
    try {
        fileSystem := DriveGetFileSystem(driveLetter)
        maxLength := (fileSystem = "FAT32") ? 11 : 32

        if (StrLen(newLabel) > maxLength) {
            return {
                Success: false,
                Error: Format("Label too long for {1} (max {2} characters)", fileSystem, maxLength)
            }
        }

        ; Sanitize label (remove invalid characters)
        sanitizedLabel := RegExReplace(newLabel, "[<>:""/\\|?*]", "")

        ; Set the label
        oldLabel := DriveGetLabel(driveLetter)
        DriveSetLabel(driveLetter, sanitizedLabel)

        return {
            Success: true,
            OldLabel: oldLabel,
            NewLabel: sanitizedLabel,
            Drive: driveLetter,
            FileSystem: fileSystem
        }
    } catch as err {
        return {
            Success: false,
            Error: "Failed to set label: " . err.Message
        }
    }
}

; Example usage
Example1_BasicLabelSet() {
    ; Prompt user for drive and label
    drive := InputBox("Enter drive letter (e.g., D:):", "Set Drive Label").Value

    if (drive = "")
        return

    newLabel := InputBox("Enter new label:", "Set Drive Label").Value

    if (newLabel = "")
        return

    result := SetDriveLabel(drive, newLabel)

    if (result.Success) {
        message := Format("
        (
            Drive Label Changed Successfully
            ═══════════════════════════════════════

            Drive:      {1}
            File System: {2}
            Old Label:   {3}
            New Label:   {4}
        )",
            result.Drive,
            result.FileSystem,
            result.OldLabel != "" ? result.OldLabel : "(No Label)",
            result.NewLabel
        )
        MsgBox(message, "Success", "Iconi")
    } else {
        MsgBox("Failed to set label: " . result.Error, "Error", "Icon!")
    }

    return result
}

; ===================================================================================================
; EXAMPLE 2: Drive Lock/Unlock Operations
; ===================================================================================================

/**
 * @class DriveLockManager
 * @description Manages drive lock and unlock operations
 */
class DriveLockManager {
    /**
     * @method LockDrive
     * @description Locks a drive to prevent removal
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Result object
     */
    static LockDrive(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        ; Check if drive is removable
        driveType := DriveGetType(driveLetter)

        if (driveType != "Removable" && driveType != "CDROM") {
            return {
                Success: false,
                Error: "Only removable drives and CD/DVD drives can be locked"
            }
        }

        ; Check if drive is ready
        if (DriveGetStatus(driveLetter) != "Ready") {
            return {
                Success: false,
                Error: "Drive is not ready"
            }
        }

        try {
            DriveLock(driveLetter)

            return {
                Success: true,
                Drive: driveLetter,
                Type: driveType,
                Message: "Drive locked successfully"
            }
        } catch as err {
            return {
                Success: false,
                Error: "Failed to lock drive: " . err.Message
            }
        }
    }

    /**
     * @method UnlockDrive
     * @description Unlocks a drive for safe removal
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Result object
     */
    static UnlockDrive(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        try {
            DriveUnlock(driveLetter)

            return {
                Success: true,
                Drive: driveLetter,
                Message: "Drive unlocked successfully - safe to remove"
            }
        } catch as err {
            return {
                Success: false,
                Error: "Failed to unlock drive: " . err.Message
            }
        }
    }

    /**
     * @method SafeRemoveDrive
     * @description Safely prepares a drive for removal
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Result object
     */
    static SafeRemoveDrive(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        ; Step 1: Unlock the drive
        unlockResult := DriveLockManager.UnlockDrive(driveLetter)

        if (!unlockResult.Success) {
            return unlockResult
        }

        ; Step 2: Wait a moment for the unlock to complete
        Sleep(500)

        return {
            Success: true,
            Drive: driveLetter,
            Message: "Drive is safe to remove"
        }
    }

    /**
     * @method ShowLockStatus
     * @description Shows lock status information
     * @param {String} driveLetter - Drive letter
     */
    static ShowLockStatus(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        driveType := DriveGetType(driveLetter)
        status := DriveGetStatus(driveLetter)

        message := Format("Drive Lock Status - {1}`n", driveLetter)
        message .= "═══════════════════════════════════════`n`n"
        message .= Format("Type: {1}`n", driveType)
        message .= Format("Status: {1}`n`n", status)

        if (driveType = "Removable" || driveType = "CDROM") {
            message .= "This drive supports lock/unlock operations.`n`n"
            message .= "Lock: Prevents physical removal`n"
            message .= "Unlock: Allows safe removal"
        } else {
            message .= "This drive type does not support lock/unlock operations."
        }

        MsgBox(message, "Lock Status", "Iconi")
    }
}

; Example usage
Example2_DriveLock() {
    ; Show removable drives
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Drive Lock", "Iconi")
        return
    }

    message := "Removable Drives:`n`n"
    for index, driveLetter in StrSplit(removables) {
        drive := driveLetter . ":"
        label := ""
        if (DriveGetStatus(drive) = "Ready") {
            try {
                label := DriveGetLabel(drive)
            }
        }
        message .= Format("{1} - {2}`n", drive, label != "" ? label : "(No Label)")
    }

    MsgBox(message, "Removable Drives", "Iconi")

    ; Demo lock status
    if (StrLen(removables) > 0) {
        firstDrive := SubStr(removables, 1, 1) . ":"
        DriveLockManager.ShowLockStatus(firstDrive)
    }
}

; ===================================================================================================
; EXAMPLE 3: Automated Label Naming System
; ===================================================================================================

/**
 * @class AutoLabelManager
 * @description Automatically manages drive labels based on rules
 */
class AutoLabelManager {
    /**
     * @method GenerateLabel
     * @description Generates a label based on drive properties and date
     * @param {String} driveLetter - Drive letter
     * @param {String} template - Label template
     * @returns {String} Generated label
     *
     * Template variables:
     * - {TYPE} = Drive type
     * - {LETTER} = Drive letter
     * - {DATE} = Current date (YYYYMMDD)
     * - {COMPUTER} = Computer name
     */
    static GenerateLabel(driveLetter, template := "{TYPE}_{LETTER}_{DATE}") {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        driveType := DriveGetType(driveLetter)
        letter := SubStr(driveLetter, 1, 1)
        dateStr := FormatTime(A_Now, "yyyyMMdd")
        computerName := A_ComputerName

        ; Replace template variables
        label := template
        label := StrReplace(label, "{TYPE}", driveType)
        label := StrReplace(label, "{LETTER}", letter)
        label := StrReplace(label, "{DATE}", dateStr)
        label := StrReplace(label, "{COMPUTER}", computerName)

        ; Trim to safe length
        if (StrLen(label) > 32)
            label := SubStr(label, 1, 32)

        return label
    }

    /**
     * @method ApplyLabelingScheme
     * @description Applies a labeling scheme to multiple drives
     * @param {Array} drives - Array of drive letters
     * @param {String} scheme - Labeling scheme name
     * @returns {Array} Results array
     */
    static ApplyLabelingScheme(drives, scheme := "standard") {
        results := []

        for drive in drives {
            if !InStr(drive, ":")
                drive .= ":"

            if (DriveGetStatus(drive) != "Ready")
                continue

            template := ""

            switch scheme {
                case "standard":
                    template := "{TYPE}_{LETTER}"
                case "dated":
                    template := "{TYPE}_{DATE}"
                case "detailed":
                    template := "{COMPUTER}_{TYPE}_{LETTER}"
                default:
                    template := "{TYPE}_{LETTER}"
            }

            newLabel := AutoLabelManager.GenerateLabel(drive, template)
            result := SetDriveLabel(drive, newLabel)
            results.Push(result)
        }

        return results
    }

    /**
     * @method AutoLabelRemovableDrives
     * @description Automatically labels all removable drives
     */
    static AutoLabelRemovableDrives() {
        removables := []
        driveList := DriveGetList("Removable")

        for index, driveLetter in StrSplit(driveList) {
            removables.Push(driveLetter . ":")
        }

        if (removables.Length = 0) {
            MsgBox("No removable drives found.", "Auto Label", "Iconi")
            return
        }

        results := AutoLabelManager.ApplyLabelingScheme(removables, "dated")

        report := "Auto-Labeling Results`n"
        report .= "═══════════════════════════════════════`n`n"

        for result in results {
            if (result.Success) {
                report .= Format("{1}: {2} → {3}`n",
                    result.Drive,
                    result.OldLabel != "" ? result.OldLabel : "(No Label)",
                    result.NewLabel
                )
            } else {
                report .= Format("{1}: ERROR - {2}`n", result.Drive, result.Error)
            }
        }

        MsgBox(report, "Auto-Labeling Complete", "Iconi")
    }
}

; Example usage
Example3_AutoLabel() {
    AutoLabelManager.AutoLabelRemovableDrives()
}

; ===================================================================================================
; EXAMPLE 4: Label Validation and Sanitization
; ===================================================================================================

/**
 * @class LabelValidator
 * @description Validates and sanitizes drive labels
 */
class LabelValidator {
    /**
     * @method ValidateLabel
     * @description Validates a drive label
     * @param {String} label - Label to validate
     * @param {String} fileSystem - File system type
     * @returns {Object} Validation result
     */
    static ValidateLabel(label, fileSystem := "NTFS") {
        issues := []
        sanitized := label

        ; Check length
        maxLength := (fileSystem = "FAT32") ? 11 : 32

        if (StrLen(label) > maxLength) {
            issues.Push(Format("Label exceeds maximum length ({1} chars)", maxLength))
            sanitized := SubStr(label, 1, maxLength)
        }

        ; Check for invalid characters
        invalidChars := []
        if (RegExMatch(label, "[<>:""/\\|?*]", &match)) {
            issues.Push("Contains invalid characters: < > : "" / \ | ? *")
            sanitized := RegExReplace(sanitized, "[<>:""/\\|?*]", "")
        }

        ; Check for trailing spaces or periods
        if (RegExMatch(label, "[ .]$")) {
            issues.Push("Ends with space or period (not recommended)")
            sanitized := RTrim(sanitized, " .")
        }

        return {
            IsValid: (issues.Length = 0),
            Issues: issues,
            Original: label,
            Sanitized: sanitized,
            FileSystem: fileSystem
        }
    }

    /**
     * @method ShowValidation
     * @description Shows validation results
     * @param {String} label - Label to validate
     */
    static ShowValidation(label) {
        result := LabelValidator.ValidateLabel(label)

        message := "Label Validation Results`n"
        message .= "═══════════════════════════════════════`n`n"
        message .= Format("Original: '{1}'`n", result.Original)
        message .= Format("Sanitized: '{1}'`n`n", result.Sanitized)

        if (result.IsValid) {
            message .= "✓ Label is valid"
        } else {
            message .= "✗ Issues found:`n`n"
            for issue in result.Issues {
                message .= "  • " . issue . "`n"
            }
        }

        MsgBox(message, "Label Validation", result.IsValid ? "Iconi" : "Icon!")
    }
}

; Example usage
Example4_LabelValidation() {
    testLabels := [
        "ValidLabel",
        "This Label Is Too Long For FAT32 Drives",
        "Invalid<>Label",
        "Trailing Space ",
        "Good_Label_123"
    ]

    report := "Label Validation Tests`n"
    report .= "═══════════════════════════════════════════════════════`n`n"

    for label in testLabels {
        result := LabelValidator.ValidateLabel(label, "FAT32")
        status := result.IsValid ? "✓ VALID" : "✗ INVALID"
        report .= Format("'{1}' → {2}`n", label, status)

        if (!result.IsValid) {
            report .= Format("  Sanitized: '{1}'`n", result.Sanitized)
        }

        report .= "`n"
    }

    MsgBox(report, "Validation Tests", "Iconi")
}

; ===================================================================================================
; EXAMPLE 5: Batch Label Operations
; ===================================================================================================

/**
 * @class BatchLabelManager
 * @description Manages batch label operations
 */
class BatchLabelManager {
    /**
     * @method BackupLabels
     * @description Backs up current drive labels
     * @param {String} backupFile - File to save backup
     * @returns {Boolean} Success status
     */
    static BackupLabels(backupFile := "") {
        if (backupFile = "")
            backupFile := A_ScriptDir . "\drive_labels_backup.txt"

        content := "Drive Label Backup - " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n"
        content .= "═══════════════════════════════════════════════════════`n`n"

        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := DriveGetLabel(drive)
                    serial := DriveGetSerial(drive)
                    fileSystem := DriveGetFileSystem(drive)

                    content .= Format("{1}|{2}|{3}|{4}`n", drive, label, serial, fileSystem)
                } catch {
                    continue
                }
            }
        }

        try {
            FileDelete(backupFile)
            FileAppend(content, backupFile)
            return true
        } catch {
            return false
        }
    }

    /**
     * @method RestoreLabels
     * @description Restores drive labels from backup
     * @param {String} backupFile - Backup file to restore from
     * @returns {Object} Restore results
     */
    static RestoreLabels(backupFile := "") {
        if (backupFile = "")
            backupFile := A_ScriptDir . "\drive_labels_backup.txt"

        if !FileExist(backupFile) {
            return {
                Success: false,
                Error: "Backup file not found"
            }
        }

        content := FileRead(backupFile)
        lines := StrSplit(content, "`n", "`r")

        restored := 0
        skipped := 0
        errors := []

        for line in lines {
            if (InStr(line, "|") = 0)
                continue

            parts := StrSplit(line, "|")
            if (parts.Length < 4)
                continue

            drive := parts[1]
            label := parts[2]
            serial := parts[3]

            ; Verify drive by serial number
            if (DriveGetStatus(drive) = "Ready") {
                try {
                    currentSerial := DriveGetSerial(drive)

                    if (currentSerial = serial) {
                        DriveSetLabel(drive, label)
                        restored++
                    } else {
                        skipped++
                    }
                } catch as err {
                    errors.Push(Format("{1}: {2}", drive, err.Message))
                }
            } else {
                skipped++
            }
        }

        return {
            Success: true,
            Restored: restored,
            Skipped: skipped,
            Errors: errors
        }
    }

    /**
     * @method ShowBackupRestore
     * @description Shows backup and restore interface
     */
    static ShowBackupRestore() {
        choice := MsgBox("Backup or Restore drive labels?`n`nYes = Backup`nNo = Restore`nCancel = Exit",
                         "Batch Label Manager", "YesNoCancel Icon?")

        if (choice = "Yes") {
            ; Backup
            if (BatchLabelManager.BackupLabels()) {
                MsgBox("Drive labels backed up successfully!", "Backup Complete", "Iconi")
            } else {
                MsgBox("Failed to backup drive labels.", "Error", "Icon!")
            }
        } else if (choice = "No") {
            ; Restore
            result := BatchLabelManager.RestoreLabels()

            if (result.Success) {
                message := Format("
                (
                    Restore Complete
                    ═══════════════════════════════════════

                    Labels Restored: {1}
                    Skipped: {2}
                    Errors: {3}
                )",
                    result.Restored,
                    result.Skipped,
                    result.Errors.Length
                )
                MsgBox(message, "Restore Complete", "Iconi")
            } else {
                MsgBox(result.Error, "Restore Error", "Icon!")
            }
        }
    }
}

; Example usage
Example5_BatchLabels() {
    BatchLabelManager.ShowBackupRestore()
}

; ===================================================================================================
; EXAMPLE 6: USB Drive Auto-Labeler
; ===================================================================================================

/**
 * @class USBAutoLabeler
 * @description Automatically labels USB drives when connected
 */
class USBAutoLabeler {
    knownDrives := Map()
    labelTemplate := "USB_{DATE}_{LETTER}"
    isMonitoring := false

    /**
     * @constructor
     */
    __New() {
        this.UpdateKnownDrives()
    }

    /**
     * @method UpdateKnownDrives
     * @description Updates known drives list
     */
    UpdateKnownDrives() {
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            this.knownDrives[driveLetter . ":"] := true
        }
    }

    /**
     * @method CheckForNewDrives
     * @description Checks for new drives and auto-labels them
     */
    CheckForNewDrives() {
        currentDrives := DriveGetList("Removable")

        for index, driveLetter in StrSplit(currentDrives) {
            drive := driveLetter . ":"

            if (!this.knownDrives.Has(drive)) {
                this.knownDrives[drive] := true

                if (DriveGetStatus(drive) = "Ready") {
                    Sleep(1000)  ; Wait for drive to be fully ready
                    this.AutoLabelDrive(drive)
                }
            }
        }
    }

    /**
     * @method AutoLabelDrive
     * @description Auto-labels a drive
     * @param {String} driveLetter - Drive letter
     */
    AutoLabelDrive(driveLetter) {
        try {
            currentLabel := DriveGetLabel(driveLetter)

            ; Only label if currently unlabeled
            if (currentLabel = "") {
                newLabel := AutoLabelManager.GenerateLabel(driveLetter, this.labelTemplate)
                DriveSetLabel(driveLetter, newLabel)

                MsgBox(Format("USB drive {1} auto-labeled as: {2}", driveLetter, newLabel),
                       "Auto-Labeled", "Iconi 1")
            }
        }
    }

    /**
     * @method StartMonitoring
     * @description Starts monitoring for new USB drives
     */
    StartMonitoring() {
        if (this.isMonitoring)
            return

        this.isMonitoring := true
        SetTimer(() => this.CheckForNewDrives(), 2000)

        MsgBox("USB auto-labeling started.`nNew USB drives will be automatically labeled.",
               "Monitoring Started", "Iconi")
    }

    /**
     * @method StopMonitoring
     * @description Stops monitoring
     */
    StopMonitoring() {
        if (!this.isMonitoring)
            return

        this.isMonitoring := false
        SetTimer(() => this.CheckForNewDrives(), 0)

        MsgBox("USB auto-labeling stopped.", "Monitoring Stopped", "Iconx")
    }
}

; Example usage
Example6_USBAutoLabeler() {
    labeler := USBAutoLabeler()

    message := "USB Auto-Labeler`n"
    message .= "═══════════════════════════════════════`n`n"
    message .= "This tool will automatically label any`n"
    message .= "unlabeled USB drives when connected.`n`n"
    message .= "Label template: " . labeler.labelTemplate . "`n`n"
    message .= "Start monitoring?"

    if (MsgBox(message, "USB Auto-Labeler", "YesNo Icon?") = "Yes") {
        labeler.StartMonitoring()
    }

    return labeler
}

; ===================================================================================================
; EXAMPLE 7: Drive Label History Tracker
; ===================================================================================================

/**
 * @class LabelHistoryTracker
 * @description Tracks history of label changes
 */
class LabelHistoryTracker {
    historyFile := A_ScriptDir . "\label_history.csv"

    /**
     * @method RecordLabelChange
     * @description Records a label change
     * @param {String} drive - Drive letter
     * @param {String} oldLabel - Old label
     * @param {String} newLabel - New label
     */
    RecordLabelChange(drive, oldLabel, newLabel) {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

        record := Format("{1},{2},{3},{4},{5}`n",
            timestamp, drive, oldLabel, newLabel, A_ComputerName)

        ; Create file with header if needed
        if !FileExist(this.historyFile) {
            FileAppend("Timestamp,Drive,OldLabel,NewLabel,Computer`n", this.historyFile)
        }

        FileAppend(record, this.historyFile)
    }

    /**
     * @method SetLabelWithHistory
     * @description Sets a label and records the change
     * @param {String} drive - Drive letter
     * @param {String} newLabel - New label
     * @returns {Object} Result object
     */
    SetLabelWithHistory(drive, newLabel) {
        if !InStr(drive, ":")
            drive .= ":"

        if (DriveGetStatus(drive) != "Ready") {
            return {Success: false, Error: "Drive not ready"}
        }

        try {
            oldLabel := DriveGetLabel(drive)
            DriveSetLabel(drive, newLabel)
            this.RecordLabelChange(drive, oldLabel, newLabel)

            return {
                Success: true,
                Drive: drive,
                OldLabel: oldLabel,
                NewLabel: newLabel
            }
        } catch as err {
            return {
                Success: false,
                Error: err.Message
            }
        }
    }

    /**
     * @method GetHistory
     * @description Gets label change history
     * @param {String} drive - Drive letter (optional)
     * @returns {Array} History records
     */
    GetHistory(drive := "") {
        if !FileExist(this.historyFile)
            return []

        content := FileRead(this.historyFile)
        lines := StrSplit(content, "`n", "`r")
        history := []

        for index, line in lines {
            if (index = 1)  ; Skip header
                continue

            if (line = "")
                continue

            fields := StrSplit(line, ",")
            if (fields.Length >= 5) {
                if (drive = "" || fields[2] = drive) {
                    history.Push({
                        Timestamp: fields[1],
                        Drive: fields[2],
                        OldLabel: fields[3],
                        NewLabel: fields[4],
                        Computer: fields[5]
                    })
                }
            }
        }

        return history
    }

    /**
     * @method ShowHistory
     * @description Shows label change history
     */
    ShowHistory() {
        history := this.GetHistory()

        if (history.Length = 0) {
            MsgBox("No label change history found.", "History", "Iconi")
            return
        }

        report := "Drive Label Change History`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for record in history {
            report .= Format("[{1}] {2}`n", record.Timestamp, record.Drive)
            report .= Format("  {1} → {2}`n`n", record.OldLabel, record.NewLabel)
        }

        MsgBox(report, "Label History", "Iconi")
    }
}

; Example usage
Example7_LabelHistory() {
    tracker := LabelHistoryTracker()
    tracker.ShowHistory()
    return tracker
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+L to set a drive label
; ^!l::Example1_BasicLabelSet()

; Press Ctrl+Alt+K to manage drive locks
; ^!k::Example2_DriveLock()

; Press Ctrl+Alt+A to auto-label removable drives
; ^!a::Example3_AutoLabel()

; Press Ctrl+Alt+V to validate a label
; ^!v::Example4_LabelValidation()

; Press Ctrl+Alt+B to backup/restore labels
; ^!b::Example5_BatchLabels()
