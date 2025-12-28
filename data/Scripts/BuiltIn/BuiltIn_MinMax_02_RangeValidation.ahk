#Requires AutoHotkey v2.0

/**
 * BuiltIn_MinMax_02_RangeValidation.ahk
 * 
 * DESCRIPTION:
 * Range validation and clamping applications using Min() and Max() for
 * constraining values to bounds, input validation, and safe value operations
 * 
 * FEATURES:
 * - Value clamping to ranges
 * - Bounds checking and validation
 * - Safe arithmetic operations
 * - Input sanitization
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Min.htm
 * https://www.autohotkey.com/docs/v2/lib/Max.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Min/Max for clamping values
 * - Range constraint patterns
 * - Defensive programming
 * - Input validation
 * 
 * LEARNING POINTS:
 * 1. Clamp value: Max(min, Min(max, value))
 * 2. Ensures values stay within bounds
 * 3. Prevents invalid operations
 * 4. Essential for user input validation
 * 5. Creates safe, predictable behavior
 */

; ============================================================
; Example 1: Basic Value Clamping
; ============================================================

/**
 * Clamp a value to a range
 * 
 * @param {Number} value - Value to clamp
 * @param {Number} minValue - Minimum allowed value
 * @param {Number} maxValue - Maximum allowed value
 * @returns {Number} - Clamped value
 */
Clamp(value, minValue, maxValue) {
    return Max(minValue, Min(maxValue, value))
}

; Test clamping
testValues := [-5, 0, 50, 100, 150]
rangeMin := 0
rangeMax := 100

output := "Value Clamping [" rangeMin ", " rangeMax "]:`n`n"

for value in testValues {
    clamped := Clamp(value, rangeMin, rangeMax)
    status := value = clamped ? "OK" : "CLAMPED"

    output .= Format("{1} → {2} ({3})`n", value, clamped, status)
}

output .= "`nFormula: Max(min, Min(max, value))`n"
output .= "Ensures value stays within bounds"

MsgBox(output, "Value Clamping", "Icon!")

; ============================================================
; Example 2: Volume Control
; ============================================================

/**
 * Safe volume adjustment
 * 
 * @param {Number} currentVolume - Current volume (0-100)
 * @param {Number} adjustment - Volume change
 * @returns {Object} - New volume and status
 */
AdjustVolume(currentVolume, adjustment) {
    newVolume := currentVolume + adjustment
    clampedVolume := Clamp(newVolume, 0, 100)
    wasClipped := newVolume != clampedVolume

    return {
        previous: currentVolume,
        requested: newVolume,
        actual: clampedVolume,
        adjustment: adjustment,
        wasClipped: wasClipped,
        atMin: clampedVolume = 0,
        atMax: clampedVolume = 100
    }
}

; Simulate volume changes
currentVol := 75
adjustments := [10, 20, 5, -50, -40]

output := "Volume Control (0-100):`n"
output .= "Starting Volume: " currentVol "`n`n"

for adjustment in adjustments {
    result := AdjustVolume(currentVol, adjustment)
    currentVol := result.actual

    output .= Format("Adjust {1:+d}: {2} → {3}",
        result.adjustment, result.previous, result.actual)

    if (result.wasClipped)
        output .= " [CLIPPED]"
    if (result.atMin)
        output .= " [MIN]"
    if (result.atMax)
        output .= " [MAX]"

    output .= "`n"
}

MsgBox(output, "Volume Control", "Icon!")

; ============================================================
; Example 3: RGB Color Clamping
; ============================================================

/**
 * Clamp RGB color values
 * 
 * @param {Number} r - Red component
 * @param {Number} g - Green component
 * @param {Number} b - Blue component
 * @returns {Object} - Clamped RGB values
 */
ClampRGB(r, g, b) {
    return {
        r: Clamp(r, 0, 255),
        g: Clamp(g, 0, 255),
        b: Clamp(b, 0, 255),
        original: { r: r, g: g, b: b },
        wasModified: (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255)
    }
}

/**
 * Adjust color brightness
 */
