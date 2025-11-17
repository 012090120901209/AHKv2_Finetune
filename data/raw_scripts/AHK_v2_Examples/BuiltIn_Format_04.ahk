#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Format Function - Advanced Templates and Dynamic Formatting
 * ============================================================================
 *
 * This script demonstrates advanced template techniques, dynamic format
 * string construction, and complex formatting scenarios.
 *
 * @description Advanced template systems and dynamic formatting
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Advanced Techniques:
 * - Dynamic format string construction
 * - Conditional formatting
 * - Template inheritance
 * - Format string builders
 * - Recursive formatting
 */

; ============================================================================
; Example 1: Dynamic Format String Construction
; ============================================================================

/**
 * Shows how to build format strings dynamically based on runtime conditions.
 * Common use: Flexible reports, conditional output, adaptive formatting
 */
Example1_DynamicFormatStrings() {
    ; Build format strings based on data type
    FormatValue(value, options := "") {
        if (IsNumber(value)) {
            if (InStr(options, "currency"))
                return Format("${:,.2f}", value)
            else if (InStr(options, "percent"))
                return Format("{:.1f}%", value)
            else if (InStr(options, "hex"))
                return Format("0x{:X}", value)
            else if (value = Floor(value))
                return Format("{:,d}", value)
            else
                return Format("{:,.2f}", value)
        }
        return String(value)
    }

    output := "=== Example 1: Dynamic Format Strings ===`n`n"

    ; Financial data with different formatting needs
    data := Map(
        "Revenue", {value: 1250000, type: "currency"},
        "Growth", {value: 15.5, type: "percent"},
        "Customers", {value: 45678, type: "integer"},
        "Color Code", {value: 0xFF5733, type: "hex"},
        "Conversion Rate", {value: 3.75, type: "percent"},
        "Average Order", {value: 127.50, type: "currency"}
    )

    for name, info in data {
        formatted := FormatValue(info.value, info.type)
        output .= Format("{:-20s}: {:s}", name, formatted) . "`n"
    }

    ; Build table headers dynamically
    output .= "`n`nDynamic Column Widths:`n"
    columns := ["Name", "Department", "Salary", "Performance"]
    employees := [
        ["Alice Johnson", "Engineering", 95000, 4.5],
        ["Bob Smith", "Sales", 75000, 4.8],
        ["Carol White", "Marketing", 68000, 4.2]
    ]

    ; Calculate optimal column widths
    colWidths := []
    for col in columns
        colWidths.Push(StrLen(col))

    for row in employees {
        for i, cell in row {
            length := StrLen(String(cell))
            if (length > colWidths[i])
                colWidths[i] := length
        }
    }

    ; Build format string dynamically
    headerFmt := ""
    for i, width in colWidths {
        headerFmt .= "{" . i . ":-" . (width + 2) . "s}"
    }

    ; Display with dynamic formatting
    output .= Format(headerFmt, columns*) . "`n"
    output .= Format("{:-" . (colWidths[1] + colWidths[2] + colWidths[3] + colWidths[4] + 8) . "s}", "") . "`n"

    for row in employees {
        line := ""
        for i, cell in row {
            if (IsNumber(cell)) {
                if (i = 3)  ; Salary column
                    line .= Format("${:>" . colWidths[i] . ",.0f}  ", cell)
                else
                    line .= Format("{:>" . colWidths[i] . ".1f}  ", cell)
            } else {
                line .= Format("{:-" . (colWidths[i] + 2) . "s}", cell)
            }
        }
        output .= line . "`n"
    }

    MsgBox(output, "Dynamic Format Strings", 262144)
}

; ============================================================================
; Example 2: Conditional Formatting and Styling
; ============================================================================

/**
 * Demonstrates conditional formatting based on values and thresholds.
 * Common use: Status indicators, alerts, color-coded reports
 */
