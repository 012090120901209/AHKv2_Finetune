#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FormatTime Function - Advanced Time Operations and Custom Locales
 * ============================================================================
 *
 * This script demonstrates advanced FormatTime() operations including
 * custom locale handling, complex date calculations, and specialized
 * formatting scenarios.
 *
 * @description Advanced FormatTime() operations and locale handling
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Advanced Topics:
 * - Relative time formatting
 * - Human-readable time differences
 * - Custom calendar systems
 * - Advanced date arithmetic with formatting
 * - International date line considerations
 */

; ============================================================================
; Example 1: Relative Time Formatting
; ============================================================================

/**
 * Formats times relative to current time (ago, from now).
 * Common use: Social media, activity feeds, notifications
 */
Example1_RelativeTime() {
    ; Format relative time
    FormatRelativeTime(timestamp) {
        now := A_Now
        diffSeconds := DateDiff(now, timestamp, "seconds")

        if (diffSeconds < 0) {
            ; Future time
            diffSeconds := -diffSeconds
            if (diffSeconds < 60)
                return "in " . diffSeconds . " seconds"
            else if (diffSeconds < 3600)
                return "in " . Floor(diffSeconds / 60) . " minutes"
            else if (diffSeconds < 86400)
                return "in " . Floor(diffSeconds / 3600) . " hours"
            else
                return "in " . Floor(diffSeconds / 86400) . " days"
        } else {
            ; Past time
            if (diffSeconds < 60)
                return diffSeconds . " seconds ago"
            else if (diffSeconds < 3600)
                return Floor(diffSeconds / 60) . " minutes ago"
            else if (diffSeconds < 86400)
                return Floor(diffSeconds / 3600) . " hours ago"
            else if (diffSeconds < 604800)
                return Floor(diffSeconds / 86400) . " days ago"
            else if (diffSeconds < 2592000)
                return Floor(diffSeconds / 604800) . " weeks ago"
            else if (diffSeconds < 31536000)
                return Floor(diffSeconds / 2592000) . " months ago"
            else
                return Floor(diffSeconds / 31536000) . " years ago"
        }
    }

    output := "=== Example 1: Relative Time Formatting ===`n`n"

    ; Past times
    output .= "Recent Activity:`n"
    times := [
        {time: DateAdd(A_Now, -30, "seconds"), action: "User logged in"},
        {time: DateAdd(A_Now, -15, "minutes"), action: "New comment posted"},
        {time: DateAdd(A_Now, -2, "hours"), action: "File uploaded"},
        {time: DateAdd(A_Now, -1, "days"), action: "Profile updated"},
        {time: DateAdd(A_Now, -7, "days"), action: "Account created"}
    ]

    for item in times {
        relTime := FormatRelativeTime(item.time)
        absTime := FormatTime(item.time, "MMM dd 'at' h:mm tt")
        output .= Format("  {:-25s} {:s} ({:s})",
            item.action,
            relTime,
            absTime) . "`n"
    }

    ; Future times
    output .= "`n`nUpcoming Events:`n"
    futureEvents := [
        {time: DateAdd(A_Now, 30, "minutes"), event: "Meeting starts"},
        {time: DateAdd(A_Now, 4, "hours"), event: "Deadline"},
        {time: DateAdd(A_Now, 2, "days"), event: "Presentation"}
    ]

    for event in futureEvents {
        relTime := FormatRelativeTime(event.time)
        absTime := FormatTime(event.time, "MMM dd 'at' h:mm tt")
        output .= Format("  {:-25s} {:s} ({:s})",
            event.event,
            relTime,
            absTime) . "`n"
    }

    MsgBox(output, "Relative Time", 262144)
}

; ============================================================================
; Example 2: Human-Readable Duration Formatting
; ============================================================================

/**
 * Formats durations in human-readable form.
 * Common use: Time tracking, session duration, elapsed time
 */
