#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * First-Class Functions
 * 
 * Demonstrates that functions are first-class citizens in AHK v2:
 * - Stored in variables
 * - Passed as arguments
 * - Returned from functions
 * - Stored in data structures
 * 
 * Source: AHK_Notes/Concepts/First_Class_Functions.md
 */

; Example 1: Functions as Callback Arguments
MsgBox("Example 1: Functions as Callbacks", , "T2")

numbers := [1, 2, 3, 4, 5]

; Different processor functions
double := (x) => x * 2
square := (x) => x * x
cube := (x) => x * x * x

; Process array with different functions
doubledNumbers := ProcessItems(numbers, double)
squaredNumbers := ProcessItems(numbers, square)
cubedNumbers := ProcessItems(numbers, cube)

MsgBox("Original: [1,2,3,4,5]`n`n"
    . "Doubled: [" Join(doubledNumbers) "]`n"
    . "Squared: [" Join(squaredNumbers) "]`n"
    . "Cubed: [" Join(cubedNumbers) "]", , "T5")

; Example 2: Function Factories
MsgBox("Example 2: Function Factories", , "T2")

multiplyByTwo := CreateMultiplier(2)
multiplyByTen := CreateMultiplier(10)

result1 := multiplyByTwo(5)
result2 := multiplyByTen(5)

MsgBox("multiplyByTwo(5) = " result1 "`n"
    . "multiplyByTen(5) = " result2, , "T3")

; Example 3: Functions in Data Structures
MsgBox("Example 3: Functions in Map", , "T2")

operations := Map(
    "add", (x, y) => x + y,
    "subtract", (x, y) => x - y,
    "multiply", (x, y) => x * y,
    "divide", (x, y) => x / y,
    "power", (x, y) => x ** y
)

result := operations["multiply"](6, 7)
MsgBox("operations['multiply'](6, 7) = " result, , "T3")

/**
 * ProcessItems - Higher-Order Function
 * 
 * Applies a processor function to each item in an array.
 * 
 * @param items - Array of items to process
 * @param processor - Function to apply to each item
 * @return Array of processed items
 */
ProcessItems(items, processor) {
    results := []
    for item in items
        results.Push(processor(item))
    return results
}

/**
 * CreateMultiplier - Function Factory
 * 
 * Returns a function that multiplies by a factor.
 * 
 * @param factor - Multiplication factor
 * @return Function that multiplies by factor
 */
CreateMultiplier(factor) {
    return (x) => x * factor
}

/**
 * Join - Helper Function
 * 
 * Joins array elements with commas.
 */
Join(arr) {
    result := ""
    for item in arr
        result .= (result ? "," : "") item
    return result
}

/*
* Key Concepts:
*
* 1. First-Class Functions Mean:
*    ✅ Assign to variables
*    ✅ Pass as parameters
*    ✅ Return from functions
*    ✅ Store in data structures
*    ✅ Create at runtime
*
* 2. Function Types in AHK v2:
*
*    Named Function:
*    MyFunc(param) {
    *        return param * 2
    *    }
    *
    *    Anonymous Function:
    *    myFunc := (param) {
        *        return param * 2
        *    }
        *
        *    Arrow Function (concise):
        *    myFunc := (param) => param * 2
        *
        * 3. Higher-Order Functions:
        *    - Functions that take functions as parameters
        *    - Functions that return functions
        *    - Enable functional programming patterns
        *
        * 4. Common Patterns:
        *
        *    Map (transform each element):
        *    ProcessItems(arr, transformer)
        *
        *    Filter (select elements):
        *    FilterItems(arr, predicate)
        *
        *    Reduce (combine elements):
        *    ReduceItems(arr, combiner, initial)
        *
        * 5. Benefits:
        *    ✅ Code reuse (same function, different behavior)
        *    ✅ Abstraction (hide implementation details)
        *    ✅ Composition (build complex from simple)
        *    ✅ Testability (easy to test small functions)
        *
        * 6. Real-World Examples:
        *
        *    Event Handling:
        *    button.OnEvent("Click", (*) => MsgBox("Clicked!"))
        *
        *    Array Processing:
        *    filtered := arr.Filter(x => x > 10)
        *
        *    Sorting:
        *    arr.Sort((a, b) => a > b ? 1 : -1)
        *
        *    Callbacks:
        *    SetTimer(() => ToolTip("Hello"), 1000)
        *
        * 7. Function Signatures:
        *
        *    Optional Parameters:
        *    func(required, optional := 10)
        *
        *    Variadic Parameters:
        *    func(required, params*)
        *
        *    By-Reference:
        *    func(&param)
        *
        * 8. Comparison with v1:
        *    v1: Limited function support (Func object)
        *    v2: Full first-class function support
        *    v2: Arrow functions, closures, etc.
        *
        * 9. Functional Programming Enabled:
        *    - Pure functions
        *    - Immutability patterns
        *    - Function composition
        *    - Partial application
        *    - Currying
*/

