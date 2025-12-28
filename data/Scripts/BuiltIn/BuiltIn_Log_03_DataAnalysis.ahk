#Requires AutoHotkey v2.0

/**
 * BuiltIn_Log_03_DataAnalysis.ahk
 * 
 * DESCRIPTION:
 * Data analysis applications using Log() for transformations, regression, and statistical analysis
 * 
 * FEATURES:
 * - Logarithmic data transformations
 * - Log-log and semi-log plots
 * - Power law detection
 * - Exponential growth analysis
 * - Data normalization with logs
 * - Geometric mean calculations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation & Statistical Analysis
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Log
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Log() for data transformation
 * - Array manipulation and analysis
 * - Statistical calculations
 * - Regression analysis
 * - Data visualization preparation
 * 
 * LEARNING POINTS:
 * 1. Log transforms can linearize exponential data
 * 2. Geometric mean uses logarithms
 * 3. Log transformation reduces skewness
 * 4. Power laws appear linear on log-log plots
 * 5. Logarithms handle wide data ranges
 */

; ============================================================
; Example 1: Logarithmic Data Transformation
; ============================================================

/**
 * Transform data using logarithms
 */
class DataTransformation {
    /**
     * Apply log transformation to dataset
     */
    static LogTransform(data) {
        transformed := []
        for value in data {
            if (value > 0)
                transformed.Push(Log(value))
        }
        return transformed
    }

    /**
     * Apply log10 transformation (for positive data)
     */
    static Log10Transform(data) {
        return DataTransformation.LogTransform(data)
    }

    /**
     * Inverse transformation
     */
    static InverseLogTransform(logData) {
        original := []
        for logValue in logData {
            original.Push(10 ** logValue)
        }
        return original
    }

    /**
     * Calculate statistics before and after transformation
     */
    static CompareTransformation(data) {
        ; Original data statistics
        origMean := DataTransformation._Mean(data)
        origStdDev := DataTransformation._StdDev(data)
        origMin := DataTransformation._Min(data)
        origMax := DataTransformation._Max(data)

        ; Transform data
        logData := DataTransformation.LogTransform(data)

        ; Transformed data statistics
        logMean := DataTransformation._Mean(logData)
        logStdDev := DataTransformation._StdDev(logData)
        logMin := DataTransformation._Min(logData)
        logMax := DataTransformation._Max(logData)

        return {
            original: { mean: origMean, stdDev: origStdDev, min: origMin, max: origMax, range: origMax - origMin },
            transformed: { mean: logMean, stdDev: logStdDev, min: logMin, max: logMax, range: logMax - logMin }
        }
    }

    static _Mean(arr) {
        sum := 0
        for val in arr
            sum += val
        return sum / arr.Length
    }

    static _StdDev(arr) {
        mean := DataTransformation._Mean(arr)
        sumSq := 0
        for val in arr
            sumSq += (val - mean) ** 2
        return Sqrt(sumSq / (arr.Length - 1))
    }

    static _Min(arr) {
        min := arr[1]
        for val in arr
            if (val < min)
                min := val
        return min
    }

    static _Max(arr) {
        max := arr[1]
        for val in arr
            if (val > max)
                max := val
        return max
    }
}

; Highly skewed data (income-like distribution)
skewedData := [25000, 30000, 35000, 40000, 45000, 50000, 60000, 75000, 100000, 150000, 500000]

stats := DataTransformation.CompareTransformation(skewedData)

output := "LOGARITHMIC DATA TRANSFORMATION:`n`n"
output .= "Data: Income-like distribution (highly skewed)`n`n"

output .= "Original Data Statistics:`n"
output .= "  Mean: $" Format("{:,.2f}", stats.original.mean) "`n"
output .= "  Std Dev: $" Format("{:,.2f}", stats.original.stdDev) "`n"
output .= "  Min: $" Format("{:,.2f}", stats.original.min) "`n"
output .= "  Max: $" Format("{:,.2f}", stats.original.max) "`n"
output .= "  Range: $" Format("{:,.2f}", stats.original.range) "`n`n"

output .= "Log-Transformed Data Statistics:`n"
output .= "  Mean: " Format("{:.4f}", stats.transformed.mean) "`n"
output .= "  Std Dev: " Format("{:.4f}", stats.transformed.stdDev) "`n"
output .= "  Min: " Format("{:.4f}", stats.transformed.min) "`n"
output .= "  Max: " Format("{:.4f}", stats.transformed.max) "`n"
output .= "  Range: " Format("{:.4f}", stats.transformed.range) "`n`n"

