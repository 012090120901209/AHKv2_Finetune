#Requires AutoHotkey v2.0
/**
 * BuiltIn_Log_02_Scales.ahk
 *
 * DESCRIPTION:
 * Logarithmic scale applications using Log() for decibels, pH, Richter scale, and magnitude measurements
 *
 * FEATURES:
 * - Decibel (dB) calculations for sound intensity
 * - pH scale for acidity/alkalinity
 * - Richter scale for earthquake magnitude
 * - Stellar magnitude (astronomy)
 * - Sound pressure level calculations
 *
 * SOURCE:
 * AutoHotkey v2 Documentation & Scientific Scales
 * https://www.autohotkey.com/docs/v2/lib/Math.htm#Log
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Log() for logarithmic scales
 * - Class-based scale calculators
 * - Inverse logarithmic calculations
 * - Scientific measurements
 * - Real-world applications
 *
 * LEARNING POINTS:
 * 1. Logarithmic scales compress large ranges
 * 2. Each unit represents a multiplicative change
 * 3. Decibels: dB = 10 × log₁₀(I/I₀)
 * 4. pH: pH = -log₁₀([H⁺])
 * 5. Richter: M = log₁₀(A) + correction factors
 */

; ============================================================
; Example 1: Decibel Scale - Sound Intensity
; ============================================================

/**
 * Calculate sound intensity in decibels
 * dB = 10 × log₁₀(I / I₀)
 * I₀ = 10^-12 W/m² (threshold of hearing)
 */
class DecibelScale {
    static I0 := 1e-12  ; Reference intensity (W/m²)

    /**
     * Convert intensity to decibels
     */
    static IntensityToDecibels(intensity) {
        return 10 * Log(intensity / DecibelScale.I0)
    }

    /**
     * Convert decibels to intensity
     */
    static DecibelsToIntensity(decibels) {
        return DecibelScale.I0 * (10 ** (decibels / 10))
    }

    /**
     * Calculate sound pressure level (SPL)
     * SPL = 20 × log₁₀(P / P₀)
     * P₀ = 20 μPa (reference pressure)
     */
    static PressureToSPL(pressure) {
        P0 := 20e-6  ; 20 micropascals
        return 20 * Log(pressure / P0)
    }

    /**
     * Combine two sound sources
     */
    static CombineSounds(db1, db2) {
        I1 := DecibelScale.DecibelsToIntensity(db1)
        I2 := DecibelScale.DecibelsToIntensity(db2)
        totalIntensity := I1 + I2
        return DecibelScale.IntensityToDecibels(totalIntensity)
    }
}

; Common sound levels
sounds := [
    {name: "Threshold of hearing", intensity: 1e-12},
    {name: "Whisper", intensity: 1e-10},
    {name: "Quiet room", intensity: 1e-9},
    {name: "Normal conversation", intensity: 1e-6},
    {name: "Busy traffic", intensity: 1e-5},
    {name: "Lawnmower", intensity: 1e-3},
    {name: "Rock concert", intensity: 1e-1},
    {name: "Jet engine", intensity: 1e1},
    {name: "Threshold of pain", intensity: 1e0}
]

output := "DECIBEL SCALE - SOUND INTENSITY:`n`n"
output .= "Reference: I₀ = 10^-12 W/m²`n"
output .= "Formula: dB = 10 × log₁₀(I / I₀)`n`n"

output .= "Sound Source              Intensity (W/m²)   Decibels (dB)`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for sound in sounds {
    db := DecibelScale.IntensityToDecibels(sound.intensity)

    output .= Format("{:-25s}", sound.name)
    output .= Format("{:18.2e}", sound.intensity)
    output .= Format("{:17.1f}", db)
    output .= "`n"
}

; Combining sounds
output .= "`nCombining Two 60 dB Sources:`n"
combined := DecibelScale.CombineSounds(60, 60)
output .= "Result: " Format("{:.1f}", combined) " dB (not 120 dB!)"

MsgBox(output, "Decibel Scale", "Icon!")

; ============================================================
; Example 2: pH Scale - Acidity and Alkalinity
; ============================================================

/**
 * pH scale calculations
 * pH = -log₁₀([H⁺])
 * [H⁺] = hydrogen ion concentration in mol/L
 */
