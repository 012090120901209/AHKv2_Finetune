/**
 * @file DriveSet_02.ahk
 * @description Advanced drive management with DriveSetLabel, DriveLock, and DriveUnlock for automation and organization
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 *
 * This file demonstrates:
 * - Advanced label management strategies
 * - Automated drive organization systems
 * - Smart lock/unlock automation
 * - Drive access control
 * - Label-based file organization
 * - Conditional labeling rules
 * - Enterprise drive management
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Smart Drive Labeling System
; ===================================================================================================

/**
 * @class SmartLabeler
 * @description Intelligent drive labeling based on content analysis
 */
class SmartLabeler {
    /**
     * @method AnalyzeDriveContent
     * @description Analyzes drive content to suggest appropriate label
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Analysis results with suggested label
     */
    static AnalyzeDriveContent(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetStatus(driveLetter) != "Ready") {
            return {
                Success: false,
                Error: "Drive not ready"
            }
        }

        ; Count file types
        imageCount := 0
        videoCount := 0
        audioCount := 0
        docCount := 0
        codeCount := 0

        imageExts := [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg"]
        videoExts := [".mp4", ".avi", ".mkv", ".mov", ".wmv"]
        audioExts := [".mp3", ".wav", ".flac", ".m4a", ".wma"]
        docExts := [".doc", ".docx", ".pdf", ".txt", ".xlsx"]
        codeExts := [".ahk", ".py", ".js", ".cpp", ".java", ".cs"]

        try {
            Loop Files, driveLetter . "\*.*", "R" {
                ext := "." . A_LoopFileExt

                for imgExt in imageExts {
                    if (ext = imgExt) {
                        imageCount++
                        break
                    }
                }

                for vidExt in videoExts {
                    if (ext = vidExt) {
                        videoCount++
                        break
                    }
                }

                for audExt in audioExts {
                    if (ext = audExt) {
                        audioCount++
                        break
                    }
                }

                for docExt in docExts {
                    if (ext = docExt) {
                        docCount++
                        break
                    }
                }

                for codeExt in codeExts {
                    if (ext = codeExt) {
                        codeCount++
                        break
                    }
                }
            }
        } catch as err {
            return {
                Success: false,
                Error: "Failed to analyze content: " . err.Message
            }
        }

        ; Determine primary content type
        suggestedLabel := ""
        primaryType := ""

        maxCount := Max(imageCount, videoCount, audioCount, docCount, codeCount)

        if (maxCount = 0) {
            suggestedLabel := "Empty_" . SubStr(driveLetter, 1, 1)
            primaryType := "Empty"
        } else if (maxCount = imageCount) {
            suggestedLabel := "Photos_" . SubStr(driveLetter, 1, 1)
            primaryType := "Photos"
        } else if (maxCount = videoCount) {
            suggestedLabel := "Videos_" . SubStr(driveLetter, 1, 1)
            primaryType := "Videos"
        } else if (maxCount = audioCount) {
            suggestedLabel := "Music_" . SubStr(driveLetter, 1, 1)
            primaryType := "Music"
        } else if (maxCount = docCount) {
            suggestedLabel := "Documents_" . SubStr(driveLetter, 1, 1)
            primaryType := "Documents"
        } else if (maxCount = codeCount) {
            suggestedLabel := "Code_" . SubStr(driveLetter, 1, 1)
            primaryType := "Code"
        }

        return {
            Success: true,
            Drive: driveLetter,
            SuggestedLabel: suggestedLabel,
            PrimaryType: primaryType,
            ImageCount: imageCount,
            VideoCount: videoCount,
            AudioCount: audioCount,
            DocumentCount: docCount,
            CodeCount: codeCount
        }
    }

