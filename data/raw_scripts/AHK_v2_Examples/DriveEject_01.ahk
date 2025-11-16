/**
 * @file DriveEject_01.ahk
 * @description Comprehensive examples of DriveEject, DriveRetract, and DriveGetStatusCD functions in AutoHotkey v2
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 *
 * This file demonstrates:
 * - Safely ejecting removable drives and optical media
 * - Retracting CD/DVD trays
 * - Checking CD/DVD drive status
 * - Automated eject procedures
 * - Safe eject validation
 * - Multi-drive eject operations
 * - CD/DVD tray automation
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic Drive Ejection
; ===================================================================================================

/**
 * @function SafeEjectDrive
 * @description Safely ejects a drive after validation
 * @param {String} driveLetter - The drive letter to eject
 * @param {Boolean} retract - Whether to retract after ejecting (for optical drives)
 * @returns {Object} Result object with success status
 *
 * @example
 * result := SafeEjectDrive("E:", false)
 * MsgBox(result.Success ? "Ejected" : "Failed")
 */
SafeEjectDrive(driveLetter, retract := false) {
    if !InStr(driveLetter, ":")
        driveLetter .= ":"

    ; Check drive type
    driveType := DriveGetType(driveLetter)

    if (driveType != "Removable" && driveType != "CDROM") {
        return {
            Success: false,
            Error: "Drive is not removable or an optical drive"
        }
    }

    ; Unlock drive first
    try {
        DriveUnlock(driveLetter)
    } catch {
        ; Drive may not be locked, continue
    }

    ; Eject the drive
    try {
        DriveEject(driveLetter)

        result := {
            Success: true,
            Drive: driveLetter,
            Type: driveType,
            Message: "Drive ejected successfully"
        }

        ; Retract if requested and it's a CD/DVD drive
        if (retract && driveType = "CDROM") {
            Sleep(3000)  ; Wait for tray to fully eject
            try {
                DriveRetract(driveLetter)
                result.Retracted := true
            } catch as err {
                result.Retracted := false
                result.RetractError := err.Message
            }
        }

        return result
    } catch as err {
        return {
            Success: false,
            Error: "Failed to eject: " . err.Message
        }
    }
}

; Example usage
Example1_BasicEject() {
    ; Get removable and CD drives
    removables := DriveGetList("Removable")
    cdroms := DriveGetList("CDROM")
    allEjectable := removables . cdroms

    if (StrLen(allEjectable) = 0) {
        MsgBox("No ejectable drives found.", "Drive Eject", "Iconi")
        return
    }

    ; Show available drives
    message := "Ejectable Drives:`n`n"
    for index, letter in StrSplit(allEjectable) {
        drive := letter . ":"
        driveType := DriveGetType(drive)
        label := ""

        if (DriveGetStatus(drive) = "Ready") {
            try {
                label := DriveGetLabel(drive)
            }
        }

        message .= Format("{1} [{2}] - {3}`n",
            drive,
            driveType,
            label != "" ? label : "(No Label)"
        )
    }

    MsgBox(message, "Ejectable Drives", "Iconi")

    ; Eject first drive as example
    if (StrLen(allEjectable) > 0) {
        firstDrive := SubStr(allEjectable, 1, 1) . ":"

        choice := MsgBox(Format("Eject drive {1}?", firstDrive), "Confirm Eject", "YesNo Icon?")

        if (choice = "Yes") {
            result := SafeEjectDrive(firstDrive)

            if (result.Success) {
                MsgBox(result.Message, "Success", "Iconi")
            } else {
                MsgBox(result.Error, "Error", "Icon!")
            }
        }
    }
}

; ===================================================================================================
; EXAMPLE 2: CD/DVD Drive Control
; ===================================================================================================

/**
 * @class OpticalDriveController
 * @description Controls CD/DVD drive tray operations
 */
class OpticalDriveController {
    /**
     * @method GetCDDriveStatus
     * @description Gets the status of a CD/DVD drive
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Status information
     */
    static GetCDDriveStatus(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetType(driveLetter) != "CDROM") {
            return {
                Success: false,
                Error: "Not a CD/DVD drive"
            }
        }

