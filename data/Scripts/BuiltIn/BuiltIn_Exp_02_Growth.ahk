#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Exp_02_Growth.ahk
 * 
 * DESCRIPTION:
 * Exponential growth applications using Exp() function for compound interest and population models
 * 
 * FEATURES:
 * - Compound interest calculations (discrete and continuous)
 * - Population growth models
 * - Investment portfolio growth
 * - Bacterial growth simulation
 * - Viral spread modeling (epidemic curves)
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation & Financial Mathematics
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Exp
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Exp() for continuous growth
 * - Class-based financial models
 * - Array building for time series
 * - Property getters for calculations
 * - Comparison of growth models
 * 
 * LEARNING POINTS:
 * 1. Continuous compounding: A = P × e^(rt)
 * 2. Discrete compounding: A = P × (1 + r/n)^(nt)
 * 3. Population doubling time: t = ln(2)/r
 * 4. Exponential growth is unrealistic long-term (no limits)
 * 5. Growth rate vs growth factor relationship
 */

; ============================================================
; Example 1: Compound Interest - Continuous vs Discrete
; ============================================================

/**
 * Calculate compound interest with different compounding frequencies
 */
class CompoundInterest {
    __New(principal, annualRate, years) {
        this.principal := principal
        this.rate := annualRate
        this.years := years
    }

    /**
     * Continuous compounding: A = P × e^(rt)
     */
    Continuous() {
        return this.principal * Exp(this.rate * this.years)
    }

    /**
     * Annual compounding: A = P × (1 + r)^t
     */
    Annual() {
        return this.principal * (1 + this.rate) ** this.years
    }

    /**
     * N times per year: A = P × (1 + r/n)^(nt)
     */
    Periodic(n) {
        return this.principal * (1 + this.rate / n) ** (n * this.years)
    }

    /**
     * Get all standard compounding periods
     */
    AllMethods() {
        return {
            annual: this.Annual(),
            semiannual: this.Periodic(2),
            quarterly: this.Periodic(4),
            monthly: this.Periodic(12),
            daily: this.Periodic(365),
            continuous: this.Continuous()
        }
    }
}

principal := 10000
rate := 0.06  ; 6% annual rate
years := 10

investment := CompoundInterest(principal, rate, years)
results := investment.AllMethods()

output := "COMPOUND INTEREST COMPARISON:`n`n"
output .= "Principal: $" Format("{:,.2f}", principal) "`n"
output .= "Annual Rate: " (rate * 100) "%`n"
output .= "Time Period: " years " years`n`n"

output .= "Compounding Method          Final Amount    Interest Earned`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

methods := [{
    name: "Annual (1x/year)", value: results.annual }, {
        name: "Semiannual (2x/year)", value: results.semiannual }, {
            name: "Quarterly (4x/year)", value: results.quarterly }, {
                name: "Monthly (12x/year)", value: results.monthly }, {
                    name: "Daily (365x/year)", value: results.daily }, {
                        name: "Continuous (∞)", value: results.continuous
                    }
]

for method in methods {
    interest := method.value - principal
    output .= Format("{:-24s}", method.name)
    output .= " $" Format("{:>10,.2f}", method.value)
    output .= "    $" Format("{:>9,.2f}", interest) "`n"
}

output .= "`nDifference (Continuous - Annual): $"
output .= Format("{:,.2f}", results.continuous - results.annual)

MsgBox(output, "Compound Interest", "Icon!")

; ============================================================
; Example 2: Investment Growth Timeline
; ============================================================

/**
 * Generate investment growth timeline
 */
GenerateGrowthTimeline(principal, rate, years) {
    timeline := []

    Loop years + 1 {
        year := A_Index - 1
        amount := principal * Exp(rate * year)
        interest := amount - principal

        timeline.Push({
            year: year,
            amount: amount,
            interest: interest
        })
    }

    return timeline
}

/**
 * Find when investment doubles
 */
DoublingTime(rate) {
    ; ln(2) / r
    return Ln(2) / rate
}

principal := 5000
rate := 0.08  ; 8% annual rate
years := 15

timeline := GenerateGrowthTimeline(principal, rate, years)
doublingTime := DoublingTime(rate)

