#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * DateAdd Function - Basic Date Addition and Subtraction
 * ============================================================================
 * 
 * This script demonstrates the DateAdd() function for adding or subtracting
 * time from dates in AutoHotkey v2.
 * 
 * @description Basic DateAdd() usage for date calculations
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * DateAdd Parameters:
 * - DateTime: The starting timestamp
 * - Value: Number to add (positive) or subtract (negative)
 * - Units: "seconds", "minutes", "hours", "days", "months", "years"
 * 
 * Returns: New timestamp as YYYYMMDDHHMMSS string
 */

; ============================================================================
; Example 1: Basic Time Unit Addition
; ============================================================================

/**
 * Demonstrates adding different time units to dates.
 * Common use: Scheduling, deadlines, reminders
 */
Example1_BasicAddition() {
    output := "=== Example 1: Basic Time Unit Addition ===`n`n"
    startDate := A_Now

    output .= "Starting Date/Time:`n"
    output .= "  " . FormatTime(startDate, "dddd, MMMM dd, yyyy 'at' h:mm:ss tt") . "`n`n"

    ; Add seconds
    output .= "Adding Time Units:`n"
    afterSeconds := DateAdd(startDate, 30, "seconds")
    output .= "  +30 seconds: " . FormatTime(afterSeconds, "h:mm:ss tt") . "`n"

    ; Add minutes
    afterMinutes := DateAdd(startDate, 45, "minutes")
    output .= "  +45 minutes: " . FormatTime(afterMinutes, "h:mm tt") . "`n"

    ; Add hours
    afterHours := DateAdd(startDate, 3, "hours")
    output .= "  +3 hours: " . FormatTime(afterHours, "h:mm tt") . "`n`n"

    ; Add days
    output .= "Adding Days:`n"
    loop 7 {
        afterDays := DateAdd(startDate, A_Index, "days")
        output .= Format("  +{:d} day{:s}: {:s}",
            A_Index,
            A_Index > 1 ? "s" : "",
            FormatTime(afterDays, "dddd, MMM dd")) . "`n"
    }

    ; Add weeks
    output .= "`n`nAdding Weeks (via days):`n"
    afterWeek := DateAdd(startDate, 7, "days")
    output .= "  +1 week: " . FormatTime(afterWeek, "dddd, MMM dd, yyyy") . "`n"

    afterTwoWeeks := DateAdd(startDate, 14, "days")
    output .= "  +2 weeks: " . FormatTime(afterTwoWeeks, "dddd, MMM dd, yyyy") . "`n"

    ; Add months
    output .= "`n`nAdding Months:`n"
    loop 6 {
        afterMonths := DateAdd(startDate, A_Index, "months")
        output .= Format("  +{:d} month{:s}: {:s}",
            A_Index,
            A_Index > 1 ? "s" : "",
            FormatTime(afterMonths, "MMMM dd, yyyy")) . "`n"
    }

    ; Add years
    output .= "`n`nAdding Years:`n"
    loop 5 {
        afterYears := DateAdd(startDate, A_Index, "years")
        output .= Format("  +{:d} year{:s}: {:s}",
            A_Index,
            A_Index > 1 ? "s" : "",
            FormatTime(afterYears, "MMMM dd, yyyy")) . "`n"
    }

    MsgBox(output, "Basic Addition", 262144)
}

; ============================================================================
; Example 2: Subtraction and Past Dates
; ============================================================================

/**
 * Shows how to subtract time to get past dates.
 * Common use: Historical data, lookback periods, archiving
 */
