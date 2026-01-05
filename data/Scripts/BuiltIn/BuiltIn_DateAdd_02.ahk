#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * DateAdd Function - Advanced Date Calculations and Business Logic
 * ============================================================================
 * 
 * This script demonstrates advanced DateAdd() operations including business
 * day calculations, complex date arithmetic, and calendar-aware operations.
 * 
 * @description Advanced DateAdd() for business and calendar calculations
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Advanced Operations:
 * - Business day calculations
 * - Calendar-aware date math
 * - Complex period calculations
 * - Date range generation
 * - Chained date operations
 */

; ============================================================================
; Example 1: Business Day Addition
; ============================================================================

/**
 * Adds business days (excluding weekends).
 * Common use: Project planning, SLA calculations, delivery estimates
 */
Example1_BusinessDayAddition() {
    ; Add business days
    AddBusinessDays(startDate, businessDays) {
        current := startDate
        daysAdded := 0

        while (daysAdded < businessDays) {
            current := DateAdd(current, 1, "days")
            dayOfWeek := FormatTime(current, "w")  ; 1=Sunday, 7=Saturday

            ; Only count weekdays (Monday-Friday)
            if (dayOfWeek >= 2 && dayOfWeek <= 6) {
                daysAdded++
            }
        }

        return current
    }

    output := "=== Example 1: Business Day Addition ===`n`n"
    startDate := A_Now

    output .= "Start Date: " . FormatTime(startDate, "dddd, MMMM dd, yyyy") . "`n`n"

    ; Add various numbers of business days
    output .= "Business Day Calculations:`n"
    businessDayAmounts := [1, 3, 5, 10, 20]

    for days in businessDayAmounts {
        resultDate := AddBusinessDays(startDate, days)
        calendarDays := DateDiff(resultDate, startDate, "days")

        output .= Format("  +{:2d} business days: {:s} ({:d} calendar days)",
            days,
            FormatTime(resultDate, "ddd, MMM dd, yyyy"),
            calendarDays) . "`n"
    }

    ; SLA response times
    output .= "`n`nSLA Response Times:`n"
    ticketCreated := startDate

    slaHours := [4, 8, 24, 48]  ; Business hours

    for hours in slaHours {
        businessDays := Ceil(hours / 8)  ; 8-hour business day
        responseDate := AddBusinessDays(ticketCreated, businessDays)

        output .= Format("  {:2d} business hours: {:s}",
            hours,
            FormatTime(responseDate, "ddd, MMM dd 'at' 5:00 PM")) . "`n"
    }

    ; Project timeline
    output .= "`n`nProject Timeline (15 Business Days):`n"
    projectStart := startDate
    projectEnd := AddBusinessDays(projectStart, 15)

    output .= "  Start: " . FormatTime(projectStart, "dddd, MMM dd") . "`n"
    output .= "  End: " . FormatTime(projectEnd, "dddd, MMM dd") . "`n"

    calendarDuration := DateDiff(projectEnd, projectStart, "days")
    output .= "  Duration: 15 business days (" . calendarDuration . " calendar days)`n"

    MsgBox(output, "Business Day Addition", 262144)
}

; ============================================================================
; Example 2: Month-End and Quarter-End Calculations
; ============================================================================

/**
 * Calculates month-end and quarter-end dates.
 * Common use: Financial reporting, billing cycles, period closings
 */
