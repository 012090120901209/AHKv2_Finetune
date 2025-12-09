#Requires AutoHotkey v2.0

/**
* ============================================================================
* FormatTime Function - Custom Formats and Locale-Specific Formatting
* ============================================================================
*
* This script demonstrates custom date/time formatting patterns and
* locale-specific considerations when using FormatTime().
*
* @description Custom FormatTime() patterns and locale formatting
* @author AHK v2 Documentation Team
* @version 1.0.0
* @date 2024-01-15
*
* Advanced Format Features:
* - Custom text literals in format strings
* - Week numbers and day of year
* - Quarter calculations
* - Locale-aware formatting
* - Special characters and escaping
*/

; ============================================================================
; Example 1: Custom Format Patterns with Literals
; ============================================================================

/**
* Shows how to include literal text in format patterns.
* Common use: Custom date displays, specific format requirements
*/
Example1_CustomPatterns() {
    output := "=== Example 1: Custom Format Patterns ===`n`n"
    now := A_Now

    ; Using single quotes for literal text
    output .= "Literal Text in Formats:`n"
    output .= "  " . FormatTime(now, "'Today is' dddd") . "`n"
    output .= "  " . FormatTime(now, "MMMM dd'th', yyyy") . "`n"
    output .= "  " . FormatTime(now, "'Week of' MMMM dd") . "`n"
    output .= "  " . FormatTime(now, "dddd 'the' dd'th of' MMMM") . "`n"
    output .= "  " . FormatTime(now, "'Q'Q yyyy") . "`n`n"

    ; Email headers
    output .= "Email-Style Headers:`n"
    output .= "  Date: " . FormatTime(now, "ddd, dd MMM yyyy HH:mm:ss") . "`n"
    output .= "  Sent: " . FormatTime(now, "dddd, MMMM dd, yyyy 'at' hh:mm tt") . "`n`n"

    ; Technical formats
    output .= "Technical Formats:`n"
    output .= "  ISO 8601: " . FormatTime(now, "yyyy-MM-dd'T'HH:mm:ss") . "`n"
    output .= "  RFC 2822: " . FormatTime(now, "ddd, dd MMM yyyy HH:mm:ss") . " +0000`n"
    output .= "  Unix Log: " . FormatTime(now, "MMM dd HH:mm:ss") . "`n`n"

    ; Business formats
    output .= "Business Formats:`n"
    output .= "  Invoice: " . FormatTime(now, "'Date:' MM/dd/yyyy 'Time:' HH:mm") . "`n"
    output .= "  Receipt: " . FormatTime(now, "MM/dd/yy 'at' hh:mm tt") . "`n"
    output .= "  Statement: " . FormatTime(now, "MMMM dd, yyyy") . "`n"

    MsgBox(output, "Custom Patterns", 262144)
}

; ============================================================================
; Example 2: Week Numbers and Day of Year
; ============================================================================

