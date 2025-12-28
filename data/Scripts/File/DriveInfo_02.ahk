/**
 * @file DriveInfo_02.ahk
 * @description Advanced drive information analysis and comparison tools using DriveGetType, DriveGetFileSystem, DriveGetLabel, and DriveGetSerial
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Advanced drive comparison and analytics
 * - Drive profile management
 * - Automated drive documentation
 * - Network drive mapping analysis
 * - Drive performance categorization
 * - Custom drive organization systems
 * - Drive audit and compliance checking
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Drive Profile System
; ===================================================================================================

/**
 * @class DriveProfile
 * @description Creates and manages comprehensive drive profiles
 */
class DriveProfile {
    profileDir := A_ScriptDir . "\DriveProfiles"

    /**
     * @constructor
     */
    __New() {
        if !DirExist(this.profileDir)
            DirCreate(this.profileDir)
    }

    /**
     * @method CreateProfile
     * @description Creates a profile for a drive
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Profile object
     */
    CreateProfile(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        status := DriveGetStatus(driveLetter)

        profile := {
            Drive: driveLetter,
            Type: DriveGetType(driveLetter),
            Status: status,
            Timestamp: FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"),
            HostComputer: A_ComputerName,
            UserName: A_UserName
        }

        if (status = "Ready") {
            try {
                profile.FileSystem := DriveGetFileSystem(driveLetter)
                profile.Label := DriveGetLabel(driveLetter)
                profile.Serial := DriveGetSerial(driveLetter)
                profile.CapacityMB := DriveGetCapacity(driveLetter)
                profile.CapacityGB := Round(profile.CapacityMB / 1024, 2)

                ; Calculate file and folder counts
                counts := this.CountFilesAndFolders(driveLetter)
                profile.FileCount := counts.Files
                profile.FolderCount := counts.Folders

                ; Identify largest folders
                profile.LargestFolders := this.GetLargestFolders(driveLetter, 5)
            } catch as err {
                profile.Error := "Error reading drive details: " . err.Message
            }
        }

        return profile
    }

    /**
     * @method CountFilesAndFolders
     * @description Counts files and folders on a drive
     * @param {String} driveLetter - Drive letter
     * @returns {Object} Counts object
     */
    CountFilesAndFolders(driveLetter) {
        fileCount := 0
        folderCount := 0

        try {
            Loop Files, driveLetter . "\*.*", "R" {
                fileCount++
            }

            Loop Files, driveLetter . "\*.*", "DR" {
                folderCount++
            }
        }

        return { Files: fileCount, Folders: folderCount }
    }

    /**
     * @method GetLargestFolders
     * @description Gets the largest folders on a drive
     * @param {String} driveLetter - Drive letter
     * @param {Number} count - Number of folders to return
     * @returns {Array} Array of folder information
     */
    GetLargestFolders(driveLetter, count := 5) {
        folders := Map()

        try {
            Loop Files, driveLetter . "\*.*", "D" {
                if (A_LoopFileName != "System Volume Information" && A_LoopFileName != "$RECYCLE.BIN") {
                    size := this.GetFolderSize(A_LoopFilePath)
                    folders[A_LoopFilePath] := size
                }
            }
        }

        ; Sort and get top folders
        topFolders := []
        for path, size in folders {
            topFolders.Push({ Path: path, SizeMB: Round(size / 1048576, 2) })

            if (topFolders.Length >= count)
                break
        }

        return topFolders
    }

    /**
     * @method GetFolderSize
     * @description Gets the size of a folder
     * @param {String} folderPath - Folder path
     * @returns {Number} Size in bytes
     */
    GetFolderSize(folderPath) {
        totalSize := 0

        try {
            Loop Files, folderPath . "\*.*", "R" {
                totalSize += A_LoopFileSize
            }
        }

        return totalSize
    }