Example2_PeriodEndCalculations() {
    ; Get last day of month
    GetMonthEnd(timestamp) {
        ; Go to first of next month, then subtract one day
        year := FormatTime(timestamp, "yyyy")
        month := FormatTime(timestamp, "MM")
        firstOfMonth := year . month . "01000000"
        firstOfNextMonth := DateAdd(firstOfMonth, 1, "months")
        return DateAdd(firstOfNextMonth, -1, "days")
    }

    ; Get last day of quarter
    GetQuarterEnd(timestamp) {
        month := Integer(FormatTime(timestamp, "MM"))
        quarter := Ceil(month / 3)
        quarterEndMonth := quarter * 3

        year := FormatTime(timestamp, "yyyy")
        quarterEnd := year . Format("{:02d}", quarterEndMonth) . "01000000"
        return GetMonthEnd(quarterEnd)
    }

    output := "=== Example 2: Period-End Calculations ===`n`n"
    today := A_Now

    ; Current month-end
    output .= "Current Month:`n"
    currentMonthEnd := GetMonthEnd(today)
    daysUntilMonthEnd := DateDiff(currentMonthEnd, today, "days")

    output .= "  Month: " . FormatTime(today, "MMMM yyyy") . "`n"
    output .= "  Month-End: " . FormatTime(currentMonthEnd, "dddd, MMMM dd") . "`n"
    output .= "  Days Until: " . daysUntilMonthEnd . " days`n`n"

    ; Next 6 month-ends
    output .= "Upcoming Month-Ends:`n"
    loop 6 {
        futureMonth := DateAdd(today, A_Index, "months")
        monthEnd := GetMonthEnd(futureMonth)

        output .= Format("  {:-12s}: {:s}",
            FormatTime(futureMonth, "MMMM yyyy"),
            FormatTime(monthEnd, "ddd, MMM dd")) . "`n"
    }

    ; Quarter-ends
    output .= "`n`nQuarter-End Dates:`n"
    currentQuarterEnd := GetQuarterEnd(today)
    output .= "  Current Quarter End: " . FormatTime(currentQuarterEnd, "MMMM dd, yyyy") . "`n`n"

    ; Next 4 quarter-ends
    year := Integer(FormatTime(today, "yyyy"))
    loop 4 {
        q := A_Index
        month := (q * 3)
        quarterDate := year . Format("{:02d}", month) . "01000000"
        qEnd := GetMonthEnd(quarterDate)

        output .= Format("  Q{:d} {:d}: {:s}",
            q,
            year,
            FormatTime(qEnd, "MMM dd, yyyy")) . "`n"
    }

    ; Fiscal year-end (assuming June 30)
    output .= "`n`nFiscal Year-End (June 30):`n"
    currentYear := FormatTime(today, "yyyy")
    fyEnd := currentYear . "0630000000"

    if (today > fyEnd)
        fyEnd := DateAdd(fyEnd, 1, "years")

    output .= "  FY End: " . FormatTime(fyEnd, "MMMM dd, yyyy") . "`n"
    output .= "  Days Until: " . DateDiff(fyEnd, today, "days") . " days`n"

    MsgBox(output, "Period-End Calculations", 262144)
}

; ============================================================================
; Example 3: Chained Date Operations
; ============================================================================

/**
 * Demonstrates chaining multiple DateAdd operations.
 * Common use: Complex calculations, business logic, time series
 */
Example3_ChainedOperations() {
    output := "=== Example 3: Chained Date Operations ===`n`n"
    startDate := A_Now

    output .= "Starting: " . FormatTime(startDate, "MMMM dd, yyyy 'at' h:mm tt") . "`n`n"

    ; Sequential operations
    output .= "Sequential Operations:`n"

    step1 := DateAdd(startDate, 3, "days")
    output .= "  Step 1: +3 days = " . FormatTime(step1, "MMM dd 'at' h:mm tt") . "`n"

    step2 := DateAdd(step1, 2, "hours")
    output .= "  Step 2: +2 hours = " . FormatTime(step2, "MMM dd 'at' h:mm tt") . "`n"

    step3 := DateAdd(step2, 30, "minutes")
    output .= "  Step 3: +30 minutes = " . FormatTime(step3, "MMM dd 'at' h:mm tt") . "`n"

    step4 := DateAdd(step3, -1, "days")
    output .= "  Step 4: -1 day = " . FormatTime(step4, "MMM dd 'at' h:mm tt") . "`n`n"

    ; Complex business scenario
    output .= "Business Scenario (Order Processing):`n"
    orderPlaced := startDate
    output .= "  Order Placed: " . FormatTime(orderPlaced, "MMM dd 'at' h:mm tt") . "`n"

    ; Add processing time
    processingComplete := DateAdd(orderPlaced, 2, "hours")
    output .= "  Processing (2hrs): " . FormatTime(processingComplete, "MMM dd 'at' h:mm tt") . "`n"

    ; Add shipping time
    shipped := DateAdd(processingComplete, 1, "days")
    output .= "  Shipped (+1 day): " . FormatTime(shipped, "MMM dd 'at' h:mm tt") . "`n"

    ; Add delivery time
    delivered := DateAdd(shipped, 3, "days")
    output .= "  Delivered (+3 days): " . FormatTime(delivered, "MMM dd 'at' h:mm tt") . "`n"

    totalTime := DateDiff(delivered, orderPlaced, "hours")
    output .= "  Total Time: " . totalTime . " hours (" . Format("{:.1f}", totalTime / 24) . " days)`n`n"

    ; Recurring event calculation
    output .= "Recurring Events (Every 2 Weeks):`n"
    eventDate := startDate

    loop 5 {
        output .= "  Event " . A_Index . ": " . FormatTime(eventDate, "ddd, MMM dd") . "`n"
        eventDate := DateAdd(eventDate, 14, "days")
    }

    MsgBox(output, "Chained Operations", 262144)
}

