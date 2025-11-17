#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * DateDiff Function - Basic Date Difference Calculations
 * ============================================================================
 *
 * This script demonstrates the DateDiff() function for calculating time
 * differences between dates in AutoHotkey v2.
 *
 * @description Basic DateDiff() usage for calculating elapsed time
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 *
 * DateDiff Parameters:
 * - DateTime1: The later/ending timestamp
 * - DateTime2: The earlier/starting timestamp
 * - Units: "seconds", "minutes", "hours", "days", "months", "years"
 *
 * Returns: Integer representing the difference in specified units
 *
 * Note: DateDiff(End, Start, Units) = positive number for elapsed time
 */

; ============================================================================
; Example 1: Basic Time Difference Calculations
; ============================================================================

/**
 * Demonstrates calculating differences in various time units.
 * Common use: Elapsed time, duration, time tracking
 */
Example1_BasicDifferences() {
    output := "=== Example 1: Basic Time Differences ===`n`n"

    ; Calculate difference from a past date
    startDate := "20240101120000"  ; Jan 1, 2024 at 12:00 PM
    endDate := A_Now

    output .= "Calculating time from:`n"
    output .= "  Start: " . FormatTime(startDate, "MMMM dd, yyyy 'at' h:mm tt") . "`n"
    output .= "  End:   " . FormatTime(endDate, "MMMM dd, yyyy 'at' h:mm tt") . "`n`n"

    ; Calculate in different units
    output .= "Time Elapsed:`n"
    seconds := DateDiff(endDate, startDate, "seconds")
    minutes := DateDiff(endDate, startDate, "minutes")
    hours := DateDiff(endDate, startDate, "hours")
    days := DateDiff(endDate, startDate, "days")

    output .= Format("  {:,d} seconds", seconds) . "`n"
    output .= Format("  {:,d} minutes", minutes) . "`n"
    output .= Format("  {:,d} hours", hours) . "`n"
    output .= Format("  {:,d} days", days) . "`n`n"

    ; Short intervals
    output .= "Short Time Intervals:`n"
    now := A_Now

    oneHourAgo := DateAdd(now, -1, "hours")
    diff_minutes := DateDiff(now, oneHourAgo, "minutes")
    output .= "  1 hour = " . diff_minutes . " minutes`n"

    thirtyMinsAgo := DateAdd(now, -30, "minutes")
    diff_seconds := DateDiff(now, thirtyMinsAgo, "seconds")
    output .= "  30 minutes = " . diff_seconds . " seconds`n"

    oneDayAgo := DateAdd(now, -1, "days")
    diff_hours := DateDiff(now, oneDayAgo, "hours")
    output .= "  1 day = " . diff_hours . " hours`n"

    ; Year difference
    output .= "`n`nYear Differences:`n"
    today := A_Now
    lastYear := DateAdd(today, -1, "years")
    fiveYearsAgo := DateAdd(today, -5, "years")

    years1 := DateDiff(today, lastYear, "years")
    years5 := DateDiff(today, fiveYearsAgo, "years")

    output .= "  1 year ago: " . years1 . " year(s) difference`n"
    output .= "  5 years ago: " . years5 . " years difference`n"

    MsgBox(output, "Basic Differences", 262144)
}

; ============================================================================
; Example 2: Age Calculation
; ============================================================================

/**
 * Calculates ages from birthdates.
 * Common use: Age verification, demographics, birthday tracking
 */
Example2_AgeCalculation() {
    output := "=== Example 2: Age Calculation ===`n`n"

    ; Sample birthdates
    people := [
        {name: "Alice Johnson", birth: "19900515000000"},
        {name: "Bob Smith", birth: "19851203000000"},
        {name: "Carol Williams", birth: "20001001000000"},
        {name: "David Brown", birth: "19750710000000"},
        {name: "Eve Davis", birth: "20100315000000"}
    ]

    output .= "Age Calculations:`n`n"

    for person in people {
        today := A_Now
        years := DateDiff(today, person.birth, "years")
        months := DateDiff(today, person.birth, "months")
        days := DateDiff(today, person.birth, "days")

        output .= person.name . ":`n"
        output .= "  Born: " . FormatTime(person.birth, "MMMM dd, yyyy") . "`n"
        output .= Format("  Age: {:d} years ({:,d} months, {:,d} days)",
            years,
            months,
            days) . "`n`n"
    }

    ; Age categories
    output .= "Age Categories:`n"
    categories := Map()
    categories["Child (0-12)"] := 0
    categories["Teen (13-19)"] := 0
    categories["Adult (20-64)"] := 0
    categories["Senior (65+)"] := 0

    for person in people {
        age := DateDiff(A_Now, person.birth, "years")

        if (age <= 12)
            categories["Child (0-12)"]++
        else if (age <= 19)
            categories["Teen (13-19)"]++
        else if (age <= 64)
            categories["Adult (20-64)"]++
        else
            categories["Senior (65+)"]++
    }

    for category, count in categories {
        output .= Format("  {:-20s}: {:d} people", category, count) . "`n"
    }

    MsgBox(output, "Age Calculation", 262144)
}

