#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Floor_03_Binning.ahk
 * 
 * DESCRIPTION:
 * Data binning and histogram creation using Floor() for grouping continuous
 * data into discrete bins, creating histograms, and statistical analysis
 * 
 * FEATURES:
 * - Data binning and categorization
 * - Histogram creation and analysis
 * - Range grouping and bucketing
 * - Statistical distribution visualization
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Floor.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Floor() for bin calculations
 * - Map objects for counting
 * - Statistical data processing
 * - Data visualization techniques
 * 
 * LEARNING POINTS:
 * 1. Binning groups continuous data into ranges
 * 2. Bin formula: Floor(value / binSize) * binSize
 * 3. Creates histograms and distributions
 * 4. Simplifies data analysis
 * 5. Reveals patterns in data
 */

; ============================================================
; Example 1: Basic Data Binning
; ============================================================

/**
 * Bin a single value
 * 
 * @param {Number} value - Value to bin
 * @param {Number} binSize - Bin width
 * @returns {Object} - Bin information
 */
BinValue(value, binSize) {
    binIndex := Floor(value / binSize)
    binStart := binIndex * binSize
    binEnd := binStart + binSize
    position := value - binStart

    return {
        value: value,
        binSize: binSize,
        binIndex: binIndex,
        binStart: binStart,
        binEnd: binEnd,
        binRange: Format("[{1}, {2})", binStart, binEnd),
        positionInBin: Round(position, 2)
    }
}

; Test binning individual values
testValues := [15, 47, 88, 103, 199]
binWidth := 20

output := "Value Binning (Bin Size: " binWidth "):`n`n"

for value in testValues {
    binned := BinValue(value, binWidth)

    output .= Format("{1} → Bin {2} {3}`n",
        binned.value, binned.binIndex, binned.binRange)
}

output .= "`nFormula: Floor(value / binSize) × binSize"

MsgBox(output, "Basic Binning", "Icon!")

; ============================================================
; Example 2: Create Histogram
; ============================================================

/**
 * Create histogram from data
 * 
 * @param {Array} data - Array of numeric values
 * @param {Number} binSize - Bin width
 * @returns {Object} - Histogram data
 */
CreateHistogram(data, binSize) {
    bins := Map()

    ; Bin each value
    for value in data {
        binIndex := Floor(value / binSize)
        binStart := binIndex * binSize

        if (!bins.Has(binStart))
            bins[binStart] := 0
        bins[binStart] := bins[binStart] + 1
    }

    ; Convert to sorted array
    binArray := []
    for binStart, count in bins {
        binArray.Push({
            start: binStart,
            end: binStart + binSize,
            count: count,
            range: Format("[{1}, {2})", binStart, binStart + binSize)
        })
    }

    ; Sort by bin start
    SortBins(&binArray)

    return {
        data: data,
        binSize: binSize,
        bins: binArray,
        totalCount: data.Length
    }
}

SortBins(&arr) {
    ; Simple bubble sort
    Loop arr.Length - 1 {
        i := A_Index
        Loop arr.Length - i {
            j := A_Index
            if (arr[j].start > arr[j + 1].start) {
                temp := arr[j]
                arr[j] := arr[j + 1]
                arr[j + 1] := temp
            }
        }
    }
}

/**
 * Format histogram as text
 */
FormatHistogram(histogram) {
    output := "Histogram:`n"
    output .= "Bin Size: " histogram.binSize "`n"
    output .= "Total: " histogram.totalCount " values`n`n"

    maxCount := 0
    for bin in histogram.bins {
        if (bin.count > maxCount)
            maxCount := bin.count
    }

    ; Display bins
    for bin in histogram.bins {
        ; Create bar
        barLength := Round((bin.count / maxCount) * 20, 0)
        bar := ""
        Loop barLength
            bar .= "█"

        output .= Format("{1}: {2} {3}`n",
            bin.range, bar, bin.count)
    }

    return output
}

; Test data: ages
ages := [22, 25, 31, 28, 45, 52, 38, 41, 29, 33, 55, 48, 27, 35, 42, 50, 26, 39, 44, 51]
ageHistogram := CreateHistogram(ages, 10)

output := FormatHistogram(ageHistogram)

MsgBox(output, "Age Distribution", "Icon!")

; ============================================================
; Example 3: Grade Distribution
; ============================================================

/**
 * Bin test scores into grade ranges
 * 
 * @param {Array} scores - Test scores (0-100)
 * @returns {Object} - Grade distribution
 */
