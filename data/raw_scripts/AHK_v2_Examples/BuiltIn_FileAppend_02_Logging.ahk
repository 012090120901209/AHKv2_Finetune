#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FileAppend - Logging Systems and Techniques
 * ============================================================================
 *
 * Demonstrates logging patterns and techniques:
 * - Application event logging
 * - Error and debug logging
 * - Rotating log files
 * - Log levels and filtering
 * - Structured logging
 * - Performance logging
 *
 * @description Logging system examples using FileAppend
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileAppend.htm
 */

; ============================================================================
; Example 1: Basic Application Logger
; ============================================================================

Example1_BasicLogger() {
    logFile := A_Temp "\app_log.txt"

    try {
        ; Initialize log file
        FileDelete(logFile)

        ; Create logger instance
        logger := CreateLogger(logFile)

        ; Log different events
        logger.Info("Application started")
        logger.Info("Loading configuration from config.ini")
        logger.Warning("Configuration file not found, using defaults")
        logger.Info("Initializing database connection")
        logger.Error("Database connection failed: Timeout after 30 seconds")
        logger.Debug("Connection string: localhost:3306/mydb")
        logger.Info("Retrying connection...")
        logger.Info("Database connection successful")
        logger.Info("Application ready")

        ; Display log
        content := FileRead(logFile)
        MsgBox(content, "Application Log")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }

    ; Logger factory function
    CreateLogger(logPath) {
        logger := {}

        logger.logFile := logPath

        logger.Log := (level, message) {
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            entry := timestamp " [" level "] " message "`n"
            FileAppend(entry, this.logFile)
        }

        logger.Info := (message) => logger.Log("INFO", message)
        logger.Warning := (message) => logger.Log("WARNING", message)
        logger.Error := (message) => logger.Log("ERROR", message)
        logger.Debug := (message) => logger.Log("DEBUG", message)

        return logger
    }
}

; ============================================================================
; Example 2: Logger with Log Levels
; ============================================================================

