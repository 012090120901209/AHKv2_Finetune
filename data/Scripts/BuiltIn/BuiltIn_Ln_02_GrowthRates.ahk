#Requires AutoHotkey v2.0

/**
 * BuiltIn_Ln_02_GrowthRates.ahk
 * 
 * DESCRIPTION:
 * Natural logarithm applications for calculating continuous growth rates and compound annual growth rate (CAGR)
 * 
 * FEATURES:
 * - Continuous growth rate calculations
 * - CAGR (Compound Annual Growth Rate)
 * - Doubling time and tripling time
 * - Effective vs nominal rates
 * - Growth rate comparisons
 * - Return on investment analysis
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation & Financial Mathematics
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Ln
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Ln() for growth rate calculations
 * - Exp() for continuous compounding
 * - Class-based financial models
 * - Property getters
 * - Mathematical formula implementations
 * 
 * LEARNING POINTS:
 * 1. Continuous rate: r = ln(final/initial) / time
 * 2. CAGR = (final/initial)^(1/years) - 1
 * 3. Doubling time = ln(2) / growth_rate
 * 4. Continuous compounding uses natural logs
 * 5. ln transforms multiplicative to additive
 */

; ============================================================
; Example 1: Continuous Growth Rate Calculator
; ============================================================

/**
 * Calculate continuous growth rate
 * r = ln(P_final / P_initial) / t
 */
class ContinuousGrowthRate {
    /**
     * Calculate growth rate from initial and final values
     */
    static Calculate(initial, final, time) {
        ratio := final / initial
        return Ln(ratio) / time
    }

    /**
     * Calculate final value from initial and rate
     */
    static FinalValue(initial, rate, time) {
        return initial * Exp(rate * time)
    }

    /**
     * Convert continuous rate to percentage
     */
    static ToPercent(rate) {
        return (Exp(rate) - 1) * 100
    }

    /**
     * Convert percentage growth to continuous rate
     */
    static FromPercent(percent) {
        return Ln(1 + percent / 100)
    }

    /**
     * Calculate time to reach target
     */
    static TimeToTarget(initial, target, rate) {
        return Ln(target / initial) / rate
    }
}

; Examples
scenarios := [{
    name: "Stock Investment", initial: 1000, final: 2500, time: 5 }, {
        name: "Population Growth", initial: 50000, final: 65000, time: 10 }, {
            name: "Business Revenue", initial: 100000, final: 500000, time: 7 }, {
                name: "Savings Account", initial: 5000, final: 6500, time: 3
            }
]

output := "CONTINUOUS GROWTH RATE ANALYSIS:`n`n"

for scenario in scenarios {
    rate := ContinuousGrowthRate.Calculate(scenario.initial, scenario.final, scenario.time)
    percentRate := ContinuousGrowthRate.ToPercent(rate)

    output .= scenario.name ":"
    output .= "`n  Initial: " Format("{:,.2f}", scenario.initial)
    output .= "`n  Final: " Format("{:,.2f}", scenario.final)
    output .= "`n  Time: " scenario.time " years"
    output .= "`n  Continuous Rate: " Format("{:.6f}", rate) " (" Format("{:.2f}", rate * 100) "%)"
    output .= "`n  Effective Rate: " Format("{:.2f}", percentRate) "%"
    output .= "`n`n"
}

MsgBox(output, "Continuous Growth Rates", "Icon!")

; ============================================================
; Example 2: CAGR vs Continuous Growth Rate
; ============================================================

/**
 * Calculate and compare CAGR with continuous growth rate
 */
class GrowthComparison {
    /**
     * Calculate CAGR (Compound Annual Growth Rate)
     * CAGR = (Final/Initial)^(1/years) - 1
     */
    static CAGR(initial, final, years) {
        return (final / initial) ** (1 / years) - 1
    }

    /**
     * Calculate continuous growth rate
     */
    static ContinuousRate(initial, final, years) {
        return Ln(final / initial) / years
    }

