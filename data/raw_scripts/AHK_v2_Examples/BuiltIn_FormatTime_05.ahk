#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FormatTime Function - Specialized Formatting and Edge Cases
 * ============================================================================
 *
 * This script demonstrates specialized FormatTime() scenarios including
 * edge cases, special dates, and complex formatting requirements.
 *
 * @description Specialized FormatTime() scenarios and edge cases
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Specialized Topics:
 * - Leap year handling
 * - Daylight saving time considerations
 * - Month-end calculations
 * - Holiday detection
 * - Anniversary calculations
 */

; ============================================================================
; Example 1: Leap Year and Month-End Handling
; ============================================================================

/**
 * Handles leap years and month-end edge cases properly.
 * Common use: Date validation, calendar applications, billing systems
 */
Example1_LeapYearHandling() {
    ; Check if year is a leap year
    IsLeapYear(year) {
        return (Mod(year, 4) = 0 && Mod(year, 100) != 0) || Mod(year, 400) = 0
    }

    ; Get days in month
    DaysInMonth(year, month) {
        daysPerMonth := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        if (month = 2 && IsLeapYear(year))
            return 29
        return daysPerMonth[month]
    }

    output := "=== Example 1: Leap Year Handling ===`n`n"

    ; Leap year analysis
    output .= "Leap Year Detection:`n"
    years := [2020, 2021, 2024, 2100, 2000]

    for year in years {
        isLeap := IsLeapYear(year)
        febDays := DaysInMonth(year, 2)

        output .= Format("  {:d}: {:s} (February has {:d} days)",
            year,
            isLeap ? "✓ Leap Year" : "✗ Not Leap Year",
            febDays) . "`n"
    }

    ; Month-end dates for current year
    output .= "`n`nMonth-End Dates (Current Year):`n"
    year := Integer(FormatTime(A_Now, "yyyy"))

    loop 12 {
        month := A_Index
        days := DaysInMonth(year, month)
        lastDay := year . Format("{:02d}", month) . Format("{:02d}", days) . "000000"

        output .= Format("  {:-10s}: {:s} ({:d} days)",
            FormatTime(lastDay, "MMMM"),
            FormatTime(lastDay, "MMM dd, yyyy"),
            days) . "`n"
    }

    ; Leap day examples
    output .= "`n`nLeap Day Examples:`n"
    leapYears := [2020, 2024, 2028]

    for leapYear in leapYears {
        leapDay := leapYear . "0229000000"
        output .= "  " . FormatTime(leapDay, "dddd, MMMM dd, yyyy") . "`n"
    }

    ; Month-end arithmetic
    output .= "`n`nMonth-End Arithmetic:`n"
    jan31 := FormatTime(A_Now, "yyyy") . "0131000000"

    output .= "  Starting: " . FormatTime(jan31, "MMM dd") . "`n"
    output .= "  +1 month: " . FormatTime(DateAdd(jan31, 1, "months"), "MMM dd") . "`n"
    output .= "  +2 months: " . FormatTime(DateAdd(jan31, 2, "months"), "MMM dd") . "`n"
    output .= "  +3 months: " . FormatTime(DateAdd(jan31, 3, "months"), "MMM dd") . "`n"

    MsgBox(output, "Leap Year Handling", 262144)
}

; ============================================================================
; Example 2: Holiday Detection and Calculation
; ============================================================================

/**
 * Detects and calculates various holidays.
 * Common use: Calendar apps, scheduling systems, business day calculations
 */