output := "INVESTMENT GROWTH TIMELINE:`n`n"
output .= "Initial Investment: $" Format("{:,.2f}", principal) "`n"
output .= "Annual Return: " (rate * 100) "%`n"
output .= "Doubling Time: " Format("{:.2f}", doublingTime) " years`n`n"

output .= "Year    Balance        Growth       Total Interest`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for entry in timeline {
    if (Mod(entry.year, 3) = 0 || entry.year = years) {
        output .= Format("{:4d}", entry.year)
        output .= "  $" Format("{:>10,.2f}", entry.amount)

        if (entry.year > 0) {
            prevAmount := timeline[entry.year].amount
            growth := entry.amount - prevAmount
            output .= "  $" Format("{:>8,.2f}", growth)
        } else {
            output .= "           -   "
        }

        output .= "  $" Format("{:>10,.2f}", entry.interest)
        output .= "`n"
    }
}

MsgBox(output, "Growth Timeline", "Icon!")

; ============================================================
; Example 3: Population Growth Model
; ============================================================

class PopulationModel {
    __New(initial, growthRate) {
        this.initial := initial
        this.rate := growthRate  ; Annual growth rate as decimal
    }

    /**
     * Calculate population at time t
     * P(t) = P₀ × e^(rt)
     */
    At(time) {
        return this.initial * Exp(this.rate * time)
    }

    /**
     * Time to reach target population
     * t = ln(P/P₀) / r
     */
    TimeToReach(target) {
        if (target <= this.initial)
            return 0
        return Ln(target / this.initial) / this.rate
    }

    /**
     * Doubling time
     */
    DoublingTime() {
        return Ln(2) / this.rate
    }

    /**
     * Growth rate as percentage
     */
    GrowthPercent() {
        return this.rate * 100
    }

    /**
     * Generate population projection
     */
    Project(years, interval := 1) {
        projections := []

        for t := 0 to years step interval {
            pop := this.At(t)
            projections.Push({
                year: t,
                population: pop
            })
            }
            return projections
    }
}

; World population example (simplified)
currentPop := 8000000000  ; 8 billion
growthRate := 0.01  ; 1% annual growth

model := PopulationModel(currentPop, growthRate)
projections := model.Project(50, 10)

output := "POPULATION GROWTH PROJECTION:`n`n"
output .= "Current Population: " Format("{:,.0f}", currentPop) "`n"
output .= "Annual Growth Rate: " Format("{:.2f}", model.GrowthPercent()) "%`n"
output .= "Doubling Time: " Format("{:.1f}", model.DoublingTime()) " years`n`n"

output .= "Year    Population (billions)`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for proj in projections {
    output .= Format("{:4d}", proj.year)
    output .= "    " Format("{:6.2f}", proj.population / 1000000000)
    output .= "`n"
}

; Time to reach milestones
output .= "`nMilestones:`n"
milestones := [10000000000, 12000000000, 16000000000]
for target in milestones {
    years := model.TimeToReach(target)
    output .= Format("{:,.0f}", target) " people in "
    output .= Format("{:.1f}", years) " years`n"
}

MsgBox(output, "Population Growth", "Icon!")

; ============================================================
; Example 4: Bacterial Growth
; ============================================================

/**
 * Model bacterial colony growth
 * Bacteria often double at regular intervals
 */
class BacterialGrowth {
    __New(initial, doublingTime) {
        this.initial := initial
        this.doublingTime := doublingTime  ; Time for population to double
        this.rate := Ln(2) / doublingTime  ; Calculate growth rate
    }

    /**
     * Population at time t (in same units as doubling time)
     */
    At(time) {
        return this.initial * Exp(this.rate * time)
    }

    /**
     * Alternative: using doubling formula
     * N(t) = N₀ × 2^(t/td)
     */
    AtDoubling(time) {
        return this.initial * (2 ** (time / this.doublingTime))
    }

    /**
     * Number of generations (doublings)
     */
    Generations(time) {
        return time / this.doublingTime
    }
}

; E. coli bacteria (doubles every 20 minutes)
initial := 100
doublingTime := 20  ; minutes

bacteria := BacterialGrowth(initial, doublingTime)

