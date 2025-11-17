#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Format Function - Advanced Number Formatting and Numeric Conversions
 * ============================================================================
 *
 * This script demonstrates advanced number formatting including hexadecimal,
 * octal, binary representations, and currency formatting.
 *
 * @description Advanced numeric formatting with Format() function
 * @author AHK v2 Documentation Team
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Number Format Specifiers:
 * - {:d} or {:i} - Signed integer
 * - {:u} - Unsigned integer
 * - {:x} - Hexadecimal lowercase
 * - {:X} - Hexadecimal uppercase
 * - {:o} - Octal
 * - {:b} - Binary (via custom function)
 * - {:e} - Scientific notation lowercase
 * - {:E} - Scientific notation uppercase
 * - {:g} - General format (shortest representation)
 * - {:G} - General format uppercase
 */

; ============================================================================
; Example 1: Hexadecimal and Octal Formatting
; ============================================================================

/**
 * Demonstrates conversion between decimal, hexadecimal, and octal formats.
 * Common use: Memory addresses, color codes, file permissions
 */
Example1_HexOctalFormatting() {
    output := "=== Example 1: Hexadecimal and Octal Formatting ===`n`n"

    ; Color code conversions
    output .= "RGB Color Codes:`n"
    colors := Map(
        "Red", {r: 255, g: 0, b: 0},
        "Green", {r: 0, g: 255, b: 0},
        "Blue", {r: 0, g: 0, b: 255},
        "Purple", {r: 128, g: 0, b: 128},
        "Orange", {r: 255, g: 165, b: 0}
    )

    for colorName, rgb in colors {
        hex := Format("#{:02X}{:02X}{:02X}", rgb.r, rgb.g, rgb.b)
        dec := Format("rgb({:d}, {:d}, {:d})", rgb.r, rgb.g, rgb.b)
        output .= Format("{:-10s} {:s} = {:s}", colorName, hex, dec) . "`n"
    }

    ; Memory addresses
    output .= "`n`nMemory Addresses:`n"
    addresses := [0x1000, 0x2A5F, 0xFFFF, 0x12345, 0xDEADBEEF]
    for addr in addresses {
        output .= Format("Address: 0x{:08X} = {:10d} decimal", addr, addr) . "`n"
    }

    ; File permissions (Unix-style)
    output .= "`n`nFile Permissions (Octal):`n"
    permissions := Map(
        "rwxr-xr-x", 0o755,
        "rw-r--r--", 0o644,
        "rwx------", 0o700,
        "rw-rw-r--", 0o664
    )

    for perm, octal in permissions {
        output .= Format("{:-10s} = {:04o} (octal) = {:d} (decimal)", perm, octal, octal) . "`n"
    }

    MsgBox(output, "Hex/Octal Formatting", 262144)
}

; ============================================================================
; Example 2: Scientific Notation and Large Numbers
; ============================================================================

/**
 * Shows scientific notation formatting for very large or small numbers.
 * Common use: Scientific calculations, astronomical data, microscopic measurements
 */
Example2_ScientificNotation() {
    output := "=== Example 2: Scientific Notation ===`n`n"

    ; Astronomical distances
    output .= "Astronomical Distances:`n"
    distances := Map(
        "Earth to Moon", 384400000,
        "Earth to Sun", 149600000000,
        "Light Year", 9460730472580800,
        "Parsec", 30856775814913673
    )

    for name, meters in distances {
        output .= Format("{:-25s} {:e} m", name, meters) . "`n"
        output .= Format("{:>25s} {:E} m", "", meters) . "`n"
        output .= Format("{:>25s} {:.2e} m (2 decimals)", "", meters) . "`n`n"
    }

    ; Microscopic measurements
    output .= "Microscopic Measurements:`n"
    sizes := Map(
        "Virus", 0.00000001,
        "Bacteria", 0.000001,
        "Human Cell", 0.00001,
        "Grain of Sand", 0.001
    )

    for item, meters in sizes {
        output .= Format("{:-20s} {:.2e} m = {:.8f} m", item, meters, meters) . "`n"
    }

    ; Scientific constants
    output .= "`n`nScientific Constants:`n"
    constants := Map(
        "Speed of Light", 299792458,
        "Planck Constant", 6.62607015e-34,
        "Avogadro Number", 6.02214076e23,
        "Electron Mass", 9.1093837015e-31
    )

    for name, value in constants {
        output .= Format("{:-20s} {:.6e}", name, value) . "`n"
    }

    MsgBox(output, "Scientific Notation", 262144)
}