class pHScale {
    /**
     * Calculate pH from hydrogen ion concentration
     */
    static ConcentrationTopH(concentration) {
        return -Log(concentration)
    }

    /**
     * Calculate hydrogen ion concentration from pH
     */
    static pHToConcentration(pH) {
        return 10 ** (-pH)
    }

    /**
     * Calculate pOH from pH
     * pH + pOH = 14 (at 25°C)
     */
    static pHTOpOH(pH) {
        return 14 - pH
    }

    /**
     * Classify solution
     */
    static Classify(pH) {
        if (pH < 7)
            return "Acidic"
        else if (pH = 7)
            return "Neutral"
        else
            return "Basic (Alkaline)"
    }

    /**
     * Calculate relative acidity
     * How many times more acidic is pH1 than pH2?
     */
    static RelativeAcidity(pH1, pH2) {
        return 10 ** (pH2 - pH1)
    }
}

; Common substances
substances := [
    {name: "Battery acid", pH: 1.0},
    {name: "Lemon juice", pH: 2.0},
    {name: "Vinegar", pH: 2.4},
    {name: "Orange juice", pH: 3.5},
    {name: "Tomato juice", pH: 4.0},
    {name: "Black coffee", pH: 5.0},
    {name: "Milk", pH: 6.5},
    {name: "Pure water", pH: 7.0},
    {name: "Blood", pH: 7.4},
    {name: "Baking soda", pH: 8.3},
    {name: "Milk of magnesia", pH: 10.5},
    {name: "Ammonia", pH: 11.0},
    {name: "Bleach", pH: 12.5},
    {name: "Drain cleaner", pH: 14.0}
]

output := "pH SCALE - ACIDITY AND ALKALINITY:`n`n"
output .= "Formula: pH = -log₁₀([H⁺])`n"
output .= "Range: 0 (most acidic) to 14 (most basic)`n`n"

output .= "Substance              pH     [H⁺] (mol/L)    Type`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for substance in substances {
    concentration := pHScale.pHToConcentration(substance.pH)
    type := pHScale.Classify(substance.pH)

    output .= Format("{:-20s}", substance.name)
    output .= Format("{:6.1f}", substance.pH)
    output .= Format("{:17.2e}", concentration)
    output .= Format("{:13s}", type)
    output .= "`n"
}

; Compare acidities
output .= "`nRelative Acidity:`n"
output .= "Lemon juice (pH 2) vs Milk (pH 6.5):`n"
relative := pHScale.RelativeAcidity(2, 6.5)
output .= "Lemon juice is " Format("{:,.0f}", relative) "× more acidic"

MsgBox(output, "pH Scale", "Icon!")

; ============================================================
; Example 3: Richter Scale - Earthquake Magnitude
; ============================================================

/**
 * Richter scale for earthquake magnitude
 * M = log₁₀(A) where A is amplitude
 */
class RichterScale {
    /**
     * Calculate magnitude from amplitude ratio
     */
    static AmplitudeToMagnitude(amplitude) {
        return Log(amplitude)
    }

    /**
     * Calculate amplitude ratio from magnitude
     */
    static MagnitudeToAmplitude(magnitude) {
        return 10 ** magnitude
    }

    /**
     * Energy released (approximate)
     * E ≈ 10^(1.5M + 4.8) Joules
     */
    static Energy(magnitude) {
        return 10 ** (1.5 * magnitude + 4.8)
    }

    /**
     * Compare two earthquakes
     */
    static CompareAmplitudes(mag1, mag2) {
        diff := mag2 - mag1
        return 10 ** diff
    }

    /**
     * Compare energy release
     */
    static CompareEnergy(mag1, mag2) {
        diff := mag2 - mag1
        return 10 ** (1.5 * diff)
    }

    /**
     * Classify earthquake
     */
    static Classify(magnitude) {
        if (magnitude < 2.0)
            return "Micro"
        else if (magnitude < 4.0)
            return "Minor"
        else if (magnitude < 5.0)
            return "Light"
        else if (magnitude < 6.0)
            return "Moderate"
        else if (magnitude < 7.0)
            return "Strong"
        else if (magnitude < 8.0)
            return "Major"
        else
            return "Great"
    }
}