; ============================================================================
; Example 3: Event Countdown and Days Until
; ============================================================================

/**
 * Calculates days until future events.
 * Common use: Countdown timers, event planning, deadlines
 */
Example3_EventCountdown() {
    output := "=== Example 3: Event Countdown ===`n`n"
    today := A_Now

    ; Upcoming events
    events := [
        {name: "Project Deadline", date: DateAdd(today, 7, "days")},
        {name: "Birthday Party", date: DateAdd(today, 15, "days")},
        {name: "Conference", date: DateAdd(today, 30, "days")},
        {name: "Vacation", date: DateAdd(today, 45, "days")},
        {name: "Annual Review", date: DateAdd(today, 90, "days")}
    ]

    output .= "Days Until Events:`n`n"

    for event in events {
        daysUntil := DateDiff(event.date, today, "days")
        hoursUntil := DateDiff(event.date, today, "hours")
        eventDate := FormatTime(event.date, "dddd, MMMM dd, yyyy")

        output .= event.name . ":`n"
        output .= "  Date: " . eventDate . "`n"
        output .= "  " . daysUntil . " days (" . hoursUntil . " hours) from now`n`n"
    }

    ; Special dates this year
    output .= "Days Until Special Dates:`n"
    year := FormatTime(today, "yyyy")

    specialDates := [
        {name: "New Year's Day", date: year . "0101000000"},
        {name: "Valentine's Day", date: year . "0214000000"},
        {name: "Independence Day", date: year . "0704000000"},
        {name: "Halloween", date: year . "1031000000"},
        {name: "Christmas", date: year . "1225000000"}
    ]

    for special in specialDates {
        ; If date has passed this year, use next year
        if (special.date < today) {
            nextYear := Integer(year) + 1
            special.date := nextYear . SubStr(special.date, 5)
        }

        daysUntil := DateDiff(special.date, today, "days")

        if (daysUntil >= 0) {
            output .= Format("  {:-20s}: {:d} days",
                special.name,
                daysUntil) . "`n"
        }
    }

    MsgBox(output, "Event Countdown", 262144)
}

; ============================================================================
; Example 4: Time Since Events (Historical)
; ============================================================================

/**
 * Calculates time elapsed since past events.
 * Common use: History tracking, anniversary calculation, audit logs
 */
Example4_TimeSinceEvents() {
    output := "=== Example 4: Time Since Events ===`n`n"
    today := A_Now

    ; Historical events
    output .= "Time Since Historical Events:`n`n"

    events := [
        {name: "Account Created", date: "20200115120000"},
        {name: "First Purchase", date: "20200201143000"},
        {name: "Service Upgrade", date: "20210615090000"},
        {name: "Last Login", date: "20240110170000"},
        {name: "Password Changed", date: "20231201080000"}
    ]

    for event in events {
        daysAgo := DateDiff(today, event.date, "days")
        monthsAgo := DateDiff(today, event.date, "months")
        yearsAgo := DateDiff(today, event.date, "years")

        output .= event.name . ":`n"
        output .= "  Date: " . FormatTime(event.date, "MMMM dd, yyyy") . "`n"

        if (yearsAgo > 0)
            output .= Format("  {:d} years ago ({:d} months, {:d} days)",
                yearsAgo,
                monthsAgo,
                daysAgo) . "`n`n"
        else if (monthsAgo > 0)
            output .= Format("  {:d} months ago ({:d} days)",
                monthsAgo,
                daysAgo) . "`n`n"
        else
            output .= Format("  {:d} days ago", daysAgo) . "`n`n"
    }

    ; Activity timeline
    output .= "Recent Activity Timeline:`n"
    activities := [
        {action: "Logged in", time: DateAdd(today, -2, "hours")},
        {action: "Updated profile", time: DateAdd(today, -5, "hours")},
        {action: "Made purchase", time: DateAdd(today, -1, "days")},
        {action: "Wrote review", time: DateAdd(today, -3, "days")}
    ]

    for activity in activities {
        hoursAgo := DateDiff(today, activity.time, "hours")
        minutesAgo := DateDiff(today, activity.time, "minutes")

        if (hoursAgo < 1)
            output .= Format("  {:s}: {:d} minutes ago",
                activity.action,
                minutesAgo) . "`n"
        else if (hoursAgo < 24)
            output .= Format("  {:s}: {:d} hours ago",
                activity.action,
                hoursAgo) . "`n"
        else
            output .= Format("  {:s}: {:d} days ago",
                activity.action,
                DateDiff(today, activity.time, "days")) . "`n"
    }

    MsgBox(output, "Time Since Events", 262144)
}

