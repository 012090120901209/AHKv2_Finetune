/**
* @file DriveGet_02.ahk
* @description Advanced examples of drive space monitoring, tracking, and management using DriveGet functions
* @author AutoHotkey v2 Examples
* @version 2.0
* @date 2025-01-16
*
* This file demonstrates:
* - Real-time drive space monitoring
* - Historical space usage tracking
* - Automated backup based on available space
* - Drive space trend analysis
* - Multi-drive load balancing
* - Predictive space warnings
* - Custom threshold management
*/

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Real-Time Drive Space Tracker with GUI
; ===================================================================================================

/**
* @class DriveSpaceTrackerGUI
* @description Real-time GUI-based drive space tracker with visual indicators
*/
class DriveSpaceTrackerGUI {
    gui := ""
    driveControls := Map()
    updateInterval := 5000  ; Update every 5 seconds

    /**
    * @constructor
    */
    __New() {
        this.CreateGUI()
        this.UpdateDriveInfo()
        SetTimer(() => this.UpdateDriveInfo(), this.updateInterval)
    }

    /**
    * @method CreateGUI
    * @description Creates the tracker GUI
    */
    CreateGUI() {
        this.gui := Gui("+Resize", "Drive Space Tracker")
        this.gui.SetFont("s10", "Segoe UI")
        this.gui.BackColor := "White"

        ; Add header
        this.gui.AddText("w600 Center", "Real-Time Drive Space Monitor")
        this.gui.SetFont("s9")
        this.gui.AddText("w600 Center", "Updated every 5 seconds")
        this.gui.AddText("w600 Section", "")  ; Spacer

        ; Get all ready drives
        drives := this.GetReadyDrives()

        for drive in drives {
            this.CreateDrivePanel(drive)
        }

        ; Add refresh button
        this.gui.AddText("w600 Section", "")
        btn := this.gui.AddButton("w200 Center", "Refresh Now")
        btn.OnEvent("Click", (*) => this.UpdateDriveInfo())

        ; Add close button
        closeBtn := this.gui.AddButton("w200 Center", "Close")
        closeBtn.OnEvent("Click", (*) => this.Close())

        this.gui.Show()
    }

    /**
    * @method GetReadyDrives
    * @description Gets all ready drives
    * @returns {Array} Array of ready drive letters
    */
    GetReadyDrives() {
        readyDrives := []
        driveList := DriveGetList()

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            if (DriveGetStatus(drive) = "Ready")
            readyDrives.Push(drive)
        }

        return readyDrives
    }

    /**
    * @method CreateDrivePanel
    * @description Creates a panel for a single drive
    * @param {String} drive - Drive letter
    */
    CreateDrivePanel(drive) {
        ; Add separator
        this.gui.AddText("w600 0x10")  ; Horizontal line

        ; Drive letter and status
        driveLabel := this.gui.AddText("xs w600 Section", "Drive " . drive)
        driveLabel.SetFont("Bold s11")

        ; Capacity info
        capacityText := this.gui.AddText("xs w600", "Total: --- GB")

        ; Usage info with color coding
        usageText := this.gui.AddText("xs w600", "Used: --- GB (---%)")

        ; Free space info
        freeText := this.gui.AddText("xs w600", "Free: --- GB (---%)")

        ; Progress bar
        progress := this.gui.AddProgress("xs w580 h20 BackgroundSilver", 0)

        ; Store controls for updates
        this.driveControls[drive] := {
            Label: driveLabel,
            Capacity: capacityText,
            Usage: usageText,
            Free: freeText,
            Progress: progress
        }
    }

    /**
    * @method UpdateDriveInfo
    * @description Updates all drive information
    */
    UpdateDriveInfo() {
        for drive, controls in this.driveControls {
            try {
                ; Get drive information
                capacity := DriveGetCapacity(drive)
                freeSpace := DriveGetSpaceFree(drive)
                usedSpace := capacity - freeSpace
                usagePercent := (usedSpace / capacity) * 100
                freePercent := 100 - usagePercent

                ; Convert to GB
                capacityGB := Round(capacity / 1024, 2)
                usedGB := Round(usedSpace / 1024, 2)
                freeGB := Round(freeSpace / 1024, 2)

                ; Update text
                controls.Capacity.Text := Format("Total: {1} GB", capacityGB)
                controls.Usage.Text := Format("Used: {1} GB ({2}%)", usedGB, Round(usagePercent, 1))
                controls.Free.Text := Format("Free: {1} GB ({2}%)", freeGB, Round(freePercent, 1))

                ; Update progress bar
                controls.Progress.Value := Round(usagePercent)

                ; Color code based on usage
                if (usagePercent >= 90) {
                    controls.Usage.SetFont("cRed Bold")
                    controls.Progress.Opt("+BackgroundRed")
                } else if (usagePercent >= 75) {
                    controls.Usage.SetFont("cOrange Bold")
                    controls.Progress.Opt("+BackgroundYellow")
                } else {
                    controls.Usage.SetFont("cGreen")
                    controls.Progress.Opt("+BackgroundGreen")
                }
            } catch as err {
                controls.Capacity.Text := "Error reading drive"
            }
        }
    }

    /**
    * @method Close
    * @description Closes the GUI and stops updates
    */
    Close() {
        SetTimer(() => this.UpdateDriveInfo(), 0)
        this.gui.Destroy()
    }
}

