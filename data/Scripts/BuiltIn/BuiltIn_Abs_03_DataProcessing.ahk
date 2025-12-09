#Requires AutoHotkey v2.0

/**
* BuiltIn_Abs_03_DataProcessing.ahk
*
* DESCRIPTION:
* Data processing applications of Abs() for error margins, statistical analysis,
* outlier detection, and data normalization
*
* FEATURES:
* - Error margin calculations
* - Statistical deviation analysis
* - Outlier detection algorithms
* - Data quality assessment
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/Abs.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Complex data structures with objects and arrays
* - Advanced statistical computations
* - Multi-dimensional data analysis
* - Functional programming patterns
*
* LEARNING POINTS:
* 1. Abs() is essential for error analysis
* 2. Used in outlier detection algorithms
* 3. Critical for data quality metrics
* 4. Foundation of many statistical measures
* 5. Key component in data validation
*/

; ============================================================
; Example 1: Error Margin Analysis
; ============================================================

/**
* Analyze measurement errors against expected values
*
* @param {Array} measurements - Array of measured values
* @param {Array} expected - Array of expected values
* @returns {Object} - Error analysis results
*/
AnalyzeErrorMargins(measurements, expected) {
    if (measurements.Length != expected.Length)
    throw ValueError("Arrays must be same length")

    errors := []
    totalError := 0
    maxError := 0
    maxErrorIndex := 0

    Loop measurements.Length {
        error := Abs(measurements[A_Index] - expected[A_Index])
        errors.Push(error)
        totalError += error

        if (error > maxError) {
            maxError := error
            maxErrorIndex := A_Index
        }
    }

    return {
        errors: errors,
        totalError: totalError,
        avgError: totalError / errors.Length,
        maxError: maxError,
        maxErrorIndex: maxErrorIndex,
        count: measurements.Length
    }
}

; Simulate measurement data
measuredValues := [100.5, 99.8, 101.2, 98.5, 100.8, 102.1, 99.2]
expectedValues := [100, 100, 100, 100, 100, 100, 100]

result := AnalyzeErrorMargins(measuredValues, expectedValues)

output := "Error Margin Analysis:`n`n"
output .= "Measurement Report:`n"

Loop result.count {
    output .= Format("#{1}: Expected={2}, Measured={3}, Error={4:.2f}`n",
    A_Index, expectedValues[A_Index],
    measuredValues[A_Index], result.errors[A_Index])
}

output .= "`nStatistics:`n"
output .= Format("Average Error: {1:.3f}`n", result.avgError)
output .= Format("Maximum Error: {1:.2f} (at position {2})`n",
result.maxError, result.maxErrorIndex)
output .= Format("Total Absolute Error: {1:.2f}", result.totalError)

MsgBox(output, "Error Analysis", "Icon!")

; ============================================================
; Example 2: Outlier Detection
; ============================================================

/**
* Detect outliers using Mean Absolute Deviation (MAD) method
*
* @param {Array} data - Dataset to analyze
* @param {Number} threshold - MAD multiplier threshold (default: 2.5)
* @returns {Object} - Outlier detection results
*/
DetectOutliers(data, threshold := 2.5) {
    ; Calculate median
    sortedData := data.Clone()
    SortArray(&sortedData)
    median := GetMedian(sortedData)

    ; Calculate MAD
    deviations := []
    for value in data
    deviations.Push(Abs(value - median))

    SortArray(&deviations)
    mad := GetMedian(deviations)

    ; Detect outliers
    outliers := []
    normal := []

    for value in data {
        deviation := Abs(value - median)
        if (mad > 0 && deviation / mad > threshold)
        outliers.Push({value: value, deviation: deviation})
        else
        normal.Push(value)
    }

    return {
        median: median,
        mad: mad,
        outliers: outliers,
        normalValues: normal,
        threshold: threshold
    }
}

GetMedian(sortedArray) {
    n := sortedArray.Length
    if (n = 0)
    return 0
    if (Mod(n, 2) = 1)
    return sortedArray[Ceil(n / 2)]
    else
    return (sortedArray[n / 2] + sortedArray[n / 2 + 1]) / 2
}

SortArray(&arr) {
    ; Simple bubble sort for small arrays
    Loop arr.Length - 1 {
        i := A_Index
        Loop arr.Length - i {
            j := A_Index
            if (arr[j] > arr[j + 1]) {
                temp := arr[j]
                arr[j] := arr[j + 1]
                arr[j + 1] := temp
            }
        }
    }
}

; Test outlier detection
testData := [10, 12, 11, 13, 12, 10, 11, 45, 12, 13, 11, 10, 12]
outlierResult := DetectOutliers(testData, 2.5)