    /**
     * @method ApplySmartLabel
     * @description Applies smart labeling to a drive
     * @param {String} driveLetter - Drive letter
     * @param {Boolean} prompt - Whether to prompt user before applying
     * @returns {Object} Result object
     */
    static ApplySmartLabel(driveLetter, prompt := true) {
        analysis := SmartLabeler.AnalyzeDriveContent(driveLetter)

        if (!analysis.Success) {
            return analysis
        }

        if (prompt) {
            message := Format("
            (
                Smart Label Suggestion
                ═══════════════════════════════════════

                Drive: {1}
                Primary Content: {2}
                Suggested Label: {3}

                File Counts:
                  Photos: {4}
                  Videos: {5}
                  Music: {6}
                  Documents: {7}
                  Code: {8}

                Apply this label?
            )",
                analysis.Drive,
                analysis.PrimaryType,
                analysis.SuggestedLabel,
                analysis.ImageCount,
                analysis.VideoCount,
                analysis.AudioCount,
                analysis.DocumentCount,
                analysis.CodeCount
            )

            if (MsgBox(message, "Smart Label", "YesNo Icon?") = "No") {
                return {Success: false, Cancelled: true}
            }
        }

        try {
            oldLabel := DriveGetLabel(driveLetter)
            DriveSetLabel(driveLetter, analysis.SuggestedLabel)

            return {
                Success: true,
                Drive: driveLetter,
                OldLabel: oldLabel,
                NewLabel: analysis.SuggestedLabel,
                Analysis: analysis
            }
        } catch as err {
            return {
                Success: false,
                Error: "Failed to set label: " . err.Message
            }
        }
    }
}

; Example usage
Example1_SmartLabeling() {
    ; Get removable drives
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Smart Labeling", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"
    result := SmartLabeler.ApplySmartLabel(firstDrive, true)

    if (result.Success) {
        MsgBox("Smart label applied successfully!", "Success", "Iconi")
    }

    return result
}

; ===================================================================================================
; EXAMPLE 2: Conditional Drive Locking System
; ===================================================================================================

/**
 * @class ConditionalLocker
 * @description Locks/unlocks drives based on conditions
 */
class ConditionalLocker {
    /**
     * @method LockIfInUse
     * @description Locks a drive if files are currently being accessed
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Result object
     */
    static LockIfInUse(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        driveType := DriveGetType(driveLetter)

        if (driveType != "Removable") {
            return {
                Success: false,
                Error: "Only removable drives can be conditionally locked"
            }
        }

        ; Check if any processes are accessing the drive
        inUse := ConditionalLocker.IsDriveInUse(driveLetter)

        if (inUse) {
            try {
                DriveLock(driveLetter)
                return {
                    Success: true,
                    Drive: driveLetter,
                    Locked: true,
                    Reason: "Drive is in use"
                }
            } catch as err {
                return {
                    Success: false,
                    Error: "Failed to lock: " . err.Message
                }
            }
        } else {
            return {
                Success: true,
                Drive: driveLetter,
                Locked: false,
                Reason: "Drive not in use, no lock needed"
            }
        }
    }

    /**
     * @method IsDriveInUse
     * @description Checks if a drive is currently being accessed
     * @param {String} driveLetter - Drive letter
     * @returns {Boolean} True if in use
     */
    static IsDriveInUse(driveLetter) {
        ; Try to create a test file
        testFile := driveLetter . "\access_test.tmp"

        try {
            FileAppend("test", testFile)
            FileDelete(testFile)
            return false  ; No active locks, not in use
        } catch {
            return true  ; File access failed, likely in use
        }
    }

    /**
     * @method AutoLockOnWrite
     * @description Automatically locks drive when write operations occur
     * @param {String} driveLetter - Drive letter
     * @param {Number} duration - Lock duration in milliseconds
     */
    static AutoLockOnWrite(driveLetter, duration := 5000) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        ; Lock the drive
        try {
            DriveLock(driveLetter)

            ; Schedule unlock
            SetTimer(() => ConditionalLocker.SafeUnlock(driveLetter), -duration)

            return {
                Success: true,
                Drive: driveLetter,
                LockDuration: duration
            }
        } catch as err {
            return {
                Success: false,
                Error: err.Message
            }
        }
    }

    /**
     * @method SafeUnlock
     * @description Safely unlocks a drive
     * @param {String} driveLetter - Drive letter
     */
    static SafeUnlock(driveLetter) {
        try {
            DriveUnlock(driveLetter)
        }
    }
}