; ============================================================================
; Example 5: Duration Between Timestamps
; ============================================================================

/**
 * Calculates durations for various scenarios.
 * Common use: Time tracking, session duration, task completion time
 */
Example5_DurationCalculation() {
    output := "=== Example 5: Duration Calculations ===`n`n"

    ; Work session durations
    output .= "Work Session Durations:`n"
    sessions := [
        {start: "20240115090000", end: "20240115120000"},
        {start: "20240115130000", end: "20240115173000"},
        {start: "20240116083000", end: "20240116113000"}
    ]

    totalMinutes := 0

    for i, session in sessions {
        minutes := DateDiff(session.end, session.start, "minutes")
        hours := Format("{:.2f}", minutes / 60)
        totalMinutes += minutes

        output .= Format("  Session {:d}: {:s} - {:s} = {:d} min ({:s} hours)",
            i,
            FormatTime(session.start, "MMM dd h:mm tt"),
            FormatTime(session.end, "h:mm tt"),
            minutes,
            hours) . "`n"
    }

    output .= Format("`n  Total: {:d} minutes ({:.2f} hours)", totalMinutes, totalMinutes / 60) . "`n`n"

    ; Meeting durations
    output .= "Meeting Durations:`n"
    meetings := [
        {name: "Team Standup", start: "20240115090000", end: "20240115091500"},
        {name: "Client Call", start: "20240115100000", end: "20240115110000"},
        {name: "Planning Session", start: "20240115140000", end: "20240115160000"}
    ]

    for meeting in meetings {
        duration := DateDiff(meeting.end, meeting.start, "minutes")
        output .= Format("  {:-20s}: {:d} minutes",
            meeting.name,
            duration) . "`n"
    }

    ; Project phase durations
    output .= "`n`nProject Phase Durations:`n"
    phases := [
        {name: "Planning", start: "20240101000000", end: "20240115000000"},
        {name: "Development", start: "20240115000000", end: "20240301000000"},
        {name: "Testing", start: "20240301000000", end: "20240315000000"}
    ]

    for phase in phases {
        days := DateDiff(phase.end, phase.start, "days")
        weeks := Format("{:.1f}", days / 7)

        output .= Format("  {:-15s}: {:d} days ({:s} weeks)",
            phase.name,
            days,
            weeks) . "`n"
    }

    MsgBox(output, "Duration Calculations", 262144)
}

; ============================================================================
; Example 6: Subscription and Service Period Tracking
; ============================================================================

/**
 * Tracks subscription periods and calculates remaining time.
 * Common use: Subscription management, trial tracking, membership systems
 */
