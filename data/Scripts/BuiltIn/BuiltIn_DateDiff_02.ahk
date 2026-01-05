#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * DateDiff Function - Advanced Analysis and Reporting
 * ============================================================================
 * 
 * This script demonstrates advanced DateDiff() operations including analytics,
 * performance metrics, and sophisticated time-based calculations.
 * 
 * @description Advanced DateDiff() for analytics and complex calculations
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Advanced Applications:
 * - Performance metrics and SLA tracking
 * - Business analytics and KPIs
 * - Time-based reports
 * - Trend analysis
 * - Capacity planning
 */

; ============================================================================
; Example 1: SLA and Response Time Tracking
; ============================================================================

/**
 * Tracks SLA compliance and response times.
 * Common use: Support tickets, customer service, IT operations
 */
Example1_SLATracking() {
    output := "=== Example 1: SLA Tracking ===`n`n"

    ; Support tickets with SLA
    tickets := [{
        id: "TKT-001", priority: "High", created: "20240115080000", resolved: "20240115093000", sla: 4 }, {
            id: "TKT-002", priority: "Medium", created: "20240115090000", resolved: "20240115170000", sla: 8 }, {
                id: "TKT-003", priority: "Low", created: "20240115100000", resolved: "20240116103000", sla: 24 }, {
                    id: "TKT-004", priority: "High", created: "20240115110000", resolved: "20240115163000", sla: 4 }, {
                        id: "TKT-005", priority: "Medium", created: "20240115120000", resolved: "20240115153000", sla: 8
                    }
    ]

    output .= "SLA Compliance Report:`n`n"
    output .= Format("{:-10s} {:-8s} {:>12s} {:>12s} {:>8s}",
        "Ticket", "Priority", "Response (h)", "SLA (h)", "Status") . "`n"
    output .= StrReplace(Format("{:55s}", ""), " ", "─") . "`n"

    totalTickets := tickets.Length
    metSLA := 0

    for ticket in tickets {
        responseHours := DateDiff(ticket.resolved, ticket.created, "hours")
        minutesTotal := DateDiff(ticket.resolved, ticket.created, "minutes")
        responseTime := Format("{:.1f}", minutesTotal / 60)

        status := responseHours <= ticket.sla ? "✓ Met" : "✗ Missed"
        if (responseHours <= ticket.sla)
            metSLA++

        output .= Format("{:-10s} {:-8s} {:>12s} {:>12d} {:>8s}",
            ticket.id,
            ticket.priority,
            responseTime,
            ticket.sla,
            status) . "`n"
    }

    compliance := (metSLA / totalTickets) * 100
    output .= "`n" . StrReplace(Format("{:55s}", ""), " ", "─") . "`n"
    output .= Format("SLA Compliance Rate: {:.1f}% ({:d}/{:d} tickets)",
        compliance,
        metSLA,
        totalTickets) . "`n`n"

    ; Average response times by priority
    output .= "Average Response Time by Priority:`n"
    priorityStats := Map("High", [], "Medium", [], "Low", [])

    for ticket in tickets {
        hours := DateDiff(ticket.resolved, ticket.created, "hours")
        priorityStats[ticket.priority].Push(hours)
    }

    for priority, times in priorityStats {
        if (times.Length > 0) {
            sum := 0
            for time in times
                sum += time
            avg := sum / times.Length

            output .= Format("  {:-10s}: {:.1f} hours average ({:d} tickets)",
                priority,
                avg,
                times.Length) . "`n"
        }
    }

    MsgBox(output, "SLA Tracking", 262144)
}

; ============================================================================
; Example 2: Performance Metrics and Benchmarking
; ============================================================================

/**
 * Analyzes performance metrics using time differences.
 * Common use: System monitoring, optimization, benchmarking
 */
