/**
 * @file DriveInfo_01.ahk
 * @description Comprehensive examples of DriveGetType, DriveGetFileSystem, DriveGetLabel, and DriveGetSerial functions
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Getting drive type information
 * - Retrieving file system details
 * - Reading and displaying drive labels
 * - Obtaining drive serial numbers
 * - Creating drive inventory systems
 * - Identifying specific drives
 * - Generating drive documentation
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic Drive Information Retrieval
; ===================================================================================================

/**
 * @function GetCompleteDriveInfo
 * @description Gets complete information about a drive
 * @param {String} DriveLetter - The drive letter to query
 * @returns {Object} Object containing all drive information
 * 
 * @example
 * info := GetCompleteDriveInfo("C:")
 * MsgBox("Drive type: " . info.Type)
 */
GetCompleteDriveInfo(DriveLetter) {
    ; Ensure drive letter has colon
    if !InStr(DriveLetter, ":")
        DriveLetter .= ":"

    ; Get all drive information
    driveType := DriveGetType(DriveLetter)
    fileSystem := ""
    label := ""
    serial := ""
    status := DriveGetStatus(DriveLetter)

    ; Only get detailed info if drive is ready
    if (status = "Ready") {
        try {
            fileSystem := DriveGetFileSystem(DriveLetter)
            label := DriveGetLabel(DriveLetter)
            serial := DriveGetSerial(DriveLetter)
        } catch as err {
            ; Some information might not be available
        }
    }

    return {
        Drive: DriveLetter,
        Type: driveType,
        FileSystem: fileSystem,
        Label: label != "" ? label : "(No Label)",
        Serial: serial,
        Status: status,
        IsReady: (status = "Ready"),
        TypeDescription: GetDriveTypeDescription(driveType)
    }
}

/**
 * @function GetDriveTypeDescription
 * @description Gets a human-readable description of drive type
 * @param {String} driveType - The drive type code
 * @returns {String} Description of the drive type
 */
GetDriveTypeDescription(driveType) {
    switch driveType {
        case "Unknown":
            return "Unknown drive type"
        case "Removable":
            return "Removable drive (USB, SD card, etc.)"
        case "Fixed":
            return "Fixed hard drive"
        case "Network":
            return "Network drive"
        case "CDROM":
            return "CD/DVD drive"
        case "RAMDisk":
            return "RAM disk"
        default:
            return "Unknown type: " . driveType
    }
}

; Example usage
Example1_BasicDriveInfo() {
    ; Get information for C: drive
    info := GetCompleteDriveInfo("C:")

    ; Display formatted information
    report := Format("
    (
    Complete Drive Information
    ═══════════════════════════════════════

    Drive:          {1}
    Type:           {2}
    Description:    {3}
    File System:    {4}
    Label:          {5}
    Serial Number:  {6}
    Status:         {7}
    )",
        info.Drive,
        info.Type,
        info.TypeDescription,
        info.FileSystem != "" ? info.FileSystem : "N/A",
        info.Label,
        info.Serial != "" ? info.Serial : "N/A",
        info.Status
    )

    MsgBox(report, "Drive Information", "Iconi")

    return info
}

; ===================================================================================================
; EXAMPLE 2: Drive Type Classification and Filtering
; ===================================================================================================

/**
 * @class DriveClassifier
 * @description Classifies and filters drives by type
 */
class DriveClassifier {
    /**
     * @method GetDrivesByType
     * @description Gets all drives of a specific type
     * @param {String} driveType - Type filter (Fixed, Removable, CDROM, Network, RAMDisk)
     * @returns {Array} Array of drive information objects
     */
    static GetDrivesByType(driveType := "Fixed") {
        drives := []
        driveList := DriveGetList(driveType)

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            info := GetCompleteDriveInfo(drive)
            drives.Push(info)
        }

        return drives
    }

    /**
     * @method GetAllDrivesGrouped
     * @description Gets all drives grouped by type
     * @returns {Map} Map of drive types to arrays of drives
     */
    static GetAllDrivesGrouped() {
        grouped := Map()
        grouped["Fixed"] := []
        grouped["Removable"] := []
        grouped["CDROM"] := []
        grouped["Network"] := []
        grouped["RAMDisk"] := []
        grouped["Unknown"] := []

        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            info := GetCompleteDriveInfo(drive)

            if grouped.Has(info.Type)
                grouped[info.Type].Push(info)
            else
                grouped["Unknown"].Push(info)
        }

        return grouped
    }

    /**
     * @method ShowDrivesByType
     * @description Shows a categorized list of drives
     */
    static ShowDrivesByType() {
        grouped := DriveClassifier.GetAllDrivesGrouped()

        report := "Drives Categorized by Type`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        ; Display each category
        for driveType, driveList in grouped {
            if (driveList.Length = 0)
                continue

            report .= Format("{1} DRIVES ({2}):`n", StrUpper(driveType), driveList.Length)

            for info in driveList {
                report .= Format("  {1} - {2} [{3}]`n",
                    info.Drive,
                    info.Label,
                    info.FileSystem != "" ? info.FileSystem : "N/A"
                )
            }

            report .= "`n"
        }

        MsgBox(report, "Drives by Type", "Iconi")
    }
}

