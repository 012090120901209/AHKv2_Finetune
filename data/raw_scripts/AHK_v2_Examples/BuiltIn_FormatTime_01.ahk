#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FormatTime Function - Basic Date and Time Formatting
 * ============================================================================
 *
 * This script demonstrates basic usage of the FormatTime() function in AHK v2.
 * FormatTime() converts timestamps to formatted date/time strings using
 * customizable format patterns.
 *
 * @description Basic FormatTime() usage for date and time formatting
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Common Format Specifiers:
 * - yyyy = 4-digit year
 * - yy = 2-digit year
 * - MM = 2-digit month
 * - MMM = Abbreviated month name
 * - MMMM = Full month name
 * - dd = 2-digit day
 * - ddd = Abbreviated day name
 * - dddd = Full day name
 * - HH = 24-hour format hour
 * - hh = 12-hour format hour
 * - mm = Minutes
 * - ss = Seconds
 * - tt = AM/PM
 */

; ============================================================================
; Example 1: Basic Date Formats
; ============================================================================

/**
 * Demonstrates common date format patterns.
 * Common use: Date displays, reports, file naming
 */
Example1_BasicDateFormats() {
    output := "=== Example 1: Basic Date Formats ===`n`n"
    output .= "Current Date in Various Formats:`n`n"

    ; Get current timestamp
    now := A_Now

    ; Common date formats
    formats := Map(
        "ISO 8601 (Standard)", "yyyy-MM-dd",
        "US Format", "MM/dd/yyyy",
        "European Format", "dd/MM/yyyy",
        "Long Date", "MMMM dd, yyyy",
        "Short Date", "MMM dd, yy",
        "Day and Date", "dddd, MMMM dd, yyyy",
        "Compact Format", "yyyyMMdd",
        "Month Year", "MMMM yyyy",
        "Year only", "yyyy",
        "Slash Format", "MM/dd/yy"
    )

    for name, pattern in formats {
        formatted := FormatTime(now, pattern)
        output .= Format("{:-25s}: {:s}", name, formatted) . "`n"
    }

    ; Custom formats
    output .= "`n`nCustom Date Formats:`n"
    output .= "Year-Month: " . FormatTime(now, "yyyy-MM") . "`n"
    output .= "Month/Day: " . FormatTime(now, "MM/dd") . "`n"
    output .= "Full spelled: " . FormatTime(now, "dddd 'the' dd 'of' MMMM, yyyy") . "`n"
    output .= "With ordinal: " . FormatTime(now, "MMMM dd'th', yyyy") . "`n"

    MsgBox(output, "Basic Date Formats", 262144)
}

; ============================================================================
; Example 2: Basic Time Formats
; ============================================================================

/**
 * Shows various time format patterns.
 * Common use: Timestamps, logs, scheduling
 */
Example2_BasicTimeFormats() {
    output := "=== Example 2: Basic Time Formats ===`n`n"
    output .= "Current Time in Various Formats:`n`n"

    now := A_Now

    ; Time formats
    formats := Map(
        "24-hour (HH:mm:ss)", "HH:mm:ss",
        "24-hour (HH:mm)", "HH:mm",
        "12-hour (hh:mm:ss tt)", "hh:mm:ss tt",
        "12-hour (hh:mm tt)", "hh:mm tt",
        "Hour only (24h)", "HH",
        "Hour only (12h)", "hh tt",
        "Compact (HHmmss)", "HHmmss",
        "Hour:Minute", "HH:mm"
    )

    for name, pattern in formats {
        formatted := FormatTime(now, pattern)
        output .= Format("{:-25s}: {:s}", name, formatted) . "`n"
    }

    ; Combined date and time
    output .= "`n`nCombined Date and Time:`n"
    output .= "ISO 8601: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "US Format: " . FormatTime(now, "MM/dd/yyyy hh:mm:ss tt") . "`n"
    output .= "European: " . FormatTime(now, "dd/MM/yyyy HH:mm:ss") . "`n"
    output .= "Long Format: " . FormatTime(now, "dddd, MMMM dd, yyyy 'at' hh:mm tt") . "`n"
    output .= "Compact: " . FormatTime(now, "yyyyMMdd_HHmmss") . "`n"

    MsgBox(output, "Basic Time Formats", 262144)
}