Example2_HolidayCalculation() {
    ; Check if date is a US federal holiday
    IsUSHoliday(timestamp) {
        year := Integer(FormatTime(timestamp, "yyyy"))
        month := Integer(FormatTime(timestamp, "MM"))
        day := Integer(FormatTime(timestamp, "dd"))
        dayOfWeek := Integer(FormatTime(timestamp, "w"))

        ; Fixed holidays
        if (month = 1 && day = 1)
            return "New Year's Day"
        if (month = 7 && day = 4)
            return "Independence Day"
        if (month = 11 && day = 11)
            return "Veterans Day"
        if (month = 12 && day = 25)
            return "Christmas Day"

        ; Martin Luther King Jr. Day - 3rd Monday in January
        if (month = 1 && dayOfWeek = 2) {
            weekNum := Ceil(day / 7)
            if (weekNum = 3)
                return "Martin Luther King Jr. Day"
        }

        ; Presidents Day - 3rd Monday in February
        if (month = 2 && dayOfWeek = 2) {
            weekNum := Ceil(day / 7)
            if (weekNum = 3)
                return "Presidents Day"
        }

        ; Memorial Day - Last Monday in May
        if (month = 5 && dayOfWeek = 2) {
            ; Check if next Monday is in June
            nextWeek := DateAdd(timestamp, 7, "days")
            if (FormatTime(nextWeek, "MM") = "06")
                return "Memorial Day"
        }

        ; Labor Day - 1st Monday in September
        if (month = 9 && dayOfWeek = 2 && day <= 7)
            return "Labor Day"

        ; Thanksgiving - 4th Thursday in November
        if (month = 11 && dayOfWeek = 5) {
            weekNum := Ceil(day / 7)
            if (weekNum = 4)
                return "Thanksgiving"
        }

        return ""
    }

    output := "=== Example 2: Holiday Calculation ===`n`n"
    year := Integer(FormatTime(A_Now, "yyyy"))

    ; Check holidays for current year
    output .= "US Federal Holidays " . year . ":`n"

    holidays := []

    ; Check each day of the year
    date := year . "0101000000"
    endDate := year . "1231000000"

    while (date <= endDate) {
        holiday := IsUSHoliday(date)
        if (holiday != "") {
            holidays.Push({date: date, name: holiday})
        }
        date := DateAdd(date, 1, "days")
    }

    for holiday in holidays {
        output .= Format("  {:-25s}: {:s}",
            holiday.name,
            FormatTime(holiday.date, "dddd, MMMM dd")) . "`n"
    }

    ; Upcoming holidays
    output .= "`n`nUpcoming Holidays:`n"
    today := A_Now
    upcomingCount := 0

    for holiday in holidays {
        if (holiday.date > today && upcomingCount < 3) {
            daysUntil := DateDiff(holiday.date, today, "days")
            output .= Format("  {:-25s}: in {:d} days ({:s})",
                holiday.name,
                daysUntil,
                FormatTime(holiday.date, "MMM dd")) . "`n"
            upcomingCount++
        }
    }

    MsgBox(output, "Holiday Calculation", 262144)
}

; ============================================================================
; Example 3: Anniversary and Recurring Date Calculator
; ============================================================================

/**
 * Calculates anniversaries and recurring dates.
 * Common use: Reminder systems, subscription tracking, event planning
 */
Example3_AnniversaryCalculator() {
    ; Calculate next anniversary
    NextAnniversary(originalDate) {
        today := A_Now
        thisYear := FormatTime(today, "yyyy")

        ; Anniversary date this year
        anniversaryThisYear := thisYear
            . FormatTime(originalDate, "MM")
            . FormatTime(originalDate, "dd")
            . "000000"

        ; If it's passed, get next year's
        if (today > anniversaryThisYear) {
            nextYear := Integer(thisYear) + 1
            return nextYear
                . FormatTime(originalDate, "MM")
                . FormatTime(originalDate, "dd")
                . "000000"
        }

        return anniversaryThisYear
    }

    output := "=== Example 3: Anniversary Calculator ===`n`n"

    ; Sample anniversaries
    anniversaries := [
        {event: "Company Founded", date: "20150315000000"},
        {event: "Service Launched", date: "20180701000000"},
        {event: "Partnership Started", date: "20200110000000"},
        {event: "First Customer", date: "20190425000000"}
    ]

    output .= "Important Anniversaries:`n`n"

    for item in anniversaries {
        original := FormatTime(item.date, "MMMM dd, yyyy")
        yearsAgo := DateDiff(A_Now, item.date, "years")
        nextDate := NextAnniversary(item.date)
        daysUntil := DateDiff(nextDate, A_Now, "days")
        nextAnniversary := yearsAgo + (nextDate > A_Now ? 1 : 0)

        output .= item.event . ":`n"
        output .= "  Original Date: " . original . " (" . yearsAgo . " years ago)`n"
        output .= "  Next Anniversary: " . FormatTime(nextDate, "MMMM dd, yyyy")
            . " (" . nextAnniversary . " years)`n"
        output .= "  Days Until: " . daysUntil . " days`n`n"
    }

    ; Subscription renewals
    output .= "Subscription Renewals:`n"
    subscriptions := [
        {service: "Cloud Storage", start: "20230101000000", term: 12},
        {service: "Software License", start: "20230315000000", term: 12},
        {service: "Support Plan", start: "20230601000000", term: 6}
    ]

    for sub in subscriptions {
        renewal := DateAdd(sub.start, sub.term, "months")

        ; Find next renewal date
        while (renewal < A_Now) {
            renewal := DateAdd(renewal, sub.term, "months")
        }

        daysUntil := DateDiff(renewal, A_Now, "days")
        output .= Format("  {:-20s}: {:s} (in {:d} days)",
            sub.service,
            FormatTime(renewal, "MMM dd, yyyy"),
            daysUntil) . "`n"
    }

    MsgBox(output, "Anniversary Calculator", 262144)
}