Example6_SubscriptionTracking() {
    output := "=== Example 6: Subscription Tracking ===`n`n"
    today := A_Now

    ; Active subscriptions
    subscriptions := [
        {service: "Cloud Storage", start: "20230101000000", term: 12},
        {service: "Software License", start: "20230615000000", term: 12},
        {service: "Support Plan", start: "20230901000000", term: 6},
        {service: "Training Access", start: "20231115000000", term: 3}
    ]

    output .= "Active Subscriptions:`n`n"

    for sub in subscriptions {
        endDate := DateAdd(sub.start, sub.term, "months")
        daysRemaining := DateDiff(endDate, today, "days")
        totalDays := DateDiff(endDate, sub.start, "days")
        percentUsed := ((totalDays - daysRemaining) / totalDays) * 100

        status := daysRemaining > 30 ? "Active"
            : (daysRemaining > 0 ? "Expiring Soon" : "Expired")

        output .= sub.service . ":`n"
        output .= "  Started: " . FormatTime(sub.start, "MMM dd, yyyy") . "`n"
        output .= "  Expires: " . FormatTime(endDate, "MMM dd, yyyy") . "`n"
        output .= Format("  Remaining: {:d} days ({:.1f}% used)",
            daysRemaining,
            percentUsed) . "`n"
        output .= "  Status: " . status . "`n`n"
    }

    ; Trial periods
    output .= "Trial Period Status:`n"
    trials := [
        {app: "App A", start: DateAdd(today, -5, "days"), duration: 14},
        {app: "App B", start: DateAdd(today, -10, "days"), duration: 30},
        {app: "App C", start: DateAdd(today, -25, "days"), duration: 30}
    ]

    for trial in trials {
        endDate := DateAdd(trial.start, trial.duration, "days")
        daysRemaining := DateDiff(endDate, today, "days")
        daysUsed := DateDiff(today, trial.start, "days")

        if (daysRemaining > 0) {
            output .= Format("  {:s}: {:d}/{:d} days used ({:d} days left)",
                trial.app,
                daysUsed,
                trial.duration,
                daysRemaining) . "`n"
        } else {
            output .= Format("  {:s}: Trial expired {:d} days ago",
                trial.app,
                -daysRemaining) . "`n"
        }
    }

    MsgBox(output, "Subscription Tracking", 262144)
}

; ============================================================================
; Example 7: Comparative Date Analysis
; ============================================================================

/**
 * Compares multiple dates and finds relationships.
 * Common use: Data analysis, timeline comparison, scheduling
 */
Example7_ComparativeDates() {
    output := "=== Example 7: Comparative Date Analysis ===`n`n"

    ; Compare multiple dates
    dates := [
        {event: "Project Kickoff", date: "20240101000000"},
        {event: "First Milestone", date: "20240201000000"},
        {event: "Mid-Point Review", date: "20240301000000"},
        {event: "Final Delivery", date: "20240401000000"}
    ]

    output .= "Event Timeline Comparison:`n`n"

    ; Calculate gaps between consecutive events
    for i, event in dates {
        output .= event.event . ": " . FormatTime(event.date, "MMM dd, yyyy") . "`n"

        if (i > 1) {
            daysBetween := DateDiff(event.date, dates[i-1].date, "days")
            output .= Format("  ({:d} days from previous event)", daysBetween) . "`n"
        }
        output .= "`n"
    }

    ; Find longest and shortest gaps
    output .= "Gap Analysis:`n"
    maxGap := 0
    minGap := 999999
    maxPair := ""
    minPair := ""

    for i, event in dates {
        if (i > 1) {
            gap := DateDiff(event.date, dates[i-1].date, "days")

            if (gap > maxGap) {
                maxGap := gap
                maxPair := dates[i-1].event . " → " . event.event
            }

            if (gap < minGap) {
                minGap := gap
                minPair := dates[i-1].event . " → " . event.event
            }
        }
    }

    output .= "  Longest gap: " . maxGap . " days (" . maxPair . ")`n"
    output .= "  Shortest gap: " . minGap . " days (" . minPair . ")`n`n"

    ; Total project duration
    totalDays := DateDiff(dates[dates.Length].date, dates[1].date, "days")
    output .= "Total Timeline: " . totalDays . " days (" . Format("{:.1f}", totalDays / 7) . " weeks)`n"

    MsgBox(output, "Comparative Dates", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
    (
    DateDiff() - Basic Calculations

    Examples:
    1. Basic Time Differences
    2. Age Calculation
    3. Event Countdown
    4. Time Since Events
    5. Duration Calculation
    6. Subscription Tracking
    7. Comparative Dates

    Press Ctrl+1-7 to run examples
    )"
    MsgBox(menu, "DateDiff Examples", 4096)
}

^1::Example1_BasicDifferences()
^2::Example2_AgeCalculation()
^3::Example3_EventCountdown()
^4::Example4_TimeSinceEvents()
^5::Example5_DurationCalculation()
^6::Example6_SubscriptionTracking()
^7::Example7_ComparativeDates()
^m::ShowMenu()

ShowMenu()