CreateGradeDistribution(scores) {
    gradeBins := Map(
        "A", { min: 90, max: 100, count: 0 },
        "B", { min: 80, max: 89, count: 0 },
        "C", { min: 70, max: 79, count: 0 },
        "D", { min: 60, max: 69, count: 0 },
        "F", { min: 0, max: 59, count: 0 }
    )

    ; Bin scores
    for score in scores {
        if (score >= 90)
            gradeBins["A"].count++
        else if (score >= 80)
            gradeBins["B"].count++
        else if (score >= 70)
            gradeBins["C"].count++
        else if (score >= 60)
            gradeBins["D"].count++
        else
            gradeBins["F"].count++
    }

    ; Calculate statistics
    sum := 0
    for score in scores
        sum += score
    average := Round(sum / scores.Length, 1)

    return {
        scores: scores,
        bins: gradeBins,
        average: average,
        total: scores.Length
    }
}

; Test scores
testScores := [92, 88, 76, 95, 84, 71, 89, 93, 67, 85, 78, 91, 82, 74, 96, 88, 65, 79, 90, 72]
gradesDist := CreateGradeDistribution(testScores)

output := "Grade Distribution:`n`n"
output .= "Total Students: " gradesDist.total "`n"
output .= "Class Average: " gradesDist.average "`n`n"

for grade, bin in gradesDist.bins {
    percent := Round((bin.count / gradesDist.total) * 100, 1)
    bar := ""
    Loop Round((bin.count / gradesDist.total) * 20, 0)
        bar .= "█"

    output .= Format("{1} ({2}-{3}): {4} {5} ({6}%)`n",
        grade, bin.min, bin.max, bar, bin.count, percent)
}

MsgBox(output, "Grade Distribution", "Icon!")

; ============================================================
; Example 4: Price Range Bucketing
; ============================================================

/**
 * Bucket prices into ranges
 * 
 * @param {Array} prices - Product prices
 * @param {Number} bucketSize - Price bucket size
 * @returns {Object} - Price distribution
 */
BucketPrices(prices, bucketSize) {
    buckets := Map()

    for price in prices {
        bucketStart := Floor(price / bucketSize) * bucketSize
        if (!buckets.Has(bucketStart))
            buckets[bucketStart] := []
        buckets[bucketStart].Push(price)
    }

    ; Create sorted array
    bucketArray := []
    for start, items in buckets {
        avgPrice := 0
        for price in items
            avgPrice += price
        avgPrice := Round(avgPrice / items.Length, 2)

        bucketArray.Push({
            start: start,
            end: start + bucketSize,
            count: items.Length,
            average: avgPrice,
            range: Format("${1}-${2}", start, start + bucketSize - 0.01)
        })
    }

    SortBins(&bucketArray)

    return {
        bucketSize: bucketSize,
        buckets: bucketArray,
        total: prices.Length
    }
}

; Product prices
productPrices := [19.99, 45.50, 12.95, 99.00, 67.50, 23.99, 89.99, 34.50, 15.00, 78.50, 55.00, 91.50, 28.99]
priceBuckets := BucketPrices(productPrices, 20)

output := "Price Distribution ($" priceBuckets.bucketSize " buckets):`n`n"

for bucket in priceBuckets.buckets {
    output .= Format("{1}: {2} products (Avg: ${3:.2f})`n",
        bucket.range, bucket.count, bucket.average)
}

MsgBox(output, "Price Ranges", "Icon!")

; ============================================================
; Example 5: Time-Based Binning
; ============================================================

/**
 * Bin timestamps into time intervals
 * 
 * @param {Array} hours - Array of hour values (0-23.99)
 * @param {Number} intervalHours - Interval size in hours
 * @returns {Object} - Time distribution
 */
BinTimeData(hours, intervalHours) {
    bins := Map()

    for hour in hours {
        binStart := Floor(hour / intervalHours) * intervalHours
        if (!bins.Has(binStart))
            bins[binStart] := 0
        bins[binStart] := bins[binStart] + 1
    }

    ; Create sorted array
    binArray := []
    for start, count in bins {
        endTime := start + intervalHours
        binArray.Push({
            start: start,
            end: endTime,
            count: count,
            range: FormatTimeRange(start, endTime)
        })
    }

    SortBins(&binArray)

    return {
        intervalHours: intervalHours,
        bins: binArray,
        total: hours.Length
    }
}

FormatTimeRange(startHour, endHour) {
    startH := Floor(startHour)
    startM := Floor((startHour - startH) * 60)
    endH := Floor(endHour)
    endM := Floor((endHour - endH) * 60)

    return Format("{1:02d}:{2:02d}-{3:02d}:{4:02d}",
        startH, startM, endH, endM)
}