; Example usage
Example2_DriveClassification() {
    DriveClassifier.ShowDrivesByType()
}

; ===================================================================================================
; EXAMPLE 3: Drive Identification by Serial Number
; ===================================================================================================

/**
 * @class DriveIdentifier
 * @description Identifies and tracks drives by serial number
 */
class DriveIdentifier {
    /**
     * @method FindDriveBySerial
     * @description Finds a drive by its serial number
     * @param {String} serialNumber - Serial number to search for
     * @returns {Object} Drive information or empty object
     */
    static FindDriveBySerial(serialNumber) {
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    serial := DriveGetSerial(drive)

                    if (serial = serialNumber) {
                        return GetCompleteDriveInfo(drive)
                    }
                } catch {
                    continue
                }
            }
        }

        return { Found: false }
    }

    /**
     * @method FindDriveByLabel
     * @description Finds a drive by its label
     * @param {String} labelName - Label to search for
     * @returns {Array} Array of matching drives
     */
    static FindDriveByLabel(labelName) {
        matches := []
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := DriveGetLabel(drive)

                    if (InStr(label, labelName)) {
                        matches.Push(GetCompleteDriveInfo(drive))
                    }
                } catch {
                    continue
                }
            }
        }

        return matches
    }

    /**
     * @method CreateDriveSignature
     * @description Creates a unique signature for a drive
     * @param {String} driveLetter - Drive letter
     * @returns {String} Unique signature combining serial, label, and filesystem
     */
    static CreateDriveSignature(driveLetter) {
        info := GetCompleteDriveInfo(driveLetter)

        if (!info.IsReady)
            return ""

        ; Create signature: Type-FileSystem-Serial
        signature := Format("{1}:{2}:{3}",
            info.Type,
            info.FileSystem,
            info.Serial
        )

        return signature
    }

    /**
     * @method VerifyDriveIdentity
     * @description Verifies if a drive matches a stored signature
     * @param {String} driveLetter - Drive letter
     * @param {String} expectedSignature - Expected signature
     * @returns {Boolean} True if signature matches
     */
    static VerifyDriveIdentity(driveLetter, expectedSignature) {
        currentSignature := DriveIdentifier.CreateDriveSignature(driveLetter)
        return (currentSignature = expectedSignature)
    }
}

; Example usage
Example3_DriveIdentification() {
    ; Get signature for C: drive
    signature := DriveIdentifier.CreateDriveSignature("C:")

    message := Format("
    (
    Drive Identification
    ═══════════════════════════════════════

    Drive: C:
    Signature: {1}

    This signature can be used to verify the
    drive's identity in the future.
    )",
        signature
    )

    MsgBox(message, "Drive Signature", "Iconi")

    ; Find drives by label example
    matches := DriveIdentifier.FindDriveByLabel("System")

    if (matches.Length > 0) {
        message := "Drives matching label 'System':`n`n"
        for info in matches {
            message .= info.Drive . " - " . info.Label . "`n"
        }
        MsgBox(message, "Label Search", "Iconi")
    }
}

; ===================================================================================================
; EXAMPLE 4: File System Analysis
; ===================================================================================================

/**
 * @class FileSystemAnalyzer
 * @description Analyzes file systems across drives
 */
