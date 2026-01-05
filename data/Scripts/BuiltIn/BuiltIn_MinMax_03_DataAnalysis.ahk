#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_MinMax_03_DataAnalysis.ahk
 * 
 * DESCRIPTION:
 * Data analysis applications using Min() and Max() for finding extremes in
 * datasets, statistical analysis, performance metrics, and data summarization
 * 
 * FEATURES:
 * - Find extremes in large datasets
 * - Statistical range analysis
 * - Performance benchmarking
 * - Data quality assessment
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Min.htm
 * https://www.autohotkey.com/docs/v2/lib/Max.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Min/Max for data analysis
 * - Statistical computations
 * - Performance measurement
 * - Array processing patterns
 * 
 * LEARNING POINTS:
 * 1. Min/Max essential for finding extremes
 * 2. Range = Max - Min shows data spread
 * 3. Combine with other statistics
 * 4. Identify outliers and anomalies
 * 5. Track performance bounds
 */

; ============================================================
; Example 1: Dataset Statistics
; ============================================================

/**
 * Calculate comprehensive statistics
 * 
 * @param {Array} data - Numeric dataset
 * @returns {Object} - Statistical summary
 */
CalculateStatistics(data) {
    if (data.Length = 0)
        return { error: "Empty dataset" }

    minValue := Min(data*)
    maxValue := Max(data*)
    rangeValue := maxValue - minValue

    ; Calculate mean
    sum := 0
    for value in data
        sum += value
    mean := sum / data.Length

    ; Calculate median
    sorted := data.Clone()
    SortArray(&sorted)
    middle := sorted.Length / 2
    median := (Mod(sorted.Length, 2) = 0)
        ? (sorted[middle] + sorted[middle + 1]) / 2
        : sorted[Ceil(middle)]

    return {
        count: data.Length,
        min: Round(minValue, 2),
        max: Round(maxValue, 2),
        range: Round(rangeValue, 2),
        mean: Round(mean, 2),
        median: Round(median, 2),
        sum: Round(sum, 2)
    }
}

