#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Floor_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of Floor() function for rounding down to the nearest
 * integer and floor operations in various contexts
 * 
 * FEATURES:
 * - Round down to nearest integer
 * - Always rounds toward negative infinity
 * - Positive and negative number handling
 * - Truncation and floor comparison
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Floor.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Floor() function
 * - Mathematical floor operations
 * - Comparison with Ceil() and Round()
 * - Integer extraction from floats
 * 
 * LEARNING POINTS:
 * 1. Floor() always rounds down to previous integer
 * 2. Floor(3.1) = 3, Floor(3.9) = 3
 * 3. For negative numbers, rounds away from zero
 * 4. Floor(-2.5) = -3 (down on number line)
 * 5. Useful for extracting integer parts
 */

; ============================================================
; Example 1: Basic Floor Operation
; ============================================================

num1 := 3.1
num2 := 3.5
num3 := 3.9
num4 := 4.0

MsgBox("Basic Floor (Round Down):`n`n"
    . "Floor(" num1 ") = " Floor(num1) "`n"
    . "Floor(" num2 ") = " Floor(num2) "`n"
    . "Floor(" num3 ") = " Floor(num3) "`n"
    . "Floor(" num4 ") = " Floor(num4) "`n`n"
    . "Floor always rounds DOWN to previous integer`n"
    . "Even 3.9 rounds down to 3",
    "Basic Floor Example", "Icon!")

; ============================================================
; Example 2: Negative Numbers
; ============================================================

negNum1 := -2.1
negNum2 := -2.5
negNum3 := -2.9
negNum4 := -3.0

MsgBox("Floor with Negative Numbers:`n`n"
    . "Floor(" negNum1 ") = " Floor(negNum1) "`n"
    . "Floor(" negNum2 ") = " Floor(negNum2) "`n"
    . "Floor(" negNum3 ") = " Floor(negNum3) "`n"
    . "Floor(" negNum4 ") = " Floor(negNum4) "`n`n"
    . "'Down' means toward negative infinity`n"
    . "So -2.1 rounds down to -3, not -2",
    "Negative Number Floor", "Icon!")

; ============================================================
; Example 3: Comparison with Round and Ceil
; ============================================================

testValue := 3.7

result := "Comparing Rounding Functions:`n`n"
result .= "Value: " testValue "`n`n"
result .= "Floor(" testValue ") = " Floor(testValue) " (always down)`n"
result .= "Round(" testValue ") = " Round(testValue) " (nearest)`n"
result .= "Ceil(" testValue ")  = " Ceil(testValue) " (always up)`n`n"

testValue2 := -3.7
result .= "`nValue: " testValue2 "`n`n"
result .= "Floor(" testValue2 ") = " Floor(testValue2) " (more negative)`n"
result .= "Round(" testValue2 ") = " Round(testValue2) " (nearest)`n"
result .= "Ceil(" testValue2 ")  = " Ceil(testValue2) " (less negative)"

MsgBox(result, "Function Comparison", "Icon!")

; ============================================================
; Example 4: Extracting Integer Part
; ============================================================

/**
 * Extract integer and fractional parts
 * 
 * @param {Number} value - Number to split
 * @returns {Object} - Integer and fractional parts
 */
SplitNumber(value) {
    integerPart := Floor(value)
    fractionalPart := value - integerPart

    return {
        original: value,
        integerPart: integerPart,
        fractionalPart: Round(fractionalPart, 6),
        sign: value >= 0 ? "positive" : "negative"
    }
}

; Test with various numbers
testNumbers := [12.345, -7.89, 100.001, -0.5]

output := "Splitting Numbers into Parts:`n`n"

for num in testNumbers {
    split := SplitNumber(num)

    output .= Format("{1} = {2} + {3}`n",
        split.original, split.integerPart, split.fractionalPart)
}

output .= "`nFloor() extracts the integer part`n"
output .= "(For negative numbers, rounds away from zero)"

MsgBox(output, "Integer Extraction", "Icon!")

; ============================================================
; Example 5: Age Calculation
; ============================================================

/**
 * Calculate age in complete years (floor of years)
 * 
 * @param {Number} yearsDecimal - Age in decimal years
 * @returns {Object} - Age breakdown
 */
CalculateAge(yearsDecimal) {
    completeYears := Floor(yearsDecimal)
    remainingMonths := Floor((yearsDecimal - completeYears) * 12)
    remainingDays := Floor(((yearsDecimal - completeYears) * 12 - remainingMonths) * 30)

    return {
        totalYears: yearsDecimal,
        years: completeYears,
        months: remainingMonths,
        days: remainingDays,
        formatted: Format("{1} years, {2} months, {3} days",
            completeYears, remainingMonths, remainingDays)
    }
}

; Calculate ages
ages := [25.75, 5.5, 0.25, 18.99]

output := "Age Calculations (Complete Years):`n`n"

for ageDecimal in ages {
    age := CalculateAge(ageDecimal)

    output .= Format("{1:.2f} years = {2}`n", age.totalYears, age.formatted)
}

output .= "`nFloor() gives complete years only`n"
output .= "Even 18.99 years = 18 complete years"

MsgBox(output, "Age Calculation", "Icon!")

; ============================================================
; Example 6: Price Truncation (Drop Cents)
; ============================================================

/**
 * Get whole dollar amount (drop cents)
 * 
 * @param {Number} price - Price with cents
 * @returns {Object} - Dollar and cent breakdown
 */
