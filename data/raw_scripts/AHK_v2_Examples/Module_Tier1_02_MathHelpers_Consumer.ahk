#Requires AutoHotkey v2.1-alpha.17
/**
 * Module Tier 1 Example 02: MathHelpers Consumer
 *
 * This example demonstrates:
 * - Importing a module
 * - Using module namespace
 * - Accessing exported functions
 * - Module alias (as Math)
 *
 * USAGE: Run this file directly
 *
 * @requires Module_Tier1_01_MathHelpers_Module.ahk
 */

#SingleInstance Force

; Import the MathHelpers module with alias "Math"
Import MathHelpers as Math

; Example 1: Basic arithmetic
result1 := Math.Add(5, 3)
result2 := Math.Subtract(10, 4)
result3 := Math.Multiply(6, 7)
result4 := Math.Divide(20, 4)

MsgBox("Addition: 5 + 3 = " result1
     . "`nSubtraction: 10 - 4 = " result2
     . "`nMultiplication: 6 × 7 = " result3
     . "`nDivision: 20 ÷ 4 = " result4,
     "Basic Arithmetic", "Icon!")

; Example 2: Power functions
base := 2
square := Math.Square(base)
cube := Math.Cube(base)
power5 := Math.Power(base, 5)

MsgBox("Base: " base
     . "`nSquare: " square
     . "`nCube: " cube
     . "`nPower of 5: " power5,
     "Power Functions", "Icon!")

; Example 3: Even/Odd check
Loop 5 {
    number := A_Index
    isEven := Math.IsEven(number)
    isOdd := Math.IsOdd(number)

    if (A_Index = 1) {
        resultText := ""
    }

    resultText .= number ": " (isEven ? "Even" : "Odd") "`n"
}

MsgBox(resultText, "Even/Odd Check", "Icon!")

; Example 4: Clamp and Lerp
value := 150
clamped := Math.Clamp(value, 0, 100)

lerp25 := Math.Lerp(0, 100, 0.25)
lerp50 := Math.Lerp(0, 100, 0.50)
lerp75 := Math.Lerp(0, 100, 0.75)

MsgBox("Original: " value
     . "`nClamped (0-100): " clamped
     . "`n`nLinear Interpolation (0-100):"
     . "`n25%: " lerp25
     . "`n50%: " lerp50
     . "`n75%: " lerp75,
     "Clamp & Lerp", "Icon!")

; Example 5: Error handling
try {
    result := Math.Divide(10, 0)
    MsgBox("Result: " result)
} catch as err {
    MsgBox("Error caught: " err.Message, "Division by Zero", "Icon!")
}

; Example 6: Complex calculation
Calculate() {
    ; Using multiple module functions
    a := Math.Square(5)        ; 25
    b := Math.Cube(2)          ; 8
    sum := Math.Add(a, b)      ; 33
    sqrt := Math.Sqrt(sum)     ; ~5.74

    return "Square(5) + Cube(2) = " a " + " b " = " sum
         . "`nSqrt(" sum ") = " Format("{:.2f}", sqrt)
}

MsgBox(Calculate(), "Complex Calculation", "Icon!")

; NOTE: We CANNOT access private functions
; This would cause an error:
; Math.FormatNumber(123.456)  ; ❌ Error: Function not found
