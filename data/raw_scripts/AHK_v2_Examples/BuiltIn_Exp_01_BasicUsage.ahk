#Requires AutoHotkey v2.0
/**
 * BuiltIn_Exp_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Basic usage examples of Exp() function for exponential calculations (e^x)
 *
 * FEATURES:
 * - Basic exponential function usage
 * - Euler's number (e) calculations
 * - Exponential growth patterns
 * - Relationship between Exp() and Ln()
 * - Power series approximations
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Exp
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Exp() function
 * - Ln() function (natural logarithm)
 * - Mathematical expressions
 * - Format() for scientific notation
 * - Loop for iterative calculations
 *
 * LEARNING POINTS:
 * 1. Exp(x) calculates e^x where e ≈ 2.71828
 * 2. e is Euler's number, base of natural logarithms
 * 3. Exp() and Ln() are inverse functions
 * 4. Exponential function grows very rapidly
 * 5. Used extensively in calculus and natural phenomena
 */

; Mathematical constants
global E := 2.71828182845905

; ============================================================
; Example 1: Basic Exponential Calculations
; ============================================================

values := [-3, -2, -1, 0, 1, 2, 3, 4, 5]
output := "BASIC EXPONENTIAL CALCULATIONS:`n`n"
output .= "e ≈ 2.71828182845905`n`n"

for x in values {
    result := Exp(x)
    output .= "e^" Format("{:2d}", x) " = " Format("{:12.8f}", result)

    ; Special cases
    if (x = 0)
        output .= "  (Always equals 1)"
    else if (x = 1)
        output .= "  (Equals e)"

    output .= "`n"
}

MsgBox(output, "Basic Exp() Function", "Icon!")

; ============================================================
; Example 2: Verifying Euler's Number
; ============================================================

/**
 * Calculate e using different methods
 */
CalculateE_Methods() {
    ; Method 1: Exp(1)
    e1 := Exp(1)

    ; Method 2: Limit definition (1 + 1/n)^n
    n := 1000000
    e2 := (1 + 1/n) ** n

    ; Method 3: Series sum: e = 1 + 1/1! + 1/2! + 1/3! + ...
    e3 := 1
    factorial := 1
    Loop 20 {
        factorial *= A_Index
        e3 += 1 / factorial
    }

    return {exp1: e1, limit: e2, series: e3}
}

results := CalculateE_Methods()

output := "CALCULATING EULER'S NUMBER (e):`n`n"
output .= "True value: e ≈ 2.718281828459045`n`n"

output .= "Method 1 - Exp(1):`n"
output .= "  e = " Format("{:.15f}", results.exp1) "`n`n"

output .= "Method 2 - Limit (1 + 1/n)^n:`n"
output .= "  e ≈ " Format("{:.15f}", results.limit) "`n`n"

output .= "Method 3 - Series 1 + 1/1! + 1/2! + ...:`n"
output .= "  e ≈ " Format("{:.15f}", results.series) "`n"

MsgBox(output, "Euler's Number", "Icon!")

; ============================================================
; Example 3: Exp() and Ln() as Inverse Functions
; ============================================================

/**
 * Demonstrate inverse relationship: Ln(Exp(x)) = x and Exp(Ln(x)) = x
 */
DemonstrateInverse() {
    testValues := [0.5, 1, 2, 3, 5, 10]
    results := []

    for x in testValues {
        ; Ln(Exp(x)) should equal x
        expThenLn := Ln(Exp(x))

        ; Exp(Ln(x)) should equal x (for positive x)
        lnThenExp := Exp(Ln(x))

        results.Push({
            x: x,
            expThenLn: expThenLn,
            lnThenExp: lnThenExp,
            error1: Abs(x - expThenLn),
            error2: Abs(x - lnThenExp)
        })
    }

    return results
}

results := DemonstrateInverse()

output := "EXP() AND LN() INVERSE RELATIONSHIP:`n`n"
output .= "Property: Ln(Exp(x)) = x and Exp(Ln(x)) = x`n`n"

output .= "Testing Ln(Exp(x)) = x:`n"
for result in results {
    output .= "  x = " Format("{:5.1f}", result.x)
    output .= " → Ln(Exp(x)) = " Format("{:12.10f}", result.expThenLn)
    output .= " (error: " Format("{:.2e}", result.error1) ")`n"
}