    /**
     * @method SaveProfile
     * @description Saves a drive profile to file
     * @param {Object} profile - Profile object
     * @returns {Boolean} Success status
     */
    SaveProfile(profile) {
        if !profile.HasOwnProp("Drive")
            return false

        fileName := this.profileDir . "\" . StrReplace(profile.Drive, ":", "") . "_profile.txt"

        content := "DRIVE PROFILE`n"
        content .= "═══════════════════════════════════════════════════════`n`n"

        for key, value in profile.OwnProps() {
            if (Type(value) != "Array" && Type(value) != "Map")
                content .= Format("{1}: {2}`n", key, value)
        }

        try {
            FileDelete(fileName)
            FileAppend(content, fileName)
            return true
        } catch {
            return false
        }
    }

    /**
     * @method ShowProfile
     * @description Shows a drive profile
     * @param {String} driveLetter - Drive letter
     */
    ShowProfile(driveLetter) {
        profile := this.CreateProfile(driveLetter)

        message := Format("Drive Profile - {1}`n", profile.Drive)
        message .= "═══════════════════════════════════════`n`n"
        message .= Format("Type: {1}`n", profile.Type)
        message .= Format("Status: {1}`n", profile.Status)

        if (profile.Status = "Ready") {
            message .= Format("File System: {1}`n", profile.FileSystem)
            message .= Format("Label: {1}`n", profile.Label)
            message .= Format("Serial: {1}`n", profile.Serial)
            message .= Format("Capacity: {1} GB`n", profile.CapacityGB)
            message .= Format("Files: {1}`n", profile.FileCount)
            message .= Format("Folders: {1}`n", profile.FolderCount)
        }

        message .= Format("`nCreated: {1}`n", profile.Timestamp)
        message .= Format("Computer: {1}`n", profile.HostComputer)

        MsgBox(message, "Drive Profile", "Iconi")

        this.SaveProfile(profile)
    }
}

; Example usage
Example1_DriveProfile() {
    profiler := DriveProfile()
    profiler.ShowProfile("C:")
    return profiler
}

; ===================================================================================================
; EXAMPLE 2: Drive Comparison Tool
; ===================================================================================================

/**
 * @class DriveComparison
 * @description Compares multiple drives across various metrics
 */
class DriveComparison {
    /**
     * @method CompareDrives
     * @description Compares two or more drives
     * @param {Array} driveLetters - Array of drive letters to compare
     * @returns {Object} Comparison results
     */
    static CompareDrives(driveLetters) {
        if (driveLetters.Length < 2)
            return { Error: "At least two drives required for comparison" }

        drives := []

        for driveLetter in driveLetters {
            if !InStr(driveLetter, ":")
                driveLetter .= ":"

            info := {
                Drive: driveLetter,
                Type: DriveGetType(driveLetter),
                Status: DriveGetStatus(driveLetter)
            }

            if (info.Status = "Ready") {
                try {
                    info.FileSystem := DriveGetFileSystem(driveLetter)
                    info.Label := DriveGetLabel(driveLetter)
                    info.Serial := DriveGetSerial(driveLetter)
                    info.CapacityMB := DriveGetCapacity(driveLetter)
                    info.FreeSpaceMB := DriveGetSpaceFree(driveLetter)
                    info.UsedSpaceMB := info.CapacityMB - info.FreeSpaceMB
                    info.UsagePercent := Round((info.UsedSpaceMB / info.CapacityMB) * 100, 2)
                } catch {
                    info.Error := true
                }
            }

            drives.Push(info)
        }

        return {
            Drives: drives,
            ComparisonDate: FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        }
    }