Example2_Subtraction() {
    output := "=== Example 2: Date Subtraction ===`n`n"
    today := A_Now

    output .= "Current Date: " . FormatTime(today, "MMMM dd, yyyy") . "`n`n"

    ; Subtract days
    output .= "Previous Days:`n"
    output .= "  Yesterday: " . FormatTime(DateAdd(today, -1, "days"), "dddd, MMM dd") . "`n"
    output .= "  2 days ago: " . FormatTime(DateAdd(today, -2, "days"), "dddd, MMM dd") . "`n"
    output .= "  1 week ago: " . FormatTime(DateAdd(today, -7, "days"), "dddd, MMM dd") . "`n"
    output .= "  2 weeks ago: " . FormatTime(DateAdd(today, -14, "days"), "dddd, MMM dd") . "`n`n"

    ; Subtract months
    output .= "Previous Months:`n"
    output .= "  Last month: " . FormatTime(DateAdd(today, -1, "months"), "MMMM yyyy") . "`n"
    output .= "  2 months ago: " . FormatTime(DateAdd(today, -2, "months"), "MMMM yyyy") . "`n"
    output .= "  3 months ago: " . FormatTime(DateAdd(today, -3, "months"), "MMMM yyyy") . "`n"
    output .= "  6 months ago: " . FormatTime(DateAdd(today, -6, "months"), "MMMM yyyy") . "`n`n"

    ; Subtract years
    output .= "Previous Years:`n"
    output .= "  Last year: " . FormatTime(DateAdd(today, -1, "years"), "yyyy") . "`n"
    output .= "  2 years ago: " . FormatTime(DateAdd(today, -2, "years"), "yyyy") . "`n"
    output .= "  5 years ago: " . FormatTime(DateAdd(today, -5, "years"), "yyyy") . "`n"
    output .= "  10 years ago: " . FormatTime(DateAdd(today, -10, "years"), "yyyy") . "`n`n"

    ; Historical dates
    output .= "Historical Reference Points:`n"
    output .= "  30 days ago: " . FormatTime(DateAdd(today, -30, "days"), "MMM dd, yyyy") . "`n"
    output .= "  90 days ago: " . FormatTime(DateAdd(today, -90, "days"), "MMM dd, yyyy") . "`n"
    output .= "  1 year ago: " . FormatTime(DateAdd(today, -365, "days"), "MMM dd, yyyy") . "`n"

    MsgBox(output, "Subtraction", 262144)
}

; ============================================================================
; Example 3: Deadline and Due Date Calculator
; ============================================================================

/**
 * Calculates deadlines and due dates from start dates.
 * Common use: Project management, billing, reminders
 */
Example3_DeadlineCalculator() {
    output := "=== Example 3: Deadline Calculator ===`n`n"
    startDate := A_Now

    output .= "Task Start Date: " . FormatTime(startDate, "MMMM dd, yyyy") . "`n`n"

    ; Common deadline scenarios
    output .= "Common Deadlines:`n"
    deadlines := [{
        name: "Same Day", days: 0, desc: "Due today" }, {
            name: "Next Day", days: 1, desc: "Due tomorrow" }, {
                name: "3-Day", days: 3, desc: "Due in 3 days" }, {
                    name: "1-Week", days: 7, desc: "Due in 1 week" }, {
                        name: "2-Week", days: 14, desc: "Due in 2 weeks" }, {
                            name: "30-Day", days: 30, desc: "Due in 30 days" }, {
                                name: "60-Day", days: 60, desc: "Due in 60 days" }, {
                                    name: "90-Day", days: 90, desc: "Due in 90 days"
                                }
    ]

    for deadline in deadlines {
        dueDate := DateAdd(startDate, deadline.days, "days")
        output .= Format("  {:-12s}: {:s} ({:s})",
            deadline.name,
            FormatTime(dueDate, "MMM dd, yyyy"),
            deadline.desc) . "`n"
    }

    ; Payment terms
    output .= "`n`nPayment Terms:`n"
    invoiceDate := startDate

    net15 := DateAdd(invoiceDate, 15, "days")
    net30 := DateAdd(invoiceDate, 30, "days")
    net60 := DateAdd(invoiceDate, 60, "days")
    net90 := DateAdd(invoiceDate, 90, "days")

    output .= "  Invoice Date: " . FormatTime(invoiceDate, "MMM dd, yyyy") . "`n"
    output .= "  Net 15: " . FormatTime(net15, "MMM dd, yyyy") . "`n"
    output .= "  Net 30: " . FormatTime(net30, "MMM dd, yyyy") . "`n"
    output .= "  Net 60: " . FormatTime(net60, "MMM dd, yyyy") . "`n"
    output .= "  Net 90: " . FormatTime(net90, "MMM dd, yyyy") . "`n`n"

    ; Project milestones
    output .= "Project Milestones (3-month project):`n"
    projectStart := startDate

    kickoff := projectStart
    week2 := DateAdd(projectStart, 14, "days")
    month1 := DateAdd(projectStart, 30, "days")
    month2 := DateAdd(projectStart, 60, "days")
    completion := DateAdd(projectStart, 90, "days")

    output .= "  Kickoff: " . FormatTime(kickoff, "MMM dd") . "`n"
    output .= "  2-Week Check-in: " . FormatTime(week2, "MMM dd") . "`n"
    output .= "  Month 1 Review: " . FormatTime(month1, "MMM dd") . "`n"
    output .= "  Month 2 Review: " . FormatTime(month2, "MMM dd") . "`n"
    output .= "  Project Completion: " . FormatTime(completion, "MMM dd, yyyy") . "`n"

    MsgBox(output, "Deadline Calculator", 262144)
}