output .= "Benefit: Transformed data has much smaller range`n"
output .= "and is more suitable for statistical analysis."

MsgBox(output, "Data Transformation", "Icon!")

; ============================================================
; Example 2: Geometric Mean
; ============================================================

/**
 * Calculate geometric mean using logarithms
 * GM = exp(mean(log(x)))  or  GM = 10^(mean(log₁₀(x)))
 */
class GeometricMean {
    /**
     * Calculate geometric mean
     */
    static Calculate(data) {
        if (data.Length = 0)
            return 0

        ; Take log of each value
        sumLog := 0
        for value in data {
            if (value <= 0)
                throw ValueError("Geometric mean requires positive values")
            sumLog += Log(value)
        }

        ; Average of logs
        meanLog := sumLog / data.Length

        ; Exponentiate back
        return 10 ** meanLog
    }

    /**
     * Calculate arithmetic mean for comparison
     */
    static ArithmeticMean(data) {
        sum := 0
        for value in data
            sum += value
        return sum / data.Length
    }

    /**
     * Calculate harmonic mean
     */
    static HarmonicMean(data) {
        sumReciprocals := 0
        for value in data {
            if (value = 0)
                throw ValueError("Harmonic mean undefined for zero values")
            sumReciprocals += 1 / value
        }
        return data.Length / sumReciprocals
    }
}

; Investment returns (multiplicative growth factors)
returns := [1.05, 1.08, 1.03, 1.10, 1.02]  ; 5%, 8%, 3%, 10%, 2% returns

geometricMean := GeometricMean.Calculate(returns)
arithmeticMean := GeometricMean.ArithmeticMean(returns)

output := "GEOMETRIC MEAN CALCULATION:`n`n"
output .= "Investment Returns (growth factors):`n"
for i, ret in returns {
    output .= "  Year " i ": " Format("{:.2f}", ret) " (" Format("{:.1f}", (ret - 1) * 100) "%)`n"
}

output .= "`nArithmetic Mean: " Format("{:.6f}", arithmeticMean)
output .= " (" Format("{:.2f}", (arithmeticMean - 1) * 100) "%)`n"

output .= "Geometric Mean: " Format("{:.6f}", geometricMean)
output .= " (" Format("{:.2f}", (geometricMean - 1) * 100) "%)`n`n"

; Verify with direct calculation
product := 1
for ret in returns
    product *= ret
directGM := product ** (1 / returns.Length)

output .= "Verification (direct): " Format("{:.6f}", directGM) "`n`n"
output .= "Note: Geometric mean is correct for average`n"
output .= "compound growth rate!"

MsgBox(output, "Geometric Mean", "Icon!")

; ============================================================
; Example 3: Detecting Power Laws
; ============================================================

/**
 * Detect and analyze power law relationships
 * y = a × x^b  →  log(y) = log(a) + b × log(x)
 */
class PowerLaw {
    /**
     * Fit power law to data
     * Returns parameters a and b where y = a × x^b
     */
    static Fit(xData, yData) {
        if (xData.Length != yData.Length)
            throw ValueError("Arrays must have same length")

        ; Transform to log-log
        logX := []
        logY := []

        for i, x in xData {
            if (x > 0 && yData[i] > 0) {
                logX.Push(Log(x))
                logY.Push(Log(yData[i]))
            }
        }

        ; Linear regression on log-log data
        regression := PowerLaw._LinearRegression(logX, logY)

        ; Convert back: log(y) = intercept + slope × log(x)
        ; y = 10^intercept × x^slope
        a := 10 ** regression.intercept
        b := regression.slope

        return { a: a, b: b, r2: regression.r2 }
    }

    /**
     * Simple linear regression
     */
    static _LinearRegression(x, y) {
        n := x.Length

        sumX := 0, sumY := 0, sumXY := 0, sumX2 := 0, sumY2 := 0

        Loop n {
            i := A_Index
            sumX += x[i]
            sumY += y[i]
            sumXY += x[i] * y[i]
            sumX2 += x[i] * x[i]
            sumY2 += y[i] * y[i]
        }

        ; Calculate slope and intercept
        slope := (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX)
        intercept := (sumY - slope * sumX) / n

        ; Calculate R²
        meanY := sumY / n
        ssTotal := sumY2 - n * meanY * meanY
        ssResidual := 0

        Loop n {
            i := A_Index
            predicted := intercept + slope * x[i]
            ssResidual += (y[i] - predicted) ** 2
        }

        r2 := 1 - (ssResidual / ssTotal)

        return { slope: slope, intercept: intercept, r2: r2 }
    }

