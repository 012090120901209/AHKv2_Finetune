#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_NumGet_02_FloatingPoint.ahk
 * 
 * DESCRIPTION:
 * Comprehensive guide to reading floating-point numbers using NumGet.
 * Covers Float (32-bit) and Double (64-bit) types with precision handling.
 * 
 * FEATURES:
 * - Reading Float (single precision) values
 * - Reading Double (double precision) values
 * - Precision and rounding considerations
 * - Special floating-point values (Infinity, NaN)
 * - Scientific notation handling
 * - Practical floating-point data processing
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - NumGet Function
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - NumGet with "Float" type (4 bytes, IEEE 754 single precision)
 * - NumGet with "Double" type (8 bytes, IEEE 754 double precision)
 * - Floating-point precision handling
 * - Binary representation of floats
 * - Conversion between integer and float representations
 * 
 * LEARNING POINTS:
 * 1. Float uses 4 bytes, Double uses 8 bytes
 * 2. Precision differs: Float ~7 digits, Double ~15 digits
 * 3. IEEE 754 standard defines float representation
 * 4. Special values exist: +/-Infinity, NaN, -0
 * 5. Binary floats cannot exactly represent all decimal numbers
 */

; ================================================================================================
; EXAMPLE 1: Basic Float and Double Reading
; ================================================================================================
; Demonstrates reading basic floating-point values