    /**
     * @method ShowComparison
     * @description Shows a comparison report
     * @param {Array} driveLetters - Drives to compare
     */
    static ShowComparison(driveLetters) {
        comparison := DriveComparison.CompareDrives(driveLetters)

        if comparison.HasOwnProp("Error") {
            MsgBox(comparison.Error, "Error", "Icon!")
            return
        }

        report := "Drive Comparison Report`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        ; Create comparison table
        report .= "Property        "
        for drive in comparison.Drives {
            report .= Format("| {1,-12} ", drive.Drive)
        }
        report .= "`n" . StrReplace(Format("{:0>80}", 0), "0", "─") . "`n"

        ; Type
        report .= "Type            "
        for drive in comparison.Drives {
            report .= Format("| {1,-12} ", drive.Type)
        }
        report .= "`n"

        ; Status
        report .= "Status          "
        for drive in comparison.Drives {
            report .= Format("| {1,-12} ", drive.Status)
        }
        report .= "`n"

        ; File System
        report .= "File System     "
        for drive in comparison.Drives {
            fs := drive.HasOwnProp("FileSystem") ? drive.FileSystem : "N/A"
            report .= Format("| {1,-12} ", fs)
        }
        report .= "`n"

        ; Capacity
        report .= "Capacity (GB)   "
        for drive in comparison.Drives {
            cap := drive.HasOwnProp("CapacityMB") ? Round(drive.CapacityMB / 1024, 1) : "N/A"
            report .= Format("| {1,-12} ", cap)
        }
        report .= "`n"

        ; Usage
        report .= "Usage (%)       "
        for drive in comparison.Drives {
            usage := drive.HasOwnProp("UsagePercent") ? drive.UsagePercent : "N/A"
            report .= Format("| {1,-12} ", usage)
        }
        report .= "`n"

        MsgBox(report, "Drive Comparison", "Iconi")
    }

    /**
     * @method FindSimilarDrives
     * @description Finds drives with similar characteristics
     * @param {String} referenceDrive - Reference drive
     * @param {String} criteria - Similarity criteria (Type, FileSystem, Size)
     * @returns {Array} Array of similar drives
     */
    static FindSimilarDrives(referenceDrive, criteria := "Type") {
        if !InStr(referenceDrive, ":")
            referenceDrive .= ":"

        refInfo := {
            Type: DriveGetType(referenceDrive),
            FileSystem: "",
            CapacityMB: 0
        }

        if (DriveGetStatus(referenceDrive) = "Ready") {
            try {
                refInfo.FileSystem := DriveGetFileSystem(referenceDrive)
                refInfo.CapacityMB := DriveGetCapacity(referenceDrive)
            }
        }

        similar := []
        allDrives := DriveGetList()

        for index, driveLetter in StrSplit(allDrives) {
            drive := driveLetter . ":"

            if (drive = referenceDrive)
                continue

            match := false

            if (criteria = "Type") {
                if (DriveGetType(drive) = refInfo.Type)
                    match := true
            } else if (criteria = "FileSystem") {
                if (DriveGetStatus(drive) = "Ready") {
                    try {
                        if (DriveGetFileSystem(drive) = refInfo.FileSystem)
                            match := true
                    }
                }
            } else if (criteria = "Size") {
                if (DriveGetStatus(drive) = "Ready") {
                    try {
                        capacity := DriveGetCapacity(drive)
                        ; Similar if within 10% of reference capacity
                        if (Abs(capacity - refInfo.CapacityMB) / refInfo.CapacityMB < 0.1)
                            match := true
                    }
                }
            }

            if (match)
                similar.Push(drive)
        }

        return similar
    }
}

; Example usage
Example2_DriveComparison() {
    ; Compare C: and D: drives
    DriveComparison.ShowComparison(["C:", "D:"])

    ; Find drives similar to C:
    similar := DriveComparison.FindSimilarDrives("C:", "Type")

    if (similar.Length > 0) {
        message := "Drives similar to C: (by type):`n`n"
        for drive in similar {
            message .= drive . "`n"
        }
        MsgBox(message, "Similar Drives", "Iconi")
    }
}

; ===================================================================================================
; EXAMPLE 3: Network Drive Mapper
; ===================================================================================================

/**
 * @class NetworkDriveMapper
 * @description Analyzes and manages network drive mappings
 */
class NetworkDriveMapper {
    /**
     * @method GetNetworkDrives
     * @description Gets all network drives
     * @returns {Array} Array of network drive information
     */
    static GetNetworkDrives() {
        networkDrives := []
        driveList := DriveGetList("Network")

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"

            info := {
                Drive: drive,
                Type: "Network",
                Status: DriveGetStatus(drive)
            }

            if (info.Status = "Ready") {
                try {
                    info.Label := DriveGetLabel(drive)
                    info.FileSystem := DriveGetFileSystem(drive)
                    info.CapacityGB := Round(DriveGetCapacity(drive) / 1024, 2)
                    info.FreeSpaceGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
                } catch {
                    info.Error := true
                }
            }

            networkDrives.Push(info)
        }