; Example usage
Example1_RealTimeTracker() {
    tracker := DriveSpaceTrackerGUI()
    return tracker
}

; ===================================================================================================
; EXAMPLE 2: Historical Drive Space Usage Tracking
; ===================================================================================================

/**
* @class DriveSpaceHistory
* @description Tracks drive space usage over time
*/
class DriveSpaceHistory {
    historyFile := A_ScriptDir . "\drive_space_history.csv"
    maxRecords := 1000

    /**
    * @method RecordCurrentState
    * @description Records current drive space state
    * @param {String} drive - Drive to record (optional, records all if omitted)
    */
    RecordCurrentState(drive := "") {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

        if (drive = "") {
            ; Record all drives
            drives := StrSplit(DriveGetList())
            for driveLetter in drives {
                drv := driveLetter . ":"
                if (DriveGetStatus(drv) = "Ready")
                this.RecordDrive(drv, timestamp)
            }
        } else {
            this.RecordDrive(drive, timestamp)
        }
    }

    /**
    * @method RecordDrive
    * @description Records a single drive's information
    * @param {String} drive - Drive letter
    * @param {String} timestamp - Timestamp string
    */
    RecordDrive(drive, timestamp) {
        try {
            capacity := DriveGetCapacity(drive)
            freeSpace := DriveGetSpaceFree(drive)
            usedSpace := capacity - freeSpace
            usagePercent := Round((usedSpace / capacity) * 100, 2)

            ; Format: Timestamp,Drive,CapacityMB,UsedMB,FreeMB,UsagePercent
            record := Format("{1},{2},{3},{4},{5},{6}`n",
            timestamp,
            drive,
            capacity,
            usedSpace,
            freeSpace,
            usagePercent
            )

            ; Create file with header if it doesn't exist
            if !FileExist(this.historyFile) {
                FileAppend("Timestamp,Drive,CapacityMB,UsedMB,FreeMB,UsagePercent`n", this.historyFile)
            }

            FileAppend(record, this.historyFile)

            ; Trim file if it gets too large
            this.TrimHistory()
        }
    }

    /**
    * @method TrimHistory
    * @description Keeps only the most recent records
    */
    TrimHistory() {
        if !FileExist(this.historyFile)
        return

        content := FileRead(this.historyFile)
        lines := StrSplit(content, "`n", "`r")

        if (lines.Length > this.maxRecords) {
            ; Keep header and last maxRecords
            newContent := lines[1] . "`n"
            startIndex := lines.Length - this.maxRecords + 1

            for i, line in lines {
                if (i >= startIndex && line != "")
                newContent .= line . "`n"
            }

            FileDelete(this.historyFile)
            FileAppend(newContent, this.historyFile)
        }
    }

    /**
    * @method GetHistory
    * @description Retrieves history for a drive
    * @param {String} drive - Drive letter
    * @param {Number} hours - Number of hours to retrieve (default: 24)
    * @returns {Array} Array of history records
    */
    GetHistory(drive, hours := 24) {
        if !FileExist(this.historyFile)
        return []

        content := FileRead(this.historyFile)
        lines := StrSplit(content, "`n", "`r")
        history := []

        cutoffTime := DateAdd(A_Now, -hours, "Hours")

        for index, line in lines {
            if (index = 1)  ; Skip header
            continue

            if (line = "")
            continue

            fields := StrSplit(line, ",")
            if (fields.Length >= 6) {
                recordTime := fields[1]
                recordDrive := fields[2]

                if (recordDrive = drive) {
                    ; Check if within time range
                    if (recordTime >= FormatTime(cutoffTime, "yyyy-MM-dd HH:mm:ss")) {
                        history.Push({
                            Timestamp: recordTime,
                            Drive: recordDrive,
                            CapacityMB: fields[3],
                            UsedMB: fields[4],
                            FreeMB: fields[5],
                            UsagePercent: fields[6]
                        })
                    }
                }
            }
        }

        return history
    }