/**
* Demonstrates formatting with week numbers and day of year.
* Common use: Calendar systems, ISO week dates, project planning
*/
Example2_WeekAndDayFormats() {
    output := "=== Example 2: Week Numbers and Day Calculations ===`n`n"
    now := A_Now

    ; Week number formats
    output .= "Week Number Formats:`n"
    weekNum := FormatTime(now, "ww")
    output .= "  Week of year: Week " . weekNum . "`n"
    output .= "  ISO Week: " . FormatTime(now, "yyyy") . "-W" . weekNum . "`n"
    output .= "  Full format: " . FormatTime(now, "yyyy 'Week' ww") . "`n`n"

    ; Day of week
    output .= "Day of Week Formats:`n"
    dayOfWeek := FormatTime(now, "w")  ; 1-7, Sunday=1
    output .= "  Numeric (1-7): " . dayOfWeek . "`n"
    output .= "  Short name: " . FormatTime(now, "ddd") . "`n"
    output .= "  Full name: " . FormatTime(now, "dddd") . "`n"
    output .= "  Custom: Day " . dayOfWeek . " of the week`n`n"

    ; Calculate day of year
    yearStart := FormatTime(now, "yyyy") . "0101000000"
    daysSinceYearStart := DateDiff(now, yearStart, "days") + 1
    output .= "Day of Year:`n"
    output .= "  Day " . daysSinceYearStart . " of " . FormatTime(now, "yyyy") . "`n"
    output .= "  Progress: " . Format("{:.1f}%", (daysSinceYearStart / 365) * 100) . " through the year`n`n"

    ; Quarter calculation
    month := Integer(FormatTime(now, "MM"))
    quarter := Ceil(month / 3)
    output .= "Quarter Information:`n"
    output .= "  Q" . quarter . " " . FormatTime(now, "yyyy") . "`n"
    output .= "  " . FormatTime(now, "MMMM") . " is in Quarter " . quarter . "`n`n"

    ; Working days calculation (approximate)
    output .= "Calendar Statistics:`n"
    output .= "  Current week: " . weekNum . " of 52`n"
    output .= "  Current month: " . FormatTime(now, "MMMM") . " (month " . FormatTime(now, "MM") . " of 12)`n"
    output .= "  Current quarter: Q" . quarter . " of 4`n"

    MsgBox(output, "Week and Day Formats", 262144)
}

; ============================================================================
; Example 3: Multi-Locale Date Formatting
; ============================================================================

/**
* Demonstrates formatting dates for different locales and regions.
* Common use: International applications, multi-region systems
*/
Example3_LocaleFormatting() {
    output := "=== Example 3: Locale-Specific Formatting ===`n`n"
    now := A_Now

    ; American format
    output .= "American (US) Format:`n"
    output .= "  Short: " . FormatTime(now, "M/d/yyyy") . "`n"
    output .= "  Long: " . FormatTime(now, "MMMM d, yyyy") . "`n"
    output .= "  Full: " . FormatTime(now, "dddd, MMMM d, yyyy 'at' h:mm tt") . "`n`n"

    ; European format
    output .= "European Format:`n"
    output .= "  Short: " . FormatTime(now, "dd/MM/yyyy") . "`n"
    output .= "  Long: " . FormatTime(now, "d MMMM yyyy") . "`n"
    output .= "  Full: " . FormatTime(now, "dddd d MMMM yyyy 'at' HH:mm") . "`n`n"

    ; ISO 8601 (International Standard)
    output .= "ISO 8601 (International):`n"
    output .= "  Date: " . FormatTime(now, "yyyy-MM-dd") . "`n"
    output .= "  DateTime: " . FormatTime(now, "yyyy-MM-dd'T'HH:mm:ss") . "`n"
    output .= "  Week: " . FormatTime(now, "yyyy-'W'ww") . "`n`n"

    ; Asian formats
    output .= "Asian Formats:`n"
    output .= "  Japanese: " . FormatTime(now, "yyyy'年'M'月'd'日'") . "`n"
    output .= "  Chinese: " . FormatTime(now, "yyyy'年'MM'月'dd'日'") . "`n"
    output .= "  Korean: " . FormatTime(now, "yyyy'년' M'월' d'일'") . "`n`n"

    ; Other regions
    output .= "Other Regional Formats:`n"
    output .= "  UK: " . FormatTime(now, "dd/MM/yyyy HH:mm") . "`n"
    output .= "  Canada: " . FormatTime(now, "yyyy-MM-dd") . "`n"
    output .= "  Australia: " . FormatTime(now, "d/MM/yyyy") . "`n"
    output .= "  South Africa: " . FormatTime(now, "yyyy/MM/dd") . "`n"

    MsgBox(output, "Locale Formatting", 262144)
}

; ============================================================================
; Example 4: Business Date Formats
; ============================================================================

