#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Function Types Comparison
 * 
 * Demonstrates the three function types in AutoHotkey v2:
 * named functions, anonymous functions, and arrow functions.
 * 
 * Source: AHK_Notes/Concepts/function-types-in-ahk-v2.md
 */

; Test 1: Named Function
result1 := NamedMultiply(5, 3)
MsgBox("Named Function:`n`n"
    . "NamedMultiply(5, 3) = " result1, , "T3")

; Test 2: Anonymous Function
anonymousMultiply := func(a, b) {
    return a * b
}
result2 := anonymousMultiply(5, 3)
MsgBox("Anonymous Function:`n`n"
    . "anonymousMultiply(5, 3) = " result2, , "T3")

; Test 3: Arrow Function
arrowMultiply := (a, b) => a * b
result3 := arrowMultiply(5, 3)
MsgBox("Arrow Function:`n`n"
    . "arrowMultiply(5, 3) = " result3, , "T3")

; Test 4: Comparing all types in callbacks
numbers := [1, 2, 3, 4, 5]

; Using named function
doubled1 := MapArray(numbers, NamedDouble)

; Using anonymous function
doubled2 := MapArray(numbers, func(x) {
    return x * 2
})

; Using arrow function
doubled3 := MapArray(numbers, (x) => x * 2)

MsgBox("Callback Comparison:`n`n"
    . "Original: [" Join(numbers) "]`n`n"
    . "Named function: [" Join(doubled1) "]`n"
    . "Anonymous function: [" Join(doubled2) "]`n"
    . "Arrow function: [" Join(doubled3) "]", , "T5")

; Test 5: Closures with different types
counter1 := CreateCounterNamed()
counter2 := CreateCounterArrow()

MsgBox("Closures:`n`n"
    . "Named closure: " counter1() ", " counter1() ", " counter1() "`n"
    . "Arrow closure: " counter2() ", " counter2() ", " counter2(), , "T5")

/**
 * Named Function - Traditional style
 * @param {number} a - First number
 * @param {number} b - Second number
 * @return {number} Product
 */
NamedMultiply(a, b) {
    return a * b
}

/**
 * Named Function - Double a number
 */
NamedDouble(x) {
    return x * 2
}

/**
 * MapArray - Apply function to each element
 */
MapArray(arr, fn) {
    result := []
    for value in arr
        result.Push(fn(value))
    return result
}

/**
 * CreateCounterNamed - Named function returning closure
 */
CreateCounterNamed() {
    count := 0

    ; Return anonymous function (closure)
    return func() {
        return ++count
    }
}

/**
 * CreateCounterArrow - Arrow function closure
 */
CreateCounterArrow() {
    count := 0

    ; Return arrow function (closure)
    return () => ++count
}

/**
 * Join - Helper to join array
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
* 1. Named Functions:
*    FunctionName(params) {
    *        ; Multiple statements
    *        return result
    *    }
    *    ✅ Reusable across script
    *    ✅ Can have JSDoc comments
    *    ✅ Good for complex logic
    *    ✅ Self-documenting
    *
    * 2. Anonymous Functions:
    *    fn := func(params) {
        *        ; Multiple statements
        *        return result
        *    }
        *    ✅ Assigned to variables
        *    ✅ Can be passed around
        *    ✅ Multiple statements
        *    ⚠ More verbose than arrows
        *
        * 3. Arrow Functions:
        *    fn := (params) => expression
        *    ✅ Concise syntax
        *    ✅ Implicit return
        *    ✅ Perfect for callbacks
        *    ⚠ Single expression only
        *
        * 4. When to Use Each:
        *    Named: Complex logic, reusable functions
        *    Anonymous: Need multiple statements in closure
        *    Arrow: Simple transformations, callbacks
        *
        * 5. Closures:
        *    All types can create closures
        *    Capture outer scope variables
        *    count := 0; () => ++count
        *
        * 6. Callback Patterns:
        *    MapArray(arr, NamedFn)           ; Named
        *    MapArray(arr, func(x) {          ; Anonymous
        *        return x * 2
        *    })
        *    MapArray(arr, (x) => x * 2)      ; Arrow
        *
        * 7. Performance:
        *    Named: Fastest (defined once)
        *    Anonymous: Creates new object each time
        *    Arrow: Creates new object each time
        *
        * 8. Comparison Table:
        *    ┌────────────┬───────┬───────────┬──────┐
        *    │ Type       │ Named │ Anonymous │ Arrow│
        *    ├────────────┼───────┼───────────┼──────┤
        *    │ Reusable   │  ✓    │     ✓     │  ✓   │
        *    │ Multi-line │  ✓    │     ✓     │  ✗   │
        *    │ Concise    │  ✗    │     ✗     │  ✓   │
        *    │ Closure    │  ✓    │     ✓     │  ✓   │
        *    │ Implicit   │  ✗    │     ✗     │  ✓   │
        *    │  return    │       │           │      │
        *    └────────────┴───────┴───────────┴──────┘
*/

