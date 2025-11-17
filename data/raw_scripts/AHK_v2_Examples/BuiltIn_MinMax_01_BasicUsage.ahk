#Requires AutoHotkey v2.0
/**
 * BuiltIn_MinMax_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Basic usage examples of Min() and Max() functions for finding minimum and
 * maximum values in sets, comparing numbers, and basic operations
 *
 * FEATURES:
 * - Find minimum and maximum values
 * - Compare two or more numbers
 * - Array min/max operations
 * - Variadic parameter usage
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Min.htm
 * https://www.autohotkey.com/docs/v2/lib/Max.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Min() and Max() functions
 * - Variadic parameters
 * - Array unpacking with *
 * - Comparison operations
 *
 * LEARNING POINTS:
 * 1. Min() returns smallest value from arguments
 * 2. Max() returns largest value from arguments
 * 3. Can accept 2 or more arguments
 * 4. Use * operator to unpack arrays
 * 5. Essential for range and bounds checking
 */

; ============================================================
; Example 1: Basic Min and Max
; ============================================================

num1 := 42
num2 := 17
num3 := 85

minValue := Min(num1, num2, num3)
maxValue := Max(num1, num2, num3)

MsgBox("Finding Min and Max:`n`n"
     . "Numbers: " num1 ", " num2 ", " num3 "`n`n"
     . "Min(" num1 ", " num2 ", " num3 ") = " minValue "`n"
     . "Max(" num1 ", " num2 ", " num3 ") = " maxValue "`n`n"
     . "Min finds the smallest value`n"
     . "Max finds the largest value",
     "Basic Min/Max", "Icon!")

; ============================================================
; Example 2: Comparing Two Values
; ============================================================

temp1 := 72.5
temp2 := 68.3

lowerTemp := Min(temp1, temp2)
higherTemp := Max(temp1, temp2)
tempDifference := higherTemp - lowerTemp

MsgBox("Temperature Comparison:`n`n"
     . "Temperature 1: " temp1 "°F`n"
     . "Temperature 2: " temp2 "°F`n`n"
     . "Lower: " lowerTemp "°F`n"
     . "Higher: " higherTemp "°F`n"
     . "Difference: " Round(tempDifference, 1) "°F`n`n"
     . "Min() and Max() work great for comparing pairs",
     "Two Value Comparison", "Icon!")

; ============================================================
; Example 3: Array Min and Max
; ============================================================

/**
 * Find min and max in an array
 *
 * @param {Array} numbers - Array of numbers
 * @returns {Object} - Min, max, and range
 */
FindMinMax(numbers) {
    if (numbers.Length = 0)
        return {error: "Empty array"}

    minValue := Min(numbers*)  ; Unpack array with *
    maxValue := Max(numbers*)
    rangeValue := maxValue - minValue

    return {
        min: minValue,
        max: maxValue,
        range: rangeValue,
        count: numbers.Length
    }
}

; Test with array of values
testArray := [23, 67, 12, 89, 45, 34, 78, 56]
result := FindMinMax(testArray)

output := "Array Min/Max Analysis:`n`n"
output .= "Values: "
for num in testArray
    output .= num " "
output .= "`n`n"
output .= "Minimum: " result.min "`n"
output .= "Maximum: " result.max "`n"
output .= "Range: " result.range "`n"
output .= "Count: " result.count "`n`n"
output .= "Use * operator to unpack array: Min(arr*)"

MsgBox(output, "Array Min/Max", "Icon!")

; ============================================================
; Example 4: Multiple Values at Once
; ============================================================

; Can pass any number of arguments
values := [5, 12, 3, 19, 8, 15, 2, 21, 11]

minVal := Min(5, 12, 3, 19, 8, 15, 2, 21, 11)
maxVal := Max(5, 12, 3, 19, 8, 15, 2, 21, 11)

; Or use array unpacking
minVal2 := Min(values*)
maxVal2 := Max(values*)

MsgBox("Variadic Parameters:`n`n"
     . "Direct: Min(5, 12, 3, ...) = " minVal "`n"
     . "Array: Min(values*) = " minVal2 "`n`n"
     . "Direct: Max(5, 12, 3, ...) = " maxVal "`n"
     . "Array: Max(values*) = " maxVal2 "`n`n"
     . "Both methods give same result!",
     "Variadic Usage", "Icon!")

; ============================================================
; Example 5: Negative Numbers
; ============================================================

negativeNumbers := [-15, -3, -42, -8, -27]
result := FindMinMax(negativeNumbers)

output := "Negative Numbers:`n`n"
output .= "Values: "
for num in negativeNumbers
    output .= num " "
output .= "`n`n"
output .= "Minimum (most negative): " result.min "`n"
output .= "Maximum (least negative): " result.max "`n"
output .= "Range: " result.range "`n`n"
output .= "Min() finds most negative`n"
output .= "Max() finds least negative"

MsgBox(output, "Negative Numbers", "Icon!")

; ============================================================
; Example 6: Mixed Positive and Negative
; ============================================================

mixedNumbers := [-10, 5, -3, 12, -7, 8, 0, -15, 20]
result := FindMinMax(mixedNumbers)

