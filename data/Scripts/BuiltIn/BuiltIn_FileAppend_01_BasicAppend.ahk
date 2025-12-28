#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FileAppend - Basic Append Operations
 * ============================================================================
 * 
 * Demonstrates fundamental FileAppend usage patterns including:
 * - Basic text appending
 * - Creating new files
 * - Appending with different encodings
 * - Line-by-line appending
 * - Error handling for append operations
 * 
 * @description Basic FileAppend operation examples
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileAppend.htm
 */

; ============================================================================
; Example 1: Simple Text Appending
; ============================================================================

Example1_SimpleAppend() {
    testFile := A_Temp "\simple_append.txt"

    try {
        ; Clear any existing file
        FileDelete(testFile)

        ; Append first line
        FileAppend("First line of text`n", testFile)

        ; Append more lines
        FileAppend("Second line of text`n", testFile)
        FileAppend("Third line of text`n", testFile)

        ; Append without newline
        FileAppend("Fourth line ", testFile)
        FileAppend("continued here`n", testFile)

        ; Read back and display
        content := FileRead(testFile)

        output := "File Contents:`n`n" content "`n`n"
        output .= "File Size: " FileGetSize(testFile) " bytes"

        MsgBox(output, "Simple Append Example")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 2: Creating Files with FileAppend
; ============================================================================

Example2_CreateFiles() {
    baseDir := A_Temp "\append_test"

    try {
        ; Create directory if needed
        if !DirExist(baseDir)
            DirCreate(baseDir)

        ; Create multiple files with content
        files := [{
            name: "readme.txt", content: "This is a README file`nCreated by FileAppend" }, {
                name: "config.ini", content: "[Settings]`nDebug=true`nPort=8080" }, {
                    name: "data.csv", content: "Name,Age,City`nJohn,30,NYC`nJane,25,LA"
                }
        ]

        for file in files {
            filePath := baseDir "\" file.name

            ; Delete if exists
            FileDelete(filePath)

            ; Create with content
            FileAppend(file.content, filePath)
        }

        ; Verify files were created
        output := "Files Created:`n`n"

        Loop Files, baseDir "\*.*" {
            output .= A_LoopFileName "`n"
            output .= "  Size: " A_LoopFileSize " bytes`n"
            output .= "  Created: " A_LoopFileTimeCreated "`n`n"
        }

        MsgBox(output, "File Creation")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        ; Cleanup
        if DirExist(baseDir)
            DirDelete(baseDir, true)
    }
}

; ============================================================================
; Example 3: Appending with Different Encodings
; ============================================================================

Example3_EncodingAppend() {
    baseFile := A_Temp "\encoding_append_"

    ; Test different encodings
    encodings := ["UTF-8", "UTF-16", "CP1252"]
    testText := "Hello World! Special chars: é ñ ü ö"

    try {
        for encoding in encodings {
            filePath := baseFile . encoding . ".txt"

            ; Delete existing
            FileDelete(filePath)

            ; Append with specific encoding
            FileAppend("File created with " encoding "`n", filePath, encoding)
            FileAppend(testText "`n", filePath, encoding)
            FileAppend("End of file`n", filePath, encoding)

            ; Read back
            content := FileRead(filePath, encoding)
            size := FileGetSize(filePath)

            MsgBox("Encoding: " encoding "`n" .
                "Size: " size " bytes`n`n" .
                "Content:`n" content,
                "Encoding Test - " encoding)

            FileDelete(filePath)
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 4: Building Files Line by Line
; ============================================================================

Example4_LineByLine() {
    reportFile := A_Temp "\report.txt"

    try {
        ; Clear file
        FileDelete(reportFile)

        ; Build a report line by line
        FileAppend("=" . StrReplace(Format("{:60}", ""), " ", "=") . "`n", reportFile)
        FileAppend("System Report`n", reportFile)
        FileAppend("=" . StrReplace(Format("{:60}", ""), " ", "=") . "`n`n", reportFile)

        ; Add system information
        FileAppend("Computer Name: " A_ComputerName "`n", reportFile)
        FileAppend("User Name: " A_UserName "`n", reportFile)
        FileAppend("OS Version: " A_OSVersion "`n", reportFile)
        FileAppend("AHK Version: " A_AhkVersion "`n`n", reportFile)

        ; Add timestamp
        FileAppend("Report Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n", reportFile)

        ; Add directory information
        FileAppend("Working Directory: " A_WorkingDir "`n", reportFile)
        FileAppend("Script Directory: " A_ScriptDir "`n", reportFile)
        FileAppend("Temp Directory: " A_Temp "`n`n", reportFile)

        ; Add separator
        FileAppend("=" . StrReplace(Format("{:60}", ""), " ", "=") . "`n", reportFile)

        ; Read and display
        content := FileRead(reportFile)
        MsgBox(content, "Generated Report")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(reportFile)
    }
}

; ============================================================================
; Example 5: Appending Data from Arrays
; ============================================================================

Example5_ArrayData() {
    dataFile := A_Temp "\array_data.txt"

    try {
        ; Sample data arrays
        names := ["John Doe", "Jane Smith", "Bob Johnson", "Alice Brown"]
        scores := [85, 92, 78, 95]
        grades := ["B", "A", "C", "A"]

        ; Clear file
        FileDelete(dataFile)

        ; Write header
        FileAppend("Student Score Report`n", dataFile)
        FileAppend(StrReplace(Format("{:50}", ""), " ", "-") . "`n`n", dataFile)

        ; Write data from arrays
        FileAppend(Format("{:-25} {:>10} {:>10}`n", "Name", "Score", "Grade"), dataFile)
        FileAppend(StrReplace(Format("{:50}", ""), " ", "-") . "`n", dataFile)

        Loop names.Length {
            line := Format("{:-25} {:>10} {:>10}`n",
                names[A_Index],
                scores[A_Index],
                grades[A_Index])
            FileAppend(line, dataFile)
        }

        ; Calculate and append summary
        total := 0
        for score in scores
            total += score

        average := Round(total / scores.Length, 2)

        FileAppend("`n" . StrReplace(Format("{:50}", ""), " ", "-") . "`n", dataFile)
        FileAppend("Summary:`n", dataFile)
        FileAppend("  Total Students: " names.Length "`n", dataFile)
        FileAppend("  Average Score: " average "`n", dataFile)

        ; Display result
        content := FileRead(dataFile)
        MsgBox(content, "Array Data Report")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(dataFile)
    }
}

; ============================================================================
; Example 6: Appending with Timestamps
; ============================================================================

Example6_TimestampedAppend() {
    logFile := A_Temp "\timestamped.txt"

    try {
        ; Clear file
        FileDelete(logFile)

        ; Append entries with timestamps
        events := [
            "Application started",
            "Loading configuration",
            "Connecting to database",
            "Database connection established",
            "User interface initialized",
            "Application ready"
        ]

        FileAppend("Event Log`n", logFile)
        FileAppend(StrReplace(Format("{:70}", ""), " ", "=") . "`n`n", logFile)

        for event in events {
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            FileAppend(timestamp " - " event "`n", logFile)

            ; Small delay to show different timestamps
            Sleep(100)
        }

        FileAppend("`n" . StrReplace(Format("{:70}", ""), " ", "=") . "`n", logFile)
        FileAppend("Log completed at: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n", logFile)

        ; Display log
        content := FileRead(logFile)
        MsgBox(content, "Timestamped Log")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }
}

; ============================================================================
; Example 7: Safe Append with Error Handling
; ============================================================================

Example7_SafeAppend() {
    testFile := A_Temp "\safe_append.txt"

    try {
        ; Demonstrate safe append function
        result1 := SafeAppend("First line`n", testFile)
        MsgBox("Append 1: " (result1 ? "Success" : "Failed"), "Safe Append")

        result2 := SafeAppend("Second line`n", testFile)
        MsgBox("Append 2: " (result2 ? "Success" : "Failed"), "Safe Append")

        ; Try to append to invalid path
        result3 := SafeAppend("Test", "Z:\invalid\path\file.txt")
        MsgBox("Append 3 (invalid path): " (result3 ? "Success" : "Failed"), "Safe Append")

        ; Display final content
        if FileExist(testFile) {
            content := FileRead(testFile)
            MsgBox("Final Content:`n`n" content, "Safe Append Result")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }

    ; Safe append function with error handling
    SafeAppend(text, filePath, encoding := "UTF-8") {
        try {
            ; Validate parameters
            if !text
                throw Error("No text provided")

            if !filePath
                throw Error("No file path provided")

            ; Check if directory exists (for new files)
            SplitPath(filePath, , &dir)
            if dir && !DirExist(dir)
                DirCreate(dir)

            ; Append to file
            FileAppend(text, filePath, encoding)

            return true

        } catch as err {
            ; Log error (in real app, you might log to a file)
            MsgBox("Append Error: " err.Message, "Error", 48)
            return false
        }
    }
}

; ============================================================================
; Example 8: Appending Multi-line Blocks
; ============================================================================

Example8_MultilineBlocks() {
    outputFile := A_Temp "\multiline.txt"

    try {
        ; Clear file
        FileDelete(outputFile)

        ; Append multi-line block using continuation section
        block1 := "
                (
                This is a multi-line block of text.
                It can span multiple lines.
                Each line is preserved in the output.
                )"

        FileAppend(block1 . "`n`n", outputFile)

        ; Append formatted multi-line content
        block2 := "
                (
                Function List:
                - Function1(): Does something
                - Function2(): Does something else
                - Function3(): Does another thing
                )"

        FileAppend(block2 . "`n`n", outputFile)

        ; Append code block
        codeBlock := "
                (
                Example Code:
                Loop 10 {
                    MsgBox("Iteration " A_Index)
                }
                )"

        FileAppend(codeBlock . "`n", outputFile)

        ; Display result
        content := FileRead(outputFile)
        MsgBox(content, "Multi-line Blocks")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(outputFile)
    }
}

; ============================================================================
; Example 9: Conditional Appending
; ============================================================================

Example9_ConditionalAppend() {
    logFile := A_Temp "\conditional.txt"

    try {
        ; Clear file
        FileDelete(logFile)

        ; Configuration
        debugMode := true
        verboseMode := false
        logLevel := "INFO"

        ; Conditional append function
        AppendLog := (message, level := "INFO") {
            ; Only log if level matches or debug mode is on
            if (debugMode || level = logLevel) {
                timestamp := FormatTime(, "HH:mm:ss")
                FileAppend(timestamp " [" level "] " message "`n", logFile)
            }
        }

        ; Test logging with different levels
        AppendLog("Application starting", "INFO")
        AppendLog("Debug information: Variable X = 42", "DEBUG")
        AppendLog("Warning: Low disk space", "WARNING")
        AppendLog("Processing user input", "INFO")
        AppendLog("Detailed state information", "DEBUG")
        AppendLog("Error: File not found", "ERROR")

        ; Display log
        if FileExist(logFile) {
            content := FileRead(logFile)
            MsgBox("Debug Mode: " (debugMode ? "ON" : "OFF") "`n" .
                "Log Level: " logLevel "`n`n" .
                "Log Contents:`n" content,
                "Conditional Logging")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }
}

; ============================================================================
; Example 10: Performance - Bulk Appending
; ============================================================================

Example10_BulkAppending() {
    testFile := A_Temp "\bulk_append.txt"

    try {
        ; Method 1: Multiple FileAppend calls
        FileDelete(testFile)
        startTime := A_TickCount

        Loop 1000
            FileAppend("Line " A_Index "`n", testFile)

        time1 := A_TickCount - startTime

        ; Method 2: Build string first, then single append
        FileDelete(testFile)
        startTime := A_TickCount

        content := ""
        Loop 1000
            content .= "Line " A_Index "`n"

        FileAppend(content, testFile)
        time2 := A_TickCount - startTime

        ; Display comparison
        output := "Performance Comparison:`n`n"
        output .= "Method 1 (1000 individual appends):`n"
        output .= "  Time: " time1 " ms`n`n"

        output .= "Method 2 (build string, single append):`n"
        output .= "  Time: " time2 " ms`n`n"

        output .= "Winner: Method 2 is " Round(time1 / time2, 2) "x faster`n`n"
        output .= "Recommendation: Build content in memory first,`n"
        output .= "then append once for better performance."

        MsgBox(output, "Performance Comparison")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Run Examples
; ============================================================================

; Uncomment to run individual examples:
; Example1_SimpleAppend()
; Example2_CreateFiles()
; Example3_EncodingAppend()
; Example4_LineByLine()
; Example5_ArrayData()
; Example6_TimestampedAppend()
; Example7_SafeAppend()
; Example8_MultilineBlocks()
; Example9_ConditionalAppend()
; Example10_BulkAppending()

; Run all examples
RunAllExamples() {
    examples := [{
        name: "Simple Append", func: Example1_SimpleAppend }, {
            name: "Create Files", func: Example2_CreateFiles }, {
                name: "Encoding Append", func: Example3_EncodingAppend }, {
                    name: "Line by Line", func: Example4_LineByLine }, {
                        name: "Array Data", func: Example5_ArrayData }, {
                            name: "Timestamped Append", func: Example6_TimestampedAppend }, {
                                name: "Safe Append", func: Example7_SafeAppend }, {
                                    name: "Multi-line Blocks", func: Example8_MultilineBlocks }, {
                                        name: "Conditional Append", func: Example9_ConditionalAppend }, {
                                            name: "Bulk Appending", func: Example10_BulkAppending
                                        }
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "FileAppend Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}

; Uncomment to run all examples interactively:
; RunAllExamples()

