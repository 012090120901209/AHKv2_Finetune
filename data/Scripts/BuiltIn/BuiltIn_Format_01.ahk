#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * Format Function - Basic String Formatting and Number Padding
 * ============================================================================
 * 
 * This script demonstrates basic usage of the Format() function in AutoHotkey v2.
 * Format() provides printf-style string formatting with support for various
 * data types, padding, alignment, and precision control.
 * 
 * @description Comprehensive examples of Format() for string formatting and number padding
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Key Format Specifiers:
 * - {:d} or {:i} - Integer (decimal)
 * - {:f} - Floating point
 * - {:e} - Scientific notation
 * - {:s} - String
 * - {:x} - Hexadecimal (lowercase)
 * - {:X} - Hexadecimal (uppercase)
 * - {:o} - Octal
 * - {:u} - Unsigned integer
 * 
 * Modifiers:
 * - Width: {:10d} - Minimum width of 10
 * - Padding: {:05d} - Pad with zeros to width 5
 * - Alignment: {:-10s} - Left align in width 10
 * - Precision: {:.2f} - 2 decimal places
 */

; ============================================================================
; Example 1: Basic Number Formatting with Padding
; ============================================================================

/**
 * Demonstrates basic number formatting with zero-padding and width specification.
 * Common use: Invoice numbers, order IDs, file naming
 */
Example1_BasicNumberPadding() {
    MsgBox("=== Example 1: Basic Number Padding ===`n`n"
        . "Purpose: Format numbers with consistent width using zero-padding`n`n"
        . "Results:`n"
        . Format("Order ID: {:05d}", 42) . "`n"
        . Format("Order ID: {:05d}", 123) . "`n"
        . Format("Order ID: {:05d}", 9999) . "`n`n"
        . "Invoice: " . Format("INV-{:08d}", 1234) . "`n"
        . "Ticket: " . Format("TKT-{:06d}", 57) . "`n"
        . "File: " . Format("IMG_{:04d}.jpg", 89))
}

; ============================================================================
; Example 2: Decimal Precision and Floating Point Formatting
; ============================================================================

/**
 * Shows how to control decimal places and format floating point numbers.
 * Common use: Financial calculations, measurements, statistical reports
 */
Example2_DecimalPrecision() {
    price := 19.99
    taxRate := 0.085
    tax := price * taxRate
    total := price + tax

    ; Different precision levels
    output := "=== Example 2: Decimal Precision ===`n`n"
    output .= "Price Formatting:`n"
    output .= Format("Price: ${:.2f}", price) . "`n"
    output .= Format("Tax Rate: {:.1%}", taxRate) . "`n"
    output .= Format("Tax Amount: ${:.2f}", tax) . "`n"
    output .= Format("Total: ${:.2f}", total) . "`n`n"

    ; Scientific measurements
    measurement := 123.456789
    output .= "Scientific Measurements:`n"
    output .= Format("Raw: {:.6f}", measurement) . "`n"
    output .= Format("2 decimals: {:.2f}", measurement) . "`n"
    output .= Format("4 decimals: {:.4f}", measurement) . "`n"
    output .= Format("No decimals: {:.0f}", measurement) . "`n`n"

    ; Financial report
    revenue := 125678.5432
    expenses := 89234.123
    profit := revenue - expenses

    output .= "Financial Report:`n"
    output .= Format("Revenue:  ${:12,.2f}", revenue) . "`n"
    output .= Format("Expenses: ${:12,.2f}", expenses) . "`n"
    output .= Format("Profit:   ${:12,.2f}", profit) . "`n"

    MsgBox(output)
}

; ============================================================================
; Example 3: String Alignment and Width Control
; ============================================================================

/**
 * Demonstrates string alignment (left, right, center) and width control.
 * Common use: Creating formatted tables, aligned output, reports
 */
Example3_StringAlignment() {
    ; Create a formatted table
    output := "=== Example 3: String Alignment ===`n`n"
    output .= "Product Inventory Report:`n"
    output .= Format("{:-20s} {:>10s} {:>10s}", "Product", "Quantity", "Price") . "`n"
    output .= Format("{:-41s}", "") . "`n"  ; Separator line

    ; Product data
    products := [{
        name: "Widget", qty: 150, price: 19.99 }, {
            name: "Gadget Pro", qty: 75, price: 49.99 }, {
                name: "Tool Set", qty: 30, price: 129.99 }, {
                    name: "Accessories", qty: 200, price: 9.99
                }
    ]

    for product in products {
        output .= Format("{:-20s} {:>10d} {:>10.2f}",
            product.name,
            product.qty,
            product.price) . "`n"
    }

    output .= "`n`nAlignment Examples:`n"
    output .= Format("Left:   [{:-15s}]", "Text") . "`n"
    output .= Format("Right:  [{:>15s}]", "Text") . "`n"
    output .= Format("Center: [{:^15s}]", "Text") . "`n"

    MsgBox(output)
}

