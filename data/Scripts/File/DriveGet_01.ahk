#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * @file DriveGet_01.ahk
 * @description Comprehensive examples of DriveGetCapacity, DriveGetSpaceFree, and DriveGetStatus functions in AutoHotkey v2
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Getting drive capacity and space information
 * - Monitoring disk space usage
 * - Checking drive status and readiness
 * - Calculating disk usage percentages
 * - Building disk space monitoring tools
 * - Creating low disk space alerts
 * - Generating disk space reports
 */


; ===================================================================================================
; EXAMPLE 1: Basic Drive Capacity and Free Space Information
; ===================================================================================================

/**
 * @function GetDriveInfo
 * @description Gets comprehensive drive capacity and free space information
 * @param {String} DriveLetter - The drive letter to query (e.g., "C:")
 * @returns {Object} Object containing capacity, free space, used space, and usage percentage
 * 
 * @example
 * info := GetDriveInfo("C:")
 * MsgBox("Drive C: has " . info.FreeGB . " GB free")
 */
GetDriveInfo(DriveLetter) {
    ; Ensure drive letter has colon
    if !InStr(DriveLetter, ":")
        DriveLetter .= ":"

    ; Get capacity in megabytes
    capacity := DriveGetCapacity(DriveLetter)

    ; Get free space in megabytes
    freeSpace := DriveGetSpaceFree(DriveLetter)

    ; Calculate used space
    usedSpace := capacity - freeSpace

    ; Calculate usage percentage
    usagePercent := (usedSpace / capacity) * 100

    ; Return comprehensive information
    return {
        Drive: DriveLetter,
        CapacityMB: capacity,
        CapacityGB: Round(capacity / 1024, 2),
        FreeSpaceMB: freeSpace,
        FreeSpaceGB: Round(freeSpace / 1024, 2),
        UsedSpaceMB: usedSpace,
        UsedSpaceGB: Round(usedSpace / 1024, 2),
        UsagePercent: Round(usagePercent, 2),
        FreePercent: Round(100 - usagePercent, 2)
    }
}

; Example usage
Example1_BasicDriveInfo() {
    ; Get information for C: drive
    info := GetDriveInfo("C:")

    ; Display formatted information
    report := Format("
    (
    Drive Information for {1}
    ═══════════════════════════════════════

    Total Capacity: {2} GB ({3} MB)
    Used Space:     {4} GB ({5} MB)
    Free Space:     {6} GB ({7} MB)

    Usage:          {8}%
    Free:           {9}%
    )",
        info.Drive,
        info.CapacityGB, info.CapacityMB,
        info.UsedSpaceGB, info.UsedSpaceMB,
        info.FreeSpaceGB, info.FreeSpaceMB,
        info.UsagePercent,
        info.FreePercent
    )

    MsgBox(report, "Drive Information", "Icon!")

    return info
}

; ===================================================================================================
; EXAMPLE 2: Multi-Drive Space Monitoring
; ===================================================================================================

/**
 * @function GetAllDrivesInfo
 * @description Gets space information for all available drives
 * @returns {Array} Array of drive information objects
 * 
 * @example
 * drives := GetAllDrivesInfo()
 * for drive in drives
 *     MsgBox(drive.Drive . " has " . drive.FreeGB . " GB free")
 */
GetAllDrivesInfo() {
    drives := []

    ; Get list of all drives
    driveList := DriveGetList()

    ; Loop through each drive
    for index, driveLetter in StrSplit(driveList) {
        drive := driveLetter . ":"

        ; Check if drive is ready
        status := DriveGetStatus(drive)

        if (status = "Ready") {
            try {
                info := GetDriveInfo(drive)
                drives.Push(info)
            } catch as err {
                ; Skip drives that can't be accessed
                continue
            }
        }
    }

    return drives
}

/**
 * @function ShowAllDrivesReport
 * @description Displays a comprehensive report of all drives
 * 
 * @example
 * ShowAllDrivesReport()
 */
