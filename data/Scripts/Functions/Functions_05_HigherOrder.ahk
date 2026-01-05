#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Higher-Order Functions
 * 
 * Demonstrates first-class functions: functions as arguments,
 * function factories, closures, and higher-order patterns.
 * 
 * Source: AHK_Notes/Concepts/First_Class_Functions.md
 */

; Test 1: Functions as arguments (callbacks)
numbers := [1, 2, 3, 4, 5]
doubled := Map_Array(numbers, (x) => x * 2)
filtered := Filter_Array(numbers, (x) => x > 2)

MsgBox("Higher-Order Functions:`n`n"
    . "Original: [" Join(numbers) "]`n"
    . "Doubled: [" Join(doubled) "]`n"
    . "Filtered (>2): [" Join(filtered) "]", , "T5")

; Test 2: Function factories
multiply5 := CreateMultiplier(5)
multiply10 := CreateMultiplier(10)

MsgBox("Function Factories:`n`n"
    . "multiply5(3) = " multiply5(3) "`n"
    . "multiply10(3) = " multiply10(3), , "T3")

; Test 3: Closure counters
counter1 := CreateCounter()
counter2 := CreateCounter(10)

MsgBox("Closures:`n`n"
    . "Counter1 increment: " counter1.Increment() "`n"
    . "Counter1 increment: " counter1.Increment() "`n"
    . "Counter1 value: " counter1.GetValue() "`n`n"
    . "Counter2 (start=10) increment: " counter2.Increment() "`n"
    . "Counter2 value: " counter2.GetValue(), , "T5")

; Test 4: Dynamic function selection
operations := Map(
    "add", (a, b) => a + b,
    "subtract", (a, b) => a - b,
    "multiply", (a, b) => a * b,
    "divide", (a, b) => a / b
)

result := ExecuteOperation(operations, "multiply", 6, 7)
MsgBox("Dynamic dispatch: 6 * 7 = " result, , "T3")

/**
 * Map_Array - Apply function to each element
 * @param {array} arr - Input array
 * @param {func} fn - Transform function
 * @return {array} Transformed array
 */
Map_Array(arr, fn) {
    result := []
    for value in arr
        result.Push(fn(value))
    return result
}

/**
 * Filter_Array - Keep elements matching predicate
 * @param {array} arr - Input array
 * @param {func} predicate - Test function
 * @return {array} Filtered array
 */
Filter_Array(arr, predicate) {
    result := []
    for value in arr {
        if (predicate(value))
            result.Push(value)
    }
    return result
}

/**
 * CreateMultiplier - Function factory
 * Returns function that multiplies by factor
 * @param {number} factor - Multiplication factor
 * @return {func} Multiplier function
 */
CreateMultiplier(factor) {
    return (x) => x * factor  ; Closure captures 'factor'
}

/**
 * CreateCounter - Closure-based counter
 * @param {int} start - Starting value
 * @return {object} Counter with methods
 */
CreateCounter(start := 0) {
    current := start  ; Private variable

    return {
        Increment: () => ++current,
        Decrement: () => --current,
        GetValue: () => current,
        Reset: () => current := start
    }
}

/**
 * ExecuteOperation - Dynamic function dispatch
 * @param {map} operations - Map of operation functions
 * @param {string} opName - Operation name
 * @param {any} args* - Arguments for operation
 * @return {any} Operation result
 */
ExecuteOperation(operations, opName, args*) {
    if (!operations.Has(opName))
        throw ValueError("Unknown operation: " opName)

    fn := operations[opName]
    return fn(args*)
}

/**
 * Join - Helper to join array elements
 */
Join(arr, delimiter := ", ") {
    result := ""
    for index, value in arr {
        result .= value (index < arr.Length ? delimiter : "")
    }
    return result
}

/*
* Key Concepts:
*
* 1. First-Class Functions:
*    fn := (x) => x * 2  ; Assign to variable
*    Map_Array(arr, fn)  ; Pass as argument
*    return (x) => ...   ; Return from function
*
* 2. Higher-Order Functions:
*    Functions that accept/return functions
*    Map, Filter, Reduce patterns
*    Function composition
*
* 3. Closures:
*    Inner function captures outer variables
*    CreateMultiplier captures 'factor'
*    CreateCounter captures 'current'
*
* 4. Function Factories:
*    CreateMultiplier(5) creates new function
*    Each call creates independent closure
*    Captured variables are private
*
* 5. Arrow Functions:
*    (x) => x * 2  ; Single expression
*    (a, b) => a + b  ; Multiple parameters
*    () => value  ; No parameters
*
* 6. Dynamic Dispatch:
*    Store functions in Map
*    Select function by name at runtime
*    Flexible, extensible architecture
*
* 7. Benefits:
*    ✅ Code reuse
*    ✅ Abstraction
*    ✅ Functional patterns
*    ✅ Flexible composition
*/