; ============================================================================
; Example 4: Subscription and Renewal Dates
; ============================================================================

/**
 * Calculates subscription periods and renewal dates.
 * Common use: SaaS billing, membership systems, license management
 */
Example4_SubscriptionDates() {
    output := "=== Example 4: Subscription & Renewal Dates ===`n`n"
    subscriptionStart := A_Now

    output .= "Subscription Start: " . FormatTime(subscriptionStart, "MMMM dd, yyyy") . "`n`n"

    ; Monthly subscription
    output .= "Monthly Subscription Renewals:`n"
    loop 12 {
        renewalDate := DateAdd(subscriptionStart, A_Index, "months")
        output .= Format("  Month {:2d}: {:s}",
            A_Index,
            FormatTime(renewalDate, "MMM dd, yyyy")) . "`n"
    }

    ; Quarterly billing
    output .= "`n`nQuarterly Billing Cycle:`n"
    loop 4 {
        quarterEnd := DateAdd(subscriptionStart, A_Index * 3, "months")
        output .= Format("  Q{:d} End: {:s}",
            A_Index,
            FormatTime(quarterEnd, "MMM dd, yyyy")) . "`n"
    }

    ; Annual renewal
    output .= "`n`nAnnual Renewals:`n"
    loop 5 {
        annualRenewal := DateAdd(subscriptionStart, A_Index, "years")
        output .= Format("  Year {:d}: {:s}",
            A_Index,
            FormatTime(annualRenewal, "MMM dd, yyyy")) . "`n"
    }

    ; Trial periods
    output .= "`n`nTrial Periods:`n"
    trials := [{
        name: "7-Day Trial", days: 7 }, {
            name: "14-Day Trial", days: 14 }, {
                name: "30-Day Trial", days: 30
            }
    ]

    for trial in trials {
        trialEnd := DateAdd(subscriptionStart, trial.days, "days")
        output .= "  " . trial.name . " ends: " . FormatTime(trialEnd, "MMM dd, yyyy") . "`n"
    }

    ; License expiration
    output .= "`n`nLicense Expiration:`n"
    licenses := [{
        type: "1-Month License", months: 1 }, {
            type: "6-Month License", months: 6 }, {
                type: "1-Year License", months: 12 }, {
                    type: "3-Year License", months: 36
                }
    ]

    for license in licenses {
        expiration := DateAdd(subscriptionStart, license.months, "months")
        output .= Format("  {:-18s}: {:s}",
            license.type,
            FormatTime(expiration, "MMM dd, yyyy")) . "`n"
    }

    MsgBox(output, "Subscription Dates", 262144)
}

; ============================================================================
; Example 5: Backup and Archive Scheduling
; ============================================================================

/**
 * Schedules backup and archive operations.
 * Common use: Data management, backup systems, archiving
 */