        try {
            status := DriveGetStatusCD(driveLetter)

            ; Status can be:
            ; "not ready" - Tray is open or no disc
            ; "open" - Tray is open
            ; "playing" - Audio CD is playing
            ; "paused" - Paused
            ; "seeking" - Seeking
            ; "stopped" - Stopped
            ; Empty string - Unknown status

            return {
                Success: true,
                Drive: driveLetter,
                Status: status,
                IsOpen: (status = "not ready" || status = "open"),
                HasMedia: (status != "not ready" && status != "open" && status != "")
            }
        } catch as err {
            return {
                Success: false,
                Error: err.Message
            }
        }
    }

    /**
     * @method ToggleTray
     * @description Toggles CD/DVD tray (open/close)
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Result object
     */
    static ToggleTray(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        statusInfo := OpticalDriveController.GetCDDriveStatus(driveLetter)

        if (!statusInfo.Success) {
            return statusInfo
        }

        try {
            if (statusInfo.IsOpen) {
                ; Tray is open, close it
                DriveRetract(driveLetter)
                action := "retracted"
            } else {
                ; Tray is closed, open it
                DriveEject(driveLetter)
                action := "ejected"
            }

            return {
                Success: true,
                Drive: driveLetter,
                Action: action,
                Message: Format("Tray {1} successfully", action)
            }
        } catch as err {
            return {
                Success: false,
                Error: err.Message
            }
        }
    }

    /**
     * @method EjectAll
     * @description Ejects all CD/DVD drives
     * @returns {Array} Results for each drive
     */
    static EjectAll() {
        results := []
        cdDrives := DriveGetList("CDROM")

        for index, letter in StrSplit(cdDrives) {
            drive := letter . ":"
            result := SafeEjectDrive(drive)
            results.Push(result)
        }

        return results
    }

    /**
     * @method RetractAll
     * @description Retracts all CD/DVD drives
     * @returns {Array} Results for each drive
     */
    static RetractAll() {
        results := []
        cdDrives := DriveGetList("CDROM")

        for index, letter in StrSplit(cdDrives) {
            drive := letter . ":"

            try {
                DriveRetract(drive)
                results.Push({
                    Success: true,
                    Drive: drive
                })
            } catch as err {
                results.Push({
                    Success: false,
                    Drive: drive,
                    Error: err.Message
                })
            }
        }

        return results
    }
}

; Example usage
Example2_CDDriveControl() {
    cdDrives := DriveGetList("CDROM")

    if (StrLen(cdDrives) = 0) {
        MsgBox("No CD/DVD drives found.", "Optical Drive Control", "Iconi")
        return
    }

    report := "CD/DVD Drive Control`n"
    report .= "═══════════════════════════════════════`n`n"

    for index, letter in StrSplit(cdDrives) {
        drive := letter . ":"
        statusInfo := OpticalDriveController.GetCDDriveStatus(drive)

        if (statusInfo.Success) {
            report .= Format("Drive {1}:`n", drive)
            report .= Format("  Status: {1}`n", statusInfo.Status)
            report .= Format("  Tray: {1}`n", statusInfo.IsOpen ? "Open" : "Closed")
            report .= Format("  Media: {1}`n`n", statusInfo.HasMedia ? "Present" : "None")
        }
    }

    MsgBox(report, "CD/DVD Drives", "Iconi")

    ; Toggle first drive
    if (StrLen(cdDrives) > 0) {
        firstDrive := SubStr(cdDrives, 1, 1) . ":"

        if (MsgBox("Toggle drive " . firstDrive . "?", "Toggle Tray", "YesNo Icon?") = "Yes") {
            result := OpticalDriveController.ToggleTray(firstDrive)

            if (result.Success) {
                MsgBox(result.Message, "Success", "Iconi")
            } else {
                MsgBox(result.Error, "Error", "Icon!")
            }
        }
    }
}

; ===================================================================================================
; EXAMPLE 3: Safe Eject with Validation
; ===================================================================================================

/**
 * @class SafeEjectManager
 * @description Manages safe ejection with comprehensive validation
 */