    /**
    * @method GetUsageTrend
    * @description Analyzes usage trend
    * @param {String} drive - Drive letter
    * @param {Number} hours - Hours to analyze
    * @returns {Object} Trend analysis
    */
    GetUsageTrend(drive, hours := 24) {
        history := this.GetHistory(drive, hours)

        if (history.Length < 2)
        return {Trend: "Insufficient data", Rate: 0}

        ; Calculate average change rate
        firstRecord := history[1]
        lastRecord := history[history.Length]

        usageChange := lastRecord.UsagePercent - firstRecord.UsagePercent

        ; Determine trend
        trend := ""
        if (usageChange > 1)
        trend := "Increasing"
        else if (usageChange < -1)
        trend := "Decreasing"
        else
        trend := "Stable"

        return {
            Trend: trend,
            Rate: Round(usageChange, 2),
            FirstUsage: firstRecord.UsagePercent,
            LastUsage: lastRecord.UsagePercent,
            RecordCount: history.Length
        }
    }
}

; Example usage
Example2_HistoricalTracking() {
    history := DriveSpaceHistory()

    ; Record current state
    history.RecordCurrentState()

    ; Get trend for C: drive
    trend := history.GetUsageTrend("C:", 24)

    message := Format("
    (
    Drive Space Trend Analysis (Last 24 hours)
    ═══════════════════════════════════════

    Drive: C:
    Trend: {1}
    Change Rate: {2}%
    Records Analyzed: {3}
    )",
    trend.Trend,
    trend.Rate,
    trend.RecordCount
    )

    MsgBox(message, "Trend Analysis", "Icon!")

    return history
}

; ===================================================================================================
; EXAMPLE 3: Smart Backup Space Validator
; ===================================================================================================

/**
* @class BackupSpaceValidator
* @description Validates sufficient space before backup operations
*/
class BackupSpaceValidator {
    /**
    * @method CanBackup
    * @description Checks if there's enough space for backup
    * @param {String} sourcePath - Source directory to backup
    * @param {String} targetDrive - Target drive for backup
    * @param {Number} safetyMarginGB - Additional safety margin in GB (default: 5)
    * @returns {Object} Validation result
    */
    CanBackup(sourcePath, targetDrive, safetyMarginGB := 5) {
        ; Calculate source size
        sourceSize := this.GetDirectorySize(sourcePath)
        sourceSizeGB := Round(sourceSize / 1024, 2)

        ; Get target drive free space
        if !InStr(targetDrive, ":")
        targetDrive .= ":"

        if (DriveGetStatus(targetDrive) != "Ready") {
            return {
                CanBackup: false,
                Reason: "Target drive is not ready",
                SourceSizeGB: sourceSizeGB,
                TargetFreeGB: 0
            }
        }

        targetFreeMB := DriveGetSpaceFree(targetDrive)
        targetFreeGB := Round(targetFreeMB / 1024, 2)

        ; Check if enough space (including safety margin)
        requiredGB := sourceSizeGB + safetyMarginGB
        canBackup := targetFreeGB >= requiredGB

        return {
            CanBackup: canBackup,
            Reason: canBackup ? "Sufficient space available" : "Insufficient space",
            SourceSizeGB: sourceSizeGB,
            TargetFreeGB: targetFreeGB,
            RequiredGB: requiredGB,
            SafetyMarginGB: safetyMarginGB,
            ExcessSpaceGB: Round(targetFreeGB - requiredGB, 2)
        }
    }

    /**
    * @method GetDirectorySize
    * @description Calculates directory size in MB
    * @param {String} path - Directory path
    * @returns {Number} Size in MB
    */
    GetDirectorySize(path) {
        totalSize := 0

        try {
            ; Get all files
            Loop Files, path . "\*.*", "R" {
                totalSize += A_LoopFileSize
            }
        }

        ; Convert to MB
        return Round(totalSize / 1048576, 2)
    }

