#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file DriveList_01.ahk
 * @description Comprehensive examples of DriveGetList function with drive enumeration and monitoring
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Enumerating all system drives
 * - Filtering drives by type
 * - Real-time drive monitoring
 * - Drive list reporting
 * - Hot-plug detection
 * - Drive inventory management
 * - System drive mapping
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic Drive Enumeration
; ===================================================================================================

/**
 * @function EnumerateAllDrives
 * @description Enumerates all drives on the system
 * @returns {Array} Array of drive information objects
 */
EnumerateAllDrives() {
    drives := []
    driveList := DriveGetList()

    for index, driveLetter in StrSplit(driveList) {
        drive := driveLetter . ":"

        info := {
            Letter: drive,
            Type: DriveGetType(drive),
            Status: DriveGetStatus(drive),
            Index: index
        }

        if (info.Status = "Ready") {
            try {
                info.Label := DriveGetLabel(drive)
                info.FileSystem := DriveGetFileSystem(drive)
                info.CapacityGB := Round(DriveGetCapacity(drive) / 1024, 2)
                info.FreeGB := Round(DriveGetSpaceFree(drive) / 1024, 2)
            } catch {
                info.Label := "(Error)"
            }
        }

        drives.Push(info)
    }

    return drives
}

Example1_BasicEnumeration() {
    drives := EnumerateAllDrives()

    report := "System Drives Enumeration`n"
    report .= "═══════════════════════════════════════════════════════`n`n"
    report .= Format("Total Drives Found: {1}`n`n", drives.Length)

    for drive in drives {
        report .= Format("{1}. Drive {2} [{3}] - {4}`n",
            drive.Index,
            drive.Letter,
            drive.Type,
            drive.Status)

        if drive.HasOwnProp("Label")
            report .= Format("   Label: {1} | {2} | {3} GB / {4} GB`n",
                drive.Label,
                drive.FileSystem,
                drive.FreeGB,
                drive.CapacityGB)

        report .= "`n"
    }

    MsgBox(report, "Drive Enumeration", "Iconi")
    return drives
}

; ===================================================================================================
; EXAMPLE 2: Filtered Drive Lists by Type
; ===================================================================================================

/**
 * @class DriveFilter
 * @description Filters and categorizes drives by type
 */
class DriveFilter {
    static GetByType(driveType := "") {
        if (driveType = "")
            return DriveGetList()

        return DriveGetList(driveType)
    }

    static GetAllByTypes() {
        types := ["Fixed", "Removable", "CDROM", "Network", "RAMDisk"]
        categorized := Map()

        for driveType in types {
            list := DriveGetList(driveType)
            categorized[driveType] := list != "" ? StrSplit(list) : []
        }

        return categorized
    }

    static ShowCategorizedDrives() {
        categorized := DriveFilter.GetAllByTypes()

        report := "Drives by Type`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        for driveType, driveList in categorized {
            report .= Format("{1} Drives ({2}):`n", driveType, driveList.Length)

            if (driveList.Length > 0) {
                for drive in driveList {
                    drivePath := drive . ":"
                    label := ""

                    if (DriveGetStatus(drivePath) = "Ready") {
                        try {
                            label := DriveGetLabel(drivePath)
                        }
                    }

                    report .= Format("  {1} - {2}`n", drivePath,
                        label != "" ? label : "(No Label)")
                }
            } else {
                report .= "  (None)`n"
            }

            report .= "`n"
        }

        MsgBox(report, "Categorized Drives", "Iconi")
    }
}

Example2_FilteredLists() {
    DriveFilter.ShowCategorizedDrives()
}

; ===================================================================================================
; EXAMPLE 3: Real-Time Drive Monitor
; ===================================================================================================

/**
 * @class DriveMonitor
 * @description Monitors drive changes in real-time
 */
class DriveMonitor {
    knownDrives := Map()
    isMonitoring := false
    changeCallback := ""

    __New() {
        this.UpdateKnownDrives()
    }

    UpdateKnownDrives() {
        this.knownDrives := Map()
        driveList := DriveGetList()

        for index, letter in StrSplit(driveList) {
            this.knownDrives[letter . ":"] := true
        }
    }

    StartMonitoring(callback := "") {
        if (this.isMonitoring)
            return

        this.isMonitoring := true
        this.changeCallback := callback
        SetTimer(() => this.CheckChanges(), 2000)

        MsgBox("Drive monitoring started.`nWill check for changes every 2 seconds.",
            "Monitor Started", "Iconi")
    }

    StopMonitoring() {
        if (!this.isMonitoring)
            return

        this.isMonitoring := false
        SetTimer(() => this.CheckChanges(), 0)

        MsgBox("Drive monitoring stopped.", "Monitor Stopped", "Iconx")
    }

