#Requires AutoHotkey v2.0

/**
 * BuiltIn_Random_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Comprehensive examples of Random() function for generating random numbers and applications
 * 
 * FEATURES:
 * - Basic random number generation
 * - Random integers and floats
 * - Random selection from arrays
 * - Dice rolling simulations
 * - Password and ID generation
 * - Shuffling algorithms
 * - Monte Carlo simulations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Random.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Random() function (integers and floats)
 * - Array manipulation with random selection
 * - String building with random characters
 * - Statistical distributions
 * - Simulation techniques
 * 
 * LEARNING POINTS:
 * 1. Random() generates pseudo-random numbers
 * 2. Random(min, max) for integers (inclusive)
 * 3. Random() with no args gives Float [0.0, 1.0)
 * 4. Use for simulations, games, and testing
 * 5. Combine with other functions for complex randomness
 */

; ============================================================
; Example 1: Basic Random Number Generation
; ============================================================

output := "BASIC RANDOM NUMBER GENERATION:`n`n"

; Random floats [0.0, 1.0)
output .= "Random Floats (no arguments):`n"
Loop 10 {
    randomFloat := Random()
    output .= "  " Format("{:.6f}", randomFloat) "`n"
}

; Random integers in range
output .= "`nRandom Integers (1 to 100):`n"
Loop 10 {
    randomInt := Random(1, 100)
    output .= "  " randomInt "`n"
}

; Random integers (negative range)
output .= "`nRandom Integers (-50 to 50):`n"
Loop 10 {
    randomInt := Random(-50, 50)
    output .= "  " randomInt "`n"
}

MsgBox(output, "Basic Random", "Icon!")

; ============================================================
; Example 2: Dice Rolling Simulator
; ============================================================

/**
 * Simulate rolling dice
 */
class Dice {
    /**
     * Roll single die
     */
    static Roll(sides := 6) {
        return Random(1, sides)
    }

    /**
     * Roll multiple dice
     */
    static RollMultiple(count, sides := 6) {
        results := []

        Loop count {
            results.Push(Dice.Roll(sides))
        }

        return results
    }

    /**
     * Roll and sum
     */
    static RollSum(count, sides := 6) {
        sum := 0

        Loop count {
            sum += Dice.Roll(sides)
        }

        return sum
    }

    /**
     * Advantage roll (roll twice, take higher)
     */
    static RollWithAdvantage(sides := 20) {
        roll1 := Dice.Roll(sides)
        roll2 := Dice.Roll(sides)
        return Max(roll1, roll2)
    }

    /**
     * Disadvantage roll (roll twice, take lower)
     */
    static RollWithDisadvantage(sides := 20) {
        roll1 := Dice.Roll(sides)
        roll2 := Dice.Roll(sides)
        return Min(roll1, roll2)
    }

    /**
     * Distribution analysis
     */
    static AnalyzeDistribution(sides, rolls) {
        counts := Map()

        Loop sides {
            counts[A_Index] := 0
        }

        Loop rolls {
            result := Dice.Roll(sides)
            counts[result]++
        }

        return counts
    }
}

output := "DICE ROLLING SIMULATOR:`n`n"

; Single die rolls
output .= "Rolling 1d6 (10 times):`n"
Loop 10 {
    roll := Dice.Roll(6)
    output .= "  Roll " A_Index ": " roll "`n"
}

; Multiple dice
output .= "`nRolling 3d6 (5 times):`n"
Loop 5 {
    rolls := Dice.RollMultiple(3, 6)
    sum := Dice.RollSum(3, 6)
    output .= "  Roll " A_Index ": [" StrReplace(Format("{:s}", rolls), " ", ", ") "]"
    output .= " = " sum "`n"
}

; Advantage/Disadvantage
output .= "`nD20 Rolls:`n"
normal := Dice.Roll(20)
advantage := Dice.RollWithAdvantage(20)
disadvantage := Dice.RollWithDisadvantage(20)

output .= "  Normal: " normal "`n"
output .= "  Advantage: " advantage "`n"
output .= "  Disadvantage: " disadvantage

MsgBox(output, "Dice Simulator", "Icon!")

; ============================================================
; Example 3: Random Selection and Sampling
; ============================================================

/**
 * Random selection utilities
 */
class RandomSelection {
    /**
     * Pick random element from array
     */
    static PickOne(array) {
        if (array.Length = 0)
            return ""

        index := Random(1, array.Length)
        return array[index]
    }

