#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Abs_02_MathOperations.ahk
 * 
 * DESCRIPTION:
 * Advanced mathematical operations using Abs() for difference calculations,
 * magnitude comparisons, and vector operations
 * 
 * FEATURES:
 * - Difference calculations in arrays
 * - Magnitude and comparison operations
 * - Mathematical formula implementations
 * - Complex numerical analysis
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Abs.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Abs() in mathematical expressions
 * - Array iteration and processing
 * - Object-oriented data structures
 * - Advanced function composition
 * 
 * LEARNING POINTS:
 * 1. Abs() is crucial for calculating differences
 * 2. Used in magnitude comparisons
 * 3. Essential for mathematical distance formulas
 * 4. Helps in normalizing signed values
 * 5. Key component in statistical calculations
 */

; ============================================================
; Example 1: Calculate Consecutive Differences
; ============================================================

/**
 * Calculate absolute differences between consecutive array elements
 * 
 * @param {Array} numbers - Array of numbers
 * @returns {Array} - Array of absolute differences
 */
CalculateConsecutiveDifferences(numbers) {
    if (numbers.Length < 2)
        return []

    differences := []
    Loop numbers.Length - 1 {
        diff := Abs(numbers[A_Index + 1] - numbers[A_Index])
        differences.Push(diff)
    }

    return differences
}

; Test with data series
dataSeries := [10, 25, 18, 42, 35, 50, 48]
differences := CalculateConsecutiveDifferences(dataSeries)

output := "Consecutive Differences Analysis:`n`n"
output .= "Data Series: "
for num in dataSeries
    output .= num " "
output .= "`n`nDifferences:`n"

Loop differences.Length {
    output .= "Abs(" dataSeries[A_Index + 1] " - " dataSeries[A_Index] ") = " differences[A_Index] "`n"
}

MsgBox(output, "Consecutive Differences", "Icon!")

; ============================================================
; Example 2: Magnitude Comparison
; ============================================================

/**
 * Compare magnitudes of two numbers regardless of sign
 * 
 * @param {Number} num1 - First number
 * @param {Number} num2 - Second number
 * @returns {Object} - Comparison results
 */
CompareMagnitudes(num1, num2) {
    mag1 := Abs(num1)
    mag2 := Abs(num2)

    return {
        num1: num1,
        num2: num2,
        magnitude1: mag1,
        magnitude2: mag2,
        larger: mag1 > mag2 ? num1 : num2,
        largerMagnitude: mag1 > mag2 ? mag1 : mag2,
        equal: mag1 = mag2
    }
}

; Compare various number pairs
pairs := [{
    a: -15, b: 10 }, {
        a: 25, b: -30 }, {
            a: -20, b: -20 }, {
                a: 7, b: -7
            }
]

output := "Magnitude Comparison Results:`n`n"

for pair in pairs {
    result := CompareMagnitudes(pair.a, pair.b)
    output .= Format("Compare: {1} vs {2}`n", pair.a, pair.b)
    output .= Format("  Magnitudes: {1} vs {2}`n", result.magnitude1, result.magnitude2)

    if (result.equal)
        output .= "  Result: Equal magnitudes`n`n"
    else
        output .= Format("  Result: {1} has larger magnitude ({2})`n`n",
            result.larger, result.largerMagnitude)
}

MsgBox(output, "Magnitude Comparisons", "Icon!")

; ============================================================
; Example 3: Mean Absolute Deviation (MAD)
; ============================================================

/**
 * Calculate Mean Absolute Deviation - a measure of variability
 * 
 * @param {Array} numbers - Array of numbers
 * @returns {Object} - Statistical results
 */
CalculateMAD(numbers) {
    if (numbers.Length = 0)
        return { mean: 0, mad: 0 }

    ; Calculate mean
    sum := 0
    for num in numbers
        sum += num
    mean := sum / numbers.Length

    ; Calculate absolute deviations
    deviationSum := 0
    for num in numbers
        deviationSum += Abs(num - mean)

    mad := deviationSum / numbers.Length

    return {
        mean: mean,
        mad: mad,
        count: numbers.Length,
        data: numbers
    }
}