class SafeEjectManager {
    /**
     * @method ValidateEjectSafety
     * @description Validates if a drive can be safely ejected
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Validation result
     */
    static ValidateEjectSafety(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        issues := []

        ; Check if drive exists
        driveType := DriveGetType(driveLetter)
        if (driveType = "Unknown" || driveType = "") {
            return {
                Safe: false,
                Issues: ["Drive does not exist"]
            }
        }

        ; Check if drive is ejectable
        if (driveType != "Removable" && driveType != "CDROM") {
            return {
                Safe: false,
                Issues: ["Drive is not ejectable (not removable or optical)"]
            }
        }

        ; Check if any files are open on the drive
        try {
            testFile := driveLetter . "\eject_test.tmp"
            FileAppend("test", testFile)
            FileDelete(testFile)
        } catch {
            issues.Push("Drive may be in use - some files might be locked")
        }

        ; For removable drives, check if it's safe
        if (driveType = "Removable") {
            ; Additional safety checks can be added here
        }

        return {
            Safe: (issues.Length = 0),
            Issues: issues,
            Drive: driveLetter,
            Type: driveType,
            CanProceed: true  ; Can still try even with warnings
        }
    }

    /**
     * @method SafeEjectWithValidation
     * @description Ejects a drive after validation
     * @param {String} driveLetter - Drive letter
     * @param {Boolean} forceEject - Whether to force eject despite warnings
     * @returns {Object} Result object
     */
    static SafeEjectWithValidation(driveLetter, forceEject := false) {
        validation := SafeEjectManager.ValidateEjectSafety(driveLetter)

        if (!validation.Safe && !forceEject) {
            return {
                Success: false,
                Validation: validation,
                Message: "Drive is not safe to eject. Use forceEject to override."
            }
        }

        ; Proceed with ejection
        result := SafeEjectDrive(driveLetter)
        result.Validation := validation

        return result
    }
}

; Example usage
Example3_SafeEjectValidation() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Safe Eject", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"

    ; Validate safety
    validation := SafeEjectManager.ValidateEjectSafety(firstDrive)

    message := Format("Safe Eject Validation - {1}`n", firstDrive)
    message .= "═══════════════════════════════════════`n`n"

    if (validation.Safe) {
        message .= "✓ Safe to eject`n`n"
    } else {
        message .= "⚠ Safety Issues:`n"
        for issue in validation.Issues {
            message .= "  • " . issue . "`n"
        }
        message .= "`n"
    }

    message .= "Proceed with ejection?"

    if (MsgBox(message, "Safe Eject", "YesNo Icon?") = "Yes") {
        result := SafeEjectManager.SafeEjectWithValidation(firstDrive, true)

        if (result.Success) {
            MsgBox("Drive ejected successfully!", "Success", "Iconi")
        } else {
            MsgBox("Failed to eject: " . result.Message, "Error", "Icon!")
        }
    }
}

; ===================================================================================================
; EXAMPLE 4: Automated Eject on Completion
; ===================================================================================================

/**
 * @class AutoEjectOnComplete
 * @description Automatically ejects drive after file operations complete
 */
class AutoEjectOnComplete {
    /**
     * @method CopyAndEject
     * @description Copies files to drive and ejects when complete
     * @param {String} sourcePath - Source file or folder
     * @param {String} targetDrive - Target drive
     * @returns {Object} Result object
     */
    static CopyAndEject(sourcePath, targetDrive) {
        if !InStr(targetDrive, ":")
            targetDrive .= ":"

        if (DriveGetStatus(targetDrive) != "Ready") {
            return {
                Success: false,
                Error: "Target drive is not ready"
            }
        }

        ; Determine target path
        targetPath := targetDrive . "\"

        if (FileExist(sourcePath)) {
            ; Single file
            SplitPath(sourcePath, &fileName)
            targetPath .= fileName
        } else if (DirExist(sourcePath)) {
            ; Directory
            SplitPath(sourcePath, &folderName)
            targetPath .= folderName
        } else {
            return {
                Success: false,
                Error: "Source path does not exist"
            }
        }

        try {
            ; Copy files
            if (InStr(FileExist(sourcePath), "D")) {
                DirCopy(sourcePath, targetPath, true)
            } else {
                FileCopy(sourcePath, targetPath, true)
            }

            ; Wait a moment for write operations to complete
            Sleep(1000)

            ; Eject drive
            ejectResult := SafeEjectDrive(targetDrive)

            return {
                Success: true,
                SourcePath: sourcePath,
                TargetPath: targetPath,
                TargetDrive: targetDrive,
                Ejected: ejectResult.Success,
                Message: "Files copied and drive ejected"
            }
        } catch as err {
            return {
                Success: false,
                Error: "Copy failed: " . err.Message
            }
        }
    }
}