; Example usage
Example2_ConditionalLocking() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Conditional Locking", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"
    result := ConditionalLocker.LockIfInUse(firstDrive)

    message := Format("
    (
        Conditional Lock Result
        ═══════════════════════════════════════

        Drive: {1}
        Locked: {2}
        Reason: {3}
    )",
        result.Drive,
        result.HasOwnProp("Locked") ? (result.Locked ? "Yes" : "No") : "Error",
        result.HasOwnProp("Reason") ? result.Reason : result.Error
    )

    MsgBox(message, "Conditional Lock", "Iconi")
}

; ===================================================================================================
; EXAMPLE 3: Enterprise Drive Labeling Policy
; ===================================================================================================

/**
 * @class EnterpriseLabelPolicy
 * @description Enforces enterprise labeling policies
 */
class EnterpriseLabelPolicy {
    static policies := Map()

    /**
     * @method DefinePolicy
     * @description Defines a labeling policy
     * @param {String} name - Policy name
     * @param {Object} rules - Policy rules
     */
    static DefinePolicy(name, rules) {
        EnterpriseLabelPolicy.policies[name] := rules
    }

    /**
     * @method ApplyPolicy
     * @description Applies a policy to a drive
     * @param {String} driveLetter - Drive letter
     * @param {String} policyName - Policy to apply
     * @returns {Object} Result object
     */
    static ApplyPolicy(driveLetter, policyName) {
        if !EnterpriseLabelPolicy.policies.Has(policyName) {
            return {
                Success: false,
                Error: "Policy not found: " . policyName
            }
        }

        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetStatus(driveLetter) != "Ready") {
            return {
                Success: false,
                Error: "Drive not ready"
            }
        }

        policy := EnterpriseLabelPolicy.policies[policyName]

        ; Build label according to policy
        label := policy.Prefix

        if policy.HasOwnProp("IncludeDrive") && policy.IncludeDrive
            label .= SubStr(driveLetter, 1, 1)

        if policy.HasOwnProp("IncludeComputer") && policy.IncludeComputer
            label .= "_" . A_ComputerName

        if policy.HasOwnProp("IncludeDate") && policy.IncludeDate
            label .= "_" . FormatTime(A_Now, "yyyyMMdd")

        if policy.HasOwnProp("IncludeSerial") && policy.IncludeSerial {
            try {
                serial := DriveGetSerial(driveLetter)
                label .= "_" . SubStr(serial, -4)  ; Last 4 digits
            }
        }

        ; Ensure label meets length requirements
        if (StrLen(label) > 32)
            label := SubStr(label, 1, 32)