    /**
     * Pick n random elements (with replacement)
     */
    static PickMultiple(array, n) {
        results := []

        Loop n {
            results.Push(RandomSelection.PickOne(array))
        }

        return results
    }

    /**
     * Pick n random elements (without replacement)
     */
    static PickUnique(array, n) {
        if (n > array.Length)
            n := array.Length

        available := array.Clone()
        results := []

        Loop n {
            index := Random(1, available.Length)
            results.Push(available[index])
            available.RemoveAt(index)
        }

        return results
    }

    /**
     * Weighted random selection
     */
    static PickWeighted(items, weights) {
        ; Calculate total weight
        totalWeight := 0
        for weight in weights {
            totalWeight += weight
        }

        ; Pick random value
        randomValue := Random() * totalWeight

        ; Find selected item
        cumulative := 0
        for index, weight in weights {
            cumulative += weight

            if (randomValue <= cumulative)
                return items[index]
        }

        return items[items.Length]
    }
}

output := "RANDOM SELECTION:`n`n"

; Pick from array
fruits := ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
output .= "Fruits: " StrReplace(Format("{:s}", fruits), " ", ", ") "`n`n"

output .= "Random picks (with replacement):`n"
Loop 8 {
    picked := RandomSelection.PickOne(fruits)
    output .= "  " A_Index ". " picked "`n"
}

; Pick unique
output .= "`nRandom picks (without replacement, 3 items):`n"
unique := RandomSelection.PickUnique(fruits, 3)
output .= "  Selected: " StrReplace(Format("{:s}", unique), " ", ", ") "`n`n"

; Weighted selection
items := ["Common", "Uncommon", "Rare", "Epic", "Legendary"]
weights := [50, 30, 15, 4, 1]  ; Probabilities

output .= "Weighted Random (Loot Drop):`n"
output .= "Items: Common(50%), Uncommon(30%), Rare(15%), Epic(4%), Legendary(1%)`n`n"

Loop 10 {
    item := RandomSelection.PickWeighted(items, weights)
    output .= "  Drop " A_Index ": " item "`n"
}

MsgBox(output, "Random Selection", "Icon!")

; ============================================================
; Example 4: Array Shuffling
; ============================================================

/**
 * Shuffle algorithms
 */
class Shuffle {
    /**
     * Fisher-Yates shuffle (modern algorithm)
     */
    static FisherYates(array) {
        shuffled := array.Clone()

        Loop shuffled.Length - 1 {
            i := shuffled.Length - A_Index + 1
            j := Random(1, i)

            ; Swap
            temp := shuffled[i]
            shuffled[i] := shuffled[j]
            shuffled[j] := temp
        }

        return shuffled
    }

    /**
     * Simple shuffle (less efficient, included for comparison)
     */
    static SimpleRandomize(array) {
        shuffled := array.Clone()

        Loop shuffled.Length * 2 {
            i := Random(1, shuffled.Length)
            j := Random(1, shuffled.Length)

            ; Swap
            temp := shuffled[i]
            shuffled[i] := shuffled[j]
            shuffled[j] := temp
        }

        return shuffled
    }

    /**
     * Partial shuffle (shuffle only first n elements)
     */
    static PartialShuffle(array, n) {
        shuffled := array.Clone()
        n := Min(n, shuffled.Length)

        Loop n {
            i := A_Index
            j := Random(i, shuffled.Length)

            ; Swap
            temp := shuffled[i]
            shuffled[i] := shuffled[j]
            shuffled[j] := temp
        }

        return shuffled
    }
}

output := "ARRAY SHUFFLING:`n`n"

; Deck of cards (simplified)
deck := []
suits := ["♠", "♥", "♦", "♣"]
ranks := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

for suit in suits {
    for rank in ranks {
        deck.Push(rank suit)
    }
}

output .= "Original Deck (first 13 cards):`n"
Loop 13 {
    output .= "  " deck[A_Index] (Mod(A_Index, 13) = 0 ? "`n" : "")
}

; Shuffle deck
shuffled := Shuffle.FisherYates(deck)

output .= "`nShuffled Deck (first 13 cards):`n"
Loop 13 {
    output .= "  " shuffled[A_Index] (Mod(A_Index, 13) = 0 ? "`n" : "")
}

; Deal hands
output .= "`nDealing 5-card hands:`n"
Loop 3 {
    hand := []
    offset := (A_Index - 1) * 5

    Loop 5 {
        hand.Push(shuffled[offset + A_Index])
    }

    output .= "  Hand " A_Index ": " StrReplace(Format("{:s}", hand), " ", " ") "`n"
}

