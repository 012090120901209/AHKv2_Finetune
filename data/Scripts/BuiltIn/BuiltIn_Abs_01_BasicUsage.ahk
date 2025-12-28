#Requires AutoHotkey v2.0

/**
 * BuiltIn_Abs_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of Abs() function for absolute value calculations
 * and distance measurements
 * 
 * FEATURES:
 * - Calculate absolute values of positive and negative numbers
 * - Distance calculations between points
 * - Temperature difference calculations
 * - Financial difference computations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Abs.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Abs() function
 * - Mathematical operations
 * - Formatted string output
 * - Function definitions with parameters
 * 
 * LEARNING POINTS:
 * 1. Abs() returns the absolute (non-negative) value of a number
 * 2. Abs(-5) returns 5, Abs(5) returns 5
 * 3. Essential for distance and difference calculations
 * 4. Works with integers and floating-point numbers
 * 5. Useful for comparing magnitudes regardless of sign
 */

; ============================================================
; Example 1: Basic Absolute Value
; ============================================================

positiveNum := 42
negativeNum := -42
zero := 0

MsgBox("Absolute Value Examples:`n`n"
    . "Abs(" positiveNum ") = " Abs(positiveNum) "`n"
    . "Abs(" negativeNum ") = " Abs(negativeNum) "`n"
    . "Abs(" zero ") = " Abs(zero) "`n`n"
    . "Note: Both positive and negative inputs yield positive outputs",
    "Basic Abs() Example", "Icon!")

; ============================================================
; Example 2: Floating-Point Numbers
; ============================================================

floatPositive := 3.14159
floatNegative := -2.71828
verySmall := -0.00001

MsgBox("Floating-Point Absolute Values:`n`n"
    . "Abs(" floatPositive ") = " Abs(floatPositive) "`n"
    . "Abs(" floatNegative ") = " Abs(floatNegative) "`n"
    . "Abs(" verySmall ") = " Abs(verySmall) "`n`n"
    . "Abs() preserves decimal precision",
    "Floating-Point Example", "Icon!")

; ============================================================
; Example 3: Distance Between Two Numbers
; ============================================================

/**
 * Calculate the absolute distance between two numbers
 * 
 * @param {Number} num1 - First number
 * @param {Number} num2 - Second number
 * @returns {Number} - Absolute distance between the numbers
 */
CalculateDistance(num1, num2) {
    return Abs(num1 - num2)
}

; Test the distance function
point1 := 50
point2 := 120
distance := CalculateDistance(point1, point2)

MsgBox("Distance Between Points:`n`n"
    . "Point 1: " point1 "`n"
    . "Point 2: " point2 "`n"
    . "Distance: " distance "`n`n"
    . "Formula: Abs(" point1 " - " point2 ") = " distance,
    "Distance Calculation", "Icon!")

; Test with reversed order
distance2 := CalculateDistance(point2, point1)

MsgBox("Distance is Symmetric:`n`n"
    . "Distance(" point1 ", " point2 ") = " distance "`n"
    . "Distance(" point2 ", " point1 ") = " distance2 "`n`n"
    . "Order doesn't matter when using Abs()",
    "Symmetric Distance", "Icon!")

; ============================================================
; Example 4: Temperature Differences
; ============================================================

/**
 * Calculate temperature difference
 * 
 * @param {Number} temp1 - First temperature
 * @param {Number} temp2 - Second temperature
 * @param {String} unit - Temperature unit (C or F)
 * @returns {String} - Formatted temperature difference
 */
GetTemperatureDifference(temp1, temp2, unit := "C") {
    difference := Abs(temp1 - temp2)
    return Format("Temperature difference: {1}°{2}", difference, unit)
}

morningTemp := -5
noonTemp := 15
eveningTemp := 8

output := "Daily Temperature Analysis:`n`n"
output .= "Morning: " morningTemp "°C`n"
output .= "Noon: " noonTemp "°C`n"
output .= "Evening: " eveningTemp "°C`n`n"
output .= GetTemperatureDifference(morningTemp, noonTemp) "`n"
output .= GetTemperatureDifference(noonTemp, eveningTemp) "`n"
output .= GetTemperatureDifference(morningTemp, eveningTemp)

MsgBox(output, "Temperature Analysis", "Icon!")

; ============================================================
; Example 5: Coordinate Distance (1D)
; ============================================================

/**
 * Calculate distance between two points on a number line
 * 
 * @param {Number} x1 - First coordinate
 * @param {Number} x2 - Second coordinate
 * @returns {Object} - Object with distance and details
 */
GetCoordinateDistance(x1, x2) {
    distance := Abs(x1 - x2)
    midpoint := (x1 + x2) / 2

    return {
        distance: distance,
        midpoint: midpoint,
        start: x1,
        end: x2
    }
}

; Calculate distances on a number line
coord1 := -10
coord2 := 25