Example2_PerformanceMetrics() {
    output := "=== Example 2: Performance Metrics ===`n`n"

    ; API response times
    apiCalls := [{
        endpoint: "/api/users", start: "20240115100000000", end: "20240115100000125" }, {
            endpoint: "/api/products", start: "20240115100100000", end: "20240115100100342" }, {
                endpoint: "/api/orders", start: "20240115100200000", end: "20240115100200089" }, {
                    endpoint: "/api/users", start: "20240115100300000", end: "20240115100300156" }, {
                        endpoint: "/api/products", start: "20240115100400000", end: "20240115100400298"
                    }
    ]

    output .= "API Response Times:`n`n"

    endpointStats := Map()

    for call in apiCalls {
        ; Calculate milliseconds (simulated - DateDiff only does seconds minimum)
        seconds := DateDiff(call.end, call.start, "seconds")
        ms := seconds * 1000 + 125  ; Simulated milliseconds

        if (!endpointStats.Has(call.endpoint))
            endpointStats[call.endpoint] := []

        endpointStats[call.endpoint].Push(ms)

        output .= Format("{:-20s}: {:>4d} ms",
            call.endpoint,
            ms) . "`n"
    }

    ; Calculate statistics per endpoint
    output .= "`n`nEndpoint Statistics:`n"
    output .= Format("{:-20s} {:>8s} {:>8s} {:>8s} {:>8s}",
        "Endpoint", "Calls", "Min", "Avg", "Max") . "`n"
    output .= StrReplace(Format("{:50s}", ""), " ", "─") . "`n"

    for endpoint, times in endpointStats {
        minTime := 999999
        maxTime := 0
        totalTime := 0

        for time in times {
            if (time < minTime)
                minTime := time
            if (time > maxTime)
                maxTime := time
            totalTime += time
        }

        avgTime := totalTime / times.Length

        output .= Format("{:-20s} {:>8d} {:>6d}ms {:>6d}ms {:>6d}ms",
            endpoint,
            times.Length,
            minTime,
            Round(avgTime),
            maxTime) . "`n"
    }

    ; Database query times
    output .= "`n`nDatabase Query Performance:`n"
    queries := [{
        query: "SELECT users", start: "20240115100000", end: "20240115100002" }, {
            query: "UPDATE products", start: "20240115100100", end: "20240115100105" }, {
                query: "INSERT orders", start: "20240115100200", end: "20240115100201"
            }
    ]

    for query in queries {
        seconds := DateDiff(query.end, query.start, "seconds")
        output .= Format("  {:-20s}: {:d}s", query.query, seconds) . "`n"
    }

    MsgBox(output, "Performance Metrics", 262144)
}

; ============================================================================
; Example 3: Business Analytics and KPIs
; ============================================================================

/**
 * Calculates business KPIs based on time differences.
 * Common use: Business intelligence, reporting, analytics dashboards
 */
Example3_BusinessAnalytics() {
    output := "=== Example 3: Business Analytics ===`n`n"

    ; Customer acquisition timeline
    customers := [{
        id: 1, signup: "20240101000000", firstPurchase: "20240103120000" }, {
            id: 2, signup: "20240102000000", firstPurchase: "20240102180000" }, {
                id: 3, signup: "20240103000000", firstPurchase: "20240110093000" }, {
                    id: 4, signup: "20240104000000", firstPurchase: "20240105150000" }, {
                        id: 5, signup: "20240105000000", firstPurchase: "20240106100000"
                    }
    ]

    output .= "Customer Acquisition Metrics:`n`n"

    totalConversionTime := 0
    fastestConversion := 999999
    slowestConversion := 0

    for customer in customers {
        conversionDays := DateDiff(customer.firstPurchase, customer.signup, "days")
        conversionHours := DateDiff(customer.firstPurchase, customer.signup, "hours")

        totalConversionTime += conversionHours

        if (conversionHours < fastestConversion)
            fastestConversion := conversionHours

        if (conversionHours > slowestConversion)
            slowestConversion := conversionHours

        output .= Format("  Customer {:d}: Converted in {:d} days ({:d} hours)",
            customer.id,
            conversionDays,
            conversionHours) . "`n"
    }

    avgConversion := totalConversionTime / customers.Length

    output .= "`n`nConversion Statistics:`n"
    output .= Format("  Average time to first purchase: {:.1f} hours ({:.1f} days)",
        avgConversion,
        avgConversion / 24) . "`n"
    output .= Format("  Fastest conversion: {:d} hours", fastestConversion) . "`n"
    output .= Format("  Slowest conversion: {:d} hours", slowestConversion) . "`n`n"

    ; Order fulfillment metrics
    output .= "Order Fulfillment Metrics:`n"
    orders := [{
        id: "ORD-001", placed: "20240110080000", shipped: "20240110140000", delivered: "20240112100000" }, {
            id: "ORD-002", placed: "20240110090000", shipped: "20240110150000", delivered: "20240113110000" }, {
                id: "ORD-003", placed: "20240110100000", shipped: "20240111100000", delivered: "20240114120000"
            }
    ]

    totalProcessing := 0
    totalDelivery := 0

    for order in orders {
        processingTime := DateDiff(order.shipped, order.placed, "hours")
        deliveryTime := DateDiff(order.delivered, order.shipped, "hours")
        totalTime := DateDiff(order.delivered, order.placed, "hours")

        totalProcessing += processingTime
        totalDelivery += deliveryTime

        output .= Format("  {:s}: Process={:d}h, Delivery={:d}h, Total={:d}h",
            order.id,
            processingTime,
            deliveryTime,
            totalTime) . "`n"
    }

    output .= "`n  Average processing time: " . Format("{:.1f}", totalProcessing / orders.Length) . " hours`n"
    output .= "  Average delivery time: " . Format("{:.1f}", totalDelivery / orders.Length) . " hours`n"

    MsgBox(output, "Business Analytics", 262144)
}