; Website traffic hours (24-hour format)
trafficHours := [9.5, 10.2, 14.7, 15.1, 16.8, 9.8, 13.5, 15.5, 10.5, 14.2, 16.3, 11.2, 15.8, 17.2, 9.3]
timeDistribution := BinTimeData(trafficHours, 2)  ; 2-hour intervals

output := "Website Traffic Distribution (2-hour intervals):`n`n"

maxCount := 0
for bin in timeDistribution.bins {
    if (bin.count > maxCount)
        maxCount := bin.count
}

for bin in timeDistribution.bins {
    bar := ""
    Loop Round((bin.count / maxCount) * 15, 0)
        bar .= "█"

    output .= Format("{1}: {2} {3}`n", bin.range, bar, bin.count)
}

MsgBox(output, "Traffic by Time", "Icon!")

; ============================================================
; Example 6: Statistical Binning with Analysis
; ============================================================

/**
 * Create detailed statistical bins
 * 
 * @param {Array} data - Numeric data
 * @param {Number} numBins - Desired number of bins
 * @returns {Object} - Statistical binning
 */
CreateStatisticalBins(data, numBins) {
    ; Find min and max
    minVal := data[1]
    maxVal := data[1]
    sum := 0

    for value in data {
        if (value < minVal)
            minVal := value
        if (value > maxVal)
            maxVal := value
        sum += value
    }

    ; Calculate bin size
    dataRange := maxVal - minVal
    binSize := dataRange / numBins

    ; Create bins
    bins := Map()
    for value in data {
        binIndex := Floor((value - minVal) / binSize)
        if (binIndex = numBins)  ; Handle max value edge case
            binIndex := numBins - 1

        binStart := minVal + (binIndex * binSize)

        if (!bins.Has(binStart))
            bins[binStart] := { count: 0, values: [] }

        bins[binStart].count++
        bins[binStart].values.Push(value)
    }

    ; Convert to array
    binArray := []
    for start, binData in bins {
        binArray.Push({
            start: Round(start, 2),
            end: Round(start + binSize, 2),
            count: binData.count,
            frequency: Round((binData.count / data.Length) * 100, 1)
        })
    }

    SortBins(&binArray)

    return {
        data: data,
        numBins: numBins,
        binSize: Round(binSize, 2),
        bins: binArray,
        min: minVal,
        max: maxVal,
        mean: Round(sum / data.Length, 2),
        range: Round(dataRange, 2)
    }
}

; Response times in milliseconds
responseTimes := [45, 52, 67, 123, 89, 156, 203, 78, 91, 134, 167, 98, 112, 145, 178, 201, 87, 102, 156, 189]
rtBins := CreateStatisticalBins(responseTimes, 5)

output := "Response Time Distribution:`n`n"
output .= Format("Range: {1}-{2} ms`n", rtBins.min, rtBins.max)
output .= "Mean: " rtBins.mean " ms`n"
output .= "Bins: " rtBins.numBins " (Size: " rtBins.binSize " ms)`n`n"

for bin in rtBins.bins {
    bar := ""
    Loop Round(bin.frequency / 5, 0)
        bar .= "█"

    output .= Format("[{1}, {2}): {3} {4} ({5}%)`n",
        bin.start, bin.end, bar, bin.count, bin.frequency)
}

MsgBox(output, "Response Times", "Icon!")

; ============================================================
; Example 7: Multi-Dimensional Binning
; ============================================================

/**
 * Bin 2D data points into grid cells
 * 
 * @param {Array} points - Array of {x, y} points
 * @param {Number} binSizeX - X bin size
 * @param {Number} binSizeY - Y bin size
 * @returns {Object} - 2D histogram
 */
Create2DHistogram(points, binSizeX, binSizeY) {
    bins := Map()

    for point in points {
        binX := Floor(point.x / binSizeX) * binSizeX
        binY := Floor(point.y / binSizeY) * binSizeY
        key := binX "," binY

        if (!bins.Has(key))
            bins[key] := { x: binX, y: binY, count: 0, points: [] }

        bins[key].count++
        bins[key].points.Push(point)
    }

    ; Convert to array
    binArray := []
    for key, bin in bins {
        binArray.Push(bin)
    }

    return {
        binSizeX: binSizeX,
        binSizeY: binSizeY,
        bins: binArray,
        totalPoints: points.Length
    }
}

/**
 * Find hotspots (bins with most points)
 */
