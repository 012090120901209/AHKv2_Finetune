#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Round_03_DataFormatting.ahk
 * 
 * DESCRIPTION:
 * Data formatting applications of Round() for display formatting,
 * percentage rounding, statistics display, and report generation
 * 
 * FEATURES:
 * - Display value formatting and alignment
 * - Percentage calculations and rounding
 * - Statistical data presentation
 * - Report and table formatting
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Round.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Round() combined with Format()
 * - Data presentation techniques
 * - Array and object manipulation
 * - String formatting for reports
 * 
 * LEARNING POINTS:
 * 1. Round before displaying to users
 * 2. Consistent precision improves readability
 * 3. Percentages typically use 1-2 decimal places
 * 4. Statistical displays need appropriate precision
 * 5. Formatting enhances data comprehension
 */

; ============================================================
; Example 1: Display Value Formatter
; ============================================================

/**
 * Format number for display with automatic precision
 * 
 * @param {Number} value - Value to format
 * @param {String} label - Label for the value
 * @param {Number} precision - Decimal places (auto if not specified)
 * @returns {String} - Formatted display string
 */
FormatForDisplay(value, label := "", precision := -1) {
    ; Auto-determine precision based on magnitude
    if (precision = -1) {
        absValue := Abs(value)
        if (absValue >= 1000)
            precision := 0
        else if (absValue >= 10)
            precision := 1
        else if (absValue >= 1)
            precision := 2
        else
            precision := 3
    }

    rounded := Round(value, precision)
    formatted := Format("{1:." precision "f}", rounded)

    if (label != "")
        return label . ": " . formatted
    else
        return formatted
}

; Test display formatting
testValues := [{
    val: 1234.5678, label: "Large" }, {
        val: 123.456, label: "Medium" }, {
            val: 12.3456, label: "Small" }, {
                val: 1.23456, label: "Tiny" }, {
                    val: 0.123456, label: "Very Small"
                }
]

output := "Automatic Display Formatting:`n`n"

for item in testValues {
    output .= FormatForDisplay(item.val, item.label) "`n"
}

output .= "`nPrecision automatically adjusted by magnitude"

MsgBox(output, "Display Formatter", "Icon!")

; ============================================================
; Example 2: Percentage Formatting
; ============================================================

/**
 * Calculate and format percentage
 * 
 * @param {Number} part - Part value
 * @param {Number} whole - Whole value
 * @param {Number} decimals - Decimal places for percentage (default: 1)
 * @returns {Object} - Percentage data
 */
CalculatePercentage(part, whole, decimals := 1) {
    if (whole = 0)
        return { value: 0, formatted: "0%", part: part, whole: whole }

    percentValue := (part / whole) * 100
    rounded := Round(percentValue, decimals)
    formatted := Format("{1:." decimals "f}%", rounded)

    return {
        value: rounded,
        formatted: formatted,
        part: part,
        whole: whole
    }
}

/**
 * Create percentage breakdown
 * 
 * @param {Array} items - Array of {name, value} objects
 * @returns {Array} - Percentage breakdown
 */
CreatePercentageBreakdown(items) {
    total := 0
    for item in items
        total += item.value

    breakdown := []
    for item in items {
        pct := CalculatePercentage(item.value, total, 1)
        breakdown.Push({
            name: item.name,
            value: item.value,
            percentage: pct.value,
            formatted: pct.formatted
        })
    }

    return { items: breakdown, total: total }
}

; Sales by region example
salesData := [{
    name: "North", value: 45000 }, {
        name: "South", value: 38000 }, {
            name: "East", value: 52000 }, {
                name: "West", value: 41000
            }
]

breakdown := CreatePercentageBreakdown(salesData)

output := "Sales by Region (Percentages):`n`n"

for item in breakdown.items {
    output .= Format("{1}: ${2:,} ({3})`n",
        item.name, item.value, item.formatted)
}

output .= Format("`nTotal: ${1:,}", breakdown.total)

MsgBox(output, "Percentage Breakdown", "Icon!")

; ============================================================
; Example 3: Statistical Summary Formatting
; ============================================================