    /**
     * Predict y value
     */
    static Predict(x, a, b) {
        return a * (x ** b)
    }
}

; Example: Zipf's law (word frequency)
; Rank vs Frequency follows power law
ranks := [1, 2, 3, 4, 5, 10, 20, 50, 100]
frequencies := [1000, 520, 350, 270, 220, 105, 55, 24, 11]

fit := PowerLaw.Fit(ranks, frequencies)

output := "POWER LAW DETECTION:`n`n"
output .= "Data: Word Frequency vs Rank (Zipf's Law)`n`n"

output .= "Power Law Fit: y = a × x^b`n"
output .= "  a = " Format("{:.4f}", fit.a) "`n"
output .= "  b = " Format("{:.4f}", fit.b) "`n"
output .= "  R² = " Format("{:.6f}", fit.r2) " (goodness of fit)`n`n"

output .= "Rank    Actual    Predicted    Error`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for i, rank in ranks {
    actual := frequencies[i]
    predicted := PowerLaw.Predict(rank, fit.a, fit.b)
    error := Abs(actual - predicted) / actual * 100

    output .= Format("{:4d}", rank)
    output .= Format("{:10.0f}", actual)
    output .= Format("{:12.1f}", predicted)
    output .= Format("{:11.1f}%", error)
    output .= "`n"
}

output .= "`nInterpretation:`n"
output .= "Exponent ≈ -1 indicates Zipf's law:`n"
output .= "frequency ∝ 1/rank"

MsgBox(output, "Power Law Analysis", "Icon!")

; ============================================================
; Example 4: Exponential Growth Detection
; ============================================================

/**
 * Detect exponential growth using semi-log transformation
 * y = a × e^(bx)  →  ln(y) = ln(a) + bx
 */
class ExponentialFit {
    /**
     * Fit exponential model to data
     * Returns a and b where y = a × 10^(bx)
     */
    static Fit(xData, yData) {
        if (xData.Length != yData.Length)
            throw ValueError("Arrays must have same length")

        ; Transform y to log
        logY := []
        validX := []

        for i, y in yData {
            if (y > 0) {
                logY.Push(Log(y))
                validX.Push(xData[i])
            }
        }

        ; Linear regression on semi-log data
        regression := PowerLaw._LinearRegression(validX, logY)

        ; Convert back: log(y) = intercept + slope × x
        ; y = 10^(intercept + slope × x) = 10^intercept × 10^(slope × x)
        a := 10 ** regression.intercept
        b := regression.slope

        return { a: a, b: b, r2: regression.r2, growthRate: (10 ** b - 1) * 100 }
    }

    /**
     * Predict y value
     */
    static Predict(x, a, b) {
        return a * (10 ** (b * x))
    }

    /**
     * Doubling time
     */
    static DoublingTime(b) {
        return Log(2) / b
    }
}

; Population growth data
years := [0, 5, 10, 15, 20, 25, 30]
population := [1000, 1280, 1640, 2100, 2690, 3450, 4420]

fit := ExponentialFit.Fit(years, population)
doublingTime := ExponentialFit.DoublingTime(fit.b)

output := "EXPONENTIAL GROWTH ANALYSIS:`n`n"
output .= "Data: Population over time`n`n"

output .= "Exponential Fit: y = a × 10^(bx)`n"
output .= "  a = " Format("{:.2f}", fit.a) " (initial value)`n"
output .= "  b = " Format("{:.6f}", fit.b) " (exponent)`n"
output .= "  Growth Rate = " Format("{:.2f}", fit.growthRate) "% per year`n"
output .= "  R² = " Format("{:.6f}", fit.r2) "`n"
output .= "  Doubling Time = " Format("{:.1f}", doublingTime) " years`n`n"

