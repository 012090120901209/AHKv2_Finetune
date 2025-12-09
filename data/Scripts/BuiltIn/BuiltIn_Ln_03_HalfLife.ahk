#Requires AutoHotkey v2.0

/**
* BuiltIn_Ln_03_HalfLife.ahk
*
* DESCRIPTION:
* Natural logarithm applications for half-life calculations in radioactive decay, drug metabolism, and decay processes
*
* FEATURES:
* - Half-life calculations and conversions
* - Decay constant relationships
* - Radioactive dating methods
* - Drug half-life in pharmacology
* - Mean lifetime calculations
* - Activity and decay rate analysis
*
* SOURCE:
* AutoHotkey v2 Documentation & Physics/Chemistry
* https://www.autohotkey.com/docs/v2/lib/Math.htm#Ln
*
* KEY V2 FEATURES DEMONSTRATED:
* - Ln() for half-life formulas
* - Exp() for decay calculations
* - Class-based decay models
* - Time-based calculations
* - Scientific applications
*
* LEARNING POINTS:
* 1. Half-life: t₁/₂ = ln(2) / λ
* 2. Decay constant: λ = ln(2) / t₁/₂
* 3. Mean lifetime: τ = 1/λ = t₁/₂ / ln(2)
* 4. N(t) = N₀ × e^(-λt) = N₀ × (1/2)^(t/t₁/₂)
* 5. Time to decay: t = -ln(N/N₀) / λ
*/

; ============================================================
; Example 1: Half-Life and Decay Constant
; ============================================================

/**
* Half-life calculations and conversions
*/
class HalfLife {
    /**
    * Calculate decay constant from half-life
    * λ = ln(2) / t₁/₂
    */
    static DecayConstant(halfLife) {
        return Ln(2) / halfLife
    }

    /**
    * Calculate half-life from decay constant
    * t₁/₂ = ln(2) / λ
    */
    static FromDecayConstant(lambda) {
        return Ln(2) / lambda
    }

    /**
    * Calculate mean lifetime
    * τ = 1/λ = t₁/₂ / ln(2)
    */
    static MeanLifetime(halfLife) {
        return halfLife / Ln(2)
    }

    /**
    * Calculate amount remaining after time t
    * N(t) = N₀ × e^(-λt)
    */
    static AmountRemaining(initial, halfLife, time) {
        lambda := HalfLife.DecayConstant(halfLife)
        return initial * Exp(-lambda * time)
    }

    /**
    * Calculate time for specific decay
    * t = -ln(N/N₀) / λ
    */
    static TimeToDecay(initial, remaining, halfLife) {
        lambda := HalfLife.DecayConstant(halfLife)
        ratio := remaining / initial
        return -Ln(ratio) / lambda
    }

    /**
    * Number of half-lives elapsed
    */
    static HalfLivesElapsed(time, halfLife) {
        return time / halfLife
    }

    /**
    * Percentage remaining after n half-lives
    */
    static PercentAfterHalfLives(n) {
        return (0.5 ** n) * 100
    }
}