earthquakes := [
    {location: "Barely felt", magnitude: 2.5},
    {location: "Often felt, minor damage", magnitude: 4.0},
    {location: "Slight damage", magnitude: 5.0},
    {location: "Moderate damage", magnitude: 6.0},
    {location: "San Francisco 1989", magnitude: 6.9},
    {location: "Serious damage", magnitude: 7.0},
    {location: "Haiti 2010", magnitude: 7.0},
    {location: "Great damage", magnitude: 8.0},
    {location: "Japan 2011", magnitude: 9.1},
    {location: "Largest recorded", magnitude: 9.5}
]

output := "RICHTER SCALE - EARTHQUAKE MAGNITUDE:`n`n"
output .= "Formula: M = log₁₀(A) where A is amplitude`n`n"

output .= "Description                   Magnitude  Energy (Joules)  Classification`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for eq in earthquakes {
    energy := RichterScale.Energy(eq.magnitude)
    classification := RichterScale.Classify(eq.magnitude)

    output .= Format("{:-28s}", eq.location)
    output .= Format("{:10.1f}", eq.magnitude)
    output .= Format("{:17.2e}", energy)
    output .= "  " classification
    output .= "`n"
}

; Compare earthquakes
output .= "`nComparison:`n"
output .= "Magnitude 7.0 vs 5.0:`n"

ampDiff := RichterScale.CompareAmplitudes(5.0, 7.0)
energyDiff := RichterScale.CompareEnergy(5.0, 7.0)

output .= "  Amplitude: " Format("{:,.0f}", ampDiff) "× greater`n"
output .= "  Energy: " Format("{:,.0f}", energyDiff) "× greater"

MsgBox(output, "Richter Scale", "Icon!")

; ============================================================
; Example 4: Stellar Magnitude - Brightness of Stars
; ============================================================

/**
 * Stellar magnitude scale (brightness of celestial objects)
 * m = -2.5 × log₁₀(F / F₀)
 * Lower magnitude = brighter
 */
class StellarMagnitude {
    /**
     * Calculate magnitude from flux ratio
     */
    static FluxToMagnitude(flux, referenceFlux := 1) {
        return -2.5 * Log(flux / referenceFlux)
    }

    /**
     * Calculate flux ratio from magnitude
     */
    static MagnitudeToFlux(magnitude, referenceFlux := 1) {
        return referenceFlux * (10 ** (-magnitude / 2.5))
    }

    /**
     * Brightness ratio between two magnitudes
     */
    static BrightnessRatio(mag1, mag2) {
        ; Brighter object has lower magnitude
        diff := mag2 - mag1
        return 10 ** (diff / 2.5)
    }

    /**
     * Classify visibility
     */
    static Visibility(magnitude) {
        if (magnitude < -26)
            return "Sun"
        else if (magnitude < -10)
            return "Extremely bright"
        else if (magnitude < 0)
            return "Very bright"
        else if (magnitude < 3)
            return "Visible to naked eye (bright)"
        else if (magnitude < 6)
            return "Visible to naked eye (faint)"
        else if (magnitude < 10)
            return "Binoculars needed"
        else
            return "Telescope needed"
    }
}

celestialObjects := [
    {name: "Sun", magnitude: -26.74},
    {name: "Full Moon", magnitude: -12.6},
    {name: "Venus (brightest)", magnitude: -4.6},
    {name: "Jupiter (brightest)", magnitude: -2.9},
    {name: "Sirius (brightest star)", magnitude: -1.46},
    {name: "Vega", magnitude: 0.03},
    {name: "Faintest naked eye", magnitude: 6.0},
    {name: "Neptune", magnitude: 7.8},
    {name: "Pluto", magnitude: 14.0},
    {name: "Faintest detected", magnitude: 30.0}
]

output := "STELLAR MAGNITUDE SCALE:`n`n"
output .= "Formula: m = -2.5 × log₁₀(F / F₀)`n"
output .= "Lower value = brighter object`n`n"

output .= "Object                    Magnitude   Visibility`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for obj in celestialObjects {
    visibility := StellarMagnitude.Visibility(obj.magnitude)

    output .= Format("{:-24s}", obj.name)
    output .= Format("{:10.2f}", obj.magnitude)
    output .= "   " visibility
    output .= "`n"
}