/**
* Shows formatting for business documents and applications.
* Common use: Invoices, contracts, reports, correspondence
*/
Example4_BusinessFormats() {
    ; Generate business document header
    GenerateDocumentHeader(docType, docNum) {
        now := A_Now
        header := ""

        header .= docType . " #" . Format("{:06d}", docNum) . "`n"
        header .= StrReplace(Format("{:60s}", ""), " ", "─") . "`n"
        header .= "Date Issued: " . FormatTime(now, "MMMM dd, yyyy") . "`n"
        header .= "Time: " . FormatTime(now, "hh:mm tt") . "`n"

        ; Calculate due date (30 days from now)
        dueDate := DateAdd(now, 30, "days")
        header .= "Due Date: " . FormatTime(dueDate, "MMMM dd, yyyy") . "`n"

        return header
    }

    output := "=== Example 4: Business Date Formats ===`n`n"
    now := A_Now

    ; Invoice header
    output .= GenerateDocumentHeader("INVOICE", 12345) . "`n`n"

    ; Contract dates
    output .= "Contract Period:`n"
    startDate := now
    endDate := DateAdd(now, 365, "days")
    output .= "  Effective: " . FormatTime(startDate, "MMMM dd, yyyy") . "`n"
    output .= "  Expires: " . FormatTime(endDate, "MMMM dd, yyyy") . "`n"
    output .= "  Term: 12 months`n`n"

    ; Statement period
    firstDay := FormatTime(now, "yyyy") . FormatTime(now, "MM") . "01000000"
    lastDay := DateAdd(DateAdd(firstDay, 1, "months"), -1, "days")
    output .= "Statement Period:`n"
    output .= "  From: " . FormatTime(firstDay, "MMMM dd, yyyy") . "`n"
    output .= "  To: " . FormatTime(lastDay, "MMMM dd, yyyy") . "`n`n"

    ; Payment terms
    output .= "Payment Terms:`n"
    net30 := DateAdd(now, 30, "days")
    net60 := DateAdd(now, 60, "days")
    output .= "  Net 30: Payment due by " . FormatTime(net30, "MM/dd/yyyy") . "`n"
    output .= "  Net 60: Payment due by " . FormatTime(net60, "MM/dd/yyyy") . "`n`n"

    ; Fiscal periods
    fiscalYear := Integer(FormatTime(now, "yyyy"))
    month := Integer(FormatTime(now, "MM"))
    if (month >= 7)
    fiscalYear++

    output .= "Fiscal Information:`n"
    output .= "  Fiscal Year: FY" . fiscalYear . "`n"
    output .= "  Current Quarter: Q" . Ceil(month / 3) . "`n"

    MsgBox(output, "Business Formats", 262144)
}

; ============================================================================
; Example 5: Time Zone and UTC Formatting
; ============================================================================

/**
* Demonstrates formatting for different time zones.
* Common use: Global applications, server logs, distributed systems
*/
Example5_TimeZoneFormatting() {
    output := "=== Example 5: Time Zone Formatting ===`n`n"
    now := A_Now
    nowUTC := A_NowUTC

    ; Local vs UTC
    output .= "Local vs UTC Time:`n"
    output .= "  Local: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "  UTC: " . FormatTime(nowUTC, "yyyy-MM-dd HH:mm:ss 'UTC'") . "`n`n"

    ; ISO 8601 with time zone
    output .= "ISO 8601 Formats:`n"
    output .= "  Local: " . FormatTime(now, "yyyy-MM-dd'T'HH:mm:ss") . "`n"
    output .= "  UTC: " . FormatTime(nowUTC, "yyyy-MM-dd'T'HH:mm:ss'Z'") . "`n`n"

    ; Server log formats
    output .= "Server Log Formats:`n"
    output .= "  Apache: " . FormatTime(now, "dd/MMM/yyyy:HH:mm:ss") . " +0000`n"
    output .= "  Nginx: " . FormatTime(now, "dd/MMM/yyyy:HH:mm:ss") . " +0000`n"
    output .= "  IIS: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss") . "`n`n"

    ; Application timestamps
    output .= "Application Timestamps:`n"
    output .= "  Database: " . FormatTime(nowUTC, "yyyy-MM-dd HH:mm:ss 'UTC'") . "`n"
    output .= "  API Response: " . FormatTime(nowUTC, "yyyy-MM-dd'T'HH:mm:ss'Z'") . "`n"
    output .= "  Log Entry: " . FormatTime(now, "yyyy-MM-dd HH:mm:ss.000") . "`n`n"

    ; Display for different time zones (conceptual)
    output .= "Time Zone Display (Conceptual):`n"
    output .= "  Pacific: " . FormatTime(now, "h:mm tt") . " PST`n"
    output .= "  Eastern: " . FormatTime(now, "h:mm tt") . " EST`n"
    output .= "  London: " . FormatTime(now, "HH:mm") . " GMT`n"
    output .= "  Tokyo: " . FormatTime(now, "HH:mm") . " JST`n"

    MsgBox(output, "Time Zone Formatting", 262144)
}