Example2_ConditionalFormatting() {
    ; Format with status indicators
    FormatMetric(name, value, target, unit := "") {
        percentage := (value / target) * 100
        status := ""
        indicator := ""

        if (percentage >= 100) {
            status := "EXCELLENT"
            indicator := "✓✓"
        } else if (percentage >= 90) {
            status := "GOOD"
            indicator := "✓"
        } else if (percentage >= 75) {
            status := "FAIR"
            indicator := "~"
        } else {
            status := "POOR"
            indicator := "✗"
        }

        return Format("{1:s} {2:-20s}: {3:>8,.0f}{4:s}/{5:>8,.0f}{4:s} ({6:>6.1f}%) [{7:-9s}]",
            indicator, name, value, unit, target, percentage, status)
    }

    output := "=== Example 2: Conditional Formatting ===`n`n"
    output .= "Performance Metrics:`n`n"

    metrics := [
        {name: "Sales Revenue", value: 125000, target: 100000, unit: "$"},
        {name: "New Customers", value: 450, target: 500, unit: ""},
        {name: "Support Tickets", value: 85, target: 100, unit: ""},
        {name: "Product Units", value: 2500, target: 3000, unit: ""},
        {name: "Website Visits", value: 45000, target: 40000, unit: ""}
    ]

    for metric in metrics {
        output .= FormatMetric(metric.name, metric.value, metric.target, metric.unit) . "`n"
    }

    ; Traffic light formatting for system health
    output .= "`n`nSystem Health Dashboard:`n`n"

    FormatHealthMetric(name, value, warningThreshold, criticalThreshold, inverse := false) {
        status := ""
        symbol := ""

        if (inverse) {  ; Lower is better
            if (value <= criticalThreshold) {
                status := "🟢 HEALTHY"
            } else if (value <= warningThreshold) {
                status := "🟡 WARNING"
            } else {
                status := "🔴 CRITICAL"
            }
        } else {  ; Higher is better
            if (value >= criticalThreshold) {
                status := "🟢 HEALTHY"
            } else if (value >= warningThreshold) {
                status := "🟡 WARNING"
            } else {
                status := "🔴 CRITICAL"
            }
        }

        return Format("{1:-25s}: {2:>8.1f}  {3:s}", name, value, status)
    }

    health := [
        {name: "CPU Usage", value: 45.5, warn: 70, crit: 50, inverse: true},
        {name: "Memory Available (GB)", value: 12.5, warn: 4, crit: 8, inverse: false},
        {name: "Disk Space (GB)", value: 125.0, warn: 50, crit: 100, inverse: false},
        {name: "Response Time (ms)", value: 85, warn: 200, crit: 100, inverse: true},
        {name: "Error Rate (%)", value: 0.5, warn: 2, crit: 1, inverse: true}
    ]

    for h in health {
        output .= FormatHealthMetric(h.name, h.value, h.warn, h.crit, h.inverse) . "`n"
    }

    MsgBox(output, "Conditional Formatting", 262144)
}

; ============================================================================
; Example 3: Nested and Recursive Formatting
; ============================================================================

/**
 * Shows recursive formatting for hierarchical data structures.
 * Common use: Tree structures, nested data, JSON-like output
 */
Example3_RecursiveFormatting() {
    ; Format nested structure with indentation
    FormatTree(node, indent := 0) {
        prefix := StrReplace(Format("{:" . (indent * 2) . "s}", ""), " ", "  ")
        output := ""

        if (node is Map) {
            for key, value in node {
                if (value is Map || value is Array) {
                    output .= prefix . Format("{:s}:", key) . "`n"
                    output .= FormatTree(value, indent + 1)
                } else {
                    output .= prefix . Format("{:s}: {:s}", key, String(value)) . "`n"
                }
            }
        } else if (node is Array) {
            for i, value in node {
                if (value is Map || value is Array) {
                    output .= prefix . Format("[{:d}]:", i) . "`n"
                    output .= FormatTree(value, indent + 1)
                } else {
                    output .= prefix . Format("[{:d}]: {:s}", i, String(value)) . "`n"
                }
            }
        }

        return output
    }

    output := "=== Example 3: Recursive Formatting ===`n`n"

    ; Complex nested structure
    organization := Map(
        "company", "TechCorp",
        "employees", 500,
        "departments", Map(
            "Engineering", Map(
                "manager", "Alice Johnson",
                "employees", 150,
                "teams", ["Backend", "Frontend", "DevOps"]
            ),
            "Sales", Map(
                "manager", "Bob Smith",
                "employees", 75,
                "regions", ["North", "South", "East", "West"]
            ),
            "Support", Map(
                "manager", "Carol White",
                "employees", 50,
                "channels", ["Email", "Phone", "Chat"]
            )
        ),
        "revenue", 15000000
    )

    output .= "Organization Structure:`n"
    output .= FormatTree(organization)

    ; File system tree
    output .= "`n`nFile System Tree:`n"
    fileSystem := Map(
        "project", Map(
            "src", ["main.ahk", "utils.ahk", "config.ahk"],
            "docs", ["README.md", "API.md"],
            "tests", Map(
                "unit", ["test_main.ahk", "test_utils.ahk"],
                "integration", ["test_api.ahk"]
            )
        )
    )

    output .= FormatTree(fileSystem)

    MsgBox(output, "Recursive Formatting", 262144)
}