class FileSystemAnalyzer {
    /**
     * @method GetFileSystemStatistics
     * @description Gets statistics about file systems in use
     * @returns {Object} Statistics object
     */
    static GetFileSystemStatistics() {
        stats := Map()
        stats["NTFS"] := 0
        stats["FAT32"] := 0
        stats["exFAT"] := 0
        stats["ReFS"] := 0
        stats["Other"] := 0

        totalDrives := 0

        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    fs := DriveGetFileSystem(drive)
                    totalDrives++

                    if stats.Has(fs)
                        stats[fs] := stats[fs] + 1
                    else
                        stats["Other"] := stats["Other"] + 1
                } catch {
                    continue
                }
            }
        }

        return {
            Statistics: stats,
            TotalDrives: totalDrives
        }
    }

    /**
     * @method GetFileSystemCapabilities
     * @description Gets capabilities of a file system
     * @param {String} fileSystem - File system type
     * @returns {Object} Capabilities information
     */
    static GetFileSystemCapabilities(fileSystem) {
        capabilities := Map()

        switch fileSystem {
            case "NTFS":
                capabilities["MaxFileSize"] := "16 TB"
                capabilities["MaxVolumeSize"] := "256 TB"
                capabilities["Encryption"] := "Yes (EFS)"
                capabilities["Compression"] := "Yes"
                capabilities["Permissions"] := "Advanced ACLs"
                capabilities["JournalRecovery"] := "Yes"

            case "FAT32":
                capabilities["MaxFileSize"] := "4 GB"
                capabilities["MaxVolumeSize"] := "2 TB"
                capabilities["Encryption"] := "No"
                capabilities["Compression"] := "No"
                capabilities["Permissions"] := "Basic"
                capabilities["JournalRecovery"] := "No"

            case "exFAT":
                capabilities["MaxFileSize"] := "16 EB"
                capabilities["MaxVolumeSize"] := "128 PB"
                capabilities["Encryption"] := "No"
                capabilities["Compression"] := "No"
                capabilities["Permissions"] := "Basic"
                capabilities["JournalRecovery"] := "No"

            case "ReFS":
                capabilities["MaxFileSize"] := "35 PB"
                capabilities["MaxVolumeSize"] := "35 PB"
                capabilities["Encryption"] := "Yes"
                capabilities["Compression"] := "No"
                capabilities["Permissions"] := "Advanced ACLs"
                capabilities["JournalRecovery"] := "Yes"

            default:
                return { Supported: false }
        }

        capabilities["FileSystem"] := fileSystem
        capabilities["Supported"] := true

        return capabilities
    }

    /**
     * @method ShowFileSystemReport
     * @description Shows a comprehensive file system report
     */
    static ShowFileSystemReport() {
        stats := FileSystemAnalyzer.GetFileSystemStatistics()

        report := "File System Usage Report`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        report .= Format("Total Drives Analyzed: {1}`n`n", stats.TotalDrives)

        for fs, count in stats.Statistics {
            if (count > 0) {
                percentage := Round((count / stats.TotalDrives) * 100, 1)
                report .= Format("{1}: {2} drives ({3}%)`n", fs, count, percentage)
            }
        }

        MsgBox(report, "File System Report", "Iconi")
    }
}

; Example usage
Example4_FileSystemAnalysis() {
    FileSystemAnalyzer.ShowFileSystemReport()

    ; Show capabilities for NTFS
    caps := FileSystemAnalyzer.GetFileSystemCapabilities("NTFS")

    if (caps["Supported"]) {
        message := "NTFS File System Capabilities`n"
        message .= "═══════════════════════════════════════`n`n"

        for feature, value in caps {
            if (feature != "Supported" && feature != "FileSystem")
                message .= Format("{1}: {2}`n", feature, value)
        }

        MsgBox(message, "NTFS Capabilities", "Iconi")
    }
}

; ===================================================================================================
; EXAMPLE 5: Drive Label Management
; ===================================================================================================

/**
 * @class DriveLabelManager
 * @description Manages drive labels and naming conventions
 */
class DriveLabelManager {
    /**
     * @method GetAllLabels
     * @description Gets labels for all drives
     * @returns {Map} Map of drive letters to labels
     */
    static GetAllLabels() {
        labels := Map()
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := DriveGetLabel(drive)
                    labels[drive] := label != "" ? label : "(No Label)"
                } catch {
                    labels[drive] := "(Error reading label)"
                }
            } else {
                labels[drive] := "(Drive not ready)"
            }
        }

        return labels
    }

    /**
     * @method FindUnlabeledDrives
     * @description Finds drives without labels
     * @returns {Array} Array of unlabeled drives
     */
    static FindUnlabeledDrives() {
        unlabeled := []
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := DriveGetLabel(drive)

                    if (label = "")
                        unlabeled.Push(drive)
                } catch {
                    continue
                }
            }
        }

        return unlabeled
    }

    /**
     * @method SuggestLabel
     * @description Suggests a label based on drive properties
     * @param {String} driveLetter - Drive letter
     * @returns {String} Suggested label
     */
    static SuggestLabel(driveLetter) {
        info := GetCompleteDriveInfo(driveLetter)

        if (!info.IsReady)
            return ""

        ; Suggest based on drive type and letter
        suggestion := ""

        switch info.Type {
            case "Fixed":
                if (driveLetter = "C:")
                    suggestion := "System"
                else
                    suggestion := "Data_" . SubStr(driveLetter, 1, 1)

            case "Removable":
                suggestion := "USB_" . SubStr(driveLetter, 1, 1)

            case "Network":
                suggestion := "Network_" . SubStr(driveLetter, 1, 1)

            case "CDROM":
                suggestion := "Disc_" . SubStr(driveLetter, 1, 1)

            default:
                suggestion := "Drive_" . SubStr(driveLetter, 1, 1)
        }

        return suggestion
    }

    /**
     * @method ShowLabelReport
     * @description Shows a report of all drive labels
     */
    static ShowLabelReport() {
        labels := DriveLabelManager.GetAllLabels()

        report := "Drive Label Report`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        labeledCount := 0
        unlabeledCount := 0

        for drive, label in labels {
            report .= Format("{1}: {2}`n", drive, label)

            if (label != "(No Label)" && !InStr(label, "not ready") && !InStr(label, "Error"))
                labeledCount++
            else if (label = "(No Label)")
                unlabeledCount++
        }

        report .= "`n═══════════════════════════════════════════════════════`n"
        report .= Format("Labeled Drives: {1}`n", labeledCount)
        report .= Format("Unlabeled Drives: {1}", unlabeledCount)

        MsgBox(report, "Drive Labels", "Iconi")
    }
}