Example2_LogLevels() {
    logFile := A_Temp "\leveled_log.txt"

    try {
        ; Test different log levels
        levels := ["DEBUG", "INFO", "WARNING", "ERROR"]

        for minLevel in levels {
            FileDelete(logFile)

            logger := CreateLeveledLogger(logFile, minLevel)

            ; Try logging at all levels
            logger.Debug("This is a debug message")
            logger.Info("This is an info message")
            logger.Warning("This is a warning message")
            logger.Error("This is an error message")

            ; Display results
            content := FileRead(logFile)
            output := "Minimum Log Level: " minLevel "`n`n"
            output .= "Logged Messages:`n" content

            MsgBox(output, "Log Level: " minLevel)
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }

    ; Create logger with level filtering
    CreateLeveledLogger(logPath, minLevel := "INFO") {
        ; Define level priorities
        priorities := Map(
            "DEBUG", 0,
            "INFO", 1,
            "WARNING", 2,
            "ERROR", 3
        )

        logger := {}
        logger.logFile := logPath
        logger.minLevel := minLevel
        logger.minPriority := priorities[minLevel]

        logger.Log := (level, message) {
            if priorities[level] >= this.minPriority {
                timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
                entry := timestamp " [" level "] " message "`n"
                FileAppend(entry, this.logFile)
            }
        }

        logger.Debug := (message) => logger.Log("DEBUG", message)
        logger.Info := (message) => logger.Log("INFO", message)
        logger.Warning := (message) => logger.Log("WARNING", message)
        logger.Error := (message) => logger.Log("ERROR", message)

        return logger
    }
}

; ============================================================================
; Example 3: Rotating Log Files
; ============================================================================

Example3_RotatingLogs() {
    logDir := A_Temp "\rotating_logs"

    try {
        ; Create log directory
        if !DirExist(logDir)
            DirCreate(logDir)

        ; Create rotating logger
        logger := CreateRotatingLogger(logDir, "app.log", 1024)  ; 1KB max size

        ; Generate log entries until rotation occurs
        Loop 50 {
            logger.Info("Log entry number " A_Index " with some additional text to increase file size")
            Sleep(10)
        }

        ; List all log files created
        output := "Rotating Log Files:`n`n"

        Loop Files, logDir "\*.log" {
            output .= A_LoopFileName "`n"
            output .= "  Size: " A_LoopFileSize " bytes`n"
            output .= "  Created: " FormatTime(A_LoopFileTimeCreated, "yyyy-MM-dd HH:mm:ss") "`n`n"
        }

        MsgBox(output, "Log Rotation")

        ; Show content of latest log
        latestLog := logDir "\app.log"
        if FileExist(latestLog) {
            content := FileRead(latestLog)
            MsgBox("Latest Log File Content:`n`n" content, "Current Log")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(logDir)
            DirDelete(logDir, true)
    }

    ; Create rotating logger
    CreateRotatingLogger(logDir, fileName, maxSize := 10240) {
        logger := {}
        logger.logDir := logDir
        logger.fileName := fileName
        logger.maxSize := maxSize
        logger.currentLog := logDir "\" fileName

        logger.Rotate := () {
            ; Check if rotation needed
            if !FileExist(this.currentLog)
                return

            if FileGetSize(this.currentLog) < this.maxSize
                return

            ; Find next available backup number
            backupNum := 1
            loop {
                backupPath := this.logDir "\" SubStr(this.fileName, 1, -4) "_" backupNum ".log"
                if !FileExist(backupPath)
                    break
                backupNum++
            }

            ; Rename current log
            FileMove(this.currentLog, backupPath)
        }

        logger.Info := (message) {
            this.Rotate()

            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            entry := timestamp " [INFO] " message "`n"
            FileAppend(entry, this.currentLog)
        }

        return logger
    }
}

; ============================================================================
; Example 4: Structured Logging with Context
; ============================================================================

Example4_StructuredLogging() {
    logFile := A_Temp "\structured_log.txt"

    try {
        FileDelete(logFile)

        ; Create structured logger
        logger := CreateStructuredLogger(logFile)

        ; Log with context
        logger.Log("INFO", "User login", Map(
            "username", "john_doe",
            "ip_address", "192.168.1.100",
            "session_id", "abc123xyz"
        ))

        logger.Log("WARNING", "High memory usage", Map(
            "memory_used_mb", 850,
            "memory_total_mb", 1024,
            "threshold_percent", 80
        ))

        logger.Log("ERROR", "Database query failed", Map(
            "query", "SELECT * FROM users",
            "error_code", 1064,
            "error_msg", "Syntax error",
            "retry_count", 3
        ))

        logger.Log("INFO", "File uploaded", Map(
            "filename", "document.pdf",
            "size_bytes", 2048576,
            "upload_time_ms", 1250
        ))

        ; Display log
        content := FileRead(logFile)
        MsgBox(content, "Structured Log")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }

    ; Create structured logger
    CreateStructuredLogger(logPath) {
        logger := {}
        logger.logFile := logPath

        logger.Log := (level, message, context := "") {
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

            ; Build log entry
            entry := timestamp " [" level "] " message

            ; Add context if provided
            if IsObject(context) {
                contextStr := ""
                for key, value in context {
                    contextStr .= key "=" value " "
                }
                entry .= " | " Trim(contextStr)
            }

            entry .= "`n"

            FileAppend(entry, this.logFile)
        }

        return logger
    }
}

; ============================================================================
; Example 5: Performance Logging
; ============================================================================

Example5_PerformanceLogging() {
    logFile := A_Temp "\performance_log.txt"

    try {
        FileDelete(logFile)

        ; Create performance logger
        logger := CreatePerformanceLogger(logFile)

        ; Track different operations
        logger.StartOperation("Database Query")
        Sleep(150)
        logger.EndOperation("Database Query")

        logger.StartOperation("File Processing")
        Sleep(250)
        logger.EndOperation("File Processing")

        logger.StartOperation("Data Validation")
        Sleep(100)
        logger.EndOperation("Data Validation")

        logger.StartOperation("Report Generation")
        Sleep(300)
        logger.EndOperation("Report Generation")

        ; Show log
        content := FileRead(logFile)
        MsgBox(content, "Performance Log")

        ; Show summary
        summary := logger.GetSummary()
        MsgBox(summary, "Performance Summary")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(logFile)
    }

    ; Create performance logger
    CreatePerformanceLogger(logPath) {
        logger := {}
        logger.logFile := logPath
        logger.operations := Map()
        logger.timings := []

        logger.StartOperation := (name) {
            this.operations[name] := A_TickCount
        }

        logger.EndOperation := (name) {
            if !this.operations.Has(name)
                return

            startTime := this.operations[name]
            duration := A_TickCount - startTime

            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            entry := timestamp " [PERF] " name ": " duration " ms`n"
            FileAppend(entry, this.logFile)

            this.timings.Push({name: name, duration: duration})
            this.operations.Delete(name)
        }

        logger.GetSummary := () {
            if this.timings.Length = 0
                return "No performance data"

            summary := "Performance Summary:`n`n"

            total := 0
            for timing in this.timings {
                summary .= timing.name ": " timing.duration " ms`n"
                total += timing.duration
            }

            summary .= "`nTotal Time: " total " ms"
            summary .= "`nAverage Time: " Round(total / this.timings.Length) " ms"

            return summary
        }

        return logger
    }
}

; ============================================================================
; Example 6: Daily Log Files
; ============================================================================

Example6_DailyLogs() {
    logDir := A_Temp "\daily_logs"

    try {
        ; Create log directory
        if !DirExist(logDir)
            DirCreate(logDir)

        ; Create daily logger
        logger := CreateDailyLogger(logDir)

        ; Log some events
        logger.Info("Application started")
        logger.Info("Processing batch job #1")
        logger.Warning("Low disk space warning")
        logger.Info("Batch job #1 completed")
        logger.Info("Application shutdown")

        ; Show today's log file
        todayLog := logger.GetTodayLogPath()

        if FileExist(todayLog) {
            content := FileRead(todayLog)
            output := "Today's Log File:`n" todayLog "`n`n" content
            MsgBox(output, "Daily Log")
        }

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(logDir)
            DirDelete(logDir, true)
    }

    ; Create daily logger
    CreateDailyLogger(logDir) {
        logger := {}
        logger.logDir := logDir

        logger.GetTodayLogPath := () {
            dateStr := FormatTime(, "yyyy-MM-dd")
            return this.logDir "\app_" dateStr ".log"
        }

        logger.Log := (level, message) {
            logFile := this.GetTodayLogPath()
            timestamp := FormatTime(, "HH:mm:ss")
            entry := timestamp " [" level "] " message "`n"
            FileAppend(entry, logFile)
        }

        logger.Info := (message) => logger.Log("INFO", message)
        logger.Warning := (message) => logger.Log("WARNING", message)
        logger.Error := (message) => logger.Log("ERROR", message)

        return logger
    }
}

; ============================================================================
; Example 7: Multi-File Logging (Separate files per level)
; ============================================================================

Example7_MultiFileLogging() {
    logDir := A_Temp "\multi_logs"

    try {
        ; Create log directory
        if !DirExist(logDir)
            DirCreate(logDir)

        ; Create multi-file logger
        logger := CreateMultiFileLogger(logDir)

        ; Log at different levels
        logger.Info("Application initialized")
        logger.Info("Loading user preferences")
        logger.Debug("User ID: 12345")
        logger.Debug("Session token: abc123")
        logger.Warning("Cache miss for user preferences")
        logger.Info("Using default preferences")
        logger.Error("Failed to save preferences")
        logger.Error("Disk write error: Permission denied")
        logger.Info("Preferences saved to memory cache")

        ; Show all log files
        output := "Log Files Created:`n`n"

        Loop Files, logDir "\*.log" {
            output .= A_LoopFileName ":`n"
            content := FileRead(A_LoopFilePath)
            output .= content "`n"
            output .= StrReplace(Format("{:60}", ""), " ", "-") "`n`n"
        }

        MsgBox(output, "Multi-File Logging")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(logDir)
            DirDelete(logDir, true)
    }

    ; Create multi-file logger
    CreateMultiFileLogger(logDir) {
        logger := {}
        logger.logDir := logDir
        logger.files := Map(
            "DEBUG", logDir "\debug.log",
            "INFO", logDir "\info.log",
            "WARNING", logDir "\warning.log",
            "ERROR", logDir "\error.log"
        )

        logger.Log := (level, message) {
            if !this.files.Has(level)
                return

            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            entry := timestamp " " message "`n"

            ; Also log to combined file
            FileAppend(timestamp " [" level "] " message "`n", this.logDir "\combined.log")

            ; Log to level-specific file
            FileAppend(entry, this.files[level])
        }

        logger.Info := (message) => logger.Log("INFO", message)
        logger.Debug := (message) => logger.Log("DEBUG", message)
        logger.Warning := (message) => logger.Log("WARNING", message)
        logger.Error := (message) => logger.Log("ERROR", message)

        return logger
    }
}

; ============================================================================
; Run Examples
; ============================================================================

; Uncomment to run individual examples:
; Example1_BasicLogger()
; Example2_LogLevels()
; Example3_RotatingLogs()
; Example4_StructuredLogging()
; Example5_PerformanceLogging()
; Example6_DailyLogs()
; Example7_MultiFileLogging()

; Run all examples
RunAllExamples() {
    examples := [
        {name: "Basic Logger", func: Example1_BasicLogger},
        {name: "Log Levels", func: Example2_LogLevels},
        {name: "Rotating Logs", func: Example3_RotatingLogs},
        {name: "Structured Logging", func: Example4_StructuredLogging},
        {name: "Performance Logging", func: Example5_PerformanceLogging},
        {name: "Daily Logs", func: Example6_DailyLogs},
        {name: "Multi-File Logging", func: Example7_MultiFileLogging}
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "Logging Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}

; Uncomment to run all examples interactively:
; RunAllExamples()