; ============================================================================
; Example 3: Currency Formatting with Locale Support
; ============================================================================

/**
 * Demonstrates currency formatting with thousand separators and symbols.
 * Common use: Financial reports, invoicing, price lists
 */
Example3_CurrencyFormatting() {
    output := "=== Example 3: Currency Formatting ===`n`n"

    ; Sales data
    sales := [
        {region: "North America", revenue: 1250000.50, expenses: 875000.25},
        {region: "Europe", revenue: 980000.75, expenses: 650000.00},
        {region: "Asia Pacific", revenue: 2150000.00, expenses: 1200000.50},
        {region: "South America", revenue: 450000.25, expenses: 325000.75}
    ]

    output .= Format("{:-20s} {:>15s} {:>15s} {:>15s}",
        "Region", "Revenue", "Expenses", "Profit") . "`n"
    output .= Format("{:-67s}", "") . "`n"

    totalRevenue := 0
    totalExpenses := 0

    for data in sales {
        profit := data.revenue - data.expenses
        totalRevenue += data.revenue
        totalExpenses += data.expenses

        output .= Format("{:-20s} ${:>14,.2f} ${:>14,.2f} ${:>14,.2f}",
            data.region,
            data.revenue,
            data.expenses,
            profit) . "`n"
    }

    totalProfit := totalRevenue - totalExpenses
    output .= Format("{:-67s}", "") . "`n"
    output .= Format("{:-20s} ${:>14,.2f} ${:>14,.2f} ${:>14,.2f}",
        "TOTAL",
        totalRevenue,
        totalExpenses,
        totalProfit) . "`n"

    ; Different currency formats
    output .= "`n`nMulti-Currency Display:`n"
    amount := 12345.67

    currencies := [
        {name: "US Dollar", symbol: "$", value: amount},
        {name: "Euro", symbol: "€", value: amount * 0.85},
        {name: "British Pound", symbol: "£", value: amount * 0.73},
        {name: "Japanese Yen", symbol: "¥", value: amount * 110.50},
        {name: "Swiss Franc", symbol: "CHF", value: amount * 0.92}
    ]

    for curr in currencies {
        if (curr.symbol = "¥") {
            ; Yen has no decimals
            output .= Format("{:-15s} {:s}{:>12,.0f}", curr.name, curr.symbol, curr.value) . "`n"
        } else {
            output .= Format("{:-15s} {:s}{:>12,.2f}", curr.name, curr.symbol, curr.value) . "`n"
        }
    }

    MsgBox(output, "Currency Formatting", 262144)
}

; ============================================================================
; Example 4: Binary Representation and Bit Manipulation
; ============================================================================

/**
 * Creates binary representations and demonstrates bit flags.
 * Common use: Permissions, flags, network protocols, low-level programming
 */
Example4_BinaryFormatting() {
    ; Helper function to convert to binary string
    ToBinary(num, width := 8) {
        binary := ""
        loop width {
            binary := (num & 1) . binary
            num >>= 1
        }
        return binary
    }

    output := "=== Example 4: Binary Formatting ===`n`n"

    ; Basic number conversions
    output .= "Number System Conversions:`n"
    numbers := [15, 42, 128, 255]

    output .= Format("{:>5s} {:>10s} {:>5s} {:>5s} {:>10s}",
        "Dec", "Binary", "Hex", "Oct", "Description") . "`n"
    output .= Format("{:-45s}", "") . "`n"

    for num in numbers {
        output .= Format("{:>5d} {:>10s} 0x{:>03X} {:>5o}",
            num,
            ToBinary(num, 8),
            num,
            num) . "`n"
    }

    ; File permissions flags
    output .= "`n`nFile Permission Flags:`n"
    READ := 0x01
    WRITE := 0x02
    EXECUTE := 0x04
    DELETE := 0x08

    permissions := [
        {name: "Read Only", flags: READ},
        {name: "Read/Write", flags: READ | WRITE},
        {name: "Full Access", flags: READ | WRITE | EXECUTE | DELETE},
        {name: "Execute Only", flags: EXECUTE}
    ]

    for perm in permissions {
        output .= Format("{:-20s} {:04b} = 0x{:02X} = {:d}",
            perm.name,
            perm.flags,
            perm.flags,
            perm.flags) . "`n"
        output .= Format("{:>20s} R:{:d} W:{:d} X:{:d} D:{:d}",
            "",
            !!(perm.flags & READ),
            !!(perm.flags & WRITE),
            !!(perm.flags & EXECUTE),
            !!(perm.flags & DELETE)) . "`n`n"
    }

    ; Network subnet masks
    output .= "Network Subnet Masks:`n"
    masks := [
        {cidr: 24, mask: 0xFFFFFF00},
        {cidr: 16, mask: 0xFFFF0000},
        {cidr: 8, mask: 0xFF000000}
    ]

    for m in masks {
        octet1 := (m.mask >> 24) & 0xFF
        octet2 := (m.mask >> 16) & 0xFF
        octet3 := (m.mask >> 8) & 0xFF
        octet4 := m.mask & 0xFF

        output .= Format("/{:d} = {:d}.{:d}.{:d}.{:d} = 0x{:08X}",
            m.cidr, octet1, octet2, octet3, octet4, m.mask) . "`n"
    }

    MsgBox(output, "Binary Formatting", 262144)
}