    /**
     * Compare both methods
     */
    static Compare(initial, final, years) {
        cagr := GrowthComparison.CAGR(initial, final, years)
        continuous := GrowthComparison.ContinuousRate(initial, final, years)

        ; Calculate effective annual rate from continuous
        effective := Exp(continuous) - 1

        return {
            cagr: cagr,
            continuous: continuous,
            effective: effective,
            difference: Abs(cagr - effective)
        }
    }
}

; Test various scenarios
tests := [{
    initial: 1000, final: 2000, years: 5, name: "Moderate Growth" }, {
        initial: 1000, final: 5000, years: 10, name: "High Growth" }, {
            initial: 1000, final: 1100, years: 2, name: "Low Growth" }, {
                initial: 10000, final: 100000, years: 20, name: "Very High Growth"
            }
]

output := "CAGR vs CONTINUOUS GROWTH RATE:`n`n"

for test in tests {
    comp := GrowthComparison.Compare(test.initial, test.final, test.years)

    output .= test.name ":"
    output .= "`n  " Format("{:,.0f}", test.initial) " → " Format("{:,.0f}", test.final)
    output .= " over " test.years " years"
    output .= "`n  CAGR: " Format("{:.4f}", comp.cagr * 100) "%"
    output .= "`n  Continuous: " Format("{:.4f}", comp.continuous * 100) "%"
    output .= "`n  Effective: " Format("{:.4f}", comp.effective * 100) "%"
    output .= "`n  Difference: " Format("{:.4f}", comp.difference * 100) "%"
    output .= "`n`n"
}

output .= "Note: CAGR and Effective rate from continuous`n"
output .= "growth are nearly identical!"

MsgBox(output, "CAGR Comparison", "Icon!")

; ============================================================
; Example 3: Doubling Time and Tripling Time
; ============================================================

/**
 * Calculate doubling and tripling times
 */
class GrowthTime {
    /**
     * Calculate doubling time from growth rate
     * t = ln(2) / r
     */
    static DoublingTime(rate) {
        return Ln(2) / rate
    }

    /**
     * Calculate tripling time
     * t = ln(3) / r
     */
    static TriplingTime(rate) {
        return Ln(3) / rate
    }

    /**
     * Calculate n-fold time
     */
    static NFoldTime(rate, n) {
        return Ln(n) / rate
    }

    /**
     * Growth rate from doubling time
     */
    static RateFromDoubling(doublingTime) {
        return Ln(2) / doublingTime
    }

    /**
     * Rule of 72 approximation vs actual
     */
    static CompareRule72(rate) {
        actual := GrowthTime.DoublingTime(rate)
        rule72 := 72 / (rate * 100)
        rule69 := 69.3 / (rate * 100)

        return {
            actual: actual,
            rule72: rule72,
            rule69: rule69,
            error72: Abs(actual - rule72),
            error69: Abs(actual - rule69)
        }
    }
}

; Various growth rates
rates := [0.02, 0.05, 0.07, 0.10, 0.12, 0.15, 0.20]

output := "DOUBLING AND TRIPLING TIMES:`n`n"
output .= "Rate    Doubling   Tripling   10-Fold   Rule72   Rule69`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for rate in rates {
    doubling := GrowthTime.DoublingTime(rate)
    tripling := GrowthTime.TriplingTime(rate)
    tenfold := GrowthTime.NFoldTime(rate, 10)
    comparison := GrowthTime.CompareRule72(rate)

    output .= Format("{:4.0f}%", rate * 100)
    output .= Format("{:10.2f}", doubling)
    output .= Format("{:11.2f}", tripling)
    output .= Format("{:10.2f}", tenfold)
    output .= Format("{:9.2f}", comparison.rule72)
    output .= Format("{:9.2f}", comparison.rule69)
    output .= "`n"
}

output .= "`nFormulas:`n"
output .= "  Doubling: t = ln(2) / r ≈ 0.693 / r`n"
output .= "  Tripling: t = ln(3) / r ≈ 1.099 / r`n"
output .= "  Rule of 72: t ≈ 72 / (r × 100)"

MsgBox(output, "Growth Times", "Icon!")

; ============================================================
; Example 4: Return on Investment (ROI) Analysis
; ============================================================

/**
 * Analyze investment returns using natural logarithms
 */