        try {
            oldLabel := DriveGetLabel(driveLetter)
            DriveSetLabel(driveLetter, label)

            return {
                Success: true,
                Drive: driveLetter,
                Policy: policyName,
                OldLabel: oldLabel,
                NewLabel: label
            }
        } catch as err {
            return {
                Success: false,
                Error: "Failed to apply policy: " . err.Message
            }
        }
    }

    /**
     * @method ValidateCompliance
     * @description Validates if a drive complies with policy
     * @param {String} driveLetter - Drive letter
     * @param {String} policyName - Policy name
     * @returns {Object} Validation result
     */
    static ValidateCompliance(driveLetter, policyName) {
        if !EnterpriseLabelPolicy.policies.Has(policyName) {
            return {
                Compliant: false,
                Error: "Policy not found"
            }
        }

        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetStatus(driveLetter) != "Ready") {
            return {
                Compliant: false,
                Error: "Drive not ready"
            }
        }

        policy := EnterpriseLabelPolicy.policies[policyName]

        try {
            currentLabel := DriveGetLabel(driveLetter)

            ; Check if label starts with required prefix
            if policy.HasOwnProp("Prefix") {
                if !InStr(currentLabel, policy.Prefix) = 1 {
                    return {
                        Compliant: false,
                        Reason: "Label does not start with required prefix: " . policy.Prefix,
                        CurrentLabel: currentLabel
                    }
                }
            }

            ; Check if label is not empty (if required)
            if policy.HasOwnProp("RequireLabel") && policy.RequireLabel {
                if (currentLabel = "") {
                    return {
                        Compliant: false,
                        Reason: "Label is required but drive is unlabeled"
                    }
                }
            }

            return {
                Compliant: true,
                Drive: driveLetter,
                Label: currentLabel,
                Policy: policyName
            }
        } catch as err {
            return {
                Compliant: false,
                Error: err.Message
            }
        }
    }
}

; Define example policies
EnterpriseLabelPolicy.DefinePolicy("Corporate", {
    Prefix: "CORP",
    IncludeDrive: true,
    IncludeComputer: true,
    RequireLabel: true
})

EnterpriseLabelPolicy.DefinePolicy("Backup", {
    Prefix: "BACKUP",
    IncludeDate: true,
    IncludeComputer: true,
    RequireLabel: true
})

EnterpriseLabelPolicy.DefinePolicy("Portable", {
    Prefix: "USB",
    IncludeDrive: true,
    IncludeSerial: true,
    RequireLabel: true
})

; Example usage
Example3_EnterprisePolicy() {
    ; Get all removable drives
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Enterprise Policy", "Iconi")
        return
    }

    report := "Enterprise Policy Application`n"
    report .= "═══════════════════════════════════════════════════════`n`n"

    for index, driveLetter in StrSplit(removables) {
        drive := driveLetter . ":"

        ; Apply Portable policy
        result := EnterpriseLabelPolicy.ApplyPolicy(drive, "Portable")

        if (result.Success) {
            report .= Format("{1}: {2} → {3}`n",
                result.Drive,
                result.OldLabel != "" ? result.OldLabel : "(No Label)",
                result.NewLabel
            )
        } else {
            report .= Format("{1}: ERROR - {2}`n", drive, result.Error)
        }
    }

    MsgBox(report, "Policy Applied", "Iconi")
}

; ===================================================================================================
; EXAMPLE 4: Automated Backup Drive Preparation
; ===================================================================================================

/**
 * @class BackupDrivePrep
 * @description Prepares drives for backup operations
 */
class BackupDrivePrep {
    /**
     * @method PrepareBackupDrive
     * @description Prepares a drive for backup with appropriate label and lock
     * @param {String} driveLetter - Drive letter
     * @param {String} backupType - Type of backup (Daily, Weekly, Monthly)
     * @returns {Object} Result object
     */
    static PrepareBackupDrive(driveLetter, backupType := "Daily") {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetStatus(driveLetter) != "Ready") {
            return {
                Success: false,
                Error: "Drive not ready"
            }
        }

        ; Generate backup label
        dateStr := FormatTime(A_Now, "yyyyMMdd")
        label := Format("BACKUP_{1}_{2}", backupType, dateStr)