output .= "`nTesting Exp(Ln(x)) = x:`n"
for result in results {
    output .= "  x = " Format("{:5.1f}", result.x)
    output .= " → Exp(Ln(x)) = " Format("{:12.10f}", result.lnThenExp)
    output .= " (error: " Format("{:.2e}", result.error2) ")`n"
}

MsgBox(output, "Inverse Functions", "Icon!")

; ============================================================
; Example 4: Exponential Growth Visualization
; ============================================================

/**
 * Compare linear, quadratic, and exponential growth
 */
CompareGrowthRates(n) {
    results := []

    Loop n {
        x := A_Index
        linear := x
        quadratic := x * x
        exponential := Exp(x)

        results.Push({
            x: x,
            linear: linear,
            quadratic: quadratic,
            exponential: exponential
        })
    }

    return results
}

results := CompareGrowthRates(10)

output := "GROWTH RATE COMPARISON:`n`n"
output .= "  x    Linear   Quadratic   Exponential`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for result in results {
    output .= Format("{:3d}  ", result.x)
    output .= Format("{:7d}  ", result.linear)
    output .= Format("{:9d}  ", result.quadratic)
    output .= Format("{:12.2f}", result.exponential)
    output .= "`n"
}

output .= "`nNote: Exponential growth eventually surpasses all polynomial growth!"

MsgBox(output, "Growth Comparison", "Icon!")

; ============================================================
; Example 5: Exponential Properties
; ============================================================

/**
 * Demonstrate key exponential properties
 */
DemonstrateProperties() {
    a := 2
    b := 3

    ; Property 1: e^(a+b) = e^a × e^b
    prop1_left := Exp(a + b)
    prop1_right := Exp(a) * Exp(b)

    ; Property 2: e^(a-b) = e^a / e^b
    prop2_left := Exp(a - b)
    prop2_right := Exp(a) / Exp(b)

    ; Property 3: (e^a)^b = e^(a×b)
    prop3_left := Exp(a) ** b
    prop3_right := Exp(a * b)

    ; Property 4: e^0 = 1
    prop4 := Exp(0)

    ; Property 5: e^(-x) = 1/e^x
    x := 2
    prop5_left := Exp(-x)
    prop5_right := 1 / Exp(x)

    return {
        prop1: {left: prop1_left, right: prop1_right, a: a, b: b},
        prop2: {left: prop2_left, right: prop2_right, a: a, b: b},
        prop3: {left: prop3_left, right: prop3_right, a: a, b: b},
        prop4: prop4,
        prop5: {left: prop5_left, right: prop5_right, x: x}
    }
}

props := DemonstrateProperties()

output := "EXPONENTIAL FUNCTION PROPERTIES:`n`n"

output .= "1. e^(a+b) = e^a × e^b`n"
output .= "   e^(" props.prop1.a "+" props.prop1.b ") = "
output .= Format("{:.8f}", props.prop1.left) "`n"
output .= "   e^" props.prop1.a " × e^" props.prop1.b " = "
output .= Format("{:.8f}", props.prop1.right) "`n`n"

output .= "2. e^(a-b) = e^a / e^b`n"
output .= "   e^(" props.prop2.a "-" props.prop2.b ") = "
output .= Format("{:.8f}", props.prop2.left) "`n"
output .= "   e^" props.prop2.a " / e^" props.prop2.b " = "
output .= Format("{:.8f}", props.prop2.right) "`n`n"

output .= "3. (e^a)^b = e^(a×b)`n"
output .= "   (e^" props.prop3.a ")^" props.prop3.b " = "
output .= Format("{:.8f}", props.prop3.left) "`n"
output .= "   e^(" props.prop3.a "×" props.prop3.b ") = "
output .= Format("{:.8f}", props.prop3.right) "`n`n"

output .= "4. e^0 = 1`n"
output .= "   e^0 = " Format("{:.8f}", props.prop4) "`n`n"

output .= "5. e^(-x) = 1/e^x`n"
output .= "   e^(-" props.prop5.x ") = " Format("{:.8f}", props.prop5.left) "`n"
output .= "   1/e^" props.prop5.x " = " Format("{:.8f}", props.prop5.right)

MsgBox(output, "Exponential Properties", "Icon!")

; ============================================================
; Example 6: Taylor Series Approximation
; ============================================================