AdjustBrightness(r, g, b, amount) {
    newR := r + amount
    newG := g + amount
    newB := b + amount

    clamped := ClampRGB(newR, newG, newB)

    return {
        original: { r: r, g: g, b: b },
        adjustment: amount,
        result: { r: clamped.r, g: clamped.g, b: clamped.b },
        wasClipped: clamped.wasModified
    }
}

; Test color adjustments
baseColor := { r: 200, g: 150, b: 100 }
brightnessChanges := [50, -100, 30]

output := "Color Brightness Adjustment:`n"
output .= Format("Base Color: RGB({1}, {2}, {3})`n`n",
    baseColor.r, baseColor.g, baseColor.b)

for change in brightnessChanges {
    result := AdjustBrightness(baseColor.r, baseColor.g, baseColor.b, change)

    output .= Format("Adjust {1:+d}: RGB({2}, {3}, {4})",
        result.adjustment,
        result.result.r, result.result.g, result.result.b)

    if (result.wasClipped)
        output .= " [CLIPPED]"

    output .= "`n"
}

MsgBox(output, "Color Clamping", "Icon!")

; ============================================================
; Example 4: Slider/Progress Validation
; ============================================================

/**
 * Validate slider position
 * 
 * @param {Number} position - Requested position
 * @param {Number} min - Minimum value
 * @param {Number} max - Maximum value
 * @returns {Object} - Validated position
 */
ValidateSliderPosition(position, min, max) {
    clamped := Clamp(position, min, max)
    percent := ((clamped - min) / (max - min)) * 100

    return {
        requested: position,
        validated: clamped,
        min: min,
        max: max,
        percent: Round(percent, 1),
        isMin: clamped = min,
        isMax: clamped = max,
        inRange: position >= min && position <= max
    }
}

/**
 * Create progress bar visualization
 */
CreateProgressBar(value, min, max, width := 20) {
    normalized := Clamp(value, min, max)
    percent := (normalized - min) / (max - min)
    filled := Floor(percent * width)

    bar := ""
    Loop width {
        bar .= A_Index <= filled ? "█" : "░"
    }

    return {
        bar: bar,
        value: normalized,
        percent: Round(percent * 100, 1)
    }
}

; Test slider validation
sliderMin := 0
sliderMax := 200
testPositions := [-10, 0, 75, 150, 200, 250]

output := "Slider Validation [" sliderMin ", " sliderMax "]:`n`n"

for position in testPositions {
    validated := ValidateSliderPosition(position, sliderMin, sliderMax)
    progress := CreateProgressBar(position, sliderMin, sliderMax, 20)

    output .= Format("{1} → {2} | {3} {4}%`n",
        validated.requested, validated.validated,
        progress.bar, progress.percent)
}

MsgBox(output, "Slider Validation", "Icon!")

; ============================================================
; Example 5: Safe Division with Bounds
; ============================================================

/**
 * Safe division with result clamping
 * 
 * @param {Number} numerator - Numerator
 * @param {Number} denominator - Denominator
 * @param {Number} minResult - Minimum allowed result
 * @param {Number} maxResult - Maximum allowed result
 * @returns {Object} - Division result
 */
SafeDivide(numerator, denominator, minResult := -1000, maxResult := 1000) {
    if (denominator = 0) {
        return {
            error: "Division by zero",
            result: 0,
            wasClamped: true
        }
    }

    rawResult := numerator / denominator
    clampedResult := Clamp(rawResult, minResult, maxResult)

    return {
        numerator: numerator,
        denominator: denominator,
        rawResult: Round(rawResult, 2),
        result: Round(clampedResult, 2),
        wasClamped: rawResult != clampedResult,
        bounds: { min: minResult, max: maxResult }
    }
}

; Test safe division
divisionTests := [{
    num: 100, den: 5 }, {
        num: 1000, den: 1 }, {
            num: 50, den: 0 }, {
                num: 10, den: 0.001
            }
]

output := "Safe Division (Clamped to ±1000):`n`n"