; ============================================================================
; Example 4: Report Builder Pattern
; ============================================================================

/**
 * Implements a report builder pattern for complex documents.
 * Common use: Executive reports, dashboards, analytics
 */
Example4_ReportBuilder() {
    class ReportBuilder {
        __New() {
            this.sections := []
            this.width := 70
        }

        AddTitle(text) {
            border := StrReplace(Format("{:" . this.width . "s}", ""), " ", "═")
            this.sections.Push("╔" . border . "╗")
            this.sections.Push("║" . Format("{:^" . this.width . "s}", text) . "║")
            this.sections.Push("╚" . border . "╝")
            return this
        }

        AddSection(heading) {
            this.sections.Push("`n" . heading)
            this.sections.Push(StrReplace(Format("{:" . StrLen(heading) . "s}", ""), " ", "─"))
            return this
        }

        AddKeyValue(key, value, formatStr := "") {
            if (formatStr != "")
                value := Format(formatStr, value)
            this.sections.Push(Format("{:-30s}: {:s}", key, String(value)))
            return this
        }

        AddTable(headers, rows) {
            ; Simple table
            headerLine := ""
            for header in headers
                headerLine .= Format("{:-15s} ", header)
            this.sections.Push(headerLine)
            this.sections.Push(StrReplace(Format("{:" . (headers.Length * 16) . "s}", ""), " ", "─"))

            for row in rows {
                line := ""
                for cell in row
                    line .= Format("{:-15s} ", String(cell))
                this.sections.Push(line)
            }
            return this
        }

        AddChart(data, width := 50) {
            maxValue := 0
            for item in data
                if (item.value > maxValue)
                    maxValue := item.value

            for item in data {
                barWidth := Round((item.value / maxValue) * width)
                bar := StrReplace(Format("{:" . barWidth . "s}", ""), " ", "█")
                this.sections.Push(Format("{:-15s} {:s} {:,.0f}", item.label, bar, item.value))
            }
            return this
        }

        AddSeparator() {
            this.sections.Push(StrReplace(Format("{:" . this.width . "s}", ""), " ", "─"))
            return this
        }

        Build() {
            output := ""
            for section in this.sections
                output .= section . "`n"
            return output
        }
    }

    ; Build executive dashboard
    report := ReportBuilder()

    report.AddTitle("EXECUTIVE DASHBOARD - Q1 2024")
        .AddSection("Financial Summary")
        .AddKeyValue("Total Revenue", 5250000, "${:,.2f}")
        .AddKeyValue("Operating Expenses", 3125000, "${:,.2f}")
        .AddKeyValue("Net Profit", 2125000, "${:,.2f}")
        .AddKeyValue("Profit Margin", 40.5, "{:.1f}%")
        .AddSeparator()
        .AddSection("Department Performance")

    deptData := [
        {label: "Engineering", value: 2100000},
        {label: "Sales", value: 1850000},
        {label: "Marketing", value: 900000},
        {label: "Support", value: 400000}
    ]

    report.AddChart(deptData)
        .AddSeparator()
        .AddSection("Key Metrics")
        .AddTable(
            ["Metric", "Current", "Target"],
            [
                ["Customers", "12,450", "15,000"],
                ["Avg Order", "$127.50", "$120.00"],
                ["Satisfaction", "4.5/5.0", "4.3/5.0"]
            ]
        )

    MsgBox(report.Build(), "Report Builder", 262144)
}