; ============================================================================
; Example 4: Invoice Generator with Format()
; ============================================================================

/**
 * Real-world example: Generate formatted invoices with proper alignment
 * and number formatting.
 */
Example4_InvoiceGenerator() {
    ; Invoice data
    invoiceNumber := 12345
    invoiceDate := "2024-01-15"
    customerName := "Acme Corporation"

    items := [{
        desc: "Professional Services", hours: 40, rate: 125.00 }, {
            desc: "Software License", qty: 5, price: 299.99 }, {
                desc: "Technical Support", hours: 8, rate: 95.00 }, {
                    desc: "Training Session", qty: 1, price: 750.00
                }
    ]

    ; Generate invoice
    invoice := ""
    invoice .= Format("{:^60s}", "INVOICE") . "`n"
    invoice .= Format("{:^60s}", "====================") . "`n`n"
    invoice .= Format("Invoice #: {:06d}", invoiceNumber) . Format("{:>45s}", "Date: " . invoiceDate) . "`n"
    invoice .= Format("Customer: {:-50s}", customerName) . "`n`n"

    invoice .= Format("{:-40s} {:>8s} {:>10s}", "Description", "Qty/Hrs", "Amount") . "`n"
    invoice .= Format("{:-60s}", "") . "`n"

    subtotal := 0
    for item in items {
        amount := 0
        qtyStr := ""

        if item.HasProp("hours") {
            amount := item.hours * item.rate
            qtyStr := Format("{:.1f}", item.hours)
        } else {
            amount := item.qty * item.price
            qtyStr := Format("{:d}", item.qty)
        }

        invoice .= Format("{:-40s} {:>8s} ${:>9.2f}", item.desc, qtyStr, amount) . "`n"
        subtotal += amount
    }

    tax := subtotal * 0.085
    total := subtotal + tax

    invoice .= Format("{:-60s}", "") . "`n"
    invoice .= Format("{:>48s} ${:>9.2f}", "Subtotal:", subtotal) . "`n"
    invoice .= Format("{:>48s} ${:>9.2f}", "Tax (8.5%):", tax) . "`n"
    invoice .= Format("{:>48s} ${:>9.2f}", "TOTAL:", total) . "`n"

    MsgBox(invoice, "Invoice Generator")
}

; ============================================================================
; Example 5: File Name Generator with Sequential Numbering
; ============================================================================

/**
 * Demonstrates creating formatted file names with dates and sequential numbers.
 * Common use: Batch processing, backup systems, log files
 */
Example5_FileNameGenerator() {
    ; Simulate generating file names for a backup system
    output := "=== Example 5: File Name Generator ===`n`n"

    ; Backup file names with date and sequence
    date := "20240115"
    for i, type in ["full", "incremental", "differential"] {
        for seq in [1, 25, 150] {
            fileName := Format("backup_{:s}_{:s}_{:04d}.bak", date, type, seq)
            output .= fileName . "`n"
        }
    }

    output .= "`n`nLog file rotation:`n"
    ; Log files with timestamps
    for hour in [0, 6, 12, 18, 23] {
        logFile := Format("app_log_{:s}_{:02d}00.log", date, hour)
        output .= logFile . "`n"
    }

    output .= "`n`nImage sequence:`n"
    ; Image sequence numbering
    for frame in [1, 10, 100, 999, 1500] {
        imgFile := Format("render_{:05d}.png", frame)
        output .= imgFile . "`n"
    }

    output .= "`n`nReport naming with zero-padding:`n"
    ; Monthly reports
    for month in [1, 2, 11, 12] {
        reportFile := Format("Sales_Report_2024_{:02d}.xlsx", month)
        output .= reportFile . "`n"
    }

    MsgBox(output)
}

; ============================================================================
; Example 6: Table Generator with Mixed Data Types
; ============================================================================

/**
 * Creates formatted tables combining strings, integers, and floats.
 * Common use: Data reports, console output, debugging information
 */