; ============================================================================
; Example 5: Percentage and Ratio Formatting
; ============================================================================

/**
 * Shows formatting for percentages, ratios, and proportions.
 * Common use: Statistics, analytics, progress tracking
 */
Example5_PercentageFormatting() {
    output := "=== Example 5: Percentage and Ratio Formatting ===`n`n"

    ; Sales conversion funnel
    output .= "Sales Conversion Funnel:`n"
    funnel := [
        {stage: "Website Visitors", count: 10000},
        {stage: "Product Page Views", count: 5500},
        {stage: "Add to Cart", count: 1200},
        {stage: "Checkout Started", count: 800},
        {stage: "Purchase Completed", count: 650}
    ]

    output .= Format("{:-25s} {:>10s} {:>15s} {:>12s}",
        "Stage", "Count", "Conversion", "Drop-off") . "`n"
    output .= Format("{:-65s}", "") . "`n"

    for i, stage in funnel {
        if (i = 1) {
            output .= Format("{:-25s} {:>10d} {:>15s} {:>12s}",
                stage.stage,
                stage.count,
                "100.00%",
                "-") . "`n"
        } else {
            conversion := (stage.count / funnel[1].count) * 100
            dropoff := ((funnel[i-1].count - stage.count) / funnel[i-1].count) * 100

            output .= Format("{:-25s} {:>10d} {:>14.2f}% {:>11.2f}%",
                stage.stage,
                stage.count,
                conversion,
                dropoff) . "`n"
        }
    }

    ; Budget allocation
    output .= "`n`nBudget Allocation:`n"
    totalBudget := 500000
    allocations := [
        {dept: "Engineering", amount: 200000},
        {dept: "Marketing", amount: 125000},
        {dept: "Sales", amount: 100000},
        {dept: "Operations", amount: 50000},
        {dept: "Other", amount: 25000}
    ]

    for alloc in allocations {
        percentage := (alloc.amount / totalBudget) * 100
        bar := StrReplace(Format("{:" . Round(percentage / 2) . "s}", ""), " ", "█")

        output .= Format("{:-15s} ${:>10,.2f} {:>6.2f}% {:s}",
            alloc.dept,
            alloc.amount,
            percentage,
            bar) . "`n"
    }

    ; Grade distribution
    output .= "`n`nGrade Distribution:`n"
    grades := Map("A", 25, "B", 45, "C", 60, "D", 15, "F", 5)
    totalStudents := 0

    for grade, count in grades
        totalStudents += count

    for grade, count in grades {
        percentage := (count / totalStudents) * 100
        output .= Format("Grade {:s}: {:>3d} students ({:>5.1f}%)",
            grade, count, percentage) . "`n"
    }

    MsgBox(output, "Percentage Formatting", 262144)
}

; ============================================================================
; Example 6: Custom Number Formatting Functions
; ============================================================================

/**
 * Demonstrates custom formatting functions for specialized needs.
 * Common use: File sizes, time duration, custom units
 */