        return networkDrives
    }

    /**
     * @method ShowNetworkDriveReport
     * @description Shows a report of network drives
     */
    static ShowNetworkDriveReport() {
        netDrives := NetworkDriveMapper.GetNetworkDrives()

        if (netDrives.Length = 0) {
            MsgBox("No network drives found.", "Network Drives", "Iconi")
            return
        }

        report := "Network Drive Report`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for info in netDrives {
            report .= Format("Drive: {1}`n", info.Drive)
            report .= Format("  Status: {1}`n", info.Status)

            if (info.Status = "Ready" && !info.HasOwnProp("Error")) {
                report .= Format("  Label: {1}`n", info.Label)
                report .= Format("  File System: {1}`n", info.FileSystem)
                report .= Format("  Capacity: {1} GB`n", info.CapacityGB)
                report .= Format("  Free Space: {1} GB`n", info.FreeSpaceGB)
            }

            report .= "`n"
        }

        MsgBox(report, "Network Drives", "Iconi")
    }

    /**
     * @method AnalyzeNetworkPerformance
     * @description Analyzes network drive performance
     * @param {String} networkDrive - Network drive letter
     * @returns {Object} Performance metrics
     */
    static AnalyzeNetworkPerformance(networkDrive) {
        if !InStr(networkDrive, ":")
            networkDrive .= ":"

        if (DriveGetType(networkDrive) != "Network") {
            return { Error: "Not a network drive" }
        }

        ; Test read speed
        testFile := networkDrive . "\speed_test.tmp"
        testData := StrReplace(Format("{:0>1048576}", 0), "0", "A")  ; 1MB of data

        startTime := A_TickCount

        try {
            FileAppend(testData, testFile)
            writeTime := A_TickCount - startTime

            startTime := A_TickCount
            FileRead(testFile)
            readTime := A_TickCount - startTime

            FileDelete(testFile)

            return {
                WriteTimeMs: writeTime,
                ReadTimeMs: readTime,
                WriteMBps: Round(1000 / writeTime, 2),
                ReadMBps: Round(1000 / readTime, 2)
            }
        } catch as err {
            return { Error: "Performance test failed: " . err.Message }
        }
    }
}

; Example usage
Example3_NetworkDriveMapper() {
    NetworkDriveMapper.ShowNetworkDriveReport()
}

; ===================================================================================================
; EXAMPLE 4: Drive Audit System
; ===================================================================================================

/**
 * @class DriveAuditor
 * @description Performs compliance and security audits on drives
 */
class DriveAuditor {
    /**
     * @method AuditDrive
     * @description Performs a comprehensive audit of a drive
     * @param {String} driveLetter - Drive to audit
     * @returns {Object} Audit results
     */
    static AuditDrive(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        audit := {
            Drive: driveLetter,
            AuditDate: FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"),
            Findings: [],
            Score: 100
        }

        ; Check if drive exists
        driveType := DriveGetType(driveLetter)
        if (driveType = "Unknown" || driveType = "") {
            audit.Findings.Push("CRITICAL: Drive does not exist")
            audit.Score -= 100
            return audit
        }

        audit.Type := driveType

        ; Check if drive is ready
        status := DriveGetStatus(driveLetter)
        audit.Status := status

        if (status != "Ready") {
            audit.Findings.Push("WARNING: Drive is not ready")
            audit.Score -= 50
            return audit
        }

        ; Check file system
        try {
            fileSystem := DriveGetFileSystem(driveLetter)
            audit.FileSystem := fileSystem

            if (driveType = "Fixed" && fileSystem != "NTFS" && fileSystem != "ReFS") {
                audit.Findings.Push("NOTICE: Fixed drive not using NTFS/ReFS file system")
                audit.Score -= 10
            }
        }

        ; Check label
        try {
            label := DriveGetLabel(driveLetter)
            audit.Label := label

            if (label = "" && driveType = "Fixed") {
                audit.Findings.Push("NOTICE: Fixed drive has no label")
                audit.Score -= 5
            }
        }

        ; Check space
        try {
            capacity := DriveGetCapacity(driveLetter)
            freeSpace := DriveGetSpaceFree(driveLetter)
            usagePercent := ((capacity - freeSpace) / capacity) * 100

            audit.UsagePercent := Round(usagePercent, 2)

            if (usagePercent > 90) {
                audit.Findings.Push("WARNING: Drive is over 90% full")
                audit.Score -= 20
            } else if (usagePercent > 80) {
                audit.Findings.Push("CAUTION: Drive is over 80% full")
                audit.Score -= 10
            }
        }

        ; Final assessment
        if (audit.Findings.Length = 0) {
            audit.Findings.Push("PASSED: No issues found")
        }

        return audit
    }