; ============================================================================
; Example 4: Calendar Date Range Generator
; ============================================================================

/**
 * Generates date ranges for reports and queries.
 * Common use: Report generation, data analysis, date pickers
 */
Example4_DateRangeGenerator() {
    ; Generate date range
    GenerateRange(startDate, endDate, intervalDays := 1) {
        dates := []
        current := startDate

        while (current <= endDate) {
            dates.Push(current)
            current := DateAdd(current, intervalDays, "days")
        }

        return dates
    }

    output := "=== Example 4: Date Range Generator ===`n`n"

    ; Weekly dates for next month
    output .= "Weekly Dates (Next 4 Weeks):`n"
    weekStart := DateAdd(A_Now, 1, "days")
    weekEnd := DateAdd(weekStart, 28, "days")
    weeklyDates := GenerateRange(weekStart, weekEnd, 7)

    for date in weeklyDates {
        output .= "  " . FormatTime(date, "dddd, MMMM dd, yyyy") . "`n"
    }

    ; First day of each month for next 6 months
    output .= "`n`nFirst of Each Month (Next 6 Months):`n"
    currentMonth := FormatTime(A_Now, "yyyyMM") . "01000000"

    loop 6 {
        monthStart := DateAdd(currentMonth, A_Index - 1, "months")
        output .= "  " . FormatTime(monthStart, "MMMM 01, yyyy") . "`n"
    }

    ; Last day of each month
    output .= "`n`nLast Day of Each Month (Next 6 Months):`n"
    loop 6 {
        monthStart := DateAdd(currentMonth, A_Index - 1, "months")
        nextMonth := DateAdd(monthStart, 1, "months")
        monthEnd := DateAdd(nextMonth, -1, "days")

        output .= "  " . FormatTime(monthEnd, "MMMM dd, yyyy") . "`n"
    }

    ; Every 15th of the month
    output .= "`n`n15th of Each Month (Next 6 Months):`n"
    loop 6 {
        month := DateAdd(currentMonth, A_Index - 1, "months")
        fifteenth := FormatTime(month, "yyyyMM") . "15000000"

        output .= "  " . FormatTime(fifteenth, "MMMM 15, yyyy") . "`n"
    }

    ; Bi-weekly pay periods
    output .= "`n`nBi-Weekly Pay Periods (Next 6 Periods):`n"
    payDate := A_Now
    ; Assume pay day is Friday
    dayOfWeek := FormatTime(payDate, "w")
    daysUntilFriday := Mod(6 - dayOfWeek + 7, 7)
    if (daysUntilFriday = 0)
        daysUntilFriday := 7

    nextPayDay := DateAdd(payDate, daysUntilFriday, "days")

    loop 6 {
        payPeriod := DateAdd(nextPayDay, (A_Index - 1) * 14, "days")
        output .= "  Period " . A_Index . ": " . FormatTime(payPeriod, "ddd, MMM dd, yyyy") . "`n"
    }

    MsgBox(output, "Date Range Generator", 262144)
}

; ============================================================================
; Example 5: Time Zone and DST Adjustments
; ============================================================================

/**
 * Handles time adjustments for time zones and daylight saving time.
 * Common use: International scheduling, time zone conversions
 */