ShowAllDrivesReport() {
    drives := GetAllDrivesInfo()

    if (drives.Length = 0) {
        MsgBox("No accessible drives found.", "Drive Report", "Icon!")
        return
    }

    ; Build report header
    report := "All Drives Space Report`n"
    report .= "═══════════════════════════════════════════════════════`n`n"

    ; Add each drive's information
    for drive in drives {
        report .= Format("Drive {1}:`n", drive.Drive)
        report .= Format("  Total: {1} GB | Used: {2} GB ({3}%) | Free: {4} GB ({5}%)`n`n",
            drive.CapacityGB,
            drive.UsedSpaceGB,
            drive.UsagePercent,
            drive.FreeSpaceGB,
            drive.FreePercent
        )
    }

    MsgBox(report, "All Drives Report", "Icon!")
}

; ===================================================================================================
; EXAMPLE 3: Low Disk Space Alert System
; ===================================================================================================

/**
 * @class DiskSpaceMonitor
 * @description Monitors disk space and alerts when space is low
 */
class DiskSpaceMonitor {
    /**
     * @property {Number} threshold - Percentage threshold for low space warning (default: 10%)
     * @property {Number} checkInterval - Time between checks in milliseconds (default: 300000 = 5 minutes)
     * @property {Array} drivesToMonitor - Array of drive letters to monitor
     * @property {Boolean} isMonitoring - Whether monitoring is active
     */
    threshold := 10
    checkInterval := 300000
    drivesToMonitor := []
    isMonitoring := false

    /**
     * @constructor
     * @param {Array} drives - Array of drive letters to monitor (optional)
     * @param {Number} threshold - Free space percentage threshold (optional)
     */
    __New(drives := [], threshold := 10) {
        this.threshold := threshold
        this.drivesToMonitor := drives.Length > 0 ? drives : this.GetSystemDrives()
    }

    /**
     * @method GetSystemDrives
     * @description Gets all ready fixed drives on the system
     * @returns {Array} Array of drive letters
     */
    GetSystemDrives() {
        systemDrives := []
        driveList := DriveGetList("FIXED")

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            if (DriveGetStatus(drive) = "Ready")
                systemDrives.Push(drive)
        }

        return systemDrives
    }

    /**
     * @method StartMonitoring
     * @description Starts the disk space monitoring
     */
    StartMonitoring() {
        if (this.isMonitoring)
            return

        this.isMonitoring := true
        this.CheckDiskSpace()
        SetTimer(() => this.CheckDiskSpace(), this.checkInterval)

        MsgBox("Disk space monitoring started.`nThreshold: " . this.threshold . "% free space",
            "Monitor Started", "Icon!")
    }

    /**
     * @method StopMonitoring
     * @description Stops the disk space monitoring
     */
    StopMonitoring() {
        if (!this.isMonitoring)
            return

        this.isMonitoring := false
        SetTimer(() => this.CheckDiskSpace(), 0)

        MsgBox("Disk space monitoring stopped.", "Monitor Stopped", "Iconx")
    }

    /**
     * @method CheckDiskSpace
     * @description Checks disk space for all monitored drives
     */
    CheckDiskSpace() {
        lowSpaceDrives := []

        for drive in this.drivesToMonitor {
            try {
                info := GetDriveInfo(drive)

                if (info.FreePercent < this.threshold) {
                    lowSpaceDrives.Push({
                        Drive: drive,
                        FreePercent: info.FreePercent,
                        FreeGB: info.FreeSpaceGB
                    })
                }
            } catch as err {
                ; Skip inaccessible drives
                continue
            }
        }

        if (lowSpaceDrives.Length > 0) {
            this.ShowLowSpaceAlert(lowSpaceDrives)
        }
    }

    /**
     * @method ShowLowSpaceAlert
     * @description Shows alert for low disk space
     * @param {Array} drives - Array of drives with low space
     */
    ShowLowSpaceAlert(drives) {
        message := "⚠️ LOW DISK SPACE WARNING ⚠️`n`n"
        message .= "The following drives are running low on space:`n`n"

        for driveInfo in drives {
            message .= Format("Drive {1}: Only {2}% ({3} GB) free`n",
                driveInfo.Drive,
                Round(driveInfo.FreePercent, 1),
                driveInfo.FreeGB
            )
        }

        message .= "`nPlease free up some disk space."

        MsgBox(message, "Low Disk Space Alert", "Icon! 48")
    }
}