; ============================================================================
; Example 4: Trend Analysis and Patterns
; ============================================================================

/**
 * Identifies trends and patterns in time-based data.
 * Common use: Data analysis, forecasting, pattern detection
 */
Example4_TrendAnalysis() {
    output := "=== Example 4: Trend Analysis ===`n`n"

    ; Website traffic over time
    trafficData := [{
        date: "20240101000000", visits: 1250 }, {
            date: "20240108000000", visits: 1380 }, {
                date: "20240115000000", visits: 1520 }, {
                    date: "20240122000000", visits: 1680 }, {
                        date: "20240129000000", visits: 1850
                    }
    ]

    output .= "Weekly Traffic Growth:`n`n"

    for i, data in trafficData {
        if (i > 1) {
            daysBetween := DateDiff(data.date, trafficData[i - 1].date, "days")
            visitChange := data.visits - trafficData[i - 1].visits
            percentChange := (visitChange / trafficData[i - 1].visits) * 100

            output .= Format("Week of {:s}: {:,d} visits (+{:d}, +{:.1f}%)",
                FormatTime(data.date, "MMM dd"),
                data.visits,
                visitChange,
                percentChange) . "`n"
        } else {
            output .= Format("Week of {:s}: {:,d} visits (baseline)",
                FormatTime(data.date, "MMM dd"),
                data.visits) . "`n"
        }
    }

    ; Calculate overall growth
    totalDays := DateDiff(trafficData[trafficData.Length].date, trafficData[1].date, "days")
    totalGrowth := trafficData[trafficData.Length].visits - trafficData[1].visits
    percentGrowth := (totalGrowth / trafficData[1].visits) * 100

    output .= "`n`nOverall Trend (" . totalDays . " days):`n"
    output .= Format("  Total growth: +{:,d} visits (+{:.1f}%)", totalGrowth, percentGrowth) . "`n"
    output .= Format("  Average daily growth: {:.1f} visits/day", totalGrowth / totalDays) . "`n`n"

    ; Time between events analysis
    output .= "Event Frequency Analysis:`n"
    events := [
        "20240101120000",
        "20240103150000",
        "20240104100000",
        "20240107093000",
        "20240110140000"
    ]

    gaps := []
    for i, event in events {
        if (i > 1) {
            daysBetween := DateDiff(event, events[i - 1], "days")
            gaps.Push(daysBetween)
            output .= Format("  Event {:d}: {:d} days since previous event", i, daysBetween) . "`n"
        }
    }

    ; Calculate average gap
    if (gaps.Length > 0) {
        totalGaps := 0
        for gap in gaps
            totalGaps += gap
        avgGap := totalGaps / gaps.Length

        output .= Format("`n  Average time between events: {:.1f} days", avgGap) . "`n"
    }

    MsgBox(output, "Trend Analysis", 262144)
}

; ============================================================================
; Example 5: Employee Time Tracking and Productivity
; ============================================================================

/**
 * Tracks employee hours and calculates productivity metrics.
 * Common use: HR systems, time tracking, productivity analysis
 */