/**
 * Calculate and format statistical summary
 * 
 * @param {Array} data - Array of numbers
 * @returns {Object} - Statistical summary
 */
FormatStatistics(data) {
    if (data.Length = 0)
        return { error: "No data" }

    ; Calculate statistics
    sum := 0
    min := data[1]
    max := data[1]

    for value in data {
        sum += value
        if (value < min)
            min := value
        if (value > max)
            max := value
    }

    mean := sum / data.Length

    ; Calculate standard deviation
    sumSquaredDiff := 0
    for value in data
        sumSquaredDiff += (value - mean) ** 2
    variance := sumSquaredDiff / data.Length
    stdDev := Sqrt(variance)

    ; Round to appropriate precision
    return {
        count: data.Length,
        sum: Round(sum, 2),
        mean: Round(mean, 2),
        min: Round(min, 2),
        max: Round(max, 2),
        range: Round(max - min, 2),
        variance: Round(variance, 2),
        stdDev: Round(stdDev, 2)
    }
}

/**
 * Format statistics as readable report
 */
FormatStatsReport(stats) {
    report := "Statistical Summary:`n"
    report .= "═══════════════════════════`n"
    report .= Format("Count:      {1}`n", stats.count)
    report .= Format("Sum:        {1:.2f}`n", stats.sum)
    report .= Format("Mean:       {1:.2f}`n", stats.mean)
    report .= Format("Min:        {1:.2f}`n", stats.min)
    report .= Format("Max:        {1:.2f}`n", stats.max)
    report .= Format("Range:      {1:.2f}`n", stats.range)
    report .= Format("Std Dev:    {1:.2f}`n", stats.stdDev)
    report .= Format("Variance:   {1:.2f}", stats.variance)
    return report
}

; Test data
testScores := [85, 92, 78, 95, 88, 76, 91, 83, 89, 94]
stats := FormatStatistics(testScores)

output := "Test Scores: "
for score in testScores
    output .= score " "
output .= "`n`n" . FormatStatsReport(stats)

MsgBox(output, "Statistics Report", "Icon!")

; ============================================================
; Example 4: Progress and Completion Rates
; ============================================================

/**
 * Calculate progress metrics
 * 
 * @param {Number} completed - Completed items
 * @param {Number} total - Total items
 * @returns {Object} - Progress data
 */
CalculateProgress(completed, total) {
    if (total = 0)
        return { percent: 0, remaining: 0, formatted: "0%" }

    percentComplete := Round((completed / total) * 100, 1)
    remaining := total - completed
    percentRemaining := Round((remaining / total) * 100, 1)

    ; Create progress bar
    barLength := 20
    filledLength := Round((completed / total) * barLength, 0)
    bar := ""
    Loop barLength {
        bar .= A_Index <= filledLength ? "█" : "░"
    }

    return {
        completed: completed,
        total: total,
        remaining: remaining,
        percentComplete: percentComplete,
        percentRemaining: percentRemaining,
        formattedPercent: Format("{1:.1f}%", percentComplete),
        progressBar: bar
    }
}

; Project tasks example
projects := [{
    name: "Website Redesign", done: 47, total: 50 }, {
        name: "Mobile App", done: 23, total: 100 }, {
            name: "Database Migration", done: 88, total: 90 }, {
                name: "Documentation", done: 15, total: 75
            }
]

output := "Project Progress Report:`n`n"

for project in projects {
    progress := CalculateProgress(project.done, project.total)

    output .= project.name . "`n"
    output .= "  " . progress.progressBar . " " . progress.formattedPercent . "`n"
    output .= Format("  {1}/{2} tasks complete, {3} remaining`n`n",
        progress.completed, progress.total, progress.remaining)
}

MsgBox(output, "Progress Tracker", "Icon!")

; ============================================================
; Example 5: Data Table Formatter
; ============================================================

/**
 * Format data as aligned table
 * 
 * @param {Array} data - Array of objects with consistent keys
 * @param {Object} columns - Column configuration
 * @returns {String} - Formatted table
 */