MsgBox(output, "Shuffling", "Icon!")

; ============================================================
; Example 5: Password and ID Generation
; ============================================================

/**
 * Generate random passwords and IDs
 */
class RandomGenerator {
    /**
     * Generate random password
     */
    static Password(length := 12, includeSymbols := true) {
        lowercase := "abcdefghijklmnopqrstuvwxyz"
        uppercase := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        numbers := "0123456789"
        symbols := "!@#$%^&*()_+-=[]{}|;:,.<>?"

        chars := lowercase uppercase numbers
        if (includeSymbols)
            chars .= symbols

        password := ""

        Loop length {
            index := Random(1, StrLen(chars))
            password .= SubStr(chars, index, 1)
        }

        return password
    }

    /**
     * Generate alphanumeric ID
     */
    static AlphanumericID(length := 8) {
        chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        id := ""

        Loop length {
            index := Random(1, StrLen(chars))
            id .= SubStr(chars, index, 1)
        }

        return id
    }

    /**
     * Generate UUID-like string
     */
    static UUID() {
        hex := "0123456789abcdef"
        uuid := ""

        ; Format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
        patterns := [8, 4, 4, 4, 12]

        for index, len in patterns {
            if (index > 1)
                uuid .= "-"

            Loop len {
                charIndex := Random(1, StrLen(hex))
                uuid .= SubStr(hex, charIndex, 1)
            }
        }

        return uuid
    }

    /**
     * Generate random color hex
     */
    static ColorHex() {
        return Format("{:06X}", Random(0, 0xFFFFFF))
    }
}

output := "PASSWORD AND ID GENERATION:`n`n"

; Passwords
output .= "Random Passwords (12 characters):`n"
Loop 5 {
    password := RandomGenerator.Password(12, true)
    output .= "  " A_Index ". " password "`n"
}

; IDs
output .= "`nAlphanumeric IDs (8 characters):`n"
Loop 5 {
    id := RandomGenerator.AlphanumericID(8)
    output .= "  " A_Index ". " id "`n"
}

; UUIDs
output .= "`nUUID-like Strings:`n"
Loop 3 {
    uuid := RandomGenerator.UUID()
    output .= "  " A_Index ". " uuid "`n"
}

; Color codes
output .= "`nRandom Color Codes:`n"
Loop 5 {
    color := RandomGenerator.ColorHex()
    output .= "  " A_Index ". #" color "`n"
}

MsgBox(output, "Generators", "Icon!")

; ============================================================
; Example 6: Statistical Distributions
; ============================================================

/**
 * Generate samples from different distributions
 */
class Distributions {
    /**
     * Uniform distribution [min, max]
     */
    static Uniform(min, max) {
        return Random() * (max - min) + min
    }

    /**
     * Normal distribution (Box-Muller transform)
     */
    static Normal(mean := 0, stdDev := 1) {
        u1 := Random()
        u2 := Random()

        ; Box-Muller transform
        z0 := Sqrt(-2 * Ln(u1)) * Cos(2 * 3.14159265359 * u2)

        return mean + stdDev * z0
    }

    /**
     * Exponential distribution
     */
    static Exponential(lambda := 1) {
        u := Random()
        return -Ln(1 - u) / lambda
    }

    /**
     * Generate histogram data
     */
    static GenerateHistogram(generator, samples, bins) {
        data := []
        Loop samples {
            data.Push(generator())
        }

        ; Create bins
        minVal := data[1]
        maxVal := data[1]

        for val in data {
            minVal := Min(minVal, val)
            maxVal := Max(maxVal, val)
        }

        binSize := (maxVal - minVal) / bins
        counts := []

        Loop bins {
            counts.Push(0)
        }

        ; Count samples in bins
        for val in data {
            binIndex := Floor((val - minVal) / binSize)
            if (binIndex >= bins)
                binIndex := bins - 1

            counts[binIndex + 1]++
        }

        return { min: minVal, max: maxVal, binSize: binSize, counts: counts }
    }
}

output := "STATISTICAL DISTRIBUTIONS:`n`n"

; Uniform distribution
output .= "Uniform Distribution [0, 10]:`n"
Loop 10 {
    value := Distributions.Uniform(0, 10)
    output .= "  " Format("{:.4f}", value) "`n"
}

; Normal distribution
output .= "`nNormal Distribution (mean=100, σ=15):`n"
Loop 10 {
    value := Distributions.Normal(100, 15)
    output .= "  " Format("{:.2f}", value) "`n"
}