; Example usage
Example3_DiskSpaceMonitor() {
    ; Create monitor for drives with less than 15% free space
    monitor := DiskSpaceMonitor(["C:", "D:"], 15)
    monitor.StartMonitoring()

    ; In a real application, the monitor would run continuously
    ; For this example, we'll just check once
    Sleep(1000)

    return monitor
}

; ===================================================================================================
; EXAMPLE 4: Drive Status Checking and Validation
; ===================================================================================================

/**
 * @function CheckDriveStatus
 * @description Checks and reports the status of a drive
 * @param {String} DriveLetter - The drive letter to check
 * @returns {Object} Object containing status information
 * 
 * Status values:
 * - "Ready": Drive is ready for use
 * - "NotReady": Drive exists but is not ready (e.g., no media)
 * - "" (empty): Drive does not exist
 */
CheckDriveStatus(DriveLetter) {
    if !InStr(DriveLetter, ":")
        DriveLetter .= ":"

    status := DriveGetStatus(DriveLetter)

    statusInfo := {
        Drive: DriveLetter,
        Status: status,
        IsReady: (status = "Ready"),
        Exists: (status != ""),
        Message: ""
    }

    ; Generate human-readable message
    if (status = "Ready") {
        statusInfo.Message := "Drive is ready and accessible"
    } else if (status = "NotReady") {
        statusInfo.Message := "Drive exists but is not ready (possibly empty or disconnected)"
    } else {
        statusInfo.Message := "Drive does not exist"
    }

    return statusInfo
}

/**
 * @function WaitForDriveReady
 * @description Waits for a drive to become ready
 * @param {String} DriveLetter - The drive letter to wait for
 * @param {Number} timeout - Maximum time to wait in milliseconds (default: 30000)
 * @returns {Boolean} True if drive became ready, false if timeout
 */
WaitForDriveReady(DriveLetter, timeout := 30000) {
    if !InStr(DriveLetter, ":")
        DriveLetter .= ":"

    startTime := A_TickCount

    while ((A_TickCount - startTime) < timeout) {
        if (DriveGetStatus(DriveLetter) = "Ready")
            return true

        Sleep(500)
    }

    return false
}

; Example usage
Example4_DriveStatusCheck() {
    ; Check multiple drives
    drives := ["C:", "D:", "E:", "Z:"]

    report := "Drive Status Report`n"
    report .= "═══════════════════════════════════════════════`n`n"

    for drive in drives {
        statusInfo := CheckDriveStatus(drive)
        report .= Format("Drive {1}: {2}`n  {3}`n`n",
            statusInfo.Drive,
            statusInfo.Status,
            statusInfo.Message
        )
    }

    MsgBox(report, "Drive Status", "Icon!")
}

; ===================================================================================================
; EXAMPLE 5: Disk Usage Visualization and Statistics
; ===================================================================================================

/**
 * @function CreateDiskUsageBar
 * @description Creates a text-based progress bar for disk usage
 * @param {Number} usagePercent - The usage percentage (0-100)
 * @param {Number} barLength - Length of the bar in characters (default: 50)
 * @returns {String} ASCII progress bar
 */