SortArray(&arr) {
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

; Sales data analysis
salesData := [1250, 980, 1560, 1120, 1380, 1450, 890, 1290, 1520, 1100]
stats := CalculateStatistics(salesData)

output := "Sales Statistics:`n`n"
output .= "Sample Size: " stats.count " days`n`n"
output .= "Minimum: $" Format("{1:,.2f}", stats.min) "`n"
output .= "Maximum: $" Format("{1:,.2f}", stats.max) "`n"
output .= "Range: $" Format("{1:,.2f}", stats.range) "`n"
output .= "Mean: $" Format("{1:,.2f}", stats.mean) "`n"
output .= "Median: $" Format("{1:,.2f}", stats.median) "`n"
output .= "Total: $" Format("{1:,.2f}", stats.sum)

MsgBox(output, "Dataset Statistics", "Icon!")

; ============================================================
; Example 2: Find Extreme Values with Context
; ============================================================

/**
 * Find minimum and maximum with additional context
 * 
 * @param {Array} data - Array of {value, label} objects
 * @returns {Object} - Extremes with context
 */
FindExtremes(data) {
    if (data.Length = 0)
        return { error: "No data" }

    minItem := data[1]
    maxItem := data[1]

    for item in data {
        if (item.value < minItem.value)
            minItem := item
        if (item.value > maxItem.value)
            maxItem := item
    }

    ; Calculate statistics
    values := []
    for item in data
        values.Push(item.value)

    return {
        min: minItem,
        max: maxItem,
        range: maxItem.value - minItem.value,
        avgValue: Round(Min(values*) + ((Max(values*) - Min(values*)) / 2), 2)
    }
}

; Temperature readings
temperatures := [{
    value: 72.5, label: "Monday 9am" }, {
        value: 85.2, label: "Tuesday 2pm" }, {
            value: 68.1, label: "Wednesday 6am" }, {
                value: 91.3, label: "Thursday 3pm" }, {
                    value: 79.8, label: "Friday 12pm"
                }
]

extremes := FindExtremes(temperatures)

output := "Temperature Extremes:`n`n"
output .= "Coldest: " extremes.min.value "°F`n"
output .= "  When: " extremes.min.label "`n`n"
output .= "Hottest: " extremes.max.value "°F`n"
output .= "  When: " extremes.max.label "`n`n"
output .= "Range: " Round(extremes.range, 1) "°F`n"
output .= "Midpoint: " extremes.avgValue "°F"

MsgBox(output, "Extreme Values", "Icon!")

; ============================================================
; Example 3: Performance Benchmarking
; ============================================================

/**
 * Analyze performance metrics
 * 
 * @param {Array} timings - Array of execution times
 * @returns {Object} - Performance analysis
 */
AnalyzePerformance(timings) {
    stats := CalculateStatistics(timings)

    ; Calculate percentiles (approximate)
    sorted := timings.Clone()
    SortArray(&sorted)

    p50 := sorted[Ceil(sorted.Length * 0.5)]  ; Median
    p95 := sorted[Ceil(sorted.Length * 0.95)]
    p99 := sorted[Ceil(sorted.Length * 0.99)]

    return {
        fastest: stats.min,
        slowest: stats.max,
        average: stats.mean,
        median: stats.median,
        p95: Round(p95, 2),
        p99: Round(p99, 2),
        range: stats.range,
        sampleSize: stats.count
    }
}

/**
 * Format performance report
 */
FormatPerformanceReport(perf) {
    report := "Performance Analysis:`n"
    report .= "═══════════════════════════════════`n`n"
    report .= Format("Sample Size: {1} executions`n`n", perf.sampleSize)
    report .= Format("Fastest: {1} ms`n", perf.fastest)
    report .= Format("Slowest: {1} ms`n", perf.slowest)
    report .= Format("Average: {1} ms`n", perf.average)
    report .= Format("Median: {1} ms`n`n", perf.median)
    report .= "Percentiles:`n"
    report .= Format("  95th: {1} ms`n", perf.p95)
    report .= Format("  99th: {1} ms`n`n", perf.p99)
    report .= Format("Range: {1} ms", perf.range)
    return report
}

; API response times (milliseconds)
responseTimes := [45, 52, 48, 156, 51, 49, 203, 47, 50, 53, 178, 46, 51, 54, 189, 48, 52, 49, 167, 51]
perfAnalysis := AnalyzePerformance(responseTimes)
report := FormatPerformanceReport(perfAnalysis)

MsgBox(report, "Performance Metrics", "Icon!")

; ============================================================
; Example 4: Price Monitoring
; ============================================================

/**
 * Track price history and changes
 * 
 * @param {Array} prices - Historical prices
 * @returns {Object} - Price analysis
 */
AnalyzePriceHistory(prices) {
    stats := CalculateStatistics(prices)

    ; Find highest and lowest with indices
    lowestPrice := Min(prices*)
    highestPrice := Max(prices*)
    lowestIndex := 0
    highestIndex := 0

    for index, price in prices {
        if (price = lowestPrice && lowestIndex = 0)
            lowestIndex := index
        if (price = highestPrice && highestIndex = 0)
            highestIndex := index
    }

    ; Calculate current trend
    currentPrice := prices[prices.Length]
    trend := currentPrice > stats.mean ? "Above Average"
        : currentPrice < stats.mean ? "Below Average"
        : "At Average"

    return {
        lowest: lowestPrice,
        lowestIndex: lowestIndex,
        highest: highestPrice,
        highestIndex: highestIndex,
        current: currentPrice,
        average: stats.mean,
        range: stats.range,
        trend: trend,
        volatility: Round((stats.range / stats.mean) * 100, 1)
    }
}

; Stock price history (last 15 days)
stockPrices := [125.50, 127.25, 126.80, 129.10, 128.50, 131.20, 130.75, 128.90,
    132.40, 131.85, 133.20, 129.75, 130.50, 132.10, 131.50]

priceAnalysis := AnalyzePriceHistory(stockPrices)

output := "Stock Price Analysis (15 Days):`n`n"
output .= "Lowest: $" Format("{1:.2f}", priceAnalysis.lowest)
output .= " (Day " priceAnalysis.lowestIndex ")`n"
output .= "Highest: $" Format("{1:.2f}", priceAnalysis.highest)
output .= " (Day " priceAnalysis.highestIndex ")`n"
output .= "Current: $" Format("{1:.2f}", priceAnalysis.current) "`n"
output .= "Average: $" Format("{1:.2f}", priceAnalysis.average) "`n`n"
output .= "Price Range: $" Format("{1:.2f}", priceAnalysis.range) "`n"
output .= "Volatility: " priceAnalysis.volatility "%`n"
output .= "Trend: " priceAnalysis.trend

MsgBox(output, "Price Monitoring", "Icon!")

; ============================================================
; Example 5: Quality Control Analysis
; ============================================================

/**
 * Analyze quality control measurements
 * 
 * @param {Array} measurements - Quality measurements
 * @param {Number} target - Target value
 * @param {Number} tolerance - Acceptable tolerance
 * @returns {Object} - Quality analysis
 */
AnalyzeQuality(measurements, target, tolerance) {
    stats := CalculateStatistics(measurements)

    ; Calculate deviation from target
    minDeviation := Abs(stats.min - target)
    maxDeviation := Abs(stats.max - target)
    avgDeviation := Abs(stats.mean - target)

    ; Count out of spec
    outOfSpec := 0
    for measure in measurements {
        if (Abs(measure - target) > tolerance)
            outOfSpec++
    }

    passRate := ((measurements.Length - outOfSpec) / measurements.Length) * 100

    return {
        target: target,
        tolerance: tolerance,
        min: stats.min,
        max: stats.max,
        mean: stats.mean,
        range: stats.range,
        minDeviation: Round(minDeviation, 2),
        maxDeviation: Round(maxDeviation, 2),
        avgDeviation: Round(avgDeviation, 2),
        outOfSpec: outOfSpec,
        passRate: Round(passRate, 1),
        totalSamples: measurements.Length
    }
}

; Manufacturing measurements
measurements := [99.8, 100.2, 99.9, 100.1, 100.3, 99.7, 100.0, 100.2, 99.8, 100.1]
targetValue := 100.0
tolerance := 0.5

qualityResults := AnalyzeQuality(measurements, targetValue, tolerance)

output := "Quality Control Report:`n`n"
output .= "Target: " qualityResults.target " ± " qualityResults.tolerance "`n"
output .= "Samples: " qualityResults.totalSamples "`n`n"
output .= "Measurements:`n"
output .= "  Min: " qualityResults.min "`n"
output .= "  Max: " qualityResults.max "`n"
output .= "  Mean: " qualityResults.mean "`n"
output .= "  Range: " qualityResults.range "`n`n"
output .= "Deviations from Target:`n"
output .= "  Max: " qualityResults.maxDeviation "`n"
output .= "  Average: " qualityResults.avgDeviation "`n`n"
output .= "Pass Rate: " qualityResults.passRate "%`n"
output .= "Out of Spec: " qualityResults.outOfSpec " samples"

MsgBox(output, "Quality Control", "Icon!")

; ============================================================
; Example 6: Multi-Series Comparison
; ============================================================

/**
 * Compare multiple data series
 * 
 * @param {Object} series - Map of series name to data array
 * @returns {Object} - Comparison results
 */
CompareSeries(series) {
    results := Map()
    overallMin := 999999
    overallMax := -999999

    for name, data in series {
        stats := CalculateStatistics(data)
        results[name] := stats

        if (stats.min < overallMin)
            overallMin := stats.min
        if (stats.max > overallMax)
            overallMax := stats.max
    }

    return {
        series: results,
        overallMin: overallMin,
        overallMax: overallMax,
        overallRange: overallMax - overallMin
    }
}

; Website traffic by region
trafficData := Map(
    "North America", [1250, 1380, 1420, 1290, 1350],
    "Europe", [890, 920, 950, 880, 910],
    "Asia", [1560, 1620, 1590, 1580, 1600],
    "South America", [450, 480, 470, 460, 490]
)

comparison := CompareSeries(trafficData)

output := "Regional Traffic Comparison:`n`n"

for region, stats in comparison.series {
    output .= region . ":`n"
    output .= "  Min: " stats.min " | Max: " stats.max "`n"
    output .= "  Avg: " stats.mean " | Range: " stats.range "`n`n"
}

output .= "Overall:`n"
output .= "  Lowest: " comparison.overallMin "`n"
output .= "  Highest: " comparison.overallMax "`n"
output .= "  Range: " comparison.overallRange

MsgBox(output, "Series Comparison", "Icon!")

; ============================================================
; Example 7: Outlier Detection
; ============================================================

/**
 * Detect outliers using IQR method
 * 
 * @param {Array} data - Dataset
 * @returns {Object} - Outlier analysis
 */
DetectOutliers(data) {
    sorted := data.Clone()
    SortArray(&sorted)

    ; Calculate quartiles
    q1Index := Ceil(sorted.Length * 0.25)
    q3Index := Ceil(sorted.Length * 0.75)
    q1 := sorted[q1Index]
    q3 := sorted[q3Index]
    iqr := q3 - q1

    ; Calculate outlier bounds
    lowerBound := q1 - (1.5 * iqr)
    upperBound := q3 + (1.5 * iqr)

    ; Find outliers
    outliers := []
    for value in data {
        if (value < lowerBound || value > upperBound)
            outliers.Push(value)
    }

    return {
        min: Min(data*),
        max: Max(data*),
        q1: Round(q1, 2),
        q3: Round(q3, 2),
        iqr: Round(iqr, 2),
        lowerBound: Round(lowerBound, 2),
        upperBound: Round(upperBound, 2),
        outliers: outliers,
        outlierCount: outliers.Length,
        dataCount: data.Length
    }
}

; Dataset with outliers
dataset := [23, 25, 24, 26, 25, 24, 150, 25, 26, 24, 25, 23, -10, 26, 25]
outlierAnalysis := DetectOutliers(dataset)

output := "Outlier Detection (IQR Method):`n`n"
output .= "Dataset Size: " outlierAnalysis.dataCount "`n"
output .= "Min: " outlierAnalysis.min " | Max: " outlierAnalysis.max "`n`n"
output .= "Quartiles:`n"
output .= "  Q1: " outlierAnalysis.q1 "`n"
output .= "  Q3: " outlierAnalysis.q3 "`n"
output .= "  IQR: " outlierAnalysis.iqr "`n`n"
output .= "Outlier Bounds:`n"
output .= "  Lower: " outlierAnalysis.lowerBound "`n"
output .= "  Upper: " outlierAnalysis.upperBound "`n`n"

if (outlierAnalysis.outlierCount > 0) {
    output .= "Outliers Found: " outlierAnalysis.outlierCount "`n"
    output .= "Values: "
    for outlier in outlierAnalysis.outliers
        output .= outlier " "
} else {
    output .= "No outliers detected"
}

MsgBox(output, "Outlier Detection", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                (
                MIN/MAX FOR DATA ANALYSIS:

                Basic Statistics:
                ─────────────────
                Essential metrics using Min/Max:

                min = Min(data*)
                max = Max(data*)
                range = max - min
                midpoint = (max + min) / 2

                Range shows data spread:
                • Small range = consistent data
                • Large range = high variability

                Finding Extremes:
                ─────────────────
                Min/Max identify extreme values:
                • Best/worst performance
                • Highest/lowest prices
                • Temperature extremes
                • Speed limits
                • Quality bounds

                Performance Analysis:
                ─────────────────────
                Key metrics:
                • Fastest time: Min(times*)
                • Slowest time: Max(times*)
                • Range: Max - Min
                • Consistency: Range / Average

                Example (Response times in ms):
                times = [45, 52, 48, 156, 51]
                Min = 45 ms (fastest)
                Max = 156 ms (slowest)
                Range = 111 ms (variability)

                Quality Control:
                ────────────────
                Monitor manufacturing:
                • Within spec: [min, max] ⊆ [target-tol, target+tol]
                • Max deviation: Max(|values - target|)
                • Pass rate: % within tolerance

                Price Monitoring:
                ─────────────────
                Track price movements:
                • 52-week low: Min(prices[0..51])
                • 52-week high: Max(prices[0..51])
                • Volatility: (high - low) / average
                • Current vs extremes

                Outlier Detection:
                ──────────────────
                IQR Method:
                Q1 = 25th percentile
                Q3 = 75th percentile
                IQR = Q3 - Q1
                Lower bound = Q1 - 1.5×IQR
                Upper bound = Q3 + 1.5×IQR

                Outliers: values outside [lower, upper]

                Multi-Series Comparison:
                ────────────────────────
                Compare datasets:
                • Find overall min/max
                • Compare ranges
                • Identify leading series
                • Spot anomalies

                Percentiles (Approximation):
                ────────────────────────────
                Sort data, then:
                P50 (median) = sorted[length × 0.5]
                P95 = sorted[length × 0.95]
                P99 = sorted[length × 0.99]

                Useful for SLAs and performance

                Common Analyses:
                ────────────────
                ✓ Summary statistics
                ✓ Performance benchmarks
                ✓ Quality control
                ✓ Price tracking
                ✓ Temperature monitoring
                ✓ Sales analysis
                ✓ Resource utilization
                ✓ Error rates

                Statistical Measures:
                ─────────────────────
                Combine Min/Max with:
                • Mean: Σ(values) / count
                • Median: Middle value
                • Mode: Most common
                • Std Dev: √(variance)

                Normalization:
                ──────────────
                Scale to [0, 1] range:
                normalized = (value - min) / (max - min)

                Example:
                min = 20, max = 100, value = 60
                normalized = (60-20)/(100-20) = 0.5

                Data Quality:
                ─────────────
                Assess with Min/Max:
                • Check for impossible values
                • Identify data entry errors
                • Validate ranges
                • Find missing data patterns

                Best Practices:
                ───────────────
                ✓ Always check for empty arrays
                ✓ Handle single-value arrays
                ✓ Round results appropriately
                ✓ Combine with other statistics
                ✓ Visualize extremes
                ✓ Track trends over time
                ✓ Document acceptable ranges

                Performance Tips:
                ─────────────────
                • Min/Max are O(n) operations
                • Cache results if used repeatedly
                • For large datasets, consider sampling
                • Use with array unpacking: Min(arr*)
                )"

MsgBox(info, "Data Analysis Reference", "Icon!")