; ============================================================================
; Example 5: Data Transformation Pipeline
; ============================================================================

/**
 * Shows formatting as part of a data transformation pipeline.
 * Common use: ETL processes, data export, API responses
 */
Example5_DataTransformation() {
    ; Transform and format data through pipeline
    class DataPipeline {
        __New(data) {
            this.data := data
        }

        Filter(condition) {
            filtered := []
            for item in this.data {
                if (condition(item))
                    filtered.Push(item)
            }
            this.data := filtered
            return this
        }

        Transform(transformFunc) {
            transformed := []
            for item in this.data
                transformed.Push(transformFunc(item))
            this.data := transformed
            return this
        }

        Sort(compareFunc) {
            ; Simple bubble sort for demonstration
            n := this.data.Length
            loop n - 1 {
                i := A_Index
                loop n - i {
                    j := A_Index
                    if (compareFunc(this.data[j], this.data[j + 1]) > 0) {
                        temp := this.data[j]
                        this.data[j] := this.data[j + 1]
                        this.data[j + 1] := temp
                    }
                }
            }
            return this
        }

        Format(formatFunc) {
            result := ""
            for item in this.data
                result .= formatFunc(item) . "`n"
            return result
        }
    }

    ; Sample transaction data
    transactions := [
        {id: 1001, customer: "Alice", amount: 250.50, type: "sale", date: "2024-01-15"},
        {id: 1002, customer: "Bob", amount: 1500.00, type: "sale", date: "2024-01-15"},
        {id: 1003, customer: "Carol", amount: 75.25, type: "refund", date: "2024-01-16"},
        {id: 1004, customer: "David", amount: 450.75, type: "sale", date: "2024-01-16"},
        {id: 1005, customer: "Eve", amount: 125.00, type: "sale", date: "2024-01-17"}
    ]

    output := "=== Example 5: Data Transformation ===`n`n"

    ; Pipeline 1: High-value sales
    output .= "High-Value Sales (>$200):`n"
    result := DataPipeline(transactions.Clone())
        .Filter((t) => t.type = "sale" && t.amount > 200)
        .Sort((a, b) => b.amount - a.amount)
        .Format((t) => Format("#{1:04d} | {2:-10s} | ${3:>8.2f} | {4:s}",
            t.id, t.customer, t.amount, t.date))

    output .= result

    ; Pipeline 2: Daily summary
    output .= "`n`nDaily Summary:`n"
    dailyTotals := Map()

    for trans in transactions {
        if (!dailyTotals.Has(trans.date))
            dailyTotals[trans.date] := {sales: 0, refunds: 0, count: 0}

        if (trans.type = "sale") {
            dailyTotals[trans.date].sales += trans.amount
            dailyTotals[trans.date].count++
        } else {
            dailyTotals[trans.date].refunds += trans.amount
        }
    }

    for date, totals in dailyTotals {
        net := totals.sales - totals.refunds
        output .= Format("{1:s} | Sales: ${2:>8.2f} | Refunds: ${3:>8.2f} | Net: ${4:>8.2f} | Orders: {5:d}",
            date, totals.sales, totals.refunds, net, totals.count) . "`n"
    }

    MsgBox(output, "Data Transformation", 262144)
}

; ============================================================================
; Example 6: Template Inheritance System
; ============================================================================

/**
 * Implements a template inheritance system for reusable formats.
 * Common use: Document generation, form letters, consistent branding
 */
