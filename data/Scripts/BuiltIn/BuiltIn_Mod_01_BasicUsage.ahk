#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Mod_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of Mod() function for modulo operations and remainder calculations
 * 
 * FEATURES:
 * - Basic modulo/remainder operations
 * - Even/odd number detection
 * - Divisibility testing
 * - Range wrapping and bounds checking
 * - Cyclic patterns
 * - Time and calendar calculations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Mod
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Mod() function
 * - Modulo arithmetic
 * - Integer division vs modulo
 * - Conditional logic with remainders
 * - Loop counter patterns
 * 
 * LEARNING POINTS:
 * 1. Mod(a, b) returns remainder of a ÷ b
 * 2. Result has same sign as dividend (a)
 * 3. Useful for detecting even/odd numbers
 * 4. Essential for cyclic/repeating patterns
 * 5. Common in array indexing and wrapping
 */

; ============================================================
; Example 1: Basic Modulo Operations
; ============================================================

calculations := [{
    dividend: 10, divisor: 3 }, {
        dividend: 17, divisor: 5 }, {
            dividend: 20, divisor: 4 }, {
                dividend: 100, divisor: 7 }, {
                    dividend: -10, divisor: 3 }, {
                        dividend: 10, divisor: -3 }, {
                            dividend: -10, divisor: -3
                        }
]

output := "BASIC MODULO OPERATIONS:`n`n"
output .= "Formula: Mod(a, b) = a - b × Floor(a/b)`n`n"

output .= " Dividend  Divisor   Quotient  Remainder  Verification`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for calc in calculations {
    remainder := Mod(calc.dividend, calc.divisor)
    quotient := Floor(calc.dividend / calc.divisor)
    verify := quotient * calc.divisor + remainder

    output .= Format("{:9d}", calc.dividend)
    output .= Format("{:9d}", calc.divisor)
    output .= Format("{:11d}", quotient)
    output .= Format("{:11d}", remainder)
    output .= Format("{:14d}", verify)

    if (verify = calc.dividend)
        output .= "  ✓"

    output .= "`n"
}

output .= "`nNote: Remainder takes sign of dividend"

MsgBox(output, "Basic Modulo", "Icon!")

; ============================================================
; Example 2: Even and Odd Number Detection
; ============================================================

/**
 * Check if number is even or odd
 */
IsEven(n) {
    return Mod(n, 2) = 0
}

IsOdd(n) {
    return Mod(n, 2) != 0
}

/**
 * Classify number
 */
ClassifyNumber(n) {
    if (IsEven(n))
        return "Even"
    else
        return "Odd"
}

numbers := [-10, -7, -4, -1, 0, 1, 4, 7, 10, 15, 20, 33, 50, 99, 100]

output := "EVEN AND ODD NUMBER DETECTION:`n`n"
output .= "Using: Mod(n, 2) = 0 for even, Mod(n, 2) ≠ 0 for odd`n`n"

output .= "Number    Mod(n,2)   Classification`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for num in numbers {
    modResult := Mod(num, 2)
    classification := ClassifyNumber(num)

    output .= Format("{:6d}", num)
    output .= Format("{:11d}", modResult)
    output .= "     " classification
    output .= "`n"
}

MsgBox(output, "Even/Odd Detection", "Icon!")

; ============================================================
; Example 3: Divisibility Testing
; ============================================================

/**
 * Test if number is divisible by another
 */
IsDivisibleBy(number, divisor) {
    return Mod(number, divisor) = 0
}

/**
 * Find all divisors of a number
 */
FindDivisors(n) {
    divisors := []

    Loop n {
        if (IsDivisibleBy(n, A_Index))
            divisors.Push(A_Index)
    }

    return divisors
}

/**
 * Check if number is prime
 */
IsPrime(n) {
    if (n <= 1)
        return false

    if (n <= 3)
        return true

    if (Mod(n, 2) = 0 || Mod(n, 3) = 0)
        return false

    i := 5
    while (i * i <= n) {
        if (Mod(n, i) = 0 || Mod(n, i + 2) = 0)
            return false
        i += 6
    }

    return true
}

testNumbers := [12, 15, 17, 24, 29, 30, 37, 42, 48, 50]

output := "DIVISIBILITY TESTING:`n`n"

for num in testNumbers {
    divisors := FindDivisors(num)
    isPrime := IsPrime(num)

    output .= "Number: " num
    output .= "`n  Divisors: "

    for divisor in divisors {
        output .= divisor " "
    }

    output .= "`n  Prime: " (isPrime ? "Yes" : "No")
    output .= "`n  Divisor Count: " divisors.Length
    output .= "`n`n"
}

MsgBox(output, "Divisibility Testing", "Icon!")

; ============================================================
; Example 4: Range Wrapping
; ============================================================

/**
 * Wrap value to range [0, max)
 */
WrapToRange(value, max) {
    return Mod(Mod(value, max) + max, max)
}