; Example usage
Example4_AutoEject() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Auto Eject", "Iconi")
        return
    }

    message := "Auto Copy and Eject Demo`n"
    message .= "═══════════════════════════════════════`n`n"
    message .= "This will copy a test file to the drive`n"
    message .= "and automatically eject when complete.`n`n"
    message .= "Continue?"

    if (MsgBox(message, "Auto Eject", "YesNo Icon?") = "Yes") {
        firstDrive := SubStr(removables, 1, 1) . ":"

        ; Create a test file
        testFile := A_Temp . "\test_copy.txt"
        FileDelete(testFile)
        FileAppend("This is a test file for auto-eject demo.", testFile)

        result := AutoEjectOnComplete.CopyAndEject(testFile, firstDrive)

        if (result.Success) {
            MsgBox(result.Message, "Success", "Iconi")
        } else {
            MsgBox(result.Error, "Error", "Icon!")
        }

        ; Cleanup
        FileDelete(testFile)
    }
}

; ===================================================================================================
; EXAMPLE 5: Multi-Drive Eject Manager
; ===================================================================================================

/**
 * @class MultiDriveEjectManager
 * @description Manages ejection of multiple drives
 */
class MultiDriveEjectManager {
    /**
     * @method EjectMultipleDrives
     * @description Ejects multiple drives
     * @param {Array} drives - Array of drive letters
     * @param {Number} delayMs - Delay between ejects in milliseconds
     * @returns {Array} Results for each drive
     */
    static EjectMultipleDrives(drives, delayMs := 1000) {
        results := []

        for drive in drives {
            result := SafeEjectDrive(drive)
            results.Push(result)

            ; Delay before next eject
            if (A_Index < drives.Length)
                Sleep(delayMs)
        }

        return results
    }

    /**
     * @method ShowEjectResults
     * @description Shows results of multi-drive eject
     * @param {Array} results - Eject results
     */
    static ShowEjectResults(results) {
        report := "Multi-Drive Eject Results`n"
        report .= "═══════════════════════════════════════`n`n"

        successCount := 0
        failCount := 0

        for result in results {
            if (result.Success) {
                successCount++
                report .= Format("✓ {1}: Ejected successfully`n", result.Drive)
            } else {
                failCount++
                report .= Format("✗ {1}: {2}`n", result.Drive, result.Error)
            }
        }

        report .= "`n═══════════════════════════════════════`n"
        report .= Format("Success: {1} | Failed: {2}", successCount, failCount)

        MsgBox(report, "Eject Results", "Iconi")
    }

    /**
     * @method EjectAllRemovable
     * @description Ejects all removable drives
     * @returns {Array} Results
     */
    static EjectAllRemovable() {
        drives := []
        removables := DriveGetList("Removable")

        for index, letter in StrSplit(removables) {
            drives.Push(letter . ":")
        }

        if (drives.Length = 0) {
            return []
        }

        return MultiDriveEjectManager.EjectMultipleDrives(drives)
    }
}

; Example usage
Example5_MultiDriveEject() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Multi-Drive Eject", "Iconi")
        return
    }

    driveCount := StrLen(removables)

    message := Format("Eject all {1} removable drive(s)?", driveCount)

    if (MsgBox(message, "Multi-Drive Eject", "YesNo Icon?") = "Yes") {
        results := MultiDriveEjectManager.EjectAllRemovable()
        MultiDriveEjectManager.ShowEjectResults(results)
    }
}

; ===================================================================================================
; EXAMPLE 6: CD/DVD Tray Animation
; ===================================================================================================

/**
 * @function CDTrayAnimation
 * @description Creates a fun animation with CD tray
 * @param {String} driveLetter - Drive letter
 * @param {Number} cycles - Number of open/close cycles
 */
