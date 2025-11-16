#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FileRead - Large File Handling and Performance Optimization
 * ============================================================================
 *
 * Demonstrates techniques for handling large files:
 * - Memory-efficient reading strategies
 * - Chunked reading for large files
 * - Progress tracking during file reading
 * - Performance optimization techniques
 * - Memory management best practices
 *
 * @description Large file handling examples for FileRead
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileRead.htm
 */

; ============================================================================
; Example 1: Creating and Reading Large Test Files
; ============================================================================

Example1_CreateLargeFile() {
    largeFile := A_Temp "\large_test_file.txt"

    try {
        ; Create a large file (5MB of text data)
        MsgBox("Creating 5MB test file...`n`nThis may take a moment.", "Creating Test File")

        ; Clear existing file
        FileDelete(largeFile)

        ; Generate and write data in chunks
        totalLines := 100000
        chunkSize := 10000

        startTime := A_TickCount

        Loop totalLines // chunkSize {
            chunk := ""
            baseIndex := (A_Index - 1) * chunkSize

            Loop chunkSize {
                lineNum := baseIndex + A_Index
                chunk .= "Line " lineNum ": This is sample data for performance testing. "
                chunk .= "The quick brown fox jumps over the lazy dog. 0123456789`n"
            }

            FileAppend(chunk, largeFile)

            ; Show progress every 20%
            if (Mod(A_Index, 2) = 0) {
                progress := Round((A_Index * chunkSize / totalLines) * 100)
                ToolTip("Creating file: " progress "%")
            }
        }

        ToolTip()

        createTime := A_TickCount - startTime
        fileSize := FileGetSize(largeFile)
        fileSizeMB := Round(fileSize / 1024 / 1024, 2)

        ; Now read the entire file
        MsgBox("File created successfully!`n`nReading entire file...", "Reading File")

        startTime := A_TickCount
        content := FileRead(largeFile)
        readTime := A_TickCount - startTime

        ; Analyze content
        lines := StrSplit(content, "`n")
        firstLine := lines[1]
        lastLine := lines[lines.Length - 1]

        output := "Large File Statistics:`n`n"
        output .= "File Size: " fileSizeMB " MB (" fileSize " bytes)`n"
        output .= "Total Lines: " lines.Length "`n`n"
        output .= "Performance:`n"
        output .= "  Creation Time: " createTime " ms`n"
        output .= "  Read Time: " readTime " ms`n"
        output .= "  Read Speed: " Round(fileSizeMB / (readTime / 1000), 2) " MB/s`n`n"
        output .= "First Line: " SubStr(firstLine, 1, 50) "...`n"
        output .= "Last Line: " SubStr(lastLine, 1, 50) "..."

        MsgBox(output, "Large File Read Complete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        ; Cleanup (uncomment to delete)
        ; FileDelete(largeFile)
        MsgBox("Test file kept at:`n" largeFile "`n`nDelete manually when done.", "Cleanup")
    }
}

; ============================================================================
; Example 2: Chunked Reading with FileOpen for Large Files
; ============================================================================