; Test with dataset
dataset := [10, 15, 20, 25, 30, 35, 40]
result := CalculateMAD(dataset)

output := "Mean Absolute Deviation Analysis:`n`n"
output .= "Dataset: "
for num in dataset
    output .= num " "
output .= "`n`n"
output .= "Mean: " Format("{1:.2f}", result.mean) "`n"
output .= "MAD: " Format("{1:.2f}", result.mad) "`n`n"
output .= "Interpretation: The average deviation from`n"
output .= "the mean is " Format("{1:.2f}", result.mad) " units."

MsgBox(output, "Statistical MAD", "Icon!")

; ============================================================
; Example 4: Distance Matrix
; ============================================================

/**
 * Create a distance matrix showing distances between all pairs
 * 
 * @param {Array} points - Array of 1D coordinates
 * @returns {Array} - 2D array of distances
 */
CreateDistanceMatrix(points) {
    matrix := []

    for i, point1 in points {
        row := []
        for j, point2 in points {
            distance := Abs(point1 - point2)
            row.Push(distance)
        }
        matrix.Push(row)
    }

    return matrix
}

; Create distance matrix
points := [5, 15, 25, 40]
matrix := CreateDistanceMatrix(points)

output := "Distance Matrix:`n`n"
output .= "Points: "
for point in points
    output .= point " "
output .= "`n`n"

; Add header
output .= "     "
for point in points
    output .= Format("{1:>5}", point)
output .= "`n"

; Add matrix rows
for i, row in matrix {
    output .= Format("{1:>5}", points[i])
    for j, distance in row {
        output .= Format("{1:>5}", distance)
    }
    output .= "`n"
}

output .= "`nNote: Each cell shows Abs(row_point - col_point)"

MsgBox(output, "Distance Matrix", "Icon!")

; ============================================================
; Example 5: Value Range Checker
; ============================================================

/**
 * Check if a value is within a tolerance range of a target
 * 
 * @param {Number} value - Value to check
 * @param {Number} target - Target value
 * @param {Number} tolerance - Acceptable deviation
 * @returns {Object} - Check results
 */
CheckValueInRange(value, target, tolerance) {
    deviation := Abs(value - target)
    inRange := deviation <= tolerance

    return {
        value: value,
        target: target,
        tolerance: tolerance,
        deviation: deviation,
        inRange: inRange,
        percentDeviation: (deviation / target) * 100
    }
}

; Quality control measurements
measurements := [99.5, 100.2, 98.8, 101.5, 100.0]
targetValue := 100
tolerance := 1.0

output := "Quality Control Analysis:`n`n"
output .= "Target: " targetValue "`n"
output .= "Tolerance: ±" tolerance "`n`n"

passCount := 0
failCount := 0

for index, measurement in measurements {
    result := CheckValueInRange(measurement, targetValue, tolerance)

    output .= Format("Measurement {1}: {2}`n", index, measurement)
    output .= Format("  Deviation: {1:.2f} ({2:.1f}%)`n",
        result.deviation, result.percentDeviation)
    output .= "  Status: " (result.inRange ? "PASS ✓" : "FAIL ✗") "`n`n"

    if (result.inRange)
        passCount++
    else
        failCount++
}

output .= Format("Summary: {1} Pass, {2} Fail", passCount, failCount)

MsgBox(output, "Quality Control", "Icon!")

; ============================================================
; Example 6: Symmetric Difference Calculator
; ============================================================

/**
 * Calculate symmetric difference between two sets of numbers
 * 
 * @param {Number} a - First number
 * @param {Number} b - Second number
 * @param {Number} c - Third number
 * @returns {Object} - All pairwise differences
 */
CalculateAllDifferences(a, b, c) {
    return {
        ab: Abs(a - b),
        ac: Abs(a - c),
        bc: Abs(b - c),
        max: Max(Abs(a - b), Abs(a - c), Abs(b - c)),
        min: Min(Abs(a - b), Abs(a - c), Abs(b - c)),
        values: [a, b, c]
    }
}