FormatDataTable(data, columns) {
    if (data.Length = 0)
        return "No data"

    ; Build header
    table := ""
    for colName, config in columns {
        table .= Format("{1:" config.width "}", config.header)
    }
    table .= "`n"

    ; Add separator
    for colName, config in columns {
        table .= StrRepeat("─", config.width)
    }
    table .= "`n"

    ; Add data rows
    for row in data {
        for colName, config in columns {
            value := row.HasOwnProp(colName) ? row.%colName% : ""

            ; Format based on type
            if (config.HasOwnProp("decimals")) {
                rounded := Round(value, config.decimals)
                formatted := Format("{1:." config.decimals "f}", rounded)
            } else {
                formatted := String(value)
            }

            table .= Format("{1:" config.width "}", formatted)
        }
        table .= "`n"
    }

    return table
}

StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

; Sales performance data
performanceData := [{
    name: "Alice", sales: 125750.50, quota: 120000, commission: 6287.53 }, {
        name: "Bob", sales: 98250.75, quota: 100000, commission: 4912.54 }, {
            name: "Carol", sales: 142500.25, quota: 130000, commission: 7125.01 }, {
                name: "David", sales: 88900.00, quota: 90000, commission: 4445.00
            }
]

; Define columns with formatting
columnConfig := Map(
    "name", { header: "Name", width: 12 },
    "sales", { header: "Sales", width: 12, decimals: 2 },
    "quota", { header: "Quota", width: 12, decimals: 0 },
    "commission", { header: "Commission", width: 12, decimals: 2 }
)

table := FormatDataTable(performanceData, columnConfig)

output := "Sales Performance Report`n`n" . table

; Add totals
totalSales := 0
totalCommission := 0
for row in performanceData {
    totalSales += row.sales
    totalCommission += row.commission
}

output .= StrRepeat("─", 48) . "`n"
output .= Format("TOTALS{1:>6}{2:12.2f}{3:24.2f}",
    "", Round(totalSales, 2), Round(totalCommission, 2))

MsgBox(output, "Performance Table", "Icon!")

; ============================================================
; Example 6: Scientific Notation Formatter
; ============================================================

/**
 * Format number with appropriate scientific notation
 * 
 * @param {Number} value - Value to format
 * @param {Number} sigFigs - Significant figures (default: 3)
 * @returns {Object} - Formatted value
 */
FormatScientific(value, sigFigs := 3) {
    if (value = 0)
        return { standard: "0", scientific: "0.0e+0" }

    absValue := Abs(value)
    exponent := Floor(Log(absValue) / Log(10))

    ; Calculate mantissa
    mantissa := value / (10 ** exponent)
    roundedMantissa := Round(mantissa, sigFigs - 1)

    scientific := Format("{1:.{2}f}e{3:+03d}",
        roundedMantissa, sigFigs - 1, exponent)

    ; Standard notation
    if (absValue >= 0.01 && absValue < 1000)
        standard := Format("{1:." sigFigs - 1 "f}", Round(value, sigFigs - 1))
    else
        standard := scientific

    return {
        original: value,
        standard: standard,
        scientific: scientific,
        exponent: exponent,
        mantissa: roundedMantissa
    }
}

; Test scientific formatting
scientificValues := [0.00000123, 0.0456, 7.89, 123.456, 9876543.21]

output := "Scientific Notation Formatting:`n`n"

for value in scientificValues {
    formatted := FormatScientific(value, 3)
    output .= Format("Original: {1}`n", formatted.original)
    output .= Format("  Standard: {1}`n", formatted.standard)
    output .= Format("  Scientific: {1}`n`n", formatted.scientific)
}

MsgBox(output, "Scientific Notation", "Icon!")

; ============================================================
; Example 7: Grade and Rating Formatter
; ============================================================

/**
 * Convert numeric scores to letter grades
 * 
 * @param {Number} score - Numeric score (0-100)
 * @returns {Object} - Grade information
 */
FormatGrade(score) {
    roundedScore := Round(score, 1)

    grade := ""
    if (roundedScore >= 90)
        grade := "A"
    else if (roundedScore >= 80)
        grade := "B"
    else if (roundedScore >= 70)
        grade := "C"
    else if (roundedScore >= 60)
        grade := "D"
    else
        grade := "F"

    return {
        score: roundedScore,
        letter: grade,
        formatted: Format("{1:.1f} ({2})", roundedScore, grade)
    }
}

