#Requires AutoHotkey v2.0
/**
 * BuiltIn_Ln_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Basic usage examples of Ln() function for natural logarithm calculations (base e)
 *
 * FEATURES:
 * - Basic natural logarithm (ln) calculations
 * - Relationship between Ln() and Exp()
 * - Natural logarithm properties
 * - Converting between different logarithm bases
 * - Euler's number (e) applications
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Ln
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Ln() function (natural logarithm, base e)
 * - Exp() function (e^x)
 * - Log() function (base 10)
 * - Mathematical expressions
 * - Format() for number display
 *
 * LEARNING POINTS:
 * 1. Ln(x) calculates log_e(x) where e ≈ 2.71828
 * 2. Ln() and Exp() are inverse functions
 * 3. Ln(e) = 1, Ln(1) = 0
 * 4. Natural log is the "natural" choice in calculus
 * 5. Used extensively in growth, decay, and probability
 */

global E := 2.71828182845905

; ============================================================
; Example 1: Basic Natural Logarithm Calculations
; ============================================================

values := [1, 2, 3, E, 5, 10, 20, 50, 100]
output := "BASIC NATURAL LOGARITHM CALCULATIONS:`n`n"
output .= "e ≈ 2.71828182845905`n`n"

for x in values {
    lnValue := Ln(x)
    output .= "ln(" Format("{:6.4f}", x) ") = " Format("{:12.8f}", lnValue)

    ; Special cases
    if (x = 1)
        output .= "  (Always equals 0)"
    else if (Abs(x - E) < 0.0001)
        output .= "  (ln(e) = 1)"

    output .= "`n"
}

MsgBox(output, "Basic Ln() Function", "Icon!")

; ============================================================
; Example 2: Ln() and Exp() as Inverse Functions
; ============================================================

/**
 * Demonstrate inverse relationship
 * Ln(Exp(x)) = x and Exp(Ln(x)) = x
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

output := "LN() AND EXP() INVERSE RELATIONSHIP:`n`n"
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
; Example 3: Natural Logarithm Properties
; ============================================================

/**
 * Demonstrate key natural logarithm properties
 */
DemonstrateLnProperties() {
    a := 10
    b := 5

    ; Property 1: ln(a × b) = ln(a) + ln(b)
    prop1_left := Ln(a * b)
    prop1_right := Ln(a) + Ln(b)

    ; Property 2: ln(a / b) = ln(a) - ln(b)
    prop2_left := Ln(a / b)
    prop2_right := Ln(a) - Ln(b)

    ; Property 3: ln(a^b) = b × ln(a)
    power := 3
    prop3_left := Ln(a ** power)
    prop3_right := power * Ln(a)

    ; Property 4: ln(1) = 0
    prop4 := Ln(1)

    ; Property 5: ln(e) = 1
    prop5 := Ln(E)

    ; Property 6: ln(√a) = ln(a) / 2
    prop6_left := Ln(Sqrt(a))
    prop6_right := Ln(a) / 2

    ; Property 7: ln(1/a) = -ln(a)
    prop7_left := Ln(1 / a)
    prop7_right := -Ln(a)

    return {
        prop1: {left: prop1_left, right: prop1_right, a: a, b: b},
        prop2: {left: prop2_left, right: prop2_right, a: a, b: b},
        prop3: {left: prop3_left, right: prop3_right, a: a, power: power},
        prop4: prop4,
        prop5: prop5,
        prop6: {left: prop6_left, right: prop6_right, a: a},
        prop7: {left: prop7_left, right: prop7_right, a: a}
    }
}

props := DemonstrateLnProperties()

output := "NATURAL LOGARITHM PROPERTIES:`n`n"

output .= "1. ln(a × b) = ln(a) + ln(b)`n"
output .= "   ln(" props.prop1.a " × " props.prop1.b ") = "
output .= Format("{:.8f}", props.prop1.left) "`n"
output .= "   ln(" props.prop1.a ") + ln(" props.prop1.b ") = "
output .= Format("{:.8f}", props.prop1.right) "`n`n"

output .= "2. ln(a / b) = ln(a) - ln(b)`n"
output .= "   ln(" props.prop2.a " / " props.prop2.b ") = "
output .= Format("{:.8f}", props.prop2.left) "`n"
output .= "   ln(" props.prop2.a ") - ln(" props.prop2.b ") = "
output .= Format("{:.8f}", props.prop2.right) "`n`n"

output .= "3. ln(a^n) = n × ln(a)`n"
output .= "   ln(" props.prop3.a "^" props.prop3.power ") = "
output .= Format("{:.8f}", props.prop3.left) "`n"
output .= "   " props.prop3.power " × ln(" props.prop3.a ") = "
output .= Format("{:.8f}", props.prop3.right) "`n`n"

output .= "4. ln(1) = 0`n"
output .= "   ln(1) = " Format("{:.8f}", props.prop4) "`n`n"

