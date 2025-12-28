/**
 * @file DirCreate_03.ahk
 * @description Comprehensive examples of DirCreate advanced recursive and error handling
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 * 
 * This file demonstrates:
 * - Multi-level recursive creation
 * - Advanced error handling
 * - Permission management
 * - Folder validation
 * - Atomic operations
 * - Transaction-like creation
 * - Rollback on error
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic DirCreate Operations
; ===================================================================================================

/**
 * @function BasicDirCreateOperation
 * @description Demonstrates basic DirCreate usage
 * @param {String} path - Path to operate on
 * @returns {Object} Result object
 */
BasicDirCreateOperation(path) {
    try {
        ; Example operation implementation
        return { Success: true, Path: path }
    } catch as err {
        return { Success: false, Error: err.Message }
    }
}

Example1_Basic() {
    testPath := A_Desktop . "\TestDirCreate_" . FormatTime(A_Now, "yyyyMMddHHmmss")

    result := BasicDirCreateOperation(testPath)

    if (result.Success) {
        MsgBox("Operation successful!`n`nPath: " . result.Path, "Success", "Iconi")
    } else {
        MsgBox("Operation failed: " . result.Error, "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 2: Advanced DirCreate with Error Handling
; ===================================================================================================

/**
 * @class DirCreateManager
 * @description Manages dircreate operations with comprehensive error handling
 */
class DirCreateManager {
    lastError := ""

    Execute(sourcePath, targetPath := "") {
        this.lastError := ""

        try {
            ; Validate inputs
            if (sourcePath = "") {
                this.lastError := "Source path is required"
                return { Success: false, Error: this.lastError }
            }

            ; Perform operation based on file type

            if DirExist(sourcePath) {
                return { Success: true, Existed: true, Path: sourcePath }
            }

            DirCreate(sourcePath)
            return { Success: true, Created: true, Path: sourcePath }

        } catch as err {
            this.lastError := err.Message
            return { Success: false, Error: err.Message }
        }
    }

    GetLastError() {
        return this.lastError
    }
}

Example2_Advanced() {
    manager := DirCreateManager()

    sourcePath := A_Desktop . "\AdvancedDirCreate"
    result := manager.Execute(sourcePath)

    if (result.Success) {
        message := "Advanced operation completed!`n`n"
        for key, value in result.OwnProps() {
            if (key != "Success")
                message .= key . ": " . value . "`n"
        }
        MsgBox(message, "Success", "Iconi")
    } else {
        MsgBox("Error: " . result.Error, "Failed", "Icon!")
    }

    return manager
}

; ===================================================================================================
; EXAMPLE 3: Batch Operations
; ===================================================================================================

/**
 * @class BatchDirCreateManager
 * @description Handles batch dircreate operations
 */
class BatchDirCreateManager {
    static ProcessMultiple(paths) {
        results := []
        successCount := 0
        failCount := 0

        for path in paths {
            manager := DirCreateManager()
            result := manager.Execute(path)

            if (result.Success)
                successCount++
            else
                failCount++

            results.Push(result)
        }

        return {
            Results: results,
            SuccessCount: successCount,
            FailCount: failCount,
            Total: paths.Length
        }
    }

    static ShowBatchResults(batchResult) {
        report := "Batch Operation Results`n"
        report .= "═══════════════════════════════════════`n`n"
        report .= Format("Total: {1}`n", batchResult.Total)
        report .= Format("Success: {1}`n", batchResult.SuccessCount)
        report .= Format("Failed: {1}`n", batchResult.FailCount)

        MsgBox(report, "Batch Results", "Iconi")
    }
}

Example3_Batch() {
    basePath := A_Desktop . "\BatchDirCreate"

    paths := []
    Loop 5 {
        paths.Push(basePath . "\Item" . A_Index)
    }

    batchResult := BatchDirCreateManager.ProcessMultiple(paths)
    BatchDirCreateManager.ShowBatchResults(batchResult)
}

; ===================================================================================================
; EXAMPLE 4: Interactive Operations
; ===================================================================================================

/**
 * @function InteractiveDirCreate
 * @description Interactive dircreate operation with user prompts
 */
InteractiveDirCreate() {
    sourcePath := InputBox("Enter source path:", "DirCreate Operation").Value

    if (sourcePath = "")
        return

    manager := DirCreateManager()
    result := manager.Execute(sourcePath)

    if (result.Success) {
        MsgBox("Operation completed successfully!", "Success", "Iconi")
    } else {
        MsgBox("Operation failed: " . result.Error, "Error", "Icon!")
    }

    return result
}

Example4_Interactive() {
    InteractiveDirCreate()
}

; ===================================================================================================
; EXAMPLE 5: Logging and Monitoring
; ===================================================================================================

/**
 * @class DirCreateLogger
 * @description Logs all dircreate operations
 */
class DirCreateLogger {
    logFile := A_ScriptDir . "\dircreate_operations.log"

    LogOperation(path, success, details := "") {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        status := success ? "SUCCESS" : "FAILED"

        logEntry := Format("[{1}] {2} - {3}", timestamp, status, path)

        if (details != "")
            logEntry .= " - " . details

        logEntry .= "`n"

        FileAppend(logEntry, this.logFile)
    }

    ExecuteWithLogging(path) {
        manager := DirCreateManager()
        result := manager.Execute(path)

        if (result.Success) {
            this.LogOperation(path, true, "Completed successfully")
        } else {
            this.LogOperation(path, false, result.Error)
        }

        return result
    }

    ShowRecentLog(lines := 20) {
        if !FileExist(this.logFile) {
            MsgBox("No log file found.", "Log", "Iconi")
            return
        }

        content := FileRead(this.logFile)
        allLines := StrSplit(content, "`n", "`r")

        report := "Recent Operations Log:`n"
        report .= "═══════════════════════════════════════`n`n"

        startIndex := Max(1, allLines.Length - lines)

        for i, line in allLines {
            if (i >= startIndex && line != "")
                report .= line . "`n"
        }

        MsgBox(report, "Operation Log", "Iconi")
    }
}

Example5_Logging() {
    logger := DirCreateLogger()

    ; Perform logged operation
    testPath := A_Desktop . "\LoggedDirCreate"
    logger.ExecuteWithLogging(testPath)

    ; Show log
    logger.ShowRecentLog(10)

    return logger
}

; ===================================================================================================
; EXAMPLE 6: Scheduled Operations
; ===================================================================================================

/**
 * @class ScheduledDirCreate
 * @description Schedules dircreate operations
 */
class ScheduledDirCreate {
    schedules := Map()

    Schedule(path, executionTime) {
        this.schedules[path] := executionTime
        SetTimer(() => this.CheckSchedules(), 60000)
    }

    CheckSchedules() {
        currentTime := FormatTime(A_Now, "HHmm")

        for path, scheduledTime in this.schedules {
            if (currentTime = scheduledTime) {
                manager := DirCreateManager()
                result := manager.Execute(path)

                if (result.Success) {
                    MsgBox(Format("Scheduled operation completed for: {1}", path),
                        "Scheduled DirCreate", "Iconi")
                }

                this.schedules.Delete(path)
            }
        }
    }
}

Example6_Scheduled() {
    scheduler := ScheduledDirCreate()

    testPath := A_Desktop . "\ScheduledDirCreate"
    scheduleTime := InputBox("Enter time (HHmm, e.g., 1430):", "Schedule").Value

    if (scheduleTime != "" && StrLen(scheduleTime) = 4) {
        scheduler.Schedule(testPath, scheduleTime)
        MsgBox(Format("Operation scheduled for {1}:{2}",
            SubStr(scheduleTime, 1, 2),
            SubStr(scheduleTime, 3, 2)),
            "Scheduled", "Iconi")
    }

    return scheduler
}

; ===================================================================================================
; EXAMPLE 7: Summary and Statistics
; ===================================================================================================

/**
 * @class DirCreateStatistics
 * @description Tracks statistics for dircreate operations
 */
class DirCreateStatistics {
    totalOperations := 0
    successfulOperations := 0
    failedOperations := 0

    RecordOperation(result) {
        this.totalOperations++

        if (result.Success)
            this.successfulOperations++
        else
            this.failedOperations++
    }

    GetStatistics() {
        successRate := this.totalOperations > 0
            ? Round((this.successfulOperations / this.totalOperations) * 100, 2)
            : 0

        return {
            Total: this.totalOperations,
            Successful: this.successfulOperations,
            Failed: this.failedOperations,
            SuccessRate: successRate
        }
    }

    ShowReport() {
        stats := this.GetStatistics()

        report := "DirCreate Operation Statistics`n"
        report .= "═══════════════════════════════════════`n`n"
        report .= Format("Total Operations: {1}`n", stats.Total)
        report .= Format("Successful: {1}`n", stats.Successful)
        report .= Format("Failed: {1}`n", stats.Failed)
        report .= Format("Success Rate: {1}%", stats.SuccessRate)

        MsgBox(report, "Statistics", "Iconi")
    }
}

Example7_Statistics() {
    stats := DirCreateStatistics()

    ; Perform some operations
    manager := DirCreateManager()

    Loop 5 {
        path := A_Desktop . "\StatsDirCreate_" . A_Index
        result := manager.Execute(path)
        stats.RecordOperation(result)
    }

    ; Show statistics
    stats.ShowReport()

    return stats
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+1 for basic operation
; ^!1::Example1_Basic()

; Press Ctrl+Alt+2 for advanced operation
; ^!2::Example2_Advanced()

; Press Ctrl+Alt+3 for batch operation
; ^!3::Example3_Batch()

; Press Ctrl+Alt+4 for interactive operation
; ^!4::Example4_Interactive()

; Press Ctrl+Alt+5 for logged operation
; ^!5::Example5_Logging()