/**
 * Create grade distribution report
 * 
 * @param {Array} scores - Array of numeric scores
 * @returns {String} - Grade report
 */
CreateGradeReport(scores) {
    gradeCounts := Map("A", 0, "B", 0, "C", 0, "D", 0, "F", 0)
    totalScore := 0

    for score in scores {
        grade := FormatGrade(score)
        gradeCounts[grade.letter] := gradeCounts[grade.letter] + 1
        totalScore += score
    }

    avgScore := Round(totalScore / scores.Length, 1)
    avgGrade := FormatGrade(avgScore)

    report := "Grade Distribution:`n`n"

    for letter, count in gradeCounts {
        pct := CalculatePercentage(count, scores.Length, 1)
        report .= Format("{1}: {2} students ({3})`n",
            letter, count, pct.formatted)
    }

    report .= Format("`nClass Average: {1} ({2})`n",
        avgScore, avgGrade.letter)
    report .= Format("Total Students: {1}", scores.Length)

    return report
}

; Class scores
classScores := [92, 88, 76, 95, 84, 71, 89, 93, 67, 85, 78, 91, 82, 74, 96, 88]
gradeReport := CreateGradeReport(classScores)

MsgBox(gradeReport, "Grade Report", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                                                    (
                                                    ROUND() FOR DATA FORMATTING & DISPLAY:

                                                    Display Formatting Guidelines:
                                                    ───────────────────────────────
                                                    Magnitude-based precision:
                                                    ≥1000: 0 decimals (1234)
                                                    ≥10:   1 decimal  (12.3)
                                                    ≥1:    2 decimals (1.23)
                                                    <1:    3 decimals (0.123)

                                                    Percentage Display:
                                                    ───────────────────
                                                    Standard: 1 decimal place
                                                    pct := Round((part/whole) * 100, 1)
                                                    display := Format('{1:.1f}%', pct)

                                                    Precise: 2 decimal places
                                                    For small changes or high accuracy needs

                                                    Statistical Rounding:
                                                    ─────────────────────
                                                    • Mean/Average: 2 decimals
                                                    • Std Deviation: 2-3 decimals
                                                    • Variance: 2 decimals
                                                    • Correlation: 3 decimals
                                                    • P-values: 4 decimals

                                                    Table Formatting:
                                                    ─────────────────
                                                    Align by decimal point:
                                                    Format('{1:12.2f}', Round(value, 2))

                                                    Consistent precision across columns:
                                                    All currency: 2 decimals
                                                    All percentages: 1 decimal
                                                    All counts: 0 decimals

                                                    Report Best Practices:
                                                    ──────────────────────
                                                    ✓ Round before display, not before calculation
                                                    ✓ Use consistent precision within categories
                                                    ✓ Show units and labels clearly
                                                    ✓ Align numbers for easy comparison
                                                    ✓ Use appropriate significant figures

                                                    Format Function Patterns:
                                                    ─────────────────────────
                                                    Currency:
                                                    Format('${1:,.2f}', Round(amt, 2))

                                                    Percentage:
                                                    Format('{1:.1f}%', Round(pct, 1))

                                                    Scientific:
                                                    Format('{1:.{2}e}', value, precision)

                                                    Fixed width:
                                                    Format('{1:10.2f}', Round(val, 2))

                                                    Common Display Contexts:
                                                    ────────────────────────
                                                    • User interfaces (simple, readable)
                                                    • Reports and dashboards (consistent)
                                                    • Scientific papers (sig figs)
                                                    • Financial statements (2 decimals)
                                                    • Statistics (appropriate precision)
                                                    • Progress indicators (0-1 decimals)

                                                    Rounding for Readability:
                                                    ─────────────────────────
                                                    Before: 3.14159265359
                                                    After:  3.14 (more readable)

                                                    Before: 0.3333333333
                                                    After:  0.33 or 33.3% (clearer)

                                                    Before: 12,345.6789
                                                    After:  12,346 (simpler)
                                                    )"

MsgBox(info, "Display Formatting Reference", "Icon!")