ExtractDollars(price) {
    dollars := Floor(price)
    cents := Round((price - dollars) * 100, 0)

    return {
        total: price,
        dollars: dollars,
        cents: cents,
        formatted: Format("${1}.{2:02d}", dollars, cents),
        dollarsOnly: Format("${1}", dollars)
    }
}

; Price examples
prices := [19.99, 99.50, 5.05, 1000.01]

output := "Dollar Extraction (Floor):`n`n"

for price in prices {
    breakdown := ExtractDollars(price)

    output .= breakdown.formatted . " → "
    output .= breakdown.dollarsOnly . " + " breakdown.cents "¢`n"
}

output .= "`nFloor() extracts dollar amount`n"
output .= "Useful for '$X and up' pricing"

MsgBox(output, "Price Truncation", "Icon!")

; ============================================================
; Example 7: Time Conversion (Hours and Minutes)
; ============================================================

/**
 * Convert decimal hours to hours and minutes
 * 
 * @param {Number} decimalHours - Time in decimal hours
 * @returns {Object} - Time breakdown
 */
ConvertToHoursMinutes(decimalHours) {
    hours := Floor(decimalHours)
    minutesDecimal := (decimalHours - hours) * 60
    minutes := Floor(minutesDecimal)
    seconds := Floor((minutesDecimal - minutes) * 60)

    return {
        decimal: decimalHours,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        formatted: Format("{1}h {2}m {3}s", hours, minutes, seconds),
        shortFormat: Format("{1}:{2:02d}", hours, minutes)
    }
}

/**
 * Calculate work time from start/end (simplified simulation)
 */
CalculateWorkHours(startHour, endHour) {
    totalHours := endHour - startHour
    time := ConvertToHoursMinutes(totalHours)

    return {
        start: startHour,
        end: endHour,
        time: time
    }
}

; Time tracking examples
timeEntries := [{
    start: 9.0, end: 17.5 },    ; 9:00 AM to 5:30 PM
    {
        start: 8.25, end: 16.75 },  ; 8:15 AM to 4:45 PM
    {
        start: 10.5, end: 14.25 }   ; 10:30 AM to 2:15 PM
]

output := "Work Time Calculations:`n`n"

totalWorked := 0
for entry in timeEntries {
    work := CalculateWorkHours(entry.start, entry.end)
    totalWorked += work.time.decimal

    output .= Format("Shift: {1:.2f} - {2:.2f} = {3}`n",
        work.start, work.end, work.time.formatted)
}

totalTime := ConvertToHoursMinutes(totalWorked)
output .= Format("`nTotal: {1} ({2:.2f} hours)",
    totalTime.formatted, totalWorked)

MsgBox(output, "Time Conversion", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            FLOOR() FUNCTION REFERENCE:

            Syntax:
            FloorValue := Floor(Number)

            Parameters:
            Number - Any number (integer or float)

            Return Value:
            Integer - The largest integer ≤ Number

            Mathematical Definition:
            Floor(x) = largest integer n where n ≤ x

            Behavior:
            • Always rounds DOWN (toward negative infinity)
            • Returns same value if already an integer
            • For negatives, rounds away from zero

            Examples:
            Floor(3.1) → 3
            Floor(3.5) → 3
            Floor(3.9) → 3
            Floor(4.0) → 4
            Floor(-2.1) → -3
            Floor(-2.9) → -3
            Floor(0) → 0

            Comparison:
            Value: 3.7
            ───────────────────────
            Floor(3.7) → 3 (down)
            Round(3.7) → 4 (nearest)
            Ceil(3.7)  → 4 (up)

            Value: -2.3
            ───────────────────────
            Floor(-2.3) → -3 (down = more negative)
            Round(-2.3) → -2 (nearest)
            Ceil(-2.3)  → -2 (up = less negative)

            Number Line Visualization:
            ◄───────────────────────────►
            -3    -2    -1     0     1     2     3     4
            ▲                       ▲
            Floor(-2.3)            Floor(3.7)
            = -3                   = 3

            Common Use Cases:
            ✓ Extract integer part of number
            ✓ Calculate complete units (years, hours, etc.)
            ✓ Drop decimal/fractional parts
            ✓ Convert decimal time to hours:minutes
            ✓ Price truncation (drop cents)
            ✓ Array index calculations
            ✓ Coordinate snapping (grid alignment)

            Integer Part Extraction:
            intPart = Floor(value)
            fracPart = value - Floor(value)

            Example: 12.345
            Integer: Floor(12.345) = 12
            Fractional: 12.345 - 12 = 0.345

            Time Conversion:
            hours = Floor(decimal_hours)
            minutes = Floor((decimal_hours - hours) × 60)

            Example: 2.75 hours
            Hours: Floor(2.75) = 2
            Minutes: Floor(0.75 × 60) = Floor(45) = 45
            Result: 2 hours 45 minutes

            Truncation vs Floor:
            For positive numbers: Same result
            Floor(3.7) = 3, Truncate(3.7) = 3

            For negative numbers: Different!
            Floor(-2.3) = -3 (rounds down)
            Truncate(-2.3) = -2 (drops decimal)

            Key Difference from Ceil():
            Floor: Rounds toward negative infinity
            Ceil: Rounds toward positive infinity

            Positive: Floor(3.7)=3, Ceil(3.7)=4
            Negative: Floor(-2.3)=-3, Ceil(-2.3)=-2
            )"

MsgBox(info, "Floor() Reference", "Icon!")
