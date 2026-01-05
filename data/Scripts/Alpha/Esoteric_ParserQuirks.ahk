#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Parser Quirks - Unusual syntax behaviors and edge cases
; Demonstrates AHK v2's parser ambiguities and unusual constructs

; =============================================================================
; 1. Multi-line Statement Continuation (Implicit)
; =============================================================================

; Function call split across lines without continuation character
MultiLineFuncDemo() {
    ; This calls TestFunc with result of b assignment
    result := TestFunc
    "arg1"
    "arg2"

    MsgBox(result)
}

TestFunc(a, b) => a " + " b

; =============================================================================
; 2. Dangling Else Demonstration
; =============================================================================

class DanglingElse {
    ; Classic ambiguity - else binds to nearest if
    static Demonstrate(a, b) {
        result := ""

        if a > 0
            if b > 0
                result := "Both positive"
            else
                result := "A positive, B not"  ; Binds to inner if!

        return result
    }

    ; Explicit bracing removes ambiguity
    static DemonstrateExplicit(a, b) {
        result := ""

        if a > 0 {
            if b > 0
                result := "Both positive"
        } else {
            result := "A not positive"  ; Now binds to outer if
        }

        return result
    }
}

; =============================================================================
; 3. Label vs Switch Case Collision
; =============================================================================

class LabelSwitchCollision {
    static labels := Map()

    ; Demonstrates label/switch ambiguity
    static Demo() {
        result := []
        d := 1
        counter := 0

        ; In real code, this creates interesting control flow
        ; goto target: jumps to label
        ; switch case target: matches value

        switch d {
            case 1:
                result.Push("Matched case 1")
                ; A label INSIDE switch is valid!
innerLabel:
                result.Push("At inner label")
            default:
                result.Push("Default case")
        }

        return result
    }
}

; =============================================================================
; 4. Operator Precedence Edge Cases
; =============================================================================

class OperatorPrecedence {
    ; not > && > || > ?: > assignment
    static Demo1() {
        ; not 1 && 2 ? 0 : 1 2
        ; Parsed as: ((not 1) && 2) ? 0 : (1 . 2)
        ; = (false && 2) ? 0 : "12"
        ; = false ? 0 : "12"
        ; = "12"

        result := not 1 && 2 ? 0 : 1 . 2
        return result  ; "12"
    }

    ; Concatenation with space is lowest precedence
    static Demo2() {
        a := 1
        b := 2

        ; Space concatenation
        result := a b  ; "12"

        ; Explicit concatenation
        result2 := a . b  ; "12"

        return [result, result2]
    }

    ; Ternary chains
    static Demo3(n) {
        ; Right-associative ternary
        return n < 0 ? "negative"
            : n = 0 ? "zero"
            : n < 10 ? "small"
            : n < 100 ? "medium"
            : "large"
    }
}

; =============================================================================
; 5. Inline Object Property Access
; =============================================================================

class InlineObjectAccess {
    ; Create and access object in one expression
    static Demo() {
        ; Single level
        value1 := { a: "hello" }.a

        ; Nested
        value2 := {
            outer: {
                inner: {
                    deep: "found"
                }
            }
        }.outer.inner.deep

        ; With method
        value3 := {
            getValue: (*) => 42,
            data: "test"
        }.getValue()

        ; Array literal access
        value4 := [10, 20, 30][2]  ; 20

        return Map(
            "value1", value1,
            "value2", value2,
            "value3", value3,
            "value4", value4
        )
    }
}

; =============================================================================
; 6. Function Definition Ambiguity
; =============================================================================

; This looks like a function definition with default parameter
; but could be interpreted as function call with parenthesized expression
AmbiguousFunc(a := 1) {
    return a * 2
}

; This IS a loop, not a function call
; The space before ( matters!
LoopVsCall() {
    results := []

    ; Loop statement - space before (
    x := 3
    Loop (x) {
        results.Push("Loop iteration " A_Index)
    }

    ; Function call - no space (or space doesn't matter here)
    y := SomeFunc(3)

    return results
}

SomeFunc(n) => n * 2

; =============================================================================
; 7. Comma Operator in Expressions
; =============================================================================

class CommaOperator {
    ; Comma evaluates all expressions, returns last
    static Demo() {
        ; All statements execute, result is last value
        result := (
            x := 1,
            y := 2,
            z := x + y,
            z * 2  ; This is returned
        )

        return result  ; 6
    }

    ; Useful in fat arrow functions for multi-statement
    static CreateCounter() {
        count := 0
        return () => (count++, count)  ; Increment AND return
    }
}

; =============================================================================
; 8. VarRef Edge Cases
; =============================================================================

class VarRefEdgeCases {
    ; Reference to reference
    static Demo() {
        a := 10

        ; Create reference
        ref := &a

        ; Dereference
        value := %ref%

        ; Modify through reference
        %ref% := 20

        return [a, value]  ; [20, 10]
    }

    ; Swap using references
    static Swap(&a, &b) {
        temp := a
        a := b
        b := temp
    }

    ; Out parameters
    static TryParse(str, &result) {
        if RegExMatch(str, "^\d+$") {
            result := Integer(str)
            return true
        }
        result := 0
        return false
    }
}

; =============================================================================
; Demo
; =============================================================================

; Operator precedence
MsgBox("Operator Precedence Demo:`n`n"
    . "not 1 && 2 ? 0 : 1.2 = " OperatorPrecedence.Demo1() "`n"
    . "Ternary chain (5): " OperatorPrecedence.Demo3(5) "`n"
    . "Ternary chain (50): " OperatorPrecedence.Demo3(50) "`n"
    . "Ternary chain (500): " OperatorPrecedence.Demo3(500))

; Inline object access
values := InlineObjectAccess.Demo()
MsgBox("Inline Object Access:`n`n"
    . "Single: " values["value1"] "`n"
    . "Nested: " values["value2"] "`n"
    . "Method: " values["value3"] "`n"
    . "Array: " values["value4"])

; Comma operator
MsgBox("Comma Operator:`n`n"
    . "Expression result: " CommaOperator.Demo() "`n"
    . "Counter: " (counter := CommaOperator.CreateCounter(),
        counter() ", " counter() ", " counter()))

; VarRef
x := 1, y := 2
VarRefEdgeCases.Swap(&x, &y)
MsgBox("VarRef Swap:`nx=" x ", y=" y)

if VarRefEdgeCases.TryParse("42", &parsed)
    MsgBox("Parsed: " parsed)
