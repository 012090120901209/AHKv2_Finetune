#Requires AutoHotkey v2.0

/**
 * BuiltIn_Log_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of Log() function for base-10 logarithm calculations
 * 
 * FEATURES:
 * - Basic logarithm (base 10) calculations
 * - Logarithm properties and rules
 * - Relationship between Log() and powers of 10
 * - Converting between logarithms and exponentials
 * - Orders of magnitude
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Log
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Log() function (base 10)
 * - Ln() function (natural logarithm)
 * - Mathematical expressions
 * - Format() for scientific notation
 * - Power operator (**)
 * 
 * LEARNING POINTS:
 * 1. Log(x) calculates log₁₀(x)
 * 2. Log(10^n) = n
 * 3. 10^Log(x) = x
 * 4. Log is only defined for positive numbers
 * 5. Logarithms turn multiplication into addition
 */

; ============================================================
; Example 1: Basic Logarithm Calculations
; ============================================================

values := [1, 10, 100, 1000, 10000, 2, 5, 50, 500]
output := "BASIC LOG() CALCULATIONS (BASE 10):`n`n"

for x in values {
    logValue := Log(x)
    output .= "log₁₀(" Format("{:6g}", x) ") = " Format("{:12.8f}", logValue)

    ; Special cases
    if (x = 1)
        output .= "  (Always equals 0)"
    else if (x = 10)
        output .= "  (Always equals 1)"
    else if (Mod(Log(x) / Log(10), 1) = 0)
        output .= "  (Power of 10)"

    output .= "`n"
}

MsgBox(output, "Basic Log() Function", "Icon!")

; ============================================================
; Example 2: Powers of 10 and Logarithms
; ============================================================

/**
 * Demonstrate inverse relationship between Log and 10^x
 */
DemonstratePowersOf10() {
    exponents := [-3, -2, -1, 0, 1, 2, 3, 4, 5]
    results := []

    for n in exponents {
        power := 10 ** n
        logPower := Log(power)

        results.Push({
            exponent: n,
            power: power,
            log: logPower,
            error: Abs(n - logPower)
        })
    }

    return results
}

results := DemonstratePowersOf10()

output := "POWERS OF 10 AND LOGARITHMS:`n`n"
output .= "Property: log₁₀(10^n) = n`n`n"

output .= "  n      10^n          log₁₀(10^n)    Verify`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for r in results {
    output .= Format("{:3d}", r.exponent)
    output .= Format("{:15.6f}", r.power)
    output .= Format("{:15.10f}", r.log)
    output .= "    " (r.error < 0.0000001 ? "✓" : "✗")
    output .= "`n"
}

MsgBox(output, "Powers of 10", "Icon!")

; ============================================================
; Example 3: Logarithm Properties
; ============================================================

/**
 * Demonstrate key logarithm properties
 */
DemonstrateLogProperties() {
    a := 100
    b := 1000

    ; Property 1: log(a × b) = log(a) + log(b)
    prop1_left := Log(a * b)
    prop1_right := Log(a) + Log(b)

    ; Property 2: log(a / b) = log(a) - log(b)
    prop2_left := Log(a / b)
    prop2_right := Log(a) - Log(b)

    ; Property 3: log(a^b) = b × log(a)
    power := 3
    prop3_left := Log(a ** power)
    prop3_right := power * Log(a)

    ; Property 4: log(1) = 0
    prop4 := Log(1)

    ; Property 5: log(10) = 1
    prop5 := Log(10)

    ; Property 6: log(√a) = log(a) / 2
    prop6_left := Log(Sqrt(a))
    prop6_right := Log(a) / 2

    return {
        prop1: { left: prop1_left, right: prop1_right, a: a, b: b },
        prop2: { left: prop2_left, right: prop2_right, a: a, b: b },
        prop3: { left: prop3_left, right: prop3_right, a: a, power: power },
        prop4: prop4,
        prop5: prop5,
        prop6: { left: prop6_left, right: prop6_right, a: a }
    }
}

props := DemonstrateLogProperties()

output := "LOGARITHM PROPERTIES:`n`n"