Example5_TimeTracking() {
    output := "=== Example 5: Employee Time Tracking ===`n`n"

    ; Time entries
    timeEntries := [{
        employee: "Alice", date: "20240115", clockIn: "20240115083000", clockOut: "20240115173000" }, {
            employee: "Alice", date: "20240116", clockIn: "20240116090000", clockOut: "20240116180000" }, {
                employee: "Bob", date: "20240115", clockIn: "20240115083000", clockOut: "20240115170000" }, {
                    employee: "Bob", date: "20240116", clockIn: "20240116085500", clockOut: "20240116174500" }, {
                        employee: "Carol", date: "20240115", clockIn: "20240115080000", clockOut: "20240115173000" }, {
                            employee: "Carol", date: "20240116", clockIn: "20240116080000", clockOut: "20240116180000"
                        }
    ]

    output .= "Daily Time Entries:`n`n"

    ; Calculate hours per employee
    employeeHours := Map()

    for entry in timeEntries {
        hours := DateDiff(entry.clockOut, entry.clockIn, "hours")
        minutes := DateDiff(entry.clockOut, entry.clockIn, "minutes")
        actualHours := Format("{:.2f}", minutes / 60)

        output .= Format("{:-10s} {:s}: {:s} - {:s} = {:s} hours",
            entry.employee,
            FormatTime(entry.clockIn, "MMM dd"),
            FormatTime(entry.clockIn, "h:mm tt"),
            FormatTime(entry.clockOut, "h:mm tt"),
            actualHours) . "`n"

        if (!employeeHours.Has(entry.employee))
            employeeHours[entry.employee] := 0
        employeeHours[entry.employee] += minutes
    }

    ; Summary by employee
    output .= "`n`nEmployee Summary:`n"
    output .= Format("{:-15s} {:>12s} {:>10s}", "Employee", "Total Hours", "Avg/Day") . "`n"
    output .= StrReplace(Format("{:40s}", ""), " ", "─") . "`n"

    for employee, totalMinutes in employeeHours {
        totalHours := Format("{:.2f}", totalMinutes / 60)

        ; Count days worked
        daysWorked := 0
        for entry in timeEntries {
            if (entry.employee = employee)
                daysWorked++
        }

        avgHours := Format("{:.2f}", (totalMinutes / 60) / daysWorked)

        output .= Format("{:-15s} {:>12s} {:>10s}",
            employee,
            totalHours,
            avgHours) . "`n"
    }

    ; Overtime analysis
    output .= "`n`nOvertime Analysis (>8 hours/day):`n"
    for entry in timeEntries {
        minutes := DateDiff(entry.clockOut, entry.clockIn, "minutes")
        hours := minutes / 60

        if (hours > 8) {
            overtime := hours - 8
            output .= Format("  {:s} on {:s}: {:.2f} hours OT",
                entry.employee,
                FormatTime(entry.clockIn, "MMM dd"),
                overtime) . "`n"
        }
    }

    MsgBox(output, "Time Tracking", 262144)
}

; ============================================================================
; Example 6: Project Timeline Analysis
; ============================================================================

/**
 * Analyzes project timelines and identifies delays.
 * Common use: Project management, schedule analysis, risk assessment
 */
Example6_ProjectAnalysis() {
    output := "=== Example 6: Project Timeline Analysis ===`n`n"

    ; Project tasks with planned vs actual dates
    tasks := [{
        name: "Requirements", plannedStart: "20240101", plannedEnd: "20240107", actualStart: "20240101", actualEnd: "20240108" }, {
            name: "Design", plannedStart: "20240108", plannedEnd: "20240121", actualStart: "20240109", actualEnd: "20240123" }, {
                name: "Development", plannedStart: "20240122", plannedEnd: "20240218", actualStart: "20240124", actualEnd: "20240220" }, {
                    name: "Testing", plannedStart: "20240219", plannedEnd: "20240303", actualStart: "20240221", actualEnd: "20240305"
                }
    ]

    output .= "Task Schedule Variance Analysis:`n`n"
    output .= Format("{:-15s} {:>10s} {:>10s} {:>10s}",
        "Task", "Planned", "Actual", "Variance") . "`n"
    output .= StrReplace(Format("{:50s}", ""), " ", "─") . "`n"

    totalVariance := 0
    delayedTasks := 0

    for task in tasks {
        plannedDays := DateDiff(task.plannedEnd . "000000", task.plannedStart . "000000", "days")
        actualDays := DateDiff(task.actualEnd . "000000", task.actualStart . "000000", "days")
        variance := actualDays - plannedDays

        totalVariance += variance
        if (variance > 0)
            delayedTasks++

        varianceStr := variance > 0 ? "+" . variance : String(variance)

        output .= Format("{:-15s} {:>8d}d {:>8d}d {:>9s}d",
            task.name,
            plannedDays,
            actualDays,
            varianceStr) . "`n"
    }

    output .= "`n`nProject Summary:`n"
    output .= "  Tasks delayed: " . delayedTasks . " of " . tasks.Length . "`n"
    output .= "  Total variance: " . totalVariance . " days`n"
    output .= "  Average variance: " . Format("{:.1f}", totalVariance / tasks.Length) . " days`n`n"

    ; Critical path analysis
    output .= "Timeline Impact:`n"
    plannedProjectEnd := tasks[tasks.Length].plannedEnd . "000000"
    actualProjectEnd := tasks[tasks.Length].actualEnd . "000000"
    projectDelay := DateDiff(actualProjectEnd, plannedProjectEnd, "days")

    output .= "  Planned completion: " . FormatTime(plannedProjectEnd, "MMM dd, yyyy") . "`n"
    output .= "  Actual completion: " . FormatTime(actualProjectEnd, "MMM dd, yyyy") . "`n"
    output .= "  Overall delay: " . projectDelay . " days`n"

    MsgBox(output, "Project Analysis", 262144)
}