; Example usage
Example5_LabelManagement() {
    DriveLabelManager.ShowLabelReport()

    ; Find unlabeled drives
    unlabeled := DriveLabelManager.FindUnlabeledDrives()

    if (unlabeled.Length > 0) {
        message := "Unlabeled Drives Found:`n`n"

        for drive in unlabeled {
            suggestion := DriveLabelManager.SuggestLabel(drive)
            message .= Format("{1} - Suggested label: {2}`n", drive, suggestion)
        }

        MsgBox(message, "Unlabeled Drives", "Iconi")
    }
}

; ===================================================================================================
; EXAMPLE 6: Drive Inventory System
; ===================================================================================================

/**
 * @class DriveInventory
 * @description Creates and manages a complete drive inventory
 */
class DriveInventory {
    /**
     * @method CreateInventory
     * @description Creates a complete inventory of all drives
     * @returns {Array} Array of drive inventory records
     */
    static CreateInventory() {
        inventory := []
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            info := GetCompleteDriveInfo(drive)

            ; Add space information if drive is ready
            if (info.IsReady) {
                try {
                    info.CapacityMB := DriveGetCapacity(drive)
                    info.FreeSpaceMB := DriveGetSpaceFree(drive)
                    info.CapacityGB := Round(info.CapacityMB / 1024, 2)
                    info.FreeSpaceGB := Round(info.FreeSpaceMB / 1024, 2)
                } catch {
                    info.CapacityGB := "N/A"
                    info.FreeSpaceGB := "N/A"
                }
            } else {
                info.CapacityGB := "N/A"
                info.FreeSpaceGB := "N/A"
            }

            inventory.Push(info)
        }

        return inventory
    }

    /**
     * @method ExportInventory
     * @description Exports inventory to a file
     * @param {String} outputPath - Path to save the inventory
     * @param {String} format - Format (CSV or TXT)
     * @returns {Boolean} Success status
     */
    static ExportInventory(outputPath, format := "CSV") {
        inventory := DriveInventory.CreateInventory()

        content := ""

        if (format = "CSV") {
            ; CSV header
            content .= "Drive,Type,FileSystem,Label,Serial,Status,CapacityGB,FreeSpaceGB`n"

            for info in inventory {
                content .= Format("{1},{2},{3},{4},{5},{6},{7},{8}`n",
                    info.Drive,
                    info.Type,
                    info.FileSystem,
                    info.Label,
                    info.Serial,
                    info.Status,
                    info.CapacityGB,
                    info.FreeSpaceGB
                )
            }
        } else {
            ; TXT format
            content .= "DRIVE INVENTORY REPORT`n"
            content .= "Generated: " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n"
            content .= "═══════════════════════════════════════════════════════`n`n"

            for info in inventory {
                content .= Format("Drive: {1}`n", info.Drive)
                content .= Format("  Type:        {1}`n", info.TypeDescription)
                content .= Format("  File System: {1}`n", info.FileSystem != "" ? info.FileSystem : "N/A")
                content .= Format("  Label:       {1}`n", info.Label)
                content .= Format("  Serial:      {1}`n", info.Serial != "" ? info.Serial : "N/A")
                content .= Format("  Status:      {1}`n", info.Status)
                content .= Format("  Capacity:    {1} GB`n", info.CapacityGB)
                content .= Format("  Free Space:  {1} GB`n`n", info.FreeSpaceGB)
            }
        }

        try {
            FileAppend(content, outputPath)
            return true
        } catch {
            return false
        }
    }

    /**
     * @method ShowInventory
     * @description Shows a formatted inventory
     */
    static ShowInventory() {
        inventory := DriveInventory.CreateInventory()

        report := "Complete Drive Inventory`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for info in inventory {
            report .= Format("{1} [{2}] - {3} - {4}`n",
                info.Drive,
                info.Type,
                info.Label,
                info.Status
            )

            if (info.IsReady) {
                report .= Format("  {1} | {2} GB total | {3} GB free`n",
                    info.FileSystem,
                    info.CapacityGB,
                    info.FreeSpaceGB
                )
            }

            report .= "`n"
        }

        MsgBox(report, "Drive Inventory", "Iconi")
    }
}

