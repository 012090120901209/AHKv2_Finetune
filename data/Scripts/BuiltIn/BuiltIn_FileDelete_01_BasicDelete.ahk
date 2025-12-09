#Requires AutoHotkey v2.0

/**
* ============================================================================
* FileDelete - Basic File Deletion Operations
* ============================================================================
*
* Demonstrates fundamental FileDelete usage patterns including:
* - Single file deletion
* - Multiple file deletion
* - Checking file existence before deletion
* - Error handling for deletion operations
* - Deletion with confirmation
* - Deletion logging
*
* @description Basic FileDelete operation examples
* @author AutoHotkey Foundation
* @version 1.0.0
* @see https://www.autohotkey.com/docs/v2/lib/FileDelete.htm
*/

; ============================================================================
; Example 1: Simple File Deletion
; ============================================================================

Example1_SimpleDelete() {
    testFile := A_Temp "\test_delete.txt"

    try {
        ; Create test file
        FileAppend("This file will be deleted", testFile)

        ; Verify file exists
        if FileExist(testFile)
        MsgBox("File created: " testFile, "Before Deletion")

        ; Delete the file
        FileDelete(testFile)

        ; Verify deletion
        if !FileExist(testFile)
        MsgBox("File successfully deleted!", "After Deletion")
        else
        MsgBox("File still exists!", "Error", 16)

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Conditional Deletion (Check Before Delete)
; ============================================================================

Example2_ConditionalDelete() {
    testFile := A_Temp "\conditional_delete.txt"

    try {
        ; Create test file
        FileAppend("Test content", testFile)

        ; Safe delete function
        SafeDelete := (filePath) {
            if FileExist(filePath) {
                FileDelete(filePath)
                return {success: true, message: "File deleted"}
            } else {
                return {success: false, message: "File does not exist"}
            }
        }

        ; Test deletion
        result := SafeDelete(testFile)
        MsgBox("Status: " result.message, "Safe Delete")

        ; Try deleting again (should fail gracefully)
        result2 := SafeDelete(testFile)
        MsgBox("Second attempt: " result2.message, "Safe Delete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 3: Deleting Multiple Files
; ============================================================================

Example3_MultipleFiles() {
    testDir := A_Temp "\delete_test"

    try {
        ; Create test directory and files
        if !DirExist(testDir)
        DirCreate(testDir)

        files := ["file1.txt", "file2.txt", "file3.txt", "file4.txt"]

        for fileName in files
        FileAppend("Test content", testDir "\" fileName)

        ; Show files before deletion
        output := "Files Before Deletion:`n`n"
        Loop Files, testDir "\*.txt"
        output .= A_LoopFileName "`n"

        MsgBox(output, "Before Deletion")

        ; Delete all files
        for fileName in files {
            filePath := testDir "\" fileName
            if FileExist(filePath)
            FileDelete(filePath)
        }

        ; Verify deletion
        output := "Files After Deletion:`n`n"
        count := 0
        Loop Files, testDir "\*.txt" {
            output .= A_LoopFileName "`n"
            count++
        }

        if count = 0
        output .= "(No files remaining)"

        MsgBox(output, "After Deletion")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 4: Delete with User Confirmation
; ============================================================================

Example4_ConfirmDelete() {
    testFile := A_Temp "\confirm_delete.txt"

    try {
        ; Create test file
        FileAppend("Important data that requires confirmation", testFile)

        ; Confirm delete function
        ConfirmDelete := (filePath) {
            if !FileExist(filePath) {
                MsgBox("File does not exist: " filePath, "Error", 16)
                return false
            }

            fileSize := FileGetSize(filePath)
            result := MsgBox("Delete file?`n`n" .
            "File: " filePath "`n" .
            "Size: " fileSize " bytes`n`n" .
            "This action cannot be undone.",
            "Confirm Deletion", 4 + 48)

            if result = "Yes" {
                FileDelete(filePath)
                MsgBox("File deleted successfully", "Deleted")
                return true
            } else {
                MsgBox("Deletion cancelled", "Cancelled")
                return false
            }
        }

        ; Test with confirmation
        ConfirmDelete(testFile)

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        ; Cleanup if not deleted
        if FileExist(testFile)
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 5: Logged Deletion
; ============================================================================

Example5_LoggedDeletion() {
    testFile := A_Temp "\logged_delete.txt"
    logFile := A_Temp "\deletion_log.txt"

    try {
        ; Clear log
        FileDelete(logFile)

        ; Create test file
        FileAppend("Test content for logged deletion", testFile)

        ; Logged delete function
        LoggedDelete := (filePath, logPath) {
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

            try {
                if !FileExist(filePath) {
                    logEntry := timestamp " [SKIP] File not found: " filePath "`n"
                    FileAppend(logEntry, logPath)
                    return false
                }

                fileSize := FileGetSize(filePath)
                FileDelete(filePath)

                logEntry := timestamp " [SUCCESS] Deleted: " filePath " (" fileSize " bytes)`n"
                FileAppend(logEntry, logPath)

                return true

            } catch as err {
                logEntry := timestamp " [ERROR] Failed to delete: " filePath " - " err.Message "`n"
                FileAppend(logEntry, logPath)
                return false
            }
        }

        ; Test logged deletion
        LoggedDelete(testFile, logFile)
        LoggedDelete(A_Temp "\nonexistent.txt", logFile)

        ; Show log
        if FileExist(logFile) {
            logContent := FileRead(logFile)
            MsgBox("Deletion Log:`n`n" logContent, "Deletion Log")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }
}

; ============================================================================
; Example 6: Batch Delete with Statistics
; ============================================================================

Example6_BatchDeleteStats() {
    testDir := A_Temp "\batch_delete"

    try {
        ; Create test directory and files
        if !DirExist(testDir)
        DirCreate(testDir)

        ; Create files of different sizes
        Loop 10 {
            fileName := testDir "\file_" A_Index ".txt"
            content := ""
            Loop Random(10, 100)
            content .= "Data line " A_Index "`n"
            FileAppend(content, fileName)
        }

        ; Collect stats before deletion
        totalFiles := 0
        totalSize := 0

        Loop Files, testDir "\*.txt" {
            totalFiles++
            totalSize += A_LoopFileSize
        }

        output := "Before Deletion:`n"
        output .= "Files: " totalFiles "`n"
        output .= "Total Size: " totalSize " bytes`n`n"

        ; Delete all files
        deleted := 0
        deletedSize := 0

        Loop Files, testDir "\*.txt" {
            fileSize := A_LoopFileSize
            FileDelete(A_LoopFilePath)
            deleted++
            deletedSize += fileSize
        }

        output .= "After Deletion:`n"
        output .= "Files Deleted: " deleted "`n"
        output .= "Space Freed: " deletedSize " bytes"

        MsgBox(output, "Batch Delete Statistics")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 7: Delete with Error Recovery
; ============================================================================

Example7_ErrorRecovery() {
    testDir := A_Temp "\error_recovery"

    try {
        ; Create test directory
        if !DirExist(testDir)
        DirCreate(testDir)

        ; Create test files
        files := ["file1.txt", "file2.txt", "file3.txt"]
        for fileName in files
        FileAppend("Content", testDir "\" fileName)

        ; Delete with error tracking
        DeleteWithTracking := (directory, pattern := "*.txt") {
            results := {
                attempted: 0,
                successful: 0,
                failed: 0,
                errors: []
            }

            Loop Files, directory "\" pattern {
                results.attempted++

                try {
                    FileDelete(A_LoopFilePath)
                    results.successful++
                } catch as err {
                    results.failed++
                    results.errors.Push({
                        file: A_LoopFileName,
                        error: err.Message
                    })
                }
            }

            return results
        }

        ; Execute deletion
        results := DeleteWithTracking(testDir)

        ; Show results
        output := "Deletion Results:`n`n"
        output .= "Files Attempted: " results.attempted "`n"
        output .= "Successfully Deleted: " results.successful "`n"
        output .= "Failed: " results.failed "`n"

        if results.errors.Length > 0 {
            output .= "`nErrors:`n"
            for error in results.errors
            output .= "- " error.file ": " error.error "`n"
        }

        MsgBox(output, "Error Recovery")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Run Examples
; ============================================================================

RunAllExamples() {
    examples := [
    {
        name: "Simple Delete", func: Example1_SimpleDelete},
        {
            name: "Conditional Delete", func: Example2_ConditionalDelete},
            {
                name: "Multiple Files", func: Example3_MultipleFiles},
                {
                    name: "Confirm Delete", func: Example4_ConfirmDelete},
                    {
                        name: "Logged Deletion", func: Example5_LoggedDeletion},
                        {
                            name: "Batch Delete Stats", func: Example6_BatchDeleteStats},
                            {
                                name: "Error Recovery", func: Example7_ErrorRecovery
                            }
                            ]

                            for example in examples {
                                result := MsgBox("Run: " example.name "?", "FileDelete Examples", 4)
                                if result = "Yes"
                                example.func.Call()
                            }
                        }
