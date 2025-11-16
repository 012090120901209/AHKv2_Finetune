#Requires AutoHotkey v2.0
/**
 * BuiltIn_Round_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Basic usage examples of Round() function for rounding numbers to
 * specified decimal places with precision control
 *
 * FEATURES:
 * - Basic rounding operations
 * - Precision control (decimal places)
 * - Banker's rounding (round half to even)
 * - Rounding integers and decimals
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Round.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Round() function with precision parameter
 * - Negative precision for rounding to tens, hundreds, etc.
 * - Format() for number display
 * - Mathematical rounding behavior
 *
 * LEARNING POINTS:
 * 1. Round() rounds to nearest integer by default
 * 2. Second parameter controls decimal places
 * 3. Negative precision rounds to left of decimal
 * 4. Uses "banker's rounding" (round half to even)
 * 5. Essential for displaying and formatting numbers
 */

; ============================================================
; Example 1: Basic Rounding to Integer
; ============================================================

num1 := 3.7
num2 := 3.2
num3 := 3.5
num4 := -2.8

MsgBox("Basic Rounding to Integer:`n`n"
     . "Round(" num1 ") = " Round(num1) "`n"
     . "Round(" num2 ") = " Round(num2) "`n"
     . "Round(" num3 ") = " Round(num3) "`n"
     . "Round(" num4 ") = " Round(num4) "`n`n"
     . "Default: Rounds to nearest integer",
     "Basic Round Example", "Icon!")

; ============================================================
; Example 2: Precision Control
; ============================================================

value := 3.14159265359

MsgBox("Rounding with Different Precision:`n`n"
     . "Original: " value "`n`n"
     . "Round(" value ", 0) = " Round(value, 0) " (integer)`n"
     . "Round(" value ", 1) = " Round(value, 1) " (1 decimal)`n"
     . "Round(" value ", 2) = " Round(value, 2) " (2 decimals)`n"
     . "Round(" value ", 3) = " Round(value, 3) " (3 decimals)`n"
     . "Round(" value ", 5) = " Round(value, 5) " (5 decimals)",
     "Precision Control", "Icon!")

; ============================================================
; Example 3: Negative Precision (Round to Tens, Hundreds)
; ============================================================

largeNum := 12345.67

MsgBox("Negative Precision - Round to Left of Decimal:`n`n"
     . "Original: " largeNum "`n`n"
     . "Round(" largeNum ", 0) = " Round(largeNum, 0) " (ones)`n"
     . "Round(" largeNum ", -1) = " Round(largeNum, -1) " (tens)`n"
     . "Round(" largeNum ", -2) = " Round(largeNum, -2) " (hundreds)`n"
     . "Round(" largeNum ", -3) = " Round(largeNum, -3) " (thousands)`n`n"
     . "Negative precision rounds to 10s, 100s, 1000s, etc.",
     "Negative Precision", "Icon!")

; ============================================================
; Example 4: Banker's Rounding (Round Half to Even)
; ============================================================

; When exactly halfway, rounds to nearest even number
test1 := 2.5  ; Should round to 2 (even)
test2 := 3.5  ; Should round to 4 (even)
test3 := 4.5  ; Should round to 4 (even)
test4 := 5.5  ; Should round to 6 (even)

MsgBox("Banker's Rounding (Round Half to Even):`n`n"
     . "Round(" test1 ") = " Round(test1) " (to even)`n"
     . "Round(" test2 ") = " Round(test2) " (to even)`n"
     . "Round(" test3 ") = " Round(test3) " (to even)`n"
     . "Round(" test4 ") = " Round(test4) " (to even)`n`n"
     . "When exactly .5, rounds to nearest even number`n"
     . "This reduces cumulative rounding bias",
     "Banker's Rounding", "Icon!")

; ============================================================
; Example 5: Rounding Comparison Function
; ============================================================

/**
 * Compare different rounding precisions
 *
 * @param {Number} value - Value to round
 * @returns {Object} - Rounded values at different precisions
 */
CompareRounding(value) {
    return {
        original: value,
        integer: Round(value, 0),
        oneDecimal: Round(value, 1),
        twoDecimal: Round(value, 2),
        threeDecimal: Round(value, 3),
        toTens: Round(value, -1),
        toHundreds: Round(value, -2)
    }
}

testValue := 123.456789
comparison := CompareRounding(testValue)

output := "Rounding Comparison:`n`n"
output .= "Original Value: " comparison.original "`n`n"
output .= "Positive Precision (decimals):`n"
output .= "  Integer: " comparison.integer "`n"
output .= "  1 decimal: " comparison.oneDecimal "`n"
output .= "  2 decimals: " comparison.twoDecimal "`n"
output .= "  3 decimals: " comparison.threeDecimal "`n`n"
output .= "Negative Precision (place values):`n"
output .= "  To tens: " comparison.toTens "`n"
output .= "  To hundreds: " comparison.toHundreds