class ROIAnalysis {
    __New(investments) {
        this.investments := investments
    }

    /**
     * Calculate annualized return
     */
    AnnualizedReturn(investment) {
        return ContinuousGrowthRate.Calculate(
            investment.initial,
            investment.final,
            investment.years
        )
    }

    /**
     * Calculate total return
     */
    TotalReturn(investment) {
        return (investment.final - investment.initial) / investment.initial
    }

    /**
     * Compare all investments
     */
    CompareAll() {
        results := []

        for inv in this.investments {
            annualized := this.AnnualizedReturn(inv)
            total := this.TotalReturn(inv)
            effectiveRate := Exp(annualized) - 1

            results.Push({
                name: inv.name,
                initial: inv.initial,
                final: inv.final,
                years: inv.years,
                totalReturn: total * 100,
                annualized: annualized * 100,
                effective: effectiveRate * 100
            })
        }

        return results
    }

    /**
     * Find best investment
     */
    BestInvestment() {
        best := ""
        bestRate := -99999

        for inv in this.investments {
            rate := this.AnnualizedReturn(inv)
            if (rate > bestRate) {
                bestRate := rate
                best := inv.name
            }
        }

        return { name: best, rate: bestRate }
    }
}

; Portfolio of investments
investments := [{
    name: "Tech Stock A", initial: 5000, final: 12000, years: 4 }, {
        name: "Index Fund", initial: 10000, final: 18000, years: 7 }, {
            name: "Real Estate", initial: 50000, final: 85000, years: 10 }, {
                name: "Bond Fund", initial: 20000, final: 24000, years: 5 }, {
                    name: "Crypto (risky)", initial: 1000, final: 5000, years: 2
                }
]

portfolio := ROIAnalysis(investments)
results := portfolio.CompareAll()
best := portfolio.BestInvestment()

output := "INVESTMENT RETURN ANALYSIS:`n`n"
output .= "Investment           Years   Total Return   Annualized   Effective`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for result in results {
    output .= Format("{:-19s}", result.name)
    output .= Format("{:6d}", result.years)
    output .= Format("{:14.2f}%", result.totalReturn)
    output .= Format("{:13.2f}%", result.annualized)
    output .= Format("{:12.2f}%", result.effective)
    output .= "`n"
}

output .= "`nBest Investment: " best.name
output .= "`nAnnualized Return: " Format("{:.2f}", best.rate * 100) "%"

MsgBox(output, "ROI Analysis", "Icon!")

; ============================================================
; Example 5: Effective vs Nominal Interest Rates
; ============================================================

/**
 * Convert between nominal and effective rates
 */
class InterestRateConversion {
    /**
     * Effective rate from nominal rate with compounding
     * Effective = (1 + r/n)^n - 1
     */
    static NominalToEffective(nominalRate, compoundingsPerYear) {
        return (1 + nominalRate / compoundingsPerYear) ** compoundingsPerYear - 1
    }

    /**
     * Continuous compounding effective rate
     * Effective = e^r - 1
     */
    static ContinuousEffective(nominalRate) {
        return Exp(nominalRate) - 1
    }

    /**
     * Nominal rate from effective rate (continuous)
     * Nominal = ln(1 + effective)
     */
    static EffectiveToContinuous(effectiveRate) {
        return Ln(1 + effectiveRate)
    }

    /**
     * Compare all compounding frequencies
     */
    static CompareCompounding(nominalRate) {
        return {
            nominal: nominalRate,
            annual: InterestRateConversion.NominalToEffective(nominalRate, 1),
            semiannual: InterestRateConversion.NominalToEffective(nominalRate, 2),
            quarterly: InterestRateConversion.NominalToEffective(nominalRate, 4),
            monthly: InterestRateConversion.NominalToEffective(nominalRate, 12),
            daily: InterestRateConversion.NominalToEffective(nominalRate, 365),
            continuous: InterestRateConversion.ContinuousEffective(nominalRate)
        }
    }
}

nominalRates := [0.05, 0.08, 0.10, 0.12]

output := "EFFECTIVE vs NOMINAL INTEREST RATES:`n`n"