Example5_TimeZoneAdjustments() {
    output := "=== Example 5: Time Zone Adjustments ===`n`n"
    localTime := A_Now
    utcTime := A_NowUTC

    output .= "Current Time:`n"
    output .= "  Local: " . FormatTime(localTime, "yyyy-MM-dd HH:mm:ss") . "`n"
    output .= "  UTC: " . FormatTime(utcTime, "yyyy-MM-dd HH:mm:ss") . "`n`n"

    ; Time zone offsets (conceptual - actual offsets vary)
    output .= "Time Zone Conversions (Conceptual):`n"
    zones := [{
        name: "UTC", offset: 0 }, {
            name: "EST (UTC-5)", offset: -5 }, {
                name: "CST (UTC-6)", offset: -6 }, {
                    name: "MST (UTC-7)", offset: -7 }, {
                        name: "PST (UTC-8)", offset: -8 }, {
                            name: "GMT (UTC+0)", offset: 0 }, {
                                name: "CET (UTC+1)", offset: 1 }, {
                                    name: "JST (UTC+9)", offset: 9
                                }
    ]

    for zone in zones {
        zoneTime := DateAdd(utcTime, zone.offset, "hours")
        output .= Format("  {:-15s}: {:s}",
            zone.name,
            FormatTime(zoneTime, "HH:mm")) . "`n"
    }

    ; Meeting across time zones
    output .= "`n`nInternational Meeting Time:`n"
    meetingUTC := FormatTime(A_Now, "yyyyMMdd") . "140000"  ; 2:00 PM UTC

    output .= "  Meeting at 14:00 UTC:`n"

    meetingLocal := DateAdd(meetingUTC, -5, "hours")  ; EST
    output .= "    New York (EST): " . FormatTime(meetingLocal, "h:mm tt") . "`n"

    meetingLondon := meetingUTC  ; GMT = UTC
    output .= "    London (GMT): " . FormatTime(meetingLondon, "HH:mm") . "`n"

    meetingTokyo := DateAdd(meetingUTC, 9, "hours")  ; JST
    output .= "    Tokyo (JST): " . FormatTime(meetingTokyo, "HH:mm") . "`n"

    ; Flight duration with time zones
    output .= "`n`nFlight Times (NYC to London):`n"
    departNYC := FormatTime(A_Now, "yyyyMMdd") . "200000"  ; 8:00 PM
    flightDuration := 7  ; 7 hours

    arriveLocal := DateAdd(departNYC, flightDuration, "hours")
    arriveLocal := DateAdd(arriveLocal, 5, "hours")  ; +5 hours time zone difference

    output .= "  Depart NYC: " . FormatTime(departNYC, "h:mm tt (EST)") . "`n"
    output .= "  Flight Time: " . flightDuration . " hours`n"
    output .= "  Arrive London: " . FormatTime(arriveLocal, "HH:mm '(GMT)'") . "`n"

    MsgBox(output, "Time Zone Adjustments", 262144)
}

; ============================================================================
; Example 6: Aging and Maturity Calculations
; ============================================================================

/**
 * Calculates aging periods and maturity dates.
 * Common use: Accounts receivable, inventory aging, financial instruments
 */
Example6_AgingCalculations() {
    output := "=== Example 6: Aging Calculations ===`n`n"
    today := A_Now

    ; Invoice aging
    output .= "Invoice Aging Report:`n"
    invoices := [{
        id: "INV-001", date: DateAdd(today, -15, "days"), amount: 1500 }, {
            id: "INV-002", date: DateAdd(today, -35, "days"), amount: 2300 }, {
                id: "INV-003", date: DateAdd(today, -65, "days"), amount: 890 }, {
                    id: "INV-004", date: DateAdd(today, -95, "days"), amount: 3400
                }
    ]

    for invoice in invoices {
        age := DateDiff(today, invoice.date, "days")
        agingCategory := ""

        if (age <= 30)
            agingCategory := "Current"
        else if (age <= 60)
            agingCategory := "31-60 days"
        else if (age <= 90)
            agingCategory := "61-90 days"
        else
            agingCategory := "90+ days (Overdue)"

        output .= Format("  {:s}: ${:,.2f} - {:d} days ({:s})",
            invoice.id,
            invoice.amount,
            age,
            agingCategory) . "`n"
    }

    ; Product expiration
    output .= "`n`nProduct Expiration Dates:`n"
    products := [{
        name: "Product A", expiry: DateAdd(today, 7, "days") }, {
            name: "Product B", expiry: DateAdd(today, 30, "days") }, {
                name: "Product C", expiry: DateAdd(today, -5, "days") }, {
                    name: "Product D", expiry: DateAdd(today, 90, "days")
                }
    ]

    for product in products {
        daysUntil := DateDiff(product.expiry, today, "days")
        status := ""

        if (daysUntil < 0)
            status := "EXPIRED"
        else if (daysUntil <= 7)
            status := "URGENT"
        else if (daysUntil <= 30)
            status := "Warning"
        else
            status := "OK"

        output .= Format("  {:-15s}: {:s} ({:s})",
            product.name,
            FormatTime(product.expiry, "MMM dd"),
            status) . "`n"
    }

    ; Bond maturity
    output .= "`n`nFinancial Instrument Maturity:`n"
    bonds := [{
        type: "3-Month T-Bill", months: 3 }, {
            type: "6-Month T-Bill", months: 6 }, {
                type: "1-Year Note", months: 12 }, {
                    type: "5-Year Bond", months: 60
                }
    ]

    issueDate := today

    for bond in bonds {
        maturity := DateAdd(issueDate, bond.months, "months")
        daysUntil := DateDiff(maturity, today, "days")

        output .= Format("  {:-18s}: {:s} ({:d} days)",
            bond.type,
            FormatTime(maturity, "MMM dd, yyyy"),
            daysUntil) . "`n"
    }

    MsgBox(output, "Aging Calculations", 262144)
}