; ============================================================================
; Example 6: Age and Duration Calculator
; ============================================================================

/**
* Calculates and formats ages and durations.
* Common use: User profiles, subscription tracking, event planning
*/
Example6_AgeCalculator() {
    ; Calculate age from birthdate
    CalculateAge(birthDate) {
        now := A_Now
        years := DateDiff(now, birthDate, "years")
        birthdayThisYear := FormatTime(birthDate, "MM") . FormatTime(birthDate, "dd") . FormatTime(now, "yyyy") . "000000"

        if (now < birthdayThisYear)
        years--

        return years
    }

    ; Format age string
    FormatAge(birthDate) {
        age := CalculateAge(birthDate)
        birthDateStr := FormatTime(birthDate, "MMMM dd, yyyy")
        return Format("Age {:d} (Born {:s})", age, birthDateStr)
    }

    output := "=== Example 6: Age and Duration Calculator ===`n`n"

    ; Sample birthdates
    output .= "Age Calculations:`n"
    birthDates := [
    "19900515120000",  ; May 15, 1990
    "19851203080000",  ; Dec 3, 1985
    "20000229140000",  ; Feb 29, 2000 (leap year)
    "19750710180000"   ; July 10, 1975
    ]

    for birthDate in birthDates {
        output .= "  " . FormatAge(birthDate) . "`n"
    }

    ; Account age
    output .= "`n`nAccount Age Examples:`n"
    accountCreated := "20200115120000"  ; Jan 15, 2020
    daysSince := DateDiff(A_Now, accountCreated, "days")
    monthsSince := DateDiff(A_Now, accountCreated, "months")
    yearsSince := DateDiff(A_Now, accountCreated, "years")

    output .= "  Created: " . FormatTime(accountCreated, "MMMM dd, yyyy") . "`n"
    output .= "  Account age: " . yearsSince . " years, " . (monthsSince - (yearsSince * 12)) . " months`n"
    output .= "  Days active: " . daysSince . " days`n`n"

    ; Membership periods
    output .= "Membership Periods:`n"
    memberSince := "20190301000000"
    memberYears := DateDiff(A_Now, memberSince, "years")
    output .= "  Member since: " . FormatTime(memberSince, "MMMM yyyy") . "`n"
    output .= "  Years of service: " . memberYears . " years`n"

    ; Anniversary calculation
    nextAnniversary := FormatTime(memberSince, "MM") . FormatTime(memberSince, "dd") . FormatTime(A_Now, "yyyy") . "000000"
    if (A_Now > nextAnniversary)
    nextAnniversary := DateAdd(nextAnniversary, 1, "years")

    daysUntil := DateDiff(nextAnniversary, A_Now, "days")
    output .= "  Next anniversary: " . FormatTime(nextAnniversary, "MMMM dd, yyyy") . " (" . daysUntil . " days)`n"

    MsgBox(output, "Age Calculator", 262144)
}