Example5_BackupScheduling() {
    output := "=== Example 5: Backup & Archive Scheduling ===`n`n"
    today := A_Now

    ; Daily backups
    output .= "Daily Backup Schedule (Next 7 Days):`n"
    loop 7 {
        backupDate := DateAdd(today, A_Index, "days")
        backupTime := FormatTime(backupDate, "yyyyMMdd") . "020000"  ; 2:00 AM
        output .= "  Day " . A_Index . ": " . FormatTime(backupTime, "ddd, MMM dd 'at' h:mm tt") . "`n"
    }

    ; Weekly backups
    output .= "`n`nWeekly Full Backups (Next 4 Weeks):`n"
    ; Find next Sunday
    currentDay := FormatTime(today, "w")
    daysUntilSunday := Mod(7 - currentDay + 1, 7)
    if (daysUntilSunday = 0)
        daysUntilSunday := 7

    firstSunday := DateAdd(today, daysUntilSunday, "days")

    loop 4 {
        weeklyBackup := DateAdd(firstSunday, (A_Index - 1) * 7, "days")
        backupTime := FormatTime(weeklyBackup, "yyyyMMdd") . "010000"  ; 1:00 AM
        output .= "  Week " . A_Index . ": " . FormatTime(backupTime, "dddd, MMM dd 'at' h:mm tt") . "`n"
    }

    ; Monthly archives
    output .= "`n`nMonthly Archives (Next 6 Months):`n"
    ; First day of next month
    nextMonth := DateAdd(FormatTime(today, "yyyyMM") . "01000000", 1, "months")

    loop 6 {
        archiveDate := DateAdd(nextMonth, A_Index - 1, "months")
        output .= "  " . FormatTime(archiveDate, "MMMM yyyy") . " archive: "
            . FormatTime(archiveDate, "MMM 01, yyyy") . "`n"
    }

    ; Quarterly snapshots
    output .= "`n`nQuarterly Snapshots:`n"
    ; Calculate next quarter start
    currentMonth := Integer(FormatTime(today, "MM"))
    currentQuarter := Ceil(currentMonth / 3)
    nextQuarterMonth := (currentQuarter * 3) + 1
    if (nextQuarterMonth > 12)
        nextQuarterMonth -= 12

    year := FormatTime(today, "yyyy")
    if (nextQuarterMonth <= currentMonth)
        year := Integer(year) + 1

    nextQuarter := year . Format("{:02d}", nextQuarterMonth) . "01000000"

    loop 4 {
        quarterSnapshot := DateAdd(nextQuarter, (A_Index - 1) * 3, "months")
        output .= "  Q" . Ceil(Integer(FormatTime(quarterSnapshot, "MM")) / 3) . " "
            . FormatTime(quarterSnapshot, "yyyy") . ": "
            . FormatTime(quarterSnapshot, "MMM dd, yyyy") . "`n"
    }

    ; Data retention periods
    output .= "`n`nData Retention Cutoff Dates:`n"
    output .= "  30-day retention: Delete data before "
        . FormatTime(DateAdd(today, -30, "days"), "MMM dd, yyyy") . "`n"
    output .= "  90-day retention: Delete data before "
        . FormatTime(DateAdd(today, -90, "days"), "MMM dd, yyyy") . "`n"
    output .= "  1-year retention: Delete data before "
        . FormatTime(DateAdd(today, -365, "days"), "MMM dd, yyyy") . "`n"
    output .= "  7-year retention: Delete data before "
        . FormatTime(DateAdd(today, -7, "years"), "MMM dd, yyyy") . "`n"

    MsgBox(output, "Backup Scheduling", 262144)
}

; ============================================================================
; Example 6: Event Planning and Scheduling
; ============================================================================

/**
 * Plans events and schedules with lead times.
 * Common use: Event management, planning, coordination
 */
Example6_EventPlanning() {
    output := "=== Example 6: Event Planning ===`n`n"

    ; Event date
    eventDate := DateAdd(A_Now, 60, "days")  ; Event in 60 days

    output .= "EVENT PLANNING TIMELINE`n"
    output .= "Event Date: " . FormatTime(eventDate, "dddd, MMMM dd, yyyy") . "`n"
    output .= StrReplace(Format("{:60s}", ""), " ", "─") . "`n`n"

    ; Planning milestones (working backwards from event)
    milestones := [{
        name: "Final Preparation", daysBefore: 1 }, {
            name: "Confirm Attendees", daysBefore: 3 }, {
                name: "Finalize Catering", daysBefore: 7 }, {
                    name: "Send Reminders", daysBefore: 14 }, {
                        name: "Book Venue", daysBefore: 30 }, {
                            name: "Send Invitations", daysBefore: 45 }, {
                                name: "Initial Planning", daysBefore: 60
                            }
    ]

    output .= "Planning Milestones:`n"
    for milestone in milestones {
        milestoneDate := DateAdd(eventDate, -milestone.daysBefore, "days")
        daysFromNow := DateDiff(milestoneDate, A_Now, "days")

        status := daysFromNow < 0 ? "✓ Past" : "○ Upcoming"

        output .= Format("  {:-25s}: {:s} ({:s})",
            milestone.name,
            FormatTime(milestoneDate, "MMM dd"),
            status) . "`n"
    }

    ; Multi-day event
    output .= "`n`nMulti-Day Conference (3 Days):`n"
    confStart := DateAdd(A_Now, 30, "days")

    loop 3 {
        day := DateAdd(confStart, A_Index - 1, "days")
        output .= "  Day " . A_Index . ": " . FormatTime(day, "dddd, MMMM dd") . "`n"
    }

    ; Recurring events
    output .= "`n`nRecurring Monthly Meetups (Next 6 Months):`n"
    ; Third Thursday of each month
    today := A_Now
    currentMonth := FormatTime(today, "yyyyMM") . "01000000"

    loop 6 {
        monthStart := DateAdd(currentMonth, A_Index - 1, "months")
        ; Find first Thursday
        dayOfWeek := FormatTime(monthStart, "w")  ; 1=Sun, 5=Thu
        daysToThursday := Mod(5 - dayOfWeek + 7, 7)
        firstThursday := DateAdd(monthStart, daysToThursday, "days")

        ; Third Thursday
        thirdThursday := DateAdd(firstThursday, 14, "days")

        output .= "  " . FormatTime(thirdThursday, "dddd, MMMM dd, yyyy") . "`n"
    }

    MsgBox(output, "Event Planning", 262144)
}

