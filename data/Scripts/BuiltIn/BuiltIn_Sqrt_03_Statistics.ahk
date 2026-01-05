#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Sqrt_03_Statistics.ahk
 * 
 * DESCRIPTION:
 * Statistical applications of Sqrt() function for variance, standard deviation, and related metrics
 * 
 * FEATURES:
 * - Standard deviation calculations
 * - Variance and population variance
 * - Coefficient of variation
 * - Z-score calculations
 * - Root mean square error (RMSE)
 * - Standard error of the mean
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation & Statistical Methods
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Sqrt
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Sqrt() in statistical formulas
 * - Variadic functions for data sets
 * - Array methods and iteration
 * - Class-based statistics objects
 * - Property getters for calculated values
 * 
 * LEARNING POINTS:
 * 1. Standard deviation measures data spread
 * 2. Variance is the square of standard deviation
 * 3. Population vs sample statistics formulas differ
 * 4. Coefficient of variation normalizes standard deviation
 * 5. RMSE measures prediction accuracy
 */

; ============================================================
; Example 1: Basic Standard Deviation
; ============================================================

/**
 * Calculate mean (average) of numbers
 * 
 * @param {Array} numbers - Array of numbers
 * @returns {Number} - Mean value
 */
Mean(numbers) {
    sum := 0
    for num in numbers {
        sum += num
    }
    return sum / numbers.Length
}

/**
 * Calculate sample variance
 * 
 * @param {Array} numbers - Array of numbers
 * @returns {Number} - Sample variance
 */
Variance(numbers) {
    if (numbers.Length < 2)
        return 0

    mean := Mean(numbers)
    sumSquaredDiff := 0

    for num in numbers {
        diff := num - mean
        sumSquaredDiff += diff * diff
    }

    ; Sample variance uses n-1 (Bessel's correction)
    return sumSquaredDiff / (numbers.Length - 1)
}

/**
 * Calculate sample standard deviation
 * 
 * @param {Array} numbers - Array of numbers
 * @returns {Number} - Sample standard deviation
 */
StandardDeviation(numbers) {
    return Sqrt(Variance(numbers))
}

; Test datasets
datasets := [{
    data: [2, 4, 4, 4, 5, 5, 7, 9], name: "Dataset 1" }, {
        data: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], name: "Uniform 1-10" }, {
            data: [100, 100, 100, 100, 100], name: "No Variation" }, {
                data: [10, 20, 30, 40, 50], name: "Linear Spacing" }, {
                    data: [5, 5, 5, 5, 100], name: "With Outlier"
                }
]

output := "STANDARD DEVIATION ANALYSIS:`n`n"

for ds in datasets {
    mean := Mean(ds.data)
    variance := Variance(ds.data)
    stdDev := StandardDeviation(ds.data)

    output .= ds.name ":"
    output .= "`n  Data: [" StrReplace(Format("{:s}", ds.data), " ", ", ") "]"
    output .= "`n  Mean: " Format("{:.4f}", mean)
    output .= "`n  Variance: " Format("{:.4f}", variance)
    output .= "`n  Std Dev: " Format("{:.4f}", stdDev) "`n`n"
}

MsgBox(output, "Standard Deviation", "Icon!")

; ============================================================
; Example 2: Population vs Sample Statistics
; ============================================================

/**
 * Calculate population variance (using n instead of n-1)
 * 
 * @param {Array} numbers - Array of numbers
 * @returns {Number} - Population variance
 */
PopulationVariance(numbers) {
    if (numbers.Length = 0)
        return 0

    mean := Mean(numbers)
    sumSquaredDiff := 0

    for num in numbers {
        diff := num - mean
        sumSquaredDiff += diff * diff
    }

    return sumSquaredDiff / numbers.Length
}

/**
 * Calculate population standard deviation
 */
PopulationStdDev(numbers) {
    return Sqrt(PopulationVariance(numbers))
}

testData := [12, 15, 18, 20, 22, 25, 28, 30]

output := "POPULATION vs SAMPLE STATISTICS:`n`n"
output .= "Data: [" StrReplace(Format("{:s}", testData), " ", ", ") "]`n"
output .= "Count: " testData.Length "`n`n"

; Population statistics
popVar := PopulationVariance(testData)
popStd := PopulationStdDev(testData)

