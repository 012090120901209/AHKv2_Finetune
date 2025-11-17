#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FileAppend - Error Handling and Validation
 * ============================================================================
 *
 * Demonstrates error handling for file append operations:
 * - Permission errors
 * - Disk space issues
 * - Path validation
 * - Atomic writes
 * - Backup and recovery
 * - Transaction-like operations
 *
 * @description Error handling examples for FileAppend
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileAppend.htm
 */

; ============================================================================
; Example 1: Basic Error Handling
; ============================================================================

Example1_BasicErrorHandling() {
    testFile := A_Temp "\error_test.txt"

    ; Test 1: Successful append
    try {
        FileAppend("Test content`n", testFile)
        MsgBox("Success: File append succeeded", "Test 1")
    } catch as err {
        MsgBox("Error: " err.Message, "Test 1 Failed", 16)
    }

    ; Test 2: Invalid path
    try {
        FileAppend("Test", "Z:\invalid\path\file.txt")
        MsgBox("This should not appear", "Test 2")
    } catch as err {
        MsgBox("Expected Error: " err.Message, "Test 2 - Invalid Path")
    }

    ; Test 3: Empty content (should succeed)
    try {
        FileAppend("", testFile)
        MsgBox("Empty append succeeded", "Test 3")
    } catch as err {
        MsgBox("Error: " err.Message, "Test 3 Failed", 16)
    }

    FileDelete(testFile)
}

; ============================================================================
; Example 2: Safe Append with Validation
; ============================================================================

