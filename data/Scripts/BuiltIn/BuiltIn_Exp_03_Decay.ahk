#Requires AutoHotkey v2.0

/**
* BuiltIn_Exp_03_Decay.ahk
*
* DESCRIPTION:
* Exponential decay applications using Exp() function for radioactive decay, depreciation, and cooling
*
* FEATURES:
* - Radioactive decay calculations
* - Half-life and decay constants
* - Asset depreciation models
* - Newton's law of cooling
* - Drug concentration in bloodstream
* - Capacitor discharge
*
* SOURCE:
* AutoHotkey v2 Documentation & Physics/Economics
* https://www.autohotkey.com/docs/v2/lib/Math.htm#Exp
*
* KEY V2 FEATURES DEMONSTRATED:
* - Exp() for decay modeling (negative exponents)
* - Class-based decay models
* - Time series generation
* - Inverse calculations (finding time)
* - Physical constant applications
*
* LEARNING POINTS:
* 1. Decay formula: N(t) = N₀ × e^(-λt)
* 2. Half-life: t₁/₂ = ln(2)/λ
* 3. Decay constant λ relates to half-life
* 4. Exponential decay approaches but never reaches zero
* 5. Used in physics, chemistry, economics, medicine
*/

; ============================================================
; Example 1: Radioactive Decay Basics
; ============================================================

/**
* Model radioactive substance decay
* N(t) = N₀ × e^(-λt)
*/
class RadioactiveDecay {
    __New(initial, halfLife) {
        this.initial := initial
        this.halfLife := halfLife
        this.decayConstant := Ln(2) / halfLife  ; λ = ln(2)/t₁/₂
    }

    /**
    * Amount remaining at time t
    */
    At(time) {
        return this.initial * Exp(-this.decayConstant * time)
    }

    /**
    * Alternative using half-life formula
    * N(t) = N₀ × (1/2)^(t/t₁/₂)
    */
    AtHalfLife(time) {
        return this.initial * (0.5 ** (time / this.halfLife))
    }

    /**
    * Percentage remaining
    */
    PercentRemaining(time) {
        return (this.At(time) / this.initial) * 100
    }

    /**
    * Amount decayed
    */
    Decayed(time) {
        return this.initial - this.At(time)
    }

    /**
    * Time to reach specific amount
    */
    TimeToReach(amount) {
        if (amount >= this.initial || amount <= 0)
        return 0
        return -Ln(amount / this.initial) / this.decayConstant
    }

    /**
    * Number of half-lives elapsed
    */
    HalfLivesElapsed(time) {
        return time / this.halfLife
    }
}

; Carbon-14 example (half-life ≈ 5,730 years)
initial := 100  ; grams
halfLife := 5730  ; years

carbon14 := RadioactiveDecay(initial, halfLife)

output := "RADIOACTIVE DECAY - CARBON-14:`n`n"
output .= "Initial Amount: " initial " grams`n"
output .= "Half-Life: " Format("{:,}", halfLife) " years`n"
output .= "Decay Constant: " Format("{:.8f}", carbon14.decayConstant) " per year`n`n"

output .= "Time (years)  Half-Lives  Remaining (g)  Remaining %`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

times := [0, 5730, 11460, 17190, 22920, 28650]

for t in times {
    halfLives := carbon14.HalfLivesElapsed(t)
    remaining := carbon14.At(t)
    percent := carbon14.PercentRemaining(t)

    output .= Format("{:12,}", t)
    output .= Format("{:11.1f}", halfLives)
    output .= Format("{:16.4f}", remaining)
    output .= Format("{:13.2f}", percent)
    output .= "`n"
}

MsgBox(output, "Radioactive Decay", "Icon!")

; ============================================================
; Example 2: Carbon Dating
; ============================================================

/**
* Determine age of sample using Carbon-14 dating
*/
CarbonDating(currentPercent, halfLife := 5730) {
    ; currentPercent is % of original C-14 remaining
    decayConstant := Ln(2) / halfLife

    ; N(t) = N₀ × e^(-λt)
    ; N(t)/N₀ = e^(-λt)
    ; ln(N(t)/N₀) = -λt
    ; t = -ln(N(t)/N₀) / λ

    ratio := currentPercent / 100
    age := -Ln(ratio) / decayConstant

    return age
}

