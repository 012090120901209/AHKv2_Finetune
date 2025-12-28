#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - For Filtering
 * ============================================================================
 * 
 * This script demonstrates for filtering in AutoHotkey v2.
 * Covers conditional filtering, data selection.
 * 
 * @file BuiltIn_For_03.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1
; ============================================================================

Example1() {
    OutputDebug("=== Example 1 ===`n")

    arr := ["apple", "banana", "cherry"]
    for index, item in arr {
        OutputDebug("  " index ": " item "`n")
    }

    ; Map iteration
    data := Map("name", "John", "age", "30")
    for key, value in data {
        OutputDebug("  " key " = " value "`n")
    }
    OutputDebug("`n")
}

; ============================================================================
; Example 2
; ============================================================================

Example2() {
    OutputDebug("=== Example 2 ===`n")

    ; Additional demonstration
    result := []
    Loop 5 {
        result.Push(A_Index * 2)
    }

    for item in result {
        OutputDebug("  " item "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3
; ============================================================================

Example3() {
    OutputDebug("=== Example 3 ===`n")

    ; Practical example
    data := Map()
    data["key1"] := "value1"
    data["key2"] := "value2"

    for key, val in data {
        OutputDebug("  " key " -> " val "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4
; ============================================================================

Example4() {
    OutputDebug("=== Example 4 ===`n")

    ; Pattern demonstration
    numbers := [1, 2, 3, 4, 5]
    sum := 0

    for num in numbers {
        sum += num
    }

    OutputDebug("  Sum: " sum "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 5
; ============================================================================

Example5() {
    OutputDebug("=== Example 5 ===`n")

    ; Advanced usage
    Loop 3 {
        outer := A_Index
        Loop 3 {
            OutputDebug("  (" outer "," A_Index ")`n")
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6
; ============================================================================

Example6() {
    OutputDebug("=== Example 6 ===`n")

    ; Real-world scenario
    items := ["Task 1", "Task 2", "Task 3"]
    completed := 0

    for task in items {
        OutputDebug("  Processing: " task "`n")
        completed++
    }

    OutputDebug("  Completed: " completed "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 7
; ============================================================================

Example7() {
    OutputDebug("=== Example 7 ===`n")

    ; Complex example
    matrix := [[1, 2], [3, 4]]

    for row in matrix {
        line := ""
        for cell in row {
            line .= cell " "
        }
        OutputDebug("  " line "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - {title}`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1()
    Example2()
    Example3()
    Example4()
    Example5()
    Example6()
    Example7()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