    /**
    * @method FindBestBackupDrive
    * @description Finds the best drive for backup
    * @param {Number} requiredSpaceGB - Required space in GB
    * @param {String} excludeDrive - Drive to exclude (typically source drive)
    * @returns {Object} Best drive information
    */
    FindBestBackupDrive(requiredSpaceGB, excludeDrive := "") {
        drives := StrSplit(DriveGetList("FIXED"))
        bestDrive := ""
        maxFreeSpace := 0

        for driveLetter in drives {
            drive := driveLetter . ":"

            ; Skip excluded drive
            if (drive = excludeDrive)
            continue

            if (DriveGetStatus(drive) = "Ready") {
                try {
                    freeSpaceMB := DriveGetSpaceFree(drive)
                    freeSpaceGB := freeSpaceMB / 1024

                    ; Check if this drive has more free space than current best
                    if (freeSpaceGB >= requiredSpaceGB && freeSpaceGB > maxFreeSpace) {
                        bestDrive := drive
                        maxFreeSpace := freeSpaceGB
                    }
                }
            }
        }

        return {
            Drive: bestDrive,
            FreeSpaceGB: Round(maxFreeSpace, 2),
            Found: bestDrive != ""
        }
    }
}

; Example usage
Example3_BackupValidator() {
    validator := BackupSpaceValidator()

    ; Example: Validate backup of Documents folder
    sourcePath := A_MyDocuments
    targetDrive := "D:"

    result := validator.CanBackup(sourcePath, targetDrive)

    message := Format("
    (
    Backup Space Validation
    ═══════════════════════════════════════

    Source: {1}
    Source Size: {2} GB

    Target Drive: {3}
    Target Free Space: {4} GB

    Required (with safety margin): {5} GB
    Safety Margin: {6} GB

    Can Backup: {7}
    Status: {8}
    )",
    sourcePath,
    result.SourceSizeGB,
    targetDrive,
    result.TargetFreeGB,
    result.RequiredGB,
    result.SafetyMarginGB,
    result.CanBackup ? "YES" : "NO",
    result.Reason
    )

    MsgBox(message, "Backup Validation", result.CanBackup ? "Iconi" : "Icon!")

    return validator
}

; ===================================================================================================
; EXAMPLE 4: Drive Load Balancer
; ===================================================================================================

/**
* @class DriveLoadBalancer
* @description Balances data across multiple drives
*/
class DriveLoadBalancer {
    drives := []

    /**
    * @constructor
    * @param {Array} driveList - Array of drive letters to balance across
    */
    __New(driveList := []) {
        this.drives := driveList.Length > 0 ? driveList : this.GetAllFixedDrives()
    }

    /**
    * @method GetAllFixedDrives
    * @description Gets all ready fixed drives
    * @returns {Array} Array of drive letters
    */
    GetAllFixedDrives() {
        fixedDrives := []
        driveList := DriveGetList("FIXED")

        for index, driveLetter in StrSplit(driveList) {
            drive := driveLetter . ":"
            if (DriveGetStatus(drive) = "Ready")
            fixedDrives.Push(drive)
        }

        return fixedDrives
    }

    /**
    * @method GetBestDriveForSize
    * @description Finds the best drive for a file of given size
    * @param {Number} fileSizeMB - File size in MB
    * @returns {String} Best drive letter
    */
    GetBestDriveForSize(fileSizeMB) {
        bestDrive := ""
        bestScore := -1

        for drive in this.drives {
            if (DriveGetStatus(drive) != "Ready")
            continue

            try {
                freeSpace := DriveGetSpaceFree(drive)
                capacity := DriveGetCapacity(drive)
                usagePercent := ((capacity - freeSpace) / capacity) * 100

                ; Can the drive fit the file?
                if (freeSpace < fileSizeMB)
                continue

                ; Score based on: lower usage = better score
                score := 100 - usagePercent

                if (score > bestScore) {
                    bestScore := score
                    bestDrive := drive
                }
            }
        }

        return bestDrive
    }