result := GetCoordinateDistance(coord1, coord2)

MsgBox("1D Coordinate Analysis:`n`n"
    . "Start Point: " result.start "`n"
    . "End Point: " result.end "`n"
    . "Distance: " result.distance " units`n"
    . "Midpoint: " result.midpoint "`n`n"
    . "Formula: Abs(" coord1 " - " coord2 ") = " result.distance,
    "Coordinate Distance", "Icon!")

; ============================================================
; Example 6: Financial Differences
; ============================================================

/**
 * Calculate absolute difference between financial values
 * 
 * @param {Number} value1 - First value
 * @param {Number} value2 - Second value
 * @returns {String} - Formatted difference
 */
GetFinancialDifference(value1, value2) {
    difference := Abs(value1 - value2)
    return Format("${1:.2f}", difference)
}

expectedCost := 1500.00
actualCost := 1735.50
budgetVariance := Abs(expectedCost - actualCost)

MsgBox("Budget Variance Analysis:`n`n"
    . "Expected Cost: $" Format("{1:.2f}", expectedCost) "`n"
    . "Actual Cost: $" Format("{1:.2f}", actualCost) "`n"
    . "Variance: " GetFinancialDifference(expectedCost, actualCost) "`n`n"
    . "Status: " (actualCost > expectedCost ? "Over Budget" : "Under Budget"),
    "Financial Analysis", "Icon!")

; Multiple transactions
transactions := [{
    planned: 100, actual: 95 }, {
        planned: 250, actual: 275 }, {
            planned: 500, actual: 500 }, {
                planned: 150, actual: 140
            }
]

output := "Transaction Variance Report:`n`n"
totalVariance := 0

for index, transaction in transactions {
    variance := Abs(transaction.planned - transaction.actual)
    totalVariance += variance
    output .= "Transaction " index ": "
    output .= "Planned $" Format("{1:.2f}", transaction.planned)
    output .= " | Actual $" Format("{1:.2f}", transaction.actual)
    output .= " | Variance $" Format("{1:.2f}", variance) "`n"
}

output .= "`nTotal Absolute Variance: $" Format("{1:.2f}", totalVariance)

MsgBox(output, "Multiple Transactions", "Icon!")

; ============================================================
; Example 7: Value Comparison Array
; ============================================================

/**
 * Find the number in an array closest to a target value
 * 
 * @param {Array} numbers - Array of numbers
 * @param {Number} target - Target value to find closest match
 * @returns {Object} - Closest number and its distance from target
 */
FindClosestValue(numbers, target) {
    if (numbers.Length = 0)
        return { value: 0, distance: 0 }

    closestNum := numbers[1]
    smallestDistance := Abs(numbers[1] - target)

    for num in numbers {
        currentDistance := Abs(num - target)
        if (currentDistance < smallestDistance) {
            smallestDistance := currentDistance
            closestNum := num
        }
    }

    return {
        value: closestNum,
        distance: smallestDistance
    }
}

; Test with array of numbers
testNumbers := [10, 25, 33, 47, 55, 62, 78, 90]
targetValue := 50

result := FindClosestValue(testNumbers, targetValue)

output := "Find Closest Value:`n`n"
output .= "Numbers: " ArrayToString(testNumbers) "`n"
output .= "Target: " targetValue "`n`n"
output .= "Closest Value: " result.value "`n"
output .= "Distance from Target: " result.distance "`n"
output .= "Calculation: Abs(" result.value " - " targetValue ") = " result.distance

MsgBox(output, "Closest Value Finder", "Icon!")

/**
 * Helper function to convert array to string
 */
ArrayToString(arr) {
    str := ""
    for index, value in arr {
        str .= value
        if (index < arr.Length)
            str .= ", "
    }
    return str
}

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            ABS() FUNCTION REFERENCE:

            Syntax:
            AbsoluteValue := Abs(Number)

            Parameters:
            Number - Any positive or negative number (integer or float)

            Return Value:
            Number - The absolute (non-negative) value

            Mathematical Definition:
            Abs(x) = x if x ≥ 0
            Abs(x) = -x if x < 0

            Key Points:
            • Always returns a non-negative value
            • Preserves the magnitude, removes the sign
            • Works with integers and floating-point numbers
            • Essential for distance calculations
            • Useful in difference and variance computations

            Common Use Cases:
            ✓ Distance calculations (1D, 2D, 3D)
            ✓ Temperature differences
            ✓ Financial variance analysis
            ✓ Error margin calculations
            ✓ Finding closest values
            ✓ Magnitude comparisons
            ✓ Statistical analysis (deviations, errors)

            Examples:
            Abs(5) → 5
            Abs(-5) → 5
            Abs(0) → 0
            Abs(-3.14) → 3.14

            Distance Formula (1D):
            distance = Abs(x2 - x1)
            )"

MsgBox(info, "Abs() Reference", "Icon!")