    /**
     * @method AuditAllDrives
     * @description Audits all fixed drives
     * @returns {Array} Array of audit results
     */
    static AuditAllDrives() {
        audits := []
        driveList := DriveGetList("Fixed")

        for index, driveLetter in StrSplit(driveList) {
            audit := DriveAuditor.AuditDrive(driveLetter . ":")
            audits.Push(audit)
        }

        return audits
    }

    /**
     * @method ShowAuditReport
     * @description Shows an audit report
     */
    static ShowAuditReport() {
        audits := DriveAuditor.AuditAllDrives()

        report := "DRIVE AUDIT REPORT`n"
        report .= "═══════════════════════════════════════════════════════`n"
        report .= Format("Audit Date: {1}`n`n", FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))

        for audit in audits {
            report .= Format("Drive: {1} - Score: {2}/100`n", audit.Drive, audit.Score)
            report .= Format("Type: {1} | Status: {2}`n", audit.Type, audit.Status)

            if audit.HasOwnProp("FileSystem")
                report .= Format("File System: {1} | Label: {2}`n", audit.FileSystem, audit.Label)

            report .= "Findings:`n"
            for finding in audit.Findings {
                report .= "  • " . finding . "`n"
            }

            report .= "`n"
        }

        MsgBox(report, "Drive Audit", "Iconi")
    }

    /**
     * @method ExportAudit
     * @description Exports audit to file
     * @param {String} outputPath - Output file path
     * @returns {Boolean} Success status
     */
    static ExportAudit(outputPath) {
        audits := DriveAuditor.AuditAllDrives()

        content := "DRIVE AUDIT REPORT`n"
        content .= "═══════════════════════════════════════════════════════`n"
        content .= Format("Audit Date: {1}`n", FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        content .= Format("Computer: {1}`n", A_ComputerName)
        content .= Format("User: {1}`n`n", A_UserName)

        for audit in audits {
            content .= Format("Drive: {1}`n", audit.Drive)
            content .= Format("  Audit Score: {1}/100`n", audit.Score)
            content .= Format("  Type: {1}`n", audit.Type)
            content .= Format("  Status: {1}`n", audit.Status)

            if audit.HasOwnProp("FileSystem") {
                content .= Format("  File System: {1}`n", audit.FileSystem)
                content .= Format("  Label: {1}`n", audit.Label)
                content .= Format("  Usage: {1}%`n", audit.UsagePercent)
            }

            content .= "  Findings:`n"
            for finding in audit.Findings {
                content .= "    • " . finding . "`n"
            }

            content .= "`n"
        }

        try {
            FileAppend(content, outputPath)
            return true
        } catch {
            return false
        }
    }
}

; Example usage
Example4_DriveAudit() {
    DriveAuditor.ShowAuditReport()

    ; Export audit
    timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")
    DriveAuditor.ExportAudit(A_Desktop . "\DriveAudit_" . timestamp . ".txt")

    MsgBox("Audit report exported to desktop.", "Export Complete", "Iconi")
}

; ===================================================================================================
; EXAMPLE 5: Drive Organization System
; ===================================================================================================

/**
 * @class DriveOrganizer
 * @description Organizes and categorizes drives
 */