FindHotspots(histogram, topN := 3) {
    sorted := histogram.bins.Clone()

    ; Sort by count (descending)
    Loop sorted.Length - 1 {
        i := A_Index
        Loop sorted.Length - i {
            j := A_Index
            if (sorted[j].count < sorted[j + 1].count) {
                temp := sorted[j]
                sorted[j] := sorted[j + 1]
                sorted[j + 1] := temp
            }
        }
    }

    hotspots := []
    Loop Min(topN, sorted.Length)
        hotspots.Push(sorted[A_Index])

    return hotspots
}

; Customer locations (simplified coordinates)
locations := [{
    x: 125, y: 340 }, { x: 130, y: 345 }, { x: 435, y: 120 }, {
        x: 128, y: 342 }, { x: 440, y: 125 }, { x: 220, y: 580 }, {
            x: 122, y: 338 }, { x: 225, y: 582 }, { x: 438, y: 122 }, {
                x: 580, y: 690 }, { x: 585, y: 695 }, { x: 582, y: 692
                }
]

locationHist := Create2DHistogram(locations, 100, 100)
hotspots := FindHotspots(locationHist, 3)

output := "Location Clustering (100×100 bins):`n`n"
output .= "Total Locations: " locationHist.totalPoints "`n"
output .= "Active Grid Cells: " locationHist.bins.Length "`n`n"
output .= "Top 3 Hotspots:`n"

for index, hotspot in hotspots {
    output .= Format("{1}. [{2}, {3}]: {4} locations`n",
        index, hotspot.x, hotspot.y, hotspot.count)
}

MsgBox(output, "Location Hotspots", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            FLOOR() FOR DATA BINNING & HISTOGRAMS:

            Binning Concept:
            ────────────────
            Converting continuous data into discrete
            categories (bins) for analysis.

            Basic Bin Formula:
            ──────────────────
            binIndex = Floor(value / binSize)
            binStart = binIndex × binSize
            binEnd = binStart + binSize

            Example (Bin size 20):
            Value 47:
            binIndex = Floor(47/20) = 2
            binStart = 2 × 20 = 40
            binEnd = 40 + 20 = 60
            Bin: [40, 60)

            Histogram Creation:
            ───────────────────
            1. Choose bin size
            2. For each value: binIndex = Floor(value/binSize)
            3. Count values in each bin
            4. Visualize distribution

            Ages with 10-year bins:
            [20, 30): 5 people
            [30, 40): 8 people
            [40, 50): 6 people

            Calculating Bin Size:
            ─────────────────────
            Method 1: Fixed size
            binSize = 10, 20, 50, etc.

            Method 2: From number of bins
            dataRange = max - min
            binSize = dataRange / numBins

            Method 3: Sturges' Rule
            numBins = Ceil(Log2(n) + 1)
            where n = data count

            2D Binning:
            ───────────
            binX = Floor(x / binSizeX) × binSizeX
            binY = Floor(y / binSizeY) × binSizeY

            Bins become grid cells:
            (125, 340) with 100×100 bins → [100, 300]
            (435, 120) with 100×100 bins → [400, 100]

            Applications:
            ─────────────
            ✓ Age distributions
            ✓ Price ranges
            ✓ Time-of-day patterns
            ✓ Geographic clustering
            ✓ Performance metrics
            ✓ Quality control
            ✓ Data visualization

            Grade Binning:
            ──────────────
            Custom bins for grades:
            A: [90, 100]
            B: [80, 90)
            C: [70, 80)
            etc.

            Use conditional logic instead of formula

            Time Binning:
            ─────────────
            Hourly data into intervals:
            2-hour bins: Floor(hour / 2) × 2
            4-hour bins: Floor(hour / 4) × 4

            Examples:
            15.5 hours → Floor(15.5/2)×2 = 14
            (14:00-16:00 bin)

            Histogram Interpretation:
            ──────────────────────────
            • Peak bins: Most common values
            • Spread: Data variability
            • Skewness: Distribution asymmetry
            • Gaps: Missing ranges

            Bin Selection Tips:
            ───────────────────
            ✓ Too few bins: Lose detail
            ✓ Too many bins: Sparse, noisy
            ✓ Typical: 5-20 bins
            ✓ Consider data range
            ✓ Round to nice numbers

            Frequency Calculation:
            ──────────────────────
            frequency = (bin_count / total_count) × 100%

            Shows percentage in each bin

            Common Patterns:
            ────────────────
            • Uniform: Equal distribution
            • Normal: Bell curve
            • Bimodal: Two peaks
            • Skewed: Asymmetric
            )"

MsgBox(info, "Binning Reference", "Icon!")