/**
 * Wrap to custom range [min, max)
 */
WrapToCustomRange(value, min, max) {
    range := max - min
    return min + Mod(Mod(value - min, range) + range, range)
}

/**
 * Circular array access
 */
CircularArrayAccess(array, index) {
    wrappedIndex := WrapToRange(index, array.Length) + 1  ; +1 for 1-based indexing
    return array[wrappedIndex]
}

; Test range wrapping
output := "RANGE WRAPPING:`n`n"
output .= "Wrap to range [0, 10):`n`n"

testValues := [-15, -10, -5, 0, 5, 10, 15, 20, 25]

for value in testValues {
    wrapped := WrapToRange(value, 10)
    output .= "  " Format("{:4d}", value) " → " wrapped "`n"
}

; Custom range [50, 100)
output .= "`nWrap to range [50, 100):`n`n"

for value in testValues {
    wrapped := WrapToCustomRange(value, 50, 100)
    output .= "  " Format("{:4d}", value) " → " wrapped "`n"
}

; Circular array
output .= "`nCircular Array Access:`n"
days := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
output .= "Days: [" StrReplace(Format("{:s}", days), " ", ", ") "]`n`n"

indices := [-7, -1, 0, 3, 7, 10, 14]
for index in indices {
    day := CircularArrayAccess(days, index)
    output .= "  Index " Format("{:3d}", index) " → " day "`n"
}

MsgBox(output, "Range Wrapping", "Icon!")

; ============================================================
; Example 5: Time and Calendar Calculations
; ============================================================

/**
 * Calculate day of week (simplified)
 */
DayOfWeek(dayNumber) {
    days := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    index := Mod(dayNumber, 7) + 1
    return days[index]
}

/**
 * Convert minutes to hours and minutes
 */
MinutesToTime(totalMinutes) {
    hours := Floor(totalMinutes / 60)
    minutes := Mod(totalMinutes, 60)
    return { hours: hours, minutes: minutes }
}

/**
 * Add time with wraparound
 */
AddTimeWraparound(hour, minute, addMinutes) {
    totalMinutes := hour * 60 + minute + addMinutes
    newHour := Mod(Floor(totalMinutes / 60), 24)
    newMinute := Mod(totalMinutes, 60)

    return { hour: newHour, minute: newMinute }
}

output := "TIME AND CALENDAR CALCULATIONS:`n`n"

; Day of week calculation
output .= "Day of Week (0 = Sunday):`n"
Loop 14 {
    day := A_Index - 1
    dayName := DayOfWeek(day)
    output .= "  Day " Format("{:2d}", day) " → " dayName "`n"
}

; Time conversion
output .= "`nMinutes to Hours:Minutes:`n"
minuteValues := [45, 90, 150, 200, 500, 1440, 2000]

for mins in minuteValues {
    time := MinutesToTime(mins)
    output .= "  " Format("{:4d}", mins) " min → "
    output .= Format("{:2d}:{:02d}", time.hours, time.minutes)
    output .= "`n"
}

; Time addition with wraparound
output .= "`nTime Addition (24-hour format):`n"
startTime := { hour: 22, minute: 45 }
additions := [30, 90, 180, 300]

for addMins in additions {
    newTime := AddTimeWraparound(startTime.hour, startTime.minute, addMins)
    output .= Format("  22:45 + {:3d} min → {:02d}:{:02d}",
        addMins, newTime.hour, newTime.minute)
    output .= "`n"
}

MsgBox(output, "Time Calculations", "Icon!")

; ============================================================
; Example 6: Color and Graphics Applications
; ============================================================

/**
 * RGB to components using modulo
 */
RGBToComponents(rgb) {
    blue := Mod(rgb, 256)
    green := Mod(Floor(rgb / 256), 256)
    red := Mod(Floor(rgb / 65536), 256)

    return { red: red, green: green, blue: blue }
}

/**
 * Components to RGB
 */
ComponentsToRGB(red, green, blue) {
    return red * 65536 + green * 256 + blue
}

/**
 * Cycle through colors
 */
CycleColor(index, numColors) {
    colorIndex := Mod(index, numColors)

    ; Generate different colors
    switch colorIndex {
        case 0: return { name: "Red", r: 255, g: 0, b: 0 }
        case 1: return { name: "Green", r: 0, g: 255, b: 0 }
        case 2: return { name: "Blue", r: 0, g: 0, b: 255 }
        case 3: return { name: "Yellow", r: 255, g: 255, b: 0 }
        case 4: return { name: "Magenta", r: 255, g: 0, b: 255 }
        case 5: return { name: "Cyan", r: 0, g: 255, b: 255 }
    }
}

output := "COLOR AND GRAPHICS APPLICATIONS:`n`n"

; RGB decomposition
colors := [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF, 0xC0C0C0]