class DriveOrganizer {
    /**
     * @method CategorizeByPurpose
     * @description Categorizes drives by their likely purpose
     * @returns {Map} Map of categories to drive arrays
     */
    static CategorizeByPurpose() {
        categories := Map()
        categories["System"] := []
        categories["Data"] := []
        categories["Backup"] := []
        categories["Media"] := []
        categories["Portable"] := []
        categories["Network"] := []
        categories["Other"] := []

        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            driveType := DriveGetType(drive)
            status := DriveGetStatus(drive)

            info := { Drive: drive, Type: driveType }

            if (status = "Ready") {
                try {
                    info.Label := DriveGetLabel(drive)
                } catch {
                    info.Label := ""
                }
            } else {
                info.Label := ""
            }

            ; Categorize based on type and label
            category := "Other"

            if (drive = "C:") {
                category := "System"
            } else if (driveType = "Network") {
                category := "Network"
            } else if (driveType = "Removable") {
                category := "Portable"
            } else if (InStr(info.Label, "Backup") || InStr(info.Label, "BACKUP")) {
                category := "Backup"
            } else if (InStr(info.Label, "Media") || InStr(info.Label, "MEDIA")) {
                category := "Media"
            } else if (driveType = "Fixed") {
                category := "Data"
            }

            categories[category].Push(info)
        }

        return categories
    }

    /**
     * @method ShowOrganizedView
     * @description Shows drives organized by purpose
     */
    static ShowOrganizedView() {
        categories := DriveOrganizer.CategorizeByPurpose()

        report := "Organized Drive View`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for category, drives in categories {
            if (drives.Length = 0)
                continue

            report .= Format("▶ {1} ({2} drives):`n", category, drives.Length)

            for info in drives {
                label := info.Label != "" ? info.Label : "(No Label)"
                report .= Format("  {1} [{2}] - {3}`n", info.Drive, info.Type, label)
            }

            report .= "`n"
        }

        MsgBox(report, "Organized Drives", "Iconi")
    }
}

; Example usage
Example5_DriveOrganization() {
    DriveOrganizer.ShowOrganizedView()
}

; ===================================================================================================
; EXAMPLE 6: Drive Documentation Generator
; ===================================================================================================

/**
 * @function GenerateDriveDocumentation
 * @description Generates comprehensive documentation for all drives
 * @param {String} outputPath - Path to save documentation
 * @returns {Boolean} Success status
 */
GenerateDriveDocumentation(outputPath) {
    content := "═══════════════════════════════════════════════════════`n"
    content .= "              SYSTEM DRIVE DOCUMENTATION`n"
    content .= "═══════════════════════════════════════════════════════`n`n"

    content .= "Generated: " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n"
    content .= "Computer: " . A_ComputerName . "`n"
    content .= "Operating System: " . A_OSVersion . "`n`n"

    content .= "═══════════════════════════════════════════════════════`n"
    content .= "DRIVE INVENTORY`n"
    content .= "═══════════════════════════════════════════════════════`n`n"

    driveList := DriveGetList()

    for index, driveLetter in StrSplit(driveList) {
        drive := driveLetter . ":"

        content .= Format("DRIVE {1}`n", drive)
        content .= StrReplace(Format("{:-<50}", ""), " ", "") . "`n"

        driveType := DriveGetType(drive)
        content .= Format("Type: {1}`n", driveType)

        status := DriveGetStatus(drive)
        content .= Format("Status: {1}`n", status)

        if (status = "Ready") {
            try {
                content .= Format("File System: {1}`n", DriveGetFileSystem(drive))
                content .= Format("Volume Label: {1}`n", DriveGetLabel(drive))
                content .= Format("Serial Number: {1}`n", DriveGetSerial(drive))

                capacity := DriveGetCapacity(drive)
                freeSpace := DriveGetSpaceFree(drive)

                content .= Format("Total Capacity: {1} GB ({2} MB)`n",
                    Round(capacity / 1024, 2), capacity)
                content .= Format("Free Space: {1} GB ({2} MB)`n",
                    Round(freeSpace / 1024, 2), freeSpace)
                content .= Format("Used Space: {1} GB ({2}%)`n",
                    Round((capacity - freeSpace) / 1024, 2),
                    Round(((capacity - freeSpace) / capacity) * 100, 2))
            } catch as err {
                content .= "Error reading drive details: " . err.Message . "`n"
            }
        }

        content .= "`n"
    }

    try {
        FileDelete(outputPath)
        FileAppend(content, outputPath)
        return true
    } catch {
        return false
    }
}