output := "Mixed Positive/Negative:`n`n"
output .= "Values: "
for num in mixedNumbers
    output .= num " "
output .= "`n`n"
output .= "Minimum: " result.min "`n"
output .= "Maximum: " result.max "`n"
output .= "Range: " result.range "`n`n"
output .= "Works seamlessly with mixed signs"

MsgBox(output, "Mixed Numbers", "Icon!")

; ============================================================
; Example 7: Practical Comparison Examples
; ============================================================

/**
 * Get best and worst scores
 *
 * @param {Array} scores - Player scores
 * @returns {Object} - Best and worst performance
 */
GetBestWorst(scores) {
    return {
        best: Max(scores*),
        worst: Min(scores*),
        spread: Max(scores*) - Min(scores*)
    }
}

/**
 * Compare measurements
 *
 * @param {Number} measurement1 - First measurement
 * @param {Number} measurement2 - Second measurement
 * @param {Number} measurement3 - Third measurement
 * @returns {Object} - Comparison results
 */
CompareMeasurements(measurement1, measurement2, measurement3) {
    minMeasure := Min(measurement1, measurement2, measurement3)
    maxMeasure := Max(measurement1, measurement2, measurement3)

    return {
        lowest: minMeasure,
        highest: maxMeasure,
        average: (measurement1 + measurement2 + measurement3) / 3,
        variance: maxMeasure - minMeasure
    }
}

; Game scores
playerScores := [1250, 980, 1560, 1120, 1380]
scoreStats := GetBestWorst(playerScores)

output := "Game Scores:`n"
output .= "Scores: "
for score in playerScores
    output .= score " "
output .= "`n`n"
output .= "Best Score: " scoreStats.best "`n"
output .= "Worst Score: " scoreStats.worst "`n"
output .= "Spread: " scoreStats.spread " points`n`n"

; Quality measurements
measure1 := 99.5
measure2 := 100.2
measure3 := 99.8
measurements := CompareMeasurements(measure1, measure2, measure3)

output .= "Quality Control:`n"
output .= "Measurements: " measure1 ", " measure2 ", " measure3 "`n`n"
output .= "Lowest: " measurements.lowest "`n"
output .= "Highest: " measurements.highest "`n"
output .= "Average: " Round(measurements.average, 2) "`n"
output .= "Variance: " Round(measurements.variance, 2)

MsgBox(output, "Practical Examples", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
MIN() AND MAX() FUNCTIONS REFERENCE:

Syntax:
  Minimum := Min(Number1, Number2, ...)
  Maximum := Max(Number1, Number2, ...)

Parameters:
  Number1, Number2, ... - Two or more numeric values
  • Requires at least 2 arguments
  • Can accept any number of arguments
  • All parameters must be numeric

Return Value:
  Number - The smallest (Min) or largest (Max) value

Examples:
  Min(5, 12, 3) → 3
  Max(5, 12, 3) → 12

  Min(-5, -12, -3) → -12 (most negative)
  Max(-5, -12, -3) → -3 (least negative)

  Min(0, 100, -50, 75) → -50
  Max(0, 100, -50, 75) → 100

Array Unpacking:
────────────────
Use * operator to unpack arrays:

  numbers := [5, 12, 3, 8]

  minVal := Min(numbers*)  ; Same as Min(5, 12, 3, 8)
  maxVal := Max(numbers*)  ; Same as Max(5, 12, 3, 8)

This is the preferred method for arrays!

Two Value Comparison:
──────────────────────
  smaller := Min(a, b)
  larger := Max(a, b)

Equivalent to:
  smaller := (a < b) ? a : b
  larger := (a > b) ? a : b

But Min/Max is more readable!

Common Use Cases:
─────────────────
✓ Find smallest/largest in dataset
✓ Compare two values
✓ Calculate range (Max - Min)
✓ Bounds checking (clamping)
✓ Finding extremes
✓ Statistical analysis
✓ Game score tracking

Finding Range:
──────────────
  range := Max(values*) - Min(values*)

Shows spread of data:
  [10, 20, 30, 40, 50]
  Range = 50 - 10 = 40

Negative Numbers:
─────────────────
Min finds most negative:
  Min(-5, -12, -3) = -12

Max finds least negative (or most positive):
  Max(-5, -12, -3) = -3

Number Line:
  ◄───────────────────────►
  -12    -5    -3     0
   ▲            ▲
  Min         Max

Best Practices:
───────────────
✓ Use Min/Max instead of if-else chains
✓ Unpack arrays with * operator
✓ Check for empty arrays before unpacking
✓ Combine with other math functions
✓ Use for readability in comparisons

Error Handling:
───────────────
Min() and Max() require at least 2 arguments:
  Min(5)        ; Error!
  Min(5, 10)    ; OK
  Min(arr*)     ; OK if arr has 2+ items

Always validate array length:
  if (arr.Length >= 2)
      result := Min(arr*)

Performance:
────────────
• Very fast operations
• O(n) time complexity
• No memory allocation
• Optimal for small to medium sets
• For very large datasets, consider custom loop
)"

MsgBox(info, "Min/Max Reference", "Icon!")