; ============================================================================
; Example 7: Shift and Rotation Scheduling
; ============================================================================

/**
 * Calculates shift schedules and rotation patterns.
 * Common use: Workforce management, scheduling systems, shift planning
 */
Example7_ShiftScheduling() {
    output := "=== Example 7: Shift Scheduling ===`n`n"
    today := A_Now

    ; 3-shift rotation (Day/Evening/Night)
    output .= "3-Shift Rotation Schedule (7-Day Cycle):`n"
    shifts := ["Day (8am-4pm)", "Evening (4pm-12am)", "Night (12am-8am)"]
    employees := ["Alice", "Bob", "Carol"]

    startDate := today

    output .= Format("{:-12s} {:-15s} {:-15s} {:-15s}",
        "Date",
        employees[1],
        employees[2],
        employees[3]) . "`n"
    output .= StrReplace(Format("{:60s}", ""), " ", "─") . "`n"

    loop 7 {
        day := DateAdd(startDate, A_Index - 1, "days")
        dayStr := FormatTime(day, "ddd, MMM dd")

        ; Rotate shifts
        shift1 := shifts[Mod(A_Index - 1, 3) + 1]
        shift2 := shifts[Mod(A_Index, 3) + 1]
        shift3 := shifts[Mod(A_Index + 1, 3) + 1]

        output .= Format("{:-12s} {:-15s} {:-15s} {:-15s}",
            dayStr,
            shift1,
            shift2,
            shift3) . "`n"
    }

    ; On-call rotation
    output .= "`n`nOn-Call Rotation (Weekly):`n"
    onCallStart := today
    onCallPeople := ["Alex", "Blake", "Casey", "Dana"]

    loop 4 {
        weekStart := DateAdd(onCallStart, (A_Index - 1) * 7, "days")
        weekEnd := DateAdd(weekStart, 6, "days")
        person := onCallPeople[A_Index]

        output .= Format("  Week {:d}: {:s} - {:s} ({:s})",
            A_Index,
            FormatTime(weekStart, "MMM dd"),
            FormatTime(weekEnd, "MMM dd"),
            person) . "`n"
    }

    ; 2-2-3 Schedule (common in 24/7 operations)
    output .= "`n`n2-2-3 Schedule Pattern (14 Days):`n"
    output .= "  (2 days on, 2 days off, 3 days on, 2 days off, 2 days on, 3 days off)`n`n"

    pattern := [1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0]  ; 1=working, 0=off
    scheduleStart := today

    loop 14 {
        day := DateAdd(scheduleStart, A_Index - 1, "days")
        status := pattern[A_Index] ? "Working" : "Off"

        output .= Format("  {:s}: {:s}",
            FormatTime(day, "ddd, MMM dd"),
            status) . "`n"
    }

    MsgBox(output, "Shift Scheduling", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
                                                                    (
                                                                    DateAdd() - Advanced Calculations

                                                                    Examples:
                                                                    1. Business Day Addition
                                                                    2. Period-End Calculations
                                                                    3. Chained Operations
                                                                    4. Date Range Generator
                                                                    5. Time Zone Adjustments
                                                                    6. Aging Calculations
                                                                    7. Shift Scheduling

                                                                    Press Ctrl+1-7 to run examples
                                                                    )"
    MsgBox(menu, "DateAdd Advanced", 4096)
}

^1:: Example1_BusinessDayAddition()
^2:: Example2_PeriodEndCalculations()
^3:: Example3_ChainedOperations()
^4:: Example4_DateRangeGenerator()
^5:: Example5_TimeZoneAdjustments()
^6:: Example6_AgingCalculations()
^7:: Example7_ShiftScheduling()
^m:: ShowMenu()

ShowMenu()