Example2_DurationFormatting() {
    ; Format duration in human readable form
    FormatDuration(seconds, detailed := false) {
        if (seconds < 60) {
            return seconds . " second" . (seconds != 1 ? "s" : "")
        }

        minutes := Floor(seconds / 60)
        hours := Floor(minutes / 60)
        days := Floor(hours / 24)

        if (detailed) {
            ; Detailed breakdown
            parts := []
            if (days > 0)
                parts.Push(days . " day" . (days != 1 ? "s" : ""))
            if (Mod(hours, 24) > 0)
                parts.Push(Mod(hours, 24) . " hour" . (Mod(hours, 24) != 1 ? "s" : ""))
            if (Mod(minutes, 60) > 0)
                parts.Push(Mod(minutes, 60) . " minute" . (Mod(minutes, 60) != 1 ? "s" : ""))
            if (Mod(seconds, 60) > 0)
                parts.Push(Mod(seconds, 60) . " second" . (Mod(seconds, 60) != 1 ? "s" : ""))

            result := ""
            for i, part in parts {
                result .= part
                if (i < parts.Length - 1)
                    result .= ", "
                else if (i = parts.Length - 1)
                    result .= " and "
            }
            return result
        } else {
            ; Compact form
            if (days > 0)
                return days . " day" . (days != 1 ? "s" : "")
            else if (hours > 0)
                return hours . " hour" . (hours != 1 ? "s" : "")
            else
                return minutes . " minute" . (minutes != 1 ? "s" : "")
        }
    }

    output := "=== Example 2: Duration Formatting ===`n`n"

    ; Session durations
    output .= "Session Durations (Compact):`n"
    sessions := [
        {user: "Alice", duration: 3665},
        {user: "Bob", duration: 7325},
        {user: "Carol", duration: 145},
        {user: "David", duration: 86400}
    ]

    for session in sessions {
        output .= Format("  {:-15s}: {:s}",
            session.user,
            FormatDuration(session.duration)) . "`n"
    }

    ; Detailed durations
    output .= "`n`nDetailed Duration Breakdowns:`n"
    durations := [125, 3665, 7325, 86400, 90061]

    for dur in durations {
        output .= "  " . dur . " seconds = " . FormatDuration(dur, true) . "`n"
    }

    ; Task completion times
    output .= "`n`nTask Completion Times:`n"
    tasks := [
        {name: "Quick Task", start: "20240115100000", end: "20240115100530"},
        {name: "Medium Task", start: "20240115090000", end: "20240115103000"},
        {name: "Long Task", start: "20240115080000", end: "20240115170000"}
    ]

    for task in tasks {
        elapsed := DateDiff(task.end, task.start, "seconds")
        output .= Format("  {:-20s}: {:s}",
            task.name,
            FormatDuration(elapsed, true)) . "`n"
    }

    MsgBox(output, "Duration Formatting", 262144)
}

; ============================================================================
; Example 3: Fiscal Calendar Formatting
; ============================================================================

/**
 * Demonstrates fiscal year and quarter calculations.
 * Common use: Financial reporting, business analytics
 */