CreateDiskUsageBar(usagePercent, barLength := 50) {
    filledLength := Round((usagePercent / 100) * barLength)
    emptyLength := barLength - filledLength

    bar := "["
    bar .= StrReplace(Format("{:0" . filledLength . "}", 0), "0", "█")
    bar .= StrReplace(Format("{:0" . emptyLength . "}", 0), "0", "░")
    bar .= "]"

    return bar
}

/**
 * @function ShowDiskUsageVisualization
 * @description Shows a visual representation of disk usage
 * @param {String} DriveLetter - The drive to visualize
 */
ShowDiskUsageVisualization(DriveLetter) {
    if !InStr(DriveLetter, ":")
        DriveLetter .= ":"

    ; Check if drive is ready
    if (DriveGetStatus(DriveLetter) != "Ready") {
        MsgBox("Drive " . DriveLetter . " is not ready.", "Error", "Icon!")
        return
    }

    info := GetDriveInfo(DriveLetter)

    ; Create usage bar
    usageBar := CreateDiskUsageBar(info.UsagePercent)

    ; Build visualization
    visualization := Format("
    (
    ╔══════════════════════════════════════════════════════════╗
    ║  DISK USAGE VISUALIZATION - Drive {1}                 ║
    ╠══════════════════════════════════════════════════════════╣
    ║                                                          ║
    ║  Total Capacity: {2} GB                               ║
    ║                                                          ║
    ║  {3}                                                     ║
    ║                                                          ║
    ║  Used:  {4} GB ({5}%)                                   ║
    ║  Free:  {6} GB ({7}%)                                   ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
    )",
        info.Drive,
        info.CapacityGB,
        usageBar,
        info.UsedSpaceGB, info.UsagePercent,
        info.FreeSpaceGB, info.FreePercent
    )

    MsgBox(visualization, "Disk Usage", "Icon!")
}

; Example usage
Example5_DiskVisualization() {
    ShowDiskUsageVisualization("C:")
}

; ===================================================================================================
; EXAMPLE 6: Disk Space Comparison and Analysis
; ===================================================================================================

/**
 * @function CompareDriveSpace
 * @description Compares space usage between multiple drives
 * @param {Array} drives - Array of drive letters to compare
 * @returns {Object} Comparison statistics
 */
CompareDriveSpace(drives) {
    driveInfos := []
    totalCapacity := 0
    totalUsed := 0
    totalFree := 0

    ; Collect information for each drive
    for drive in drives {
        if !InStr(drive, ":")
            drive .= ":"

        if (DriveGetStatus(drive) = "Ready") {
            try {
                info := GetDriveInfo(drive)
                driveInfos.Push(info)
                totalCapacity += info.CapacityMB
                totalUsed += info.UsedSpaceMB
                totalFree += info.FreeSpaceMB
            }
        }
    }

    ; Calculate aggregate statistics
    return {
        Drives: driveInfos,
        TotalCapacityGB: Round(totalCapacity / 1024, 2),
        TotalUsedGB: Round(totalUsed / 1024, 2),
        TotalFreeGB: Round(totalFree / 1024, 2),
        AverageUsagePercent: driveInfos.Length > 0 ? Round(totalUsed / totalCapacity * 100, 2) : 0,
        DriveCount: driveInfos.Length
    }
}

/**
 * @function ShowDriveComparison
 * @description Displays a comparison report of multiple drives
 */
ShowDriveComparison() {
    ; Compare all fixed drives
    allDrives := StrSplit(DriveGetList("FIXED"))

    comparison := CompareDriveSpace(allDrives)

    report := "Drive Space Comparison Report`n"
    report .= "═══════════════════════════════════════════════════════`n`n"

    ; Individual drive details
    for info in comparison.Drives {
        report .= Format("{1}: {2} GB total, {3} GB used ({4}%), {5} GB free`n",
            info.Drive,
            info.CapacityGB,
            info.UsedSpaceGB,
            info.UsagePercent,
            info.FreeSpaceGB
        )
    }

    ; Aggregate statistics
    report .= "`n═══════════════════════════════════════════════════════`n"
    report .= "TOTAL STATISTICS:`n"
    report .= Format("Total Capacity: {1} GB`n", comparison.TotalCapacityGB)
    report .= Format("Total Used: {1} GB`n", comparison.TotalUsedGB)
    report .= Format("Total Free: {2} GB`n", comparison.TotalFreeGB)
    report .= Format("Average Usage: {3}%`n", comparison.AverageUsagePercent)
    report .= Format("Drives Analyzed: {4}", comparison.DriveCount)

    MsgBox(report, "Drive Comparison", "Icon!")
}