; ============================================================================
; Example 3: Timestamp Generator for Various Uses
; ============================================================================

/**
 * Generates timestamps for different purposes.
 * Common use: Logging, file naming, database entries
 */
Example3_TimestampGenerator() {
    output := "=== Example 3: Timestamp Generator ===`n`n"

    now := A_Now

    ; Log file timestamps
    output .= "Log File Timestamps:`n"
    output .= "  Standard Log: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "  Compact Log: " . FormatTime(now, "yyyyMMdd_HHmmss") . "`n"
    output .= "  Daily Log File: app_" . FormatTime(now, "yyyy-MM-dd") . ".log`n"
    output .= "  Hourly Log File: app_" . FormatTime(now, "yyyy-MM-dd_HH") . "00.log`n`n"

    ; File naming
    output .= "File Naming Conventions:`n"
    output .= "  Backup File: backup_" . FormatTime(now, "yyyyMMdd_HHmmss") . ".zip`n"
    output .= "  Report File: report_" . FormatTime(now, "yyyy-MM") . ".xlsx`n"
    output .= "  Screenshot: screenshot_" . FormatTime(now, "yyyyMMdd_HHmmss") . ".png`n"
    output .= "  Data Export: data_" . FormatTime(now, "yyyy-MM-dd") . ".csv`n`n"

    ; Database timestamps
    output .= "Database Timestamps:`n"
    output .= "  MySQL/PostgreSQL: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "  ISO 8601: " . FormatTime(now, "yyyy-MM-dd'T'HH:mm:ss") . "`n"
    output .= "  Unix-style: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n`n"

    ; Human-readable
    output .= "Human-Readable Formats:`n"
    output .= "  Full: " . FormatTime(now, "dddd, MMMM dd, yyyy 'at' hh:mm tt") . "`n"
    output .= "  Casual: " . FormatTime(now, "MMM dd, yyyy 'at' hh:mm tt") . "`n"
    output .= "  Short: " . FormatTime(now, "MM/dd/yy hh:mm tt") . "`n"

    MsgBox(output, "Timestamp Generator", 262144)
}

; ============================================================================
; Example 4: Calendar and Schedule Formatting
; ============================================================================

/**
 * Creates formatted calendar views and schedules.
 * Common use: Calendar displays, scheduling apps, reminders
 */
