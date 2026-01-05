#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Type Coercion - Unusual type conversions and implicit behaviors
; Demonstrates AHK v2's type system quirks and coercion rules

; =============================================================================
; 1. Truthiness Rules
; =============================================================================

class Truthiness {
    ; AHK's truthiness is different from most languages
    static Demonstrate() {
        results := Map()

        ; Numbers
        results["0"] := !!0           ; false
        results["1"] := !!1           ; true
        results["-1"] := !!-1         ; true
        results["0.0"] := !!0.0       ; false
        results["0.1"] := !!0.1       ; true

        ; Strings
        results['""'] := !!""         ; false
        results['"0"'] := !!"0"       ; false (string "0" is falsy!)
        results['"1"'] := !!"1"       ; true
        results['"false"'] := !!"false"  ; true (non-empty, non-zero string)
        results['" "'] := !!" "       ; true (non-empty)

        ; Objects
        results["{}"] := !! {}         ; true
        results["[]"] := !![]         ; true
        results["Map()"] := !!Map()   ; true

        return results
    }

    ; The "0" string gotcha
    static ZeroStringGotcha() {
        value := "0"

        ; This is FALSE because "0" is falsy
        if value
            return "truthy"
        else
            return "falsy"  ; This executes!
    }
}

; =============================================================================
; 2. Numeric String Coercion
; =============================================================================

class NumericCoercion {
    static Demonstrate() {
        results := []

        ; Automatic numeric conversion
        results.Push("'5' + 3 = " ("5" + 3))      ; 8 (string to number)
        results.Push("'5' . 3 = " ("5" . 3))      ; "53" (concatenation)
        results.Push("'5' 3 = " ("5" 3))          ; "53" (space concat)

        ; Comparison coercion
        results.Push("'10' > 9 = " ("10" > 9))    ; true (numeric comparison)
        results.Push("'10' > '9' = " ("10" > "9")) ; false (string comparison!)

        ; Leading zeros
        results.Push("'007' + 0 = " ("007" + 0))  ; 7
        results.Push("'0x10' + 0 = " ("0x10" + 0)) ; 16 (hex)

        ; Scientific notation
        results.Push("'1e3' + 0 = " ("1e3" + 0))  ; 1000

        ; Partial numeric strings
        results.Push("'42abc' + 0 = " ("42abc" + 0)) ; Error or 42 depending on context

        return results
    }

    ; Safe numeric conversion
    static SafeToNumber(value, default := 0) {
        if IsNumber(value)
            return value + 0

        if value is String {
            if RegExMatch(value, "^-?\d+\.?\d*$")
                return value + 0
        }

        return default
    }
}

; =============================================================================
; 3. Object to Primitive Coercion
; =============================================================================

class ObjectCoercion {
    value := 0

    __New(v) => this.value := v

    ; Called when object used as number
    __Number() => this.value

    ; Called when object used as string
    ToString() => "ObjectCoercion(" this.value ")"

    ; Demonstrate coercion
    static Demo() {
        obj := ObjectCoercion(42)

        results := []

        ; Numeric context - calls __Number (if defined) or errors
        ; results.Push("obj + 1 = " (obj + 1))  ; Would need __Number

        ; String context
        results.Push("String: " obj.ToString())

        ; Comparison
        results.Push("obj.value = 42: " (obj.value = 42))

        return results
    }
}

; =============================================================================
; 4. Array/Map Coercion Tricks
; =============================================================================

class CollectionCoercion {
    ; Arrays as variadic arguments
    static ArraySpread() {
        arr := [1, 2, 3]
        return Max(arr*)  ; Spread array as arguments -> 3
    }

    ; Map initialization quirks
    static MapQuirks() {
        ; Standard initialization
        m1 := Map("a", 1, "b", 2)

        ; From array of pairs (manual)
        pairs := [["c", 3], ["d", 4]]
        m2 := Map()
        for pair in pairs
            m2[pair[1]] := pair[2]

        ; Key coercion - all keys become strings for comparison
        m3 := Map()
        m3[1] := "number one"
        m3["1"] := "string one"  ; Different key!

        return Map(
            "m1.count", m1.Count,
            "m2.count", m2.Count,
            "m3.count", m3.Count,  ; 2 - separate keys
            "m3[1]", m3[1],
            "m3['1']", m3["1"]
        )
    }
}