; ===================================================================================================
; EXAMPLE 7: Disk Space Export and Logging
; ===================================================================================================

/**
 * @function ExportDiskSpaceReport
 * @description Exports disk space information to a file
 * @param {String} outputPath - Path to save the report
 * @param {String} format - Format of the report ("TXT", "CSV", or "JSON")
 * @returns {Boolean} True if successful, false otherwise
 */
ExportDiskSpaceReport(outputPath, format := "TXT") {
    drives := GetAllDrivesInfo()

    if (drives.Length = 0)
        return false

    content := ""

    if (format = "CSV") {
        ; CSV format
        content .= "Drive,CapacityGB,UsedGB,FreeGB,UsagePercent,FreePercent`n"
        for info in drives {
            content .= Format("{1},{2},{3},{4},{5},{6}`n",
                info.Drive,
                info.CapacityGB,
                info.UsedSpaceGB,
                info.FreeSpaceGB,
                info.UsagePercent,
                info.FreePercent
            )
        }
    } else if (format = "JSON") {
        ; JSON format (simplified)
        content .= "{ `"drives`": [`n"
        for index, info in drives {
            content .= "  {`n"
            content .= '    "drive": "' . info.Drive . '",`n'
            content .= '    "capacityGB": ' . info.CapacityGB . ',`n'
            content .= '    "usedGB": ' . info.UsedSpaceGB . ',`n'
            content .= '    "freeGB": ' . info.FreeSpaceGB . ',`n'
            content .= '    "usagePercent": ' . info.UsagePercent . ',`n'
            content .= '    "freePercent": ' . info.FreePercent . '`n'
            content .= "  }" . (index < drives.Length ? "," : "") . "`n"
        }
        content .= "] }"
    } else {
        ; TXT format
        content .= "Disk Space Report - " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n"
        content .= "═══════════════════════════════════════════════════════`n`n"

        for info in drives {
            content .= Format("Drive {1}:`n", info.Drive)
            content .= Format("  Capacity: {1} GB`n", info.CapacityGB)
            content .= Format("  Used:     {1} GB ({2}%)`n", info.UsedSpaceGB, info.UsagePercent)
            content .= Format("  Free:     {1} GB ({2}%)`n`n", info.FreeSpaceGB, info.FreePercent)
        }
    }

    try {
        FileAppend(content, outputPath)
        return true
    } catch as err {
        return false
    }
}

; Example usage
Example7_ExportReport() {
    ; Export to multiple formats
    timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")

    ExportDiskSpaceReport(A_Desktop . "\DiskReport_" . timestamp . ".txt", "TXT")
    ExportDiskSpaceReport(A_Desktop . "\DiskReport_" . timestamp . ".csv", "CSV")
    ExportDiskSpaceReport(A_Desktop . "\DiskReport_" . timestamp . ".json", "JSON")

    MsgBox("Disk space reports exported to desktop in TXT, CSV, and JSON formats.",
        "Export Complete", "Icon!")
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+D to show drive information
; ^!d::Example1_BasicDriveInfo()

; Press Ctrl+Alt+A to show all drives report
; ^!a::ShowAllDrivesReport()

; Press Ctrl+Alt+V to visualize disk usage
; ^!v::ShowDiskUsageVisualization("C:")

; Press Ctrl+Alt+E to export disk report
; ^!e::Example7_ExportReport()

