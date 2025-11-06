#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * AHK v2 Standard Library Examples - Part 3: Math & Type Conversion
 *
 * Built-in mathematical functions and type conversions
 * Documentation: https://www.autohotkey.com/docs/v2/
 */

; ═══════════════════════════════════════════════════════════════════════════
; MATH FUNCTIONS (Examples 1-15)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 1: Basic arithmetic operators
 */
ArithmeticExample() {
    a := 10
    b := 3

    MsgBox("a = " a ", b = " b "`n`n"
        . "Addition: " (a + b) "`n"
        . "Subtraction: " (a - b) "`n"
        . "Multiplication: " (a * b) "`n"
        . "Division: " (a / b) "`n"
        . "Floor Division: " (a // b) "`n"
        . "Modulo: " Mod(a, b) "`n"
        . "Power: " (a ** b))
}

/**
 * Example 2: Abs() - Absolute value
 */
AbsExample() {
    num1 := -15
    num2 := 25

    MsgBox("Abs(-15) = " Abs(num1) "`n"
        . "Abs(25) = " Abs(num2))
}

/**
 * Example 3: Round(), Floor(), Ceil() - Rounding
 */
RoundingExample() {
    number := 3.7

    MsgBox("Number: " number "`n`n"
        . "Round: " Round(number) "`n"
        . "Floor: " Floor(number) "`n"
        . "Ceil: " Ceil(number) "`n`n"
        . "Round to 2 decimals: " Round(3.14159, 2))
}

/**
 * Example 4: Min() and Max() - Find minimum/maximum
 */
MinMaxExample() {
    numbers := [5, 12, 3, 18, 7]

    minimum := Min(numbers*)
    maximum := Max(numbers*)

    MsgBox("Numbers: " ArrayToString(numbers) "`n`n"
        . "Minimum: " minimum "`n"
        . "Maximum: " maximum)
}

/**
 * Example 5: Sqrt() - Square root
 */
SqrtExample() {
    numbers := [4, 9, 16, 25, 100]

    output := "Square roots:`n`n"
    for num in numbers
        output .= "√" num " = " Sqrt(num) "`n"

    MsgBox(output)
}

/**
 * Example 6: Exp() and Ln() - Exponential and natural log
 */
ExpLnExample() {
    x := 2

    exp_result := Exp(x)  ; e^x
    ln_result := Ln(exp_result)  ; ln(e^x) = x

    MsgBox("x = " x "`n`n"
        . "e^x = " exp_result "`n"
        . "ln(e^x) = " ln_result)
}

/**
 * Example 7: Log() - Logarithm base 10
 */
LogExample() {
    numbers := [10, 100, 1000]

    output := "Logarithm base 10:`n`n"
    for num in numbers
        output .= "log(" num ") = " Log(num) "`n"

    MsgBox(output)
}

/**
 * Example 8: Sin(), Cos(), Tan() - Trigonometric functions
 */
TrigExample() {
    angle := 45
    radians := angle * 3.14159 / 180  ; Convert to radians

    MsgBox("Angle: " angle "° (" radians " radians)`n`n"
        . "Sin: " Round(Sin(radians), 4) "`n"
        . "Cos: " Round(Cos(radians), 4) "`n"
        . "Tan: " Round(Tan(radians), 4))
}

/**
 * Example 9: ASin(), ACos(), ATan() - Inverse trig functions
 */
InverseTrigExample() {
    value := 0.5

    MsgBox("Value: " value "`n`n"
        . "ASin (radians): " Round(ASin(value), 4) "`n"
        . "ACos (radians): " Round(ACos(value), 4) "`n"
        . "ATan (radians): " Round(ATan(value), 4))
}

/**
 * Example 10: Random() - Generate random numbers
 */
RandomExample() {
    ; Random integer between 1 and 100
    rand1 := Random(1, 100)

    ; Random float between 0 and 1
    rand2 := Random()

    ; Random from array
    choices := ["red", "green", "blue", "yellow"]
    randChoice := choices[Random(1, choices.Length)]

    MsgBox("Random integer (1-100): " rand1 "`n"
        . "Random float (0-1): " rand2 "`n"
        . "Random choice: " randChoice)
}

/**
 * Example 11: Mod() - Modulo operation
 */
ModExample() {
    MsgBox("10 mod 3 = " Mod(10, 3) "`n"
        . "15 mod 4 = " Mod(15, 4) "`n"
        . "7 mod 2 = " Mod(7, 2) " (odd)`n"
        . "8 mod 2 = " Mod(8, 2) " (even)")
}

/**
 * Example 12: Bitwise operations
 */
BitwiseExample() {
    a := 12  ; Binary: 1100
    b := 10  ; Binary: 1010

    MsgBox("a = " a " (1100)`n"
        . "b = " b " (1010)`n`n"
        . "AND: " (a & b) " (" Format("{:b}", a & b) ")`n"
        . "OR: " (a | b) " (" Format("{:b}", a | b) ")`n"
        . "XOR: " (a ^ b) " (" Format("{:b}", a ^ b) ")`n"
        . "NOT a: " (~a & 0xFF) "`n"
        . "Left shift: " (a << 1) "`n"
        . "Right shift: " (a >> 1))
}

/**
 * Example 13: Comparison operators
 */
ComparisonExample() {
    a := 10
    b := 20

    MsgBox("a = " a ", b = " b "`n`n"
        . "a = b: " (a = b) "`n"
        . "a != b: " (a != b) "`n"
        . "a < b: " (a < b) "`n"
        . "a > b: " (a > b) "`n"
        . "a <= b: " (a <= b) "`n"
        . "a >= b: " (a >= b))
}

/**
 * Example 14: Logical operators
 */
LogicalExample() {
    x := true
    y := false

    MsgBox("x = " x ", y = " y "`n`n"
        . "x AND y: " (x && y) "`n"
        . "x OR y: " (x || y) "`n"
        . "NOT x: " (!x) "`n"
        . "NOT y: " (!y))
}

/**
 * Example 15: Ternary operator
 */
TernaryExample() {
    score := 85

    grade := score >= 90 ? "A" : score >= 80 ? "B" : score >= 70 ? "C" : "F"
    passed := score >= 60 ? "Passed" : "Failed"

    MsgBox("Score: " score "`n"
        . "Grade: " grade "`n"
        . "Status: " passed)
}

; ═══════════════════════════════════════════════════════════════════════════
; TYPE CONVERSION (Examples 16-25)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 16: Integer() - Convert to integer
 */
IntegerExample() {
    str := "123"
    float := 45.67

    int1 := Integer(str)
    int2 := Integer(float)

    MsgBox("String '123' to int: " int1 "`n"
        . "Float 45.67 to int: " int2)
}

/**
 * Example 17: Float() - Convert to float
 */
FloatExample() {
    str := "123.45"
    int := 100

    float1 := Float(str)
    float2 := Float(int)

    MsgBox("String '123.45' to float: " float1 "`n"
        . "Integer 100 to float: " float2)
}

/**
 * Example 18: Number() - Convert to number
 */
NumberExample() {
    str1 := "42"
    str2 := "3.14"
    str3 := "invalid"

    num1 := Number(str1)
    num2 := Number(str2)
    num3 := Number(str3)  ; Returns 0 for invalid

    MsgBox("'42' to number: " num1 "`n"
        . "'3.14' to number: " num2 "`n"
        . "'invalid' to number: " num3)
}

/**
 * Example 19: String() - Convert to string
 */
StringExample() {
    num := 123
    float := 45.67
    bool := true

    str1 := String(num)
    str2 := String(float)
    str3 := String(bool)

    MsgBox("Integer to string: '" str1 "'`n"
        . "Float to string: '" str2 "'`n"
        . "Boolean to string: '" str3 "'")
}

/**
 * Example 20: Type() - Get variable type
 */
TypeExample() {
    var1 := "Hello"
    var2 := 123
    var3 := 3.14
    var4 := [1, 2, 3]
    var5 := Map("a", 1)

    MsgBox("Type of 'Hello': " Type(var1) "`n"
        . "Type of 123: " Type(var2) "`n"
        . "Type of 3.14: " Type(var3) "`n"
        . "Type of [1,2,3]: " Type(var4) "`n"
        . "Type of Map: " Type(var5))
}

/**
 * Example 21: IsNumber() - Check if numeric
 */
IsNumberExample() {
    test1 := "123"
    test2 := "abc"
    test3 := "12.34"

    MsgBox("'123' is number: " IsNumber(test1) "`n"
        . "'abc' is number: " IsNumber(test2) "`n"
        . "'12.34' is number: " IsNumber(test3))
}

/**
 * Example 22: IsInteger() - Check if integer
 */
IsIntegerExample() {
    test1 := 123
    test2 := 12.34
    test3 := "456"

    MsgBox("123 is integer: " IsInteger(test1) "`n"
        . "12.34 is integer: " IsInteger(test2) "`n"
        . "'456' is integer: " IsInteger(test3))
}

/**
 * Example 23: IsFloat() - Check if float
 */
IsFloatExample() {
    test1 := 3.14
    test2 := 42
    test3 := "2.5"

    MsgBox("3.14 is float: " IsFloat(test1) "`n"
        . "42 is float: " IsFloat(test2) "`n"
        . "'2.5' is float: " IsFloat(test3))
}

/**
 * Example 24: IsObject() - Check if object
 */
IsObjectExample() {
    test1 := [1, 2, 3]
    test2 := Map("a", 1)
    test3 := "string"
    test4 := 123

    MsgBox("Array is object: " IsObject(test1) "`n"
        . "Map is object: " IsObject(test2) "`n"
        . "String is object: " IsObject(test3) "`n"
        . "Number is object: " IsObject(test4))
}

/**
 * Example 25: Number formatting
 */
NumberFormatExample() {
    num := 1234567.89

    MsgBox("Number: " num "`n`n"
        . "2 decimals: " Format("{:.2f}", num) "`n"
        . "Scientific: " Format("{:e}", num) "`n"
        . "Hex: " Format("{:#x}", Integer(num)) "`n"
        . "Binary: " Format("{:#b}", 255))
}

; Helper function
ArrayToString(arr) {
    str := "["
    for value in arr
        str .= value ", "
    return RTrim(str, ", ") "]"
}

; Menu
MsgBox("AHK v2 Standard Library - Math & Types (Part 3)`n`n"
    . "MATH (1-15):`n"
    . "1. Arithmetic   2. Abs   3. Round/Floor/Ceil   4. Min/Max   5. Sqrt`n"
    . "6. Exp/Ln   7. Log   8. Sin/Cos/Tan   9. ASin/ACos/ATan   10. Random`n"
    . "11. Mod   12. Bitwise   13. Comparison   14. Logical   15. Ternary`n`n"
    . "TYPE CONVERSION (16-25):`n"
    . "16. Integer   17. Float   18. Number   19. String   20. Type`n"
    . "21. IsNumber   22. IsInteger   23. IsFloat   24. IsObject   25. Formatting`n`n"
    . "Call any example function to run!")

; Uncomment to test:
; ArithmeticExample()
; RoundingExample()
; RandomExample()
; TypeExample()