; Example usage
Example6_DriveInventory() {
    DriveInventory.ShowInventory()

    ; Export inventory
    timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")
    DriveInventory.ExportInventory(A_Desktop . "\DriveInventory_" . timestamp . ".csv", "CSV")
    DriveInventory.ExportInventory(A_Desktop . "\DriveInventory_" . timestamp . ".txt", "TXT")

    MsgBox("Drive inventory exported to desktop.", "Export Complete", "Iconi")
}

; ===================================================================================================
; EXAMPLE 7: USB Drive Detector and Logger
; ===================================================================================================

/**
 * @class USBDriveLogger
 * @description Detects and logs USB drive connections
 */
class USBDriveLogger {
    logFile := A_ScriptDir . "\usb_drive_log.txt"
    knownDrives := Map()

    /**
     * @constructor
     */
    __New() {
        this.UpdateKnownDrives()
    }

    /**
     * @method UpdateKnownDrives
     * @description Updates the list of known drives
     */
    UpdateKnownDrives() {
        driveList := DriveGetList("Removable")

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            this.knownDrives[drive] := true
        }
    }

    /**
     * @method CheckForNewDrives
     * @description Checks for newly connected drives
     * @returns {Array} Array of new drive information
     */
    CheckForNewDrives() {
        newDrives := []
        currentDrives := DriveGetList("Removable")

        for index, driveLetter in StrSplit(currentDrives) {
            drive := driveLetter . ":"

            if (!this.knownDrives.Has(drive)) {
                info := GetCompleteDriveInfo(drive)
                newDrives.Push(info)
                this.knownDrives[drive] := true
                this.LogDriveConnection(info)
            }
        }

        return newDrives
    }

    /**
     * @method LogDriveConnection
     * @description Logs a drive connection
     * @param {Object} driveInfo - Drive information
     */
    LogDriveConnection(driveInfo) {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

        logEntry := Format("[{1}] USB Drive Connected`n", timestamp)
        logEntry .= Format("  Drive: {1}`n", driveInfo.Drive)
        logEntry .= Format("  Label: {1}`n", driveInfo.Label)
        logEntry .= Format("  Serial: {1}`n", driveInfo.Serial)
        logEntry .= Format("  File System: {1}`n`n", driveInfo.FileSystem)

        FileAppend(logEntry, this.logFile)
    }

    /**
     * @method StartMonitoring
     * @description Starts monitoring for USB drives
     */
    StartMonitoring() {
        SetTimer(() => this.MonitorDrives(), 2000)
        MsgBox("USB drive monitoring started.", "Monitor", "Iconi")
    }

    /**
     * @method MonitorDrives
     * @description Monitor callback function
     */
    MonitorDrives() {
        newDrives := this.CheckForNewDrives()

        for info in newDrives {
            MsgBox(Format("USB Drive Connected!`n`nDrive: {1}`nLabel: {2}",
                info.Drive, info.Label), "New Drive", "Iconi")
        }
    }
}

; Example usage
Example7_USBMonitor() {
    logger := USBDriveLogger()

    message := "USB Drive Logger initialized.`n`n"
    message .= "Current removable drives:`n"

    removable := DriveClassifier.GetDrivesByType("Removable")

    for info in removable {
        message .= Format("{1} - {2}`n", info.Drive, info.Label)
    }

    MsgBox(message, "USB Logger", "Iconi")

    return logger
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+I to show drive info
; ^!i::Example1_BasicDriveInfo()

; Press Ctrl+Alt+C to show drives by type
; ^!c::Example2_DriveClassification()

; Press Ctrl+Alt+F to show file system report
; ^!f::Example4_FileSystemAnalysis()

; Press Ctrl+Alt+L to show label report
; ^!l::Example5_LabelManagement()

; Press Ctrl+Alt+V to show inventory
; ^!v::Example6_DriveInventory()