    /**
    * @method GetLoadBalanceReport
    * @description Gets a load balance report
    * @returns {String} Formatted report
    */
    GetLoadBalanceReport() {
        report := "Drive Load Balance Report`n"
        report .= "═══════════════════════════════════════════════════════`n`n"

        totalCapacity := 0
        totalUsed := 0

        driveInfos := []

        for drive in this.drives {
            if (DriveGetStatus(drive) != "Ready")
            continue

            try {
                capacity := DriveGetCapacity(drive)
                freeSpace := DriveGetSpaceFree(drive)
                used := capacity - freeSpace
                usagePercent := (used / capacity) * 100

                totalCapacity += capacity
                totalUsed += used

                driveInfos.Push({
                    Drive: drive,
                    UsagePercent: usagePercent,
                    FreeGB: Round(freeSpace / 1024, 2)
                })

                report .= Format("{1}: {2}% used, {3} GB free`n",
                drive,
                Round(usagePercent, 1),
                Round(freeSpace / 1024, 2)
                )
            }
        }

        ; Calculate balance score (lower is better)
        if (driveInfos.Length > 1) {
            avgUsage := (totalUsed / totalCapacity) * 100
            variance := 0

            for info in driveInfos {
                variance += (info.UsagePercent - avgUsage) ** 2
            }

            variance := variance / driveInfos.Length
            balanceScore := Round(Sqrt(variance), 2)

            report .= "`n═══════════════════════════════════════════════════════`n"
            report .= Format("Average Usage: {1}%`n", Round(avgUsage, 2))
            report .= Format("Balance Score: {1} (lower is better)`n", balanceScore)

            if (balanceScore < 5)
            report .= "Status: Excellent balance`n"
            else if (balanceScore < 15)
            report .= "Status: Good balance`n"
            else if (balanceScore < 25)
            report .= "Status: Fair balance`n"
            else
            report .= "Status: Poor balance - consider redistributing files`n"
        }

        return report
    }
}

; Example usage
Example4_LoadBalancer() {
    balancer := DriveLoadBalancer()
    report := balancer.GetLoadBalanceReport()
    MsgBox(report, "Load Balance Report", "Icon!")

    return balancer
}

; ===================================================================================================
; EXAMPLE 5: Predictive Space Warning System
; ===================================================================================================

/**
* @class PredictiveSpaceWarning
* @description Predicts when drive will run out of space based on usage trends
*/
class PredictiveSpaceWarning {
    history := DriveSpaceHistory()

    /**
    * @method PredictDaysUntilFull
    * @description Predicts days until drive is full
    * @param {String} drive - Drive letter
    * @param {Number} threshold - Full threshold percentage (default: 95)
    * @returns {Object} Prediction result
    */
    PredictDaysUntilFull(drive, threshold := 95) {
        ; Get historical data
        histData := this.history.GetHistory(drive, 168)  ; 7 days

        if (histData.Length < 10) {
            return {
                CanPredict: false,
                Reason: "Insufficient historical data (need at least 10 data points)",
                DaysUntilFull: -1
            }
        }

        ; Calculate average daily change
        firstRecord := histData[1]
        lastRecord := histData[histData.Length]

        firstUsage := firstRecord.UsagePercent
        lastUsage := lastRecord.UsagePercent

        ; Parse timestamps
        usageChange := lastUsage - firstUsage

        ; Calculate time span
        ; Simplified: assume records span the request period
        daysCovered := 7

        if (usageChange <= 0) {
            return {
                CanPredict: true,
                Reason: "Usage is stable or decreasing",
                DaysUntilFull: -1,
                Trend: "Stable/Decreasing"
            }
        }

        ; Calculate daily change rate
        dailyChangeRate := usageChange / daysCovered

        ; Calculate days until threshold
        currentUsage := lastUsage
        spaceRemaining := threshold - currentUsage
        daysUntilFull := spaceRemaining / dailyChangeRate

        return {
            CanPredict: true,
            Reason: "Prediction based on 7-day trend",
            DaysUntilFull: Round(daysUntilFull, 1),
            CurrentUsage: Round(currentUsage, 2),
            DailyChangeRate: Round(dailyChangeRate, 3),
            Trend: "Increasing"
        }
    }

    /**
    * @method ShowPrediction
    * @description Shows prediction for a drive
    * @param {String} drive - Drive letter
    */
    ShowPrediction(drive) {
        prediction := this.PredictDaysUntilFull(drive)

        message := Format("Drive {1} - Space Prediction`n", drive)
        message .= "═══════════════════════════════════════`n`n"

        if (prediction.CanPredict) {
            if (prediction.DaysUntilFull > 0) {
                message .= Format("Days Until 95% Full: {1}`n", prediction.DaysUntilFull)
                message .= Format("Current Usage: {1}%`n", prediction.CurrentUsage)
                message .= Format("Daily Change Rate: {1}%`n", prediction.DailyChangeRate)
                message .= Format("Trend: {1}`n`n", prediction.Trend)

                if (prediction.DaysUntilFull < 7)
                message .= "⚠️ WARNING: Drive will be full within a week!"
                else if (prediction.DaysUntilFull < 30)
                message .= "⚠️ CAUTION: Drive will be full within a month."
                else
                message .= "✓ Drive has sufficient space for now."
            } else {
                message .= Format("Status: {1}`n", prediction.Reason)
                message .= "✓ No immediate space concerns."
            }
        } else {
            message .= Format("Cannot predict: {1}", prediction.Reason)
        }

        MsgBox(message, "Space Prediction", "Iconi")
    }
}