        ; Set label
        try {
            oldLabel := DriveGetLabel(driveLetter)
            DriveSetLabel(driveLetter, label)

            ; Lock drive if removable (to prevent accidental removal during backup)
            driveType := DriveGetType(driveLetter)
            locked := false

            if (driveType = "Removable") {
                try {
                    DriveLock(driveLetter)
                    locked := true
                } catch {
                    ; Lock may fail, but continue anyway
                }
            }

            return {
                Success: true,
                Drive: driveLetter,
                OldLabel: oldLabel,
                NewLabel: label,
                BackupType: backupType,
                Locked: locked,
                ReadyForBackup: true
            }
        } catch as err {
            return {
                Success: false,
                Error: "Failed to prepare drive: " . err.Message
            }
        }
    }

    /**
     * @method FinishBackupDrive
     * @description Finalizes a backup drive after backup completion
     * @param {String} driveLetter - Drive letter
     * @param {Boolean} success - Whether backup was successful
     * @returns {Object} Result object
     */
    static FinishBackupDrive(driveLetter, success := true) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        try {
            ; Update label to indicate completion
            currentLabel := DriveGetLabel(driveLetter)
            newLabel := currentLabel . (success ? "_OK" : "_ERR")

            ; Trim if too long
            if (StrLen(newLabel) > 32)
                newLabel := SubStr(currentLabel, 1, 28) . (success ? "_OK" : "_ERR")

            DriveSetLabel(driveLetter, newLabel)

            ; Unlock drive if removable
            driveType := DriveGetType(driveLetter)

            if (driveType = "Removable") {
                try {
                    DriveUnlock(driveLetter)
                } catch {
                    ; Unlock may fail if not locked
                }
            }

            return {
                Success: true,
                Drive: driveLetter,
                Label: newLabel,
                BackupSuccess: success,
                SafeToRemove: true
            }
        } catch as err {
            return {
                Success: false,
                Error: err.Message
            }
        }
    }
}

; Example usage
Example4_BackupPrep() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Backup Prep", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"

    ; Prepare for backup
    result := BackupDrivePrep.PrepareBackupDrive(firstDrive, "Daily")

    if (result.Success) {
        message := Format("
        (
            Backup Drive Prepared
            ═══════════════════════════════════════

            Drive: {1}
            New Label: {2}
            Backup Type: {3}
            Locked: {4}

            Drive is ready for backup operation.

            Simulate backup completion?
        )",
            result.Drive,
            result.NewLabel,
            result.BackupType,
            result.Locked ? "Yes" : "No"
        )

        if (MsgBox(message, "Backup Prep", "YesNo Icon?") = "Yes") {
            ; Simulate successful backup
            Sleep(2000)

            finishResult := BackupDrivePrep.FinishBackupDrive(firstDrive, true)

            if (finishResult.Success) {
                MsgBox(Format("Backup completed!`n`nDrive: {1}`nLabel: {2}`nSafe to remove: {3}",
                    finishResult.Drive,
                    finishResult.Label,
                    finishResult.SafeToRemove ? "Yes" : "No"
                ), "Backup Complete", "Iconi")
            }
        }
    } else {
        MsgBox("Failed to prepare drive: " . result.Error, "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 5: Project-Based Drive Organization
; ===================================================================================================

/**
 * @class ProjectDriveOrganizer
 * @description Organizes drives based on project naming conventions
 */
class ProjectDriveOrganizer {
    /**
     * @method CreateProjectDrive
     * @description Creates a project-labeled drive
     * @param {String} driveLetter - Drive letter
     * @param {String} projectName - Project name
     * @param {String} projectCode - Project code (optional)
     * @returns {Object} Result object
     */
    static CreateProjectDrive(driveLetter, projectName, projectCode := "") {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetStatus(driveLetter) != "Ready") {
            return {
                Success: false,
                Error: "Drive not ready"
            }
        }

        ; Build project label
        label := "PRJ"

        if (projectCode != "")
            label .= "_" . projectCode

        ; Sanitize project name
        safeName := RegExReplace(projectName, "[^a-zA-Z0-9_-]", "")
        safeName := SubStr(safeName, 1, 20)  ; Limit length

        label .= "_" . safeName

        ; Ensure total length is acceptable
        if (StrLen(label) > 32)
            label := SubStr(label, 1, 32)

        try {
            oldLabel := DriveGetLabel(driveLetter)
            DriveSetLabel(driveLetter, label)

            ; Create standard project folders
            ProjectDriveOrganizer.CreateProjectStructure(driveLetter)

            return {
                Success: true,
                Drive: driveLetter,
                OldLabel: oldLabel,
                NewLabel: label,
                ProjectName: projectName,
                ProjectCode: projectCode
            }
        } catch as err {
            return {
                Success: false,
                Error: err.Message
            }
        }
    }

    /**
     * @method CreateProjectStructure
     * @description Creates standard project folder structure
     * @param {String} driveLetter - Drive letter
     */
    static CreateProjectStructure(driveLetter) {
        folders := [
            "Documents",
            "Source",
            "Assets",
            "Output",
            "Archive",
            "References"
        ]

        for folder in folders {
            folderPath := driveLetter . "\" . folder

            if !DirExist(folderPath) {
                try {
                    DirCreate(folderPath)
                } catch {
                    ; Folder creation may fail, continue anyway
                }
            }
        }
    }

    /**
     * @method ListProjectDrives
     * @description Lists all drives with project labels
     * @returns {Array} Array of project drive information
     */
    static ListProjectDrives() {
        projectDrives := []
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := DriveGetLabel(drive)

                    ; Check if it's a project drive (starts with PRJ)
                    if InStr(label, "PRJ") = 1 {
                        projectDrives.Push({
                            Drive: drive,
                            Label: label,
                            Type: DriveGetType(drive)
                        })
                    }
                } catch {
                    continue
                }
            }
        }

        return projectDrives
    }
}