; Compare brightness
output .= "`nBrightness Comparisons:`n"
sunVsMoon := StellarMagnitude.BrightnessRatio(-12.6, -26.74)
output .= "Sun vs Full Moon: " Format("{:,.0f}", sunVsMoon) "× brighter`n"

siriusVsFaintest := StellarMagnitude.BrightnessRatio(6.0, -1.46)
output .= "Sirius vs faintest naked eye: " Format("{:,.0f}", siriusVsFaintest) "× brighter"

MsgBox(output, "Stellar Magnitude", "Icon!")

; ============================================================
; Example 5: Sound Pressure Level (SPL) Calculator
; ============================================================

/**
 * Detailed sound pressure level calculations
 */
class SoundPressure {
    static P0 := 20e-6  ; 20 micropascals (threshold of hearing)

    /**
     * Calculate SPL from pressure
     * SPL = 20 × log₁₀(P / P₀)
     */
    static PressureToSPL(pressure) {
        return 20 * Log(pressure / SoundPressure.P0)
    }

    /**
     * Calculate pressure from SPL
     */
    static SPLToPressure(spl) {
        return SoundPressure.P0 * (10 ** (spl / 20))
    }

    /**
     * Distance attenuation (inverse square law)
     * SPL₂ = SPL₁ - 20 × log₁₀(d₂/d₁)
     */
    static AttenuateDistance(initialSPL, distance1, distance2) {
        return initialSPL - 20 * Log(distance2 / distance1)
    }

    /**
     * Safe exposure time calculator
     */
    static SafeExposureTime(spl) {
        ; OSHA guideline: 8 hours at 90 dB, halve time for every 5 dB increase
        if (spl <= 85)
            return "Unlimited (below threshold)"
        else if (spl <= 90)
            return "8 hours"
        else if (spl <= 95)
            return "4 hours"
        else if (spl <= 100)
            return "2 hours"
        else if (spl <= 105)
            return "1 hour"
        else if (spl <= 110)
            return "30 minutes"
        else if (spl <= 115)
            return "15 minutes"
        else
            return "< 15 minutes (hearing damage risk)"
    }
}

; Sound sources at 1 meter
soundSources := [
    {name: "Whisper", spl: 30},
    {name: "Library", spl: 40},
    {name: "Office", spl: 50},
    {name: "Conversation", spl: 60},
    {name: "Vacuum cleaner", spl: 70},
    {name: "Alarm clock", spl: 80},
    {name: "Lawnmower", spl: 90},
    {name: "Chainsaw", spl: 100},
    {name: "Rock concert", spl: 110},
    {name: "Gunshot", spl: 140}
]

output := "SOUND PRESSURE LEVEL (SPL):`n`n"
output .= "Reference: P₀ = 20 μPa`n"
output .= "Formula: SPL = 20 × log₁₀(P / P₀)`n`n"

output .= "Source               SPL (dB)   Pressure (Pa)   Safe Exposure`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for source in soundSources {
    pressure := SoundPressure.SPLToPressure(source.spl)
    safeTime := SoundPressure.SafeExposureTime(source.spl)

    output .= Format("{:-19s}", source.name)
    output .= Format("{:9d}", source.spl)
    output .= Format("{:15.4f}", pressure)
    output .= "   " safeTime
    output .= "`n"
}

; Distance attenuation example
output .= "`nDistance Attenuation (Rock Concert):`n"
initialSPL := 110  ; dB at 1 meter
distances := [1, 2, 4, 8, 16]

for dist in distances {
    spl := SoundPressure.AttenuateDistance(initialSPL, 1, dist)
    output .= "  " dist " m: " Format("{:.1f}", spl) " dB`n"
}

MsgBox(output, "Sound Pressure Level", "Icon!")

; ============================================================
; Example 6: Comparing Logarithmic Scales
; ============================================================

/**
 * Compare how different scales work
 */