for test in divisionTests {
    result := SafeDivide(test.num, test.den, -1000, 1000)

    if (result.HasOwnProp("error")) {
        output .= Format("{1} ÷ {2} = ERROR: {3}`n",
            test.num, test.den, result.error)
    } else {
        output .= Format("{1} ÷ {2} = {3}",
            result.numerator, result.denominator, result.result)

        if (result.wasClamped)
            output .= " [CLAMPED from " result.rawResult "]"

        output .= "`n"
    }
}

MsgBox(output, "Safe Division", "Icon!")

; ============================================================
; Example 6: User Input Sanitization
; ============================================================

/**
 * Sanitize numeric input
 * 
 * @param {Number} input - User input value
 * @param {Object} constraints - Min, max, and default values
 * @returns {Object} - Sanitized value
 */
SanitizeInput(input, constraints) {
    ; Apply constraints
    sanitized := Clamp(input, constraints.min, constraints.max)

    return {
        original: input,
        sanitized: sanitized,
        wasModified: input != sanitized,
        constraints: constraints,
        percentOfRange: Round(((sanitized - constraints.min) /
            (constraints.max - constraints.min)) * 100, 1)
    }
}

/**
 * Validate form field
 */
ValidateField(fieldName, value, min, max, defaultValue := 0) {
    if (!IsNumber(value))
        return { field: fieldName, value: defaultValue, error: "Not a number" }

    result := SanitizeInput(value, { min: min, max: max })

    return {
        field: fieldName,
        original: result.original,
        value: result.sanitized,
        wasModified: result.wasModified,
        valid: !result.wasModified
    }
}

; Form validation examples
formFields := [{
    name: "Age", value: 25, min: 0, max: 120 }, {
        name: "Quantity", value: 150, min: 1, max: 100 }, {
            name: "Temperature", value: -50, min: -20, max: 120 }, {
                name: "Score", value: 85, min: 0, max: 100
            }
]

output := "Form Input Validation:`n`n"

validCount := 0
invalidCount := 0

for field in formFields {
    validation := ValidateField(field.name, field.value,
        field.min, field.max)

    output .= Format("{1}: {2} → {3} ",
        validation.field, validation.original, validation.value)

    if (validation.valid) {
        output .= "✓"
        validCount++
    } else {
        output .= "✗ ADJUSTED"
        invalidCount++
    }

    output .= "`n"
}

output .= Format("`nValid: {1} | Adjusted: {2}", validCount, invalidCount)

MsgBox(output, "Input Validation", "Icon!")

; ============================================================
; Example 7: Percentage Bounds
; ============================================================

/**
 * Ensure percentage is valid (0-100)
 * 
 * @param {Number} value - Percentage value
 * @returns {Object} - Valid percentage
 */
ClampPercent(value) {
    clamped := Clamp(value, 0, 100)

    return {
        original: value,
        percent: clamped,
        decimal: clamped / 100,
        formatted: Format("{1:.1f}%", clamped),
        wasClipped: value != clamped
    }
}

/**
 * Calculate discount with limits
 */
ApplyDiscount(price, discountPercent, maxDiscount := 50) {
    ; Limit discount to maximum
    actualDiscount := Clamp(discountPercent, 0, maxDiscount)
    discountAmount := price * (actualDiscount / 100)
    finalPrice := price - discountAmount

    return {
        originalPrice: price,
        requestedDiscount: discountPercent,
        actualDiscount: actualDiscount,
        discountAmount: Round(discountAmount, 2),
        finalPrice: Round(finalPrice, 2),
        wasLimited: discountPercent != actualDiscount
    }
}

; Discount scenarios
price := 199.99
discountAttempts := [10, 25, 50, 75, 100]
maxAllowedDiscount := 50

output := "Discount Validation (Max " maxAllowedDiscount "%):`n"
output .= "Original Price: $" Format("{1:.2f}", price) "`n`n"

for discount in discountAttempts {
    result := ApplyDiscount(price, discount, maxAllowedDiscount)

    output .= Format("{1}% → {2}%: ${3:.2f}",
        result.requestedDiscount, result.actualDiscount,
        result.finalPrice)

    if (result.wasLimited)
        output .= " [LIMITED]"

    output .= "`n"
}