CDTrayAnimation(driveLetter, cycles := 3) {
    if !InStr(driveLetter, ":")
        driveLetter .= ":"

    if (DriveGetType(driveLetter) != "CDROM") {
        MsgBox("Not a CD/DVD drive.", "Error", "Icon!")
        return
    }

    Loop cycles {
        ; Eject
        try {
            DriveEject(driveLetter)
            Sleep(2000)

            ; Retract
            DriveRetract(driveLetter)
            Sleep(2000)
        } catch as err {
            MsgBox("Animation failed: " . err.Message, "Error", "Icon!")
            return
        }
    }

    MsgBox("Animation complete!", "CD Tray Animation", "Iconi")
}

; Example usage
Example6_TrayAnimation() {
    cdDrives := DriveGetList("CDROM")

    if (StrLen(cdDrives) = 0) {
        MsgBox("No CD/DVD drives found.", "Tray Animation", "Iconi")
        return
    }

    firstDrive := SubStr(cdDrives, 1, 1) . ":"

    if (MsgBox("Play CD tray animation on drive " . firstDrive . "?",
               "Tray Animation", "YesNo Icon?") = "Yes") {
        CDTrayAnimation(firstDrive, 3)
    }
}

; ===================================================================================================
; EXAMPLE 7: Emergency Eject All
; ===================================================================================================

/**
 * @class EmergencyEject
 * @description Emergency eject all removable media
 */
class EmergencyEject {
    /**
     * @method EjectAllNow
     * @description Immediately ejects all removable media
     * @param {Boolean} includeOptical - Whether to include optical drives
     * @returns {Object} Summary of eject operations
     */
    static EjectAllNow(includeOptical := true) {
        ejectedDrives := []
        failedDrives := []

        ; Eject removable drives
        removables := DriveGetList("Removable")
        for index, letter in StrSplit(removables) {
            drive := letter . ":"

            try {
                DriveUnlock(drive)
                DriveEject(drive)
                ejectedDrives.Push(drive)
            } catch {
                failedDrives.Push(drive)
            }
        }

        ; Eject optical drives if requested
        if (includeOptical) {
            cdDrives := DriveGetList("CDROM")
            for index, letter in StrSplit(cdDrives) {
                drive := letter . ":"

                try {
                    DriveEject(drive)
                    ejectedDrives.Push(drive)
                } catch {
                    failedDrives.Push(drive)
                }
            }
        }

        return {
            EjectedDrives: ejectedDrives,
            FailedDrives: failedDrives,
            TotalEjected: ejectedDrives.Length,
            TotalFailed: failedDrives.Length
        }
    }

    /**
     * @method ShowEmergencyEjectSummary
     * @description Shows summary of emergency eject
     * @param {Object} summary - Eject summary
     */
    static ShowEmergencyEjectSummary(summary) {
        message := "Emergency Eject Summary`n"
        message .= "═══════════════════════════════════════`n`n"

        message .= Format("Ejected: {1} drive(s)`n", summary.TotalEjected)
        for drive in summary.EjectedDrives {
            message .= "  ✓ " . drive . "`n"
        }

        if (summary.TotalFailed > 0) {
            message .= Format("`nFailed: {1} drive(s)`n", summary.TotalFailed)
            for drive in summary.FailedDrives {
                message .= "  ✗ " . drive . "`n"
            }
        }

        MsgBox(message, "Emergency Eject", "Iconi")
    }
}

; Example usage
Example7_EmergencyEject() {
    message := "⚠ EMERGENCY EJECT ALL ⚠`n"
    message .= "═══════════════════════════════════════`n`n"
    message .= "This will immediately eject ALL removable`n"
    message .= "media and optical drives.`n`n"
    message .= "Continue?"

    if (MsgBox(message, "Emergency Eject", "YesNo Icon!") = "Yes") {
        summary := EmergencyEject.EjectAllNow(true)
        EmergencyEject.ShowEmergencyEjectSummary(summary)
    }
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+E to eject a drive
; ^!e::Example1_BasicEject()

; Press Ctrl+Alt+T to toggle CD tray
; ^!t::Example2_CDDriveControl()

; Press Ctrl+Alt+S to safe eject with validation
; ^!s::Example3_SafeEjectValidation()

; Press Ctrl+F12 for emergency eject all
; ^F12::Example7_EmergencyEject()
