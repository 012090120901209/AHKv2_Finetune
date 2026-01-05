#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * Format Function - Printf-Style Templates and Advanced Formatting
 * ============================================================================
 * 
 * This script demonstrates printf-style format strings, positional arguments,
 * and template-based formatting for complex output generation.
 * 
 * @description Printf-style formatting with Format() function
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Advanced Features:
 * - Positional arguments: {1}, {2}, {3}
 * - Argument reuse: {1:d}, {1:x}, {1:o}
 * - Width and precision: {1:10.2f}
 * - Zero-padding: {1:05d}
 * - Sign display: {1:+d}
 * - Space padding: {1: d}
 * - Left/right alignment: {1:-10s}, {1:>10s}
 * - Center alignment: {1:^10s}
 */

; ============================================================================
; Example 1: Positional Arguments and Argument Reuse
; ============================================================================

/**
 * Demonstrates using positional arguments to reference format arguments.
 * Common use: Templates where same value appears multiple times
 */
Example1_PositionalArguments() {
    output := "=== Example 1: Positional Arguments ===`n`n"

    ; Basic positional arguments
    name := "Alice"
    age := 30
    city := "New York"

    output .= "Basic Positional Usage:`n"
    output .= Format("Name: {1}, Age: {2}, City: {3}", name, age, city) . "`n"
    output .= Format("Hello {1}, you are {2} years old and live in {3}!", name, age, city) . "`n"
    output .= Format("{3} resident {1} is {2} years old", name, age, city) . "`n`n"

    ; Argument reuse - same value in different formats
    output .= "Argument Reuse (Multiple Formats):`n"
    value := 255

    output .= Format("Decimal: {1:d}, Hex: {1:02X}, Octal: {1:o}", value) . "`n"

    colorValue := 0xFF5733
    output .= Format("Color: #{1:06X} = Red:{2:d} Green:{3:d} Blue:{4:d}",
        colorValue,
        (colorValue >> 16) & 0xFF,
        (colorValue >> 8) & 0xFF,
        colorValue & 0xFF) . "`n`n"

    ; Template with repeated values
    output .= "Template with Repeated Values:`n"
    productName := "SuperWidget Pro"
    price := 299.99

    template := "
    (
    ╔══════════════════════════════════════╗
    ║  {1:^36s}  ║
    ╠══════════════════════════════════════╣
    ║  Regular Price:   ${2:>16.2f}  ║
    ║  Sale Price:      ${3:>16.2f}  ║
    ║  You Save:        ${4:>16.2f}  ║
    ║                                      ║
    ║  Savings:         {5:>15.1f}%  ║
    ╚══════════════════════════════════════╝
    )"

    salePrice := price * 0.80
    savings := price - salePrice
    savingsPercent := (savings / price) * 100

    output .= Format(template, productName, price, salePrice, savings, savingsPercent)

    MsgBox(output, "Positional Arguments", 262144)
}

; ============================================================================
; Example 2: Dynamic Report Templates
; ============================================================================

/**
 * Creates reusable report templates with Format() placeholders.
 * Common use: Automated reporting, email templates, document generation
 */
Example2_ReportTemplates() {
    ; Daily sales report template
    dailySalesTemplate := "
    (
    ╔══════════════════════════════════════════════════════════╗
    ║            DAILY SALES REPORT - {1:s}              ║
    ╠══════════════════════════════════════════════════════════╣
    ║                                                          ║
    ║  Store: {2:-45s}      ║
    ║  Manager: {3:-43s}      ║
    ║                                                          ║
    ╠══════════════════════════════════════════════════════════╣
    ║  Transactions:              {4:>25,d}  ║
    ║  Gross Sales:               ${5:>24,.2f}  ║
    ║  Returns:                   ${6:>24,.2f}  ║
    ║  Net Sales:                 ${7:>24,.2f}  ║
    ║                                                          ║
    ║  Average Transaction:       ${8:>24,.2f}  ║
    ║  Largest Sale:              ${9:>24,.2f}  ║
    ║                                                          ║
    ║  Target:                    ${10:>24,.2f}  ║
    ║  Achievement:               {11:>24.1f}%  ║
    ║  Status: {12:-47s}      ║
    ╚══════════════════════════════════════════════════════════╝
    )"

    ; Generate report for different stores
    stores := [{
        date: "2024-01-15",
        name: "Downtown Store",
        manager: "John Smith",
        transactions: 342,
        grossSales: 45678.90,
        returns: 2345.50,
        target: 40000
    }, {
        date: "2024-01-15",
        name: "Mall Location",
        manager: "Sarah Johnson",
        transactions: 567,
        grossSales: 67890.25,
        returns: 1234.75,
        target: 60000
    }
    ]

    output := "=== Example 2: Report Templates ===`n`n"

    for store in stores {
        netSales := store.grossSales - store.returns
        avgTransaction := netSales / store.transactions
        achievement := (netSales / store.target) * 100
        status := achievement >= 100 ? "✓ TARGET ACHIEVED" : "⚠ BELOW TARGET"

        ; Find largest sale (simulated)
        largestSale := store.grossSales / store.transactions * 2.5

        report := Format(dailySalesTemplate,
            store.date,
            store.name,
            store.manager,
            store.transactions,
            store.grossSales,
            store.returns,
            netSales,
            avgTransaction,
            largestSale,
            store.target,
            achievement,
            status)

        output .= report . "`n`n"
    }

    MsgBox(output, "Report Templates", 262144)
}