MsgBox(output, "Rounding Comparison", "Icon!")

; ============================================================
; Example 6: Array Rounding
; ============================================================

/**
 * Round all values in an array to specified precision
 *
 * @param {Array} numbers - Array of numbers to round
 * @param {Number} precision - Decimal places
 * @returns {Array} - Rounded numbers
 */
RoundArray(numbers, precision := 0) {
    rounded := []
    for num in numbers
        rounded.Push(Round(num, precision))
    return rounded
}

/**
 * Format array as string
 */
FormatArray(arr, decimals := 2) {
    str := ""
    for index, value in arr {
        if (decimals = 0)
            str .= value
        else
            str .= Format("{1:." decimals "f}", value)

        if (index < arr.Length)
            str .= ", "
    }
    return str
}

; Test with array of measurements
measurements := [12.345, 23.678, 34.912, 45.234, 56.789]

output := "Array Rounding:`n`n"
output .= "Original: " FormatArray(measurements, 3) "`n`n"
output .= "Rounded to integers: " FormatArray(RoundArray(measurements, 0), 0) "`n"
output .= "Rounded to 1 decimal: " FormatArray(RoundArray(measurements, 1), 1) "`n"
output .= "Rounded to 2 decimals: " FormatArray(RoundArray(measurements, 2), 2)

MsgBox(output, "Array Rounding", "Icon!")

; ============================================================
; Example 7: Smart Rounding Function
; ============================================================

/**
 * Smart rounding based on magnitude of number
 *
 * @param {Number} value - Value to round
 * @returns {Object} - Value with suggested precision
 */
SmartRound(value) {
    absValue := Abs(value)

    if (absValue >= 1000)
        precision := 0  ; Large numbers: no decimals
    else if (absValue >= 10)
        precision := 1  ; Medium numbers: 1 decimal
    else if (absValue >= 1)
        precision := 2  ; Small numbers: 2 decimals
    else if (absValue >= 0.01)
        precision := 3  ; Very small: 3 decimals
    else
        precision := 5  ; Tiny numbers: 5 decimals

    return {
        original: value,
        rounded: Round(value, precision),
        precision: precision,
        reason: GetPrecisionReason(absValue)
    }
}

GetPrecisionReason(absValue) {
    if (absValue >= 1000)
        return "Large number (≥1000)"
    else if (absValue >= 10)
        return "Medium number (≥10)"
    else if (absValue >= 1)
        return "Small number (≥1)"
    else if (absValue >= 0.01)
        return "Very small (≥0.01)"
    else
        return "Tiny number (<0.01)"
}

; Test smart rounding with various values
testValues := [12345.6789, 123.456, 12.345, 1.2345, 0.012345]

output := "Smart Rounding Analysis:`n`n"

for value in testValues {
    result := SmartRound(value)
    output .= Format("Value: {1}`n", result.original)
    output .= Format("  Rounded: {1}`n", result.rounded)
    output .= Format("  Precision: {1} decimals`n", result.precision)
    output .= Format("  Reason: {1}`n`n", result.reason)
}

MsgBox(output, "Smart Rounding", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ROUND() FUNCTION REFERENCE:

Syntax:
  Rounded := Round(Number, Precision := 0)

Parameters:
  Number - The number to round
  Precision - Number of decimal places (default: 0)
    • Positive: Decimal places (1, 2, 3...)
    • Zero: Round to integer
    • Negative: Round to tens (-1), hundreds (-2), etc.

Return Value:
  Number - The rounded value

Rounding Behavior:
  • Uses 'Banker's Rounding' (round half to even)
  • When exactly .5, rounds to nearest even number
  • Example: Round(2.5) = 2, Round(3.5) = 4
  • This reduces cumulative bias in calculations

Precision Examples:
  Round(3.14159, 0) → 3      (integer)
  Round(3.14159, 1) → 3.1    (1 decimal)
  Round(3.14159, 2) → 3.14   (2 decimals)
  Round(12345, -1) → 12350   (tens)
  Round(12345, -2) → 12300   (hundreds)
  Round(12345, -3) → 12000   (thousands)

Key Points:
• Default precision is 0 (rounds to integer)
• Negative precision rounds to left of decimal
• Banker's rounding prevents bias
• Works with positive and negative numbers
• Returns same type as input (float/integer)

Common Use Cases:
✓ Display formatting
✓ Financial calculations
✓ Measurement rounding
✓ Statistical reporting
✓ User interface display
✓ Data normalization
✓ Reducing precision for comparisons

Banker's Rounding vs Traditional:
  Traditional: Always round .5 up
    2.5 → 3, 3.5 → 4, 4.5 → 5, 5.5 → 6

  Banker's (AHK): Round .5 to even
    2.5 → 2, 3.5 → 4, 4.5 → 4, 5.5 → 6

  Advantage: Over many operations, equal
  rounding up and down reduces cumulative error
)"

MsgBox(info, "Round() Reference", "Icon!")
