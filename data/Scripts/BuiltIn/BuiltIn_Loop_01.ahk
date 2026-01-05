#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Basic Count Loop
 * ============================================================================
 * 
 * This script demonstrates basic Loop statement usage in AutoHotkey v2.
 * Shows count-based iteration, loop counters, and common patterns.
 * 
 * @file BuiltIn_Loop_01.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples included:
 * 1. Basic count-based loops
 * 2. Loop counter (A_Index) usage
 * 3. Counting up and down
 * 4. Step intervals
 * 5. Loop with arrays
 * 6. Accumulation patterns
 * 7. Real-world count loop applications
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Basic Count Loops
; ============================================================================

/**
 * Demonstrates fundamental count-based loop syntax.
 */
Example1_BasicCountLoops() {
    OutputDebug("=== Example 1: Basic Count Loops ===`n")

    ; Simple loop - repeat 5 times
    OutputDebug("Counting to 5:`n")
    Loop 5 {
        OutputDebug("  Iteration " A_Index "`n")
    }

    ; Loop with variable count
    count := 3
    OutputDebug("`nLooping " count " times:`n")
    Loop count {
        OutputDebug("  Step " A_Index "`n")
    }

    ; Loop zero times (doesn't execute)
    OutputDebug("`nLoop 0 times:`n")
    Loop 0 {
        OutputDebug("  This won't print`n")
    }
    OutputDebug("  (No iterations)`n")

    ; Loop with expression
    start := 2
    multiplier := 3
    iterations := start * multiplier
    OutputDebug("`nLoop with expression (" start " * " multiplier " = " iterations "):`n")
    Loop iterations {
        OutputDebug("  #" A_Index "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Loop Counter (A_Index)
; ============================================================================

/**
 * Demonstrates using A_Index for various purposes.
 */
Example2_LoopCounter() {
    OutputDebug("=== Example 2: Loop Counter (A_Index) ===`n")

    ; A_Index as counter (1-based)
    OutputDebug("A_Index is 1-based:`n")
    Loop 5 {
        OutputDebug("  A_Index = " A_Index "`n")
    }

    ; Using A_Index in calculations
    OutputDebug("`nMultiplication table for 7:`n")
    Loop 10 {
        result := 7 * A_Index
        OutputDebug("  7 × " A_Index " = " result "`n")
    }

    ; A_Index for conditional logic
    OutputDebug("`nEven/Odd detection:`n")
    Loop 6 {
        if (Mod(A_Index, 2) = 0) {
            OutputDebug("  " A_Index " is even`n")
        } else {
            OutputDebug("  " A_Index " is odd`n")
        }
    }

    ; A_Index for array-style access
    values := [10, 20, 30, 40, 50]
    OutputDebug("`nAccessing array with A_Index:`n")
    Loop values.Length {
        OutputDebug("  values[" A_Index "] = " values[A_Index] "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Counting Patterns
; ============================================================================

/**
 * Demonstrates various counting patterns.
 */
Example3_CountingPatterns() {
    OutputDebug("=== Example 3: Counting Patterns ===`n")

    ; Count up from 1
    OutputDebug("Count up 1-5:`n")
    Loop 5 {
        OutputDebug("  " A_Index "`n")
    }

    ; Count down (reverse calculation)
    OutputDebug("`nCount down 5-1:`n")
    total := 5
    Loop total {
        value := total - A_Index + 1
        OutputDebug("  " value "`n")
    }

    ; Skip counting (multiples)
    OutputDebug("`nMultiples of 3:`n")
    Loop 5 {
        value := A_Index * 3
        OutputDebug("  " value "`n")
    }

    ; Powers of 2
    OutputDebug("`nPowers of 2:`n")
    Loop 8 {
        value := 2 ** (A_Index - 1)
        OutputDebug("  2^" (A_Index - 1) " = " value "`n")
    }

    ; Fibonacci sequence
    OutputDebug("`nFibonacci sequence:`n")
    a := 0
    b := 1
    Loop 10 {
        OutputDebug("  F(" A_Index ") = " b "`n")
        temp := a + b
        a := b
        b := temp
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Step Intervals
; ============================================================================

/**
 * Demonstrates implementing step intervals in loops.
 */
Example4_StepIntervals() {
    OutputDebug("=== Example 4: Step Intervals ===`n")

    ; Step by 2
    OutputDebug("Every 2nd number (0-20):`n")
    Loop 11 {
        value := (A_Index - 1) * 2
        OutputDebug("  " value "`n")
    }

    ; Step by 5
    OutputDebug("`nEvery 5th number (5-50):`n")
    Loop 10 {
        value := A_Index * 5
        OutputDebug("  " value "`n")
    }

    ; Countdown with steps
    OutputDebug("`nCountdown from 100 by 10:`n")
    Loop 10 {
        value := 100 - ((A_Index - 1) * 10)
        OutputDebug("  " value "`n")
    }

    ; Custom step pattern
    OutputDebug("`nDecimal steps (0.0 to 1.0 by 0.1):`n")
    Loop 11 {
        value := (A_Index - 1) * 0.1
        OutputDebug("  " Round(value, 1) "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Loop with Collections
; ============================================================================

/**
 * Demonstrates looping through arrays and collections.
 */
Example5_LoopWithCollections() {
    OutputDebug("=== Example 5: Loop with Collections ===`n")

    ; Loop through array
    fruits := ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    OutputDebug("Fruits list:`n")
    Loop fruits.Length {
        OutputDebug("  " A_Index ". " fruits[A_Index] "`n")
    }

    ; Process array elements
    numbers := [10, 25, 7, 42, 15]
    total := 0
    OutputDebug("`nSumming numbers:`n")
    Loop numbers.Length {
        value := numbers[A_Index]
        total += value
        OutputDebug("  Add " value " -> Total: " total "`n")
    }
    OutputDebug("Final sum: " total "`n")

    ; Build array using loop
    squares := []
    Loop 10 {
        squares.Push(A_Index ** 2)
    }
    OutputDebug("`nSquares array:`n")
    Loop squares.Length {
        OutputDebug("  " A_Index "² = " squares[A_Index] "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Accumulation Patterns
; ============================================================================

/**
 * Demonstrates various accumulation patterns.
 */
Example6_AccumulationPatterns() {
    OutputDebug("=== Example 6: Accumulation Patterns ===`n")

    ; Sum accumulation
    sum := 0
    Loop 10 {
        sum += A_Index
    }
    OutputDebug("Sum of 1-10: " sum "`n")

    ; Product accumulation
    product := 1
    Loop 5 {
        product *= A_Index
    }
    OutputDebug("Factorial of 5: " product "`n")

    ; String concatenation
    result := ""
    Loop 5 {
        result .= A_Index
        if (A_Index < 5) {
            result .= ", "
        }
    }
    OutputDebug("Concatenated: " result "`n")

    ; Max/Min tracking
    values := [15, 7, 23, 4, 19, 11]
    maxVal := values[1]
    minVal := values[1]
    Loop values.Length {
        if (values[A_Index] > maxVal) {
            maxVal := values[A_Index]
        }
        if (values[A_Index] < minVal) {
            minVal := values[A_Index]
        }
    }
    OutputDebug("Values: [15, 7, 23, 4, 19, 11]`n")
    OutputDebug("Max: " maxVal ", Min: " minVal "`n")

    ; Average calculation
    total := 0
    Loop values.Length {
        total += values[A_Index]
    }
    average := total / values.Length
    OutputDebug("Average: " Round(average, 2) "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Real-World Applications
; ============================================================================

/**
 * Demonstrates practical real-world loop applications.
 */
Example7_RealWorldApplications() {
    OutputDebug("=== Example 7: Real-World Applications ===`n")

    ; Generate password
    password := ""
    chars := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%"
    Loop 12 {
        pos := Random(1, StrLen(chars))
        password .= SubStr(chars, pos, 1)
    }
    OutputDebug("Generated password: " password "`n")

    ; Progress bar simulation
    OutputDebug("`nProgress bar:`n")
    Loop 10 {
        progress := A_Index * 10
        bar := ""
        Loop 10 {
            bar .= (A_Index <= progress / 10) ? "█" : "░"
        }
        OutputDebug("  [" bar "] " progress "%`n")
        Sleep(50)
    }

    ; Table generation
    OutputDebug("`nMultiplication table (1-5):`n")
    header := "    |"
    Loop 5 {
        header .= Format("{:5}", A_Index)
    }
    OutputDebug(header "`n")
    OutputDebug("    +-------------------------`n")

    Loop 5 {
        row := Format("{:3} |", A_Index)
        outer := A_Index
        Loop 5 {
            row .= Format("{:5}", outer * A_Index)
        }
        OutputDebug(row "`n")
    }

    ; Batch processing simulation
    OutputDebug("`nBatch processing 5 items:`n")
    Loop 5 {
        OutputDebug("  Processing item " A_Index "/5...`n")
        Sleep(30)
        OutputDebug("  Item " A_Index " completed`n")
    }
    OutputDebug("Batch processing complete!`n")

    OutputDebug("`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Basic Count Loop Examples`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_BasicCountLoops()
    Example2_LoopCounter()
    Example3_CountingPatterns()
    Example4_StepIntervals()
    Example5_LoopWithCollections()
    Example6_AccumulationPatterns()
    Example7_RealWorldApplications()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