    CheckChanges() {
        currentDrives := Map()
        driveList := DriveGetList()

        for index, letter in StrSplit(driveList) {
            currentDrives[letter . ":"] := true
        }

        ; Check for new drives
        for drive, _ in currentDrives {
            if (!this.knownDrives.Has(drive)) {
                this.OnDriveAdded(drive)
            }
        }

        ; Check for removed drives
        for drive, _ in this.knownDrives {
            if (!currentDrives.Has(drive)) {
                this.OnDriveRemoved(drive)
            }
        }

        this.knownDrives := currentDrives
    }

    OnDriveAdded(drive) {
        driveType := DriveGetType(drive)
        label := ""

        if (DriveGetStatus(drive) = "Ready") {
            try {
                label := DriveGetLabel(drive)
            }
        }

        message := Format("Drive Added: {1}`nType: {2}`nLabel: {3}",
            drive, driveType, label != "" ? label : "(No Label)")

        MsgBox(message, "Drive Added", "Iconi 2")

        if (this.changeCallback != "")
            this.changeCallback(drive, "added")
    }

    OnDriveRemoved(drive) {
        message := Format("Drive Removed: {1}", drive)
        MsgBox(message, "Drive Removed", "Icon! 2")

        if (this.changeCallback != "")
            this.changeCallback(drive, "removed")
    }
}

Example3_DriveMonitor() {
    monitor := DriveMonitor()

    message := "Real-Time Drive Monitor`n"
    message .= "═══════════════════════════════════════`n`n"
    message .= "This will monitor for drive changes.`n"
    message .= "Connect or disconnect drives to see detection.`n`n"
    message .= "Start monitoring?"

    if (MsgBox(message, "Drive Monitor", "YesNo Icon?") = "Yes") {
        monitor.StartMonitoring()
    }

    return monitor
}

; ===================================================================================================
; EXAMPLE 4: Drive List Comparison
; ===================================================================================================

/**
 * @class DriveComparator
 * @description Compares drive lists between different time points
 */
class DriveComparator {
    static snapshot1 := ""
    static snapshot2 := ""

    static TakeSnapshot() {
        return DriveGetList()
    }

    static CompareSnapshots(snap1, snap2) {
        drives1 := snap1 != "" ? StrSplit(snap1) : []
        drives2 := snap2 != "" ? StrSplit(snap2) : []

        added := []
        removed := []

        ; Find added drives
        for drive in drives2 {
            found := false
            for oldDrive in drives1 {
                if (drive = oldDrive) {
                    found := true
                    break
                }
            }
            if (!found)
                added.Push(drive . ":")
        }

        ; Find removed drives
        for drive in drives1 {
            found := false
            for newDrive in drives2 {
                if (drive = newDrive) {
                    found := true
                    break
                }
            }
            if (!found)
                removed.Push(drive . ":")
        }

        return {
            Added: added,
            Removed: removed,
            HasChanges: (added.Length > 0 || removed.Length > 0)
        }
    }

    static ShowComparison() {
        DriveComparator.snapshot1 := DriveComparator.TakeSnapshot()
        MsgBox("Snapshot 1 taken. Make drive changes, then click OK.", "Snapshot", "Iconi")

        DriveComparator.snapshot2 := DriveComparator.TakeSnapshot()

        comparison := DriveComparator.CompareSnapshots(
            DriveComparator.snapshot1,
            DriveComparator.snapshot2
        )

        report := "Drive List Comparison`n"
        report .= "═══════════════════════════════════════`n`n"

        if (!comparison.HasChanges) {
            report .= "No changes detected."
        } else {
            if (comparison.Added.Length > 0) {
                report .= "Added Drives:`n"
                for drive in comparison.Added {
                    report .= "  + " . drive . "`n"
                }
                report .= "`n"
            }

            if (comparison.Removed.Length > 0) {
                report .= "Removed Drives:`n"
                for drive in comparison.Removed {
                    report .= "  - " . drive . "`n"
                }
            }
        }

        MsgBox(report, "Comparison Results", "Iconi")
    }
}

Example4_DriveComparison() {
    DriveComparator.ShowComparison()
}

; ===================================================================================================
; EXAMPLE 5: Drive Inventory Report Generator
; ===================================================================================================

/**
 * @function GenerateDriveInventoryReport
 * @description Generates a comprehensive drive inventory report
 * @param {String} outputPath - Path to save the report
 * @returns {Boolean} Success status
 */
