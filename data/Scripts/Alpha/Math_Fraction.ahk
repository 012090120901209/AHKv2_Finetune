#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Fraction - Rational number arithmetic
; Demonstrates exact fraction math with simplification

class Fraction {
    __New(numerator, denominator := 1) {
        if denominator = 0
            throw Error("Denominator cannot be zero")

        ; Normalize sign (denominator always positive)
        if denominator < 0 {
            numerator := -numerator
            denominator := -denominator
        }

        ; Simplify
        gcd := this.GCD(Abs(numerator), denominator)
        this.num := numerator // gcd
        this.den := denominator // gcd
    }

    GCD(a, b) {
        while b {
            temp := b
            b := Mod(a, b)
            a := temp
        }
        return a
    }

    static FromDecimal(decimal, tolerance := 0.000001) {
        ; Convert decimal to fraction using continued fractions
        if Abs(decimal - Round(decimal)) < tolerance
            return Fraction(Round(decimal), 1)

        isNegative := decimal < 0
        decimal := Abs(decimal)

        h1 := 1, h2 := 0
        k1 := 0, k2 := 1
        b := decimal

        Loop 20 {
            a := Floor(b)
            h3 := a * h1 + h2
            k3 := a * k1 + k2

            if Abs(decimal - h3 / k3) < tolerance
                return Fraction(isNegative ? -h3 : h3, k3)

            h2 := h1, h1 := h3
            k2 := k1, k1 := k3

            remainder := b - a
            if Abs(remainder) < tolerance
                break
            b := 1 / remainder
        }

        return Fraction(isNegative ? -h1 : h1, k1)
    }

    Add(other) => Fraction(
        this.num * other.den + other.num * this.den,
        this.den * other.den
    )

    Subtract(other) => Fraction(
        this.num * other.den - other.num * this.den,
        this.den * other.den
    )

    Multiply(other) => Fraction(
        this.num * other.num,
        this.den * other.den
    )

    Divide(other) {
        if other.num = 0
            throw Error("Cannot divide by zero")
        return Fraction(
            this.num * other.den,
            this.den * other.num
        )
    }

    Reciprocal() {
        if this.num = 0
            throw Error("Cannot take reciprocal of zero")
        return Fraction(this.den, this.num)
    }

    Power(n) {
        if n = 0
            return Fraction(1, 1)
        if n < 0
            return this.Reciprocal().Power(-n)
        return Fraction(this.num ** n, this.den ** n)
    }

    ToDecimal() => this.num / this.den

    Compare(other) {
        diff := this.num * other.den - other.num * this.den
        return diff > 0 ? 1 : (diff < 0 ? -1 : 0)
    }

    Equals(other) => this.num = other.num && this.den = other.den

    ToString() {
        if this.den = 1
            return String(this.num)
        return this.num "/" this.den
    }

    ToMixed() {
        ; Returns mixed number string (e.g., "2 1/3")
        if Abs(this.num) < this.den
            return this.ToString()

        whole := this.num // this.den
        remainder := Abs(Mod(this.num, this.den))

        if remainder = 0
            return String(whole)

        return whole " " remainder "/" this.den
    }
}

; Demo - Basic operations
f1 := Fraction(1, 2)
f2 := Fraction(1, 3)

result := "Fraction Operations:`n"
result .= f1.ToString() " + " f2.ToString() " = " f1.Add(f2).ToString() "`n"
result .= f1.ToString() " - " f2.ToString() " = " f1.Subtract(f2).ToString() "`n"
result .= f1.ToString() " × " f2.ToString() " = " f1.Multiply(f2).ToString() "`n"
result .= f1.ToString() " ÷ " f2.ToString() " = " f1.Divide(f2).ToString() "`n"

MsgBox(result)

; Demo - Auto simplification
f3 := Fraction(6, 8)
f4 := Fraction(15, 25)

result := "Auto Simplification:`n"
result .= "6/8 simplifies to " f3.ToString() "`n"
result .= "15/25 simplifies to " f4.ToString() "`n"

; Demo - Powers
f5 := Fraction(2, 3)
result .= "`nPowers of " f5.ToString() ":`n"
result .= "² = " f5.Power(2).ToString() "`n"
result .= "³ = " f5.Power(3).ToString() "`n"
result .= "⁻¹ = " f5.Power(-1).ToString() "`n"

MsgBox(result)

; Demo - Decimal conversion
decimals := [0.5, 0.333333, 0.25, 0.125, 0.142857, 3.14159]

result := "Decimal to Fraction:`n"
for dec in decimals {
    frac := Fraction.FromDecimal(dec)
    result .= dec " ≈ " frac.ToString() " = " Round(frac.ToDecimal(), 6) "`n"
}

MsgBox(result)

; Demo - Mixed numbers
mixed := [Fraction(7, 3), Fraction(22, 7), Fraction(-5, 2)]

result := "Mixed Numbers:`n"
for frac in mixed
    result .= frac.ToString() " = " frac.ToMixed() "`n"

MsgBox(result)
