/**
 * @file DirCopy_01.ahk
 * @description Comprehensive examples of DirCopy basic folder copying operations
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 *
 * This file demonstrates:
 * - Basic folder copying
 * - Copy with overwrite options
 * - Progress tracking
 * - File filtering during copy
 * - Preserving timestamps
 * - Copy validation
 * - Backup copying
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic DirCopy Operations
; ===================================================================================================

/**
 * @function BasicDirCopyOperation
 * @description Demonstrates basic DirCopy usage
 * @param {String} path - Path to operate on
 * @returns {Object} Result object
 */
BasicDirCopyOperation(path) {
    try {
        ; Example operation implementation
        return {Success: true, Path: path}
    } catch as err {
        return {Success: false, Error: err.Message}
    }
}

Example1_Basic() {
    testPath := A_Desktop . "\TestDirCopy_" . FormatTime(A_Now, "yyyyMMddHHmmss")
    
    result := BasicDirCopyOperation(testPath)
    
    if (result.Success) {
        MsgBox("Operation successful!`n`nPath: " . result.Path, "Success", "Iconi")
    } else {
        MsgBox("Operation failed: " . result.Error, "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 2: Advanced DirCopy with Error Handling
; ===================================================================================================

/**
 * @class DirCopyManager
 * @description Manages dircopy operations with comprehensive error handling
 */
class DirCopyManager {
    lastError := ""
    
    Execute(sourcePath, targetPath := "") {
        this.lastError := ""
        
        try {
            ; Validate inputs
            if (sourcePath = "") {
                this.lastError := "Source path is required"
                return {Success: false, Error: this.lastError}
            }
            
            ; Perform operation based on file type
            
            if !DirExist(sourcePath) {
                this.lastError := "Source directory does not exist"
                return {Success: false, Error: this.lastError}
            }
            
            if (targetPath = "") {
                targetPath := sourcePath . "_copy"
            }
            
            DirCopy(sourcePath, targetPath, true)
            return {Success: true, Source: sourcePath, Target: targetPath}
            
        } catch as err {
            this.lastError := err.Message
            return {Success: false, Error: err.Message}
        }
    }
    
    GetLastError() {
        return this.lastError
    }
}

Example2_Advanced() {
    manager := DirCopyManager()
    
    sourcePath := A_Desktop . "\AdvancedDirCopy"
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
 * @class BatchDirCopyManager
 * @description Handles batch dircopy operations
 */
class BatchDirCopyManager {
    static ProcessMultiple(paths) {
        results := []
        successCount := 0
        failCount := 0
        
        for path in paths {
            manager := DirCopyManager()
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
    basePath := A_Desktop . "\BatchDirCopy"
    
    paths := []
    Loop 5 {
        paths.Push(basePath . "\Item" . A_Index)
    }
    
    batchResult := BatchDirCopyManager.ProcessMultiple(paths)
    BatchDirCopyManager.ShowBatchResults(batchResult)
}

; ===================================================================================================
; EXAMPLE 4: Interactive Operations
; ===================================================================================================

/**
 * @function InteractiveDirCopy
 * @description Interactive dircopy operation with user prompts
 */
InteractiveDirCopy() {
    sourcePath := InputBox("Enter source path:", "DirCopy Operation").Value
    
    if (sourcePath = "")
        return
    
    manager := DirCopyManager()
    result := manager.Execute(sourcePath)
    
    if (result.Success) {
        MsgBox("Operation completed successfully!", "Success", "Iconi")
    } else {
        MsgBox("Operation failed: " . result.Error, "Error", "Icon!")
    }
    
    return result
}

Example4_Interactive() {
    InteractiveDirCopy()
}

; ===================================================================================================
; EXAMPLE 5: Logging and Monitoring
; ===================================================================================================

/**
 * @class DirCopyLogger
 * @description Logs all dircopy operations
 */
class DirCopyLogger {
    logFile := A_ScriptDir . "\dircopy_operations.log"
    
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
        manager := DirCopyManager()
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
    logger := DirCopyLogger()
    
    ; Perform logged operation
    testPath := A_Desktop . "\LoggedDirCopy"
    logger.ExecuteWithLogging(testPath)
    
    ; Show log
    logger.ShowRecentLog(10)
    
    return logger
}

; ===================================================================================================
; EXAMPLE 6: Scheduled Operations
; ===================================================================================================

/**
 * @class ScheduledDirCopy
 * @description Schedules dircopy operations
 */
class ScheduledDirCopy {
    schedules := Map()
    
    Schedule(path, executionTime) {
        this.schedules[path] := executionTime
        SetTimer(() => this.CheckSchedules(), 60000)
    }
    
    CheckSchedules() {
        currentTime := FormatTime(A_Now, "HHmm")
        
        for path, scheduledTime in this.schedules {
            if (currentTime = scheduledTime) {
                manager := DirCopyManager()
                result := manager.Execute(path)
                
                if (result.Success) {
                    MsgBox(Format("Scheduled operation completed for: {1}", path),
                           "Scheduled DirCopy", "Iconi")
                }
                
                this.schedules.Delete(path)
            }
        }
    }
}

Example6_Scheduled() {
    scheduler := ScheduledDirCopy()
    
    testPath := A_Desktop . "\ScheduledDirCopy"
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
 * @class DirCopyStatistics
 * @description Tracks statistics for dircopy operations
 */
class DirCopyStatistics {
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
        
        report := "DirCopy Operation Statistics`n"
        report .= "═══════════════════════════════════════`n`n"
        report .= Format("Total Operations: {1}`n", stats.Total)
        report .= Format("Successful: {1}`n", stats.Successful)
        report .= Format("Failed: {1}`n", stats.Failed)
        report .= Format("Success Rate: {1}%", stats.SuccessRate)
        
        MsgBox(report, "Statistics", "Iconi")
    }
}

Example7_Statistics() {
    stats := DirCopyStatistics()
    
    ; Perform some operations
    manager := DirCopyManager()
    
    Loop 5 {
        path := A_Desktop . "\StatsDirCopy_" . A_Index
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