; Example usage
Example6_Documentation() {
    outputPath := A_Desktop . "\SystemDriveDocumentation.txt"

    if GenerateDriveDocumentation(outputPath) {
        MsgBox("Drive documentation generated successfully!`n`nSaved to: " . outputPath,
            "Documentation Complete", "Iconi")
        Run(outputPath)
    } else {
        MsgBox("Failed to generate documentation.", "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 7: Removable Drive History Tracker
; ===================================================================================================

/**
 * @class RemovableDriveHistory
 * @description Tracks history of removable drives connected to the system
 */
class RemovableDriveHistory {
    historyFile := A_ScriptDir . "\removable_drive_history.csv"

    /**
     * @method RecordDrive
     * @description Records a removable drive connection
     * @param {String} driveLetter - Drive letter
     */
    RecordDrive(driveLetter) {
        if !InStr(driveLetter, ":")
            driveLetter .= ":"

        if (DriveGetType(driveLetter) != "Removable")
            return

        if (DriveGetStatus(driveLetter) != "Ready")
            return

        try {
            label := DriveGetLabel(driveLetter)
            serial := DriveGetSerial(driveLetter)
            fileSystem := DriveGetFileSystem(driveLetter)
            capacity := Round(DriveGetCapacity(driveLetter) / 1024, 2)

            timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

            record := Format("{1},{2},{3},{4},{5},{6},{7}`n",
                timestamp, driveLetter, label, serial, fileSystem, capacity, A_ComputerName)

            ; Create file with header if it doesn't exist
            if !FileExist(this.historyFile) {
                FileAppend("Timestamp,Drive,Label,Serial,FileSystem,CapacityGB,Computer`n",
                    this.historyFile)
            }

            FileAppend(record, this.historyFile)
        }
    }

    /**
     * @method GetHistory
     * @description Gets the history of removable drives
     * @returns {Array} Array of history records
     */
    GetHistory() {
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
            if (fields.Length >= 7) {
                history.Push({
                    Timestamp: fields[1],
                    Drive: fields[2],
                    Label: fields[3],
                    Serial: fields[4],
                    FileSystem: fields[5],
                    CapacityGB: fields[6],
                    Computer: fields[7]
                })
            }
        }

        return history
    }

    /**
     * @method ShowHistory
     * @description Shows the removable drive history
     */
    ShowHistory() {
        history := this.GetHistory()

        if (history.Length = 0) {
            MsgBox("No removable drive history found.", "History", "Iconi")
            return
        }

        report := "Removable Drive Connection History`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        ; Show last 10 records
        startIndex := Max(1, history.Length - 9)

        for i, record in history {
            if (i >= startIndex) {
                report .= Format("[{1}] {2}`n", record.Timestamp, record.Drive)
                report .= Format("  Label: {1} | Serial: {2}`n",
                    record.Label, record.Serial)
                report .= Format("  {1} | {2} GB`n`n",
                    record.FileSystem, record.CapacityGB)
            }
        }

        report .= Format("Total Records: {1}", history.Length)

        MsgBox(report, "Removable Drive History", "Iconi")
    }
}

; Example usage
Example7_RemovableHistory() {
    tracker := RemovableDriveHistory()

    ; Record current removable drives
    removables := DriveGetList("Removable")
    for index, driveLetter in StrSplit(removables) {
        tracker.RecordDrive(driveLetter . ":")
    }

    ; Show history
    tracker.ShowHistory()

    return tracker
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+P to show drive profile
; ^!p::Example1_DriveProfile()

; Press Ctrl+Alt+C to compare drives
; ^!c::Example2_DriveComparison()

; Press Ctrl+Alt+N to show network drives
; ^!n::Example3_NetworkDriveMapper()

; Press Ctrl+Alt+A to show drive audit
; ^!a::Example4_DriveAudit()

; Press Ctrl+Alt+O to show organized view
; ^!o::Example5_DriveOrganization()

; Press Ctrl+Alt+D to generate documentation
; ^!d::Example6_Documentation()

