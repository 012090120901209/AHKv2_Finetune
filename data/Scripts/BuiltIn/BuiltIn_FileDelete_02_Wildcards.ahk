#Requires AutoHotkey v2.0

/**
* ============================================================================
* FileDelete - Wildcard Patterns and Pattern Matching
* ============================================================================
*
* Demonstrates wildcard pattern deletion including:
* - Simple wildcard patterns (*.txt, *.log, etc.)
* - Complex pattern matching
* - Recursive pattern deletion
* - Pattern-based filtering
* - Safe wildcard operations
* - Pattern validation
*
* @description Wildcard pattern deletion examples for FileDelete
* @author AutoHotkey Foundation
* @version 1.0.0
* @see https://www.autohotkey.com/docs/v2/lib/FileDelete.htm
*/

; ============================================================================
; Example 1: Simple Wildcard Deletion
; ============================================================================

Example1_SimpleWildcard() {
    testDir := A_Temp "\wildcard_test"

    try {
        ; Create test directory
        if !DirExist(testDir)
        DirCreate(testDir)

        ; Create various file types
        extensions := [".txt", ".log", ".tmp", ".bak", ".dat"]

        for ext in extensions {
            Loop 3
            FileAppend("Test content", testDir "\file" A_Index ext)
        }

        ; Show files before deletion
        output := "Files Before Deletion:`n`n"
        Loop Files, testDir "\*.*"
        output .= A_LoopFileName "`n"

        MsgBox(output, "Before Wildcard Delete")

        ; Delete all .txt files using wildcard
        Loop Files, testDir "\*.txt" {
            FileDelete(A_LoopFilePath)
        }

        ; Show files after deletion
        output := "Files After Deleting *.txt:`n`n"
        Loop Files, testDir "\*.*"
        output .= A_LoopFileName "`n"

        MsgBox(output, "After Wildcard Delete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 2: Multiple Pattern Deletion
; ============================================================================

Example2_MultiplePatterns() {
    testDir := A_Temp "\multi_pattern"

    try {
        ; Create test directory and files
        if !DirExist(testDir)
        DirCreate(testDir)

        ; Create files with different extensions
        files := [
        "document.txt", "report.doc", "data.csv",
        "backup.bak", "temp.tmp", "log.log",
        "image.jpg", "photo.png", "archive.zip"
        ]

        for fileName in files
        FileAppend("Content", testDir "\" fileName)

        ; Define patterns to delete
        patterns := ["*.tmp", "*.bak", "*.log"]

        ; Show before deletion
        output := "Files Before Deletion:`n`n"
        Loop Files, testDir "\*.*"
        output .= A_LoopFileName "`n"

        MsgBox(output, "Before Multi-Pattern Delete")

        ; Delete multiple patterns
        deleted := []
        for pattern in patterns {
            Loop Files, testDir "\" pattern {
                FileDelete(A_LoopFilePath)
                deleted.Push(A_LoopFileName)
            }
        }

        ; Show results
        output := "Deleted Files:`n"
        for file in deleted
        output .= "- " file "`n"

        output .= "`nRemaining Files:`n"
        Loop Files, testDir "\*.*"
        output .= "- " A_LoopFileName "`n"

        MsgBox(output, "Multi-Pattern Delete Results")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 3: Date-Based Pattern Deletion
; ============================================================================

Example3_DateBasedPattern() {
    testDir := A_Temp "\date_pattern"

    try {
        ; Create test directory
        if !DirExist(testDir)
        DirCreate(testDir)

        ; Create files with date-like names
        dates := ["2024-01-15", "2024-02-20", "2024-03-10", "2023-12-25", "2023-11-30"]

        for date in dates {
            FileAppend("Log content", testDir "\log_" date ".txt")
        }

        ; Show all files
        output := "All Log Files:`n`n"
        Loop Files, testDir "\log_*.txt"
        output .= A_LoopFileName "`n"

        MsgBox(output, "All Files")

        ; Delete logs from 2023
        deleted := 0
        Loop Files, testDir "\log_2023-*.txt" {
            FileDelete(A_LoopFilePath)
            deleted++
        }

        ; Show results
        output := "Deleted " deleted " files from 2023`n`n"
        output .= "Remaining Files:`n`n"

        Loop Files, testDir "\log_*.txt"
        output .= A_LoopFileName "`n"

        MsgBox(output, "Date Pattern Delete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 4: Size-Based Deletion with Patterns
; ============================================================================

Example4_SizeBasedDeletion() {
    testDir := A_Temp "\size_pattern"

    try {
        ; Create test directory
        if !DirExist(testDir)
        DirCreate(testDir)

        ; Create files of different sizes
        Loop 10 {
            content := ""
            ; Create content of varying sizes
            Loop Random(10, 100)
            content .= "Data line " A_Index "`n"

            FileAppend(content, testDir "\file" A_Index ".txt")
        }

        ; Show files with sizes
        output := "Files Before Deletion:`n`n"
        Loop Files, testDir "\*.txt" {
            output .= A_LoopFileName " - " A_LoopFileSize " bytes`n"
        }

        MsgBox(output, "Before Size-Based Delete")

        ; Delete files larger than 500 bytes
        threshold := 500
        deleted := []

        Loop Files, testDir "\*.txt" {
            if A_LoopFileSize > threshold {
                deleted.Push({name: A_LoopFileName, size: A_LoopFileSize})
                FileDelete(A_LoopFilePath)
            }
        }

        ; Show results
        output := "Deleted Files (> " threshold " bytes):`n`n"
        for file in deleted
        output .= file.name " - " file.size " bytes`n"

        output .= "`nRemaining Files:`n`n"
        Loop Files, testDir "\*.txt"
        output .= A_LoopFileName " - " A_LoopFileSize " bytes`n"

        MsgBox(output, "Size-Based Delete Results")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 5: Recursive Pattern Deletion
; ============================================================================

Example5_RecursivePattern() {
    baseDir := A_Temp "\recursive_test"

    try {
        ; Create directory structure
        dirs := [baseDir, baseDir "\sub1", baseDir "\sub2", baseDir "\sub1\subsub"]

        for dir in dirs {
            if !DirExist(dir)
            DirCreate(dir)
        }

        ; Create .tmp files in all directories
        for dir in dirs {
            Loop 3
            FileAppend("Temp data", dir "\temp" A_Index ".tmp")

            ; Also create some .txt files
            Loop 2
            FileAppend("Text data", dir "\file" A_Index ".txt")
        }

        ; Count files before deletion
        tmpCount := 0
        Loop Files, baseDir "\*.tmp", "R"
        tmpCount++

        output := "Before Deletion:`n"
        output .= "Total .tmp files: " tmpCount "`n`n"

        ; Show directory structure
        Loop Files, baseDir "\*.*", "R"
        output .= A_LoopFilePath "`n"

        MsgBox(output, "Before Recursive Delete")

        ; Delete all .tmp files recursively
        deleted := 0
        Loop Files, baseDir "\*.tmp", "R" {
            FileDelete(A_LoopFilePath)
            deleted++
        }

        ; Show results
        output := "Recursively deleted " deleted " .tmp files`n`n"
        output .= "Remaining files:`n"

        Loop Files, baseDir "\*.*", "R"
        output .= A_LoopFilePath "`n"

        MsgBox(output, "After Recursive Delete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(baseDir)
        DirDelete(baseDir, true)
    }
}

; ============================================================================
; Example 6: Safe Wildcard Deletion with Confirmation
; ============================================================================

Example6_SafeWildcardDelete() {
    testDir := A_Temp "\safe_wildcard"

    try {
        ; Create test directory and files
        if !DirExist(testDir)
        DirCreate(testDir)

        Loop 10
        FileAppend("Data", testDir "\file" A_Index ".txt")

        ; Safe wildcard delete function
        SafeWildcardDelete := (directory, pattern) {
            ; Count matching files
            count := 0
            totalSize := 0

            Loop Files, directory "\" pattern {
                count++
                totalSize += A_LoopFileSize
            }

            if count = 0 {
                MsgBox("No files match pattern: " pattern, "No Files")
                return {deleted: 0, cancelled: false}
            }

            ; Show confirmation
            result := MsgBox("Delete " count " file(s) matching '" pattern "'?`n`n" .
            "Total size: " totalSize " bytes`n`n" .
            "This cannot be undone.",
            "Confirm Deletion", 4 + 48)

            if result = "No"
            return {deleted: 0, cancelled: true}

            ; Delete files
            deleted := 0
            Loop Files, directory "\" pattern {
                try {
                    FileDelete(A_LoopFilePath)
                    deleted++
                } catch {
                    ; Continue on error
                }
            }

            return {deleted: deleted, cancelled: false}
        }

        ; Test safe deletion
        result := SafeWildcardDelete(testDir, "*.txt")

        output := "Safe Wildcard Delete Results:`n`n"
        output .= "Files deleted: " result.deleted "`n"
        output .= "Cancelled: " (result.cancelled ? "Yes" : "No")

        MsgBox(output, "Results")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
    }
}

; ============================================================================
; Example 7: Pattern-Based Cleanup with Logging
; ============================================================================

Example7_PatternCleanupLog() {
    testDir := A_Temp "\pattern_cleanup"
    logFile := A_Temp "\cleanup_log.txt"

    try {
        ; Create test environment
        if !DirExist(testDir)
        DirCreate(testDir)

        FileDelete(logFile)

        ; Create various files
        extensions := [".tmp", ".bak", ".old", ".cache", ".log"]

        for ext in extensions {
            Loop 5
            FileAppend("Data", testDir "\file" A_Index ext)
        }

        ; Cleanup patterns (temporary file patterns)
        cleanupPatterns := ["*.tmp", "*.bak", "*.old", "*.cache"]

        ; Perform cleanup with logging
        FileAppend("Cleanup Log - " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n", logFile)
        FileAppend(StrReplace(Format("{:60}", ""), " ", "=") "`n`n", logFile)

        totalDeleted := 0
        totalSize := 0

        for pattern in cleanupPatterns {
            patternDeleted := 0
            patternSize := 0

            Loop Files, testDir "\" pattern {
                size := A_LoopFileSize
                name := A_LoopFileName

                FileDelete(A_LoopFilePath)

                FileAppend("Deleted: " name " (" size " bytes)`n", logFile)

                patternDeleted++
                patternSize += size
            }

            totalDeleted += patternDeleted
            totalSize += patternSize

            if patternDeleted > 0 {
                FileAppend("`nPattern: " pattern "`n", logFile)
                FileAppend("  Files: " patternDeleted "`n", logFile)
                FileAppend("  Size: " patternSize " bytes`n`n", logFile)
            }
        }

        ; Write summary
        FileAppend(StrReplace(Format("{:60}", ""), " ", "=") "`n", logFile)
        FileAppend("Total Files Deleted: " totalDeleted "`n", logFile)
        FileAppend("Total Space Freed: " totalSize " bytes`n", logFile)

        ; Show log
        logContent := FileRead(logFile)
        MsgBox(logContent, "Cleanup Log")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(testDir)
        DirDelete(testDir, true)
        FileDelete(logFile)
    }
}

; ============================================================================
; Run Examples
; ============================================================================

RunAllExamples() {
    examples := [
    {
        name: "Simple Wildcard", func: Example1_SimpleWildcard},
        {
            name: "Multiple Patterns", func: Example2_MultiplePatterns},
            {
                name: "Date-Based Pattern", func: Example3_DateBasedPattern},
                {
                    name: "Size-Based Deletion", func: Example4_SizeBasedDeletion},
                    {
                        name: "Recursive Pattern", func: Example5_RecursivePattern},
                        {
                            name: "Safe Wildcard Delete", func: Example6_SafeWildcardDelete},
                            {
                                name: "Pattern Cleanup Log", func: Example7_PatternCleanupLog
                            }
                            ]

                            for example in examples {
                                result := MsgBox("Run: " example.name "?", "Wildcard Examples", 4)
                                if result = "Yes"
                                example.func.Call()
                            }
                        }

                        ; Uncomment to run all examples interactively:
                        ; RunAllExamples()
