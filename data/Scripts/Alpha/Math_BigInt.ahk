#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; BigInt - Arbitrary precision integers
; Demonstrates big number arithmetic using string representation

class BigInt {
    __New(value := "0") {
        if value is Integer {
            this.negative := value < 0
            this.digits := Abs(value) = 0 ? "0" : ""
            value := Abs(value)
            while value > 0 {
                this.digits := String(Mod(value, 10)) this.digits
                value := value // 10
            }
            if this.digits = ""
                this.digits := "0"
        } else {
            str := String(value)
            this.negative := SubStr(str, 1, 1) = "-"
            if this.negative
                str := SubStr(str, 2)
            ; Remove leading zeros
            str := RegExReplace(str, "^0+", "")
            this.digits := str = "" ? "0" : str
        }
    }

    static Zero() => BigInt("0")
    static One() => BigInt("1")

    IsZero() => this.digits = "0"
    IsNegative() => this.negative && !this.IsZero()

    Abs() {
        result := BigInt(this.digits)
        result.negative := false
        return result
    }

    Negate() {
        result := BigInt(this.digits)
        result.negative := !this.negative
        return result
    }

    Compare(other) {
        ; Handle signs
        if this.negative && !other.negative
            return -1
        if !this.negative && other.negative
            return 1

        ; Compare magnitudes
        result := this._CompareMagnitude(other)
        return this.negative ? -result : result
    }

    _CompareMagnitude(other) {
        if StrLen(this.digits) != StrLen(other.digits)
            return StrLen(this.digits) > StrLen(other.digits) ? 1 : -1
        return StrCompare(this.digits, other.digits)
    }

    Add(other) {
        ; Handle signs
        if this.negative && !other.negative
            return other.Subtract(this.Abs())
        if !this.negative && other.negative
            return this.Subtract(other.Abs())
        if this.negative && other.negative
            return this._AddMagnitudes(other).Negate()

        return this._AddMagnitudes(other)
    }

    _AddMagnitudes(other) {
        a := this.digits, b := other.digits

        ; Pad to same length
        maxLen := Max(StrLen(a), StrLen(b))
        a := Format("{:0" maxLen "}", a)
        b := Format("{:0" maxLen "}", b)

        result := ""
        carry := 0

        Loop maxLen {
            i := maxLen - A_Index + 1
            sum := Integer(SubStr(a, i, 1)) + Integer(SubStr(b, i, 1)) + carry
            carry := sum >= 10 ? 1 : 0
            result := String(Mod(sum, 10)) result
        }

        if carry
            result := "1" result

        return BigInt(result)
    }

    Subtract(other) {
        if this.negative && !other.negative
            return this.Abs()._AddMagnitudes(other).Negate()
        if !this.negative && other.negative
            return this._AddMagnitudes(other.Abs())
        if this.negative && other.negative
            return other.Abs().Subtract(this.Abs())

        ; Both positive
        cmp := this._CompareMagnitude(other)
        if cmp = 0
            return BigInt.Zero()
        if cmp < 0
            return other._SubtractMagnitudes(this).Negate()

        return this._SubtractMagnitudes(other)
    }

    _SubtractMagnitudes(other) {
        a := this.digits, b := other.digits
        maxLen := StrLen(a)
        b := Format("{:0" maxLen "}", b)

        result := ""
        borrow := 0

        Loop maxLen {
            i := maxLen - A_Index + 1
            diff := Integer(SubStr(a, i, 1)) - Integer(SubStr(b, i, 1)) - borrow

            if diff < 0 {
                diff += 10
                borrow := 1
            } else {
                borrow := 0
            }

            result := String(diff) result
        }

        return BigInt(result)
    }

    Multiply(other) {
        if this.IsZero() || other.IsZero()
            return BigInt.Zero()

        a := this.digits, b := other.digits
        lenA := StrLen(a), lenB := StrLen(b)

        ; Initialize result array
        resultLen := lenA + lenB
        result := []
        Loop resultLen
            result.Push(0)

        ; Grade school multiplication
        Loop lenA {
            i := lenA - A_Index + 1
            digitA := Integer(SubStr(a, i, 1))

            Loop lenB {
                j := lenB - A_Index + 1
                digitB := Integer(SubStr(b, j, 1))
                pos := (lenA - i) + (lenB - j) + 1

                result[pos] += digitA * digitB
            }
        }

        ; Process carries
        Loop resultLen - 1 {
            if result[A_Index] >= 10 {
                result[A_Index + 1] += result[A_Index] // 10
                result[A_Index] := Mod(result[A_Index], 10)
            }
        }

        ; Build string (reverse order)
        str := ""
        Loop resultLen
            str := String(result[A_Index]) str

        resultBig := BigInt(str)
        resultBig.negative := this.negative != other.negative
        return resultBig
    }

    ToString() {
        return (this.negative && !this.IsZero() ? "-" : "") this.digits
    }
}

; Demo - Large numbers
a := BigInt("123456789012345678901234567890")
b := BigInt("987654321098765432109876543210")

result := "Big Integer Arithmetic:`n"
result .= "a = " a.ToString() "`n"
result .= "b = " b.ToString() "`n"
result .= "`na + b = " a.Add(b).ToString() "`n"
result .= "b - a = " b.Subtract(a).ToString() "`n"

MsgBox(result)

; Demo - Multiplication
c := BigInt("12345678901234567890")
d := BigInt("98765432109876543210")

result := "Multiplication:`n"
result .= c.ToString() " × " d.ToString() "`n= " c.Multiply(d).ToString()

MsgBox(result)

; Demo - Factorial
Factorial(n) {
    result := BigInt.One()
    Loop n
        result := result.Multiply(BigInt(A_Index))
    return result
}

result := "Factorials:`n"
for n in [10, 20, 50]
    result .= n "! = " Factorial(n).ToString() "`n`n"

MsgBox(result)