output := "BACTERIAL GROWTH SIMULATION:`n`n"
output .= "Species: E. coli (approximate)`n"
output .= "Initial Count: " initial " cells`n"
output .= "Doubling Time: " doublingTime " minutes`n`n"

output .= "Time (min)  Generations  Population      Scientific`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

times := [0, 20, 40, 60, 120, 180, 240, 360, 480]

for t in times {
    gen := bacteria.Generations(t)
    pop := bacteria.At(t)

    output .= Format("{:10d}", t)
    output .= Format("{:13.1f}", gen)
    output .= Format("{:15,.0f}", pop)
    output .= Format("{:15.2e}", pop)
    output .= "`n"
}

output .= "`nAfter 8 hours (480 min): "
output .= Format("{:.2e}", bacteria.At(480)) " cells"

MsgBox(output, "Bacterial Growth", "Icon!")

; ============================================================
; Example 5: Retirement Savings Calculator
; ============================================================

/**
 * Calculate retirement savings with regular contributions
 * Combines continuous growth with periodic deposits
 */
class RetirementSavings {
    __New(initialBalance, monthlyContribution, annualReturn, years) {
        this.initial := initialBalance
        this.monthly := monthlyContribution
        this.rate := annualReturn
        this.years := years
    }

    /**
     * Future value with continuous compounding and monthly contributions
     * Approximation using discrete monthly compounding
     */
    FutureValue() {
        monthlyRate := this.rate / 12
        months := this.years * 12

        ; Initial balance growth
        initialGrowth := this.initial * Exp(this.rate * this.years)

        ; Future value of annuity (monthly contributions)
        if (monthlyRate > 0) {
            contributionGrowth := this.monthly *
                ((1 + monthlyRate) ** months - 1) / monthlyRate
        } else {
            contributionGrowth := this.monthly * months
        }

        return initialGrowth + contributionGrowth
    }

    /**
     * Total contributions over period
     */
    TotalContributions() {
        return this.initial + (this.monthly * 12 * this.years)
    }

    /**
     * Interest/growth earned
     */
    InterestEarned() {
        return this.FutureValue() - this.TotalContributions()
    }
}

initial := 25000
monthly := 500
returnRate := 0.07  ; 7% annual return
years := 30

retirement := RetirementSavings(initial, monthly, returnRate, years)

output := "RETIREMENT SAVINGS PROJECTION:`n`n"
output .= "Starting Balance: $" Format("{:,.2f}", initial) "`n"
output .= "Monthly Contribution: $" Format("{:,.2f}", monthly) "`n"
output .= "Expected Annual Return: " (returnRate * 100) "%`n"
output .= "Time Horizon: " years " years`n`n"

output .= "Results:`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

totalContrib := retirement.TotalContributions()
futureVal := retirement.FutureValue()
interest := retirement.InterestEarned()

output .= "Total Contributions:  $" Format("{:>12,.2f}", totalContrib) "`n"
output .= "Investment Growth:    $" Format("{:>12,.2f}", interest) "`n"
output .= "Final Balance:        $" Format("{:>12,.2f}", futureVal) "`n`n"

output .= "Growth Multiple: " Format("{:.2f}", futureVal / totalContrib) "x`n"
output .= "Effective Rate: " Format("{:.1f}", (interest / totalContrib) * 100) "%"

MsgBox(output, "Retirement Savings", "Icon!")

; ============================================================
; Example 6: Rule of 72 vs Actual Doubling Time
; ============================================================

/**
 * Compare Rule of 72 approximation with actual doubling time
 * Rule of 72: years ≈ 72 / (rate × 100)
 * Actual: years = ln(2) / rate
 */
CompareDoublingMethods() {
    rates := [0.01, 0.03, 0.05, 0.07, 0.08, 0.10, 0.12, 0.15]
    results := []

    for rate in rates {
        ; Actual doubling time
        actual := Ln(2) / rate

        ; Rule of 72
        rule72 := 72 / (rate * 100)

        ; Rule of 69.3 (more accurate)
        rule69 := 69.3 / (rate * 100)

        ; Error
        error72 := Abs(actual - rule72)
        error69 := Abs(actual - rule69)

        results.Push({
            rate: rate,
            actual: actual,
            rule72: rule72,
            rule69: rule69,
            error72: error72,
            error69: error69
        })
    }

    return results
}