Example3_FiscalCalendar() {
    ; Calculate fiscal year (assuming July 1 start)
    GetFiscalYear(timestamp, fyStart := 7) {
        year := Integer(FormatTime(timestamp, "yyyy"))
        month := Integer(FormatTime(timestamp, "MM"))

        if (month >= fyStart)
            return year + 1
        else
            return year
    }

    ; Get fiscal quarter
    GetFiscalQuarter(timestamp, fyStart := 7) {
        month := Integer(FormatTime(timestamp, "MM"))

        ; Adjust month to fiscal year
        fiscalMonth := month - fyStart + 1
        if (fiscalMonth <= 0)
            fiscalMonth += 12

        return Ceil(fiscalMonth / 3)
    }

    ; Format fiscal period
    FormatFiscalPeriod(timestamp, fyStart := 7) {
        fy := GetFiscalYear(timestamp, fyStart)
        fq := GetFiscalQuarter(timestamp, fyStart)

        return "FY" . fy . " Q" . fq
    }

    output := "=== Example 3: Fiscal Calendar ===`n`n"

    now := A_Now

    ; Current fiscal information
    output .= "Current Fiscal Information:`n"
    output .= "  Calendar Date: " . FormatTime(now, "MMMM dd, yyyy") . "`n"
    output .= "  Fiscal Year: FY" . GetFiscalYear(now) . "`n"
    output .= "  Fiscal Quarter: Q" . GetFiscalQuarter(now) . "`n"
    output .= "  Fiscal Period: " . FormatFiscalPeriod(now) . "`n`n"

    ; Monthly breakdown for current calendar year
    output .= "Fiscal Period Mapping (July 1 FY Start):`n"
    output .= Format("{:-15s} {:>12s} {:>6s}",
        "Calendar Month",
        "Fiscal Year",
        "Quarter") . "`n"
    output .= StrReplace(Format("{:40s}", ""), " ", "─") . "`n"

    year := FormatTime(now, "yyyy")
    loop 12 {
        month := A_Index
        testDate := year . Format("{:02d}", month) . "15000000"
        fy := GetFiscalYear(testDate)
        fq := GetFiscalQuarter(testDate)

        output .= Format("{:-15s} {:>12s} {:>6s}",
            FormatTime(testDate, "MMMM yyyy"),
            "FY" . fy,
            "Q" . fq) . "`n"
    }

    ; Fiscal year boundaries
    output .= "`n`nFiscal Year Boundaries:`n"
    currentFY := GetFiscalYear(now)
    fyStart := (currentFY - 1) . "0701000000"
    fyEnd := currentFY . "0630235959"

    output .= "  Start: " . FormatTime(fyStart, "MMMM dd, yyyy") . "`n"
    output .= "  End: " . FormatTime(fyEnd, "MMMM dd, yyyy") . "`n"

    daysInFY := DateDiff(fyEnd, fyStart, "days") + 1
    daysPassed := DateDiff(now, fyStart, "days")
    percentComplete := (daysPassed / daysInFY) * 100

    output .= "  Progress: " . Format("{:.1f}% complete", percentComplete) . "`n"
    output .= "  Days remaining: " . (daysInFY - daysPassed) . " of " . daysInFY

    MsgBox(output, "Fiscal Calendar", 262144)
}

; ============================================================================
; Example 4: Multi-Format DateTime Display
; ============================================================================

/**
 * Creates comprehensive datetime displays for various contexts.
 * Common use: Status displays, dashboards, system information
 */