Example6_TemplateInheritance() {
    ; Base template class
    class BaseTemplate {
        __New(data) {
            this.data := data
        }

        GetHeader() {
            return Format("╔{:═^60s}╗", " " . this.data.title . " ")
        }

        GetFooter() {
            return Format("╚{:═^60s}╝", " " . this.data.footer . " ")
        }

        Render() {
            return this.GetHeader() . "`n" . this.GetBody() . "`n" . this.GetFooter()
        }
    }

    ; Invoice template
    class InvoiceTemplate extends BaseTemplate {
        GetBody() {
            body := ""
            body .= Format("║ Invoice #: {:<48d} ║", this.data.invoiceNum) . "`n"
            body .= Format("║ Date: {:<53s} ║", this.data.date) . "`n"
            body .= Format("║ Customer: {:<50s} ║", this.data.customer) . "`n"
            body .= Format("║{:─^60s}║", "") . "`n"

            for item in this.data.items {
                body .= Format("║ {:<40s} ${:>16.2f} ║",
                    item.description, item.amount) . "`n"
            }

            body .= Format("║{:─^60s}║", "") . "`n"
            body .= Format("║ {:>42s} ${:>14.2f} ║", "TOTAL:", this.data.total)

            return body
        }
    }

    ; Receipt template
    class ReceiptTemplate extends BaseTemplate {
        GetBody() {
            body := ""
            body .= Format("║{:^60s}║", this.data.storeName) . "`n"
            body .= Format("║{:^60s}║", this.data.storeAddress) . "`n"
            body .= Format("║{:─^60s}║", "") . "`n"
            body .= Format("║ Date: {:<53s} ║", this.data.date) . "`n"
            body .= Format("║ Receipt #: {:<47d} ║", this.data.receiptNum) . "`n"
            body .= Format("║{:─^60s}║", "") . "`n"

            for item in this.data.items {
                body .= Format("║ {:<45s} ${:>11.2f} ║",
                    item.name . " x" . item.qty, item.price * item.qty) . "`n"
            }

            body .= Format("║{:─^60s}║", "") . "`n"
            body .= Format("║ {:>47s} ${:>9.2f} ║", "Subtotal:", this.data.subtotal) . "`n"
            body .= Format("║ {:>47s} ${:>9.2f} ║", "Tax:", this.data.tax) . "`n"
            body .= Format("║ {:>47s} ${:>9.2f} ║", "TOTAL:", this.data.total)

            return body
        }
    }

    output := "=== Example 6: Template Inheritance ===`n`n"

    ; Generate invoice
    invoiceData := {
        title: "INVOICE",
        footer: "Thank You",
        invoiceNum: 12345,
        date: "January 15, 2024",
        customer: "Acme Corporation",
        items: [
            {description: "Professional Services (40 hours)", amount: 5000.00},
            {description: "Software License", amount: 1500.00}
        ],
        total: 6500.00
    }

    invoice := InvoiceTemplate(invoiceData)
    output .= invoice.Render() . "`n`n"

    ; Generate receipt
    receiptData := {
        title: "RECEIPT",
        footer: "Please Come Again",
        storeName: "SuperMart",
        storeAddress: "123 Main St, Anytown, USA",
        date: "January 15, 2024 10:30 AM",
        receiptNum: 54321,
        items: [
            {name: "Widget", qty: 2, price: 19.99},
            {name: "Gadget", qty: 1, price: 49.99}
        ],
        subtotal: 89.97,
        tax: 7.65,
        total: 97.62
    }

    receipt := ReceiptTemplate(receiptData)
    output .= receipt.Render()

    MsgBox(output, "Template Inheritance", 262144)
}

; ============================================================================
; Example 7: Format String Library
; ============================================================================

/**
 * Creates a library of reusable format functions.
 * Common use: Code reuse, standardization, maintainability
 */