CompareLogarithmicScales() {
    return [
        {
            name: "Decibels (Sound)",
            formula: "10 × log₁₀(I/I₀)",
            factor: "10× intensity = +10 dB",
            range: "0 to 140+ dB"
        },
        {
            name: "pH (Acidity)",
            formula: "-log₁₀([H⁺])",
            factor: "10× [H⁺] = -1 pH",
            range: "0 to 14 (typical)"
        },
        {
            name: "Richter (Earthquakes)",
            formula: "log₁₀(A)",
            factor: "10× amplitude = +1 M",
            range: "0 to 10+"
        },
        {
            name: "Stellar Magnitude",
            formula: "-2.5 × log₁₀(F/F₀)",
            factor: "100× brighter = -5 mag",
            range: "-27 to +30"
        }
    ]
}

scales := CompareLogarithmicScales()

output := "COMPARING LOGARITHMIC SCALES:`n`n"

for scale in scales {
    output .= scale.name ":"
    output .= "`n  Formula: " scale.formula
    output .= "`n  Scale Factor: " scale.factor
    output .= "`n  Typical Range: " scale.range
    output .= "`n`n"
}

output .= "Common Property:`n"
output .= "All logarithmic scales compress wide ranges`n"
output .= "into manageable numbers by using powers of 10."

MsgBox(output, "Scale Comparison", "Icon!")

; ============================================================
; Example 7: Inverse Calculations
; ============================================================

/**
 * Find original values from scale measurements
 */
PerformInverseCalculations() {
    results := []

    ; From decibels to intensity
    db := 80
    intensity := DecibelScale.DecibelsToIntensity(db)
    results.Push({
        scale: "Decibels",
        given: db " dB",
        result: Format("{:.2e}", intensity) " W/m²"
    })

    ; From pH to concentration
    pH := 4.5
    concentration := pHScale.pHToConcentration(pH)
    results.Push({
        scale: "pH",
        given: "pH " pH,
        result: Format("{:.2e}", concentration) " mol/L [H⁺]"
    })

    ; From magnitude to amplitude
    magnitude := 6.5
    amplitude := RichterScale.MagnitudeToAmplitude(magnitude)
    results.Push({
        scale: "Richter",
        given: "Magnitude " magnitude,
        result: Format("{:.2e}", amplitude) " × reference"
    })

    ; From stellar magnitude to flux
    stellarMag := 3.0
    flux := StellarMagnitude.MagnitudeToFlux(stellarMag)
    results.Push({
        scale: "Stellar Magnitude",
        given: "Magnitude " stellarMag,
        result: Format("{:.4f}", flux) " × reference"
    })

    return results
}

results := PerformInverseCalculations()

output := "INVERSE CALCULATIONS:`n`n"
output .= "Converting scale values back to original measurements`n`n"

output .= "Scale                   Given Value          Original Measurement`n"
output .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

for r in results {
    output .= Format("{:-23s}", r.scale)
    output .= Format("{:20s}", r.given)
    output .= " " r.result
    output .= "`n"
}

MsgBox(output, "Inverse Calculations", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
LOGARITHMIC SCALES REFERENCE:

Decibels (Sound Intensity):
  dB = 10 × log₁₀(I / I₀)
  I₀ = 10^-12 W/m²
  10× intensity = +10 dB

Sound Pressure Level:
  SPL = 20 × log₁₀(P / P₀)
  P₀ = 20 μPa
  2× pressure = +6 dB

pH Scale:
  pH = -log₁₀([H⁺])
  Range: 0 (acidic) to 14 (basic)
  10× [H⁺] = -1 pH unit

Richter Scale:
  M = log₁₀(A)
  10× amplitude = +1 magnitude
  Each magnitude ≈ 32× more energy

Stellar Magnitude:
  m = -2.5 × log₁₀(F / F₀)
  Lower = brighter
  5 magnitudes = 100× brightness

Why Logarithmic Scales?
✓ Compress enormous ranges
✓ Human perception often logarithmic
✓ Multiplicative changes → additive
✓ Easier to work with large numbers
✓ Emphasize relative differences

Applications:
✓ Acoustics and audio
✓ Chemistry (pH, pKa)
✓ Seismology
✓ Astronomy
✓ Electronics (gain, attenuation)
✓ Information theory
)"

MsgBox(info, "Logarithmic Scales Reference", "Icon!")