output .= "5. ln(e) = 1`n"
output .= "   ln(e) = " Format("{:.8f}", props.prop5) "`n`n"

output .= "6. ln(√a) = ln(a) / 2`n"
output .= "   ln(√" props.prop6.a ") = " Format("{:.8f}", props.prop6.left) "`n"
output .= "   ln(" props.prop6.a ") / 2 = " Format("{:.8f}", props.prop6.right) "`n`n"

output .= "7. ln(1/a) = -ln(a)`n"
output .= "   ln(1/" props.prop7.a ") = " Format("{:.8f}", props.prop7.left) "`n"
output .= "   -ln(" props.prop7.a ") = " Format("{:.8f}", props.prop7.right)

MsgBox(output, "Ln Properties", "Icon!")

; ============================================================
; Example 4: Converting Between Logarithm Bases
; ============================================================

/**
 * Convert between natural log and common log
 * ln(x) = log₁₀(x) × ln(10)
 * log₁₀(x) = ln(x) / ln(10)
 */
ConvertLogarithms(x) {
    naturalLog := Ln(x)
    commonLog := Log(x)

    ; Conversions
    ln10 := Ln(10)
    lnFromLog := commonLog * ln10
    logFromLn := naturalLog / ln10

    return {
        x: x,
        ln: naturalLog,
        log: commonLog,
        ln10: ln10,
        lnFromLog: lnFromLog,
        logFromLn: logFromLn
    }
}

testValues := [2, 10, 100, E]

output := "CONVERTING BETWEEN LOG BASES:`n`n"
output .= "ln(10) = " Format("{:.10f}", Ln(10)) "`n`n"

output .= "  x       ln(x)      log₁₀(x)    Conversions`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for x in testValues {
    result := ConvertLogarithms(x)

    output .= Format("{:6.4f}", result.x)
    output .= Format("{:12.8f}", result.ln)
    output .= Format("{:12.8f}", result.log)
    output .= "    ln=" Format("{:.6f}", result.lnFromLog)
    output .= " log=" Format("{:.6f}", result.logFromLn)
    output .= "`n"
}

output .= "`nFormulas:`n"
output .= "  ln(x) = log₁₀(x) × ln(10)`n"
output .= "  log₁₀(x) = ln(x) / ln(10)"

MsgBox(output, "Base Conversion", "Icon!")

; ============================================================
; Example 5: Solving Equations with Natural Logarithms
; ============================================================

/**
 * Solve exponential equations using natural logarithms
 */
SolveExponentialEquations() {
    results := []

    ; Equation 1: e^x = 10
    ; Solution: x = ln(10)
    eq1_target := 10
    eq1_solution := Ln(eq1_target)
    eq1_verify := Exp(eq1_solution)
    results.Push({
        equation: "e^x = " eq1_target,
        solution: "x = ln(" eq1_target ")",
        value: eq1_solution,
        verify: eq1_verify
    })

    ; Equation 2: e^(2x) = 100
    ; Solution: x = ln(100) / 2
    eq2_target := 100
    eq2_solution := Ln(eq2_target) / 2
    eq2_verify := Exp(2 * eq2_solution)
    results.Push({
        equation: "e^(2x) = " eq2_target,
        solution: "x = ln(" eq2_target ") / 2",
        value: eq2_solution,
        verify: eq2_verify
    })

    ; Equation 3: 5 × e^x = 50
    ; Solution: x = ln(50/5) = ln(10)
    eq3_coeff := 5
    eq3_target := 50
    eq3_solution := Ln(eq3_target / eq3_coeff)
    eq3_verify := eq3_coeff * Exp(eq3_solution)
    results.Push({
        equation: eq3_coeff " × e^x = " eq3_target,
        solution: "x = ln(" eq3_target "/" eq3_coeff ")",
        value: eq3_solution,
        verify: eq3_verify
    })

    return results
}

results := SolveExponentialEquations()

output := "SOLVING EXPONENTIAL EQUATIONS:`n`n"

for result in results {
    output .= "Equation: " result.equation "`n"
    output .= "Solution: " result.solution "`n"
    output .= "x = " Format("{:.8f}", result.value) "`n"
    output .= "Verify: " Format("{:.6f}", result.verify) "`n`n"
}

MsgBox(output, "Solving Equations", "Icon!")

; ============================================================
; Example 6: Continuous Growth Rate Calculations
; ============================================================

/**
 * Calculate continuous growth rate
 * If P(t) = P₀ × e^(rt), then r = ln(P(t)/P₀) / t
 */
ContinuousGrowthRate(initialValue, finalValue, time) {
    ratio := finalValue / initialValue
    rate := Ln(ratio) / time
    return rate
}

/**
 * Calculate doubling time
 * t = ln(2) / r
 */
DoublingTime(rate) {
    return Ln(2) / rate
}

/**
 * Calculate time to reach target
 * t = ln(target/initial) / r
 */
TimeToReach(initial, target, rate) {
    return Ln(target / initial) / rate
}