; ============================================================================
; Example 3: Email and Notification Templates
; ============================================================================

/**
 * Demonstrates formatting email templates and notifications.
 * Common use: Automated emails, alerts, user communications
 */
Example3_EmailTemplates() {
    ; Order confirmation template
    orderConfirmTemplate := "
    (
    Subject: Order Confirmation - Order #{1:06d}

    Dear {2:s},

    Thank you for your order! Your order has been confirmed.

    Order Details:
    ──────────────────────────────────────────────
    Order Number:     {1:06d}
    Order Date:       {3:s}
    Estimated Delivery: {4:s}

    Items Ordered:
    {
        5:s
    }

    ──────────────────────────────────────────────
    Subtotal:         ${6:>10,.2f}
    Shipping:         ${7:>10,.2f}
    Tax:              ${8:>10,.2f}
    ──────────────────────────────────────────────
    Total:            ${9:>10,.2f}

    Shipping Address:
    {
        10:s
    }

    Track your order: www.example.com/track/{1:06d}

    Questions? Contact us at support@example.com

    Best regards,
    The Sales Team
    )"

    ; Create sample order
    orderNum := 12345
    customerName := "Jane Doe"
    orderDate := "January 15, 2024"
    deliveryDate := "January 20, 2024"

    items := ""
    items .= Format("  {1:-30s} x{2:d}  ${3:>8,.2f}`n", "SuperWidget Pro", 2, 299.99)
    items .= Format("  {1:-30s} x{2:d}  ${3:>8,.2f}`n", "Premium Cable", 1, 29.99)
    items .= Format("  {1:-30s} x{2:d}  ${3:>8,.2f}", "Extended Warranty", 1, 49.99)

    subtotal := 679.96
    shipping := 15.00
    tax := subtotal * 0.085
    total := subtotal + shipping + tax

    address := "Jane Doe`n123 Main Street`nApt 4B`nNew York, NY 10001"

    email := Format(orderConfirmTemplate,
        orderNum,
        customerName,
        orderDate,
        deliveryDate,
        items,
        subtotal,
        shipping,
        tax,
        total,
        address)

    ; Password reset template
    resetTemplate := "
    (
    Subject: Password Reset Request

    Hello {1:s},

    We received a request to reset your password for your account.

    Username: {2:s}
    Email: {3:s}
    Request Time: {4:s}

    If you requested this change, use this code:

    Reset Code: {5:06d}
    Expires in: {6:d} minutes

    If you didn't request this, please ignore this email.
    Your password will remain unchanged.

    Security tip: Never share your reset code with anyone.

    Best regards,
    Security Team
    )"

    resetEmail := Format(resetTemplate,
        "John Smith",
        "jsmith42",
        "john.smith@example.com",
        "2024-01-15 14:30:22",
        873245,
        30)

    output := "=== Example 3: Email Templates ===`n`n"
    output .= email . "`n`n"
    output .= "═══════════════════════════════════════════════`n`n"
    output .= resetEmail

    MsgBox(output, "Email Templates", 262144)
}

; ============================================================================
; Example 4: Log Message Formatting
; ============================================================================

/**
 * Shows consistent log message formatting with severity levels.
 * Common use: Application logging, debugging, audit trails
 */