samples := [
{
    name: "Ancient Wood", percent: 12.5},
    {
        name: "Bone Fragment", percent: 25.0},
        {
            name: "Charcoal", percent: 50.0},
            {
                name: "Textile", percent: 75.0},
                {
                    name: "Organic Material", percent: 6.25
                }
                ]

                output := "CARBON-14 DATING ANALYSIS:`n`n"
                output .= "Half-Life of C-14: 5,730 years`n`n"

                output .= "Sample                  % Remaining   Estimated Age`n"
                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                for sample in samples {
                    age := CarbonDating(sample.percent)

                    output .= Format("{:-23s}", sample.name)
                    output .= Format("{:11.2f}%", sample.percent)
                    output .= Format("{:14,.0f}", age) " years`n"
                }

                MsgBox(output, "Carbon Dating", "Icon!")

                ; ============================================================
                ; Example 3: Asset Depreciation
                ; ============================================================

                /**
                * Calculate asset depreciation using exponential decay
                * V(t) = V₀ × e^(-rt)
                */
                class AssetDepreciation {
                    __New(purchasePrice, depreciationRate, usefulLife) {
                        this.initial := purchasePrice
                        this.rate := depreciationRate  ; Annual depreciation rate
                        this.life := usefulLife
                    }

                    /**
                    * Value at time t (years)
                    */
                    ValueAt(years) {
                        return this.initial * Exp(-this.rate * years)
                    }

                    /**
                    * Depreciation amount
                    */
                    DepreciatedAmount(years) {
                        return this.initial - this.ValueAt(years)
                    }

                    /**
                    * Percent of original value remaining
                    */
                    PercentValue(years) {
                        return (this.ValueAt(years) / this.initial) * 100
                    }

                    /**
                    * Annual depreciation table
                    */
                    DepreciationSchedule(years) {
                        schedule := []

                        Loop years + 1 {
                            year := A_Index - 1
                            value := this.ValueAt(year)
                            depreciation := this.DepreciatedAmount(year)

                            schedule.Push({
                                year: year,
                                value: value,
                                depreciation: depreciation,
                                percent: this.PercentValue(year)
                            })
                        }

                        return schedule
                    }
                }

                ; Vehicle depreciation example
                purchasePrice := 35000
                rate := 0.15  ; 15% annual depreciation
                usefulLife := 10

                vehicle := AssetDepreciation(purchasePrice, rate, usefulLife)
                schedule := vehicle.DepreciationSchedule(10)

                output := "VEHICLE DEPRECIATION SCHEDULE:`n`n"
                output .= "Purchase Price: $" Format("{:,}", purchasePrice) "`n"
                output .= "Depreciation Rate: " (rate * 100) "% per year`n`n"

                output .= "Year   Book Value   Depreciation   % of Original`n"
                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                for entry in schedule {
                    output .= Format("{:4d}", entry.year)
                    output .= "  $" Format("{:>9,.2f}", entry.value)
                    output .= "   $" Format("{:>9,.2f}", entry.depreciation)
                    output .= Format("{:14.1f}%", entry.percent)
                    output .= "`n"
                }

                MsgBox(output, "Asset Depreciation", "Icon!")

                ; ============================================================
                ; Example 4: Newton's Law of Cooling
                ; ============================================================

                /**
                * Model temperature change using Newton's Law of Cooling
                * T(t) = T_ambient + (T₀ - T_ambient) × e^(-kt)
                */
                class CoolingModel {
                    __New(initialTemp, ambientTemp, coolingConstant) {
                        this.T0 := initialTemp
                        this.Tamb := ambientTemp
                        this.k := coolingConstant
                    }

                    /**
                    * Temperature at time t
                    */
                    TempAt(time) {
                        return this.Tamb + (this.T0 - this.Tamb) * Exp(-this.k * time)
                    }

                    /**
                    * Time to reach target temperature
                    */
                    TimeToReach(targetTemp) {
                        if (this.T0 > this.Tamb && targetTemp <= this.Tamb)
                        return "infinity"
                        if (this.T0 < this.Tamb && targetTemp >= this.Tamb)
                        return "infinity"

                        ; Solve: target = Tamb + (T0 - Tamb) × e^(-kt)
                        ; (target - Tamb) = (T0 - Tamb) × e^(-kt)
                        ; e^(-kt) = (target - Tamb) / (T0 - Tamb)
                        ; -kt = ln((target - Tamb) / (T0 - Tamb))
                        ; t = -ln((target - Tamb) / (T0 - Tamb)) / k

                        ratio := (targetTemp - this.Tamb) / (this.T0 - this.Tamb)
                        return -Ln(ratio) / this.k
                    }
                }

                ; Hot coffee cooling
                initialTemp := 90  ; °C
                ambientTemp := 20  ; °C (room temperature)
                k := 0.05  ; cooling constant (per minute)

                coffee := CoolingModel(initialTemp, ambientTemp, k)

                output := "NEWTON'S LAW OF COOLING - HOT COFFEE:`n`n"
                output .= "Initial Temperature: " initialTemp "°C`n"
                output .= "Room Temperature: " ambientTemp "°C`n"
                output .= "Cooling Constant: " k " per minute`n`n"

                output .= "Time (min)  Temperature (°C)`n"
                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                times := [0, 5, 10, 15, 20, 30, 40, 60, 90, 120]

                for t in times {
                    temp := coffee.TempAt(t)
                    output .= Format("{:10d}", t)
                    output .= Format("{:18.2f}", temp)
                    output .= "`n"
                }

                ; Time to drinking temperature
                drinkingTemp := 60  ; °C
                timeTodrink := coffee.TimeToReach(drinkingTemp)

                output .= "`nTime to reach " drinkingTemp "°C: "
                output .= Format("{:.1f}", timeTodrink) " minutes"

                MsgBox(output, "Cooling Model", "Icon!")

                ; ============================================================
                ; Example 5: Drug Concentration in Bloodstream
                ; ============================================================

                /**
                * Model drug elimination from body
                * C(t) = C₀ × e^(-kt)
                */
                class DrugElimination {
                    __New(initialDose, eliminationRate, halfLife := "") {
                        this.C0 := initialDose
                        if (halfLife != "") {
                            this.halfLife := halfLife
                            this.k := Ln(2) / halfLife
                        } else {
                            this.k := eliminationRate
                            this.halfLife := Ln(2) / eliminationRate
                        }
                    }

                    /**
                    * Concentration at time t
                    */
                    ConcentrationAt(time) {
                        return this.C0 * Exp(-this.k * time)
                    }

                    /**
                    * Time to reach specific concentration
                    */
                    TimeToConcentration(concentration) {
                        if (concentration >= this.C0 || concentration <= 0)
                        return 0
                        return -Ln(concentration / this.C0) / this.k
                    }

                    /**
                    * Is concentration below therapeutic level?
                    */
                    IsBelowTherapeutic(time, therapeuticLevel) {
                        return this.ConcentrationAt(time) < therapeuticLevel
                    }
                }

                ; Medication example
                initialDose := 500  ; mg
                halfLife := 6  ; hours

                drug := DrugElimination(initialDose, "", halfLife)

                output := "DRUG ELIMINATION FROM BLOODSTREAM:`n`n"
                output .= "Initial Dose: " initialDose " mg`n"
                output .= "Half-Life: " halfLife " hours`n"
                output .= "Elimination Rate: " Format("{:.4f}", drug.k) " per hour`n`n"

                output .= "Time (hrs)  Concentration (mg)  % Remaining`n"
                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                Loop 25 {
                    time := (A_Index - 1) * 2
                    conc := drug.ConcentrationAt(time)
                    percent := (conc / initialDose) * 100

                    output .= Format("{:10d}", time)
                    output .= Format("{:21.2f}", conc)
                    output .= Format("{:13.1f}%", percent)
                    output .= "`n"
                }

                ; Therapeutic level analysis
                therapeuticLevel := 50  ; mg
                timeBelow := drug.TimeToConcentration(therapeuticLevel)

                output .= "`nTherapeutic Level: " therapeuticLevel " mg`n"
                output .= "Falls below at: " Format("{:.1f}", timeBelow) " hours"

                MsgBox(output, "Drug Elimination", "Icon!")

                ; ============================================================
                ; Example 6: Capacitor Discharge
                ; ============================================================

                /**
                * Model capacitor discharge in RC circuit
                * V(t) = V₀ × e^(-t/RC)
                */
                class CapacitorDischarge {
                    __New(initialVoltage, resistance, capacitance) {
                        this.V0 := initialVoltage
                        this.R := resistance  ; Ohms
                        this.C := capacitance  ; Farads
                        this.tau := resistance * capacitance  ; Time constant
                    }

                    /**
                    * Voltage at time t
                    */
                    VoltageAt(time) {
                        return this.V0 * Exp(-time / this.tau)
                    }

                    /**
                    * Current at time t (I = V/R)
                    */
                    CurrentAt(time) {
                        return this.VoltageAt(time) / this.R
                    }

                    /**
                    * Time to reach voltage
                    */
                    TimeToVoltage(voltage) {
                        if (voltage >= this.V0 || voltage <= 0)
                        return 0
                        return -this.tau * Ln(voltage / this.V0)
                    }

                    /**
                    * Time constants elapsed
                    */
                    TimeConstants(time) {
                        return time / this.tau
                    }
                }

                ; RC circuit example
                V0 := 12  ; Volts
                R := 10000  ; 10kΩ
                C := 0.001  ; 1000μF = 0.001F

                circuit := CapacitorDischarge(V0, R, C)

                output := "CAPACITOR DISCHARGE (RC CIRCUIT):`n`n"
                output .= "Initial Voltage: " V0 " V`n"
                output .= "Resistance: " Format("{:,}", R) " Ω`n"
                output .= "Capacitance: " (C * 1000000) " μF`n"
                output .= "Time Constant (τ): " circuit.tau " seconds`n`n"

                output .= "Time (s)  τ      Voltage (V)  Current (mA)  % Remaining`n"
                output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                times := [0, 5, 10, 15, 20, 30, 40, 50]

                for t in times {
                    tc := circuit.TimeConstants(t)
                    voltage := circuit.VoltageAt(t)
                    current := circuit.CurrentAt(t) * 1000  ; Convert to mA
                    percent := (voltage / V0) * 100

                    output .= Format("{:8.0f}", t)
                    output .= Format("{:6.1f}", tc)
                    output .= Format("{:13.4f}", voltage)
                    output .= Format("{:14.4f}", current)
                    output .= Format("{:13.1f}%", percent)
                    output .= "`n"
                }

                output .= "`nAfter 5τ (" (circuit.tau * 5) "s): "
                output .= Format("{:.2f}%", (circuit.VoltageAt(circuit.tau * 5) / V0) * 100)
                output .= " remaining (≈0.7%)"

                MsgBox(output, "Capacitor Discharge", "Icon!")

                ; ============================================================
                ; Example 7: Comparing Decay Rates
                ; ============================================================

                /**
                * Compare different decay processes
                */
                CompareDecayRates() {
                    processes := [
                    {
                        name: "Fast Decay", halfLife: 1},
                        {
                            name: "Medium Decay", halfLife: 5},
                            {
                                name: "Slow Decay", halfLife: 10},
                                {
                                    name: "Very Slow Decay", halfLife: 20
                                }
                                ]

                                results := []

                                for proc in processes {
                                    decay := RadioactiveDecay(100, proc.halfLife)

                                    ; Calculate remaining at various times
                                    results.Push({
                                        name: proc.name,
                                        halfLife: proc.halfLife,
                                        t5: decay.At(5),
                                        t10: decay.At(10),
                                        t20: decay.At(20),
                                        t50: decay.At(50)
                                    })
                                }

                                return results
                            }

                            results := CompareDecayRates()

                            output := "DECAY RATE COMPARISON:`n`n"
                            output .= "Starting Amount: 100 units`n`n"

                            output .= "Process              t½     5 units   10 units  20 units  50 units`n"
                            output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

                            for r in results {
                                output .= Format("{:-20s}", r.name)
                                output .= Format("{:4d}", r.halfLife)
                                output .= Format("{:11.2f}", r.t5)
                                output .= Format("{:10.2f}", r.t10)
                                output .= Format("{:10.2f}", r.t20)
                                output .= Format("{:10.2f}", r.t50)
                                output .= "`n"
                            }

                            output .= "`nNote: Shorter half-life = faster decay"

                            MsgBox(output, "Decay Comparison", "Icon!")

                            ; ============================================================
                            ; Reference Information
                            ; ============================================================

                            info := "
                            (
                            EXPONENTIAL DECAY REFERENCE:

                            General Decay Formula:
                            N(t) = N₀ × e^(-λt)
                            N₀ = initial amount
                            λ = decay constant
                            t = time

                            Half-Life Formula:
                            N(t) = N₀ × (1/2)^(t/t₁/₂)
                            t₁/₂ = half-life

                            Decay Constant:
                            λ = ln(2) / t₁/₂
                            t₁/₂ = ln(2) / λ ≈ 0.693 / λ

                            Time to Reach Amount:
                            t = -ln(N/N₀) / λ
                            t = t₁/₂ × ln(N₀/N) / ln(2)

                            Percentage Remaining:
                            % = (N(t) / N₀) × 100

                            Common Half-Lives:
                            Carbon-14: 5,730 years
                            Uranium-238: 4.5 billion years
                            Iodine-131: 8 days
                            Radon-222: 3.8 days

                            Applications:
                            ✓ Radioactive decay
                            ✓ Carbon dating
                            ✓ Asset depreciation
                            ✓ Drug elimination
                            ✓ Cooling/heating
                            ✓ RC circuit discharge
                            ✓ Population decline

                            Newton's Law of Cooling:
                            T(t) = T_amb + (T₀ - T_amb) × e^(-kt)

                            RC Circuit:
                            V(t) = V₀ × e^(-t/RC)
                            τ = RC (time constant)

                            Key Properties:
                            • Never reaches exactly zero
                            • 50% remains after 1 half-life
                            • 25% remains after 2 half-lives
                            • 12.5% remains after 3 half-lives
                            • After 5 half-lives: ~3% remains
                            )"

                            MsgBox(info, "Exponential Decay Reference", "Icon!")