; Exponential distribution
output .= "`nExponential Distribution (λ=0.5):`n"
Loop 10 {
    value := Distributions.Exponential(0.5)
    output .= "  " Format("{:.4f}", value) "`n"
}

MsgBox(output, "Distributions", "Icon!")

; ============================================================
; Example 7: Monte Carlo Simulation
; ============================================================

/**
 * Monte Carlo simulations
 */
class MonteCarlo {
    /**
     * Estimate Pi using random points in circle
     */
    static EstimatePi(samples) {
        insideCircle := 0

        Loop samples {
            x := Random() * 2 - 1  ; [-1, 1]
            y := Random() * 2 - 1  ; [-1, 1]

            ; Check if inside unit circle
            if (x * x + y * y <= 1)
                insideCircle++
        }

        return 4 * insideCircle / samples
    }

    /**
     * Simulate probability of event
     */
    static SimulateProbability(event, trials) {
        successes := 0

        Loop trials {
            if (event())
                successes++
        }

        return successes / trials
    }

    /**
     * Monty Hall problem simulation
     */
    static MontyHall(trials, switchDoors) {
        wins := 0

        Loop trials {
            ; Setup
            carDoor := Random(1, 3)
            initialChoice := Random(1, 3)

            ; Host opens door
            availableDoors := [1, 2, 3]
            availableDoors.RemoveAt(initialChoice)

            if (carDoor = initialChoice) {
                ; Car behind initial choice, host opens random remaining door
                availableDoors.RemoveAt(Random(1, availableDoors.Length))
            } else {
                ; Car behind other door, host must open the empty one
                for index, door in availableDoors {
                    if (door = carDoor) {
                        availableDoors.RemoveAt(index = 1 ? 2 : 1)
                        break
                    }
                }
            }

            ; Final choice
            finalChoice := switchDoors ? availableDoors[1] : initialChoice

            ; Check win
            if (finalChoice = carDoor)
                wins++
        }

        return wins / trials
    }
}

output := "MONTE CARLO SIMULATIONS:`n`n"

; Estimate Pi
samples := [100, 1000, 10000, 100000]
output .= "Estimating π:`n"

for n in samples {
    piEstimate := MonteCarlo.EstimatePi(n)
    error := Abs(piEstimate - 3.14159265359)

    output .= Format("  {:6d} samples: π ≈ {:.6f} (error: {:.6f})",
        n, piEstimate, error) "`n"
}

; Monty Hall problem
output .= "`nMonty Hall Problem (10,000 trials):`n"
stayWinRate := MonteCarlo.MontyHall(10000, false)
switchWinRate := MonteCarlo.MontyHall(10000, true)

output .= "  Stay with initial choice: " Format("{:.2f}", stayWinRate * 100) "%`n"
output .= "  Switch doors: " Format("{:.2f}", switchWinRate * 100) "%`n"
output .= "  (Expected: ~33% stay, ~67% switch)"

MsgBox(output, "Monte Carlo", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
RANDOM() FUNCTION REFERENCE:

Syntax:
Float := Random()               ; Returns [0.0, 1.0)
Integer := Random(Max)          ; Returns [0, Max]
Integer := Random(Min, Max)     ; Returns [Min, Max]

Return Values:
• Random() → Float in [0.0, 1.0)
• Random(n) → Integer in [0, n]
• Random(a, b) → Integer in [a, b]
• Both bounds are inclusive for integers

Properties:
• Pseudo-random (deterministic seed)
• Uniform distribution
• Each call is independent
• Not cryptographically secure

Common Patterns:
✓ Dice roll: Random(1, 6)
✓ Coin flip: Random(0, 1)
✓ Percentage: Random(1, 100)
✓ Array pick: array[Random(1, array.Length)]
✓ Float range: Random() * (max - min) + min

Applications:
✓ Game mechanics (dice, loot drops)
✓ Password generation
✓ Shuffling algorithms
✓ Sampling and testing
✓ Monte Carlo simulations
✓ Procedural generation
✓ Random selection

Algorithms:
• Fisher-Yates: Optimal shuffle O(n)
• Box-Muller: Normal distribution
• Inverse transform: Various distributions
• Rejection sampling: Complex distributions

Best Practices:
• Use Fisher-Yates for shuffling
• Clone arrays before shuffling
• Consider weighted randomness
• Test distributions with histograms
• Use Monte Carlo for complex probabilities

Limitations:
• Not cryptographically secure
• Pseudo-random (repeatable with same seed)
• For crypto, use system random sources
)"

MsgBox(info, "Random() Reference", "Icon!")