for nomRate in nominalRates {
    rates := InterestRateConversion.CompareCompounding(nomRate)

    output .= "Nominal Rate: " Format("{:.2f}", nomRate * 100) "%`n`n"

    output .= "Compounding         Effective Rate   Difference`n"
    output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

    compoundings := [{
        name: "Annual", rate: rates.annual }, {
            name: "Semiannual", rate: rates.semiannual }, {
                name: "Quarterly", rate: rates.quarterly }, {
                    name: "Monthly", rate: rates.monthly }, {
                        name: "Daily", rate: rates.daily }, {
                            name: "Continuous", rate: rates.continuous
                        }
    ]

    for comp in compoundings {
        diff := (comp.rate - nomRate) * 100

        output .= Format("{:-18s}", comp.name)
        output .= Format("{:13.4f}%", comp.rate * 100)
        output .= Format("{:14.4f}%", diff)
        output .= "`n"
    }

    output .= "`n"
}

MsgBox(output, "Interest Rate Conversion", "Icon!")

; ============================================================
; Example 6: Average Growth Rate of Multiple Periods
; ============================================================

/**
 * Calculate average growth rate across multiple periods
 */
class AverageGrowthRate {
    /**
     * Geometric mean of growth rates (correct method)
     */
    static GeometricMean(rates) {
        product := 1
        for rate in rates {
            product *= (1 + rate)
        }

        return product ** (1 / rates.Length) - 1
    }

    /**
     * Using logarithms (equivalent but more stable)
     */
    static LogMethod(rates) {
        sumLn := 0
        for rate in rates {
            sumLn += Ln(1 + rate)
        }

        avgLn := sumLn / rates.Length
        return Exp(avgLn) - 1
    }

    /**
     * Arithmetic mean (incorrect for growth rates)
     */
    static ArithmeticMean(rates) {
        sum := 0
        for rate in rates {
            sum += rate
        }
        return sum / rates.Length
    }

    /**
     * Compare methods
     */
    static Compare(rates) {
        geometric := AverageGrowthRate.GeometricMean(rates)
        logarithmic := AverageGrowthRate.LogMethod(rates)
        arithmetic := AverageGrowthRate.ArithmeticMean(rates)

        return {
            geometric: geometric,
            logarithmic: logarithmic,
            arithmetic: arithmetic,
            difference: Abs(geometric - logarithmic)
        }
    }
}

; Annual returns over 5 years
returns := [0.15, -0.05, 0.20, 0.08, -0.02]  ; 15%, -5%, 20%, 8%, -2%

comparison := AverageGrowthRate.Compare(returns)

output := "AVERAGE GROWTH RATE CALCULATION:`n`n"
output .= "Annual Returns:`n"

for i, ret in returns {
    output .= "  Year " i ": " Format("{:+.2f}", ret * 100) "%`n"
}

output .= "`nAverage Growth Rate Methods:`n`n"

output .= "Geometric Mean (Correct):`n"
output .= "  " Format("{:.4f}", comparison.geometric * 100) "%`n`n"

output .= "Logarithmic Method (Equivalent):`n"
output .= "  " Format("{:.4f}", comparison.logarithmic * 100) "%`n`n"

output .= "Arithmetic Mean (Incorrect!):`n"
output .= "  " Format("{:.4f}", comparison.arithmetic * 100) "%`n`n"

; Verify with actual compound growth
initial := 1000
final := initial
for rate in returns {
    final := final * (1 + rate)
}

actualAvg := (final / initial) ** (1 / returns.Length) - 1

output .= "Verification:`n"
output .= "  $1000 → $" Format("{:.2f}", final) " over 5 years`n"
output .= "  Actual average: " Format("{:.4f}", actualAvg * 100) "%`n`n"

output .= "Always use geometric mean for growth rates!"

MsgBox(output, "Average Growth Rate", "Icon!")

; ============================================================
; Example 7: Volatility and Growth
; ============================================================

/**
 * Analyze relationship between volatility and growth
 */