/**
 * Approximate e^x using Taylor series
 * e^x = 1 + x + x²/2! + x³/3! + x⁴/4! + ...
 *
 * @param {Number} x - Value to calculate e^x
 * @param {Number} terms - Number of terms to use
 * @returns {Number} - Approximation of e^x
 */
ExpTaylor(x, terms := 20) {
    result := 1
    term := 1

    Loop terms {
        term *= x / A_Index
        result += term
    }

    return result
}

testValue := 2
output := "TAYLOR SERIES APPROXIMATION:`n`n"
output .= "e^x = 1 + x + x²/2! + x³/3! + x⁴/4! + ...`n`n"
output .= "Calculating e^" testValue ":`n`n"

trueValue := Exp(testValue)
output .= "True value (Exp(" testValue ")): " Format("{:.10f}", trueValue) "`n`n"

output .= "Approximations by number of terms:`n"
termCounts := [1, 2, 3, 5, 10, 20]

for n in termCounts {
    approx := ExpTaylor(testValue, n)
    error := Abs(trueValue - approx)
    errorPct := (error / trueValue) * 100

    output .= Format("{:3d} terms: ", n)
    output .= Format("{:14.10f}", approx)
    output .= " (error: " Format("{:.2e}", error)
    output .= ", " Format("{:.4f}", errorPct) "%)`n"
}

MsgBox(output, "Taylor Series", "Icon!")

; ============================================================
; Example 7: Practical Applications
; ============================================================

/**
 * Calculate continuous compound interest
 * A = P × e^(rt)
 */
ContinuousCompound(principal, rate, time) {
    return principal * Exp(rate * time)
}

/**
 * Population growth (natural growth)
 * P(t) = P₀ × e^(rt)
 */
PopulationGrowth(initial, rate, time) {
    return initial * Exp(rate * time)
}

/**
 * Probability density function of normal distribution at x=0
 * For standard normal: f(0) = 1/√(2π) ≈ 0.3989
 */
NormalPDF_AtZero() {
    return 1 / Sqrt(2 * 3.14159265359)
}

output := "PRACTICAL APPLICATIONS:`n`n"

; Continuous compound interest
principal := 1000
rate := 0.05  ; 5% annual rate
years := 10
finalAmount := ContinuousCompound(principal, rate, years)

output .= "1. Continuous Compound Interest:`n"
output .= "   Principal: $" principal "`n"
output .= "   Rate: " (rate * 100) "% per year`n"
output .= "   Time: " years " years`n"
output .= "   Final Amount: $" Format("{:.2f}", finalAmount) "`n`n"

; Population growth
initial := 1000
growthRate := 0.03  ; 3% annual growth
time := 20
population := PopulationGrowth(initial, growthRate, time)

output .= "2. Population Growth:`n"
output .= "   Initial: " initial " individuals`n"
output .= "   Growth Rate: " (growthRate * 100) "% per year`n"
output .= "   Time: " time " years`n"
output .= "   Final Population: " Format("{:.0f}", population) "`n`n"

; Normal distribution
output .= "3. Normal Distribution:`n"
output .= "   PDF at mean (x=0): " Format("{:.6f}", NormalPDF_AtZero())

MsgBox(output, "Applications", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
EXP() FUNCTION REFERENCE:

Syntax:
  Result := Exp(Number)

Parameters:
  Number - The exponent value

Return Value:
  Float - e^Number (e raised to the power of Number)

Euler's Number:
  e = 2.718281828459045...
  e = lim(n→∞) (1 + 1/n)^n
  e = 1 + 1/1! + 1/2! + 1/3! + ...

Key Properties:
• e^0 = 1
• e^1 = e
• e^(a+b) = e^a × e^b
• e^(a-b) = e^a / e^b
• (e^a)^b = e^(ab)
• e^(-x) = 1/e^x

Inverse Function:
• Ln(Exp(x)) = x
• Exp(Ln(x)) = x (for x > 0)

Common Values:
e^0 = 1.000000
e^1 = 2.718282 (e)
e^2 = 7.389056
e^(-1) = 0.367879 (1/e)

Taylor Series:
e^x = Σ(n=0 to ∞) x^n / n!
    = 1 + x + x²/2! + x³/3! + ...

Applications:
✓ Continuous compound interest
✓ Population growth/decay
✓ Radioactive decay
✓ Normal distribution
✓ Calculus (derivatives/integrals)
✓ Differential equations
)"

MsgBox(info, "Exp() Reference", "Icon!")