; ============================================================================
; Example 4: Age Calculator with Precision
; ============================================================================

/**
 * Calculates precise ages including months and days.
 * Common use: HR systems, membership management, age verification
 */
Example4_PreciseAge() {
    ; Calculate exact age in years, months, and days
    CalculatePreciseAge(birthDate) {
        today := A_Now

        years := DateDiff(today, birthDate, "years")

        ; Check if birthday has occurred this year
        birthdayThisYear := FormatTime(today, "yyyy")
            . FormatTime(birthDate, "MM")
            . FormatTime(birthDate, "dd")
            . "000000"

        if (today < birthdayThisYear)
            years--

        ; Calculate from last birthday
        lastBirthday := (Integer(FormatTime(today, "yyyy")) - years)
            . FormatTime(birthDate, "MM")
            . FormatTime(birthDate, "dd")
            . "000000"

        ; If we're before the birth month/day, go back a year
        if (today < lastBirthday)
            lastBirthday := DateAdd(lastBirthday, -1, "years")

        months := DateDiff(today, lastBirthday, "months")

        ; Calculate days from start of current month
        monthAgo := DateAdd(today, -months, "months")
        days := DateDiff(today, monthAgo, "days")

        return {years: years, months: Mod(months, 12), days: days}
    }

    output := "=== Example 4: Precise Age Calculator ===`n`n"

    ; Sample birthdates
    people := [
        {name: "Alice Johnson", birth: "19900515000000"},
        {name: "Bob Smith", birth: "19851203000000"},
        {name: "Carol Williams", birth: "20001001000000"},
        {name: "David Brown", birth: "19750710000000"}
    ]

    output .= "Precise Age Calculations:`n`n"

    for person in people {
        age := CalculatePreciseAge(person.birth)
        birthStr := FormatTime(person.birth, "MMMM dd, yyyy")

        output .= person.name . ":`n"
        output .= "  Born: " . birthStr . "`n"
        output .= Format("  Age: {:d} years, {:d} months, {:d} days",
            age.years,
            age.months,
            age.days) . "`n"

        ; Next birthday
        nextBirthday := FormatTime(A_Now, "yyyy")
            . FormatTime(person.birth, "MM")
            . FormatTime(person.birth, "dd")
            . "000000"

        if (nextBirthday <= A_Now) {
            nextBirthday := DateAdd(nextBirthday, 1, "years")
        }

        daysUntilBirthday := DateDiff(nextBirthday, A_Now, "days")
        output .= "  Next Birthday: " . FormatTime(nextBirthday, "MMMM dd, yyyy")
            . " (in " . daysUntilBirthday . " days)`n`n"
    }

    ; Age categories
    output .= "Age Category Examples:`n"
    ageCategories := [
        {age: 5, category: "Preschool"},
        {age: 18, category: "Adult"},
        {age: 21, category: "Legal Drinking Age (US)"},
        {age: 65, category: "Senior Citizen"}
    ]

    for cat in ageCategories {
        output .= Format("  {:-30s}: {:d}+ years", cat.category, cat.age) . "`n"
    }

    MsgBox(output, "Precise Age Calculator", 262144)
}

; ============================================================================
; Example 5: Quarter and Period Management
; ============================================================================

/**
 * Manages fiscal quarters and custom periods.
 * Common use: Financial reporting, business analytics
 */