Example6_TableGenerator() {
    ; Employee performance data
    employees := [{
        id: 101, name: "Alice Johnson", dept: "Sales", sales: 125340.50, commission: 0.15 }, {
            id: 102, name: "Bob Smith", dept: "Marketing", sales: 98760.25, commission: 0.12 }, {
                id: 205, name: "Carol Williams", dept: "Sales", sales: 156890.75, commission: 0.15 }, {
                    id: 78, name: "David Brown", dept: "Support", sales: 45230.00, commission: 0.10 }, {
                        id: 315, name: "Eve Davis", dept: "Sales", sales: 201450.80, commission: 0.18
                    }
    ]

    output := "=== Example 6: Employee Performance Report ===`n`n"
    output .= Format("{:>4s} {:-20s} {:-12s} {:>12s} {:>8s} {:>12s}",
        "ID", "Name", "Department", "Sales", "Rate", "Commission") . "`n"
    output .= Format("{:-80s}", "") . "`n"

    totalSales := 0
    totalCommission := 0

    for emp in employees {
        commissionAmt := emp.sales * emp.commission
        totalSales += emp.sales
        totalCommission += commissionAmt

        output .= Format("{:>4d} {:-20s} {:-12s} ${:>11,.2f} {:>7.1%} ${:>11,.2f}",
            emp.id,
            emp.name,
            emp.dept,
            emp.sales,
            emp.commission,
            commissionAmt) . "`n"
    }

    output .= Format("{:-80s}", "") . "`n"
    output .= Format("{:>38s} ${:>11,.2f} {:>8s} ${:>11,.2f}",
        "TOTALS:",
        totalSales,
        "",
        totalCommission) . "`n"

    output .= "`n`nAverage Sales: " . Format("${:,.2f}", totalSales / employees.Length)
    output .= "`nTop Performer: " . Format("{:s} (${:,.2f})", employees[3].name, employees[3].sales)

    MsgBox(output, "Performance Report", 262144)  ; Width for better display
}

; ============================================================================
; Example 7: Progress Bar Using String Formatting
; ============================================================================

/**
 * Creates ASCII progress bars using Format() for alignment and padding.
 * Common use: Console applications, progress indicators, status displays
 */
Example7_ProgressBarFormatter() {
    output := "=== Example 7: Progress Bar Formatting ===`n`n"

    ; Function to create a progress bar
    CreateProgressBar(percentage, width := 40) {
        filled := Floor(percentage * width / 100)
        empty := width - filled
        bar := StrReplace(Format("{:" . filled . "s}", ""), " ", "█")
        bar .= StrReplace(Format("{:" . empty . "s}", ""), " ", "░")
        return Format("[{:s}] {:>6.2f}%", bar, percentage)
    }

    ; Simulate various progress levels
    tasks := [{
        name: "Downloading files", progress: 25.5 }, {
            name: "Processing data", progress: 67.8 }, {
                name: "Uploading results", progress: 92.3 }, {
                    name: "Finalizing", progress: 100.0 }, {
                        name: "Waiting to start", progress: 0.0
                    }
    ]

    for task in tasks {
        output .= Format("{:-25s} ", task.name)
        output .= CreateProgressBar(task.progress, 30)
        output .= "`n"
    }

    output .= "`n`nDisk Usage:`n"
    drives := [{
        letter: "C:", used: 234.5, total: 500 }, {
            letter: "D:", used: 789.2, total: 1000 }, {
                letter: "E:", used: 45.8, total: 250
            }
    ]

    for drive in drives {
        percentage := (drive.used / drive.total) * 100
        output .= Format("Drive {:s} ", drive.letter)
        output .= CreateProgressBar(percentage, 25)
        output .= Format(" ({:.1f}/{:.1f} GB)", drive.used, drive.total)
        output .= "`n"
    }

    MsgBox(output, "Progress Indicators", 262144)
}

; ============================================================================
; Main Menu
; ============================================================================

; Show menu to run examples
ShowMenu() {
    menu := "
                                                                    (
                                                                    Format() Function - Basic String Formatting

                                                                    Choose an example:

                                                                    1. Basic Number Padding
                                                                    2. Decimal Precision
                                                                    3. String Alignment
                                                                    4. Invoice Generator
                                                                    5. File Name Generator
                                                                    6. Table Generator
                                                                    7. Progress Bar Formatter

                                                                    Press 1-7 to run an example, or ESC to exit
                                                                    )"

    MsgBox(menu, "Format() Examples", 4096)
}

; Hotkeys to run examples
^1:: Example1_BasicNumberPadding()
^2:: Example2_DecimalPrecision()
^3:: Example3_StringAlignment()
^4:: Example4_InvoiceGenerator()
^5:: Example5_FileNameGenerator()
^6:: Example6_TableGenerator()
^7:: Example7_ProgressBarFormatter()
^m:: ShowMenu()

; Show menu on startup
ShowMenu()