output := "CONTINUOUS GROWTH RATE CALCULATIONS:`n`n"

; Investment example
initial := 1000
final := 2000
years := 10
rate := ContinuousGrowthRate(initial, final, years)
doubling := DoublingTime(rate)

output .= "Investment Growth:`n"
output .= "  Initial: $" initial "`n"
output .= "  Final: $" final "`n"
output .= "  Time: " years " years`n"
output .= "  Growth Rate: " Format("{:.4f}", rate) " (" Format("{:.2f}", rate * 100) "% per year)`n"
output .= "  Doubling Time: " Format("{:.2f}", doubling) " years`n`n"

; Population growth
popInitial := 5000
popFinal := 8000
popTime := 15
popRate := ContinuousGrowthRate(popInitial, popFinal, popTime)
popDoubling := DoublingTime(popRate)

output .= "Population Growth:`n"
output .= "  Initial: " popInitial " people`n"
output .= "  Final: " popFinal " people`n"
output .= "  Time: " popTime " years`n"
output .= "  Growth Rate: " Format("{:.4f}", popRate) " (" Format("{:.2f}", popRate * 100) "% per year)`n"
output .= "  Doubling Time: " Format("{:.2f}", popDoubling) " years"

MsgBox(output, "Growth Rate", "Icon!")

; ============================================================
; Example 7: Natural Logarithm in Probability
; ============================================================

/**
 * Calculate information content (Shannon information)
 * I = -ln(P)
 */
InformationContent(probability) {
    if (probability <= 0 || probability > 1)
        throw ValueError("Probability must be between 0 and 1")
    return -Ln(probability)
}

/**
 * Calculate entropy (expected information)
 * H = -Σ(P(x) × ln(P(x)))
 */
CalculateEntropy(probabilities) {
    entropy := 0
    for p in probabilities {
        if (p > 0)
            entropy -= p * Ln(p)
    }
    return entropy
}

; Information content for various probabilities
probabilities := [1.0, 0.5, 0.25, 0.1, 0.01, 0.001]

output := "INFORMATION CONTENT IN PROBABILITY:`n`n"
output .= "Formula: I = -ln(P) (in nats)`n`n"

output .= "Probability   Information (nats)   Interpretation`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for p in probabilities {
    info := InformationContent(p)
    interpretation := p = 1.0 ? "Certain (no surprise)"
                    : p >= 0.5 ? "Likely"
                    : p >= 0.1 ? "Somewhat unlikely"
                    : p >= 0.01 ? "Rare"
                    : "Very rare"

    output .= Format("{:11.3f}", p)
    output .= Format("{:20.4f}", info)
    output .= "   " interpretation
    output .= "`n"
}

; Entropy example
output .= "`nEntropy Example:`n"
fairCoin := [0.5, 0.5]
biasedCoin := [0.9, 0.1]
fairDie := [1/6, 1/6, 1/6, 1/6, 1/6, 1/6]

output .= "  Fair coin: H = " Format("{:.4f}", CalculateEntropy(fairCoin)) " nats`n"
output .= "  Biased coin: H = " Format("{:.4f}", CalculateEntropy(biasedCoin)) " nats`n"
output .= "  Fair die: H = " Format("{:.4f}", CalculateEntropy(fairDie)) " nats`n`n"

output .= "Higher entropy = more uncertainty"

MsgBox(output, "Information & Entropy", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
LN() FUNCTION REFERENCE:

Syntax:
  Result := Ln(Number)

Parameters:
  Number - Positive number (must be > 0)

Return Value:
  Float - Natural logarithm (base e)

Definition:
  If ln(x) = y, then e^y = x
  where e ≈ 2.718281828459045

Key Properties:
• ln(1) = 0
• ln(e) = 1
• ln(e²) = 2
• ln(e^x) = x
• e^(ln(x)) = x

Logarithm Rules:
✓ ln(a × b) = ln(a) + ln(b)
✓ ln(a / b) = ln(a) - ln(b)
✓ ln(a^n) = n × ln(a)
✓ ln(√a) = ln(a) / 2
✓ ln(1/a) = -ln(a)
✓ ln(e^x) = x

Base Conversion:
  ln(x) = log₁₀(x) × ln(10)
  ln(x) = log₁₀(x) / 0.4343
  log₁₀(x) = ln(x) / ln(10)
  log₁₀(x) = ln(x) × 0.4343

Common Values:
ln(1) = 0
ln(2) ≈ 0.693
ln(e) = 1
ln(10) ≈ 2.303

Why Natural Logarithm?
✓ Derivative of ln(x) = 1/x
✓ Integral of 1/x = ln(x)
✓ Natural in calculus
✓ Continuous growth/decay
✓ Information theory
✓ Probability distributions

Applications:
✓ Continuous compounding
✓ Growth rate calculations
✓ Half-life and decay
✓ Information entropy
✓ Statistical distributions
✓ Machine learning
✓ Signal processing
)"

MsgBox(info, "Ln() Reference", "Icon!")