output .= "Year    Actual    Predicted    Error`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for i, year in years {
    actual := population[i]
    predicted := ExponentialFit.Predict(year, fit.a, fit.b)
    error := Abs(actual - predicted) / actual * 100

    output .= Format("{:4d}", year)
    output .= Format("{:9.0f}", actual)
    output .= Format("{:12.0f}", predicted)
    output .= Format("{:10.1f}%", error)
    output .= "`n"
}

MsgBox(output, "Exponential Growth", "Icon!")

; ============================================================
; Example 5: Data Normalization
; ============================================================

/**
 * Normalize data using log transformation
 */
class DataNormalization {
    /**
     * Log normalization
     */
    static LogNormalize(data) {
        normalized := []
        for value in data {
            if (value > 0)
                normalized.Push(Log(value))
        }
        return normalized
    }

    /**
     * Z-score normalization on log-transformed data
     */
    static LogZScore(data) {
        logData := DataNormalization.LogNormalize(data)

        ; Calculate mean and std dev
        mean := DataTransformation._Mean(logData)
        stdDev := DataTransformation._StdDev(logData)

        ; Z-score transformation
        zScores := []
        for logVal in logData {
            zScore := (logVal - mean) / stdDev
            zScores.Push(zScore)
        }

        return { logData: logData, zScores: zScores, mean: mean, stdDev: stdDev }
    }
}

; Website traffic data (highly variable)
traffic := [100, 150, 500, 1200, 350, 5000, 800, 200, 10000, 450]

normalization := DataNormalization.LogZScore(traffic)

output := "DATA NORMALIZATION WITH LOGARITHMS:`n`n"
output .= "Website Traffic Data (highly variable)`n`n"

output .= "Value      Log(Value)   Z-Score`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for i, value in traffic {
    logVal := normalization.logData[i]
    zScore := normalization.zScores[i]

    output .= Format("{:6.0f}", value)
    output .= Format("{:13.4f}", logVal)
    output .= Format("{:11.4f}", zScore)
    output .= "`n"
}

output .= "`nLog Statistics:`n"
output .= "  Mean: " Format("{:.4f}", normalization.mean) "`n"
output .= "  Std Dev: " Format("{:.4f}", normalization.stdDev) "`n`n"

output .= "Benefit: Outliers (10000) have less extreme`n"
output .= "z-scores after log transformation."

MsgBox(output, "Data Normalization", "Icon!")

; ============================================================
; Example 6: Semi-Log Plot Analysis
; ============================================================

/**
 * Analyze data suitable for semi-log plotting
 */
class SemiLogAnalysis {
    /**
     * Determine if data is better represented on semi-log scale
     */
    static AnalyzeScale(xData, yData) {
        ; Linear fit (y vs x)
        linearFit := PowerLaw._LinearRegression(xData, yData)

        ; Semi-log fit (y vs x, but log(y))
        logY := []
        for y in yData {
            if (y > 0)
                logY.Push(Log(y))
            else
                logY.Push(0)
        }
        semiLogFit := PowerLaw._LinearRegression(xData, logY)

        ; Log-log fit
        logX := []
        validLogY := []
        for i, x in xData {
            if (x > 0 && yData[i] > 0) {
                logX.Push(Log(x))
                validLogY.Push(Log(yData[i]))
            }
        }
        logLogFit := PowerLaw._LinearRegression(logX, validLogY)

        return {
            linear: { r2: linearFit.r2, type: "Linear (y vs x)" },
            semiLog: { r2: semiLogFit.r2, type: "Semi-log (log(y) vs x)" },
            logLog: { r2: logLogFit.r2, type: "Log-log (log(y) vs log(x))" }
        }
    }

    /**
     * Recommend best scale
     */
    static RecommendScale(analysis) {
        best := "linear"
        bestR2 := analysis.linear.r2

        if (analysis.semiLog.r2 > bestR2) {
            best := "semiLog"
            bestR2 := analysis.semiLog.r2
        }

        if (analysis.logLog.r2 > bestR2) {
            best := "logLog"
            bestR2 := analysis.logLog.r2
        }

        return best
    }
}

; Exponential-like data
timePoints := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
measurements := [10, 15, 23, 35, 54, 82, 125, 190, 290, 440]

analysis := SemiLogAnalysis.AnalyzeScale(timePoints, measurements)
recommendation := SemiLogAnalysis.RecommendScale(analysis)

output := "SEMI-LOG PLOT ANALYSIS:`n`n"
output .= "Comparing different scales for data representation`n`n"

output .= "Scale Type                    R² (Goodness of Fit)`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