Example4_CalendarFormatting() {
    ; Get current month info
    now := A_Now
    currentMonth := FormatTime(now, "MMMM yyyy")
    currentDay := FormatTime(now, "dd")

    ; Create a simple month view
    output := "=== Example 4: Calendar Formatting ===`n`n"
    output .= Format("{:^50s}", currentMonth) . "`n"
    output .= Format("{:^50s}", StrReplace(Format("{:50s}", ""), " ", "─")) . "`n`n"

    ; Week headers
    output .= Format("{:^7s} {:^7s} {:^7s} {:^7s} {:^7s} {:^7s} {:^7s}",
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat") . "`n"
    output .= StrReplace(Format("{:50s}", ""), " ", "─") . "`n"

    ; Sample schedule for today
    output .= "`n`nToday's Schedule (" . FormatTime(now, "dddd, MMMM dd") . "):`n"
    output .= StrReplace(Format("{:50s}", ""), " ", "─") . "`n"

    schedule := [
        {time: "09:00", event: "Team Meeting", duration: "1 hour"},
        {time: "10:30", event: "Project Review", duration: "45 mins"},
        {time: "13:00", event: "Lunch Break", duration: "1 hour"},
        {time: "14:00", event: "Client Call", duration: "30 mins"},
        {time: "16:00", event: "Code Review", duration: "1 hour"}
    ]

    for item in schedule {
        output .= Format("{:5s} - {:-30s} ({:s})",
            item.time,
            item.event,
            item.duration) . "`n"
    }

    ; Week view
    output .= "`n`nThis Week:`n"
    output .= StrReplace(Format("{:50s}", ""), " ", "─") . "`n"

    ; Calculate start of week (Sunday)
    dayOfWeek := FormatTime(now, "w")  ; 1=Sunday, 7=Saturday
    daysToSubtract := dayOfWeek - 1

    loop 7 {
        dayOffset := A_Index - 1 - daysToSubtract
        currentDate := DateAdd(now, dayOffset, "days")
        dayName := FormatTime(currentDate, "ddd")
        dateStr := FormatTime(currentDate, "MM/dd")
        isToday := FormatTime(currentDate, "yyyyMMdd") = FormatTime(now, "yyyyMMdd")

        marker := isToday ? "►" : " "
        output .= Format("{:s} {:-3s} {:s}",
            marker,
            dayName,
            dateStr) . "`n"
    }

    MsgBox(output, "Calendar Formatting", 262144)
}

; ============================================================================
; Example 5: Log Entry Formatter
; ============================================================================

/**
 * Formats log entries with timestamps and levels.
 * Common use: Application logging, debugging, audit trails
 */
Example5_LogFormatter() {
    ; Create formatted log entry
    FormatLogEntry(level, message, component := "") {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        levelStr := Format("[{:-8s}]", level)
        componentStr := component != "" ? Format("[{:s}]", component) : ""

        return Format("{:s} {:s} {:s} {:s}",
            timestamp,
            levelStr,
            componentStr,
            message)
    }

    output := "=== Example 5: Log Entry Formatter ===`n`n"
    output .= "Application Log Entries:`n"
    output .= StrReplace(Format("{:80s}", ""), " ", "═") . "`n`n"

    ; Simulate log entries at different times
    baseTime := A_Now

    logs := [
        {time: baseTime, level: "INFO", component: "App", message: "Application started"},
        {time: DateAdd(baseTime, 1, "seconds"), level: "INFO", component: "Database", message: "Connected to database"},
        {time: DateAdd(baseTime, 5, "seconds"), level: "DEBUG", component: "API", message: "Processing request /api/users"},
        {time: DateAdd(baseTime, 7, "seconds"), level: "WARN", component: "Cache", message: "Cache miss rate above threshold"},
        {time: DateAdd(baseTime, 10, "seconds"), level: "ERROR", component: "FileIO", message: "Failed to write to file"},
        {time: DateAdd(baseTime, 12, "seconds"), level: "INFO", component: "App", message: "Request completed successfully"}
    ]

    for log in logs {
        timestamp := FormatTime(log.time, "yyyy-MM-dd HH:mm:ss")
        entry := Format("{:s} [{:-8s}] [{:-10s}] {:s}",
            timestamp,
            log.level,
            log.component,
            log.message)
        output .= entry . "`n"
    }

    ; Different log formats
    output .= "`n`nAlternative Log Formats:`n"
    output .= StrReplace(Format("{:80s}", ""), " ", "─") . "`n`n"

    now := A_Now

    output .= "Compact Format:`n"
    output .= FormatTime(now, "yyyyMMdd HHmmss") . " [INFO] Message here`n`n"

    output .= "ISO 8601 Format:`n"
    output .= FormatTime(now, "yyyy-MM-dd'T'HH:mm:ss") . " [INFO] Message here`n`n"

    output .= "Human-Readable Format:`n"
    output .= FormatTime(now, "MMM dd, yyyy 'at' hh:mm:ss tt") . " - INFO - Message here`n`n"

    output .= "Unix-style Format:`n"
    output .= FormatTime(now, "MMM dd HH:mm:ss") . " hostname app[1234]: Message here`n"

    MsgBox(output, "Log Formatter", 262144)
}

; ============================================================================
; Example 6: Time-Based File Organizer
; ============================================================================

/**
 * Demonstrates organizing files by date using FormatTime.
 * Common use: File management, backup organization, archiving
 */
Example6_FileOrganizer() {
    output := "=== Example 6: Time-Based File Organization ===`n`n"

    now := A_Now

    ; Organize by year/month/day
    output .= "Hierarchical Organization:`n"
    output .= "Root Folder/`n"
    output .= "  " . FormatTime(now, "yyyy") . "/`n"
    output .= "    " . FormatTime(now, "MM - MMMM") . "/`n"
    output .= "      " . FormatTime(now, "dd - dddd") . "/`n"
    output .= "        file_" . FormatTime(now, "HHmmss") . ".txt`n`n"

    ; Archive structure
    output .= "Archive Structure:`n"
    output .= "Archives/`n"
    output .= "  " . FormatTime(now, "yyyy") . "/`n"
    output .= "    Q" . Format("{:d}", Ceil(Integer(FormatTime(now, "MM")) / 3)) . "/`n"
    output .= "      " . FormatTime(now, "MMMM") . "/`n"
    output .= "        archive_" . FormatTime(now, "yyyy-MM-dd") . ".zip`n`n"

    ; Backup naming
    output .= "Backup File Names:`n"
    output .= "  Daily: backup_" . FormatTime(now, "yyyy-MM-dd") . ".bak`n"
    output .= "  Weekly: backup_" . FormatTime(now, "yyyy") . "_W" . FormatTime(now, "ww") . ".bak`n"
    output .= "  Monthly: backup_" . FormatTime(now, "yyyy-MM") . ".bak`n"
    output .= "  Full: backup_full_" . FormatTime(now, "yyyyMMdd_HHmmss") . ".bak`n`n"

    ; Log rotation
    output .= "Log File Rotation:`n"
    output .= "  Current: application.log`n"
    output .= "  Rotated: application_" . FormatTime(now, "yyyy-MM-dd") . ".log`n"
    output .= "  Archived: logs_" . FormatTime(now, "yyyy-MM") . ".zip`n"

    MsgBox(output, "File Organization", 262144)
}

; ============================================================================
; Example 7: Report Header Generator
; ============================================================================

/**
 * Generates formatted report headers with timestamps.
 * Common use: Business reports, analytics, documentation
 */
Example7_ReportHeaders() {
    ; Generate report header
    GenerateReportHeader(title, reportType := "Standard") {
        now := A_Now
        header := ""
        width := 70

        ; Box top
        header .= "╔" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "═") . "╗`n"

        ; Title
        header .= "║" . Format("{:^" . (width - 2) . "s}", title) . "║`n"

        ; Report type
        header .= "║" . Format("{:^" . (width - 2) . "s}", reportType . " Report") . "║`n"

        ; Separator
        header .= "╠" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "═") . "╣`n"

        ; Date information
        header .= "║ " . Format("Generated: {:-" . (width - 15) . "s}", FormatTime(now, "dddd, MMMM dd, yyyy")) . " ║`n"
        header .= "║ " . Format("Time:      {:-" . (width - 15) . "s}", FormatTime(now, "hh:mm:ss tt")) . " ║`n"

        ; Box bottom
        header .= "╚" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "═") . "╝"

        return header
    }

    output := "=== Example 7: Report Headers ===`n`n"

    ; Sales Report
    output .= GenerateReportHeader("MONTHLY SALES REPORT", "Executive") . "`n`n`n"

    ; Financial Report
    output .= GenerateReportHeader("QUARTERLY FINANCIAL SUMMARY", "Financial") . "`n`n`n"

    ; Custom header with additional info
    now := A_Now
    customHeader := ""
    customHeader .= "═══════════════════════════════════════════════════════`n"
    customHeader .= Format("{:^55s}", "SYSTEM STATUS REPORT") . "`n"
    customHeader .= "═══════════════════════════════════════════════════════`n"
    customHeader .= Format("Report Date:     {:s}", FormatTime(now, "MMMM dd, yyyy")) . "`n"
    customHeader .= Format("Report Time:     {:s}", FormatTime(now, "hh:mm:ss tt")) . "`n"
    customHeader .= Format("Period:          {:s}", FormatTime(now, "MMMM yyyy")) . "`n"
    customHeader .= Format("Generated By:    System Administrator") . "`n"
    customHeader .= "═══════════════════════════════════════════════════════`n"

    output .= customHeader

    MsgBox(output, "Report Headers", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
    (
    FormatTime() - Basic Date/Time Formatting

    Examples:
    1. Basic Date Formats
    2. Basic Time Formats
    3. Timestamp Generator
    4. Calendar Formatting
    5. Log Entry Formatter
    6. File Organization
    7. Report Headers

    Press Ctrl+1-7 to run examples
    )"
    MsgBox(menu, "FormatTime Examples", 4096)
}

^1::Example1_BasicDateFormats()
^2::Example2_BasicTimeFormats()
^3::Example3_TimestampGenerator()
^4::Example4_CalendarFormatting()
^5::Example5_LogFormatter()
^6::Example6_FileOrganizer()
^7::Example7_ReportHeaders()
^m::ShowMenu()

ShowMenu()