output := "Outlier Detection Analysis:`n`n"
output .= "Dataset: "
for value in testData
output .= value " "
output .= "`n`n"
output .= Format("Median: {1:.2f}`n", outlierResult.median)
output .= Format("MAD: {1:.2f}`n", outlierResult.mad)
output .= Format("Threshold: {1} × MAD`n`n", outlierResult.threshold)

if (outlierResult.outliers.Length > 0) {
    output .= "Detected Outliers:`n"
    for outlier in outlierResult.outliers {
        output .= Format("  Value: {1}, Deviation: {2:.2f}`n",
        outlier.value, outlier.deviation)
    }
} else {
    output .= "No outliers detected"
}

MsgBox(output, "Outlier Detection", "Icon!")

; ============================================================
; Example 3: Data Quality Assessment
; ============================================================

/**
* Assess data quality based on consistency metrics
*
* @param {Array} data - Data points to assess
* @returns {Object} - Quality metrics
*/
AssessDataQuality(data) {
    if (data.Length < 2)
    return {quality: "Insufficient data", score: 0}

    ; Calculate mean
    sum := 0
    for value in data
    sum += value
    mean := sum / data.Length

    ; Calculate variations
    totalDeviation := 0
    maxDeviation := 0
    consistencyScore := 0

    for value in data {
        deviation := Abs(value - mean)
        totalDeviation += deviation
        if (deviation > maxDeviation)
        maxDeviation := deviation
    }

    avgDeviation := totalDeviation / data.Length
    coefficientOfVariation := (avgDeviation / mean) * 100

    ; Determine quality score (0-100)
    if (coefficientOfVariation < 5)
    qualityScore := 100
    else if (coefficientOfVariation < 10)
    qualityScore := 90
    else if (coefficientOfVariation < 15)
    qualityScore := 75
    else if (coefficientOfVariation < 25)
    qualityScore := 50
    else
    qualityScore := 25

    return {
        mean: mean,
        avgDeviation: avgDeviation,
        maxDeviation: maxDeviation,
        coefficientOfVariation: coefficientOfVariation,
        qualityScore: qualityScore,
        rating: GetQualityRating(qualityScore)
    }
}

GetQualityRating(score) {
    if (score >= 90)
    return "Excellent"
    else if (score >= 75)
    return "Good"
    else if (score >= 50)
    return "Fair"
    else
    return "Poor"
}

; Test data quality
dataset1 := [100, 101, 99, 100, 102, 99, 101, 100]
dataset2 := [100, 85, 115, 92, 108, 95, 105, 88]

for index, dataset in [dataset1, dataset2] {
    quality := AssessDataQuality(dataset)

    output := Format("Dataset {1} Quality Assessment:`n`n", index)
    output .= "Data: "
    for value in dataset
    output .= value " "
    output .= "`n`n"
    output .= Format("Mean: {1:.2f}`n", quality.mean)
    output .= Format("Avg Deviation: {1:.2f}`n", quality.avgDeviation)
    output .= Format("Max Deviation: {1:.2f}`n", quality.maxDeviation)
    output .= Format("Coefficient of Variation: {1:.2f}%`n`n", quality.coefficientOfVariation)
    output .= Format("Quality Score: {1}/100`n", quality.qualityScore)
    output .= Format("Rating: {1}", quality.rating)

    MsgBox(output, "Data Quality " index, "Icon!")
}

; ============================================================
; Example 4: Prediction Error Analysis
; ============================================================

/**
* Calculate prediction errors and accuracy metrics
*
* @param {Array} predicted - Predicted values
* @param {Array} actual - Actual values
* @returns {Object} - Error metrics
*/
CalculatePredictionErrors(predicted, actual) {
    if (predicted.Length != actual.Length)
    throw ValueError("Arrays must be same length")

    errors := []
    absErrors := []
    squaredErrors := []

    for i, pred in predicted {
        error := actual[i] - pred
        absError := Abs(error)

        errors.Push(error)
        absErrors.Push(absError)
        squaredErrors.Push(error * error)
    }

    ; Calculate metrics
    mae := Sum(absErrors) / absErrors.Length  ; Mean Absolute Error
    mse := Sum(squaredErrors) / squaredErrors.Length  ; Mean Squared Error
    rmse := Sqrt(mse)  ; Root Mean Squared Error

    return {
        errors: errors,
        absErrors: absErrors,
        mae: mae,
        mse: mse,
        rmse: rmse,
        count: errors.Length
    }
}

Sum(arr) {
    total := 0
    for value in arr
    total += value
    return total
}

