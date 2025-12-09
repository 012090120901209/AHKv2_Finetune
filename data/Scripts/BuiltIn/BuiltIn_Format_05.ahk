#Requires AutoHotkey v2.0

/**
* ============================================================================
* Format Function - Real-World Applications and Complex Scenarios
* ============================================================================
*
* This script demonstrates real-world applications of Format() function
* including data visualization, business documents, and system utilities.
*
* @description Real-world Format() applications and complex formatting scenarios
* @author AHK v2 Documentation Team
* @version 1.0.0
* @date 2024-01-15
*
* Real-World Applications:
* - Business reports and documents
* - Data visualization and charts
* - System monitoring dashboards
* - File and data exports
* - User interface formatting
*/

; ============================================================================
; Example 1: Financial Statement Generator
; ============================================================================

/**
* Generates complete financial statements with proper formatting.
* Common use: Accounting, financial reporting, business analytics
*/
Example1_FinancialStatements() {
    ; Generate complete income statement
    GenerateIncomeStatement(period, data) {
        statement := ""
        width := 70

        ; Header
        statement .= Format("{:^" . width . "s}", "INCOME STATEMENT") . "`n"
        statement .= Format("{:^" . width . "s}", period) . "`n"
        statement .= StrReplace(Format("{:" . width . "s}", ""), " ", "═") . "`n`n"

        ; Revenue section
        statement .= Format("{:-50s} {:>17s}", "REVENUE", "") . "`n"
        totalRevenue := 0
        for item in data.revenue {
            statement .= Format("  {:-48s} ${:>15,.2f}", item.name, item.amount) . "`n"
            totalRevenue += item.amount
        }
        statement .= Format("{:-50s} ${:>15,.2f}", "Total Revenue", totalRevenue) . "`n`n"

        ; Cost of Goods Sold
        statement .= Format("{:-50s} {:>17s}", "COST OF GOODS SOLD", "") . "`n"
        totalCOGS := 0
        for item in data.cogs {
            statement .= Format("  {:-48s} ${:>15,.2f}", item.name, item.amount) . "`n"
            totalCOGS += item.amount
        }
        statement .= Format("{:-50s} ${:>15,.2f}", "Total COGS", totalCOGS) . "`n"

        ; Gross Profit
        grossProfit := totalRevenue - totalCOGS
        statement .= Format("{:-50s} ${:>15,.2f}", "GROSS PROFIT", grossProfit) . "`n`n"

        ; Operating Expenses
        statement .= Format("{:-50s} {:>17s}", "OPERATING EXPENSES", "") . "`n"
        totalOpEx := 0
        for item in data.opex {
            statement .= Format("  {:-48s} ${:>15,.2f}", item.name, item.amount) . "`n"
            totalOpEx += item.amount
        }
        statement .= Format("{:-50s} ${:>15,.2f}", "Total Operating Expenses", totalOpEx) . "`n"

        ; Operating Income
        operatingIncome := grossProfit - totalOpEx
        statement .= Format("{:-50s} ${:>15,.2f}", "OPERATING INCOME", operatingIncome) . "`n`n"

        ; Other Income/Expenses
        otherIncome := data.otherIncome
        interestExpense := data.interestExpense

        statement .= Format("  {:-48s} ${:>15,.2f}", "Other Income", otherIncome) . "`n"
        statement .= Format("  {:-48s} (${:>14,.2f})", "Interest Expense", interestExpense) . "`n"

        ; Net Income Before Tax
        netBeforeTax := operatingIncome + otherIncome - interestExpense
        statement .= Format("{:-50s} ${:>15,.2f}", "NET INCOME BEFORE TAX", netBeforeTax) . "`n"

        ; Tax
        tax := netBeforeTax * data.taxRate
        statement .= Format("  {:-48s} (${:>14,.2f})", "Income Tax (" . Format("{:.1f}", data.taxRate * 100) . "%)", tax) . "`n"

        ; Net Income
        netIncome := netBeforeTax - tax
        statement .= StrReplace(Format("{:" . width . "s}", ""), " ", "═") . "`n"
        statement .= Format("{:-50s} ${:>15,.2f}", "NET INCOME", netIncome) . "`n"
        statement .= StrReplace(Format("{:" . width . "s}", ""), " ", "═") . "`n"

        ; Ratios
        statement .= "`n" . Format("{:^" . width . "s}", "KEY RATIOS") . "`n"
        statement .= StrReplace(Format("{:" . width . "s}", ""), " ", "─") . "`n"
        statement .= Format("{:-50s} {:>16.2f}%", "Gross Profit Margin", (grossProfit / totalRevenue) * 100) . "`n"
        statement .= Format("{:-50s} {:>16.2f}%", "Operating Margin", (operatingIncome / totalRevenue) * 100) . "`n"
        statement .= Format("{:-50s} {:>16.2f}%", "Net Profit Margin", (netIncome / totalRevenue) * 100) . "`n"

        return statement
    }

    ; Sample financial data
    financialData := {
        revenue: [
        {
            name: "Product Sales", amount: 2500000},
            {
                name: "Service Revenue", amount: 750000},
                {
                    name: "License Fees", amount: 250000
                }
                ],
                cogs: [
                {
                    name: "Direct Materials", amount: 800000},
                    {
                        name: "Direct Labor", amount: 500000},
                        {
                            name: "Manufacturing Overhead", amount: 300000
                        }
                        ],
                        opex: [
                        {
                            name: "Sales & Marketing", amount: 400000},
                            {
                                name: "General & Administrative", amount: 350000},
                                {
                                    name: "Research & Development", amount: 250000},
                                    {
                                        name: "Depreciation & Amortization", amount: 100000
                                    }
                                    ],
                                    otherIncome: 50000,
                                    interestExpense: 75000,
                                    taxRate: 0.21
                                }

                                output := GenerateIncomeStatement("Year Ended December 31, 2024", financialData)
                                MsgBox(output, "Financial Statement", 262144)
                            }

                            ; ============================================================================
                            ; Example 2: System Monitoring Dashboard
                            ; ============================================================================

                            /**
                            * Creates a system monitoring dashboard with real-time metrics.
                            * Common use: Server monitoring, performance tracking, system admin
                            */
                            Example2_SystemDashboard() {
                                ; Generate dashboard
                                GenerateDashboard(metrics) {
                                    dashboard := ""
                                    width := 75

                                    ; Title
                                    dashboard .= "╔" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "═") . "╗`n"
                                    dashboard .= "║" . Format("{:^" . (width - 2) . "s}", "SYSTEM MONITORING DASHBOARD") . "║`n"
                                    dashboard .= "║" . Format("{:^" . (width - 2) . "s}", FormatTime(, "yyyy-MM-dd HH:mm:ss")) . "║`n"
                                    dashboard .= "╠" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "═") . "╣`n"

                                    ; CPU Section
                                    dashboard .= "║ " . Format("{:-" . (width - 4) . "s}", "CPU METRICS") . " ║`n"
                                    cpuUsage := metrics.cpu.usage
                                    cpuBar := CreateBar(cpuUsage, 40)
                                    cpuStatus := cpuUsage > 80 ? "🔴 HIGH" : (cpuUsage > 60 ? "🟡 MEDIUM" : "🟢 NORMAL")

                                    dashboard .= "║ " . Format("Usage:    {:s} {:>5.1f}% {:s}", cpuBar, cpuUsage, cpuStatus) . " ║`n"
                                    dashboard .= "║ " . Format("Cores:    {:>2d} physical, {:>2d} logical", metrics.cpu.physical, metrics.cpu.logical) . StrReplace(Format("{:" . (width - 45) . "s}", ""), " ", " ") . " ║`n"
                                    dashboard .= "║ " . Format("Frequency: {:>6.2f} GHz", metrics.cpu.frequency) . StrReplace(Format("{:" . (width - 30) . "s}", ""), " ", " ") . " ║`n"

                                    ; Memory Section
                                    dashboard .= "╠" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "─") . "╣`n"
                                    dashboard .= "║ " . Format("{:-" . (width - 4) . "s}", "MEMORY METRICS") . " ║`n"

                                    memUsage := (metrics.memory.used / metrics.memory.total) * 100
                                    memBar := CreateBar(memUsage, 40)
                                    memStatus := memUsage > 85 ? "🔴 HIGH" : (memUsage > 70 ? "🟡 MEDIUM" : "🟢 NORMAL")

                                    dashboard .= "║ " . Format("Usage:    {:s} {:>5.1f}% {:s}", memBar, memUsage, memStatus) . " ║`n"
                                    dashboard .= "║ " . Format("Used:     {:.2f} GB / {:.2f} GB", metrics.memory.used, metrics.memory.total) . StrReplace(Format("{:" . (width - 42) . "s}", ""), " ", " ") . " ║`n"
                                    dashboard .= "║ " . Format("Available: {:.2f} GB", metrics.memory.available) . StrReplace(Format("{:" . (width - 30) . "s}", ""), " ", " ") . " ║`n"

                                    ; Disk Section
                                    dashboard .= "╠" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "─") . "╣`n"
                                    dashboard .= "║ " . Format("{:-" . (width - 4) . "s}", "DISK METRICS") . " ║`n"

                                    for disk in metrics.disks {
                                        diskUsage := (disk.used / disk.total) * 100
                                        diskBar := CreateBar(diskUsage, 30)
                                        diskStatus := diskUsage > 90 ? "🔴" : (diskUsage > 75 ? "🟡" : "🟢")

                                        dashboard .= "║ " . Format("{:s}: {:s} {:>5.1f}% ({:.0f}/{:.0f}GB) {:s}",
                                        disk.letter, diskBar, diskUsage, disk.used, disk.total, diskStatus) . " ║`n"
                                    }

                                    ; Network Section
                                    dashboard .= "╠" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "─") . "╣`n"
                                    dashboard .= "║ " . Format("{:-" . (width - 4) . "s}", "NETWORK METRICS") . " ║`n"
                                    dashboard .= "║ " . Format("Download: {:>8.2f} Mbps  ↓ {:>10s}",
                                    metrics.network.download, FormatBytes(metrics.network.downloadBytes) . "/s") . StrReplace(Format("{:" . (width - 50) . "s}", ""), " ", " ") . " ║`n"
                                    dashboard .= "║ " . Format("Upload:   {:>8.2f} Mbps  ↑ {:>10s}",
                                    metrics.network.upload, FormatBytes(metrics.network.uploadBytes) . "/s") . StrReplace(Format("{:" . (width - 50) . "s}", ""), " ", " ") . " ║`n"

                                    ; Process Section
                                    dashboard .= "╠" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "─") . "╣`n"
                                    dashboard .= "║ " . Format("{:-" . (width - 4) . "s}", "TOP PROCESSES") . " ║`n"
                                    dashboard .= "║ " . Format("{:-25s} {:>12s} {:>12s}", "Process", "CPU %", "Memory") . StrReplace(Format("{:" . (width - 57) . "s}", ""), " ", " ") . " ║`n"

                                    for proc in metrics.processes {
                                        dashboard .= "║ " . Format("{:-25s} {:>11.1f}% {:>12s}",
                                        proc.name, proc.cpu, FormatBytes(proc.memory)) . StrReplace(Format("{:" . (width - 57) . "s}", ""), " ", " ") . " ║`n"
                                    }

                                    dashboard .= "╚" . StrReplace(Format("{:" . (width - 2) . "s}", ""), " ", "═") . "╝"

                                    return dashboard
                                }

                                CreateBar(percentage, width) {
                                    filled := Round(percentage * width / 100)
                                    return StrReplace(Format("{:" . filled . "s}", ""), " ", "█")
                                    . StrReplace(Format("{:" . (width - filled) . "s}", ""), " ", "░")
                                }

                                FormatBytes(bytes) {
                                    if (bytes >= 1073741824)
                                    return Format("{:.1f}GB", bytes / 1073741824)
                                    else if (bytes >= 1048576)
                                    return Format("{:.1f}MB", bytes / 1048576)
                                    else if (bytes >= 1024)
                                    return Format("{:.1f}KB", bytes / 1024)
                                    else
                                    return Format("{:d}B", bytes)
                                }

                                ; Sample metrics data
                                metricsData := {
                                    cpu: {usage: 45.5, physical: 8, logical: 16, frequency: 3.6},
                                    memory: {total: 32.0, used: 18.5, available: 13.5},
                                    disks: [
                                    {
                                        letter: "C", total: 500, used: 325},
                                        {
                                            letter: "D", total: 1000, used: 680},
                                            {
                                                letter: "E", total: 2000, used: 450
                                            }
                                            ],
                                            network: {download: 125.5, upload: 45.2, downloadBytes: 15728640, uploadBytes: 5767168},
                                            processes: [
                                            {
                                                name: "chrome.exe", cpu: 12.5, memory: 2147483648},
                                                {
                                                    name: "code.exe", cpu: 8.3, memory: 1073741824},
                                                    {
                                                        name: "AutoHotkey64.exe", cpu: 2.1, memory: 52428800},
                                                        {
                                                            name: "explorer.exe", cpu: 1.5, memory: 209715200
                                                        }
                                                        ]
                                                    }

                                                    dashboard := GenerateDashboard(metricsData)
                                                    MsgBox(dashboard, "System Dashboard", 262144)
                                                }

                                                ; ============================================================================
                                                ; Example 3: Project Management Report
                                                ; ============================================================================

                                                /**
                                                * Generates project management reports with tasks, timelines, and progress.
                                                * Common use: Project tracking, team management, status reporting
                                                */
                                                Example3_ProjectReport() {
                                                    GenerateProjectReport(project) {
                                                        report := ""
                                                        width := 80

                                                        ; Header
                                                        report .= Format("{:═^" . width . "s}", " PROJECT STATUS REPORT ") . "`n"
                                                        report .= Format("{:^" . width . "s}", project.name) . "`n"
                                                        report .= Format("{:^" . width . "s}", "Report Date: " . project.reportDate) . "`n"
                                                        report .= StrReplace(Format("{:" . width . "s}", ""), " ", "═") . "`n`n"

                                                        ; Project Overview
                                                        report .= Format("{:-40s}", "PROJECT OVERVIEW") . "`n"
                                                        report .= Format("  Project Manager: {:-60s}", project.manager) . "`n"
                                                        report .= Format("  Start Date:      {:-60s}", project.startDate) . "`n"
                                                        report .= Format("  End Date:        {:-60s}", project.endDate) . "`n"
                                                        report .= Format("  Status:          {:-60s}", project.status) . "`n"
                                                        report .= Format("  Budget:          ${:,.2f}", project.budget) . "`n"
                                                        report .= Format("  Spent:           ${:,.2f} ({:.1f}%)", project.spent, (project.spent/project.budget)*100) . "`n`n"

                                                        ; Overall Progress
                                                        overallProgress := 0
                                                        for task in project.tasks
                                                        overallProgress += task.progress
                                                        overallProgress /= project.tasks.Length

                                                        report .= Format("{:-40s}", "OVERALL PROGRESS") . "`n"
                                                        progressBar := CreateProgressBar(overallProgress, 50)
                                                        report .= Format("  {:s} {:.1f}%", progressBar, overallProgress) . "`n`n"

                                                        ; Tasks
                                                        report .= Format("{:-40s}", "TASKS") . "`n"
                                                        report .= Format("  {:-3s} {:-30s} {:-12s} {:>8s} {:>10s}",
                                                        "ID", "Task Name", "Assignee", "Progress", "Status") . "`n"
                                                        report .= StrReplace(Format("  {:" . (width - 2) . "s}", ""), " ", "─") . "`n"

                                                        for task in project.tasks {
                                                            statusIcon := task.status = "Complete" ? "✓"
                                                            : (task.status = "In Progress" ? "►"
                                                            : (task.status = "Blocked" ? "✗" : "○"))

                                                            report .= Format("  {:>3d} {:-30s} {:-12s} {:>7.0f}% {:s} {:s}",
                                                            task.id,
                                                            task.name,
                                                            task.assignee,
                                                            task.progress,
                                                            statusIcon,
                                                            task.status) . "`n"
                                                        }

                                                        ; Milestones
                                                        report .= "`n" . Format("{:-40s}", "MILESTONES") . "`n"
                                                        for milestone in project.milestones {
                                                            status := milestone.completed ? "✓ Completed" : "○ Pending"
                                                            report .= Format("  {:-50s} {:s} ({:s})",
                                                            milestone.name,
                                                            milestone.date,
                                                            status) . "`n"
                                                        }

                                                        ; Risks and Issues
                                                        if (project.risks.Length > 0) {
                                                            report .= "`n" . Format("{:-40s}", "RISKS & ISSUES") . "`n"
                                                            for risk in project.risks {
                                                                severity := risk.severity = "High" ? "🔴" : (risk.severity = "Medium" ? "🟡" : "🟢")
                                                                report .= Format("  {:s} [{:-8s}] {:s}",
                                                                severity,
                                                                risk.severity,
                                                                risk.description) . "`n"
                                                            }
                                                        }

                                                        return report
                                                    }

                                                    CreateProgressBar(percentage, width) {
                                                        filled := Round(percentage * width / 100)
                                                        bar := StrReplace(Format("{:" . filled . "s}", ""), " ", "█")
                                                        bar .= StrReplace(Format("{:" . (width - filled) . "s}", ""), " ", "░")
                                                        return "[" . bar . "]"
                                                    }

                                                    ; Sample project data
                                                    projectData := {
                                                        name: "Website Redesign Project",
                                                        manager: "Sarah Johnson",
                                                        startDate: "2024-01-01",
                                                        endDate: "2024-03-31",
                                                        reportDate: "2024-01-15",
                                                        status: "On Track",
                                                        budget: 150000,
                                                        spent: 45000,
                                                        tasks: [
                                                        {
                                                            id: 1, name: "Requirements Gathering", assignee: "Alice", progress: 100, status: "Complete"},
                                                            {
                                                                id: 2, name: "Design Mockups", assignee: "Bob", progress: 80, status: "In Progress"},
                                                                {
                                                                    id: 3, name: "Frontend Development", assignee: "Carol", progress: 45, status: "In Progress"},
                                                                    {
                                                                        id: 4, name: "Backend Development", assignee: "David", progress: 30, status: "In Progress"},
                                                                        {
                                                                            id: 5, name: "Testing", assignee: "Eve", progress: 0, status: "Not Started"},
                                                                            {
                                                                                id: 6, name: "Deployment", assignee: "Frank", progress: 0, status: "Not Started"
                                                                            }
                                                                            ],
                                                                            milestones: [
                                                                            {
                                                                                name: "Project Kickoff", date: "2024-01-01", completed: true},
                                                                                {
                                                                                    name: "Design Approval", date: "2024-01-20", completed: false},
                                                                                    {
                                                                                        name: "Development Complete", date: "2024-02-28", completed: false},
                                                                                        {
                                                                                            name: "Go Live", date: "2024-03-31", completed: false
                                                                                        }
                                                                                        ],
                                                                                        risks: [
                                                                                        {
                                                                                            severity: "Medium", description: "Third-party API integration delays"},
                                                                                            {
                                                                                                severity: "Low", description: "Team member vacation in February"
                                                                                            }
                                                                                            ]
                                                                                        }

                                                                                        report := GenerateProjectReport(projectData)
                                                                                        MsgBox(report, "Project Report", 262144)
                                                                                    }

                                                                                    ; ============================================================================
                                                                                    ; Example 4: CSV/Excel Export Formatter
                                                                                    ; ============================================================================

                                                                                    /**
                                                                                    * Formats data for CSV/Excel export with proper escaping and alignment.
                                                                                    * Common use: Data export, reporting, integration with spreadsheets
                                                                                    */
                                                                                    Example4_DataExport() {
                                                                                        ; Generate CSV with proper escaping
                                                                                        GenerateCSV(headers, rows, delimiter := ",") {
                                                                                            EscapeCSVField(field) {
                                                                                                field := String(field)
                                                                                                if (InStr(field, delimiter) || InStr(field, "`n") || InStr(field, '"'))
                                                                                                return '"' . StrReplace(field, '"', '""') . '"'
                                                                                                return field
                                                                                            }

                                                                                            csv := ""

                                                                                            ; Headers
                                                                                            headerLine := ""
                                                                                            for i, header in headers {
                                                                                                headerLine .= EscapeCSVField(header)
                                                                                                if (i < headers.Length)
                                                                                                headerLine .= delimiter
                                                                                            }
                                                                                            csv .= headerLine . "`n"

                                                                                            ; Data rows
                                                                                            for row in rows {
                                                                                                line := ""
                                                                                                for i, cell in row {
                                                                                                    line .= EscapeCSVField(cell)
                                                                                                    if (i < row.Length)
                                                                                                    line .= delimiter
                                                                                                }
                                                                                                csv .= line . "`n"
                                                                                            }

                                                                                            return csv
                                                                                        }

                                                                                        ; Generate fixed-width format
                                                                                        GenerateFixedWidth(headers, rows, widths) {
                                                                                            output := ""

                                                                                            ; Headers
                                                                                            headerLine := ""
                                                                                            for i, header in headers {
                                                                                                headerLine .= Format("{:-" . widths[i] . "s} ", header)
                                                                                            }
                                                                                            output .= headerLine . "`n"

                                                                                            ; Separator
                                                                                            sepLine := ""
                                                                                            for width in widths {
                                                                                                sepLine .= StrReplace(Format("{:" . (width + 1) . "s}", ""), " ", "-")
                                                                                            }
                                                                                            output .= sepLine . "`n"

                                                                                            ; Data rows
                                                                                            for row in rows {
                                                                                                line := ""
                                                                                                for i, cell in row {
                                                                                                    cellStr := String(cell)
                                                                                                    if (IsNumber(cell) && cell != Floor(cell))
                                                                                                    line .= Format("{:>" . widths[i] . ".2f} ", cell)
                                                                                                    else if (IsNumber(cell))
                                                                                                    line .= Format("{:>" . widths[i] . "d} ", cell)
                                                                                                    else
                                                                                                    line .= Format("{:-" . widths[i] . "s} ", cellStr)
                                                                                                }
                                                                                                output .= line . "`n"
                                                                                            }

                                                                                            return output
                                                                                        }

                                                                                        output := "=== Example 4: Data Export Formatting ===`n`n"

                                                                                        ; Sample sales data
                                                                                        headers := ["Order ID", "Customer", "Product", "Quantity", "Price", "Total"]
                                                                                        rows := [
                                                                                        [1001, "Acme Corp", "Widget Pro", 5, 299.99, 1499.95],
                                                                                        [1002, "TechStart Inc", "Gadget, Premium", 2, 549.50, 1099.00],
                                                                                        [1003, 'ABC "Solutions"', "Tool Set", 1, 199.99, 199.99],
                                                                                        [1004, "Global Ltd", "Accessory Pack", 10, 29.99, 299.90]
                                                                                        ]

                                                                                        ; CSV format
                                                                                        output .= "CSV Format (Comma-Separated):`n"
                                                                                        output .= StrReplace(Format("{:80s}", ""), " ", "─") . "`n"
                                                                                        output .= GenerateCSV(headers, rows)

                                                                                        ; TSV format
                                                                                        output .= "`nTSV Format (Tab-Separated):`n"
                                                                                        output .= StrReplace(Format("{:80s}", ""), " ", "─") . "`n"
                                                                                        output .= GenerateCSV(headers, rows, "`t")

                                                                                        ; Fixed-width format
                                                                                        output .= "`nFixed-Width Format:`n"
                                                                                        output .= StrReplace(Format("{:80s}", ""), " ", "─") . "`n"
                                                                                        columnWidths := [8, 20, 20, 8, 8, 10]
                                                                                        output .= GenerateFixedWidth(headers, rows, columnWidths)

                                                                                        MsgBox(output, "Data Export", 262144)
                                                                                    }

                                                                                    ; ============================================================================
                                                                                    ; Example 5: ASCII Charts and Visualizations
                                                                                    ; ============================================================================

                                                                                    /**
                                                                                    * Creates ASCII-based charts and data visualizations.
                                                                                    * Common use: Console output, reports, quick data visualization
                                                                                    */
                                                                                    Example5_ASCIICharts() {
                                                                                        ; Create horizontal bar chart
                                                                                        CreateBarChart(data, maxWidth := 50) {
                                                                                            chart := ""
                                                                                            maxValue := 0

                                                                                            for item in data {
                                                                                                if (item.value > maxValue)
                                                                                                maxValue := item.value
                                                                                            }

                                                                                            for item in data {
                                                                                                barLength := Round((item.value / maxValue) * maxWidth)
                                                                                                bar := StrReplace(Format("{:" . barLength . "s}", ""), " ", "█")
                                                                                                chart .= Format("{:-20s} {:s} {:.1f}",
                                                                                                item.label,
                                                                                                bar,
                                                                                                item.value) . "`n"
                                                                                            }

                                                                                            return chart
                                                                                        }

                                                                                        ; Create line chart
                                                                                        CreateLineChart(data, height := 15, width := 60) {
                                                                                            chart := ""

                                                                                            ; Find min/max
                                                                                            minVal := data[1].value
                                                                                            maxVal := data[1].value

                                                                                            for item in data {
                                                                                                if (item.value < minVal)
                                                                                                minVal := item.value
                                                                                                if (item.value > maxVal)
                                                                                                maxVal := item.value
                                                                                            }

                                                                                            range := maxVal - minVal
                                                                                            if (range = 0)
                                                                                            range := 1

                                                                                            ; Create grid
                                                                                            grid := []
                                                                                            loop height {
                                                                                                row := []
                                                                                                loop width
                                                                                                row.Push(" ")
                                                                                                grid.Push(row)
                                                                                            }

                                                                                            ; Plot points
                                                                                            for i, item in data {
                                                                                                x := Round(((i - 1) / (data.Length - 1)) * (width - 1)) + 1
                                                                                                y := height - Round(((item.value - minVal) / range) * (height - 1))

                                                                                                if (x <= width && y >= 1 && y <= height)
                                                                                                grid[y][x] := "●"

                                                                                                ; Connect with lines
                                                                                                if (i > 1) {
                                                                                                    prevX := Round(((i - 2) / (data.Length - 1)) * (width - 1)) + 1
                                                                                                    prevY := height - Round(((data[i-1].value - minVal) / range) * (height - 1))

                                                                                                    ; Simple line drawing
                                                                                                    if (prevX != x) {
                                                                                                        steps := Abs(x - prevX)
                                                                                                        loop steps {
                                                                                                            t := A_Index / steps
                                                                                                            lineX := Round(prevX + (x - prevX) * t)
                                                                                                            lineY := Round(prevY + (y - prevY) * t)
                                                                                                            if (lineX <= width && lineY >= 1 && lineY <= height)
                                                                                                            grid[lineY][lineX] := "─"
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }

                                                                                            ; Draw Y-axis
                                                                                            chart .= Format("{:>8.1f} │", maxVal)
                                                                                            for col in grid[1]
                                                                                            chart .= col
                                                                                            chart .= "`n"

                                                                                            for i, row in grid {
                                                                                                if (i = 1)
                                                                                                continue
                                                                                                if (i = height) {
                                                                                                    chart .= Format("{:>8.1f} │", minVal)
                                                                                                } else {
                                                                                                    val := maxVal - ((i - 1) / (height - 1)) * range
                                                                                                    chart .= Format("{:>8.1f} │", val)
                                                                                                }

                                                                                                for col in row
                                                                                                chart .= col
                                                                                                chart .= "`n"
                                                                                            }

                                                                                            ; X-axis
                                                                                            chart .= "         └" . StrReplace(Format("{:" . width . "s}", ""), " ", "─") . "`n"

                                                                                            return chart
                                                                                        }

                                                                                        output := "=== Example 5: ASCII Charts ===`n`n"

                                                                                        ; Bar chart - Monthly sales
                                                                                        output .= "Monthly Sales (Bar Chart):`n"
                                                                                        salesData := [
                                                                                        {
                                                                                            label: "January", value: 125000},
                                                                                            {
                                                                                                label: "February", value: 138000},
                                                                                                {
                                                                                                    label: "March", value: 142000},
                                                                                                    {
                                                                                                        label: "April", value: 155000},
                                                                                                        {
                                                                                                            label: "May", value: 148000
                                                                                                        }
                                                                                                        ]

                                                                                                        output .= CreateBarChart(salesData, 40) . "`n"

                                                                                                        ; Line chart - Stock prices
                                                                                                        output .= "`nStock Price Trend (Line Chart):`n"
                                                                                                        stockData := [
                                                                                                        {
                                                                                                            date: "Day 1", value: 150.5},
                                                                                                            {
                                                                                                                date: "Day 2", value: 152.3},
                                                                                                                {
                                                                                                                    date: "Day 3", value: 148.7},
                                                                                                                    {
                                                                                                                        date: "Day 4", value: 155.2},
                                                                                                                        {
                                                                                                                            date: "Day 5", value: 158.9},
                                                                                                                            {
                                                                                                                                date: "Day 6", value: 157.1},
                                                                                                                                {
                                                                                                                                    date: "Day 7", value: 162.5
                                                                                                                                }
                                                                                                                                ]

                                                                                                                                output .= CreateLineChart(stockData, 10, 50)

                                                                                                                                MsgBox(output, "ASCII Charts", 262144)
                                                                                                                            }

                                                                                                                            ; ============================================================================
                                                                                                                            ; Example 6: Audit Log Formatter
                                                                                                                            ; ============================================================================

                                                                                                                            /**
                                                                                                                            * Formats audit logs with proper structure and searchability.
                                                                                                                            * Common use: Security auditing, compliance, system logs
                                                                                                                            */
                                                                                                                            Example6_AuditLog() {
                                                                                                                                FormatAuditEntry(entry) {
                                                                                                                                    timestamp := entry.timestamp
                                                                                                                                    level := entry.level
                                                                                                                                    user := entry.user
                                                                                                                                    action := entry.action
                                                                                                                                    resource := entry.resource
                                                                                                                                    details := entry.details
                                                                                                                                    ip := entry.ip

                                                                                                                                    ; Level icons
                                                                                                                                    icons := Map(
                                                                                                                                    "INFO", "ℹ️",
                                                                                                                                    "WARN", "⚠️",
                                                                                                                                    "ERROR", "❌",
                                                                                                                                    "SECURITY", "🔒",
                                                                                                                                    "CRITICAL", "🚨"
                                                                                                                                    )

                                                                                                                                    icon := icons.Has(level) ? icons[level] : "•"

                                                                                                                                    log := Format("[{:s}] {:s} {:-10s} | User: {:-15s} | IP: {:s}",
                                                                                                                                    timestamp,
                                                                                                                                    icon,
                                                                                                                                    level,
                                                                                                                                    user,
                                                                                                                                    ip) . "`n"

                                                                                                                                    log .= Format("{:>25s} Action: {:s} on {:s}",
                                                                                                                                    "",
                                                                                                                                    action,
                                                                                                                                    resource) . "`n"

                                                                                                                                    if (details != "")
                                                                                                                                    log .= Format("{:>25s} Details: {:s}",
                                                                                                                                    "",
                                                                                                                                    details) . "`n"

                                                                                                                                    return log
                                                                                                                                }

                                                                                                                                output := "=== Example 6: Audit Log ===`n`n"
                                                                                                                                output .= "SYSTEM AUDIT LOG - " . FormatTime(, "yyyy-MM-dd") . "`n"
                                                                                                                                output .= StrReplace(Format("{:80s}", ""), " ", "═") . "`n`n"

                                                                                                                                ; Sample audit entries
                                                                                                                                auditEntries := [
                                                                                                                                {
                                                                                                                                    timestamp: "2024-01-15 10:23:45",
                                                                                                                                    level: "INFO",
                                                                                                                                    user: "alice.johnson",
                                                                                                                                    action: "LOGIN",
                                                                                                                                    resource: "WebApp",
                                                                                                                                    details: "Successful authentication",
                                                                                                                                    ip: "192.168.1.100"
                                                                                                                                },
                                                                                                                                {
                                                                                                                                    timestamp: "2024-01-15 10:24:12",
                                                                                                                                    level: "INFO",
                                                                                                                                    user: "alice.johnson",
                                                                                                                                    action: "READ",
                                                                                                                                    resource: "Document_12345",
                                                                                                                                    details: "Accessed confidential report",
                                                                                                                                    ip: "192.168.1.100"
                                                                                                                                },
                                                                                                                                {
                                                                                                                                    timestamp: "2024-01-15 10:25:33",
                                                                                                                                    level: "SECURITY",
                                                                                                                                    user: "unknown",
                                                                                                                                    action: "LOGIN_FAILED",
                                                                                                                                    resource: "WebApp",
                                                                                                                                    details: "Invalid credentials (attempt 3/5)",
                                                                                                                                    ip: "203.0.113.45"
                                                                                                                                },
                                                                                                                                {
                                                                                                                                    timestamp: "2024-01-15 10:26:01",
                                                                                                                                    level: "WARN",
                                                                                                                                    user: "bob.smith",
                                                                                                                                    action: "UPDATE",
                                                                                                                                    resource: "SystemConfig",
                                                                                                                                    details: "Modified security settings",
                                                                                                                                    ip: "192.168.1.105"
                                                                                                                                },
                                                                                                                                {
                                                                                                                                    timestamp: "2024-01-15 10:27:15",
                                                                                                                                    level: "CRITICAL",
                                                                                                                                    user: "unknown",
                                                                                                                                    action: "LOGIN_FAILED",
                                                                                                                                    resource: "AdminPanel",
                                                                                                                                    details: "Multiple failed admin login attempts - Account locked",
                                                                                                                                    ip: "203.0.113.45"
                                                                                                                                }
                                                                                                                                ]

                                                                                                                                for entry in auditEntries {
                                                                                                                                    output .= FormatAuditEntry(entry) . "`n"
                                                                                                                                }

                                                                                                                                ; Summary
                                                                                                                                output .= StrReplace(Format("{:80s}", ""), " ", "═") . "`n"
                                                                                                                                output .= Format("Total Entries: {:d} | Security Alerts: {:d} | Critical: {:d}",
                                                                                                                                auditEntries.Length,
                                                                                                                                2,
                                                                                                                                1) . "`n"

                                                                                                                                MsgBox(output, "Audit Log", 262144)
                                                                                                                            }

                                                                                                                            ; ============================================================================
                                                                                                                            ; Example 7: Multi-Format Report Generator
                                                                                                                            ; ============================================================================

                                                                                                                            /**
                                                                                                                            * Generates reports in multiple formats from single data source.
                                                                                                                            * Common use: Flexible reporting, multi-channel distribution
                                                                                                                            */
                                                                                                                            Example7_MultiFormatReport() {
                                                                                                                                ; Sample report data
                                                                                                                                reportData := {
                                                                                                                                    title: "Q1 2024 Sales Summary",
                                                                                                                                    date: "2024-01-15",
                                                                                                                                    summary: {
                                                                                                                                        totalSales: 3500000,
                                                                                                                                        totalOrders: 4250,
                                                                                                                                        avgOrderValue: 823.53,
                                                                                                                                        topRegion: "West Coast"
                                                                                                                                    },
                                                                                                                                    breakdown: [
                                                                                                                                    {
                                                                                                                                        region: "West Coast", sales: 1250000, orders: 1500},
                                                                                                                                        {
                                                                                                                                            region: "East Coast", sales: 980000, orders: 1100},
                                                                                                                                            {
                                                                                                                                                region: "Midwest", sales: 750000, orders: 950},
                                                                                                                                                {
                                                                                                                                                    region: "South", sales: 520000, orders: 700
                                                                                                                                                }
                                                                                                                                                ]
                                                                                                                                            }

                                                                                                                                            ; Text format
                                                                                                                                            textReport := Format("{:^60s}", reportData.title) . "`n"
                                                                                                                                            textReport .= Format("{:^60s}", reportData.date) . "`n"
                                                                                                                                            textReport .= StrReplace(Format("{:60s}", ""), " ", "=") . "`n`n"
                                                                                                                                            textReport .= "Summary:`n"
                                                                                                                                            textReport .= Format("  Total Sales:        ${:,.2f}", reportData.summary.totalSales) . "`n"
                                                                                                                                            textReport .= Format("  Total Orders:       {:,d}", reportData.summary.totalOrders) . "`n"
                                                                                                                                            textReport .= Format("  Avg Order Value:    ${:.2f}", reportData.summary.avgOrderValue) . "`n"
                                                                                                                                            textReport .= Format("  Top Region:         {:s}", reportData.summary.topRegion) . "`n`n"
                                                                                                                                            textReport .= "Regional Breakdown:`n"
                                                                                                                                            for item in reportData.breakdown {
                                                                                                                                                textReport .= Format("  {:-15s} ${:>10,.0f} ({:>5,d} orders)",
                                                                                                                                                item.region, item.sales, item.orders) . "`n"
                                                                                                                                            }

                                                                                                                                            ; HTML-like format
                                                                                                                                            htmlReport := "<report>`n"
                                                                                                                                            htmlReport .= Format("  <title>{:s}</title>", reportData.title) . "`n"
                                                                                                                                            htmlReport .= Format("  <date>{:s}</date>", reportData.date) . "`n"
                                                                                                                                            htmlReport .= "  <summary>`n"
                                                                                                                                            htmlReport .= Format("    <totalSales>{:.2f}</totalSales>", reportData.summary.totalSales) . "`n"
                                                                                                                                            htmlReport .= Format("    <totalOrders>{:d}</totalOrders>", reportData.summary.totalOrders) . "`n"
                                                                                                                                            htmlReport .= Format("    <avgOrderValue>{:.2f}</avgOrderValue>", reportData.summary.avgOrderValue) . "`n"
                                                                                                                                            htmlReport .= "  </summary>`n"
                                                                                                                                            htmlReport .= "  <regions>`n"
                                                                                                                                            for item in reportData.breakdown {
                                                                                                                                                htmlReport .= Format("    <region name='{:s}' sales='{:.2f}' orders='{:d}' />",
                                                                                                                                                item.region, item.sales, item.orders) . "`n"
                                                                                                                                            }
                                                                                                                                            htmlReport .= "  </regions>`n"
                                                                                                                                            htmlReport .= "</report>"

                                                                                                                                            ; JSON-like format
                                                                                                                                            jsonReport := "{`n"
                                                                                                                                            jsonReport .= Format('  "title": "{:s}",', reportData.title) . "`n"
                                                                                                                                            jsonReport .= Format('  "date": "{:s}",', reportData.date) . "`n"
                                                                                                                                            jsonReport .= '  "summary": {`n'
                                                                                                                                            jsonReport .= Format('    "totalSales": {:.2f},', reportData.summary.totalSales) . "`n"
                                                                                                                                            jsonReport .= Format('    "totalOrders": {:d},', reportData.summary.totalOrders) . "`n"
                                                                                                                                            jsonReport .= Format('    "avgOrderValue": {:.2f}', reportData.summary.avgOrderValue) . "`n"
                                                                                                                                            jsonReport .= '  },`n'
                                                                                                                                            jsonReport .= '  "breakdown": [`n'
                                                                                                                                            for i, item in reportData.breakdown {
                                                                                                                                                jsonReport .= Format('    {{"region": "{:s}", "sales": {:.2f}, "orders": {:d}}}',
                                                                                                                                                item.region, item.sales, item.orders)
                                                                                                                                                jsonReport .= (i < reportData.breakdown.Length ? "," : "") . "`n"
                                                                                                                                            }
                                                                                                                                            jsonReport .= '  ]`n'
                                                                                                                                            jsonReport .= "}"

                                                                                                                                            output := "=== Example 7: Multi-Format Report ===`n`n"
                                                                                                                                            output .= "TEXT FORMAT:`n" . StrReplace(Format("{:70s}", ""), " ", "-") . "`n"
                                                                                                                                            output .= textReport . "`n`n"
                                                                                                                                            output .= "XML-LIKE FORMAT:`n" . StrReplace(Format("{:70s}", ""), " ", "-") . "`n"
                                                                                                                                            output .= htmlReport . "`n`n"
                                                                                                                                            output .= "JSON-LIKE FORMAT:`n" . StrReplace(Format("{:70s}", ""), " ", "-") . "`n"
                                                                                                                                            output .= jsonReport

                                                                                                                                            MsgBox(output, "Multi-Format Report", 262144)
                                                                                                                                        }

                                                                                                                                        ; ============================================================================
                                                                                                                                        ; Main Menu and Hotkeys
                                                                                                                                        ; ============================================================================

                                                                                                                                        ShowMenu() {
                                                                                                                                            menu := "
                                                                                                                                            (
                                                                                                                                            Format() - Real-World Applications

                                                                                                                                            Examples:
                                                                                                                                            1. Financial Statements
                                                                                                                                            2. System Dashboard
                                                                                                                                            3. Project Report
                                                                                                                                            4. Data Export
                                                                                                                                            5. ASCII Charts
                                                                                                                                            6. Audit Log
                                                                                                                                            7. Multi-Format Report

                                                                                                                                            Press Ctrl+1-7 to run examples
                                                                                                                                            )"
                                                                                                                                            MsgBox(menu, "Format Real-World Examples", 4096)
                                                                                                                                        }

                                                                                                                                        ^1::Example1_FinancialStatements()
                                                                                                                                        ^2::Example2_SystemDashboard()
                                                                                                                                        ^3::Example3_ProjectReport()
                                                                                                                                        ^4::Example4_DataExport()
                                                                                                                                        ^5::Example5_ASCIICharts()
                                                                                                                                        ^6::Example6_AuditLog()
                                                                                                                                        ^7::Example7_MultiFormatReport()
                                                                                                                                        ^m::ShowMenu()

                                                                                                                                        ShowMenu()