Example4_MultiFormatDisplay() {
    ; Generate comprehensive datetime display
    GenerateDateTimeDisplay() {
        now := A_Now
        nowUTC := A_NowUTC

        display := ""
        display .= "╔══════════════════════════════════════════════════════╗`n"
        display .= "║" . Format("{:^54s}", "COMPREHENSIVE DATE/TIME DISPLAY") . "║`n"
        display .= "╠══════════════════════════════════════════════════════╣`n"

        ; Current time in various formats
        display .= "║ Current Time (Local)                                 ║`n"
        display .= "║ " . Format("  Full:      {:-40s}", FormatTime(now, "dddd, MMMM dd, yyyy 'at' hh:mm:ss tt")) . " ║`n"
        display .= "║ " . Format("  12-hour:   {:-40s}", FormatTime(now, "MM/dd/yyyy hh:mm:ss tt")) . " ║`n"
        display .= "║ " . Format("  24-hour:   {:-40s}", FormatTime(now, "yyyy-MM-dd HH:mm:ss")) . " ║`n"
        display .= "║ " . Format("  Compact:   {:-40s}", FormatTime(now, "yyyyMMdd_HHmmss")) . " ║`n"

        ; UTC time
        display .= "╠══════════════════════════════════════════════════════╣`n"
        display .= "║ UTC Time                                             ║`n"
        display .= "║ " . Format("  ISO 8601:  {:-40s}", FormatTime(nowUTC, "yyyy-MM-dd'T'HH:mm:ss'Z'")) . " ║`n"

        ; Calendar information
        display .= "╠══════════════════════════════════════════════════════╣`n"
        display .= "║ Calendar Information                                 ║`n"

        dayOfYear := DateDiff(now, FormatTime(now, "yyyy") . "0101000000", "days") + 1
        weekNum := FormatTime(now, "ww")
        dayOfWeek := FormatTime(now, "w")

        display .= "║ " . Format("  Day:       {:-40s}", FormatTime(now, "dddd")) . " ║`n"
        display .= "║ " . Format("  Week:      Week {:d} of {:d}", Integer(weekNum), 52) . StrReplace(Format("{:30s}", ""), " ", " ") . " ║`n"
        display .= "║ " . Format("  Day/Year:  Day {:d} of 365", dayOfYear) . StrReplace(Format("{:31s}", ""), " ", " ") . " ║`n"

        quarter := Ceil(Integer(FormatTime(now, "MM")) / 3)
        display .= "║ " . Format("  Quarter:   Q{:d} {:s}", quarter, FormatTime(now, "yyyy")) . StrReplace(Format("{:33s}", ""), " ", " ") . " ║`n"

        ; Time until end of day/week/month/year
        display .= "╠══════════════════════════════════════════════════════╣`n"
        display .= "║ Time Remaining                                       ║`n"

        endOfDay := FormatTime(now, "yyyyMMdd") . "235959"
        minsToEndOfDay := DateDiff(endOfDay, now, "minutes")
        display .= "║ " . Format("  End of day: {:d} hours, {:d} minutes",
            Floor(minsToEndOfDay / 60),
            Mod(minsToEndOfDay, 60)) . StrReplace(Format("{:21s}", ""), " ", " ") . " ║`n"

        ; Month/Year progress
        monthDays := FormatTime(DateAdd(FormatTime(now, "yyyyMM") . "01000000", 1, "months"), "dd")
        currentDay := Integer(FormatTime(now, "dd"))
        monthProgress := (currentDay / monthDays) * 100

        display .= "║ " . Format("  Month progress: {:.1f}%", monthProgress) . StrReplace(Format("{:32s}", ""), " ", " ") . " ║`n"

        display .= "╚══════════════════════════════════════════════════════╝"

        return display
    }

    MsgBox(GenerateDateTimeDisplay(), "DateTime Display", 262144)
}

; ============================================================================
; Example 5: Timestamp Validation and Sanitization
; ============================================================================

/**
 * Validates and formats timestamps safely.
 * Common use: Data validation, user input handling
 */
Example5_TimestampValidation() {
    ; Validate and format timestamp
    SafeFormatTime(timestamp, format := "yyyy-MM-dd HH:mm:ss", default := "Invalid Date") {
        try {
            result := FormatTime(timestamp, format)
            return result
        } catch {
            return default
        }
    }

    ; Parse various date formats
    NormalizeDateString(dateStr) {
        ; Try to parse common formats and return YYYYMMDDHHMMSS
        ; This is a simplified example

        ; Try MM/DD/YYYY
        if RegExMatch(dateStr, "(\d{1,2})/(\d{1,2})/(\d{4})", &match) {
            month := Format("{:02d}", match[1])
            day := Format("{:02d}", match[2])
            year := match[3]
            return year . month . day . "000000"
        }

        ; Try YYYY-MM-DD
        if RegExMatch(dateStr, "(\d{4})-(\d{1,2})-(\d{1,2})", &match) {
            year := match[1]
            month := Format("{:02d}", match[2])
            day := Format("{:02d}", match[3])
            return year . month . day . "000000"
        }

        return ""
    }

    output := "=== Example 5: Timestamp Validation ===`n`n"

    ; Test various timestamps
    output .= "Timestamp Validation:`n"
    timestamps := [
        {input: A_Now, desc: "Current time"},
        {input: "20240115120000", desc: "Valid timestamp"},
        {input: "20240229120000", desc: "Leap year date"},
        {input: "invalid", desc: "Invalid timestamp"},
        {input: "", desc: "Empty timestamp"}
    ]

    for item in timestamps {
        result := SafeFormatTime(item.input, "MMMM dd, yyyy")
        output .= Format("  {:-25s}: {:s}",
            item.desc,
            result) . "`n"
    }

    ; Date string parsing
    output .= "`n`nDate String Parsing:`n"
    dateStrings := [
        "01/15/2024",
        "2024-01-15",
        "15/01/2024",
        "Invalid date"
    ]

    for dateStr in dateStrings {
        normalized := NormalizeDateString(dateStr)
        if (normalized != "")
            formatted := FormatTime(normalized, "MMMM dd, yyyy")
        else
            formatted := "Could not parse"

        output .= Format("  {:-15s} → {:s}",
            dateStr,
            formatted) . "`n"
    }

    ; Range validation
    output .= "`n`nDate Range Validation:`n"
    startDate := "20240101000000"
    endDate := "20241231235959"
    testDates := [
        "20240615120000",  ; Within range
        "20231215120000",  ; Before range
        "20250115120000"   ; After range
    ]

    for testDate in testDates {
        inRange := (testDate >= startDate && testDate <= endDate)
        status := inRange ? "✓ Valid" : "✗ Out of range"

        output .= Format("  {:s}: {:s}",
            FormatTime(testDate, "yyyy-MM-dd"),
            status) . "`n"
    }

    MsgBox(output, "Timestamp Validation", 262144)
}