Example4_LogFormatting() {
    ; Log message template
    FormatLogMessage(level, timestamp, component, message, details := "") {
        icons := Map(
            "DEBUG", "🔍",
            "INFO", "ℹ️",
            "WARN", "⚠️",
            "ERROR", "❌",
            "CRITICAL", "🔥"
        )

        icon := icons.Has(level) ? icons[level] : "•"
        baseMsg := Format("[{1:s}] {2:s} {3:-8s} | {4:-15s} | {5:s}",
            timestamp,
            icon,
            level,
            component,
            message)

        if (details != "")
            return baseMsg . "`n" . Format("{:>50s} {1:s}", "Details: ", details)
        return baseMsg
    }

    output := "=== Example 4: Log Message Formatting ===`n`n"

    ; Simulate log entries
    logs := [{
        level: "INFO", time: "2024-01-15 10:23:45", component: "Application", msg: "Application started successfully", details: "" }, {
            level: "DEBUG", time: "2024-01-15 10:23:46", component: "Database", msg: "Connection pool initialized", details: "Pool size: 10, Timeout: 30s" }, {
                level: "INFO", time: "2024-01-15 10:24:12", component: "API", msg: "Request processed", details: "Endpoint: /api/users, Method: GET, Status: 200" }, {
                    level: "WARN", time: "2024-01-15 10:24:45", component: "Cache", msg: "Cache miss rate high", details: "Miss rate: 45%, Threshold: 30%" }, {
                        level: "ERROR", time: "2024-01-15 10:25:03", component: "FileSystem", msg: "Failed to write file", details: "Path: /data/temp.log, Error: Permission denied" }, {
                            level: "CRITICAL", time: "2024-01-15 10:25:15", component: "Security", msg: "Multiple failed login attempts", details: "User: admin, Attempts: 5, IP: 192.168.1.100"
                        }
    ]

    for log in logs {
        output .= FormatLogMessage(log.level, log.time, log.component, log.msg, log.details) . "`n"
    }

    ; Summary statistics
    output .= "`n" . Format("{:-80s}", "") . "`n"
    output .= Format("Total entries: {:d} | Errors: {:d} | Warnings: {:d}",
        logs.Length,
        2,
        1) . "`n"

    MsgBox(output, "Log Formatting", 262144)
}

; ============================================================================
; Example 5: Configuration File Generation
; ============================================================================

/**
 * Generates formatted configuration files (INI, YAML-style, JSON-like).
 * Common use: Config generation, settings export, deployment scripts
 */
Example5_ConfigFileGeneration() {
    output := "=== Example 5: Configuration File Generation ===`n`n"

    ; Application configuration
    appName := "MyApplication"
    version := "2.5.0"
    port := 8080
    maxConnections := 1000
    timeout := 30
    debug := true
    logLevel := "INFO"

    ; INI-style configuration
    iniConfig := "
                        (
                        ; {1:s} Configuration File
                        ; Version: {2:s}
                        ; Generated: {3:s}

                        [Application]
                        Name = {1:s}
                        Version = {2:s}
                        Environment = production

                        [Server]
                        Port = {4:d}
                        Host = 0.0.0.0
                        MaxConnections = {5:d}
                        Timeout = {6:d}

                        [Logging]
                        Level = {7:s}
                        Debug = {8:s}
                        LogFile = logs/app_{9:s}.log

                        [Database]
                        Host = localhost
                        Port = 5432
                        Name = myapp_db
                        PoolSize = {10:d}
                        )"

    output .= "INI-Style Configuration:`n"
    output .= Format(iniConfig,
        appName,
        version,
        "2024-01-15 10:30:00",
        port,
        maxConnections,
        timeout,
        logLevel,
        debug ? "true" : "false",
        "20240115",
        20)

    ; YAML-style configuration
    yamlConfig := "
                        (
                        `n`nYAML-Style Configuration:
                        # {1:s} Configuration
                        # Version: {2:s}

                        application:
                        name: {1:s}
                        version: {2:s}
                        port: {3:d}

                        server:
                        maxConnections: {4:d}
                        timeout: {5:d}
                        debug: {6:s}

                        logging:
                        level: {7:s}
                        format: json
                        rotation:
                        maxSize: 100MB
                        maxFiles: {8:d}
                        )"

    output .= Format(yamlConfig,
        appName,
        version,
        port,
        maxConnections,
        timeout,
        debug ? "true" : "false",
        logLevel,
        10)

    MsgBox(output, "Config File Generation", 262144)
}

; ============================================================================
; Example 6: Table and Grid Formatting
; ============================================================================

/**
 * Creates complex formatted tables with borders and alignment.
 * Common use: Console output, reports, data visualization
 */