scales := [analysis.linear, analysis.semiLog, analysis.logLog]
for scale in scales {
    output .= Format("{:-28s}", scale.type)
    output .= Format("{:10.6f}", scale.r2)

    ; Mark the best
    if ((scale.type = "Linear (y vs x)" && recommendation = "linear")
        || (scale.type = "Semi-log (log(y) vs x)" && recommendation = "semiLog")
        || (scale.type = "Log-log (log(y) vs log(x))" && recommendation = "logLog"))
        output .= "  ← Best fit"

    output .= "`n"
}

output .= "`nRecommendation: Use "
output .= recommendation = "linear" ? "linear scale"
    : recommendation = "semiLog" ? "semi-log scale (exponential)"
    : "log-log scale (power law)"

MsgBox(output, "Scale Analysis", "Icon!")

; ============================================================
; Example 7: Benford's Law Analysis
; ============================================================

/**
 * Analyze first digits using Benford's Law
 * P(d) = log₁₀(1 + 1/d)
 */
class BenfordsLaw {
    /**
     * Calculate expected frequency for digit d
     */
    static ExpectedFrequency(digit) {
        if (digit < 1 || digit > 9)
            return 0
        return Log(1 + 1 / digit)
    }

    /**
     * Get first digit of a number
     */
    static FirstDigit(number) {
        absNum := Abs(number)
        while (absNum >= 10)
            absNum := Floor(absNum / 10)
        return absNum
    }

    /**
     * Analyze dataset for Benford's Law compliance
     */
    static Analyze(data) {
        ; Count first digits
        counts := Map()
        Loop 9
            counts[A_Index] := 0

        for value in data {
            digit := BenfordsLaw.FirstDigit(value)
            if (digit >= 1 && digit <= 9)
                counts[digit]++
        }

        ; Calculate frequencies
        total := data.Length
        results := []

        Loop 9 {
            digit := A_Index
            observed := counts[digit] / total
            expected := BenfordsLaw.ExpectedFrequency(digit)
            difference := Abs(observed - expected)

            results.Push({
                digit: digit,
                count: counts[digit],
                observed: observed,
                expected: expected,
                difference: difference
            })
        }

        return results
    }
}

; Population data (should follow Benford's Law)
populations := [1420, 331, 273, 220, 217, 206, 145, 128, 127, 126,
    84, 68, 67, 65, 60, 51, 47, 46, 45, 42]

analysis := BenfordsLaw.Analyze(populations)

output := "BENFORD'S LAW ANALYSIS:`n`n"
output .= "Dataset: Country populations (millions)`n`n"

output .= "Digit  Count   Observed   Expected   Difference`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for result in analysis {
    output .= Format("{:5d}", result.digit)
    output .= Format("{:7d}", result.count)
    output .= Format("{:11.3f}", result.observed)
    output .= Format("{:11.3f}", result.expected)
    output .= Format("{:13.3f}", result.difference)
    output .= "`n"
}

output .= "`nBenford's Law: P(d) = log₁₀(1 + 1/d)`n"
output .= "Natural datasets often follow this distribution."

MsgBox(output, "Benford's Law", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
LOG() IN DATA ANALYSIS REFERENCE:

Data Transformations:
y' = log₁₀(y)
Purpose: Reduce skewness, stabilize variance

Geometric Mean:
GM = 10^(mean(log₁₀(x)))
Use: Multiplicative processes (growth rates)

Power Law Detection:
y = ax^b → log(y) = log(a) + b×log(x)
Plot: log-log scale appears linear

Exponential Detection:
y = a×10^(bx) → log(y) = log(a) + bx
Plot: Semi-log scale appears linear

Scale Selection:
• Linear: Additive relationships
• Semi-log: Exponential growth/decay
• Log-log: Power laws, scaling

Benford's Law:
P(d) = log₁₀(1 + 1/d)
First digit distribution in natural data

Benefits of Log Transformation:
✓ Linearizes multiplicative relationships
✓ Reduces impact of outliers
✓ Stabilizes variance
✓ Makes skewed data more normal
✓ Easier to interpret ratios

Applications:
✓ Regression analysis
✓ Time series analysis
✓ Financial data
✓ Population studies
✓ Scientific measurements
✓ Machine learning preprocessing
)"

MsgBox(info, "Log in Data Analysis Reference", "Icon!")
