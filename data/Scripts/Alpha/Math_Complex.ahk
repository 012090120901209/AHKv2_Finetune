#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Complex Numbers - Complex arithmetic
; Demonstrates imaginary number operations

class Complex {
    __New(real, imag := 0) {
        this.real := real
        this.imag := imag
    }

    static FromPolar(magnitude, angle) {
        return Complex(magnitude * Cos(angle), magnitude * Sin(angle))
    }

    Add(other) => Complex(this.real + other.real, this.imag + other.imag)

    Subtract(other) => Complex(this.real - other.real, this.imag - other.imag)

    Multiply(other) {
        if IsNumber(other)
            return Complex(this.real * other, this.imag * other)
        ; (a + bi)(c + di) = (ac - bd) + (ad + bc)i
        return Complex(
            this.real * other.real - this.imag * other.imag,
            this.real * other.imag + this.imag * other.real
        )
    }

    Divide(other) {
        if IsNumber(other)
            return Complex(this.real / other, this.imag / other)
        ; (a + bi)/(c + di) = ((ac + bd) + (bc - ad)i) / (c² + d²)
        denom := other.real ** 2 + other.imag ** 2
        return Complex(
            (this.real * other.real + this.imag * other.imag) / denom,
            (this.imag * other.real - this.real * other.imag) / denom
        )
    }

    Conjugate() => Complex(this.real, -this.imag)

    Magnitude() => Sqrt(this.real ** 2 + this.imag ** 2)

    Phase() => ATan2(this.imag, this.real)

    Power(n) {
        ; De Moivre's formula
        mag := this.Magnitude() ** n
        angle := this.Phase() * n
        return Complex.FromPolar(mag, angle)
    }

    Sqrt() => this.Power(0.5)

    Exp() {
        ; e^(a+bi) = e^a * (cos(b) + i*sin(b))
        ea := Exp(this.real)
        return Complex(ea * Cos(this.imag), ea * Sin(this.imag))
    }

    Equals(other, epsilon := 0.000001) {
        return Abs(this.real - other.real) < epsilon
            && Abs(this.imag - other.imag) < epsilon
    }

    ToString() {
        if this.imag = 0
            return String(Round(this.real, 4))
        if this.real = 0
            return Round(this.imag, 4) "i"
        sign := this.imag >= 0 ? "+" : "-"
        return Round(this.real, 4) " " sign " " Abs(Round(this.imag, 4)) "i"
    }
}

; ATan2 implementation
ATan2(y, x) {
    if x > 0
        return ATan(y / x)
    if x < 0 && y >= 0
        return ATan(y / x) + 3.14159265359
    if x < 0 && y < 0
        return ATan(y / x) - 3.14159265359
    if x = 0 && y > 0
        return 3.14159265359 / 2
    if x = 0 && y < 0
        return -3.14159265359 / 2
    return 0
}

; Demo - Basic operations
z1 := Complex(3, 4)
z2 := Complex(1, 2)

result := "Complex Operations:`n"
result .= "z1 = " z1.ToString() "`n"
result .= "z2 = " z2.ToString() "`n"
result .= "z1 + z2 = " z1.Add(z2).ToString() "`n"
result .= "z1 - z2 = " z1.Subtract(z2).ToString() "`n"
result .= "z1 × z2 = " z1.Multiply(z2).ToString() "`n"
result .= "z1 ÷ z2 = " z1.Divide(z2).ToString() "`n"

MsgBox(result)

; Demo - Properties
result := "Complex Properties:`n"
result .= "z1 = " z1.ToString() "`n"
result .= "|z1| = " Round(z1.Magnitude(), 4) "`n"
result .= "Phase(z1) = " Round(z1.Phase() * 180 / 3.14159, 2) "°`n"
result .= "Conjugate = " z1.Conjugate().ToString() "`n"
result .= "z1² = " z1.Power(2).ToString() "`n"
result .= "√z1 = " z1.Sqrt().ToString() "`n"

MsgBox(result)

; Demo - Polar form
z3 := Complex.FromPolar(5, 3.14159265359 / 4)  ; 45°

result := "Polar Form:`n"
result .= "FromPolar(5, 45°) = " z3.ToString() "`n"
result .= "Magnitude = " Round(z3.Magnitude(), 4) "`n"
result .= "Phase = " Round(z3.Phase() * 180 / 3.14159, 2) "°`n"

; Euler's identity: e^(iπ) + 1 = 0
eiPi := Complex(0, 3.14159265359).Exp()
result .= "`nEuler's Identity:`n"
result .= "e^(iπ) = " eiPi.ToString() "`n"
result .= "e^(iπ) + 1 ≈ " eiPi.Add(Complex(1, 0)).ToString()

MsgBox(result)