Example2_ChunkedReading() {
    largeFile := A_Temp "\large_test_file.txt"

    ; First create a test file if it doesn't exist
    if !FileExist(largeFile) {
        MsgBox("Creating test file first...", "Setup")
        FileDelete(largeFile)

        Loop 50000 {
            FileAppend("Line " A_Index ": Sample data for chunked reading test.`n", largeFile)

            if Mod(A_Index, 10000) = 0
                ToolTip("Creating: " (A_Index / 500) "%")
        }
        ToolTip()
    }

    try {
        ; Read file in chunks
        chunkSize := 4096  ; 4KB chunks
        totalChunks := 0
        totalBytes := 0

        startTime := A_TickCount

        file := FileOpen(largeFile, "r")

        if !file
            throw Error("Cannot open file")

        ; Get total file size
        file.Seek(0, 2)  ; Seek to end
        fileSize := file.Pos
        file.Seek(0, 0)  ; Seek to beginning

        ; Read in chunks
        progress := ""

        while !file.AtEOF {
            chunk := file.Read(chunkSize)
            totalBytes += StrLen(chunk)
            totalChunks++

            ; Update progress
            if Mod(totalChunks, 100) = 0 {
                percent := Round((totalBytes / fileSize) * 100)
                ToolTip("Reading: " percent "% (" totalChunks " chunks)")
            }
        }

        file.Close()
        ToolTip()

        readTime := A_TickCount - startTime

        output := "Chunked Reading Results:`n`n"
        output .= "File Size: " Round(fileSize / 1024 / 1024, 2) " MB`n"
        output .= "Chunk Size: " chunkSize " bytes`n"
        output .= "Total Chunks: " totalChunks "`n"
        output .= "Total Bytes Read: " totalBytes "`n`n"
        output .= "Performance:`n"
        output .= "  Read Time: " readTime " ms`n"
        output .= "  Speed: " Round((fileSize / 1024 / 1024) / (readTime / 1000), 2) " MB/s"

        MsgBox(output, "Chunked Reading")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 3: Line-by-Line Reading for Memory Efficiency
; ============================================================================

Example3_LineByLineReading() {
    testFile := A_Temp "\line_by_line_test.txt"

    try {
        ; Create test file
        FileDelete(testFile)
        Loop 10000 {
            FileAppend("Line " A_Index ": Sample data with number " (A_Index * 123) "`n", testFile)
        }

        ; Read line by line using Loop Read
        lineCount := 0
        totalChars := 0
        longestLine := ""
        longestLength := 0

        startTime := A_TickCount

        Loop Read, testFile {
            lineCount++
            totalChars += StrLen(A_LoopReadLine)

            if StrLen(A_LoopReadLine) > longestLength {
                longestLength := StrLen(A_LoopReadLine)
                longestLine := A_LoopReadLine
            }

            ; Update progress
            if Mod(lineCount, 1000) = 0
                ToolTip("Processing line " lineCount)
        }

        ToolTip()

        readTime := A_TickCount - startTime

        output := "Line-by-Line Reading Results:`n`n"
        output .= "Total Lines: " lineCount "`n"
        output .= "Total Characters: " totalChars "`n"
        output .= "Average Line Length: " Round(totalChars / lineCount) " chars`n`n"
        output .= "Longest Line:`n"
        output .= "  Length: " longestLength " chars`n"
        output .= "  Content: " longestLine "`n`n"
        output .= "Read Time: " readTime " ms"

        MsgBox(output, "Line-by-Line Reading")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 4: Selective Reading - Reading Specific Sections
; ============================================================================

Example4_SelectiveReading() {
    testFile := A_Temp "\selective_read_test.txt"

    try {
        ; Create a large file with sections
        FileDelete(testFile)

        FileAppend("[HEADER]`n", testFile)
        Loop 100
            FileAppend("Header line " A_Index "`n", testFile)

        FileAppend("`n[DATA]`n", testFile)
        Loop 10000
            FileAppend("Data line " A_Index ": " (A_Index * 456) "`n", testFile)

        FileAppend("`n[FOOTER]`n", testFile)
        Loop 100
            FileAppend("Footer line " A_Index "`n", testFile)

        ; Method 1: Read only specific section using Loop Read
        MsgBox("Reading only DATA section using Loop Read...", "Selective Reading")

        dataLines := []
        inDataSection := false
        startTime := A_TickCount

        Loop Read, testFile {
            if InStr(A_LoopReadLine, "[DATA]") {
                inDataSection := true
                continue
            }

            if InStr(A_LoopReadLine, "[FOOTER]") {
                break
            }

            if inDataSection && Trim(A_LoopReadLine)
                dataLines.Push(A_LoopReadLine)
        }

        loopReadTime := A_TickCount - startTime

        ; Method 2: Read entire file and extract section
        startTime := A_TickCount
        content := FileRead(testFile)

        ; Extract DATA section using RegEx
        if RegExMatch(content, "s)\[DATA\](.*?)\[FOOTER\]", &match) {
            extractedData := match[1]
            extractedLines := StrSplit(Trim(extractedData), "`n")
        }

        fullReadTime := A_TickCount - startTime

        output := "Selective Reading Comparison:`n`n"
        output .= "Method 1 (Loop Read):`n"
        output .= "  Lines Found: " dataLines.Length "`n"
        output .= "  Time: " loopReadTime " ms`n`n"

        output .= "Method 2 (Full Read + Extract):`n"
        output .= "  Lines Found: " extractedLines.Length "`n"
        output .= "  Time: " fullReadTime " ms`n`n"

        output .= "Winner: " (loopReadTime < fullReadTime ? "Loop Read" : "Full Read") "`n`n"

        output .= "Sample Data (first 3 lines):`n"
        Loop Min(3, dataLines.Length)
            output .= dataLines[A_Index] "`n"

        MsgBox(output, "Selective Reading Results")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 5: Memory-Efficient Log File Analysis
; ============================================================================

Example5_LogFileAnalysis() {
    logFile := A_Temp "\large_log_file.log"

    try {
        ; Create a large log file
        MsgBox("Creating large log file (50,000 entries)...", "Setup")

        FileDelete(logFile)
        levels := ["INFO", "WARNING", "ERROR", "DEBUG"]

        Loop 50000 {
            level := levels[Mod(A_Index, 4) + 1]
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            FileAppend(timestamp " [" level "] Message #" A_Index ": Random value " Random(1, 9999) "`n", logFile)

            if Mod(A_Index, 5000) = 0
                ToolTip("Creating log: " (A_Index / 500) "%")
        }
        ToolTip()

        ; Analyze log file without loading entirely into memory
        MsgBox("Analyzing log file using memory-efficient method...", "Analysis")

        stats := Map(
            "total", 0,
            "INFO", 0,
            "WARNING", 0,
            "ERROR", 0,
            "DEBUG", 0
        )

        errors := []
        maxErrors := 10  ; Only keep first 10 errors

        startTime := A_TickCount

        Loop Read, logFile {
            stats["total"]++

            ; Count by level
            for level in levels {
                if InStr(A_LoopReadLine, "[" level "]") {
                    stats[level]++

                    ; Collect ERROR entries (limited)
                    if level = "ERROR" && errors.Length < maxErrors
                        errors.Push(A_LoopReadLine)

                    break
                }
            }

            ; Progress update
            if Mod(stats["total"], 5000) = 0
                ToolTip("Analyzing: " stats["total"] " entries")
        }

        ToolTip()

        analysisTime := A_TickCount - startTime

        output := "Log File Analysis Results:`n`n"
        output .= "Total Entries: " stats["total"] "`n"
        output .= "File Size: " Round(FileGetSize(logFile) / 1024 / 1024, 2) " MB`n`n"

        output .= "Distribution:`n"
        for level in levels {
            percent := Round((stats[level] / stats["total"]) * 100, 1)
            output .= "  " level ": " stats[level] " (" percent "%)`n"
        }

        output .= "`nAnalysis Time: " analysisTime " ms`n"
        output .= "Memory-efficient: YES (line-by-line processing)`n`n"

        output .= "Sample Errors (first 3):`n"
        Loop Min(3, errors.Length)
            output .= errors[A_Index] "`n"

        MsgBox(output, "Log Analysis Complete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        ; Keep file for other examples
        MsgBox("Log file kept at:`n" logFile, "Info")
    }
}

; ============================================================================
; Example 6: Performance Comparison - Different Reading Methods
; ============================================================================

Example6_PerformanceComparison() {
    testFile := A_Temp "\performance_test.txt"

    try {
        ; Create test file
        MsgBox("Creating test file for performance comparison...", "Setup")

        FileDelete(testFile)
        Loop 20000
            FileAppend("Test line " A_Index " with some sample data: " Random(10000, 99999) "`n", testFile)

        fileSize := Round(FileGetSize(testFile) / 1024, 2)

        results := []

        ; Method 1: FileRead (entire file)
        startTime := A_TickCount
        content1 := FileRead(testFile)
        lines1 := StrSplit(content1, "`n")
        time1 := A_TickCount - startTime
        results.Push({method: "FileRead (entire)", time: time1, lines: lines1.Length})

        ; Method 2: Loop Read
        startTime := A_TickCount
        lines2 := []
        Loop Read, testFile
            lines2.Push(A_LoopReadLine)
        time2 := A_TickCount - startTime
        results.Push({method: "Loop Read", time: time2, lines: lines2.Length})

        ; Method 3: FileOpen with chunked reading
        startTime := A_TickCount
        file := FileOpen(testFile, "r")
        lines3 := 0
        while !file.AtEOF {
            line := file.ReadLine()
            lines3++
        }
        file.Close()
        time3 := A_TickCount - startTime
        results.Push({method: "FileOpen + ReadLine", time: time3, lines: lines3})

        ; Method 4: FileRead with limited processing
        startTime := A_TickCount
        content4 := FileRead(testFile)
        lines4 := StrLen(content4) - StrLen(StrReplace(content4, "`n", ""))
        time4 := A_TickCount - startTime
        results.Push({method: "FileRead (count only)", time: time4, lines: lines4})

        ; Display results
        output := "Performance Comparison Results:`n`n"
        output .= "Test File: " fileSize " KB`n`n"

        ; Find fastest
        fastest := results[1]
        for result in results {
            if result.time < fastest.time
                fastest := result
        }

        for result in results {
            marker := (result.method = fastest.method) ? " ★ FASTEST" : ""
            output .= result.method ":" marker "`n"
            output .= "  Time: " result.time " ms`n"
            output .= "  Lines: " result.lines "`n`n"
        }

        output .= "Recommendation:`n"
        output .= "- Small files (< 1MB): Use FileRead`n"
        output .= "- Large files (> 10MB): Use Loop Read`n"
        output .= "- Line processing: Use Loop Read`n"
        output .= "- Binary data: Use FileOpen"

        MsgBox(output, "Performance Comparison")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(testFile)
    }
}

; ============================================================================
; Example 7: Progress Tracking for Large File Operations
; ============================================================================

Example7_ProgressTracking() {
    largeFile := A_Temp "\progress_test.txt"

    try {
        ; Create test file
        MsgBox("Creating large file with progress tracking...", "Setup")

        CreateFileWithProgress(largeFile, 30000)

        ; Read file with progress tracking
        MsgBox("Reading file with progress tracking...", "Reading")

        result := ReadFileWithProgress(largeFile)

        output := "Progress Tracking Results:`n`n"
        output .= "File Size: " Round(result.size / 1024, 2) " KB`n"
        output .= "Lines Read: " result.lines "`n"
        output .= "Read Time: " result.time " ms`n"
        output .= "Average Speed: " Round(result.lines / (result.time / 1000)) " lines/sec"

        MsgBox(output, "Progress Tracking Complete")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(largeFile)
    }

    ; Create file with progress
    CreateFileWithProgress(filePath, totalLines) {
        FileDelete(filePath)

        Loop totalLines {
            FileAppend("Line " A_Index ": Sample data`n", filePath)

            if Mod(A_Index, 1000) = 0 {
                percent := Round((A_Index / totalLines) * 100)
                ToolTip("Creating file: " percent "% (" A_Index "/" totalLines ")")
            }
        }

        ToolTip()
    }

    ; Read file with progress
    ReadFileWithProgress(filePath) {
        startTime := A_TickCount
        lineCount := 0
        fileSize := FileGetSize(filePath)

        Loop Read, filePath {
            lineCount++

            if Mod(lineCount, 1000) = 0 {
                percent := Round((A_Index / 30000) * 100)  ; Approximate
                ToolTip("Reading: " percent "% (" lineCount " lines)")
            }
        }

        ToolTip()

        return {
            lines: lineCount,
            size: fileSize,
            time: A_TickCount - startTime
        }
    }
}

; ============================================================================
; Run Examples
; ============================================================================

; Uncomment to run individual examples:
; Example1_CreateLargeFile()
; Example2_ChunkedReading()
; Example3_LineByLineReading()
; Example4_SelectiveReading()
; Example5_LogFileAnalysis()
; Example6_PerformanceComparison()
; Example7_ProgressTracking()

; Run all examples
RunAllExamples() {
    examples := [
        {name: "Create & Read Large File", func: Example1_CreateLargeFile},
        {name: "Chunked Reading", func: Example2_ChunkedReading},
        {name: "Line-by-Line Reading", func: Example3_LineByLineReading},
        {name: "Selective Reading", func: Example4_SelectiveReading},
        {name: "Log File Analysis", func: Example5_LogFileAnalysis},
        {name: "Performance Comparison", func: Example6_PerformanceComparison},
        {name: "Progress Tracking", func: Example7_ProgressTracking}
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "Large File Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}

; Uncomment to run all examples interactively:
; RunAllExamples()
