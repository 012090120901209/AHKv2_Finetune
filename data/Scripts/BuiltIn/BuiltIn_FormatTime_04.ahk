#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FormatTime Function - Advanced Time Operations and Timestamps
 * ============================================================================
 * 
 * This script demonstrates advanced timestamp operations, time zone handling,
 * and sophisticated datetime calculations with FormatTime().
 * 
 * @description Advanced timestamp operations and time handling
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Advanced Features:
 * - Unix timestamp conversion
 * - Business hours calculations
 * - Working day calculations
 * - Advanced scheduling
 * - Performance timing
 */

; ============================================================================
; Example 1: Unix Timestamp Operations
; ============================================================================

/**
 * Works with Unix timestamps and epoch conversions.
 * Common use: API integration, database timestamps, cross-platform compatibility
 */
Example1_UnixTimestamps() {
    ; Convert AHK timestamp to Unix timestamp (seconds since 1970-01-01)
    ToUnixTime(ahkTimestamp) {
        epoch := "19700101000000"
        return DateDiff(ahkTimestamp, epoch, "seconds")
    }

    ; Convert Unix timestamp to AHK timestamp
    FromUnixTime(unixTimestamp) {
        epoch := "19700101000000"
        return DateAdd(epoch, unixTimestamp, "seconds")
    }

    output := "=== Example 1: Unix Timestamp Operations ===`n`n"
    now := A_Now

    ; Current time conversions
    output .= "Current Time Conversions:`n"
    output .= "  AHK Format: " . now . "`n"
    output .= "  Formatted: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n"

    unixNow := ToUnixTime(now)
    output .= "  Unix Timestamp: " . unixNow . "`n"
    output .= "  Unix (Milliseconds): " . (unixNow * 1000) . "`n`n"

    ; Sample Unix timestamps
    output .= "Unix Timestamp Examples:`n"
    timestamps := [{
        unix: 0, desc: "Unix Epoch" }, {
            unix: 1000000000, desc: "1 Billion Seconds" }, {
                unix: 1609459200, desc: "2021-01-01 00:00:00" }, {
                    unix: 1735689600, desc: "2025-01-01 00:00:00"
                }
    ]

    for item in timestamps {
        ahkTime := FromUnixTime(item.unix)
        formatted := FormatTime(ahkTime, "yyyy-MM-dd HH:mm:ss")
        output .= Format("  {:s}: {:d} = {:s}",
            item.desc,
            item.unix,
            formatted) . "`n"
    }

    ; API Response Example
    output .= "`n`nAPI Timestamp Formatting:`n"
    apiResponse := {
        timestamp: unixNow,
        created_at: ToUnixTime(DateAdd(now, -2, "hours")),
        updated_at: ToUnixTime(DateAdd(now, -15, "minutes"))
    }

    output .= "  Current: " . FormatTime(FromUnixTime(apiResponse.timestamp), "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "  Created: " . FormatTime(FromUnixTime(apiResponse.created_at), "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "  Updated: " . FormatTime(FromUnixTime(apiResponse.updated_at), "yyyy-MM-dd HH:mm:ss") . "`n"

    MsgBox(output, "Unix Timestamps", 262144)
}

; ============================================================================
; Example 2: Business Hours Calculator
; ============================================================================

/**
 * Calculates time within business hours.
 * Common use: SLA tracking, business hour scheduling, work time calculation
 */
Example2_BusinessHours() {
    ; Check if time is within business hours
    IsBusinessHours(timestamp, startHour := 9, endHour := 17) {
        hour := Integer(FormatTime(timestamp, "HH"))
        dayOfWeek := FormatTime(timestamp, "w")  ; 1=Sunday, 7=Saturday

        ; Check if weekday (Monday-Friday = 2-6)
        isWeekday := (dayOfWeek >= 2 && dayOfWeek <= 6)

        ; Check if within hours
        isDuringHours := (hour >= startHour && hour < endHour)

        return isWeekday && isDuringHours
    }

    ; Calculate next business day
    NextBusinessDay(timestamp) {
        nextDay := DateAdd(timestamp, 1, "days")
        dayOfWeek := FormatTime(nextDay, "w")

        ; Skip weekend
        while (dayOfWeek = 1 || dayOfWeek = 7) {  ; Sunday or Saturday
            nextDay := DateAdd(nextDay, 1, "days")
            dayOfWeek := FormatTime(nextDay, "w")
        }

        return nextDay
    }

    ; Calculate business hours between two timestamps
    BusinessHoursBetween(startTime, endTime, dayStart := 9, dayEnd := 17) {
        hours := 0
        current := startTime

        while (current < endTime) {
            if (IsBusinessHours(current, dayStart, dayEnd)) {
                hours++
            }
            current := DateAdd(current, 1, "hours")
        }

        return hours
    }

    output := "=== Example 2: Business Hours ===`n`n"
    now := A_Now

    ; Current status
    output .= "Current Status:`n"
    output .= "  Current Time: " . FormatTime(now, "dddd, MMMM dd 'at' h:mm tt") . "`n"
    output .= "  Business Hours: " . (IsBusinessHours(now) ? "Yes ✓" : "No ✗") . "`n`n"

    ; Test various times
    output .= "Business Hours Check:`n"
    testTimes := [
        FormatTime(now, "yyyyMMdd") . "083000",  ; 8:30 AM
        FormatTime(now, "yyyyMMdd") . "120000",  ; Noon
        FormatTime(now, "yyyyMMdd") . "180000",  ; 6:00 PM
        FormatTime(now, "yyyyMMdd") . "220000"   ; 10:00 PM
    ]

    for testTime in testTimes {
        isBusinessTime := IsBusinessHours(testTime)
        status := isBusinessTime ? "✓ Business Hours" : "✗ After Hours"

        output .= Format("  {:s}: {:s}",
            FormatTime(testTime, "h:mm tt"),
            status) . "`n"
    }

    ; SLA Calculation
    output .= "`n`nSLA Response Time (24 Business Hours):`n"
    ticketTime := now
    responseDeadline := ticketTime

    ; Add 24 business hours
    businessHoursAdded := 0
    while (businessHoursAdded < 24) {
        responseDeadline := DateAdd(responseDeadline, 1, "hours")
        if (IsBusinessHours(responseDeadline)) {
            businessHoursAdded++
        }
    }

    output .= "  Ticket Created: " . FormatTime(ticketTime, "MMM dd 'at' h:mm tt") . "`n"
    output .= "  Response Due: " . FormatTime(responseDeadline, "MMM dd 'at' h:mm tt") . "`n"

    ; Next business day
    output .= "`n`nNext Business Day:`n"
    nextBizDay := NextBusinessDay(now)
    output .= "  From: " . FormatTime(now, "dddd, MMM dd") . "`n"
    output .= "  Next: " . FormatTime(nextBizDay, "dddd, MMM dd") . "`n"

    MsgBox(output, "Business Hours", 262144)
}

; ============================================================================
; Example 3: Working Days Calculator
; ============================================================================

/**
 * Calculates working days between dates, excluding weekends and holidays.
 * Common use: Project planning, delivery estimates, workload calculation
 */
Example3_WorkingDays() {
    ; Count working days between two dates
    WorkingDaysBetween(startDate, endDate, excludeWeekends := true) {
        days := 0
        current := startDate

        while (current <= endDate) {
            dayOfWeek := FormatTime(current, "w")

            ; Check if it's a weekday (Monday-Friday)
            if (!excludeWeekends || (dayOfWeek >= 2 && dayOfWeek <= 6)) {
                days++
            }

            current := DateAdd(current, 1, "days")
        }

        return days
    }

    ; Add working days to a date
    AddWorkingDays(startDate, workingDays) {
        current := startDate
        daysAdded := 0

        while (daysAdded < workingDays) {
            current := DateAdd(current, 1, "days")
            dayOfWeek := FormatTime(current, "w")

            ; Only count weekdays
            if (dayOfWeek >= 2 && dayOfWeek <= 6) {
                daysAdded++
            }
        }

        return current
    }

    output := "=== Example 3: Working Days Calculator ===`n`n"
    today := A_Now

    ; Project timeline
    output .= "Project Timeline (15 Working Days):`n"
    projectStart := today
    projectEnd := AddWorkingDays(projectStart, 15)

    output .= "  Start Date: " . FormatTime(projectStart, "dddd, MMMM dd, yyyy") . "`n"
    output .= "  End Date: " . FormatTime(projectEnd, "dddd, MMMM dd, yyyy") . "`n"
    output .= "  Duration: 15 working days`n"

    calendarDays := DateDiff(projectEnd, projectStart, "days")
    output .= "  Calendar Days: " . calendarDays . " days`n`n"

    ; Month analysis
    firstOfMonth := FormatTime(today, "yyyyMM") . "01000000"
    lastOfMonth := DateAdd(DateAdd(firstOfMonth, 1, "months"), -1, "days")

    workingDays := WorkingDaysBetween(firstOfMonth, lastOfMonth)
    totalDays := DateDiff(lastOfMonth, firstOfMonth, "days") + 1

    output .= "Current Month Analysis (" . FormatTime(today, "MMMM yyyy") . "):`n"
    output .= "  Total Days: " . totalDays . " days`n"
    output .= "  Working Days: " . workingDays . " days`n"
    output .= "  Weekend Days: " . (totalDays - workingDays) . " days`n`n"

    ; Delivery estimation
    output .= "Delivery Estimates:`n"
    estimates := [{
        name: "Standard", days: 5 }, {
            name: "Express", days: 3 }, {
                name: "Same Week", days: 2
            }
    ]

    for est in estimates {
        deliveryDate := AddWorkingDays(today, est.days)
        output .= Format("  {:-15s}: {:s} ({:d} working days)",
            est.name,
            FormatTime(deliveryDate, "MMM dd"),
            est.days) . "`n"
    }

    MsgBox(output, "Working Days", 262144)
}

; ============================================================================
; Example 4: Advanced Scheduling System
; ============================================================================

/**
 * Creates sophisticated scheduling with recurring events.
 * Common use: Calendar applications, task schedulers, meeting planners
 */
Example4_AdvancedScheduling() {
    ; Generate next occurrence of a recurring event
    NextOccurrence(baseDate, pattern) {
        if (pattern.type = "daily") {
            return DateAdd(baseDate, pattern.interval, "days")
        } else if (pattern.type = "weekly") {
            return DateAdd(baseDate, pattern.interval * 7, "days")
        } else if (pattern.type = "monthly") {
            return DateAdd(baseDate, pattern.interval, "months")
        }
        return baseDate
    }

    output := "=== Example 4: Advanced Scheduling ===`n`n"
    today := A_Now

    ; Daily standup meeting
    output .= "Daily Standup Meeting:`n"
    standupTime := FormatTime(today, "yyyyMMdd") . "093000"
    output .= "  Today: " . FormatTime(standupTime, "h:mm tt") . "`n"

    loop 4 {
        standupTime := DateAdd(standupTime, 1, "days")
        ; Skip weekends
        while (FormatTime(standupTime, "w") = 1 || FormatTime(standupTime, "w") = 7) {
            standupTime := DateAdd(standupTime, 1, "days")
        }
        output .= "  " . FormatTime(standupTime, "ddd, MMM dd 'at' h:mm tt") . "`n"
    }

    ; Weekly team meeting
    output .= "`n`nWeekly Team Meeting (Every Monday at 2:00 PM):`n"
    ; Find next Monday
    nextMeeting := today
    loop {
        if (FormatTime(nextMeeting, "w") = 2 && nextMeeting > today) {  ; Monday
            break
        }
        nextMeeting := DateAdd(nextMeeting, 1, "days")
    }

    ; Set time to 2:00 PM
    nextMeeting := FormatTime(nextMeeting, "yyyyMMdd") . "140000"

    loop 5 {
        output .= "  " . FormatTime(nextMeeting, "dddd, MMMM dd 'at' h:mm tt") . "`n"
        nextMeeting := DateAdd(nextMeeting, 7, "days")
    }

    ; Monthly report
    output .= "`n`nMonthly Report (1st of each month):`n"
    reportDate := FormatTime(today, "yyyy") . FormatTime(today, "MM") . "01090000"

    ; If today is past the 1st, get next month
    if (today > reportDate) {
        reportDate := DateAdd(reportDate, 1, "months")
    }

    loop 6 {
        output .= "  " . FormatTime(reportDate, "MMMM dd, yyyy 'at' h:mm tt") . "`n"
        reportDate := DateAdd(reportDate, 1, "months")
    }

    ; Quarterly review
    output .= "`n`nQuarterly Review (Every 3 months):`n"
    month := Integer(FormatTime(today, "MM"))
    quarter := Ceil(month / 3)
    quarterMonth := ((quarter - 1) * 3) + 1

    reviewDate := FormatTime(today, "yyyy") . Format("{:02d}", quarterMonth) . "15100000"

    if (today > reviewDate) {
        reviewDate := DateAdd(reviewDate, 3, "months")
    }

    loop 4 {
        output .= "  Q" . Ceil(Integer(FormatTime(reviewDate, "MM")) / 3) . " - "
        output .= FormatTime(reviewDate, "MMMM dd, yyyy") . "`n"
        reviewDate := DateAdd(reviewDate, 3, "months")
    }

    MsgBox(output, "Advanced Scheduling", 262144)
}

; ============================================================================
; Example 5: Performance Timing and Benchmarking
; ============================================================================

/**
 * Uses timestamps for performance measurement and benchmarking.
 * Common use: Code optimization, profiling, performance monitoring
 */
Example5_PerformanceTiming() {
    ; Simple timer class

    output := "=== Example 5: Performance Timing ===`n`n"

    ; Simulate some operations
    timer := Timer()

    ; Operation 1
    Sleep(100)
    timer.Mark("Database Query")

    ; Operation 2
    Sleep(50)
    timer.Mark("Data Processing")

    ; Operation 3
    Sleep(75)
    timer.Mark("Rendering")

    output .= timer.Report() . "`n`n"

    ; Timestamp-based duration formatting
    output .= "Operation Durations:`n"

    operations := [{
        name: "API Call", start: "20240115100000", end: "20240115100002" }, {
            name: "File Processing", start: "20240115100005", end: "20240115100015" }, {
                name: "Data Export", start: "20240115100020", end: "20240115100035"
            }
    ]

    for op in operations {
        durationSec := DateDiff(op.end, op.start, "seconds")
        durationMs := DateDiff(op.end, op.start, "seconds") * 1000

        output .= Format("  {:-20s}: {:.2f}s ({:,d} ms)",
            op.name,
            durationSec,
            durationMs) . "`n"
    }

    ; Response time analysis
    output .= "`n`nResponse Time Analysis:`n"
    requests := [{
        id: 1, start: "20240115100000", end: "20240115100000", status: "Fast" }, {
            id: 2, start: "20240115100001", end: "20240115100002", status: "Normal" }, {
                id: 3, start: "20240115100003", end: "20240115100008", status: "Slow"
            }
    ]

    totalTime := 0
    for req in requests {
        responseTime := DateDiff(req.end, req.start, "seconds")
        totalTime += responseTime

        output .= Format("  Request {:d}: {:>3d}ms - {:s}",
            req.id,
            responseTime * 1000,
            req.status) . "`n"
    }

    avgTime := totalTime / requests.Length
    output .= Format("`n  Average Response Time: {:.0f}ms", avgTime * 1000)

    MsgBox(output, "Performance Timing", 262144)
}

; ============================================================================
; Example 6: Timestamp Range Generator
; ============================================================================

/**
 * Generates timestamp ranges for reports and queries.
 * Common use: Database queries, report generation, log analysis
 */
Example6_TimestampRanges() {
    ; Generate timestamp range
    GetRange(rangeType, referenceDate := "") {
        if (referenceDate = "")
            referenceDate := A_Now

        range := { start: "", end: "" }

        if (rangeType = "today") {
            range.start := FormatTime(referenceDate, "yyyyMMdd") . "000000"
            range.end := FormatTime(referenceDate, "yyyyMMdd") . "235959"
        } else if (rangeType = "this_week") {
            ; Get start of week (Sunday)
            dayOfWeek := FormatTime(referenceDate, "w") - 1
            weekStart := DateAdd(referenceDate, -dayOfWeek, "days")
            range.start := FormatTime(weekStart, "yyyyMMdd") . "000000"
            range.end := FormatTime(DateAdd(weekStart, 6, "days"), "yyyyMMdd") . "235959"
        } else if (rangeType = "this_month") {
            range.start := FormatTime(referenceDate, "yyyyMM") . "01000000"
            nextMonth := DateAdd(range.start, 1, "months")
            range.end := FormatTime(DateAdd(nextMonth, -1, "days"), "yyyyMMdd") . "235959"
        } else if (rangeType = "this_year") {
            range.start := FormatTime(referenceDate, "yyyy") . "0101000000"
            range.end := FormatTime(referenceDate, "yyyy") . "1231235959"
        } else if (rangeType = "last_7_days") {
            range.start := FormatTime(DateAdd(referenceDate, -7, "days"), "yyyyMMdd") . "000000"
            range.end := FormatTime(referenceDate, "yyyyMMdd") . "235959"
        } else if (rangeType = "last_30_days") {
            range.start := FormatTime(DateAdd(referenceDate, -30, "days"), "yyyyMMdd") . "000000"
            range.end := FormatTime(referenceDate, "yyyyMMdd") . "235959"
        }

        return range
    }

    output := "=== Example 6: Timestamp Ranges ===`n`n"
    today := A_Now

    ; Common ranges
    ranges := ["today", "this_week", "this_month", "this_year", "last_7_days", "last_30_days"]

    for rangeType in ranges {
        range := GetRange(rangeType, today)

        displayName := StrReplace(rangeType, "_", " ")
        displayName := StrUpper(SubStr(displayName, 1, 1)) . SubStr(displayName, 2)

        output .= displayName . ":`n"
        output .= "  Start: " . FormatTime(range.start, "yyyy-MM-dd HH:mm:ss") . "`n"
        output .= "  End:   " . FormatTime(range.end, "yyyy-MM-dd HH:mm:ss") . "`n"

        days := DateDiff(range.end, range.start, "days") + 1
        output .= "  Days:  " . days . "`n`n"
    }

    ; SQL query examples
    output .= "SQL Query Examples:`n`n"

    thisMonth := GetRange("this_month")
    output .= "-- Sales this month`n"
    output .= "SELECT * FROM sales`n"
    output .= "WHERE sale_date >= '" . FormatTime(thisMonth.start, "yyyy-MM-dd") . "'`n"
    output .= "  AND sale_date <= '" . FormatTime(thisMonth.end, "yyyy-MM-dd") . "';`n"

    MsgBox(output, "Timestamp Ranges", 262144)
}

; ============================================================================
; Example 7: Time Log System
; ============================================================================

/**
 * Creates a time tracking and logging system.
 * Common use: Time tracking, activity logging, productivity monitoring
 */
Example7_TimeLogging() {
    ; Time log entry class

    ; Simulate time logging
    TimeLog.LogEntry("Development", "Code review", 30)
    TimeLog.LogEntry("Development", "Bug fixing", 45)
    TimeLog.LogEntry("Meetings", "Team standup", 15)
    TimeLog.LogEntry("Development", "Feature implementation", 90)
    TimeLog.LogEntry("Meetings", "Client call", 60)
    TimeLog.LogEntry("Administration", "Email responses", 20)

    output := "=== Example 7: Time Logging System ===`n`n"
    output .= TimeLog.GenerateReport()

    MsgBox(output, "Time Logging", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
                                (
                                FormatTime() - Advanced Time Operations

                                Examples:
                                1. Unix Timestamps
                                2. Business Hours
                                3. Working Days
                                4. Advanced Scheduling
                                5. Performance Timing
                                6. Timestamp Ranges
                                7. Time Logging

                                Press Ctrl+1-7 to run examples
                                )"
    MsgBox(menu, "FormatTime Advanced Time Ops", 4096)
}

^1:: Example1_UnixTimestamps()
^2:: Example2_BusinessHours()
^3:: Example3_WorkingDays()
^4:: Example4_AdvancedScheduling()
^5:: Example5_PerformanceTiming()
^6:: Example6_TimestampRanges()
^7:: Example7_TimeLogging()
^m:: ShowMenu()

ShowMenu()

; Moved class Timer from nested scope
class Timer {
    __New() {
        this.startTime := A_TickCount
        this.marks := Map()
    }

    Mark(label) {
        this.marks[label] := A_TickCount
    }

    Elapsed(fromLabel := "") {
        current := A_TickCount
        if (fromLabel != "" && this.marks.Has(fromLabel))
            return current - this.marks[fromLabel]
        return current - this.startTime
    }

    Report() {
        report := "Performance Report:`n"
        report .= "  Total Time: " . this.Elapsed() . " ms`n`n"

        if (this.marks.Count > 0) {
            report .= "Checkpoints:`n"
            lastTime := this.startTime

            for label, time in this.marks {
                elapsed := time - this.startTime
                delta := time - lastTime
                report .= Format("  {:-20s}: {:>6d} ms (Δ {:>6d} ms)",
                    label,
                    elapsed,
                    delta) . "`n"
                lastTime := time
            }
        }

        return report
    }
}

; Moved class TimeLog from nested scope
class TimeLog {
    static entries := []

    static LogEntry(category, description, duration := 0) {
        entry := {
            timestamp: A_Now,
            category: category,
            description: description,
            duration: duration
        }
        TimeLog.entries.Push(entry)
    }

    static GenerateReport() {
        report := "Time Log Report - " . FormatTime(A_Now, "MMMM dd, yyyy") . "`n"
        report .= StrReplace(Format("{:70s}", ""), " ", "═") . "`n`n"

        if (TimeLog.entries.Length = 0) {
            report .= "No entries logged.`n"
            return report
        }

        ; Group by category
        categories := Map()

        for entry in TimeLog.entries {
            if (!categories.Has(entry.category))
                categories[entry.category] := []
            categories[entry.category].Push(entry)
        }

        ; Display by category
        for category, entries in categories {
            report .= Format("{:s} ({:d} entries):", category, entries.Length) . "`n"

            totalDuration := 0
            for entry in entries {
                timestamp := FormatTime(entry.timestamp, "HH:mm")
                report .= Format("  [{:s}] {:-40s} {:>3d} min",
                    timestamp,
                    entry.description,
                    entry.duration) . "`n"
                totalDuration += entry.duration
            }

            report .= Format("  Total: {:d} minutes ({:.1f} hours)", totalDuration, totalDuration / 60) . "`n`n"
        }

        return report
    }
}