; =============================================================================
; 5. Boolean Context Surprises
; =============================================================================

class BooleanSurprises {
    static Demo() {
        results := []

        ; Empty vs zero
        results.Push("'' = 0: " ("" = 0))       ; true (empty string equals zero!)
        results.Push("'' == 0: " ("" == 0))     ; false (case-sensitive, still type differs)
        results.Push("'' = '0': " ("" = "0"))   ; false (different strings)

        ; Logical operators return values, not booleans
        results.Push("5 && 3: " (5 && 3))       ; 3 (last truthy value)
        results.Push("5 || 3: " (5 || 3))       ; 5 (first truthy value)
        results.Push("0 || 3: " (0 || 3))       ; 3 (first truthy)
        results.Push("0 && 3: " (0 && 3))       ; 0 (first falsy)

        ; Useful pattern: default values
        name := ""
        displayName := name || "Anonymous"      ; "Anonymous"
        results.Push("Default: " displayName)

        return results
    }
}

; =============================================================================
; 6. Assignment Expression Returns
; =============================================================================

class AssignmentReturns {
    static Demo() {
        results := []

        ; Assignment returns the assigned value
        results.Push("(x := 5): " (x := 5))  ; 5

        ; Chained assignment
        a := b := c := 10
        results.Push("a=b=c=10: a=" a ", b=" b ", c=" c)

        ; Assignment in condition
        if (found := InStr("hello", "ll"))
            results.Push("Found at: " found)

        ; Assignment in ternary
        result := (n := 5) > 3 ? "big" : "small"
        results.Push("Ternary with assign: " result ", n=" n)

        ; Compound assignment returns
        x := 5
        results.Push("(x += 3): " (x += 3))  ; 8

        return results
    }
}

; =============================================================================
; 7. Function Reference Coercion
; =============================================================================

class FuncCoercion {
    ; Functions are objects
    static Demo() {
        results := []

        ; Function as value
        fn := MsgBox
        results.Push("fn is Func: " (fn is Func))

        ; Bound function
        add := (a, b) => a + b
        add5 := add.Bind(5)
        results.Push("Bound func: " add5(3))  ; 8

        ; Method extraction
        obj := { value: 10, getValue: (this) => this.value }
        method := obj.getValue
        ; results.Push("Extracted: " method.Call(obj))  ; Need explicit Call

        ; Callable objects
        callable := { Call: (this, x) => x * 2 }
        results.Push("Callable: " callable(5))  ; 10
        results.Push("callable has Call: " HasMethod(callable))

        return results
    }
}

; =============================================================================
; 8. Unset vs Empty vs Zero
; =============================================================================

class UnsetVsEmpty {
    static Demo() {
        results := []

        ; Truly unset
        ; x is unset here

        ; Optional parameter
        TestFunc(param := unset) {
            if IsSet(param)
                return "Set: " param
            return "Unset"
        }

        results.Push("No arg: " TestFunc())
        results.Push("With arg: " TestFunc("hello"))
        results.Push("Empty string: " TestFunc(""))
        results.Push("Zero: " TestFunc(0))

        ; All are "set" even if falsy!

        return results
    }
}

; =============================================================================
; Demo
; =============================================================================

; Truthiness
truth := Truthiness.Demonstrate()
output := "Truthiness Rules:`n`n"
for k, v in truth
    output .= k ": " (v ? "true" : "false") "`n"
output .= "`n'0' gotcha: " Truthiness.ZeroStringGotcha()
MsgBox(output)

; Numeric coercion
coerce := NumericCoercion.Demonstrate()
output := "Numeric Coercion:`n`n"
for item in coerce
    output .= item "`n"
MsgBox(output)

; Boolean surprises
bools := BooleanSurprises.Demo()
output := "Boolean Surprises:`n`n"
for item in bools
    output .= item "`n"
MsgBox(output)

; Assignment returns
assigns := AssignmentReturns.Demo()
output := "Assignment Returns:`n`n"
for item in assigns
    output .= item "`n"
MsgBox(output)

; Collection coercion
mapInfo := CollectionCoercion.MapQuirks()
output := "Map Key Coercion:`n`n"
for k, v in mapInfo
    output .= k ": " v "`n"
MsgBox(output)
