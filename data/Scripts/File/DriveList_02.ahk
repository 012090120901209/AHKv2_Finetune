/**
 * @file DriveList_02.ahk
 * @description Advanced drive listing with custom filtering, analytics, and system integration
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Advanced drive filtering and search
 * - Drive analytics and statistics
 * - Custom drive organization schemes
 * - Drive health monitoring
 * - System integration utilities
 * - Multi-criteria drive selection
 * - Automated drive discovery
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Advanced Drive Search and Filtering
; ===================================================================================================

/**
 * @class AdvancedDriveSearch
 * @description Advanced drive search with multiple criteria
 */
class AdvancedDriveSearch {
    static FindDrives(criteria) {
        allDrives := DriveGetList()
        matches := []

        for index, letter in StrSplit(allDrives) {
            drive := letter . ":"

            if (AdvancedDriveSearch.MatchesCriteria(drive, criteria))
                matches.Push(drive)
        }

        return matches
    }

    static MatchesCriteria(drive, criteria) {
        ; Check type filter
        if criteria.HasOwnProp("Type") {
            if (DriveGetType(drive) != criteria.Type)
                return false
        }

        ; Check status filter
        if criteria.HasOwnProp("Status") {
            if (DriveGetStatus(drive) != criteria.Status)
                return false
        }

        ; Check minimum free space
        if criteria.HasOwnProp("MinFreeGB") {
            if (DriveGetStatus(drive) = "Ready") {
                try {
                    freeGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
                    if (freeGB < criteria.MinFreeGB)
                        return false
                } catch {
                    return false
                }
            } else {
                return false
            }
        }

        ; Check file system
        if criteria.HasOwnProp("FileSystem") {
            if (DriveGetStatus(drive) = "Ready") {
                try {
                    if (DriveGetFileSystem(drive) != criteria.FileSystem)
                        return false
                } catch {
                    return false
                }
            } else {
                return false
            }
        }

        ; Check label pattern
        if criteria.HasOwnProp("LabelPattern") {
            if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := DriveGetLabel(drive)
                    if !InStr(label, criteria.LabelPattern)
                        return false
                } catch {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
}

Example1_AdvancedSearch() {
    ; Search for NTFS drives with at least 10GB free
    criteria := {
        FileSystem: "NTFS",
        MinFreeGB: 10,
        Status: "Ready"
    }

    matches := AdvancedDriveSearch.FindDrives(criteria)

    report := "Advanced Drive Search Results`n"
    report .= "═══════════════════════════════════════`n`n"
    report .= "Search Criteria:`n"
    report .= "  File System: NTFS`n"
    report .= "  Minimum Free Space: 10 GB`n"
    report .= "  Status: Ready`n`n"

    if (matches.Length > 0) {
        report .= Format("Found {1} matching drive(s):`n`n", matches.Length)

        for drive in matches {
            freeGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
            label := DriveGetLabel(drive)
            report .= Format("{1} - {2} ({3} GB free)`n",
                drive,
                label != "" ? label : "(No Label)",
                freeGB)
        }
    } else {
        report .= "No matching drives found."
    }

    MsgBox(report, "Search Results", "Iconi")
}

; ===================================================================================================
; EXAMPLE 2: Drive Analytics Dashboard
; ===================================================================================================

/**
 * @class DriveAnalytics
 * @description Provides analytics on system drives
 */
class DriveAnalytics {
    static GetStatistics() {
        allDrives := DriveGetList()

        stats := {
            TotalDrives: 0,
            ReadyDrives: 0,
            TotalCapacityGB: 0,
            TotalFreeGB: 0,
            TotalUsedGB: 0,
            AverageUsagePercent: 0,
            ByType: Map(),
            ByFileSystem: Map()
        }

        stats.TotalDrives := StrLen(allDrives)

        for index, letter in StrSplit(allDrives) {
            drive := letter . ":"
            driveType := DriveGetType(drive)

            ; Count by type
            if !stats.ByType.Has(driveType)
                stats.ByType[driveType] := 0
            stats.ByType[driveType] := stats.ByType[driveType] + 1

            if (DriveGetStatus(drive) = "Ready") {
                stats.ReadyDrives++

                try {
                    capacityMB := DriveGetCapacity(drive)
                    freeMB := DriveGetSpaceFree(drive)

                    stats.TotalCapacityGB += Round(capacityMB / 1024, 2)
                    stats.TotalFreeGB += Round(freeMB / 1024, 2)
                    stats.TotalUsedGB += Round((capacityMB - freeMB) / 1024, 2)

                    ; Count by file system
                    fs := DriveGetFileSystem(drive)
                    if !stats.ByFileSystem.Has(fs)
                        stats.ByFileSystem[fs] := 0
                    stats.ByFileSystem[fs] := stats.ByFileSystem[fs] + 1
                }
            }
        }

        if (stats.TotalCapacityGB > 0) {
            stats.AverageUsagePercent := Round((stats.TotalUsedGB / stats.TotalCapacityGB) * 100, 2)
        }

        return stats
    }

    static ShowDashboard() {
        stats := DriveAnalytics.GetStatistics()

        report := "╔═══════════════════════════════════════════════════════╗`n"
        report .= "║           DRIVE ANALYTICS DASHBOARD                   ║`n"
        report .= "╚═══════════════════════════════════════════════════════╝`n`n"

        report .= "OVERVIEW`n"
        report .= StrReplace(Format("{:-<55}", ""), " ", "") . "`n"
        report .= Format("Total Drives: {1}`n", stats.TotalDrives)
        report .= Format("Ready Drives: {1}`n", stats.ReadyDrives)
        report .= Format("Total Capacity: {1} GB`n", Round(stats.TotalCapacityGB, 2))
        report .= Format("Total Free: {1} GB`n", Round(stats.TotalFreeGB, 2))
        report .= Format("Total Used: {1} GB`n", Round(stats.TotalUsedGB, 2))
        report .= Format("Average Usage: {1}%`n`n", stats.AverageUsagePercent)

        report .= "BY TYPE`n"
        report .= StrReplace(Format("{:-<55}", ""), " ", "") . "`n"
        for driveType, count in stats.ByType {
            report .= Format("{1}: {2}`n", driveType, count)
        }

        report .= "`nBY FILE SYSTEM`n"
        report .= StrReplace(Format("{:-<55}", ""), " ", "") . "`n"
        for fs, count in stats.ByFileSystem {
            report .= Format("{1}: {2}`n", fs, count)
        }

        MsgBox(report, "Analytics Dashboard", "Iconi")
    }
}

Example2_Analytics() {
    DriveAnalytics.ShowDashboard()
}

; ===================================================================================================
; EXAMPLE 3: Best Drive Selector
; ===================================================================================================

/**
 * @class BestDriveSelector
 * @description Selects the best drive based on various criteria
 */
class BestDriveSelector {
    static FindBestForBackup(requiredSpaceGB) {
        allDrives := DriveGetList("Fixed,Removable")
        bestDrive := ""
        bestScore := -1

        for index, letter in StrSplit(allDrives) {
            drive := letter . ":"

            if (DriveGetStatus(drive) != "Ready")
                continue

            try {
                freeGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
                capacityGB := Round(DriveGetCapacity(drive) / 1024, 2)

                ; Check if enough space
                if (freeGB < requiredSpaceGB)
                    continue

                ; Score based on: free space percentage and total free space
                usagePercent := ((capacityGB - freeGB) / capacityGB) * 100

                ; Prefer drives with lower usage and more total free space
                score := (100 - usagePercent) + (freeGB / 100)

                if (score > bestScore) {
                    bestScore := score
                    bestDrive := drive
                }
            }
        }

        if (bestDrive = "")
            return { Found: false, Message: "No suitable drive found" }

        return {
            Found: true,
            Drive: bestDrive,
            FreeGB: Round(DriveGetSpaceFree(bestDrive) / 1024, 2),
            Label: DriveGetLabel(bestDrive)
        }
    }

    static FindFastestDrive() {
        allDrives := DriveGetList("Fixed")
        fastestDrive := ""
        fastestScore := -1

        for index, letter in StrSplit(allDrives) {
            drive := letter . ":"

            if (DriveGetStatus(drive) != "Ready")
                continue

            ; Test write speed
            testFile := drive . "\speed_test.tmp"
            testData := StrReplace(Format("{:0>1048576}", 0), "0", "A")  ; 1MB

            try {
                startTime := A_TickCount
                FileAppend(testData, testFile)
                writeTime := A_TickCount - startTime
                FileDelete(testFile)

                score := 1000 / writeTime  ; Higher score = faster

                if (score > fastestScore) {
                    fastestScore := score
                    fastestDrive := drive
                }
            }
        }

        if (fastestDrive = "")
            return { Found: false }

        return {
            Found: true,
            Drive: fastestDrive,
            Label: DriveGetLabel(fastestDrive)
        }
    }
}

Example3_BestDrive() {
    requiredGB := 50
    result := BestDriveSelector.FindBestForBackup(requiredGB)

    if (result.Found) {
        message := Format("
        (
        Best Drive for Backup
        ═══════════════════════════════════════

        Drive: {1}
        Label: {2}
        Free Space: {3} GB

        This drive has been selected based on:
        • Sufficient free space ({4} GB required)
        • Optimal space-to-usage ratio
        • Drive health
        )",
            result.Drive,
            result.Label != "" ? result.Label : "(No Label)",
            result.FreeGB,
            requiredGB
        )

        MsgBox(message, "Best Drive", "Iconi")
    } else {
        MsgBox(result.Message, "No Drive Found", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 4: Drive Health Monitor
; ===================================================================================================

/**
 * @class DriveHealthMonitor
 * @description Monitors drive health based on various metrics
 */
class DriveHealthMonitor {
    static CheckHealth(drive) {
        if !InStr(drive, ":")
            drive .= ":"

        health := {
            Drive: drive,
            Status: "Unknown",
            Score: 100,
            Issues: []
        }

        driveStatus := DriveGetStatus(drive)

        if (driveStatus != "Ready") {
            health.Status := "Not Ready"
            health.Score := 0
            health.Issues.Push("Drive is not ready")
            return health
        }

        try {
            ; Check space usage
            capacityMB := DriveGetCapacity(drive)
            freeMB := DriveGetSpaceFree(drive)
            usagePercent := ((capacityMB - freeMB) / capacityMB) * 100

            if (usagePercent > 95) {
                health.Issues.Push("Critical: Drive is over 95% full")
                health.Score -= 40
            } else if (usagePercent > 90) {
                health.Issues.Push("Warning: Drive is over 90% full")
                health.Score -= 20
            } else if (usagePercent > 80) {
                health.Issues.Push("Caution: Drive is over 80% full")
                health.Score -= 10
            }

            ; Check file system
            fs := DriveGetFileSystem(drive)
            driveType := DriveGetType(drive)

            if (driveType = "Fixed" && fs != "NTFS" && fs != "ReFS") {
                health.Issues.Push("Notice: Fixed drive not using NTFS/ReFS")
                health.Score -= 5
            }

            ; Determine overall status
            if (health.Score >= 80)
                health.Status := "Healthy"
            else if (health.Score >= 60)
                health.Status := "Good"
            else if (health.Score >= 40)
                health.Status := "Fair"
            else
                health.Status := "Poor"

            if (health.Issues.Length = 0)
                health.Issues.Push("No issues detected")
        } catch as err {
            health.Status := "Error"
            health.Score := 0
            health.Issues.Push("Error checking health: " . err.Message)
        }

        return health
    }

    static MonitorAllDrives() {
        allDrives := DriveGetList()
        results := []

        for index, letter in StrSplit(allDrives) {
            health := DriveHealthMonitor.CheckHealth(letter . ":")
            results.Push(health)
        }

        return results
    }

    static ShowHealthReport() {
        results := DriveHealthMonitor.MonitorAllDrives()

        report := "Drive Health Report`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for health in results {
            statusIcon := ""
            if (health.Status = "Healthy")
                statusIcon := "✓"
            else if (health.Status = "Good")
                statusIcon := "√"
            else if (health.Status = "Fair")
                statusIcon := "~"
            else
                statusIcon := "✗"

            report .= Format("{1} {2} - {3} (Score: {4}/100)`n",
                statusIcon,
                health.Drive,
                health.Status,
                health.Score)

            for issue in health.Issues {
                report .= "   • " . issue . "`n"
            }

            report .= "`n"
        }

        MsgBox(report, "Health Report", "Iconi")
    }
}

Example4_HealthMonitor() {
    DriveHealthMonitor.ShowHealthReport()
}

; ===================================================================================================
; EXAMPLE 5: Custom Drive Organization
; ===================================================================================================

/**
 * @class CustomOrganization
 * @description Custom drive organization schemes
 */
class CustomOrganization {
    static OrganizeByPurpose() {
        allDrives := DriveGetList()
        organized := Map()
        organized["System"] := []
        organized["Data"] := []
        organized["Backup"] := []
        organized["Media"] := []
        organized["Temporary"] := []
        organized["Other"] := []

        for index, letter in StrSplit(allDrives) {
            drive := letter . ":"
            driveType := DriveGetType(drive)
            category := "Other"

            ; System drive
            if (drive = "C:") {
                category := "System"
            }
            ; Check label for categorization
            else if (DriveGetStatus(drive) = "Ready") {
                try {
                    label := StrUpper(DriveGetLabel(drive))

                    if InStr(label, "BACKUP")
                        category := "Backup"
                    else if InStr(label, "MEDIA") || InStr(label, "PHOTO") || InStr(label, "VIDEO")
                        category := "Media"
                    else if InStr(label, "TEMP") || InStr(label, "TMP")
                        category := "Temporary"
                    else if (driveType = "Fixed")
                        category := "Data"
                }
            }

            organized[category].Push(drive)
        }

        return organized
    }

    static ShowOrganizedView() {
        organized := CustomOrganization.OrganizeByPurpose()

        report := "Custom Drive Organization`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for category, driveList in organized {
            if (driveList.Length = 0)
                continue

            report .= Format("▶ {1} ({2})`n", category, driveList.Length)

            for drive in driveList {
                label := ""
                if (DriveGetStatus(drive) = "Ready") {
                    try {
                        label := DriveGetLabel(drive)
                    }
                }

                report .= Format("  {1} - {2}`n",
                    drive,
                    label != "" ? label : "(No Label)")
            }

            report .= "`n"
        }

        MsgBox(report, "Organized View", "Iconi")
    }
}

Example5_CustomOrganization() {
    CustomOrganization.ShowOrganizedView()
}

; ===================================================================================================
; EXAMPLE 6: Drive Discovery Wizard
; ===================================================================================================

/**
 * @class DriveDiscovery
 * @description Interactive drive discovery wizard
 */
class DriveDiscovery {
    static RunWizard() {
        ; Step 1: Discover all drives
        allDrives := DriveGetList()

        message := "Drive Discovery Wizard`n"
        message .= "═══════════════════════════════════════`n`n"
        message .= Format("Discovered {1} drive(s)`n`n", StrLen(allDrives))
        message .= "Proceed with detailed scan?"

        if (MsgBox(message, "Discovery Wizard", "YesNo Icon?") = "No")
            return

        ; Step 2: Detailed scan
        driveInfo := []

        for index, letter in StrSplit(allDrives) {
            drive := letter . ":"

            info := {
                Drive: drive,
                Type: DriveGetType(drive),
                Status: DriveGetStatus(drive)
            }

            if (info.Status = "Ready") {
                try {
                    info.Label := DriveGetLabel(drive)
                    info.FileSystem := DriveGetFileSystem(drive)
                    info.CapacityGB := Round(DriveGetCapacity(drive) / 1024, 2)
                    info.FreeGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
                    info.Health := DriveHealthMonitor.CheckHealth(drive)
                }
            }

            driveInfo.Push(info)
        }

        ; Step 3: Show results
        DriveDiscovery.ShowResults(driveInfo)
    }

    static ShowResults(driveInfo) {
        report := "Discovery Results`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for info in driveInfo {
            report .= Format("Drive: {1} ({2})`n", info.Drive, info.Type)
            report .= Format("  Status: {1}`n", info.Status)

            if info.HasOwnProp("Label") {
                report .= Format("  Label: {1}`n", info.Label)
                report .= Format("  File System: {1}`n", info.FileSystem)
                report .= Format("  Capacity: {1} GB`n", info.CapacityGB)
                report .= Format("  Free Space: {1} GB`n", info.FreeGB)
                report .= Format("  Health: {1}`n", info.Health.Status)
            }

            report .= "`n"
        }

        MsgBox(report, "Discovery Complete", "Iconi")
    }
}

Example6_DiscoveryWizard() {
    DriveDiscovery.RunWizard()
}

; ===================================================================================================
; EXAMPLE 7: Drive List Export Utilities
; ===================================================================================================

/**
 * @function ExportDriveListToCSV
 * @description Exports drive list to CSV format
 * @param {String} outputPath - Output file path
 * @returns {Boolean} Success status
 */
ExportDriveListToCSV(outputPath := "") {
    if (outputPath = "")
        outputPath := A_Desktop . "\DriveList_" . FormatTime(A_Now, "yyyyMMdd_HHmmss") . ".csv"

    allDrives := DriveGetList()

    content := "Drive,Type,Status,Label,FileSystem,CapacityGB,FreeGB,UsagePercent`n"

    for index, letter in StrSplit(allDrives) {
        drive := letter . ":"
        driveType := DriveGetType(drive)
        status := DriveGetStatus(drive)

        line := Format("{1},{2},{3}", drive, driveType, status)

        if (status = "Ready") {
            try {
                label := DriveGetLabel(drive)
                fs := DriveGetFileSystem(drive)
                capacityGB := Round(DriveGetCapacity(drive) / 1024, 2)
                freeGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
                usagePercent := Round(((capacityGB - freeGB) / capacityGB) * 100, 2)

                line .= Format(",{1},{2},{3},{4},{5}",
                    label,
                    fs,
                    capacityGB,
                    freeGB,
                    usagePercent)
            } catch {
                line .= ",,,,,"
            }
        } else {
            line .= ",,,,,"
        }

        content .= line . "`n"
    }

    try {
        FileDelete(outputPath)
        FileAppend(content, outputPath)
        return true
    } catch {
        return false
    }
}

Example7_ExportCSV() {
    outputPath := A_Desktop . "\DriveList_" . FormatTime(A_Now, "yyyyMMdd_HHmmss") . ".csv"

    if (ExportDriveListToCSV(outputPath)) {
        MsgBox("Drive list exported successfully!`n`nSaved to:`n" . outputPath,
            "Export Complete", "Iconi")
        Run(outputPath)
    } else {
        MsgBox("Failed to export drive list.", "Error", "Icon!")
    }
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+S to advanced search
; ^!s::Example1_AdvancedSearch()

; Press Ctrl+Alt+A to show analytics
; ^!a::Example2_Analytics()

; Press Ctrl+Alt+B to find best drive
; ^!b::Example3_BestDrive()

; Press Ctrl+Alt+H to show health report
; ^!h::Example4_HealthMonitor()

; Press Ctrl+Alt+W to run discovery wizard
; ^!w::Example6_DiscoveryWizard()