Example6_TableFormatting() {
    ; Create a boxed table
    CreateTable(title, headers, rows) {
        ; Calculate column widths
        colWidths := []
        for header in headers
            colWidths.Push(StrLen(header))

        for row in rows {
            for i, cell in row {
                if (StrLen(String(cell)) > colWidths[i])
                    colWidths[i] := StrLen(String(cell))
            }
        }

        ; Create table
        totalWidth := 0
        for width in colWidths
            totalWidth += width + 3  ; +3 for " | "
        totalWidth += 1  ; Final border

        table := ""
        table .= "╔" . StrReplace(Format("{:" . totalWidth . "s}", ""), " ", "═") . "╗`n"
        table .= "║" . Format("{:^" . totalWidth . "s}", title) . "║`n"
        table .= "╠" . StrReplace(Format("{:" . totalWidth . "s}", ""), " ", "═") . "╣`n"

        ; Headers
        table .= "║ "
        for i, header in headers {
            table .= Format("{:-" . colWidths[i] . "s}", header)
            if (i < headers.Length)
                table .= " | "
        }
        table .= " ║`n"
        table .= "╠" . StrReplace(Format("{:" . totalWidth . "s}", ""), " ", "═") . "╣`n"

        ; Rows
        for row in rows {
            table .= "║ "
            for i, cell in row {
                if (IsNumber(cell))
                    table .= Format("{:>" . colWidths[i] . ".2f}", cell)
                else
                    table .= Format("{:-" . colWidths[i] . "s}", cell)

                if (i < row.Length)
                    table .= " | "
            }
            table .= " ║`n"
        }

        table .= "╚" . StrReplace(Format("{:" . totalWidth . "s}", ""), " ", "═") . "╝"
        return table
    }

    ; Sales data
    headers := ["Region", "Q1", "Q2", "Q3", "Q4", "Total"]
    rows := [
        ["North", 125000, 138000, 142000, 155000, 560000],
        ["South", 98000, 105000, 112000, 120000, 435000],
        ["East", 156000, 162000, 171000, 178000, 667000],
        ["West", 134000, 128000, 145000, 152000, 559000]
    ]

    output := "=== Example 6: Table Formatting ===`n`n"
    output .= CreateTable("Quarterly Sales Report 2024", headers, rows)

    MsgBox(output, "Table Formatting", 262144)
}

; ============================================================================
; Example 7: Multi-Language Template System
; ============================================================================

/**
 * Demonstrates template system for multi-language support.
 * Common use: Internationalization, localization, multi-language apps
 */
Example7_MultiLanguageTemplates() {
    ; Template definitions
    templates := Map(
        "en", Map(
            "welcome", "Welcome, {1:s}!",
            "balance", "Your account balance is ${1:,.2f}",
            "transaction", "Transaction #{1:06d} - {2:s}: ${3:,.2f}",
            "date", "{1:s} {2:02d}, {3:d}"
        ),
        "es", Map(
            "welcome", "¡Bienvenido, {1:s}!",
            "balance", "El saldo de su cuenta es ${1:,.2f}",
            "transaction", "Transacción #{1:06d} - {2:s}: ${3:,.2f}",
            "date", "{2:02d} de {1:s} de {3:d}"
        ),
        "fr", Map(
            "welcome", "Bienvenue, {1:s}!",
            "balance", "Le solde de votre compte est de ${1:,.2f}",
            "transaction", "Transaction #{1:06d} - {2:s}: ${3:,.2f}",
            "date", "{2:02d} {1:s} {3:d}"
        )
    )

    output := "=== Example 7: Multi-Language Templates ===`n`n"

    userName := "Maria Garcia"
    balance := 5432.50
    transId := 98765
    transType := "Deposit"
    amount := 250.00
    month := "January"
    day := 15
    year := 2024

    ; Generate for each language
    for lang, strings in templates {
        langName := Map("en", "English", "es", "Spanish", "fr", "French")[lang]
        output .= Format("--- {1:s} ({2:s}) ---", langName, StrUpper(lang)) . "`n"

        output .= Format(strings["welcome"], userName) . "`n"
        output .= Format(strings["balance"], balance) . "`n"
        output .= Format(strings["transaction"], transId, transType, amount) . "`n"
        output .= Format(strings["date"], month, day, year) . "`n`n"
    }

    MsgBox(output, "Multi-Language Templates", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
                        (
                        Format() - Printf-Style Templates

                        Examples:
                        1. Positional Arguments
                        2. Report Templates
                        3. Email Templates
                        4. Log Formatting
                        5. Config File Generation
                        6. Table Formatting
                        7. Multi-Language Templates

                        Press Ctrl+1-7 to run examples
                        )"
    MsgBox(menu, "Format Templates", 4096)
}

^1:: Example1_PositionalArguments()
^2:: Example2_ReportTemplates()
^3:: Example3_EmailTemplates()
^4:: Example4_LogFormatting()
^5:: Example5_ConfigFileGeneration()
^6:: Example6_TableFormatting()
^7:: Example7_MultiLanguageTemplates()
^m:: ShowMenu()

ShowMenu()
