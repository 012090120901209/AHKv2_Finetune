#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * DateAdd Function - Complex Scenarios and Real-World Applications
 * ============================================================================
 * 
 * This script demonstrates complex DateAdd() scenarios including compound
 * calculations, business rules, and sophisticated date management.
 * 
 * @description Complex DateAdd() for real-world business applications
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Complex Scenarios:
 * - Compound interest periods
 * - Warranty and service contracts
 * - Medication and treatment schedules
 * - Lease and rental calculations
 * - Academic calendars
 */

; ============================================================================
; Example 1: Warranty and Service Contract Management
; ============================================================================

/**
 * Calculates warranty periods and service renewals.
 * Common use: Product support, service contracts, maintenance scheduling
 */
Example1_WarrantyManagement() {
    output := "=== Example 1: Warranty Management ===`n`n"
    purchaseDate := A_Now

    output .= "Purchase Date: " . FormatTime(purchaseDate, "MMMM dd, yyyy") . "`n`n"

    ; Standard warranty periods
    output .= "Warranty Coverage:`n"
    warranties := [{
        type: "90-Day Limited", days: 90 }, {
            type: "1-Year Standard", months: 12 }, {
                type: "2-Year Extended", months: 24 }, {
                    type: "3-Year Premium", months: 36 }, {
                        type: "5-Year Lifetime", months: 60
                    }
    ]

    for warranty in warranties {
        if (warranty.HasProp("days"))
            expiry := DateAdd(purchaseDate, warranty.days, "days")
        else
            expiry := DateAdd(purchaseDate, warranty.months, "months")

        daysRemaining := DateDiff(expiry, A_Now, "days")
        status := daysRemaining > 0 ? "Active" : "Expired"

        output .= Format("  {:-20s}: {:s} ({:s})",
            warranty.type,
            FormatTime(expiry, "MMM dd, yyyy"),
            status) . "`n"
    }

    ; Service intervals
    output .= "`n`nService Maintenance Schedule:`n"
    serviceIntervals := [{
        desc: "First Service (30 days)", days: 30 }, {
            desc: "3-Month Service", months: 3 }, {
                desc: "6-Month Service", months: 6 }, {
                    desc: "Annual Service", months: 12 }, {
                        desc: "2-Year Major Service", months: 24
                    }
    ]

    for interval in serviceIntervals {
        if (interval.HasProp("days"))
            serviceDate := DateAdd(purchaseDate, interval.days, "days")
        else
            serviceDate := DateAdd(purchaseDate, interval.months, "months")

        daysUntil := DateDiff(serviceDate, A_Now, "days")

        if (daysUntil > 0) {
            output .= Format("  {:-25s}: {:s} (in {:d} days)",
                interval.desc,
                FormatTime(serviceDate, "MMM dd"),
                daysUntil) . "`n"
        }
    }

    ; Extended warranty options
    output .= "`n`nExtended Warranty Add-Ons:`n"
    standardExpiry := DateAdd(purchaseDate, 12, "months")
    output .= "  Standard Warranty Ends: " . FormatTime(standardExpiry, "MMM dd, yyyy") . "`n`n"

    extensions := [{
        name: "+1 Year Extension", months: 12 }, {
            name: "+2 Year Extension", months: 24 }, {
                name: "+3 Year Extension", months: 36
            }
    ]

    for ext in extensions {
        newExpiry := DateAdd(standardExpiry, ext.months, "months")
        output .= "  " . ext.name . ": Coverage until " . FormatTime(newExpiry, "MMM dd, yyyy") . "`n"
    }

    MsgBox(output, "Warranty Management", 262144)
}

; ============================================================================
; Example 2: Medication and Treatment Schedules
; ============================================================================

/**
 * Creates medication schedules and treatment timelines.
 * Common use: Healthcare, medical reminders, treatment planning
 */
