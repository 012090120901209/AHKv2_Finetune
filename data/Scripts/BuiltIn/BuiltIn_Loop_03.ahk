#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Nested Loops
 * ============================================================================
 * 
 * @file BuiltIn_Loop_03.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples of nested loop structures including 2D iteration,
 * matrix operations, and multi-dimensional data processing.
 * 
 * @requires AutoHotkey v2.0+
 */


; ============================================================================
; Example 1: Basic Nested Loops
; ============================================================================

/**
 * Demonstrates basic nested loops.
 */
Example1_Basic_Nested_Loops() {
    OutputDebug("=== Example 1: Basic Nested Loops ===`n")

    ; Multiplication table
    Loop 5 {
        outer := A_Index
        row := ""
        Loop 5 {
            product := outer * A_Index
            row .= Format("{:4}", product)
        }
        OutputDebug("  " row "`n")
    }

    ; Nested iteration
    Loop 3 {
        OutputDebug("  Outer " A_Index ":`n")
        Loop 4 {
            OutputDebug("    Inner " A_Index "`n")
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: 2D Array Processing
; ============================================================================

/**
 * Demonstrates 2d array processing.
 */
Example2_2D_Array_Processing() {
    OutputDebug("=== Example 2: 2D Array Processing ===`n")

    ; Create and process 2D array
    grid := [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    Loop grid.Length {
        row := grid[A_Index]
        OutputDebug("  Row " A_Index ": ")
        Loop row.Length {
            OutputDebug(row[A_Index] " ")
        }
        OutputDebug("`n")
    }

    ; Sum all elements
    total := 0
    Loop grid.Length {
        Loop grid[A_Index].Length {
            total += grid[A_Index][A_Index]
        }
    }
    OutputDebug("  Total sum: " total "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Matrix Operations
; ============================================================================

/**
 * Demonstrates matrix operations.
 */
Example3_Matrix_Operations() {
    OutputDebug("=== Example 3: Matrix Operations ===`n")

    ; Transpose matrix
    matrix := [[1, 2, 3], [4, 5, 6]]
    rows := matrix.Length
    cols := matrix[1].Length

    OutputDebug("  Original matrix:`n")
    Loop rows {
        r := A_Index
        Loop cols {
            OutputDebug("  " matrix[r][A_Index])
        }
        OutputDebug("`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Pattern Generation
; ============================================================================

/**
 * Demonstrates pattern generation.
 */
Example4_Pattern_Generation() {
    OutputDebug("=== Example 4: Pattern Generation ===`n")

    ; Generate patterns
    Loop 5 {
        line := ""
        Loop A_Index {
            line .= "*"
        }
        OutputDebug("  " line "`n")
    }

    ; Diamond pattern
    size := 5
    Loop size {
        spaces := size - A_Index
        stars := (A_Index * 2) - 1
        line := ""
        Loop spaces
            line .= " "
        Loop stars
            line .= "*"
        OutputDebug("  " line "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Coordinate Systems
; ============================================================================

/**
 * Demonstrates coordinate systems.
 */
Example5_Coordinate_Systems() {
    OutputDebug("=== Example 5: Coordinate Systems ===`n")

    ; Grid coordinates
    Loop 3 {
        y := A_Index
        Loop 3 {
            x := A_Index
            OutputDebug("  Point(" x "," y ") ")
        }
        OutputDebug("`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Search in 2D
; ============================================================================

/**
 * Demonstrates search in 2d.
 */
Example6_Search_in_2D() {
    OutputDebug("=== Example 6: Search in 2D ===`n")

    ; Find value in grid
    data := [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    target := 5
    found := false

    Loop data.Length {
        if (found)
            break
        row := A_Index
        Loop data[row].Length {
            if (data[row][A_Index] = target) {
                OutputDebug("  Found " target " at (" row "," A_Index ")`n")
                found := true
                break
            }
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Combined Iteration
; ============================================================================

/**
 * Demonstrates combined iteration.
 */
Example7_Combined_Iteration() {
    OutputDebug("=== Example 7: Combined Iteration ===`n")

    ; Combine two arrays
    names := ["Alice", "Bob", "Carol"]
    scores := [85, 92, 78]

    Loop names.Length {
        idx := A_Index
        OutputDebug("  " names[idx] ": " scores[idx] " points`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Nested Loops`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_Basic_Nested_Loops()
    Example2_2D_Array_Processing()
    Example3_Matrix_Operations()
    Example4_Pattern_Generation()
    Example5_Coordinate_Systems()
    Example6_Search_in_2D()
    Example7_Combined_Iteration()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