class VolatilityImpact {
    /**
     * Calculate arithmetic vs geometric average
     * Shows drag from volatility
     */
    static VolatilityDrag(returns) {
        arithmeticMean := 0
        for ret in returns {
            arithmeticMean += ret
        }
        arithmeticMean /= returns.Length

        ; Variance
        variance := 0
        for ret in returns {
            variance += (ret - arithmeticMean) ** 2
        }
        variance /= (returns.Length - 1)

        ; Geometric mean
        product := 1
        for ret in returns {
            product *= (1 + ret)
        }
        geometricMean := product ** (1 / returns.Length) - 1

        ; Drag
        drag := arithmeticMean - geometricMean

        return {
            arithmetic: arithmeticMean,
            geometric: geometricMean,
            variance: variance,
            volatility: Sqrt(variance),
            drag: drag
        }
    }
}

; Two investments: stable vs volatile (same arithmetic mean)
stableReturns := [0.08, 0.08, 0.08, 0.08, 0.08]
volatileReturns := [0.30, -0.10, 0.15, -0.05, 0.10]

stableAnalysis := VolatilityImpact.VolatilityDrag(stableReturns)
volatileAnalysis := VolatilityImpact.VolatilityDrag(volatileReturns)

output := "VOLATILITY IMPACT ON GROWTH:`n`n"

output .= "Stable Investment (constant returns):`n"
output .= "  Arithmetic Mean: " Format("{:.2f}", stableAnalysis.arithmetic * 100) "%`n"
output .= "  Geometric Mean: " Format("{:.2f}", stableAnalysis.geometric * 100) "%`n"
output .= "  Volatility: " Format("{:.2f}", stableAnalysis.volatility * 100) "%`n"
output .= "  Volatility Drag: " Format("{:.2f}", stableAnalysis.drag * 100) "%`n`n"

output .= "Volatile Investment (same arithmetic mean):`n"
output .= "  Arithmetic Mean: " Format("{:.2f}", volatileAnalysis.arithmetic * 100) "%`n"
output .= "  Geometric Mean: " Format("{:.2f}", volatileAnalysis.geometric * 100) "%`n"
output .= "  Volatility: " Format("{:.2f}", volatileAnalysis.volatility * 100) "%`n"
output .= "  Volatility Drag: " Format("{:.2f}", volatileAnalysis.drag * 100) "%`n`n"

output .= "Key Insight: Higher volatility reduces actual returns,`n"
output .= "even with the same average return!"

MsgBox(output, "Volatility & Growth", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                                                            (
                                                            NATURAL LOG IN GROWTH RATES REFERENCE:

                                                            Continuous Growth Rate:
                                                            r = ln(Final / Initial) / time
                                                            Final = Initial × e^(rt)

                                                            Doubling Time:
                                                            t = ln(2) / r ≈ 0.693 / r
                                                            Rule of 72: t ≈ 72 / (r × 100)

                                                            Tripling Time:
                                                            t = ln(3) / r ≈ 1.099 / r

                                                            N-fold Time:
                                                            t = ln(n) / r

                                                            CAGR (Compound Annual Growth Rate):
                                                            CAGR = (Final / Initial)^(1/years) - 1

                                                            Continuous to Effective Rate:
                                                            Effective = e^r - 1

                                                            Effective to Continuous Rate:
                                                            Continuous = ln(1 + effective)

                                                            Geometric Mean of Returns:
                                                            GM = exp(mean(ln(1 + r))) - 1
                                                            Or: GM = ∏(1 + rᵢ)^(1/n) - 1

                                                            Key Relationships:
                                                            • ln(1 + r) ≈ r for small r
                                                            • Continuous rate < CAGR < Arithmetic
                                                            • Volatility drag = Arithmetic - Geometric

                                                            Applications:
                                                            ✓ Investment analysis
                                                            ✓ Population forecasting
                                                            ✓ Economic modeling
                                                            ✓ Business metrics
                                                            ✓ Compound growth
                                                            ✓ Return comparisons

                                                            Why Use Natural Log?
                                                            ✓ Mathematically natural
                                                            ✓ Continuous compounding
                                                            ✓ Additive property for ratios
                                                            ✓ Stable numeric calculations
                                                            ✓ Derivative-friendly
                                                            )"

MsgBox(info, "Growth Rates Reference", "Icon!")