; Example usage
Example5_PredictiveWarning() {
    predictor := PredictiveSpaceWarning()
    predictor.ShowPrediction("C:")

    return predictor
}

; ===================================================================================================
; EXAMPLE 6: Automated Space Management
; ===================================================================================================

/**
* @function CleanupTemporaryFiles
* @description Cleans up temporary files to free space
* @param {String} drive - Drive to clean (optional)
* @returns {Object} Cleanup results
*/
CleanupTemporaryFiles(drive := "") {
    freedSpace := 0
    filesDeleted := 0

    ; Temp directories to clean
    tempDirs := [
    A_Temp,
    "C:\Windows\Temp"
    ]

    for tempDir in tempDirs {
        ; Skip if drive specified and doesn't match
        if (drive != "" && !InStr(tempDir, drive))
        continue

        try {
            Loop Files, tempDir . "\*.*", "R" {
                ; Only delete files older than 7 days
                if (DateDiff(A_Now, A_LoopFileTimeModified, "Days") > 7) {
                    try {
                        fileSize := A_LoopFileSize
                        FileDelete(A_LoopFilePath)
                        freedSpace += fileSize
                        filesDeleted++
                    }
                }
            }
        }
    }

    return {
        FilesDeleted: filesDeleted,
        SpaceFreedMB: Round(freedSpace / 1048576, 2),
        SpaceFreedGB: Round(freedSpace / 1073741824, 2)
    }
}

; Example usage
Example6_AutoCleanup() {
    result := CleanupTemporaryFiles("C:")

    message := Format("
    (
    Temporary Files Cleanup Complete
    ═══════════════════════════════════════

    Files Deleted: {1}
    Space Freed: {2} GB ({3} MB)
    )",
    result.FilesDeleted,
    result.SpaceFreedGB,
    result.SpaceFreedMB
    )

    MsgBox(message, "Cleanup Complete", "Iconi")
}

; ===================================================================================================
; EXAMPLE 7: Drive Health Dashboard
; ===================================================================================================

/**
* @function CreateDriveHealthDashboard
* @description Creates a comprehensive drive health dashboard
*/
CreateDriveHealthDashboard() {
    drives := StrSplit(DriveGetList("FIXED"))

    dashboard := "═══════════════════════════════════════════════════════`n"
    dashboard .= "           DRIVE HEALTH DASHBOARD`n"
    dashboard .= "═══════════════════════════════════════════════════════`n`n"

    for driveLetter in drives {
        drive := driveLetter . ":"

        if (DriveGetStatus(drive) != "Ready")
        continue

        try {
            capacity := DriveGetCapacity(drive)
            freeSpace := DriveGetSpaceFree(drive)
            usedSpace := capacity - freeSpace
            usagePercent := (usedSpace / capacity) * 100

            ; Health status
            health := ""
            if (usagePercent < 70)
            health := "✓ HEALTHY"
            else if (usagePercent < 85)
            health := "⚠ CAUTION"
            else if (usagePercent < 95)
            health := "⚠ WARNING"
            else
            health := "✗ CRITICAL"

            dashboard .= Format("Drive {1} - {2}`n", drive, health)
            dashboard .= Format("  Capacity: {1} GB`n", Round(capacity / 1024, 2))
            dashboard .= Format("  Used: {1} GB ({2}%)`n", Round(usedSpace / 1024, 2), Round(usagePercent, 1))
            dashboard .= Format("  Free: {1} GB ({2}%)`n", Round(freeSpace / 1024, 2), Round(100 - usagePercent, 1))
            dashboard .= "`n"
        }
    }

    dashboard .= "═══════════════════════════════════════════════════════"

    MsgBox(dashboard, "Drive Health Dashboard", "Iconi")
}

; Example usage
Example7_HealthDashboard() {
    CreateDriveHealthDashboard()
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+T to show real-time tracker
; ^!t::Example1_RealTimeTracker()

; Press Ctrl+Alt+H to show health dashboard
; ^!h::Example7_HealthDashboard()

; Press Ctrl+Alt+P to show prediction
; ^!p::Example5_PredictiveWarning()

; Press Ctrl+Alt+C to cleanup temp files
; ^!c::Example6_AutoCleanup()