; Example usage
Example5_ProjectOrganization() {
    removables := DriveGetList("Removable")

    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Project Organization", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"

    ; Get project details
    projectName := InputBox("Enter project name:", "Project Drive Setup").Value
    if (projectName = "")
        return

    projectCode := InputBox("Enter project code (optional):", "Project Drive Setup").Value

    ; Create project drive
    result := ProjectDriveOrganizer.CreateProjectDrive(firstDrive, projectName, projectCode)

    if (result.Success) {
        message := Format("
        (
            Project Drive Created
            ═══════════════════════════════════════

            Drive: {1}
            Label: {2}
            Project: {3}
            Code: {4}

            Standard project folders created:
            • Documents
            • Source
            • Assets
            • Output
            • Archive
            • References
        )",
            result.Drive,
            result.NewLabel,
            result.ProjectName,
            result.ProjectCode != "" ? result.ProjectCode : "(None)"
        )

        MsgBox(message, "Project Drive Ready", "Iconi")
    } else {
        MsgBox("Failed to create project drive: " . result.Error, "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 6: Time-Based Auto-Unlock System
; ===================================================================================================

/**
 * @class TimeBasedUnlock
 * @description Automatically unlocks drives at specific times
 */
class TimeBasedUnlock {
    schedules := Map()

    /**
     * @method ScheduleUnlock
     * @description Schedules a drive to unlock at a specific time
     * @param {String} driveLetter - Drive letter
     * @param {String} unlockTime - Time to unlock (HHmm format, e.g., "0900")
     */
    ScheduleUnlock(driveLetter, unlockTime) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        this.schedules[driveLetter] := unlockTime

        ; Start monitoring
        SetTimer(() => this.CheckSchedules(), 60000)  ; Check every minute
    }

    /**
     * @method CheckSchedules
     * @description Checks if any drives should be unlocked
     */
    CheckSchedules() {
        currentTime := FormatTime(A_Now, "HHmm")

        for drive, unlockTime in this.schedules {
            if (currentTime = unlockTime) {
                this.UnlockDrive(drive)
            }
        }
    }

    /**
     * @method UnlockDrive
     * @description Unlocks a drive
     * @param {String} driveLetter - Drive letter
     */
    UnlockDrive(driveLetter) {
        try {
            DriveUnlock(driveLetter)
            MsgBox(Format("Drive {1} auto-unlocked at {2}",
                driveLetter,
                FormatTime(A_Now, "HH:mm")
            ), "Auto-Unlock", "Iconi 2")
        } catch as err {
            ; Unlock may fail if drive is not locked
        }
    }
}

; Example usage
Example6_TimeBasedUnlock() {
    unlocker := TimeBasedUnlock()

    message := "Time-Based Auto-Unlock System`n"
    message .= "═══════════════════════════════════════`n`n"
    message .= "Schedule a drive to automatically unlock`n"
    message .= "at a specific time each day.`n`n"
    message .= "Enter unlock time (HHmm format, e.g., 0900):"

    unlockTime := InputBox(message, "Schedule Unlock").Value

    if (unlockTime = "" || StrLen(unlockTime) != 4)
        return

    removables := DriveGetList("Removable")
    if (StrLen(removables) = 0) {
        MsgBox("No removable drives found.", "Schedule Unlock", "Iconi")
        return
    }

    firstDrive := SubStr(removables, 1, 1) . ":"
    unlocker.ScheduleUnlock(firstDrive, unlockTime)

    MsgBox(Format("Drive {1} scheduled to unlock at {2}:{3}",
        firstDrive,
        SubStr(unlockTime, 1, 2),
        SubStr(unlockTime, 3, 2)
    ), "Schedule Set", "Iconi")

    return unlocker
}

; ===================================================================================================
; EXAMPLE 7: Multi-Drive Label Synchronization
; ===================================================================================================

/**
 * @class LabelSync
 * @description Synchronizes labels across multiple drives
 */
class LabelSync {
    /**
     * @method SyncLabels
     * @description Synchronizes labels to match a pattern
     * @param {Array} drives - Drives to synchronize
     * @param {String} pattern - Label pattern to apply
     * @returns {Array} Results for each drive
     */
    static SyncLabels(drives, pattern) {
        results := []

        for index, driveLetter in drives {
            if !InStr(driveLetter, ":")
                driveLetter .= ":"

            ; Replace pattern variables
            label := StrReplace(pattern, "{INDEX}", index)
            label := StrReplace(label, "{LETTER}", SubStr(driveLetter, 1, 1))
            label := StrReplace(label, "{DATE}", FormatTime(A_Now, "yyyyMMdd"))

            try {
                oldLabel := DriveGetLabel(driveLetter)
                DriveSetLabel(driveLetter, label)

                results.Push({
                    Success: true,
                    Drive: driveLetter,
                    OldLabel: oldLabel,
                    NewLabel: label
                })
            } catch as err {
                results.Push({
                    Success: false,
                    Drive: driveLetter,
                    Error: err.Message
                })
            }
        }

        return results
    }

    /**
     * @method ShowSyncResults
     * @description Shows synchronization results
     * @param {Array} results - Sync results
     */
    static ShowSyncResults(results) {
        report := "Label Synchronization Results`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

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

        MsgBox(report, "Sync Results", "Iconi")
    }
}

; Example usage
Example7_LabelSync() {
    ; Get all removable drives
    removableList := DriveGetList("Removable")

    if (StrLen(removableList) = 0) {
        MsgBox("No removable drives found.", "Label Sync", "Iconi")
        return
    }

    drives := []
    for index, letter in StrSplit(removableList) {
        drives.Push(letter . ":")
    }

    ; Sync with pattern
    pattern := "SYNC_{INDEX}_{DATE}"
    results := LabelSync.SyncLabels(drives, pattern)
    LabelSync.ShowSyncResults(results)
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+S to apply smart labeling
; ^!s::Example1_SmartLabeling()

; Press Ctrl+Alt+C to use conditional locking
; ^!c::Example2_ConditionalLocking()

; Press Ctrl+Alt+E to apply enterprise policy
; ^!e::Example3_EnterprisePolicy()

; Press Ctrl+Alt+B to prepare backup drive
; ^!b::Example4_BackupPrep()

; Press Ctrl+Alt+P to create project drive
; ^!p::Example5_ProjectOrganization()