Example2_MedicationSchedule() {
    output := "=== Example 2: Medication Schedule ===`n`n"
    treatmentStart := A_Now

    output .= "Treatment Start: " . FormatTime(treatmentStart, "MMMM dd, yyyy") . "`n`n"

    ; Antibiotic course (every 8 hours for 10 days)
    output .= "Antibiotic Course (Every 8 hours for 10 days):`n"
    output .= "Doses for first 2 days:`n"

    currentTime := treatmentStart
    doseCount := 1

    loop 6 {  ; First 6 doses (2 days)
        output .= Format("  Dose {:d}: {:s}",
            doseCount,
            FormatTime(currentTime, "MMM dd 'at' h:mm tt")) . "`n"
        currentTime := DateAdd(currentTime, 8, "hours")
        doseCount++
    }

    courseDuration := 10
    totalDoses := (courseDuration * 24) / 8
    courseEnd := DateAdd(treatmentStart, courseDuration, "days")

    output .= "`n  Total doses: " . totalDoses . " doses over " . courseDuration . " days`n"
    output .= "  Course ends: " . FormatTime(courseEnd, "MMM dd, yyyy 'at' h:mm tt") . "`n"

    ; Daily medication
    output .= "`n`nDaily Medication (Next 7 Days):`n"
    dailyMedTime := FormatTime(treatmentStart, "yyyyMMdd") . "080000"  ; 8:00 AM

    loop 7 {
        nextDose := DateAdd(dailyMedTime, A_Index - 1, "days")
        output .= "  Day " . A_Index . ": " . FormatTime(nextDose, "ddd, MMM dd 'at' h:mm tt") . "`n"
    }

    ; Weekly injection
    output .= "`n`nWeekly Injection Schedule (12 weeks):`n"
    injectionDay := treatmentStart

    loop 12 {
        injection := DateAdd(injectionDay, (A_Index - 1) * 7, "days")
        output .= Format("  Week {:2d}: {:s}",
            A_Index,
            FormatTime(injection, "ddd, MMM dd")) . "`n"
    }

    ; Post-treatment checkups
    output .= "`n`nPost-Treatment Checkups:`n"
    checkups := [{
        desc: "1-week follow-up", days: 7 }, {
            desc: "2-week follow-up", days: 14 }, {
                desc: "1-month follow-up", days: 30 }, {
                    desc: "3-month follow-up", days: 90 }, {
                        desc: "6-month follow-up", days: 180
                    }
    ]

    for checkup in checkups {
        appointmentDate := DateAdd(courseEnd, checkup.days, "days")
        output .= "  " . checkup.desc . ": " . FormatTime(appointmentDate, "MMM dd, yyyy") . "`n"
    }

    MsgBox(output, "Medication Schedule", 262144)
}

; ============================================================================
; Example 3: Lease and Rental Calculations
; ============================================================================

/**
 * Manages lease periods and rental agreements.
 * Common use: Property management, equipment rental, lease tracking
 */