output .= "RGB Color Decomposition:`n`n"
output .= "   RGB     Red  Green  Blue   Reconstructed`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for rgb in colors {
    comp := RGBToComponents(rgb)
    reconstructed := ComponentsToRGB(comp.red, comp.green, comp.blue)

    output .= Format("{:08X}", rgb)
    output .= Format("{:6d}", comp.red)
    output .= Format("{:6d}", comp.green)
    output .= Format("{:6d}", comp.blue)
    output .= "   " Format("{:08X}", reconstructed)
    output .= (rgb = reconstructed ? " ✓" : " ✗")
    output .= "`n"
}

; Color cycling
output .= "`nColor Cycling (6 colors):`n"
Loop 12 {
    index := A_Index - 1
    color := CycleColor(index, 6)
    output .= "  Index " Format("{:2d}", index) " → " color.name
    output .= " (RGB: " color.r ", " color.g ", " color.b ")`n"
}

MsgBox(output, "Color Applications", "Icon!")

; ============================================================
; Example 7: Practical Applications
; ============================================================

/**
 * Check if year is leap year
 */
IsLeapYear(year) {
    ; Divisible by 4 AND (not divisible by 100 OR divisible by 400)
    return (Mod(year, 4) = 0) && (Mod(year, 100) != 0 || Mod(year, 400) = 0)
}

/**
 * Calculate checksum digit (Luhn algorithm simplified)
 */
CalculateCheckDigit(number) {
    sum := 0
    numStr := String(number)

    Loop Parse, numStr {
        digit := Integer(A_LoopField)
        sum += digit
    }

    return Mod(10 - Mod(sum, 10), 10)
}

/**
 * Rotate array left
 */
RotateArrayLeft(array, positions) {
    result := []
    len := array.Length

    Loop len {
        index := A_Index
        newIndex := Mod(index - 1 + positions, len) + 1
        result.Push(array[newIndex])
    }

    return result
}

output := "PRACTICAL APPLICATIONS:`n`n"

; Leap years
output .= "Leap Year Detection:`n"
years := [2000, 2020, 2021, 2024, 2100, 2400]

for year in years {
    isLeap := IsLeapYear(year)
    output .= "  " year ": " (isLeap ? "Leap Year" : "Not Leap") "`n"
}

; Checksum
output .= "`nChecksum Digit Calculation:`n"
numbers := [123, 456, 789, 1234, 5678]

for num in numbers {
    checkDigit := CalculateCheckDigit(num)
    output .= "  " num " → Check digit: " checkDigit "`n"
}

; Array rotation
output .= "`nArray Rotation:`n"
original := [1, 2, 3, 4, 5, 6, 7]
output .= "Original: [" StrReplace(Format("{:s}", original), " ", ", ") "]`n`n"

rotations := [1, 2, 3, -1, -2]
for rot in rotations {
    rotated := RotateArrayLeft(original, rot)
    output .= "Rotate " Format("{:+2d}", rot) ": ["
    output .= StrReplace(Format("{:s}", rotated), " ", ", ") "]`n"
}

MsgBox(output, "Practical Applications", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                        (
                        MOD() FUNCTION REFERENCE:

                        Syntax:
                        Result := Mod(Dividend, Divisor)

                        Parameters:
                        Dividend - Number to be divided
                        Divisor - Number to divide by

                        Return Value:
                        Integer or Float - Remainder of division

                        Definition:
                        Mod(a, b) = a - b × Floor(a/b)

                        Sign Rules:
                        • Result has same sign as dividend
                        • Mod(10, 3) = 1
                        • Mod(-10, 3) = -1
                        • Mod(10, -3) = 1

                        Common Uses:
                        ✓ Even/odd detection: Mod(n, 2)
                        ✓ Divisibility: Mod(a, b) = 0
                        ✓ Range wrapping: Mod(value, range)
                        ✓ Cyclic patterns: Mod(index, cycle)
                        ✓ Array indexing: Mod(i, length)
                        ✓ Time calculations (12/24 hour)

                        Examples:
                        • Mod(7, 3) = 1 (7 = 3×2 + 1)
                        • Mod(10, 5) = 0 (10 = 5×2 + 0)
                        • Mod(8, 3) = 2 (8 = 3×2 + 2)

                        Properties:
                        • Mod(a, b) < b (for positive b)
                        • Mod(a + b, b) = Mod(a, b)
                        • Mod(a × c, b × c) ≠ Mod(a, b) × c

                        Special Cases:
                        • Mod(n, 1) = fractional part
                        • Mod(n, 2) = 0 for even, 1 for odd
                        • Mod(n, n) = 0

                        Applications:
                        ✓ Calendar calculations
                        ✓ Clock arithmetic
                        ✓ Color manipulation
                        ✓ Checksum algorithms
                        ✓ Circular buffers
                        ✓ Game logic (turn-based)
                        )"

MsgBox(info, "Mod() Reference", "Icon!")