output .= "Population Statistics (÷n):`n"
output .= "  Variance: " Format("{:.4f}", popVar) "`n"
output .= "  Std Dev: " Format("{:.4f}", popStd) "`n`n"

; Sample statistics
sampVar := Variance(testData)
sampStd := StandardDeviation(testData)

output .= "Sample Statistics (÷(n-1)):`n"
output .= "  Variance: " Format("{:.4f}", sampVar) "`n"
output .= "  Std Dev: " Format("{:.4f}", sampStd) "`n`n"

output .= "Difference:`n"
output .= "  Variance: " Format("{:.4f}", sampVar - popVar) "`n"
output .= "  Std Dev: " Format("{:.4f}", sampStd - popStd) "`n"

MsgBox(output, "Population vs Sample", "Icon!")

; ============================================================
; Example 3: Statistics Class with Full Analysis
; ============================================================

class Statistics {
    __New(data) {
        this.data := data
        this.n := data.Length
    }

    Mean => this._CalculateMean()
    Variance => this._CalculateVariance()
    StdDev => Sqrt(this.Variance)
    Min => this._CalculateMin()
    Max => this._CalculateMax()
    Range => this.Max - this.Min

    _CalculateMean() {
        sum := 0
        for num in this.data
            sum += num
        return sum / this.n
    }

    _CalculateVariance() {
        if (this.n < 2)
            return 0

        mean := this.Mean
        sumSq := 0
        for num in this.data
            sumSq += (num - mean) ** 2

        return sumSq / (this.n - 1)
    }

    _CalculateMin() {
        min := this.data[1]
        for num in this.data
            if (num < min)
                min := num
        return min
    }

    _CalculateMax() {
        max := this.data[1]
        for num in this.data
            if (num > max)
                max := num
        return max
    }

    /**
     * Coefficient of Variation (CV) - normalized std dev
     */
    CoefficientOfVariation() {
        return (this.StdDev / this.Mean) * 100
    }

    /**
     * Calculate Z-score for a value
     */
    ZScore(value) {
        return (value - this.Mean) / this.StdDev
    }

    /**
     * Standard Error of the Mean
     */
    StandardError() {
        return this.StdDev / Sqrt(this.n)
    }

    Summary() {
        output := "Count: " this.n "`n"
        output .= "Mean: " Format("{:.4f}", this.Mean) "`n"
        output .= "Std Dev: " Format("{:.4f}", this.StdDev) "`n"
        output .= "Variance: " Format("{:.4f}", this.Variance) "`n"
        output .= "Min: " Format("{:.4f}", this.Min) "`n"
        output .= "Max: " Format("{:.4f}", this.Max) "`n"
        output .= "Range: " Format("{:.4f}", this.Range) "`n"
        output .= "CV: " Format("{:.2f}", this.CoefficientOfVariation()) "%`n"
        output .= "SE: " Format("{:.4f}", this.StandardError())
        return output
    }
}

; Test with exam scores
examScores := [85, 92, 78, 90, 88, 76, 95, 82, 87, 91]
stats := Statistics(examScores)

output := "COMPREHENSIVE STATISTICAL ANALYSIS:`n`n"
output .= "Exam Scores: [" StrReplace(Format("{:s}", examScores), " ", ", ") "]`n`n"
output .= stats.Summary()

MsgBox(output, "Statistics Class", "Icon!")

; ============================================================
; Example 4: Z-Scores and Standardization
; ============================================================

/**
 * Calculate Z-scores for entire dataset
 */
CalculateZScores(numbers) {
    mean := Mean(numbers)
    stdDev := StandardDeviation(numbers)
    zScores := []

    for num in numbers {
        zScore := (num - mean) / stdDev
        zScores.Push(zScore)
    }

    return zScores
}

/**
 * Identify outliers using Z-score method
 * Typically |Z| > 3 is considered outlier
 */
FindOutliers(numbers, threshold := 3) {
    zScores := CalculateZScores(numbers)
    outliers := []

    Loop numbers.Length {
        if (Abs(zScores[A_Index]) > threshold) {
            outliers.Push({
                value: numbers[A_Index],
                zScore: zScores[A_Index],
                index: A_Index
            })
        }
    }

    return outliers
}