Example3_LeaseManagement() {
    output := "=== Example 3: Lease Management ===`n`n"
    leaseStart := A_Now

    output .= "Lease Start Date: " . FormatTime(leaseStart, "MMMM dd, yyyy") . "`n`n"

    ; Common lease terms
    output .= "Lease Term Options:`n"
    leaseTerms := [{
        term: "6-Month Lease", months: 6 }, {
            term: "12-Month Lease", months: 12 }, {
                term: "18-Month Lease", months: 18 }, {
                    term: "24-Month Lease", months: 24 }, {
                        term: "36-Month Lease", months: 36
                    }
    ]

    for lease in leaseTerms {
        leaseEnd := DateAdd(leaseStart, lease.months, "months")
        daysRemaining := DateDiff(leaseEnd, A_Now, "days")

        output .= Format("  {:-18s}: Ends {:s} ({:d} days)",
            lease.term,
            FormatTime(leaseEnd, "MMM dd, yyyy"),
            daysRemaining) . "`n"
    }

    ; Monthly rent due dates (12-month lease)
    output .= "`n`nMonthly Rent Schedule (12-Month Lease):`n"
    leaseTerm := 12

    loop leaseTerm {
        rentDue := DateAdd(leaseStart, A_Index - 1, "months")
        monthNum := A_Index

        output .= Format("  Month {:2d}: Rent due {:s}",
            monthNum,
            FormatTime(rentDue, "MMM 01, yyyy")) . "`n"
    }

    ; Lease renewal timeline
    output .= "`n`nLease Renewal Timeline:`n"
    leaseEnd := DateAdd(leaseStart, 12, "months")

    renewalMilestones := [{
        desc: "90-day notice period begins", days: -90 }, {
            desc: "60-day renewal reminder", days: -60 }, {
                desc: "30-day final decision", days: -30 }, {
                    desc: "Lease ends / Move-out", days: 0
                }
    ]

    for milestone in renewalMilestones {
        milestoneDate := DateAdd(leaseEnd, milestone.days, "days")
        daysFromNow := DateDiff(milestoneDate, A_Now, "days")

        output .= Format("  {:-30s}: {:s}",
            milestone.desc,
            FormatTime(milestoneDate, "MMM dd, yyyy")) . "`n"
    }

    ; Security deposit return
    output .= "`n`nSecurity Deposit Return:`n"
    moveOut := leaseEnd
    depositReturn := DateAdd(moveOut, 30, "days")  ; Typically within 30 days

    output .= "  Move-out date: " . FormatTime(moveOut, "MMM dd, yyyy") . "`n"
    output .= "  Deposit return deadline: " . FormatTime(depositReturn, "MMM dd, yyyy") . "`n"

    MsgBox(output, "Lease Management", 262144)
}

; ============================================================================
; Example 4: Academic Calendar and Semester Planning
; ============================================================================

/**
 * Creates academic calendars and semester schedules.
 * Common use: Education, course planning, academic administration
 */
Example4_AcademicCalendar() {
    output := "=== Example 4: Academic Calendar ===`n`n"

    ; Fall semester example
    fallStart := FormatTime(A_Now, "yyyy") . "0901000000"  ; September 1

    output .= "Fall Semester " . FormatTime(fallStart, "yyyy") . ":`n"
    output .= "  Semester Start: " . FormatTime(fallStart, "MMM dd") . "`n"

    ; Key academic dates
    orientationWeek := DateAdd(fallStart, -7, "days")
    addDropDeadline := DateAdd(fallStart, 14, "days")
    midterms := DateAdd(fallStart, 56, "days")  ; ~8 weeks
    thanksgiving := DateAdd(fallStart, 77, "days")  ; Late November
    finals := DateAdd(fallStart, 112, "days")  ; ~16 weeks
    semesterEnd := DateAdd(finals, 7, "days")

    output .= "  Orientation: " . FormatTime(orientationWeek, "MMM dd") . "`n"
    output .= "  Add/Drop Deadline: " . FormatTime(addDropDeadline, "MMM dd") . "`n"
    output .= "  Midterm Exams: " . FormatTime(midterms, "MMM dd") . "`n"
    output .= "  Thanksgiving Break: " . FormatTime(thanksgiving, "MMM dd") . "`n"
    output .= "  Final Exams: " . FormatTime(finals, "MMM dd") . "`n"
    output .= "  Semester End: " . FormatTime(semesterEnd, "MMM dd") . "`n`n"

    ; Spring semester
    springStart := FormatTime(A_Now, "yyyy") . "0115000000"  ; January 15
    if (springStart < A_Now)
        springStart := DateAdd(springStart, 1, "years")

    output .= "Spring Semester " . FormatTime(springStart, "yyyy") . ":`n"
    output .= "  Semester Start: " . FormatTime(springStart, "MMM dd") . "`n"

    springAddDrop := DateAdd(springStart, 14, "days")
    springBreak := DateAdd(springStart, 63, "days")  ; ~9 weeks
    springFinals := DateAdd(springStart, 112, "days")  ; ~16 weeks
    springEnd := DateAdd(springFinals, 7, "days")

    output .= "  Add/Drop Deadline: " . FormatTime(springAddDrop, "MMM dd") . "`n"
    output .= "  Spring Break: " . FormatTime(springBreak, "MMM dd") . "`n"
    output .= "  Final Exams: " . FormatTime(springFinals, "MMM dd") . "`n"
    output .= "  Semester End: " . FormatTime(springEnd, "MMM dd") . "`n`n"

    ; Assignment due dates (weekly, 12 weeks)
    output .= "Weekly Assignment Schedule (First 6 Weeks):`n"
    assignmentDay := DateAdd(fallStart, 4, "days")  ; Fridays

    loop 6 {
        dueDate := DateAdd(assignmentDay, (A_Index - 1) * 7, "days")
        output .= Format("  Week {:d}: Due {:s}",
            A_Index,
            FormatTime(dueDate, "ddd, MMM dd")) . "`n"
    }

    ; Academic breaks
    output .= "`n`nAcademic Year Breaks:`n"
    breaks := [{
        name: "Fall Break", start: DateAdd(fallStart, 49, "days"), days: 3 }, {
            name: "Winter Break", start: semesterEnd, days: 21 }, {
                name: "Spring Break", start: springBreak, days: 7 }, {
                    name: "Summer Break", start: springEnd, days: 90
                }
    ]

    for breakPeriod in breaks {
        breakEnd := DateAdd(breakPeriod.start, breakPeriod.days, "days")
        output .= Format("  {:-15s}: {:s} - {:s} ({:d} days)",
            breakPeriod.name,
            FormatTime(breakPeriod.start, "MMM dd"),
            FormatTime(breakEnd, "MMM dd"),
            breakPeriod.days) . "`n"
    }

    MsgBox(output, "Academic Calendar", 262144)
}