; Test with triangle sides
side1 := 15
side2 := 20
side3 := 25

result := CalculateAllDifferences(side1, side2, side3)

output := "Triangle Side Analysis:`n`n"
output .= Format("Sides: {1}, {2}, {3}`n`n", side1, side2, side3)
output .= "Pairwise Differences:`n"
output .= Format("  |{1} - {2}| = {3}`n", side1, side2, result.ab)
output .= Format("  |{1} - {2}| = {3}`n", side1, side3, result.ac)
output .= Format("  |{1} - {2}| = {3}`n", side2, side3, result.bc)
output .= "`nMaximum Difference: " result.max "`n"
output .= "Minimum Difference: " result.min

MsgBox(output, "Symmetric Differences", "Icon!")

; ============================================================
; Example 7: Signal Variation Analysis
; ============================================================

/**
 * Analyze variation in a signal or time series
 * 
 * @param {Array} signal - Array of signal values
 * @returns {Object} - Variation statistics
 */
AnalyzeSignalVariation(signal) {
    if (signal.Length < 2)
        return { totalVariation: 0, avgVariation: 0, maxVariation: 0 }

    totalVariation := 0
    maxVariation := 0
    variations := []

    Loop signal.Length - 1 {
        variation := Abs(signal[A_Index + 1] - signal[A_Index])
        variations.Push(variation)
        totalVariation += variation
        if (variation > maxVariation)
            maxVariation := variation
    }

    return {
        totalVariation: totalVariation,
        avgVariation: totalVariation / variations.Length,
        maxVariation: maxVariation,
        minVariation: Min(variations*),
        variations: variations,
        signalLength: signal.Length
    }
}

; Simulate sensor readings
sensorReadings := [100, 102, 99, 103, 101, 105, 98, 104, 100]
analysis := AnalyzeSignalVariation(sensorReadings)

output := "Signal Variation Analysis:`n`n"
output .= "Sensor Readings: "
for reading in sensorReadings
    output .= reading " "
output .= "`n`n"
output .= "Total Variation: " Format("{1:.2f}", analysis.totalVariation) "`n"
output .= "Average Variation: " Format("{1:.2f}", analysis.avgVariation) "`n"
output .= "Maximum Variation: " analysis.maxVariation "`n"
output .= "Minimum Variation: " analysis.minVariation "`n`n"
output .= "Stability: " (analysis.avgVariation < 3 ? "Good" : "Unstable")

MsgBox(output, "Signal Analysis", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            ABS() IN MATHEMATICAL OPERATIONS:

            Common Mathematical Uses:
            ──────────────────────────────

            1. Distance Calculations:
            distance = Abs(x2 - x1)

            2. Magnitude Comparison:
            Compare Abs(a) with Abs(b)

            3. Mean Absolute Deviation (MAD):
            MAD = Σ(Abs(xi - mean)) / n

            4. Total Variation:
            TV = Σ(Abs(xi+1 - xi))

            5. Error/Tolerance Checking:
            error = Abs(measured - expected)
            acceptable = error <= tolerance

            6. Symmetric Difference:
            symdiff = Abs(a - b)

            Key Mathematical Properties:
            • |a| ≥ 0 (always non-negative)
            • |-a| = |a| (sign doesn't matter)
            • |a × b| = |a| × |b| (multiplicative)
            • Triangle inequality: |a + b| ≤ |a| + |b|

            Applications:
            ✓ Statistical analysis (MAD, deviations)
            ✓ Quality control (tolerance checks)
            ✓ Signal processing (variation analysis)
            ✓ Distance matrices
            ✓ Error calculations
            ✓ Magnitude comparisons
            ✓ Range validation

            Performance Note:
            • Abs() is a very fast operation
            • Safe for all number types
            • No overflow issues with proper inputs
            )"

MsgBox(info, "Abs() Mathematical Reference", "Icon!")