testData := [10, 12, 11, 13, 12, 11, 50, 12, 13, 11, 10]
stats := Statistics(testData)
zScores := CalculateZScores(testData)
outliers := FindOutliers(testData)

output := "Z-SCORE ANALYSIS:`n`n"
output .= "Data: [" StrReplace(Format("{:s}", testData), " ", ", ") "]`n"
output .= "Mean: " Format("{:.4f}", stats.Mean) "`n"
output .= "Std Dev: " Format("{:.4f}", stats.StdDev) "`n`n"

output .= "Z-Scores:`n"
Loop testData.Length {
    output .= "  " testData[A_Index] " → Z = "
    output .= Format("{:.4f}", zScores[A_Index]) "`n"
}

output .= "`nOutliers (|Z| > 3):`n"
if (outliers.Length = 0) {
    output .= "  No outliers found`n"
} else {
    for outlier in outliers {
        output .= "  Value: " outlier.value
        output .= ", Z-score: " Format("{:.4f}", outlier.zScore)
        output .= " (index " outlier.index ")`n"
    }
}

MsgBox(output, "Z-Score Analysis", "Icon!")

; ============================================================
; Example 5: Root Mean Square Error (RMSE)
; ============================================================

/**
 * Calculate Root Mean Square Error
 * Measures accuracy of predictions
 * 
 * @param {Array} actual - Actual values
 * @param {Array} predicted - Predicted values
 * @returns {Number} - RMSE value
 */
RMSE(actual, predicted) {
    if (actual.Length != predicted.Length)
        throw ValueError("Arrays must have same length")

    sumSquaredErrors := 0
    Loop actual.Length {
        error := actual[A_Index] - predicted[A_Index]
        sumSquaredErrors += error * error
    }

    meanSquaredError := sumSquaredErrors / actual.Length
    return Sqrt(meanSquaredError)
}

/**
 * Calculate Mean Absolute Error (for comparison)
 */
MAE(actual, predicted) {
    if (actual.Length != predicted.Length)
        throw ValueError("Arrays must have same length")

    sumAbsErrors := 0
    Loop actual.Length {
        error := Abs(actual[A_Index] - predicted[A_Index])
        sumAbsErrors += error
    }

    return sumAbsErrors / actual.Length
}

; Weather prediction example
actualTemp := [72, 75, 68, 71, 73, 70, 74, 76]
predictedTemp := [71, 76, 67, 72, 74, 69, 73, 77]

rmse := RMSE(actualTemp, predictedTemp)
mae := MAE(actualTemp, predictedTemp)

output := "PREDICTION ACCURACY ANALYSIS:`n`n"
output .= "Actual Temperatures:    [" StrReplace(Format("{:s}", actualTemp), " ", ", ") "]`n"
output .= "Predicted Temperatures: [" StrReplace(Format("{:s}", predictedTemp), " ", ", ") "]`n`n"

output .= "Error Metrics:`n"
output .= "  RMSE: " Format("{:.4f}", rmse) "°F`n"
output .= "  MAE:  " Format("{:.4f}", mae) "°F`n`n"

output .= "Individual Errors:`n"
Loop actualTemp.Length {
    error := actualTemp[A_Index] - predictedTemp[A_Index]
    output .= "  Day " A_Index ": " Format("{:+.1f}", error) "°F`n"
}

MsgBox(output, "RMSE Analysis", "Icon!")

; ============================================================
; Example 6: Confidence Intervals
; ============================================================

/**
 * Calculate confidence interval for the mean
 * Using t-distribution approximation (z-value for large n)
 * 
 * @param {Array} data - Sample data
 * @param {Number} confidence - Confidence level (e.g., 0.95 for 95%)
 * @returns {Object} - {lower, upper, margin}
 */
ConfidenceInterval(data, confidence := 0.95) {
    stats := Statistics(data)
    se := stats.StandardError()

    ; Z-values for common confidence levels
    ; 90%: 1.645, 95%: 1.96, 99%: 2.576
    zValue := confidence = 0.95 ? 1.96
        : confidence = 0.90 ? 1.645
        : confidence = 0.99 ? 2.576
        : 1.96

    margin := zValue * se

    return {
        mean: stats.Mean,
        lower: stats.Mean - margin,
        upper: stats.Mean + margin,
        margin: margin,
        confidence: confidence * 100
    }
}