; ============================================================================
; Example 5: Loan and Payment Schedules
; ============================================================================

/**
 * Creates loan amortization and payment schedules.
 * Common use: Finance, loans, installment payments
 */
Example5_PaymentSchedule() {
    output := "=== Example 5: Loan Payment Schedule ===`n`n"
    loanDate := A_Now

    output .= "Loan Origination: " . FormatTime(loanDate, "MMMM dd, yyyy") . "`n`n"

    ; Monthly payment schedule (24 months)
    output .= "Monthly Payment Schedule (24-Month Loan):`n"
    loanTerm := 24

    ; First 6 payments
    loop 6 {
        paymentDate := DateAdd(loanDate, A_Index, "months")
        principal := 10000  ; Example
        monthlyPayment := principal / loanTerm

        output .= Format("  Payment {:2d}: {:s} (${:,.2f})",
            A_Index,
            FormatTime(paymentDate, "MMM 01, yyyy"),
            monthlyPayment) . "`n"
    }

    output .= "  ... (payments 7-23)`n"

    finalPayment := DateAdd(loanDate, loanTerm, "months")
    output .= Format("  Payment {:2d}: {:s} (${:,.2f} - Final)",
        loanTerm,
        FormatTime(finalPayment, "MMM 01, yyyy"),
        monthlyPayment) . "`n`n"

    ; Quarterly payment option
    output .= "Quarterly Payment Option (6 Quarters):`n"
    quarterlyTerm := 6

    loop quarterlyTerm {
        qtrPayment := DateAdd(loanDate, A_Index * 3, "months")
        qtrAmount := (principal / quarterlyTerm)

        output .= Format("  Quarter {:d}: {:s} (${:,.2f})",
            A_Index,
            FormatTime(qtrPayment, "MMM 01, yyyy"),
            qtrAmount) . "`n"
    }

    ; Bi-weekly payment schedule
    output .= "`n`nBi-Weekly Payment Schedule (First 10 Payments):`n"
    biweeklyStart := loanDate

    loop 10 {
        payDate := DateAdd(biweeklyStart, (A_Index - 1) * 14, "days")
        biweeklyAmount := (principal / 52) * 2  ; Assume 52 biweekly periods

        output .= Format("  Payment {:2d}: {:s} (${:,.2f})",
            A_Index,
            FormatTime(payDate, "MMM dd"),
            biweeklyAmount) . "`n"
    }

    ; Grace period and late fees
    output .= "`n`nPayment Terms:`n"
    dueDate := DateAdd(loanDate, 1, "months")
    graceEnd := DateAdd(dueDate, 10, "days")
    lateFeeDate := DateAdd(graceEnd, 1, "days")

    output .= "  Payment Due: " . FormatTime(dueDate, "MMM 01") . "`n"
    output .= "  Grace Period Ends: " . FormatTime(graceEnd, "MMM 10") . "`n"
    output .= "  Late Fee Applied: " . FormatTime(lateFeeDate, "MMM 11") . "`n"

    MsgBox(output, "Payment Schedule", 262144)
}