MsgBox(output, "Discount Clamping", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                        (
                        MIN/MAX FOR RANGE VALIDATION & CLAMPING:

                        Clamping Formula:
                        ─────────────────
                        clamped = Max(min, Min(max, value))

                        How it works:
                        1. Min(max, value) ensures value ≤ max
                        2. Max(min, result) ensures result ≥ min

                        Examples:
                        Clamp(150, 0, 100):
                        Min(100, 150) = 100
                        Max(0, 100) = 100 ✓

                        Clamp(-5, 0, 100):
                        Min(100, -5) = -5
                        Max(0, -5) = 0 ✓

                        Clamp(50, 0, 100):
                        Min(100, 50) = 50
                        Max(0, 50) = 50 ✓

                        Step-by-Step Breakdown:
                        ───────────────────────
                        Value: 150, Range: [0, 100]

                        Step 1: Min(100, 150) = 100
                        (Cap at maximum)

                        Step 2: Max(0, 100) = 100
                        (Ensure above minimum)

                        Result: 100

                        Value: -5, Range: [0, 100]

                        Step 1: Min(100, -5) = -5
                        (Already below max)

                        Step 2: Max(0, -5) = 0
                        (Raise to minimum)

                        Result: 0

                        Common Applications:
                        ────────────────────
                        1. Volume Control (0-100):
                        volume = Clamp(newVolume, 0, 100)

                        2. RGB Colors (0-255):
                        r = Clamp(r, 0, 255)
                        g = Clamp(g, 0, 255)
                        b = Clamp(b, 0, 255)

                        3. Slider Position:
                        pos = Clamp(position, minPos, maxPos)

                        4. Percentage (0-100):
                        percent = Clamp(value, 0, 100)

                        5. Temperature Range:
                        temp = Clamp(temp, minTemp, maxTemp)

                        Input Validation:
                        ─────────────────
                        Sanitize user input:

                        function ValidateInput(value, min, max) {
                            clamped = Clamp(value, min, max)
                            if (value != clamped)
                            ShowWarning("Value adjusted")
                            return clamped
                        }

                        Benefits:
                        ✓ Prevents invalid values
                        ✓ No error checking needed
                        ✓ Safe for calculations
                        ✓ User-friendly corrections

                        Safe Arithmetic:
                        ────────────────
                        Prevent overflow/underflow:

                        result = value + adjustment
                        safe = Clamp(result, min, max)

                        Example:
                        volume = 95
                        adjustment = +10
                        new = 95 + 10 = 105
                        safe = Clamp(105, 0, 100) = 100 ✓

                        Alternative Syntax:
                        ───────────────────
                        Explicit min/max:
                        value = Max(minValue, value)  ; At least min
                        value = Min(maxValue, value)  ; At most max

                        Both operations:
                        value = Max(min, Min(max, value))  ; Within range

                        Validation Patterns:
                        ────────────────────
                        1. Clamp and use:
                        value = Clamp(input, min, max)

                        2. Clamp and notify:
                        clamped = Clamp(input, min, max)
                        if (input != clamped)
                        Notify("Value adjusted")

                        3. Validate then clamp:
                        if (input < min || input > max)
                        input = Clamp(input, min, max)

                        Best Practices:
                        ───────────────
                        ✓ Always validate user input
                        ✓ Clamp before critical operations
                        ✓ Use meaningful min/max constants
                        ✓ Provide feedback when clamping
                        ✓ Document valid ranges
                        ✓ Consider edge cases (min = max)

                        Common Ranges:
                        ──────────────
                        • Percentage: [0, 100]
                        • RGB: [0, 255]
                        • Alpha: [0, 1] or [0, 255]
                        • Angle: [0, 360]
                        • Volume: [0, 100]
                        • Array index: [0, length-1]

                        Error Prevention:
                        ─────────────────
                        Clamping prevents:
                        • Array out of bounds
                        • Color overflow
                        • Volume too loud/quiet
                        • Invalid percentage
                        • UI element off-screen
                        • Division issues
                        )"

MsgBox(info, "Range Validation Reference", "Icon!")