; Common radioactive isotopes
isotopes := [
{
    name: "Uranium-238", halfLife: 4.468e9, unit: "years"},
    {
        name: "Carbon-14", halfLife: 5730, unit: "years"},
        {
            name: "Radium-226", halfLife: 1600, unit: "years"},
            {
                name: "Tritium (H-3)", halfLife: 12.32, unit: "years"},
                {
                    name: "Iodine-131", halfLife: 8.02, unit: "days"},
                    {
                        name: "Radon-222", halfLife: 3.82, unit: "days"},
                        {
                            name: "Polonium-214", halfLife: 164, unit: "microseconds"
                        }
                        ]

                        output := "HALF-LIFE AND DECAY CONSTANTS:`n`n"
                        output .= "Formula: λ = ln(2) / t₁/₂`n`n"

                        output .= "Isotope            Half-Life         Decay Constant   Mean Lifetime`n"
                        output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                        for isotope in isotopes {
                            lambda := HalfLife.DecayConstant(isotope.halfLife)
                            meanLife := HalfLife.MeanLifetime(isotope.halfLife)

                            output .= Format("{:-17s}", isotope.name)
                            output .= Format("{:14.3e} ", isotope.halfLife) isotope.unit
                            output .= Format("{:16.6e}", lambda)
                            output .= Format("{:16.3e}", meanLife)
                            output .= "`n"
                        }

                        MsgBox(output, "Half-Life Basics", "Icon!")

                        ; ============================================================
                        ; Example 2: Radioactive Decay Timeline
                        ; ============================================================

                        /**
                        * Generate decay timeline for an isotope
                        */
                        class DecayTimeline {
                            __New(isotope, halfLife, initialAmount) {
                                this.isotope := isotope
                                this.halfLife := halfLife
                                this.initial := initialAmount
                                this.lambda := HalfLife.DecayConstant(halfLife)
                            }

                            /**
                            * Generate timeline at half-life intervals
                            */
                            GenerateTimeline(numHalfLives) {
                                timeline := []

                                Loop numHalfLives + 1 {
                                    n := A_Index - 1
                                    time := n * this.halfLife
                                    amount := this.initial * (0.5 ** n)
                                    percentage := (amount / this.initial) * 100

                                    timeline.Push({
                                        halfLives: n,
                                        time: time,
                                        amount: amount,
                                        percentage: percentage
                                    })
                                }

                                return timeline
                            }

                            /**
                            * Find time when specific percentage remains
                            */
                            TimeToPercentage(targetPercent) {
                                ratio := targetPercent / 100
                                return -Ln(ratio) / this.lambda
                            }
                        }

                        ; Carbon-14 example
                        c14 := DecayTimeline("Carbon-14", 5730, 100)
                        timeline := c14.GenerateTimeline(8)

                        output := "RADIOACTIVE DECAY TIMELINE:`n`n"
                        output .= "Isotope: Carbon-14`n"
                        output .= "Half-Life: 5,730 years`n"
                        output .= "Initial Amount: 100 grams`n`n"

                        output .= "Half-Lives   Time (years)   Amount (g)   Percentage`n"
                        output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                        for entry in timeline {
                            output .= Format("{:10d}", entry.halfLives)
                            output .= Format("{:15,.0f}", entry.time)
                            output .= Format("{:13.4f}", entry.amount)
                            output .= Format("{:12.2f}%", entry.percentage)
                            output .= "`n"
                        }

                        ; Special percentages
                        output .= "`nTime to reach specific percentages:`n"
                        percentages := [90, 75, 50, 25, 10, 1]

                        for pct in percentages {
                            time := c14.TimeToPercentage(pct)
                            output .= "  " pct "% remaining: " Format("{:,.0f}", time) " years`n"
                        }

                        MsgBox(output, "Decay Timeline", "Icon!")

                        ; ============================================================
                        ; Example 3: Carbon Dating Application
                        ; ============================================================

                        /**
                        * Carbon-14 dating calculator
                        */
                        class CarbonDating {
                            static HALF_LIFE := 5730  ; years

                            /**
                            * Calculate age from percentage remaining
                            * age = -ln(ratio) / λ
                            */
                            static CalculateAge(percentRemaining) {
                                lambda := HalfLife.DecayConstant(CarbonDating.HALF_LIFE)
                                ratio := percentRemaining / 100
                                return -Ln(ratio) / lambda
                            }

                            /**
                            * Calculate percentage remaining from age
                            */
                            static PercentRemaining(age) {
                                lambda := HalfLife.DecayConstant(CarbonDating.HALF_LIFE)
                                return 100 * Exp(-lambda * age)
                            }

                            /**
                            * Estimate uncertainty (simplified)
                            */
                            static EstimateUncertainty(age) {
                                ; Rough estimate: ±40-80 years for samples < 50,000 years
                                return Max(40, Min(age * 0.01, 500))
                            }
                        }

                        ; Archaeological samples
                        samples := [
                        {
                            name: "Ancient Scroll", percentC14: 87.5},
                            {
                                name: "Wooden Artifact", percentC14: 65.0},
                                {
                                    name: "Bone Fragment", percentC14: 50.0},
                                    {
                                        name: "Charcoal Sample", percentC14: 25.0},
                                        {
                                            name: "Textile Piece", percentC14: 12.5},
                                            {
                                                name: "Cave Painting", percentC14: 6.25
                                            }
                                            ]

                                            output := "CARBON-14 DATING ANALYSIS:`n`n"
                                            output .= "Half-Life of C-14: 5,730 years`n`n"

                                            output .= "Sample                % C-14   Estimated Age     Uncertainty`n"
                                            output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                                            for sample in samples {
                                                age := CarbonDating.CalculateAge(sample.percentC14)
                                                uncertainty := CarbonDating.EstimateUncertainty(age)

                                                output .= Format("{:-20s}", sample.name)
                                                output .= Format("{:7.2f}%", sample.percentC14)
                                                output .= Format("{:13,.0f}", age) " years"
                                                output .= "  ±" Format("{:.0f}", uncertainty)
                                                output .= "`n"
                                            }

                                            ; Maximum dating range
                                            output .= "`nMaximum Dating Range:`n"
                                            minDetectable := 1  ; 1% of original
                                            maxAge := CarbonDating.CalculateAge(minDetectable)
                                            output .= "  ~" Format("{:,.0f}", maxAge) " years (1% remaining)`n"
                                            output .= "  Practical limit: ~50,000 years"

                                            MsgBox(output, "Carbon Dating", "Icon!")

                                            ; ============================================================
                                            ; Example 4: Pharmacokinetics - Drug Half-Life
                                            ; ============================================================

                                            /**
                                            * Drug metabolism and elimination
                                            */
                                            class DrugHalfLife {
                                                __New(drugName, halfLife, initialDose) {
                                                    this.name := drugName
                                                    this.halfLife := halfLife  ; hours
                                                    this.initial := initialDose  ; mg
                                                    this.lambda := HalfLife.DecayConstant(halfLife)
                                                }

                                                /**
                                                * Concentration at time t
                                                */
                                                ConcentrationAt(hours) {
                                                    return this.initial * Exp(-this.lambda * hours)
                                                }

                                                /**
                                                * Time to reach target concentration
                                                */
                                                TimeToConcentration(targetConc) {
                                                    return -Ln(targetConc / this.initial) / this.lambda
                                                }

                                                /**
                                                * Dosing schedule to maintain therapeutic range
                                                */
                                                DosingSchedule(therapeuticMin, therapeuticMax) {
                                                    ; Time to reach minimum from maximum
                                                    interval := this.TimeToConcentration(therapeuticMin)

                                                    ; Dose needed to reach maximum
                                                    doseNeeded := therapeuticMax - (therapeuticMin * Exp(-this.lambda * interval))

                                                    return {
                                                        interval: interval,
                                                        dose: doseNeeded,
                                                        minLevel: therapeuticMin,
                                                        maxLevel: therapeuticMax
                                                    }
                                                }

                                                /**
                                                * Steady state concentration with repeated dosing
                                                */
                                                SteadyState(dose, interval) {
                                                    ; C_ss = dose / (1 - e^(-λ×interval))
                                                    return dose / (1 - Exp(-this.lambda * interval))
                                                }
                                            }

                                            ; Common medications
                                            medications := [
                                            DrugHalfLife("Aspirin", 0.25, 325),          ; 15 min half-life, 325mg
                                            DrugHalfLife("Caffeine", 5, 100),            ; 5 hr half-life, 100mg
                                            DrugHalfLife("Ibuprofen", 2, 400),           ; 2 hr half-life, 400mg
                                            DrugHalfLife("Diazepam", 43, 10),            ; 43 hr half-life, 10mg
                                            DrugHalfLife("Digoxin", 36, 0.25)            ; 36 hr half-life, 0.25mg
                                            ]

                                            output := "DRUG HALF-LIFE IN PHARMACOLOGY:`n`n"

                                            for drug in medications {
                                                output .= drug.name ":"
                                                output .= "`n  Initial Dose: " drug.initial " mg"
                                                output .= "`n  Half-Life: " drug.halfLife " hours"
                                                output .= "`n`n  Time Course:`n"

                                                ; Show concentration at key time points
                                                times := [1, 4, 12, 24, 48]
                                                for hours in times {
                                                    if (hours <= drug.halfLife * 5) {  ; Only show relevant times
                                                    conc := drug.ConcentrationAt(hours)
                                                    pct := (conc / drug.initial) * 100

                                                    output .= "    " hours " hours: "
                                                    output .= Format("{:.2f}", conc) " mg"
                                                    output .= " (" Format("{:.1f}", pct) "%)`n"
                                                }
                                            }

                                            output .= "`n"
                                        }

                                        MsgBox(output, "Drug Half-Life", "Icon!")

                                        ; ============================================================
                                        ; Example 5: Activity and Decay Rate
                                        ; ============================================================

                                        /**
                                        * Radioactive activity calculations
                                        * Activity A = λN (number of decays per unit time)
                                        */
                                        class RadioactiveActivity {
                                            /**
                                            * Calculate activity from amount
                                            * A = λN
                                            */
                                            static Activity(amount, halfLife) {
                                                lambda := HalfLife.DecayConstant(halfLife)
                                                return lambda * amount
                                            }

                                            /**
                                            * Activity at time t
                                            * A(t) = A₀ × e^(-λt)
                                            */
                                            static ActivityAt(initialActivity, halfLife, time) {
                                                lambda := HalfLife.DecayConstant(halfLife)
                                                return initialActivity * Exp(-lambda * time)
                                            }

                                            /**
                                            * Specific activity (activity per unit mass)
                                            */
                                            static SpecificActivity(halfLife, molarMass) {
                                                ; Activity per mole
                                                lambda := HalfLife.DecayConstant(halfLife)
                                                avogadro := 6.022e23
                                                activityPerMole := lambda * avogadro

                                                ; Per gram
                                                return activityPerMole / molarMass
                                            }

                                            /**
                                            * Convert between activity units
                                            * 1 Curie (Ci) = 3.7 × 10^10 Becquerel (Bq)
                                            */
                                            static BqToCi(becquerels) {
                                                return becquerels / 3.7e10
                                            }

                                            static CiToBq(curies) {
                                                return curies * 3.7e10
                                            }
                                        }

                                        ; Activity examples
                                        samples := [
                                        {
                                            isotope: "Cobalt-60", amount: 1e20, halfLife: 5.27, unit: "years"},
                                            {
                                                isotope: "Iodine-131", amount: 1e18, halfLife: 8.02, unit: "days"},
                                                {
                                                    isotope: "Technetium-99m", amount: 1e19, halfLife: 6.01, unit: "hours"
                                                }
                                                ]

                                                output := "RADIOACTIVE ACTIVITY CALCULATIONS:`n`n"
                                                output .= "Activity = λ × N (decays per second)`n`n"

                                                output .= "Isotope          Amount (atoms)   Activity (Bq)    Activity (Ci)`n"
                                                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                                                for sample in samples {
                                                    ; Convert half-life to seconds
                                                    halfLifeSeconds := sample.halfLife *
                                                    (sample.unit = "years" ? 365.25 * 24 * 3600
                                                    : sample.unit = "days" ? 24 * 3600
                                                    : 3600)

                                                    activity := RadioactiveActivity.Activity(sample.amount, halfLifeSeconds)
                                                    activityCi := RadioactiveActivity.BqToCi(activity)

                                                    output .= Format("{:-15s}", sample.isotope)
                                                    output .= Format("{:17.2e}", sample.amount)
                                                    output .= Format("{:16.2e}", activity)
                                                    output .= Format("{:16.2e}", activityCi)
                                                    output .= "`n"
                                                }

                                                output .= "`nUnits:`n"
                                                output .= "  1 Becquerel (Bq) = 1 decay/second`n"
                                                output .= "  1 Curie (Ci) = 3.7 × 10^10 Bq"

                                                MsgBox(output, "Radioactive Activity", "Icon!")

                                                ; ============================================================
                                                ; Example 6: Decay Chain Analysis
                                                ; ============================================================

                                                /**
                                                * Sequential decay (parent → daughter)
                                                */
                                                class DecayChain {
                                                    /**
                                                    * Bateman equation for parent-daughter decay
                                                    * Simplified for single decay step
                                                    */
                                                    static DaughterAmount(parentInitial, parentHalfLife, daughterHalfLife, time) {
                                                        lambda1 := HalfLife.DecayConstant(parentHalfLife)
                                                        lambda2 := HalfLife.DecayConstant(daughterHalfLife)

                                                        ; Parent amount
                                                        parent := parentInitial * Exp(-lambda1 * time)

                                                        ; Daughter amount (simplified, assumes no initial daughter)
                                                        if (Abs(lambda1 - lambda2) < 1e-10) {
                                                            ; Equal half-lives (special case)
                                                            daughter := parentInitial * lambda1 * time * Exp(-lambda1 * time)
                                                        } else {
                                                            ; Different half-lives
                                                            daughter := parentInitial * (lambda1 / (lambda2 - lambda1)) *
                                                            (Exp(-lambda1 * time) - Exp(-lambda2 * time))
                                                        }

                                                        return {
                                                            parent: parent,
                                                            daughter: Max(0, daughter),
                                                            time: time
                                                        }
                                                    }

                                                    /**
                                                    * Secular equilibrium check
                                                    * Occurs when parent half-life >> daughter half-life
                                                    */
                                                    static IsSecularEquilibrium(parentHalfLife, daughterHalfLife) {
                                                        return parentHalfLife > (10 * daughterHalfLife)
                                                    }
                                                }

                                                ; Decay chain example: Radon-222 → Polonium-218
                                                parentHL := 3.82  ; days (Radon-222)
                                                daughterHL := 3.10 / (24 * 60)  ; days (Polonium-218, 3.10 min)
                                                initial := 1000

                                                output := "DECAY CHAIN ANALYSIS:`n`n"
                                                output .= "Parent: Radon-222 (t₁/₂ = 3.82 days)`n"
                                                output .= "Daughter: Polonium-218 (t₁/₂ = 3.10 min)`n"
                                                output .= "Initial Parent Amount: 1000 atoms`n`n"

                                                isEquilibrium := DecayChain.IsSecularEquilibrium(parentHL, daughterHL)
                                                output .= "Secular Equilibrium: " (isEquilibrium ? "Yes" : "No") "`n`n"

                                                output .= "Time (days)   Parent   Daughter   Total`n"
                                                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                                                times := [0, 0.5, 1, 2, 5, 10, 20]

                                                for t in times {
                                                    result := DecayChain.DaughterAmount(initial, parentHL, daughterHL, t)
                                                    total := result.parent + result.daughter

                                                    output .= Format("{:11.1f}", t)
                                                    output .= Format("{:10.2f}", result.parent)
                                                    output .= Format("{:11.2f}", result.daughter)
                                                    output .= Format("{:9.2f}", total)
                                                    output .= "`n"
                                                }

                                                MsgBox(output, "Decay Chain", "Icon!")

                                                ; ============================================================
                                                ; Example 7: Comparison of Different Decay Processes
                                                ; ============================================================

                                                /**
                                                * Compare various decay half-lives
                                                */
                                                CompareDecayProcesses() {
                                                    processes := [
                                                    {
                                                        name: "Proton (theoretical)", halfLife: 1e34, unit: "years", type: "Subatomic"},
                                                        {
                                                            name: "Uranium-238", halfLife: 4.468e9, unit: "years", type: "Geological"},
                                                            {
                                                                name: "Plutonium-239", halfLife: 24110, unit: "years", type: "Nuclear waste"},
                                                                {
                                                                    name: "Carbon-14", halfLife: 5730, unit: "years", type: "Archaeological"},
                                                                    {
                                                                        name: "Radium-226", halfLife: 1600, unit: "years", type: "Environmental"},
                                                                        {
                                                                            name: "Cesium-137", halfLife: 30.17, unit: "years", type: "Nuclear accident"},
                                                                            {
                                                                                name: "Tritium", halfLife: 12.32, unit: "years", type: "Fusion fuel"},
                                                                                {
                                                                                    name: "Strontium-90", halfLife: 28.8, unit: "years", type: "Fission product"},
                                                                                    {
                                                                                        name: "Iodine-131", halfLife: 8.02, unit: "days", type: "Medical"},
                                                                                        {
                                                                                            name: "Radon-222", halfLife: 3.82, unit: "days", type: "Environmental"},
                                                                                            {
                                                                                                name: "Polonium-210", halfLife: 138, unit: "days", type: "Highly radioactive"
                                                                                            }
                                                                                            ]

                                                                                            return processes
                                                                                        }

                                                                                        processes := CompareDecayProcesses()

                                                                                        output := "DECAY HALF-LIFE COMPARISON:`n`n"

                                                                                        output .= "Process                Half-Life          Decay Constant    Type`n"
                                                                                        output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                                                                                        for proc in processes {
                                                                                            lambda := HalfLife.DecayConstant(proc.halfLife)

                                                                                            output .= Format("{:-21s}", proc.name)
                                                                                            output .= Format("{:12.3e} ", proc.halfLife) proc.unit
                                                                                            output .= Format("{:16.3e}", lambda)
                                                                                            output .= "  " proc.type
                                                                                            output .= "`n"
                                                                                        }

                                                                                        ; Time scales
                                                                                        output .= "`nTime Scale Comparison:`n"
                                                                                        output .= "  After 10 half-lives: ~0.1% remains`n"
                                                                                        output .= "  After 20 half-lives: ~0.0001% remains`n"
                                                                                        output .= "  Effectively gone: >10 half-lives"

                                                                                        MsgBox(output, "Decay Comparison", "Icon!")

                                                                                        ; ============================================================
                                                                                        ; Reference Information
                                                                                        ; ============================================================

                                                                                        info := "
                                                                                        (
                                                                                        NATURAL LOG IN HALF-LIFE REFERENCE:

                                                                                        Half-Life Formula:
                                                                                        t₁/₂ = ln(2) / λ ≈ 0.693 / λ
                                                                                        where λ = decay constant

                                                                                        Decay Constant:
                                                                                        λ = ln(2) / t₁/₂

                                                                                        Mean Lifetime:
                                                                                        τ = 1/λ = t₁/₂ / ln(2)
                                                                                        τ ≈ 1.443 × t₁/₂

                                                                                        Decay Equations:
                                                                                        N(t) = N₀ × e^(-λt)
                                                                                        N(t) = N₀ × (1/2)^(t/t₁/₂)

                                                                                        Activity:
                                                                                        A(t) = λN(t) = A₀ × e^(-λt)

                                                                                        Time to Decay:
                                                                                        t = -ln(N/N₀) / λ
                                                                                        t = t₁/₂ × ln(N₀/N) / ln(2)

                                                                                        Percentage After n Half-Lives:
                                                                                        % = (1/2)^n × 100
                                                                                        n=1: 50%, n=2: 25%, n=3: 12.5%

                                                                                        Key Relationships:
                                                                                        • ln(2) ≈ 0.693147
                                                                                        • 1/ln(2) ≈ 1.442695
                                                                                        • After 10 half-lives: 0.0977%
                                                                                        • After 20 half-lives: 0.000095%

                                                                                        Carbon Dating:
                                                                                        age = -ln(ratio) / λ
                                                                                        where ratio = C-14 remaining / C-14 initial

                                                                                        Applications:
                                                                                        ✓ Radioactive decay
                                                                                        ✓ Nuclear medicine
                                                                                        ✓ Archaeological dating
                                                                                        ✓ Drug metabolism
                                                                                        ✓ Environmental monitoring
                                                                                        ✓ Nuclear waste management
                                                                                        ✓ Geochronology
                                                                                        )"

                                                                                        MsgBox(info, "Half-Life Reference", "Icon!")