Example1_BasicFloatReading() {
    ; Create buffer for float and double values
    buf := Buffer(32)

    ; Write various float values
    NumPut("Float", 3.14159, buf, 0)
    NumPut("Float", -273.15, buf, 4)
    NumPut("Float", 0.00001, buf, 8)
    NumPut("Float", 999999.9, buf, 12)

    ; Write various double values
    NumPut("Double", 3.141592653589793, buf, 16)
    NumPut("Double", -273.15, buf, 24)

    ; Read float values
    pi_float := NumGet(buf, 0, "Float")
    temp_float := NumGet(buf, 4, "Float")
    small_float := NumGet(buf, 8, "Float")
    large_float := NumGet(buf, 12, "Float")

    ; Read double values
    pi_double := NumGet(buf, 16, "Double")
    temp_double := NumGet(buf, 24, "Double")

    ; Compare precision
    result := "Basic Float and Double Reading:`n`n"

    result .= "Float Values (4 bytes, ~7 digit precision):`n"
    result .= "  Offset 0: " . Format("{:.6f}", pi_float) . " (Pi approximation)`n"
    result .= "  Offset 4: " . Format("{:.2f}", temp_float) . " (absolute zero in °C)`n"
    result .= "  Offset 8: " . Format("{:.8f}", small_float) . " (small value)`n"
    result .= "  Offset 12: " . Format("{:.1f}", large_float) . " (large value)`n`n"

    result .= "Double Values (8 bytes, ~15 digit precision):`n"
    result .= "  Offset 16: " . Format("{:.15f}", pi_double) . " (Pi, more precise)`n"
    result .= "  Offset 24: " . Format("{:.2f}", temp_double) . " (same temperature)`n`n"

    result .= "Precision Comparison (Pi):`n"
    result .= "  Float:  " . Format("{:.15f}", pi_float) . "`n"
    result .= "  Double: " . Format("{:.15f}", pi_double) . "`n"
    result .= "  Difference: " . Format("{:.15e}", Abs(pi_double - pi_float))

    MsgBox(result, "Example 1: Basic Float/Double", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Precision and Rounding
; ================================================================================================
; Shows precision differences and rounding behavior

Example2_PrecisionAndRounding() {
    ; Create buffer
    buf := Buffer(64)

    ; Test values that show precision limits
    testValues := [
        1.0 / 3.0,              ; Repeating decimal
        0.1 + 0.2,              ; Classic floating-point issue
        1234567.89,             ; Near float precision limit
        123456789012345.0,      ; Beyond float precision
        0.123456789012345       ; Small fraction
    ]

    ; Write and read as Float
    floatResults := []
    loop testValues.Length {
        offset := (A_Index - 1) * 4
        NumPut("Float", testValues[A_Index], buf, offset)
        floatResults.Push(NumGet(buf, offset, "Float"))
    }

    ; Write and read as Double
    doubleResults := []
    loop testValues.Length {
        offset := (A_Index - 1) * 8
        NumPut("Double", testValues[A_Index], buf, offset)
        doubleResults.Push(NumGet(buf, offset, "Double"))
    }

    ; Display results
    result := "Precision and Rounding Examples:`n`n"

    result .= "Test Value              | Float Result           | Double Result`n"
    result .= "------------------------|------------------------|---------------------------`n"

    loop testValues.Length {
        original := testValues[A_Index]
        floatVal := floatResults[A_Index]
        doubleVal := doubleResults[A_Index]

        result .= Format("{:-23.15f}", original) . " | "
        result .= Format("{:-22.15f}", floatVal) . " | "
        result .= Format("{:-25.15f}", doubleVal) . "`n"
    }

    result .= "`nKey Observations:`n"
    result .= "- Float loses precision after ~7 significant digits`n"
    result .= "- Double maintains precision to ~15 significant digits`n"
    result .= "- Some decimals cannot be exactly represented in binary"

    MsgBox(result, "Example 2: Precision & Rounding", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Special Floating-Point Values
; ================================================================================================
; Demonstrates special IEEE 754 values

Example3_SpecialValues() {
    ; Create buffer
    buf := Buffer(48)

    ; Create special values using integer bit patterns
    ; Positive infinity: 0x7F800000 (float), 0x7FF0000000000000 (double)
    ; Negative infinity: 0xFF800000 (float), 0xFFF0000000000000 (double)
    ; NaN: 0x7FC00000 (float), 0x7FF8000000000000 (double)
    ; Negative zero: 0x80000000 (float), 0x8000000000000000 (double)

    ; Write special float values using integer representation
    NumPut("UInt", 0x7F800000, buf, 0)    ; +Infinity
    NumPut("UInt", 0xFF800000, buf, 4)    ; -Infinity
    NumPut("UInt", 0x7FC00000, buf, 8)    ; NaN
    NumPut("UInt", 0x80000000, buf, 12)   ; -0.0
    NumPut("UInt", 0x00000000, buf, 16)   ; +0.0

    ; Write special double values
    NumPut("UInt64", 0x7FF0000000000000, buf, 20)  ; +Infinity
    NumPut("UInt64", 0xFFF0000000000000, buf, 28)  ; -Infinity
    NumPut("UInt64", 0x7FF8000000000000, buf, 36)  ; NaN
    NumPut("UInt64", 0x8000000000000000, buf, 44)  ; -0.0

    ; Read as floats
    posInf_f := NumGet(buf, 0, "Float")
    negInf_f := NumGet(buf, 4, "Float")
    nan_f := NumGet(buf, 8, "Float")
    negZero_f := NumGet(buf, 12, "Float")
    posZero_f := NumGet(buf, 16, "Float")

    ; Read as doubles
    posInf_d := NumGet(buf, 20, "Double")
    negInf_d := NumGet(buf, 28, "Double")
    nan_d := NumGet(buf, 36, "Double")
    negZero_d := NumGet(buf, 44, "Double")

    ; Test special properties
    CheckSpecial(value) {
        if value = ""
            return "Empty"
        if !IsNumber(value)
            return "Not a number"
        if value > 1.0e308
            return "+Infinity"
        if value < -1.0e308
            return "-Infinity"
        if value != value  ; NaN != NaN
            return "NaN"
        if value = 0 {
            ; Can't easily distinguish +0 from -0 in AHK
            return "Zero"
        }
        return "Normal: " . value
    }

    ; Display results
    result := "Special Floating-Point Values:`n`n"

    result .= "Float Special Values:`n"
    result .= "  +Infinity: " . CheckSpecial(posInf_f) . "`n"
    result .= "  -Infinity: " . CheckSpecial(negInf_f) . "`n"
    result .= "  NaN: " . CheckSpecial(nan_f) . "`n"
    result .= "  -0.0: " . CheckSpecial(negZero_f) . "`n"
    result .= "  +0.0: " . CheckSpecial(posZero_f) . "`n`n"

    result .= "Double Special Values:`n"
    result .= "  +Infinity: " . CheckSpecial(posInf_d) . "`n"
    result .= "  -Infinity: " . CheckSpecial(negInf_d) . "`n"
    result .= "  NaN: " . CheckSpecial(nan_d) . "`n"
    result .= "  -0.0: " . CheckSpecial(negZero_d) . "`n`n"

    result .= "Properties:`n"
    result .= "  Infinity > any normal number`n"
    result .= "  NaN != NaN (unique property)`n"
    result .= "  -0.0 == +0.0 in comparisons`n"
    result .= "  Used for error handling and limits"

    MsgBox(result, "Example 3: Special Values", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Scientific and Engineering Data
; ================================================================================================
; Practical example with scientific measurements

Example4_ScientificData() {
    ; Simulate scientific measurements in a buffer
    ; Each record: [timestamp(double)][temperature(float)][pressure(float)][humidity(float)]
    recordSize := 8 + 4 + 4 + 4  ; 20 bytes
    recordCount := 10
    buf := Buffer(recordSize * recordCount)

    ; Generate sample data
    baseTime := 1700000000.0  ; Unix timestamp
    loop recordCount {
        offset := (A_Index - 1) * recordSize

        ; Timestamp (increasing by 60 seconds)
        timestamp := baseTime + (A_Index - 1) * 60.0
        NumPut("Double", timestamp, buf, offset)

        ; Temperature in Celsius (varying)
        temp := 20.0 + Random(-5.0, 5.0)
        NumPut("Float", temp, buf, offset + 8)

        ; Pressure in hPa (varying)
        pressure := 1013.25 + Random(-10.0, 10.0)
        NumPut("Float", pressure, buf, offset + 12)

        ; Humidity percentage (varying)
        humidity := 50.0 + Random(-15.0, 15.0)
        NumPut("Float", humidity, buf, offset + 16)
    }

    ; Process data: calculate statistics
    tempSum := 0.0
    pressureSum := 0.0
    humiditySum := 0.0

    tempMin := 999.0
    tempMax := -999.0

    loop recordCount {
        offset := (A_Index - 1) * recordSize

        temp := NumGet(buf, offset + 8, "Float")
        pressure := NumGet(buf, offset + 12, "Float")
        humidity := NumGet(buf, offset + 16, "Float")

        tempSum += temp
        pressureSum += pressure
        humiditySum += humidity

        if temp < tempMin
            tempMin := temp
        if temp > tempMax
            tempMax := temp
    }

    tempAvg := tempSum / recordCount
    pressureAvg := pressureSum / recordCount
    humidityAvg := humiditySum / recordCount

    ; Read first and last records for display
    firstTime := NumGet(buf, 0, "Double")
    firstTemp := NumGet(buf, 8, "Float")
    firstPressure := NumGet(buf, 12, "Float")
    firstHumidity := NumGet(buf, 16, "Float")

    lastOffset := (recordCount - 1) * recordSize
    lastTime := NumGet(buf, lastOffset, "Double")
    lastTemp := NumGet(buf, lastOffset + 8, "Float")
    lastPressure := NumGet(buf, lastOffset + 12, "Float")
    lastHumidity := NumGet(buf, lastOffset + 16, "Float")

    ; Display results
    result := "Scientific Data Processing:`n`n"
    result .= "Data Format: " . recordCount . " records, " . recordSize . " bytes each`n"
    result .= "Total Size: " . buf.Size . " bytes`n`n"

    result .= "First Record:`n"
    result .= "  Timestamp: " . Format("{:.0f}", firstTime) . "`n"
    result .= "  Temperature: " . Format("{:.2f}", firstTemp) . "°C`n"
    result .= "  Pressure: " . Format("{:.2f}", firstPressure) . " hPa`n"
    result .= "  Humidity: " . Format("{:.1f}", firstHumidity) . "%`n`n"

    result .= "Last Record:`n"
    result .= "  Timestamp: " . Format("{:.0f}", lastTime) . "`n"
    result .= "  Temperature: " . Format("{:.2f}", lastTemp) . "°C`n"
    result .= "  Pressure: " . Format("{:.2f}", lastPressure) . " hPa`n"
    result .= "  Humidity: " . Format("{:.1f}", lastHumidity) . "%`n`n"

    result .= "Statistics:`n"
    result .= "  Avg Temperature: " . Format("{:.2f}", tempAvg) . "°C`n"
    result .= "  Min Temperature: " . Format("{:.2f}", tempMin) . "°C`n"
    result .= "  Max Temperature: " . Format("{:.2f}", tempMax) . "°C`n"
    result .= "  Avg Pressure: " . Format("{:.2f}", pressureAvg) . " hPa`n"
    result .= "  Avg Humidity: " . Format("{:.1f}", humidityAvg) . "%"

    MsgBox(result, "Example 4: Scientific Data", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Float Array Operations
; ================================================================================================
; Demonstrates array operations on floating-point data

Example5_FloatArrays() {
    ; Create arrays of financial data (stock prices)
    dayCount := 20
    buf := Buffer(dayCount * 4)  ; Float array

    ; Simulate stock prices (starting at $100)
    basePrice := 100.0
    loop dayCount {
        change := Random(-5.0, 5.0)
        price := basePrice + change
        NumPut("Float", price, buf, (A_Index - 1) * 4)
        basePrice := price
    }

    ; Calculate metrics
    prices := []
    loop dayCount {
        price := NumGet(buf, (A_Index - 1) * 4, "Float")
        prices.Push(price)
    }

    ; Find min, max
    minPrice := prices[1]
    maxPrice := prices[1]
    minDay := 1
    maxDay := 1

    loop dayCount {
        price := prices[A_Index]
        if price < minPrice {
            minPrice := price
            minDay := A_Index
        }
        if price > maxPrice {
            maxPrice := price
            maxDay := A_Index
        }
    }

    ; Calculate daily changes
    maxGain := -999.0
    maxLoss := 999.0
    maxGainDay := 1
    maxLossDay := 1

    loop dayCount - 1 {
        today := prices[A_Index]
        tomorrow := prices[A_Index + 1]
        change := tomorrow - today

        if change > maxGain {
            maxGain := change
            maxGainDay := A_Index
        }
        if change < maxLoss {
            maxLoss := change
            maxLossDay := A_Index
        }
    }

    ; Calculate average
    sum := 0.0
    for price in prices {
        sum += price
    }
    average := sum / dayCount

    ; Display results
    result := "Float Array Operations (Stock Prices):`n`n"
    result .= "Dataset: " . dayCount . " trading days`n"
    result .= "Storage: " . buf.Size . " bytes (Float array)`n`n"

    result .= "Price Range:`n"
    result .= "  Minimum: $" . Format("{:.2f}", minPrice) . " (Day " . minDay . ")`n"
    result .= "  Maximum: $" . Format("{:.2f}", maxPrice) . " (Day " . maxDay . ")`n"
    result .= "  Average: $" . Format("{:.2f}", average) . "`n"
    result .= "  Spread: $" . Format("{:.2f}", maxPrice - minPrice) . "`n`n"

    result .= "Daily Changes:`n"
    result .= "  Biggest Gain: $" . Format("{:.2f}", maxGain) . " (Day " . maxGainDay . ")`n"
    result .= "  Biggest Loss: $" . Format("{:.2f}", maxLoss) . " (Day " . maxLossDay . ")`n`n"

    result .= "First 10 Prices:`n  "
    loop Min(10, dayCount) {
        result .= "$" . Format("{:.2f}", prices[A_Index]) . " "
    }

    MsgBox(result, "Example 5: Float Array Operations", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Mixed Integer and Float Reading
; ================================================================================================
; Shows reading structures with both integer and floating-point fields

Example6_MixedIntFloat() {
    ; Structure: GameScore
    ; int playerId (4 bytes)
    ; float score (4 bytes)
    ; float time (4 bytes)
    ; int level (4 bytes)
    ; Total: 16 bytes per record

    recordSize := 16
    recordCount := 5
    buf := Buffer(recordSize * recordCount)

    ; Sample game scores
    scores := [{
        id: 1001, score: 9850.5, time: 125.3, level: 10 }, {
            id: 1002, score: 12400.0, time: 98.7, level: 12 }, {
                id: 1003, score: 8900.25, time: 145.8, level: 9 }, {
                    id: 1004, score: 15600.75, time: 87.2, level: 15 }, {
                        id: 1005, score: 11200.5, time: 112.5, level: 11
                    }
    ]

    ; Write records
    loop recordCount {
        offset := (A_Index - 1) * recordSize
        record := scores[A_Index]

        NumPut("Int", record.id, buf, offset)
        NumPut("Float", record.score, buf, offset + 4)
        NumPut("Float", record.time, buf, offset + 8)
        NumPut("Int", record.level, buf, offset + 12)
    }

    ; Read and find best performer
    bestScore := 0.0
    bestPlayer := 0
    fastestTime := 999.9
    fastestPlayer := 0
    highestLevel := 0
    highestPlayer := 0

    loop recordCount {
        offset := (A_Index - 1) * recordSize

        playerId := NumGet(buf, offset, "Int")
        score := NumGet(buf, offset + 4, "Float")
        time := NumGet(buf, offset + 8, "Float")
        level := NumGet(buf, offset + 12, "Int")

        if score > bestScore {
            bestScore := score
            bestPlayer := playerId
        }
        if time < fastestTime {
            fastestTime := time
            fastestPlayer := playerId
        }
        if level > highestLevel {
            highestLevel := level
            highestPlayer := playerId
        }
    }

    ; Read specific record for display
    offset := 1 * recordSize  ; Second record
    id := NumGet(buf, offset, "Int")
    score := NumGet(buf, offset + 4, "Float")
    time := NumGet(buf, offset + 8, "Float")
    level := NumGet(buf, offset + 12, "Int")

    ; Display results
    result := "Mixed Integer and Float Reading:`n`n"
    result .= "Structure: GameScore (16 bytes)`n"
    result .= "  int playerId (4 bytes)`n"
    result .= "  float score (4 bytes)`n"
    result .= "  float time (4 bytes)`n"
    result .= "  int level (4 bytes)`n`n"

    result .= "Sample Record (Player " . id . "):`n"
    result .= "  Score: " . Format("{:.2f}", score) . "`n"
    result .= "  Time: " . Format("{:.1f}", time) . " seconds`n"
    result .= "  Level: " . level . "`n`n"

    result .= "Leaderboard:`n"
    result .= "  Highest Score: " . Format("{:.2f}", bestScore)
        . " (Player " . bestPlayer . ")`n"
    result .= "  Fastest Time: " . Format("{:.1f}", fastestTime)
        . "s (Player " . fastestPlayer . ")`n"
    result .= "  Highest Level: " . highestLevel
        . " (Player " . highestPlayer . ")`n`n"

    result .= "Total Records: " . recordCount . " (" . buf.Size . " bytes)"

    MsgBox(result, "Example 6: Mixed Int/Float", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                    (
                    NumGet Floating-Point Examples

                    1. Basic Float and Double Reading
                    2. Precision and Rounding
                    3. Special Floating-Point Values
                    4. Scientific and Engineering Data
                    5. Float Array Operations
                    6. Mixed Integer and Float Reading

                    Select an example (1-6) or press Cancel to exit:
                    )"

    choice := InputBox(menu, "NumGet Floating-Point Examples", "w450 h320")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicFloatReading()
        case "2": Example2_PrecisionAndRounding()
        case "3": Example3_SpecialValues()
        case "4": Example4_ScientificData()
        case "5": Example5_FloatArrays()
        case "6": Example6_MixedIntFloat()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