results := CompareDoublingMethods()

output := "DOUBLING TIME COMPARISON:`n`n"
output .= "Rate   Actual   Rule72   Rule69   Error72  Error69`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for r in results {
    output .= Format("{:4.0f}%", r.rate * 100)
    output .= Format("{:8.2f}", r.actual)
    output .= Format("{:9.2f}", r.rule72)
    output .= Format("{:9.2f}", r.rule69)
    output .= Format("{:9.3f}", r.error72)
    output .= Format("{:9.3f}", r.error69)
    output .= "`n"
}

output .= "`nRule of 72: Quick mental math`n"
output .= "Rule of 69.3: More accurate for continuous compounding"

MsgBox(output, "Doubling Time Methods", "Icon!")

; ============================================================
; Example 7: Comparing Different Investments
; ============================================================

/**
 * Compare multiple investment strategies
 */
class Investment {
    __New(name, principal, rate, years) {
        this.name := name
        this.principal := principal
        this.rate := rate
        this.years := years
    }

    FinalValue() {
        return this.principal * Exp(this.rate * this.years)
    }

    TotalReturn() {
        return this.FinalValue() - this.principal
    }

    ReturnPercent() {
        return (this.TotalReturn() / this.principal) * 100
    }

    CAGR() {
        ; Compound Annual Growth Rate
        return (Exp(this.rate) - 1) * 100
    }
}

investments := [
    Investment("Conservative Bonds", 10000, 0.03, 10),
    Investment("Balanced Portfolio", 10000, 0.07, 10),
    Investment("Aggressive Stocks", 10000, 0.10, 10),
    Investment("High-Risk Venture", 10000, 0.15, 10)
]

output := "INVESTMENT COMPARISON (10-YEAR HORIZON):`n`n"
output .= "Initial Investment: $10,000 each`n`n"

output .= "Strategy              Rate   Final Value  Total Return   CAGR`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for inv in investments {
    output .= Format("{:-20s}", inv.name)
    output .= Format("{:5.0f}%", inv.rate * 100)
    output .= "  $" Format("{:>10,.2f}", inv.FinalValue())
    output .= "  $" Format("{:>9,.2f}", inv.TotalReturn())
    output .= Format("{:7.2f}%", inv.CAGR())
    output .= "`n"
}

; Best and worst
best := investments[1]
worst := investments[1]

for inv in investments {
    if (inv.FinalValue() > best.FinalValue())
        best := inv
    if (inv.FinalValue() < worst.FinalValue())
        worst := inv
}

output .= "`nDifference (Best - Worst): $"
output .= Format("{:,.2f}", best.FinalValue() - worst.FinalValue())

MsgBox(output, "Investment Comparison", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                    (
                    EXPONENTIAL GROWTH REFERENCE:

                    Continuous Compound Interest:
                    A = P × e^(rt)
                    P = principal, r = rate, t = time

                    Discrete Compounding:
                    A = P × (1 + r/n)^(nt)
                    n = compounding periods per year

                    Population Growth:
                    P(t) = P₀ × e^(rt)
                    r = growth rate (as decimal)

                    Doubling Time:
                    t_double = ln(2) / r ≈ 0.693 / r

                    Rule of 72 (approximation):
                    years ≈ 72 / (rate × 100)

                    Compound Annual Growth Rate:
                    CAGR = e^r - 1

                    Key Formulas:
                    • Future Value: FV = PV × e^(rt)
                    • Time to reach goal: t = ln(FV/PV) / r
                    • Growth factor: e^r per unit time

                    Compounding Frequency Effects:
                    Annual (n=1) < Semiannual (n=2) <
                    Quarterly (n=4) < Monthly (n=12) <
                    Daily (n=365) < Continuous (n=∞)

                    Applications:
                    ✓ Investment returns
                    ✓ Retirement planning
                    ✓ Population forecasting
                    ✓ Bacterial growth
                    ✓ Economic modeling
                    ✓ Business projections
                    )"

MsgBox(info, "Exponential Growth Reference", "Icon!")