output .= "1. log(a × b) = log(a) + log(b)`n"
output .= "   log(" props.prop1.a " × " props.prop1.b ") = "
output .= Format("{:.8f}", props.prop1.left) "`n"
output .= "   log(" props.prop1.a ") + log(" props.prop1.b ") = "
output .= Format("{:.8f}", props.prop1.right) "`n`n"

output .= "2. log(a / b) = log(a) - log(b)`n"
output .= "   log(" props.prop2.a " / " props.prop2.b ") = "
output .= Format("{:.8f}", props.prop2.left) "`n"
output .= "   log(" props.prop2.a ") - log(" props.prop2.b ") = "
output .= Format("{:.8f}", props.prop2.right) "`n`n"

output .= "3. log(a^n) = n × log(a)`n"
output .= "   log(" props.prop3.a "^" props.prop3.power ") = "
output .= Format("{:.8f}", props.prop3.left) "`n"
output .= "   " props.prop3.power " × log(" props.prop3.a ") = "
output .= Format("{:.8f}", props.prop3.right) "`n`n"

output .= "4. log(1) = 0`n"
output .= "   log(1) = " Format("{:.8f}", props.prop4) "`n`n"

output .= "5. log(10) = 1`n"
output .= "   log(10) = " Format("{:.8f}", props.prop5) "`n`n"

output .= "6. log(√a) = log(a) / 2`n"
output .= "   log(√" props.prop6.a ") = " Format("{:.8f}", props.prop6.left) "`n"
output .= "   log(" props.prop6.a ") / 2 = " Format("{:.8f}", props.prop6.right)

MsgBox(output, "Logarithm Properties", "Icon!")

; ============================================================
; Example 4: Converting Between Bases
; ============================================================

/**
 * Convert logarithm from one base to another
 * log_b(x) = log₁₀(x) / log₁₀(b)
 */
LogBase(x, base) {
    return Log(x) / Log(base)
}

/**
 * Calculate logarithm in various bases
 */
CalculateMultipleBases(x) {
    return {
        log2: LogBase(x, 2),      ; Binary logarithm
        log10: Log(x),             ; Common logarithm
        logE: Ln(x),               ; Natural logarithm
        log16: LogBase(x, 16)      ; Hexadecimal logarithm
    }
}

testValue := 256
results := CalculateMultipleBases(testValue)

output := "LOGARITHMS IN DIFFERENT BASES:`n`n"
output .= "Value: " testValue "`n`n"

output .= "Base       Notation    Result`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

bases := [{
    base: 2, name: "Binary", notation: "log₂", value: results.log2 }, {
        base: "e", name: "Natural", notation: "ln", value: results.logE }, {
            base: 10, name: "Common", notation: "log₁₀", value: results.log10 }, {
                base: 16, name: "Hexadecimal", notation: "log₁₆", value: results.log16
            }
]

for b in bases {
    output .= Format("{:>4s}", b.base)
    output .= Format("{:14s}", "  " b.name)
    output .= Format("{:9s}", b.notation)
    output .= Format("{:12.8f}", b.value)
    output .= "`n"
}

; Show that 256 = 2^8, 16^2
output .= "`nVerification:`n"
output .= "256 = 2^" Format("{:.0f}", results.log2) " = 16^" Format("{:.0f}", results.log16)

MsgBox(output, "Different Bases", "Icon!")

; ============================================================
; Example 5: Orders of Magnitude
; ============================================================

/**
 * Calculate order of magnitude (power of 10)
 */
OrderOfMagnitude(x) {
    return Floor(Log(Abs(x)))
}

/**
 * Express number in scientific notation
 */
ScientificNotation(x) {
    if (x = 0)
        return { mantissa: 0, exponent: 0 }

    exponent := OrderOfMagnitude(x)
    mantissa := x / (10 ** exponent)

    return { mantissa: mantissa, exponent: exponent }
}

numbers := [1234, 0.00567, 987654321, 0.0000123, 5.6e8, 3.14e-5]

output := "ORDERS OF MAGNITUDE:`n`n"
output .= "Number            Order   Scientific Notation`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for num in numbers {
    order := OrderOfMagnitude(num)
    sci := ScientificNotation(num)

    output .= Format("{:16.8g}", num)
    output .= Format("{:8d}", order)
    output .= "    " Format("{:.4f}", sci.mantissa) " × 10^" sci.exponent
    output .= "`n"
}