Example6_CustomFormatting() {
    ; Format bytes to human-readable size
    FormatBytes(bytes) {
        units := ["B", "KB", "MB", "GB", "TB"]
        index := 1
        value := bytes

        while (value >= 1024 && index < units.Length) {
            value /= 1024
            index++
        }

        if (index = 1)
            return Format("{:d} {:s}", value, units[index])
        else
            return Format("{:.2f} {:s}", value, units[index])
    }

    ; Format seconds to time duration
    FormatDuration(seconds) {
        days := Floor(seconds / 86400)
        hours := Floor(Mod(seconds, 86400) / 3600)
        mins := Floor(Mod(seconds, 3600) / 60)
        secs := Mod(seconds, 60)

        if (days > 0)
            return Format("{:d}d {:d}h {:d}m {:d}s", days, hours, mins, secs)
        else if (hours > 0)
            return Format("{:d}h {:d}m {:d}s", hours, mins, secs)
        else if (mins > 0)
            return Format("{:d}m {:d}s", mins, secs)
        else
            return Format("{:d}s", secs)
    }

    output := "=== Example 6: Custom Formatting ===`n`n"

    ; File sizes
    output .= "File Size Formatting:`n"
    fileSizes := [
        {name: "document.txt", bytes: 1024},
        {name: "photo.jpg", bytes: 2548576},
        {name: "video.mp4", bytes: 1073741824},
        {name: "archive.zip", bytes: 5368709120}
    ]

    for file in fileSizes {
        output .= Format("{:-20s} {:>15s} ({:>12,d} bytes)",
            file.name,
            FormatBytes(file.bytes),
            file.bytes) . "`n"
    }

    ; Time durations
    output .= "`n`nDuration Formatting:`n"
    durations := [
        {task: "Quick task", seconds: 45},
        {task: "Medium task", seconds: 3665},
        {task: "Long task", seconds: 86400},
        {task: "Very long task", seconds: 259200}
    ]

    for task in durations {
        output .= Format("{:-20s} {:>20s} ({:>8,d} seconds)",
            task.task,
            FormatDuration(task.seconds),
            task.seconds) . "`n"
    }

    ; Number with custom units
    output .= "`n`nCustom Unit Formatting:`n"
    measurements := [
        {item: "Distance", value: 15.5, unit: "km"},
        {item: "Weight", value: 72.3, unit: "kg"},
        {item: "Temperature", value: 23.5, unit: "°C"},
        {item: "Pressure", value: 1013.25, unit: "hPa"}
    ]

    for m in measurements {
        output .= Format("{:-15s} {:>8.2f} {:s}", m.item, m.value, m.unit) . "`n"
    }

    MsgBox(output, "Custom Formatting", 262144)
}

; ============================================================================
; Example 7: Data Export Formatting
; ============================================================================

/**
 * Shows formatting for various data export formats (CSV, TSV, fixed-width).
 * Common use: Data export, reporting, integration with other tools
 */
Example7_DataExportFormatting() {
    ; Sample data
    records := [
        {id: 1, name: "Alice Johnson", email: "alice@example.com", score: 95.5},
        {id: 2, name: "Bob Smith", email: "bob@example.com", score: 87.3},
        {id: 3, name: "Carol White", email: "carol@example.com", score: 92.8},
        {id: 4, name: "David Brown", email: "david@example.com", score: 88.1}
    ]

    output := "=== Example 7: Data Export Formatting ===`n`n"

    ; CSV format
    output .= "CSV Format:`n"
    output .= "ID,Name,Email,Score`n"
    for rec in records {
        output .= Format("{:d},""{:s}"",""{:s}"",{:.2f}",
            rec.id, rec.name, rec.email, rec.score) . "`n"
    }

    ; Fixed-width format
    output .= "`n`nFixed-Width Format:`n"
    output .= Format("{:>4s} {:-20s} {:-25s} {:>6s}",
        "ID", "Name", "Email", "Score") . "`n"

    for rec in records {
        output .= Format("{:>4d} {:-20s} {:-25s} {:>6.2f}",
            rec.id, rec.name, rec.email, rec.score) . "`n"
    }

    ; Tab-separated values
    output .= "`n`nTab-Separated Values:`n"
    output .= "ID`tName`tEmail`tScore`n"
    for rec in records {
        output .= Format("{:d}`t{:s}`t{:s}`t{:.2f}",
            rec.id, rec.name, rec.email, rec.score) . "`n"
    }

    MsgBox(output, "Data Export Formatting", 262144)
}

; ============================================================================
; Main Menu and Hotkeys
; ============================================================================

ShowMenu() {
    menu := "
    (
    Format() Function - Advanced Number Formatting

    Choose an example:

    1. Hexadecimal and Octal Formatting
    2. Scientific Notation
    3. Currency Formatting
    4. Binary Formatting
    5. Percentage Formatting
    6. Custom Formatting
    7. Data Export Formatting

    Press Ctrl+1-7 to run examples
    )"

    MsgBox(menu, "Format() Advanced Examples", 4096)
}

^1::Example1_HexOctalFormatting()
^2::Example2_ScientificNotation()
^3::Example3_CurrencyFormatting()
^4::Example4_BinaryFormatting()
^5::Example5_PercentageFormatting()
^6::Example6_CustomFormatting()
^7::Example7_DataExportFormatting()
^m::ShowMenu()

ShowMenu()