; ============================================================================
; Example 6: Time-Based Greeting Generator
; ============================================================================

/**
 * Generates contextual greetings based on time of day.
 * Common use: User interfaces, email templates, notifications
 */
Example6_ContextualGreeting() {
    ; Generate greeting based on time
    GetGreeting(timestamp := "", userName := "User") {
        if (timestamp = "")
            timestamp := A_Now

        hour := Integer(FormatTime(timestamp, "HH"))
        dayName := FormatTime(timestamp, "dddd")

        ; Time-based greeting
        timeGreeting := ""
        if (hour >= 5 && hour < 12)
            timeGreeting := "Good morning"
        else if (hour >= 12 && hour < 17)
            timeGreeting := "Good afternoon"
        else if (hour >= 17 && hour < 21)
            timeGreeting := "Good evening"
        else
            timeGreeting := "Good night"

        ; Day-specific additions
        dayAddition := ""
        if (dayName = "Monday")
            dayAddition := " Hope you have a great start to the week!"
        else if (dayName = "Friday")
            dayAddition := " Happy Friday!"
        else if (dayName = "Saturday" || dayName = "Sunday")
            dayAddition := " Enjoy your weekend!"

        return timeGreeting . ", " . userName . "!" . dayAddition
    }

    output := "=== Example 6: Contextual Greetings ===`n`n"

    ; Greetings at different times
    output .= "Time-Based Greetings:`n"
    times := [
        {hour: "06", desc: "Early Morning"},
        {hour: "10", desc: "Mid Morning"},
        {hour: "13", desc: "Afternoon"},
        {hour: "18", desc: "Evening"},
        {hour: "22", desc: "Night"}
    ]

    for timeInfo in times {
        testTime := FormatTime(A_Now, "yyyyMMdd") . timeInfo.hour . "0000"
        greeting := GetGreeting(testTime, "John")
        output .= Format("  {:-15s} ({:s}): {:s}",
            timeInfo.desc,
            FormatTime(testTime, "h tt"),
            greeting) . "`n"
    }

    ; Current greeting
    output .= "`n`nCurrent Greeting:`n"
    output .= "  " . GetGreeting("", "Alice") . "`n`n"

    ; Email template with greeting
    now := A_Now
    output .= "Email Template Example:`n"
    output .= StrReplace(Format("{:50s}", ""), " ", "─") . "`n"
    output .= GetGreeting(now, "Customer") . "`n`n"
    output .= "Thank you for contacting us on " . FormatTime(now, "dddd, MMMM dd") . ".`n"
    output .= "We will respond to your inquiry shortly.`n`n"
    output .= "Best regards,`n"
    output .= "The Support Team"

    MsgBox(output, "Contextual Greetings", 262144)
}