; Test prediction model
predictedSales := [100, 150, 200, 180, 220, 190]
actualSales := [105, 145, 210, 175, 225, 195]

metrics := CalculatePredictionErrors(predictedSales, actualSales)

output := "Prediction Error Analysis:`n`n"
output .= "Sales Forecast vs Actual:`n"

Loop metrics.count {
    output .= Format("Period {1}: Predicted={2}, Actual={3}, Error={4:+.0f}, |Error|={5:.0f}`n",
    A_Index, predictedSales[A_Index], actualSales[A_Index],
    metrics.errors[A_Index], metrics.absErrors[A_Index])
}

output .= "`nError Metrics:`n"
output .= Format("MAE (Mean Absolute Error): {1:.2f}`n", metrics.mae)
output .= Format("MSE (Mean Squared Error): {1:.2f}`n", metrics.mse)
output .= Format("RMSE (Root Mean Squared Error): {1:.2f}`n`n", metrics.rmse)
output .= "Lower values indicate better predictions"

MsgBox(output, "Prediction Accuracy", "Icon!")

; ============================================================
; Example 5: Tolerance Band Monitoring
; ============================================================

/**
* Monitor values against tolerance bands
*
* @param {Array} values - Values to monitor
* @param {Number} target - Target value
* @param {Number} warningTolerance - Warning threshold
* @param {Number} criticalTolerance - Critical threshold
* @returns {Object} - Monitoring results
*/
MonitorToleranceBands(values, target, warningTolerance, criticalTolerance) {
    results := []
    okCount := 0
    warningCount := 0
    criticalCount := 0

    for value in values {
        deviation := Abs(value - target)
        status := ""

        if (deviation <= warningTolerance) {
            status := "OK"
            okCount++
        } else if (deviation <= criticalTolerance) {
            status := "WARNING"
            warningCount++
        } else {
            status := "CRITICAL"
            criticalCount++
        }

        results.Push({
            value: value,
            deviation: deviation,
            status: status
        })
    }

    return {
        results: results,
        okCount: okCount,
        warningCount: warningCount,
        criticalCount: criticalCount,
        total: values.Length
    }
}

; Monitor process parameters
processValues := [100, 102, 98, 105, 97, 108, 95, 112, 99]
targetValue := 100
warningThreshold := 5
criticalThreshold := 10

monitoring := MonitorToleranceBands(processValues, targetValue,
warningThreshold, criticalThreshold)

output := "Process Monitoring Report:`n`n"
output .= Format("Target: {1} ± {2} (Warning) ± {3} (Critical)`n`n",
targetValue, warningThreshold, criticalThreshold)

for index, result in monitoring.results {
    statusSymbol := result.status = "OK" ? "✓"
    : result.status = "WARNING" ? "⚠"
    : "✗"

    output .= Format("Reading {1}: {2} | Dev: {3:.1f} | {4} {5}`n",
    index, result.value, result.deviation,
    result.status, statusSymbol)
}

output .= "`nSummary:`n"
output .= Format("OK: {1} | Warnings: {2} | Critical: {3}",
monitoring.okCount, monitoring.warningCount,
monitoring.criticalCount)

MsgBox(output, "Tolerance Monitoring", "Icon!")

; ============================================================
; Example 6: Data Smoothness Analysis
; ============================================================

/**
* Analyze data smoothness by examining consecutive variations
*
* @param {Array} data - Time series or sequential data
* @returns {Object} - Smoothness metrics
*/
AnalyzeDataSmoothness(data) {
    if (data.Length < 2)
    return {smoothness: 0, rating: "Insufficient data"}

    variations := []
    totalVariation := 0

    Loop data.Length - 1 {
        variation := Abs(data[A_Index + 1] - data[A_Index])
        variations.Push(variation)
        totalVariation += variation
    }

    avgVariation := totalVariation / variations.Length
    maxVariation := Max(variations*)

    ; Smoothness score (inverse of variation)
    smoothnessScore := maxVariation > 0 ? 100 / (1 + avgVariation) : 100

    return {
        variations: variations,
        totalVariation: totalVariation,
        avgVariation: avgVariation,
        maxVariation: maxVariation,
        smoothnessScore: smoothnessScore,
        rating: GetSmoothnessRating(smoothnessScore)
    }
}

GetSmoothnessRating(score) {
    if (score >= 80)
    return "Very Smooth"
    else if (score >= 60)
    return "Smooth"
    else if (score >= 40)
    return "Moderate"
    else
    return "Rough"
}

; Test with different datasets
smoothData := [100, 101, 102, 101, 100, 101, 102, 101]
roughData := [100, 110, 95, 115, 90, 105, 98, 112]