Example7_FormatLibrary() {
    class FormatLib {
        ; Format file size
        static FileSize(bytes) {
            units := ["B", "KB", "MB", "GB", "TB"]
            index := 1
            value := bytes

            while (value >= 1024 && index < units.Length) {
                value /= 1024
                index++
            }

            return index = 1
                ? Format("{:d} {:s}", value, units[index])
                : Format("{:.2f} {:s}", value, units[index])
        }

        ; Format percentage with bar
        static PercentBar(value, total, width := 20) {
            percentage := (value / total) * 100
            filled := Round((value / total) * width)
            bar := StrReplace(Format("{:" . filled . "s}", ""), " ", "█")
            bar .= StrReplace(Format("{:" . (width - filled) . "s}", ""), " ", "░")
            return Format("[{:s}] {:>5.1f}%", bar, percentage)
        }

        ; Format duration
        static Duration(seconds) {
            hours := Floor(seconds / 3600)
            mins := Floor(Mod(seconds, 3600) / 60)
            secs := Mod(seconds, 60)

            if (hours > 0)
                return Format("{:02d}:{:02d}:{:02d}", hours, mins, secs)
            else
                return Format("{:02d}:{:02d}", mins, secs)
        }

        ; Format phone number
        static Phone(number) {
            digits := RegExReplace(number, "\D")
            if (StrLen(digits) = 10)
                return Format("({:s}) {:s}-{:s}",
                    SubStr(digits, 1, 3),
                    SubStr(digits, 4, 3),
                    SubStr(digits, 7, 4))
            return number
        }

        ; Format credit card (masked)
        static CreditCard(number) {
            clean := RegExReplace(number, "\D")
            if (StrLen(clean) = 16) {
                last4 := SubStr(clean, 13, 4)
                return Format("**** **** **** {:s}", last4)
            }
            return number
        }

        ; Format money
        static Money(amount, currency := "$") {
            return Format("{:s}{:,.2f}", currency, amount)
        }

        ; Format coordinates
        static Coordinates(lat, lon) {
            latDir := lat >= 0 ? "N" : "S"
            lonDir := lon >= 0 ? "E" : "W"
            return Format("{:.6f}°{:s}, {:.6f}°{:s}",
                Abs(lat), latDir, Abs(lon), lonDir)
        }
    }

    output := "=== Example 7: Format Library ===`n`n"

    ; Demonstrate all formatters
    output .= "File Sizes:`n"
    output .= Format("  Small:  {:s}", FormatLib.FileSize(1024)) . "`n"
    output .= Format("  Medium: {:s}", FormatLib.FileSize(5242880)) . "`n"
    output .= Format("  Large:  {:s}", FormatLib.FileSize(1073741824)) . "`n`n"

    output .= "Progress Bars:`n"
    output .= "  Task 1: " . FormatLib.PercentBar(45, 100) . "`n"
    output .= "  Task 2: " . FormatLib.PercentBar(78, 100) . "`n"
    output .= "  Task 3: " . FormatLib.PercentBar(100, 100) . "`n`n"

    output .= "Durations:`n"
    output .= Format("  Short:  {:s}", FormatLib.Duration(125)) . "`n"
    output .= Format("  Medium: {:s}", FormatLib.Duration(3665)) . "`n"
    output .= Format("  Long:   {:s}", FormatLib.Duration(14523)) . "`n`n"

    output .= "Contact Information:`n"
    output .= Format("  Phone: {:s}", FormatLib.Phone("5551234567")) . "`n"
    output .= Format("  Card:  {:s}", FormatLib.CreditCard("4532123456789012")) . "`n`n"

    output .= "Financial:`n"
    output .= Format("  USD:   {:s}", FormatLib.Money(1234.56, "$")) . "`n"
    output .= Format("  EUR:   {:s}", FormatLib.Money(1234.56, "€")) . "`n`n"

    output .= "Geographic:`n"
    output .= Format("  NYC:   {:s}", FormatLib.Coordinates(40.7128, -74.0060)) . "`n"
    output .= Format("  Tokyo: {:s}", FormatLib.Coordinates(35.6762, 139.6503)) . "`n"

    MsgBox(output, "Format Library", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
    (
    Format() - Advanced Templates

    Examples:
    1. Dynamic Format Strings
    2. Conditional Formatting
    3. Recursive Formatting
    4. Report Builder
    5. Data Transformation
    6. Template Inheritance
    7. Format Library

    Press Ctrl+1-7 to run examples
    )"
    MsgBox(menu, "Advanced Format Examples", 4096)
}

^1::Example1_DynamicFormatStrings()
^2::Example2_ConditionalFormatting()
^3::Example3_RecursiveFormatting()
^4::Example4_ReportBuilder()
^5::Example5_DataTransformation()
^6::Example6_TemplateInheritance()
^7::Example7_FormatLibrary()
^m::ShowMenu()

ShowMenu()
