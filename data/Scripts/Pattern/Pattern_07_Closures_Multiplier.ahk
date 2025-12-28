#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Closures Pattern - Function Multiplier Factory
 * 
 * Demonstrates closures as function generators.
 * Creates specialized functions that remember configuration.
 * 
 * Source: AHK_Notes/Patterns/closures-in-ahk-v2.md
 */

; Create specialized multiplier functions
double := CreateMultiplier(2)
triple := CreateMultiplier(3)
tenTimes := CreateMultiplier(10)

; Use the generated functions
result1 := double(5)
result2 := triple(5)
result3 := tenTimes(5)

MsgBox("Using function factories:`n`n"
    . "double(5) = " result1 "`n"
    . "triple(5) = " result2 "`n"
    . "tenTimes(5) = " result3, , "T5")

; Example: Create dynamic converters
inchesToCm := CreateMultiplier(2.54)
poundsToKg := CreateMultiplier(0.453592)
fahrenheitOffset := CreateAdder(-32)

height := 70  ; inches
weight := 150 ; pounds

MsgBox("Unit Conversions:`n`n"
    . height " inches = " Round(inchesToCm(height), 2) " cm`n"
    . weight " pounds = " Round(poundsToKg(weight), 2) " kg", , "T5")

/**
 * CreateMultiplier - Function Generator
 * 
 * Creates a function that multiplies by a fixed factor.
 * 
 * @param factor - The multiplication factor to capture
 * @return Function that multiplies input by factor
 */
CreateMultiplier(factor) {
    ; Return arrow function that captures 'factor'
    return (x) => x * factor
}

/**
 * CreateAdder - Function Generator
 * 
 * Creates a function that adds a fixed amount.
 * 
 * @param amount - The amount to add
 * @return Function that adds amount to input
 */
CreateAdder(amount) {
    return (x) => x + amount
}

/**
 * CreateOperation - Generic Operation Generator
 * 
 * Creates a function that applies any operation with a fixed operand.
 */
CreateOperation(operation, operand) {
    return (x) => operation(x, operand)
}

/*
* Key Concepts:
*
* 1. Function Generator Pattern:
*    - Returns a function, not a value
*    - Returned function captures parameters
*    - Creates specialized versions of generic operations
*
* 2. Closure Mechanism:
*
*    CreateMultiplier(2) returns:
*    (x) => x * 2    ; '2' is captured from outer scope
*
*    Every call to double(n) uses the captured '2'
*
* 3. Partial Application:
*    - Fixing some parameters of a function
*    - Creating specialized functions from generic ones
*
*    multiply(x, y) → CreateMultiplier(y) → (x) => x * y
*
* 4. Use Cases:
*
*    Configuration:
*    logger := CreateLogger("DEBUG")
*    logger("Message")  ; Logs with DEBUG level
*
*    Validation:
*    ageValidator := CreateRangeValidator(18, 65)
*    isValid := ageValidator(25)
*
*    Formatting:
*    currencyFormatter := CreateFormatter("$", 2)
*    formatted := currencyFormatter(123.456)  ; "$123.46"
*
*    Event Handlers:
*    handler := CreateClickHandler("Button1", processClick)
*    button.OnEvent("Click", handler)
*
* 5. Benefits:
*    ✅ Reduces code duplication
*    ✅ Configurable behavior
*    ✅ Cleaner than global variables
*    ✅ Testable isolated units
*    ✅ Reusable across codebase
*
* 6. Advanced Example - Compose Functions:
*
*    Compose(f, g) {
    *        return (x) => f(g(x))
    *    }
    *
    *    addTen := CreateAdder(10)
    *    double := CreateMultiplier(2)
    *    addThenDouble := Compose(double, addTen)
    *
    *    result := addThenDouble(5)  ; (5 + 10) * 2 = 30
    *
    * 7. Currying vs Partial Application:
    *
    *    Currying (breaks into single-argument functions):
    *    add(x)(y) → 5(3) → 8
    *
    *    Partial Application (fixes some arguments):
    *    add(x, y) → addFive(y) → addFive(3) → 8
    *
    * 8. Real-World Example - API Client:
    *
    *    CreateAPIClient(baseURL, apiKey) {
        *        return {
            *            Get: (endpoint) => HttpGet(baseURL endpoint, apiKey),
            *            Post: (endpoint, data) => HttpPost(baseURL endpoint, data, apiKey)
            *        }
            *    }
            *
            *    github := CreateAPIClient("https://api.github.com", myToken)
            *    repos := github.Get("/user/repos")
            *
            * 9. Performance:
            *    ✅ Minimal overhead
            *    ✅ Function created once
            *    ✅ Fast execution
            *    ⚠️  Small memory cost per closure
            *
            * 10. Functional Programming:
            *     - Closures enable FP patterns in AHK
            *     - Higher-order functions
            *     - Function composition
            *     - Immutable state management
*/