Example5_QuarterManagement() {
    ; Get quarter information
    GetQuarterInfo(timestamp, fyStart := 1) {
        month := Integer(FormatTime(timestamp, "MM"))
        year := Integer(FormatTime(timestamp, "yyyy"))

        ; Adjust for fiscal year
        fiscalMonth := month - fyStart + 1
        if (fiscalMonth <= 0) {
            fiscalMonth += 12
            fiscalYear := year
        } else {
            fiscalYear := year + (fyStart > 1 ? 1 : 0)
        }

        quarter := Ceil(fiscalMonth / 3)

        ; Calculate quarter start and end
        qStartMonth := ((quarter - 1) * 3) + fyStart
        if (qStartMonth > 12)
            qStartMonth -= 12

        qStartYear := fyStart > 1 && qStartMonth < fyStart ? year : (year - (fiscalMonth <= 0 ? 1 : 0))
        qStart := qStartYear . Format("{:02d}", qStartMonth) . "01000000"

        qEnd := DateAdd(DateAdd(qStart, 3, "months"), -1, "days")

        return {
            quarter: quarter,
            fiscalYear: fiscalYear,
            start: qStart,
            end: qEnd
        }
    }

    output := "=== Example 5: Quarter Management ===`n`n"
    today := A_Now

    ; Calendar year quarters
    output .= "Calendar Year Quarters:`n"
    qInfo := GetQuarterInfo(today, 1)

    output .= "  Current Quarter: Q" . qInfo.quarter . " " . qInfo.fiscalYear . "`n"
    output .= "  Period: " . FormatTime(qInfo.start, "MMM dd") . " - "
        . FormatTime(qInfo.end, "MMM dd, yyyy") . "`n"

    daysPassed := DateDiff(today, qInfo.start, "days")
    totalDays := DateDiff(qInfo.end, qInfo.start, "days") + 1
    progress := (daysPassed / totalDays) * 100

    output .= Format("  Progress: {:.1f}% ({:d}/{:d} days)", progress, daysPassed, totalDays) . "`n`n"

    ; All quarters this year
    output .= "All Quarters This Year:`n"
    year := FormatTime(today, "yyyy")

    loop 4 {
        q := A_Index
        qStart := year . Format("{:02d}", ((q - 1) * 3) + 1) . "01000000"
        qEnd := DateAdd(DateAdd(qStart, 3, "months"), -1, "days")

        output .= Format("  Q{:d}: {:s} - {:s}",
            q,
            FormatTime(qStart, "MMM dd"),
            FormatTime(qEnd, "MMM dd")) . "`n"
    }

    ; Fiscal year quarters (July start)
    output .= "`n`nFiscal Year Quarters (July Start):`n"
    fyInfo := GetQuarterInfo(today, 7)

    output .= "  Current FQ: Q" . fyInfo.quarter . " FY" . fyInfo.fiscalYear . "`n"
    output .= "  Period: " . FormatTime(fyInfo.start, "MMM dd") . " - "
        . FormatTime(fyInfo.end, "MMM dd, yyyy") . "`n"

    MsgBox(output, "Quarter Management", 262144)
}

; ============================================================================
; Example 6: Date Range Validator
; ============================================================================

/**
 * Validates date ranges and checks for overlaps.
 * Common use: Booking systems, scheduling, conflict detection
 */
Example6_DateRangeValidator() {
    ; Check if two ranges overlap
    RangesOverlap(start1, end1, start2, end2) {
        return !(end1 < start2 || end2 < start1)
    }

    ; Check if date is in range
    DateInRange(date, rangeStart, rangeEnd) {
        return date >= rangeStart && date <= rangeEnd
    }

    output := "=== Example 6: Date Range Validator ===`n`n"

    ; Sample bookings
    bookings := [
        {name: "Conference Room A", start: "20240115090000", end: "20240115110000"},
        {name: "Conference Room B", start: "20240115100000", end: "20240115120000"},
        {name: "Conference Room C", start: "20240115130000", end: "20240115150000"}
    ]

    output .= "Existing Bookings:`n"
    for booking in bookings {
        output .= Format("  {:-18s}: {:s} - {:s}",
            booking.name,
            FormatTime(booking.start, "h:mm tt"),
            FormatTime(booking.end, "h:mm tt")) . "`n"
    }

    ; Check new booking for conflicts
    newBooking := {start: "20240115103000", end: "20240115123000"}

    output .= "`n`nNew Booking Request:`n"
    output .= "  Time: " . FormatTime(newBooking.start, "h:mm tt")
        . " - " . FormatTime(newBooking.end, "h:mm tt") . "`n`n"

    output .= "Conflict Check:`n"
    hasConflict := false

    for booking in bookings {
        overlap := RangesOverlap(newBooking.start, newBooking.end,
            booking.start, booking.end)

        if (overlap) {
            output .= "  ✗ Conflicts with " . booking.name . "`n"
            hasConflict := true
        }
    }

    if (!hasConflict) {
        output .= "  ✓ No conflicts - booking available`n"
    }

    ; Date range validation
    output .= "`n`nDate Range Validation:`n"
    ranges := [
        {desc: "Project Phase 1", start: "20240101000000", end: "20240331000000"},
        {desc: "Project Phase 2", start: "20240401000000", end: "20240630000000"},
        {desc: "Invalid Range", start: "20240701000000", end: "20240601000000"}  ; End before start
    ]

    for range in ranges {
        valid := range.end >= range.start
        status := valid ? "✓ Valid" : "✗ Invalid (end before start)"

        output .= Format("  {:-20s}: {:s}", range.desc, status) . "`n"

        if (valid) {
            days := DateDiff(range.end, range.start, "days") + 1
            output .= Format("    Duration: {:d} days", days) . "`n"
        }
    }

    MsgBox(output, "Date Range Validator", 262144)
}