for index, testData in [smoothData, roughData] {
    result := AnalyzeDataSmoothness(testData)

    output := Format("Dataset {1} Smoothness Analysis:`n`n", index)
    output .= "Data: "
    for value in testData
    output .= value " "
    output .= "`n`n"
    output .= Format("Total Variation: {1:.2f}`n", result.totalVariation)
    output .= Format("Average Variation: {1:.2f}`n", result.avgVariation)
    output .= Format("Maximum Variation: {1:.2f}`n`n", result.maxVariation)
    output .= Format("Smoothness Score: {1:.1f}/100`n", result.smoothnessScore)
    output .= Format("Rating: {1}", result.rating)

    MsgBox(output, "Smoothness Analysis " index, "Icon!")
}

; ============================================================
; Example 7: Statistical Control Limits
; ============================================================

/**
* Calculate control limits and identify out-of-control points
*
* @param {Array} data - Process data
* @param {Number} sigmaMultiplier - Number of standard deviations (default: 3)
* @returns {Object} - Control chart analysis
*/
AnalyzeControlLimits(data, sigmaMultiplier := 3) {
    ; Calculate mean
    mean := Sum(data) / data.Length

    ; Calculate standard deviation using MAD approximation
    deviations := []
    for value in data
    deviations.Push(Abs(value - mean))

    avgDeviation := Sum(deviations) / deviations.Length
    sigma := avgDeviation * 1.4826  ; MAD to sigma conversion factor

    ucl := mean + (sigmaMultiplier * sigma)  ; Upper Control Limit
    lcl := mean - (sigmaMultiplier * sigma)  ; Lower Control Limit

    ; Identify out-of-control points
    outOfControl := []
    for index, value in data {
        if (value > ucl || value < lcl)
        outOfControl.Push({index: index, value: value})
    }

    return {
        mean: mean,
        sigma: sigma,
        ucl: ucl,
        lcl: lcl,
        outOfControl: outOfControl,
        inControl: data.Length - outOfControl.Length
    }
}

; Process control data
controlData := [100, 102, 98, 101, 99, 103, 97, 115, 101, 100, 99, 102]
controlAnalysis := AnalyzeControlLimits(controlData, 3)

output := "Statistical Process Control:`n`n"
output .= Format("Mean: {1:.2f}`n", controlAnalysis.mean)
output .= Format("Sigma (σ): {1:.2f}`n", controlAnalysis.sigma)
output .= Format("UCL (+3σ): {1:.2f}`n", controlAnalysis.ucl)
output .= Format("LCL (-3σ): {1:.2f}`n`n", controlAnalysis.lcl)

if (controlAnalysis.outOfControl.Length > 0) {
    output .= "Out-of-Control Points:`n"
    for point in controlAnalysis.outOfControl {
        output .= Format("  Position {1}: {2:.2f}`n", point.index, point.value)
    }
} else {
    output .= "All points within control limits ✓"
}

output .= Format("`n`nSummary: {1}/{2} points in control",
controlAnalysis.inControl, controlData.Length)

MsgBox(output, "Control Chart Analysis", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ABS() IN DATA PROCESSING & STATISTICS:

Error Analysis:
───────────────
• Mean Absolute Error (MAE): Σ|yi - ŷi| / n
• Root Mean Squared Error (RMSE): √(Σ(yi - ŷi)² / n)
• Absolute Percentage Error: |actual - predicted| / actual × 100

Statistical Measures:
─────────────────────
• Mean Absolute Deviation (MAD): Σ|xi - x̄| / n
• Median Absolute Deviation: median(|xi - median(x)|)
• Coefficient of Variation: (MAD / mean) × 100

Quality Metrics:
────────────────
• Tolerance checking: |measured - target| ≤ tolerance
• Deviation analysis: |value - expected|
• Consistency scoring: Based on absolute deviations

Outlier Detection:
──────────────────
• Modified Z-score: |xi - median| / MAD
• Threshold method: |xi - mean| > k × σ
• Range method: Outside [Q1 - 1.5×IQR, Q3 + 1.5×IQR]

Process Control:
────────────────
• Control limits: mean ± k × σ
• Out-of-control: |value - mean| > k × σ
• Trend detection: Σ|consecutive differences|

Applications:
✓ Quality control and Six Sigma
✓ Prediction model evaluation
✓ Outlier and anomaly detection
✓ Process monitoring
✓ Data quality assessment
✓ Error analysis and reporting
✓ Statistical process control

Best Practices:
• Use appropriate threshold for your domain
• Consider both average and maximum errors
• Combine with other statistical measures
• Normalize by scale when comparing datasets
)"

MsgBox(info, "Abs() Data Processing Reference", "Icon!")