; ============================================================================
; Example 7: Date Formatting Presets Library
; ============================================================================

/**
 * Provides a library of common date formatting presets.
 * Common use: Standardization, code reuse, consistency
 */
Example7_FormattingPresets() {
    ; Date formatting presets
    class DateFormat {
        static ISO_DATE := "yyyy-MM-dd"
        static ISO_DATETIME := "yyyy-MM-dd'T'HH:mm:ss"
        static ISO_DATETIME_UTC := "yyyy-MM-dd'T'HH:mm:ss'Z'"

        static US_SHORT := "M/d/yyyy"
        static US_LONG := "MMMM d, yyyy"
        static US_FULL := "dddd, MMMM d, yyyy"

        static EU_SHORT := "d/M/yyyy"
        static EU_LONG := "d MMMM yyyy"

        static FILE_SAFE := "yyyyMMdd_HHmmss"
        static LOG_TIMESTAMP := "yyyy-MM-dd HH:mm:ss"

        static TIME_12HR := "hh:mm:ss tt"
        static TIME_24HR := "HH:mm:ss"

        static COMPACT := "yyyyMMddHHmmss"

        ; Preset formatters
        static Format(timestamp, preset) {
            return FormatTime(timestamp, preset)
        }
    }

    output := "=== Example 7: Formatting Presets ===`n`n"
    now := A_Now

    ; Demonstrate all presets
    output .= "Standard Presets:`n"
    output .= "  ISO Date: " . DateFormat.Format(now, DateFormat.ISO_DATE) . "`n"
    output .= "  ISO DateTime: " . DateFormat.Format(now, DateFormat.ISO_DATETIME) . "`n"
    output .= "  US Short: " . DateFormat.Format(now, DateFormat.US_SHORT) . "`n"
    output .= "  US Long: " . DateFormat.Format(now, DateFormat.US_LONG) . "`n"
    output .= "  US Full: " . DateFormat.Format(now, DateFormat.US_FULL) . "`n"
    output .= "  EU Short: " . DateFormat.Format(now, DateFormat.EU_SHORT) . "`n"
    output .= "  EU Long: " . DateFormat.Format(now, DateFormat.EU_LONG) . "`n`n"

    output .= "Technical Presets:`n"
    output .= "  File Safe: " . DateFormat.Format(now, DateFormat.FILE_SAFE) . "`n"
    output .= "  Log Timestamp: " . DateFormat.Format(now, DateFormat.LOG_TIMESTAMP) . "`n"
    output .= "  Time 12hr: " . DateFormat.Format(now, DateFormat.TIME_12HR) . "`n"
    output .= "  Time 24hr: " . DateFormat.Format(now, DateFormat.TIME_24HR) . "`n"
    output .= "  Compact: " . DateFormat.Format(now, DateFormat.COMPACT) . "`n`n"

    ; Usage examples
    output .= "Usage Examples:`n"
    output .= "  Filename: backup_" . DateFormat.Format(now, DateFormat.FILE_SAFE) . ".zip`n"
    output .= "  Log: [" . DateFormat.Format(now, DateFormat.LOG_TIMESTAMP) . "] Message`n"
    output .= "  Report: Report for " . DateFormat.Format(now, DateFormat.US_LONG) . "`n"

    MsgBox(output, "Formatting Presets", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
    (
    FormatTime() - Advanced Operations

    Examples:
    1. Relative Time Formatting
    2. Duration Formatting
    3. Fiscal Calendar
    4. Multi-Format Display
    5. Timestamp Validation
    6. Contextual Greetings
    7. Formatting Presets

    Press Ctrl+1-7 to run examples
    )"
    MsgBox(menu, "FormatTime Advanced", 4096)
}

^1::Example1_RelativeTime()
^2::Example2_DurationFormatting()
^3::Example3_FiscalCalendar()
^4::Example4_MultiFormatDisplay()
^5::Example5_TimestampValidation()
^6::Example6_ContextualGreeting()
^7::Example7_FormattingPresets()
^m::ShowMenu()

ShowMenu()