; ============================================================================
; Example 7: Complex Date Formatting Utilities
; ============================================================================

/**
 * Provides utility functions for complex date formatting scenarios.
 * Common use: Utilities library, date formatting helpers
 */
Example7_FormattingUtilities() {
    ; Format duration between two dates
    FormatDateDifference(startDate, endDate) {
        years := DateDiff(endDate, startDate, "years")
        months := DateDiff(endDate, startDate, "months") - (years * 12)
        days := DateDiff(endDate, startDate, "days")

        parts := []
        if (years > 0)
            parts.Push(years . " year" . (years > 1 ? "s" : ""))
        if (months > 0)
            parts.Push(months . " month" . (months > 1 ? "s" : ""))
        if (days > 0 && years = 0)
            parts.Push(days . " day" . (days > 1 ? "s" : ""))

        if (parts.Length = 0)
            return "Same day"

        result := ""
        for i, part in parts {
            result .= part
            if (i < parts.Length - 1)
                result .= ", "
            else if (i = parts.Length - 1 && parts.Length > 1)
                result .= " and "
        }
        return result
    }

    ; Format relative date
    FormatRelativeDate(date) {
        today := A_Now
        daysDiff := DateDiff(date, today, "days")

        if (daysDiff = 0)
            return "Today"
        else if (daysDiff = 1)
            return "Tomorrow"
        else if (daysDiff = -1)
            return "Yesterday"
        else if (daysDiff > 0 && daysDiff <= 7)
            return FormatTime(date, "dddd") . " (in " . daysDiff . " days)"
        else if (daysDiff < 0 && daysDiff >= -7)
            return FormatTime(date, "dddd") . " (" . (-daysDiff) . " days ago)"
        else
            return FormatTime(date, "MMMM dd, yyyy")
    }

    output := "=== Example 7: Formatting Utilities ===`n`n"
    today := A_Now

    ; Date difference examples
    output .= "Date Difference Formatting:`n"
    ranges := [
        {start: "20230101000000", end: "20240115000000"},
        {start: "20220601000000", end: today},
        {start: "20231215000000", end: "20240101000000"}
    ]

    for range in ranges {
        diff := FormatDateDifference(range.start, range.end)
        output .= "  " . FormatTime(range.start, "MMM dd, yyyy")
            . " to " . FormatTime(range.end, "MMM dd, yyyy") . ":`n"
        output .= "    " . diff . "`n"
    }

    ; Relative date formatting
    output .= "`n`nRelative Date Formatting:`n"
    dates := [
        DateAdd(today, -7, "days"),
        DateAdd(today, -1, "days"),
        today,
        DateAdd(today, 1, "days"),
        DateAdd(today, 3, "days"),
        DateAdd(today, 14, "days")
    ]

    for date in dates {
        output .= "  " . FormatTime(date, "yyyy-MM-dd") . " = "
            . FormatRelativeDate(date) . "`n"
    }

    ; Ordinal day formatting
    output .= "`n`nOrdinal Date Formatting:`n"
    GetOrdinalSuffix(day) {
        if (day >= 11 && day <= 13)
            return "th"
        switch Mod(day, 10) {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
        }
    }

    loop 5 {
        testDate := FormatTime(today, "yyyyMM") . Format("{:02d}", A_Index * 5) . "000000"
        day := Integer(FormatTime(testDate, "dd"))
        suffix := GetOrdinalSuffix(day)

        output .= "  " . FormatTime(testDate, "MMMM") . " "
            . day . suffix . ", "
            . FormatTime(testDate, "yyyy") . "`n"
    }

    MsgBox(output, "Formatting Utilities", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
    (
    FormatTime() - Specialized Formatting

    Examples:
    1. Leap Year Handling
    2. Holiday Calculation
    3. Anniversary Calculator
    4. Precise Age Calculator
    5. Quarter Management
    6. Date Range Validator
    7. Formatting Utilities

    Press Ctrl+1-7 to run examples
    )"
    MsgBox(menu, "FormatTime Specialized", 4096)
}

^1::Example1_LeapYearHandling()
^2::Example2_HolidayCalculation()
^3::Example3_AnniversaryCalculator()
^4::Example4_PreciseAge()
^5::Example5_QuarterManagement()
^6::Example6_DateRangeValidator()
^7::Example7_FormattingUtilities()
^m::ShowMenu()

ShowMenu()