; ============================================================================
; Example 7: Event Countdown and Planning
; ============================================================================

/**
* Creates countdown displays for future events.
* Common use: Event planning, deadlines, project milestones
*/
Example7_EventCountdown() {
    ; Create countdown display
    FormatCountdown(eventDate, eventName) {
        now := A_Now
        daysUntil := DateDiff(eventDate, now, "days")
        hoursUntil := DateDiff(eventDate, now, "hours")
        minutesUntil := DateDiff(eventDate, now, "minutes")

        eventDateStr := FormatTime(eventDate, "dddd, MMMM dd, yyyy 'at' hh:mm tt")

        countdown := eventName . "`n"
        countdown .= "  Date: " . eventDateStr . "`n"

        if (daysUntil > 0) {
            hours := Mod(hoursUntil, 24)
            countdown .= "  Countdown: " . daysUntil . " days, " . hours . " hours`n"
        } else if (hoursUntil > 0) {
            mins := Mod(minutesUntil, 60)
            countdown .= "  Countdown: " . hoursUntil . " hours, " . mins . " minutes`n"
        } else {
            countdown .= "  Countdown: " . minutesUntil . " minutes`n"
        }

        return countdown
    }

    output := "=== Example 7: Event Countdown ===`n`n"

    ; Upcoming events
    events := [
    {
        name: "Project Deadline", date: DateAdd(A_Now, 7, "days")},
        {
            name: "Team Meeting", date: DateAdd(A_Now, 2, "days")},
            {
                name: "Product Launch", date: DateAdd(A_Now, 30, "days")},
                {
                    name: "Conference", date: DateAdd(A_Now, 60, "days")
                }
                ]

                for event in events {
                    output .= FormatCountdown(event.date, event.name) . "`n"
                }

                ; Important dates this year
                today := A_Now
                year := FormatTime(today, "yyyy")

                output .= "`nImportant Dates This Year:`n"
                importantDates := [
                {
                    name: "New Year's Day", date: year . "0101000000"},
                    {
                        name: "Independence Day", date: year . "0704000000"},
                        {
                            name: "Thanksgiving", date: year . "1128000000"},  ; Approximate
                            {
                                name: "Christmas", date: year . "1225000000"},
                                {
                                    name: "New Year's Eve", date: year . "1231000000"
                                }
                                ]

                                for dateInfo in importantDates {
                                    if (dateInfo.date > today) {
                                        daysUntil := DateDiff(dateInfo.date, today, "days")
                                        output .= "  " . Format("{:-20s} - {:s} ({:d} days)",
                                        dateInfo.name,
                                        FormatTime(dateInfo.date, "MMM dd"),
                                        daysUntil) . "`n"
                                    }
                                }

                                MsgBox(output, "Event Countdown", 262144)
                            }

                            ; ============================================================================
                            ; Main Menu and Hotkeys
                            ; ============================================================================

                            ShowMenu() {
                                menu := "
                                (
                                FormatTime() - Custom Formats and Locales

                                Examples:
                                1. Custom Format Patterns
                                2. Week Numbers and Day of Year
                                3. Locale-Specific Formatting
                                4. Business Date Formats
                                5. Time Zone Formatting
                                6. Age Calculator
                                7. Event Countdown

                                Press Ctrl+1-7 to run examples
                                )"
                                MsgBox(menu, "FormatTime Custom Formats", 4096)
                            }

                            ^1::Example1_CustomPatterns()
                            ^2::Example2_WeekAndDayFormats()
                            ^3::Example3_LocaleFormatting()
                            ^4::Example4_BusinessFormats()
                            ^5::Example5_TimeZoneFormatting()
                            ^6::Example6_AgeCalculator()
                            ^7::Example7_EventCountdown()
                            ^m::ShowMenu()

                            ShowMenu()