; ============================================================================
; Example 6: Project Phase and Milestone Planning
; ============================================================================

/**
 * Creates detailed project timelines with phases and milestones.
 * Common use: Project management, development cycles, construction
 */
Example6_ProjectPhases() {
    output := "=== Example 6: Project Phase Planning ===`n`n"
    projectStart := A_Now

    output .= "Project Start: " . FormatTime(projectStart, "MMMM dd, yyyy") . "`n`n"

    ; Project phases
    phases := [{
        name: "Planning", weeks: 2 }, {
            name: "Design", weeks: 3 }, {
                name: "Development", weeks: 8 }, {
                    name: "Testing", weeks: 3 }, {
                        name: "Deployment", weeks: 1 }, {
                            name: "Post-Launch Support", weeks: 2
                        }
    ]

    output .= "Project Phases:`n"
    currentDate := projectStart

    for phase in phases {
        phaseEnd := DateAdd(currentDate, phase.weeks * 7, "days")

        output .= Format("  {:-25s}: {:s} - {:s} ({:d} weeks)",
            phase.name,
            FormatTime(currentDate, "MMM dd"),
            FormatTime(phaseEnd, "MMM dd"),
            phase.weeks) . "`n"

        currentDate := DateAdd(phaseEnd, 1, "days")
    }

    totalWeeks := 0
    for phase in phases
        totalWeeks += phase.weeks

    projectEnd := DateAdd(projectStart, totalWeeks * 7, "days")
    output .= "`n  Total Duration: " . totalWeeks . " weeks`n"
    output .= "  Project End: " . FormatTime(projectEnd, "MMMM dd, yyyy") . "`n`n"

    ; Major milestones
    output .= "Major Milestones:`n"
    milestones := [{
        name: "Kickoff Meeting", week: 0 }, {
            name: "Design Approval", week: 5 }, {
                name: "Alpha Release", week: 9 }, {
                    name: "Beta Release", week: 13 }, {
                        name: "Production Release", week: 17 }, {
                            name: "Project Closure", week: 19
                        }
    ]

    for milestone in milestones {
        msDate := DateAdd(projectStart, milestone.week * 7, "days")
        weeksFromNow := DateDiff(msDate, A_Now, "days") / 7

        output .= Format("  {:-25s}: Week {:2d} ({:s})",
            milestone.name,
            milestone.week + 1,
            FormatTime(msDate, "MMM dd")) . "`n"
    }

    ; Sprint schedule (2-week sprints)
    output .= "`n`n2-Week Sprint Schedule:`n"
    sprintStart := projectStart
    sprintCount := Ceil(totalWeeks / 2)

    loop 6 {  ; Show first 6 sprints
        if (A_Index > sprintCount)
            break

        sprintEnd := DateAdd(sprintStart, 14, "days")

        output .= Format("  Sprint {:d}: {:s} - {:s}",
            A_Index,
            FormatTime(sprintStart, "MMM dd"),
            FormatTime(sprintEnd, "MMM dd")) . "`n"

        sprintStart := DateAdd(sprintEnd, 1, "days")
    }

    MsgBox(output, "Project Phases", 262144)
}

; ============================================================================
; Example 7: Recurring Maintenance and Inspection Schedules
; ============================================================================

/**
 * Creates maintenance and inspection schedules.
 * Common use: Equipment maintenance, facility management, compliance
 */