Example2_SafeAppend() {
    testFile := A_Temp "\safe_append.txt"

    try {
        ; Create safe append function
        SafeAppend := (content, filePath, encoding := "UTF-8") {
            result := Map("success", false, "error", "")

            try {
                ; Validate content
                if !IsSet(content) {
                    throw Error("Content not provided")
                }

                ; Validate file path
                if !filePath {
                    throw Error("File path not provided")
                }

                ; Check if path is valid
                SplitPath(filePath, , &dir)
                if dir && !DirExist(dir) {
                    throw Error("Directory does not exist: " dir)
                }

                ; Attempt append
                FileAppend(content, filePath, encoding)

                result["success"] := true
                return result

            } catch as err {
                result["error"] := err.Message
                return result
            }
        }

        ; Test safe append
        result1 := SafeAppend("Test line 1`n", testFile)
        MsgBox("Test 1: " (result1["success"] ? "Success" : "Failed - " result1["error"]), "Safe Append")

        result2 := SafeAppend("Test line 2`n", "C:\InvalidPath\file.txt")
        MsgBox("Test 2: " (result2["success"] ? "Success" : "Failed - " result2["error"]), "Safe Append")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 3: Retry Logic for Transient Errors
; ============================================================================

Example3_RetryLogic() {
    testFile := A_Temp "\retry_test.txt"

    try {
        FileDelete(testFile)

        ; Append with retry logic
        AppendWithRetry := (content, filePath, maxRetries := 3, delayMs := 100) {
            attempt := 1

            Loop maxRetries {
                try {
                    FileAppend(content, filePath)
                    return {success: true, attempts: attempt}
                } catch as err {
                    if attempt >= maxRetries {
                        return {success: false, error: err.Message, attempts: attempt}
                    }
                    Sleep(delayMs)
                    attempt++
                }
            }
        }

        ; Test retry logic
        result := AppendWithRetry("Test content with retry`n", testFile, 3, 100)

        output := "Retry Test Results:`n`n"
        output .= "Success: " (result.success ? "Yes" : "No") "`n"
        output .= "Attempts: " result.attempts "`n"

        if !result.success
            output .= "Error: " result.error

        MsgBox(output, "Retry Logic")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 4: Atomic Write with Temporary File
; ============================================================================

Example4_AtomicWrite() {
    targetFile := A_Temp "\atomic_target.txt"

    try {
        ; Atomic append function
        AtomicAppend := (content, filePath) {
            tempFile := filePath ".tmp"

            try {
                ; If target exists, copy it first
                if FileExist(filePath) {
                    FileCopy(filePath, tempFile, 1)
                    FileAppend(content, tempFile)
                } else {
                    FileAppend(content, tempFile)
                }

                ; Atomic rename/replace
                FileMove(tempFile, filePath, 1)

                return {success: true}

            } catch as err {
                ; Cleanup temp file on error
                FileDelete(tempFile)
                return {success: false, error: err.Message}
            }
        }

        ; Test atomic append
        result1 := AtomicAppend("Line 1`n", targetFile)
        MsgBox("Append 1: " (result1.success ? "Success" : "Failed"), "Atomic Write")

        result2 := AtomicAppend("Line 2`n", targetFile)
        MsgBox("Append 2: " (result2.success ? "Success" : "Failed"), "Atomic Write")

        ; Show final content
        if FileExist(targetFile) {
            content := FileRead(targetFile)
            MsgBox("Final Content:`n`n" content, "Atomic Write Result")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(targetFile)
        FileDelete(targetFile ".tmp")
    }
}

; ============================================================================
; Example 5: Backup Before Append
; ============================================================================

Example5_BackupBeforeAppend() {
    dataFile := A_Temp "\important_data.txt"
    backupFile := A_Temp "\important_data.backup"

    try {
        ; Create initial file
        FileDelete(dataFile)
        FileAppend("Initial data line 1`n", dataFile)
        FileAppend("Initial data line 2`n", dataFile)

        ; Append with backup
        AppendWithBackup := (content, filePath) {
            backupPath := filePath ".backup"

            try {
                ; Create backup if file exists
                if FileExist(filePath) {
                    FileCopy(filePath, backupPath, 1)
                }

                ; Attempt append
                FileAppend(content, filePath)

                return {success: true, backup: backupPath}

            } catch as err {
                ; Restore from backup if append failed
                if FileExist(backupPath) {
                    FileCopy(backupPath, filePath, 1)
                }

                return {success: false, error: err.Message}
            }
        }

        ; Test backup and append
        result := AppendWithBackup("New data line 3`n", dataFile)

        output := "Backup and Append:`n`n"
        output .= "Success: " (result.success ? "Yes" : "No") "`n"

        if result.success {
            output .= "Backup: " result.backup "`n`n"
            output .= "Content:`n" FileRead(dataFile)
        }

        MsgBox(output, "Backup Before Append")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(dataFile)
        FileDelete(backupFile)
    }
}

; ============================================================================
; Example 6: Disk Space Check
; ============================================================================

Example6_DiskSpaceCheck() {
    testFile := A_Temp "\diskspace_test.txt"

    try {
        ; Append with disk space check
        AppendWithSpaceCheck := (content, filePath, minFreeMB := 10) {
            try {
                ; Get drive from path
                SplitPath(filePath, , , , &drive)
                if !drive
                    drive := SubStr(A_Temp, 1, 2)

                ; Check free space
                freeSpace := DriveGetSpaceFree(drive)

                if freeSpace < minFreeMB {
                    throw Error("Insufficient disk space: " Round(freeSpace) " MB free, need " minFreeMB " MB")
                }

                ; Append content
                FileAppend(content, filePath)

                return {success: true, freeSpace: freeSpace}

            } catch as err {
                return {success: false, error: err.Message}
            }
        }

        ; Test with different requirements
        result1 := AppendWithSpaceCheck("Test content`n", testFile, 1)
        output := "Test 1 (require 1MB):`n"
        output .= "Success: " (result1.success ? "Yes" : "No") "`n"

        if result1.success
            output .= "Free Space: " Round(result1.freeSpace) " MB`n"

        MsgBox(output, "Disk Space Check")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 7: Logged Append with Error Tracking
; ============================================================================

Example7_LoggedAppend() {
    dataFile := A_Temp "\data.txt"
    errorLog := A_Temp "\errors.log"

    try {
        FileDelete(dataFile)
        FileDelete(errorLog)

        ; Create logged append function
        LoggedAppend := (content, filePath, logPath) {
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

            try {
                FileAppend(content, filePath)

                ; Log success
                logEntry := timestamp " [SUCCESS] Appended to " filePath "`n"
                FileAppend(logEntry, logPath)

                return {success: true}

            } catch as err {
                ; Log error
                logEntry := timestamp " [ERROR] Failed to append to " filePath ": " err.Message "`n"
                FileAppend(logEntry, logPath)

                return {success: false, error: err.Message}
            }
        }

        ; Test logged append
        result1 := LoggedAppend("Data line 1`n", dataFile, errorLog)
        result2 := LoggedAppend("Data line 2`n", dataFile, errorLog)
        result3 := LoggedAppend("Data line 3`n", "C:\Invalid\Path.txt", errorLog)

        ; Show error log
        if FileExist(errorLog) {
            logContent := FileRead(errorLog)
            MsgBox("Error Log:`n`n" logContent, "Logged Append")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(dataFile)
        FileDelete(errorLog)
    }
}

; ============================================================================
; Run Examples
; ============================================================================

RunAllExamples() {
    examples := [
        {name: "Basic Error Handling", func: Example1_BasicErrorHandling},
        {name: "Safe Append", func: Example2_SafeAppend},
        {name: "Retry Logic", func: Example3_RetryLogic},
        {name: "Atomic Write", func: Example4_AtomicWrite},
        {name: "Backup Before Append", func: Example5_BackupBeforeAppend},
        {name: "Disk Space Check", func: Example6_DiskSpaceCheck},
        {name: "Logged Append", func: Example7_LoggedAppend}
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "Error Handling Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}