; ============================================================================
; Example 7: Age and Birthday Calculations
; ============================================================================

/**
 * Calculates ages and birthday-related dates.
 * Common use: Age verification, birthday reminders, anniversary tracking
 */
Example7_BirthdayCalculations() {
    output := "=== Example 7: Birthday Calculations ===`n`n"
    today := A_Now

    ; Sample birthdate
    birthDate := "19900515120000"  ; May 15, 1990

    output .= "Person Details:`n"
    output .= "  Born: " . FormatTime(birthDate, "MMMM dd, yyyy") . "`n"

    ; Calculate age
    years := DateDiff(today, birthDate, "years")

    ; Check if birthday has occurred this year
    birthdayThisYear := FormatTime(today, "yyyy") . FormatTime(birthDate, "MMdd") . "000000"
    if (today < birthdayThisYear)
        years--

    output .= "  Current Age: " . years . " years old`n`n"

    ; Next birthday
    nextBirthday := FormatTime(today, "yyyy") . FormatTime(birthDate, "MMdd") . "000000"
    if (nextBirthday <= today)
        nextBirthday := DateAdd(nextBirthday, 1, "years")

    daysUntil := DateDiff(nextBirthday, today, "days")

    output .= "Next Birthday:`n"
    output .= "  Date: " . FormatTime(nextBirthday, "dddd, MMMM dd, yyyy") . "`n"
    output .= "  Age: " . (years + 1) . " years old`n"
    output .= "  Days Until: " . daysUntil . " days`n`n"

    ; Milestone birthdays
    output .= "Upcoming Milestone Birthdays:`n"
    milestones := [21, 25, 30, 40, 50, 60, 65, 70, 75, 80]

    for milestone in milestones {
        if (milestone > years) {
            milestoneDate := DateAdd(birthDate, milestone, "years")
            yearsAway := milestone - years

            output .= Format("  Age {:d}: {:s} (in {:d} year{:s})",
                milestone,
                FormatTime(milestoneDate, "yyyy"),
                yearsAway,
                yearsAway > 1 ? "s" : "") . "`n"

            if (A_Index >= 3)  ; Show first 3 upcoming milestones
                break
        }
    }

    ; Half birthday
    output .= "`n`nHalf Birthday:`n"
    halfBirthday := DateAdd(birthDate, 6, "months")
    halfBirthdayThisYear := FormatTime(today, "yyyy") . FormatTime(halfBirthday, "MMdd") . "000000"

    if (halfBirthdayThisYear <= today)
        halfBirthdayThisYear := DateAdd(halfBirthdayThisYear, 1, "years")

    output .= "  " . FormatTime(halfBirthdayThisYear, "MMMM dd, yyyy") . "`n"

    ; Age at specific future date
    output .= "`n`nAge Projections:`n"
    projections := [{
        desc: "Next month", date: DateAdd(today, 1, "months") }, {
            desc: "Next year", date: DateAdd(today, 1, "years") }, {
                desc: "In 5 years", date: DateAdd(today, 5, "years") }, {
                    desc: "In 10 years", date: DateAdd(today, 10, "years")
                }
    ]

    for proj in projections {
        ageAtDate := DateDiff(proj.date, birthDate, "years")
        output .= Format("  {:-15s}: {:d} years old ({:s})",
            proj.desc,
            ageAtDate,
            FormatTime(proj.date, "MMM yyyy")) . "`n"
    }

    MsgBox(output, "Birthday Calculations", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
                                                                                        (
                                                                                        DateAdd() - Basic Addition and Subtraction

                                                                                        Examples:
                                                                                        1. Basic Time Unit Addition
                                                                                        2. Subtraction and Past Dates
                                                                                        3. Deadline Calculator
                                                                                        4. Subscription Dates
                                                                                        5. Backup Scheduling
                                                                                        6. Event Planning
                                                                                        7. Birthday Calculations

                                                                                        Press Ctrl+1-7 to run examples
                                                                                        )"
    MsgBox(menu, "DateAdd Examples", 4096)
}

^1:: Example1_BasicAddition()
^2:: Example2_Subtraction()
^3:: Example3_DeadlineCalculator()
^4:: Example4_SubscriptionDates()
^5:: Example5_BackupScheduling()
^6:: Example6_EventPlanning()
^7:: Example7_BirthdayCalculations()
^m:: ShowMenu()

ShowMenu()