Example7_MaintenanceSchedule() {
    output := "=== Example 7: Maintenance Schedule ===`n`n"
    today := A_Now

    ; Vehicle maintenance
    output .= "Vehicle Maintenance Schedule:`n"
    lastService := today

    services := [{
        type: "Oil Change", interval: 3, unit: "months" }, {
            type: "Tire Rotation", interval: 6, unit: "months" }, {
                type: "Annual Inspection", interval: 12, unit: "months" }, {
                    type: "Brake Check", interval: 12, unit: "months" }, {
                        type: "Battery Check", interval: 24, unit: "months"
                    }
    ]

    for service in services {
        nextService := DateAdd(lastService, service.interval, service.unit)
        daysUntil := DateDiff(nextService, today, "days")

        output .= Format("  {:-20s}: {:s} (in {:d} days)",
            service.type,
            FormatTime(nextService, "MMM dd, yyyy"),
            daysUntil) . "`n"
    }

    ; Building inspections
    output .= "`n`nBuilding Inspection Schedule:`n"
    lastInspection := today

    inspections := [{
        type: "Fire Safety", months: 6 }, {
            type: "HVAC System", months: 3 }, {
                type: "Elevator", months: 1 }, {
                    type: "Electrical", months: 12 }, {
                        type: "Plumbing", months: 6
                    }
    ]

    for inspection in inspections {
        nextInsp := DateAdd(lastInspection, inspection.months, "months")

        output .= Format("  {:-20s}: Every {:d} months, next on {:s}",
            inspection.type,
            inspection.months,
            FormatTime(nextInsp, "MMM dd")) . "`n"
    }

    ; Equipment calibration
    output .= "`n`nEquipment Calibration Schedule:`n"
    calibrationBase := today

    equipment := ["Sensor A", "Meter B", "Scale C", "Gauge D"]
    calibrationInterval := 90  ; days

    for i, item in equipment {
        nextCal := DateAdd(calibrationBase, i * calibrationInterval, "days")

        output .= Format("  {:-15s}: {:s}",
            item,
            FormatTime(nextCal, "MMM dd, yyyy")) . "`n"
    }

    ; Filter replacements (quarterly)
    output .= "`n`nFilter Replacement Schedule (Quarterly):`n"
    quarterStart := today

    loop 4 {
        replDate := DateAdd(quarterStart, (A_Index - 1) * 3, "months")

        output .= Format("  Q{:d} {:s}: {:s}",
            A_Index,
            FormatTime(replDate, "yyyy"),
            FormatTime(replDate, "MMM dd")) . "`n"
    }

    ; Safety drills (semi-annual)
    output .= "`n`nSafety Drill Schedule:`n"
    drillTypes := ["Fire Drill", "Evacuation Drill"]

    for type in drillTypes {
        firstDrill := DateAdd(today, 1, "months")
        secondDrill := DateAdd(firstDrill, 6, "months")

        output .= "  " . type . ":`n"
        output .= "    " . FormatTime(firstDrill, "MMM dd, yyyy") . "`n"
        output .= "    " . FormatTime(secondDrill, "MMM dd, yyyy") . "`n"
    }

    MsgBox(output, "Maintenance Schedule", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
                                                                                                                                                                    (
                                                                                                                                                                    DateAdd() - Complex Scenarios

                                                                                                                                                                    Examples:
                                                                                                                                                                    1. Warranty Management
                                                                                                                                                                    2. Medication Schedule
                                                                                                                                                                    3. Lease Management
                                                                                                                                                                    4. Academic Calendar
                                                                                                                                                                    5. Payment Schedule
                                                                                                                                                                    6. Project Phases
                                                                                                                                                                    7. Maintenance Schedule

                                                                                                                                                                    Press Ctrl+1-7 to run examples
                                                                                                                                                                    )"
    MsgBox(menu, "DateAdd Complex Scenarios", 4096)
}

^1:: Example1_WarrantyManagement()
^2:: Example2_MedicationSchedule()
^3:: Example3_LeaseManagement()
^4:: Example4_AcademicCalendar()
^5:: Example5_PaymentSchedule()
^6:: Example6_ProjectPhases()
^7:: Example7_MaintenanceSchedule()
^m:: ShowMenu()

ShowMenu()