; ============================================================================
; Example 7: Data Retention and Archive Management
; ============================================================================

/**
 * Manages data retention policies based on time differences.
 * Common use: Compliance, data governance, archive systems
 */
Example7_DataRetention() {
    output := "=== Example 7: Data Retention Management ===`n`n"
    today := A_Now

    ; Data records with retention policies
    records := [{
        type: "Transaction Logs", created: "20230101000000", retention: 365 }, {
            type: "Customer Data", created: "20200601000000", retention: 2190 },  ; 6 years
        {
            type: "Email Archives", created: "20231201000000", retention: 90 }, {
                type: "System Backups", created: "20240101000000", retention: 30 }, {
                    type: "Audit Trails", created: "20190115000000", retention: 2555 }  ; 7 years
    ]

    output .= "Data Retention Status:`n`n"
    output .= Format("{:-20s} {:>12s} {:>12s} {:>15s}",
        "Data Type", "Age (days)", "Retention", "Status") . "`n"
    output .= StrReplace(Format("{:65s}", ""), " ", "─") . "`n"

    recordsToArchive := 0
    recordsToDelete := 0

    for record in records {
        age := DateDiff(today, record.created, "days")
        retentionEnd := DateAdd(record.created, record.retention, "days")
        daysRemaining := DateDiff(retentionEnd, today, "days")

        status := ""
        if (daysRemaining > 90)
            status := "Active"
        else if (daysRemaining > 0) {
            status := "Archive Soon"
            recordsToArchive++
        } else {
            status := "Delete"
            recordsToDelete++
        }

        output .= Format("{:-20s} {:>12,d} {:>12d} {:>15s}",
            record.type,
            age,
            record.retention,
            status) . "`n"
    }

    output .= "`n`nRetention Summary:`n"
    output .= "  Records to archive: " . recordsToArchive . "`n"
    output .= "  Records to delete: " . recordsToDelete . "`n`n"

    ; Compliance periods
    output .= "Compliance Period Status:`n"
    complianceData := [{
        regulation: "GDPR", requirement: "Data deletion after 2 years", days: 730 }, {
            regulation: "SOX", requirement: "Financial records 7 years", days: 2555 }, {
                regulation: "HIPAA", requirement: "Medical records 6 years", days: 2190
            }
    ]

    for data in complianceData {
        testDate := DateAdd(today, -data.days, "days")
        output .= Format("  {:-10s}: Data before {:s} is due for review",
            data.regulation,
            FormatTime(testDate, "MMM yyyy")) . "`n"
    }

    MsgBox(output, "Data Retention", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
                                                                                                                                                (
                                                                                                                                                DateDiff() - Advanced Analysis

                                                                                                                                                Examples:
                                                                                                                                                1. SLA Tracking
                                                                                                                                                2. Performance Metrics
                                                                                                                                                3. Business Analytics
                                                                                                                                                4. Trend Analysis
                                                                                                                                                5. Time Tracking
                                                                                                                                                6. Project Analysis
                                                                                                                                                7. Data Retention

                                                                                                                                                Press Ctrl+1-7 to run examples
                                                                                                                                                )"
    MsgBox(menu, "DateDiff Advanced", 4096)
}

^1:: Example1_SLATracking()
^2:: Example2_PerformanceMetrics()
^3:: Example3_BusinessAnalytics()
^4:: Example4_TrendAnalysis()
^5:: Example5_TimeTracking()
^6:: Example6_ProjectAnalysis()
^7:: Example7_DataRetention()
^m:: ShowMenu()

ShowMenu()