MsgBox(output, "Orders of Magnitude", "Icon!")

; ============================================================
; Example 6: Solving Exponential Equations
; ============================================================

/**
 * Solve equations of the form 10^x = N
 * Solution: x = log₁₀(N)
 */
SolveExponential10(N) {
    return Log(N)
}

/**
 * Solve equations of the form a^x = N
 * Solution: x = log(N) / log(a)
 */
SolveExponentialBase(a, N) {
    return Log(N) / Log(a)
}

output := "SOLVING EXPONENTIAL EQUATIONS:`n`n"

; Solve 10^x = N
output .= "Solve: 10^x = N`n"
output .= "Solution: x = log₁₀(N)`n`n"

targets := [50, 100, 500, 1000, 5000]
for N in targets {
    x := SolveExponential10(N)
    verify := 10 ** x

    output .= "  10^x = " Format("{:5d}", N) " → x = " Format("{:.6f}", x)
    output .= " (verify: " Format("{:.2f}", verify) ")`n"
}

; Solve a^x = N
output .= "`nSolve: 2^x = N`n"
output .= "Solution: x = log₁₀(N) / log₁₀(2)`n`n"

base := 2
targets := [8, 16, 32, 64, 128, 256]
for N in targets {
    x := SolveExponentialBase(base, N)
    verify := base ** x

    output .= "  2^x = " Format("{:4d}", N) " → x = " Format("{:.6f}", x)
    output .= " (verify: " Format("{:.2f}", verify) ")`n"
}

MsgBox(output, "Solving Exponentials", "Icon!")

; ============================================================
; Example 7: Logarithmic Scale Comparison
; ============================================================

/**
 * Compare linear vs logarithmic scale
 */
CompareScales(values) {
    results := []

    for val in values {
        linearDiff := val - values[1]
        logDiff := Log(val) - Log(values[1])

        results.Push({
            value: val,
            linear: linearDiff,
            log: logDiff
        })
    }

    return results
}

values := [1, 10, 100, 1000, 10000, 100000]
results := CompareScales(values)

output := "LINEAR vs LOGARITHMIC SCALE:`n`n"
output .= "   Value    Linear Diff    Log Diff`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for r in results {
    output .= Format("{:8,.0f}", r.value)
    output .= Format("{:15,.0f}", r.linear)
    output .= Format("{:12.4f}", r.log)
    output .= "`n"
}

output .= "`nNotice:`n"
output .= "- Linear: differences grow exponentially`n"
output .= "- Logarithmic: differences are constant (1.0)`n"
output .= "- Each value is 10× the previous`n"
output .= "- Log increases by 1 each time"

MsgBox(output, "Scale Comparison", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
            (
            LOG() FUNCTION REFERENCE:

            Syntax:
            Result := Log(Number)

            Parameters:
            Number - Positive number (must be > 0)

            Return Value:
            Float - Base-10 logarithm of Number

            Definition:
            If log₁₀(x) = y, then 10^y = x

            Key Properties:
            • log₁₀(1) = 0
            • log₁₀(10) = 1
            • log₁₀(100) = 2
            • log₁₀(10^n) = n
            • 10^(log₁₀(x)) = x

            Logarithm Rules:
            ✓ log(a × b) = log(a) + log(b)
            ✓ log(a / b) = log(a) - log(b)
            ✓ log(a^n) = n × log(a)
            ✓ log(√a) = log(a) / 2
            ✓ log(1/a) = -log(a)

            Base Conversion:
            log_b(x) = log₁₀(x) / log₁₀(b)
            log_b(x) = ln(x) / ln(b)

            Common Values:
            log₁₀(1) = 0
            log₁₀(2) ≈ 0.301
            log₁₀(e) ≈ 0.434
            log₁₀(10) = 1

            Relationship to Ln():
            log₁₀(x) = ln(x) / ln(10)
            log₁₀(x) ≈ 0.434 × ln(x)

            Applications:
            ✓ Orders of magnitude
            ✓ Scientific notation
            ✓ pH calculations
            ✓ Decibel measurements
            ✓ Richter scale
            ✓ Solving exponential equations

            Special Cases:
            • log(0) = undefined (−∞)
            • log(negative) = undefined
            • log(1) = 0
            )"

MsgBox(info, "Log() Reference", "Icon!")