GenerateDriveInventoryReport(outputPath := "") {
    if (outputPath = "")
        outputPath := A_Desktop . "\DriveInventory_" . FormatTime(A_Now, "yyyyMMdd_HHmmss") . ".txt"

    drives := EnumerateAllDrives()

    content := "╔═══════════════════════════════════════════════════════╗`n"
    content .= "║          SYSTEM DRIVE INVENTORY REPORT                ║`n"
    content .= "╚═══════════════════════════════════════════════════════╝`n`n"

    content .= "Generated: " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n"
    content .= "Computer: " . A_ComputerName . "`n"
    content .= "User: " . A_UserName . "`n"
    content .= "OS: " . A_OSVersion . "`n"
    content .= "Total Drives: " . drives.Length . "`n`n"

    content .= "═══════════════════════════════════════════════════════`n"
    content .= "DETAILED DRIVE INFORMATION`n"
    content .= "═══════════════════════════════════════════════════════`n`n"

    for drive in drives {
        content .= Format("DRIVE {1}`n", drive.Letter)
        content .= StrReplace(Format("{:-<50}", ""), " ", "") . "`n"
        content .= Format("Type: {1}`n", drive.Type)
        content .= Format("Status: {1}`n", drive.Status)

        if drive.HasOwnProp("Label") {
            content .= Format("Label: {1}`n", drive.Label)
            content .= Format("File System: {1}`n", drive.FileSystem)
            content .= Format("Capacity: {1} GB`n", drive.CapacityGB)
            content .= Format("Free Space: {1} GB`n", drive.FreeGB)
            content .= Format("Used Space: {1} GB ({2}%)`n",
                Round(drive.CapacityGB - drive.FreeGB, 2),
                Round(((drive.CapacityGB - drive.FreeGB) / drive.CapacityGB) * 100, 1))
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

Example5_InventoryReport() {
    outputPath := A_Desktop . "\DriveInventory_" . FormatTime(A_Now, "yyyyMMdd_HHmmss") . ".txt"

    if (GenerateDriveInventoryReport(outputPath)) {
        MsgBox("Drive inventory report generated successfully!`n`nSaved to:`n" . outputPath,
            "Report Generated", "Iconi")
        Run(outputPath)
    } else {
        MsgBox("Failed to generate report.", "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 6: Drive Map Visualization
; ===================================================================================================

/**
 * @function CreateDriveMap
 * @description Creates a visual map of all drives
 * @returns {String} ASCII drive map
 */
CreateDriveMap() {
    categorized := DriveFilter.GetAllByTypes()

    map := "`n╔═══════════════════════════════════════════════════════╗`n"
    map .= "║              SYSTEM DRIVE MAP                          ║`n"
    map .= "╚═══════════════════════════════════════════════════════╝`n`n"

    for driveType, driveList in categorized {
        if (driveList.Length = 0)
            continue

        map .= Format("▼ {1} ({2})`n", driveType, driveList.Length)

        for drive in driveList {
            drivePath := drive . ":"
            status := DriveGetStatus(drivePath) = "Ready" ? "●" : "○"
            label := ""

            if (status = "●") {
                try {
                    label := DriveGetLabel(drivePath)
                    label := label != "" ? label : "(No Label)"
                }
            }

            map .= Format("  {1} {2} - {3}`n", status, drivePath, label)
        }

        map .= "`n"
    }

    return map
}

Example6_DriveMap() {
    map := CreateDriveMap()
    MsgBox(map, "Drive Map", "Iconi")
}

; ===================================================================================================
; EXAMPLE 7: Hot-Plug Drive Logger
; ===================================================================================================

/**
 * @class HotPlugLogger
 * @description Logs hot-plug events for removable drives
 */
class HotPlugLogger {
    logFile := A_ScriptDir . "\hotplug_log.txt"
    monitor := ""

    __New() {
        this.monitor := DriveMonitor()
        this.monitor.changeCallback := (drive, action) => this.LogEvent(drive, action)
    }

    StartLogging() {
        this.monitor.StartMonitoring()
    }

    StopLogging() {
        this.monitor.StopMonitoring()
    }

    LogEvent(drive, action) {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        driveType := DriveGetType(drive)

        logEntry := Format("[{1}] {2} - {3} ({4})`n",
            timestamp,
            StrUpper(action),
            drive,
            driveType)

        FileAppend(logEntry, this.logFile)
    }

    ShowLog() {
        if !FileExist(this.logFile) {
            MsgBox("No log file found.", "Hot-Plug Log", "Iconi")
            return
        }

        content := FileRead(this.logFile)
        lines := StrSplit(content, "`n", "`r")

        report := "Hot-Plug Event Log (Last 20 events)`n"
        report .= "═══════════════════════════════════════`n`n"

        startIndex := Max(1, lines.Length - 20)

        for i, line in lines {
            if (i >= startIndex && line != "")
                report .= line . "`n"
        }

        MsgBox(report, "Hot-Plug Log", "Iconi")
    }
}

Example7_HotPlugLogger() {
    logger := HotPlugLogger()

    message := "Hot-Plug Drive Logger`n"
    message .= "═══════════════════════════════════════`n`n"
    message .= "This will log all drive connect/disconnect events.`n`n"
    message .= "Start logging?"

    if (MsgBox(message, "Hot-Plug Logger", "YesNo Icon?") = "Yes") {
        logger.StartLogging()
    }

    return logger
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+E to enumerate all drives
; ^!e::Example1_BasicEnumeration()

; Press Ctrl+Alt+F to show filtered drives
; ^!f::Example2_FilteredLists()

; Press Ctrl+Alt+M to start drive monitor
; ^!m::Example3_DriveMonitor()

; Press Ctrl+Alt+R to generate inventory report
; ^!r::Example5_InventoryReport()

; Press Ctrl+Alt+V to show drive map
; ^!v::Example6_DriveMap()