sampleData := [23, 25, 21, 24, 26, 22, 24, 25, 23, 26, 24, 25]
stats := Statistics(sampleData)

output := "CONFIDENCE INTERVALS:`n`n"
output .= "Sample Data: [" StrReplace(Format("{:s}", sampleData), " ", ", ") "]`n"
output .= "Sample Size: " sampleData.Length "`n"
output .= "Mean: " Format("{:.4f}", stats.Mean) "`n"
output .= "Std Dev: " Format("{:.4f}", stats.StdDev) "`n"
output .= "Std Error: " Format("{:.4f}", stats.StandardError()) "`n`n"

; Calculate different confidence intervals
confidenceLevels := [0.90, 0.95, 0.99]

for level in confidenceLevels {
    ci := ConfidenceInterval(sampleData, level)
    output .= Format("{:.0f}% Confidence Interval:`n", ci.confidence)
    output .= "  " Format("{:.4f}", ci.lower) " to " Format("{:.4f}", ci.upper) "`n"
    output .= "  Margin of Error: ±" Format("{:.4f}", ci.margin) "`n`n"
}

MsgBox(output, "Confidence Intervals", "Icon!")

; ============================================================
; Example 7: Coefficient of Variation Comparison
; ============================================================

/**
 * Compare variability of different datasets using CV
 * CV = (σ/μ) × 100%
 */
CompareVariability(datasets) {
    results := []

    for ds in datasets {
        stats := Statistics(ds.data)
        cv := stats.CoefficientOfVariation()

        results.Push({
            name: ds.name,
            mean: stats.Mean,
            stdDev: stats.StdDev,
            cv: cv,
            interpretation: cv < 15 ? "Low variability"
                : cv < 30 ? "Moderate variability"
                : "High variability"
        })
    }

    return results
}

; Compare different product quality metrics
qualityData := [{
    name: "Product A Weight (g)", data: [100, 101, 99, 100, 102, 101, 100, 99] }, {
        name: "Product B Length (cm)", data: [50, 55, 45, 52, 48, 51, 49, 53] }, {
            name: "Product C Temperature (°C)", data: [20, 21, 20, 22, 19, 21, 20, 21] }, {
                name: "Product D Pressure (PSI)", data: [30, 45, 25, 50, 35, 40, 28, 47]
            }
]

results := CompareVariability(qualityData)

output := "COEFFICIENT OF VARIATION COMPARISON:`n`n"
output .= "CV = (Std Dev / Mean) × 100%`n"
output .= "Used to compare variability across different scales`n`n"

for result in results {
    output .= result.name ":"
    output .= "`n  Mean: " Format("{:.2f}", result.mean)
    output .= "`n  Std Dev: " Format("{:.4f}", result.stdDev)
    output .= "`n  CV: " Format("{:.2f}", result.cv) "%"
    output .= "`n  " result.interpretation "`n`n"
}

MsgBox(output, "Variability Comparison", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                            (
                            SQRT IN STATISTICS REFERENCE:

                            Sample Variance:
                            s² = Σ(xᵢ - x̄)² / (n - 1)

                            Population Variance:
                            σ² = Σ(xᵢ - μ)² / n

                            Sample Standard Deviation:
                            s = √[Σ(xᵢ - x̄)² / (n - 1)]

                            Population Standard Deviation:
                            σ = √[Σ(xᵢ - μ)² / n]

                            Z-Score:
                            Z = (x - μ) / σ

                            Standard Error of Mean:
                            SE = σ / √n

                            Root Mean Square Error:
                            RMSE = √[Σ(yᵢ - ŷᵢ)² / n]

                            Coefficient of Variation:
                            CV = (σ / μ) × 100%

                            Confidence Interval (95%):
                            CI = x̄ ± 1.96 × (σ / √n)

                            Root Mean Square (RMS):
                            RMS = √[(x₁² + x₂² + ... + xₙ²) / n]

                            Key Differences:
                            • Sample (n-1): Unbiased estimator for populations
                            • Population (n): When you have all data
                            • Use sample formulas for most real-world data

                            Interpretation:
                            • Small σ: Data clustered near mean
                            • Large σ: Data widely spread
                            • |Z| > 2: Unusual (95% rule)
                            • |Z| > 3: Very unusual/outlier (99.7% rule)
                            )"

MsgBox(info, "Statistics Reference", "Icon!")
