#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Operator Overloading - Custom operators for classes
; Demonstrates all overloadable operators in AHK v2

; =============================================================================
; 1. Complete Operator Overloading Example - Complex Numbers
; =============================================================================

class Complex {
    __New(real := 0, imag := 0) {
        this.real := real
        this.imag := imag
    }

    ; Arithmetic operators
    __Add(other) {
        if other is Complex
            return Complex(this.real + other.real, this.imag + other.imag)
        return Complex(this.real + other, this.imag)
    }

    __Sub(other) {
        if other is Complex
            return Complex(this.real - other.real, this.imag - other.imag)
        return Complex(this.real - other, this.imag)
    }

    __Mul(other) {
        if other is Complex {
            ; (a+bi)(c+di) = (ac-bd) + (ad+bc)i
            real := this.real * other.real - this.imag * other.imag
            imag := this.real * other.imag + this.imag * other.real
            return Complex(real, imag)
        }
        return Complex(this.real * other, this.imag * other)
    }

    __Div(other) {
        if other is Complex {
            ; (a+bi)/(c+di) = (ac+bd)/(c²+d²) + (bc-ad)/(c²+d²)i
            denom := other.real ** 2 + other.imag ** 2
            real := (this.real * other.real + this.imag * other.imag) / denom
            imag := (this.imag * other.real - this.real * other.imag) / denom
            return Complex(real, imag)
        }
        return Complex(this.real / other, this.imag / other)
    }

    ; Unary minus
    __Neg() => Complex(-this.real, -this.imag)

    ; Comparison
    __Eq(other) {
        if other is Complex
            return this.real = other.real && this.imag = other.imag
        return this.real = other && this.imag = 0
    }

    ; Magnitude (for comparisons)
    Magnitude => Sqrt(this.real ** 2 + this.imag ** 2)

    ; String representation
    ToString() {
        if this.imag >= 0
            return this.real "+" this.imag "i"
        return this.real this.imag "i"
    }

    ; Conjugate
    Conjugate() => Complex(this.real, -this.imag)
}

; =============================================================================
; 2. Vector with Full Operator Support
; =============================================================================

class Vec3 {
    __New(x := 0, y := 0, z := 0) {
        this.x := x
        this.y := y
        this.z := z
    }

    ; Vector addition
    __Add(other) {
        if other is Vec3
            return Vec3(this.x + other.x, this.y + other.y, this.z + other.z)
        return Vec3(this.x + other, this.y + other, this.z + other)
    }

    ; Vector subtraction
    __Sub(other) {
        if other is Vec3
            return Vec3(this.x - other.x, this.y - other.y, this.z - other.z)
        return Vec3(this.x - other, this.y - other, this.z - other)
    }

    ; Scalar multiplication
    __Mul(scalar) => Vec3(this.x * scalar, this.y * scalar, this.z * scalar)

    ; Scalar division
    __Div(scalar) => Vec3(this.x / scalar, this.y / scalar, this.z / scalar)

    ; Unary minus (negate)
    __Neg() => Vec3(-this.x, -this.y, -this.z)

    ; Equality
    __Eq(other) {
        if other is Vec3
            return this.x = other.x && this.y = other.y && this.z = other.z
        return false
    }

    ; Dot product (using modulo for uniqueness)
    __Mod(other) {
        if other is Vec3
            return this.x * other.x + this.y * other.y + this.z * other.z
        throw TypeError("Dot product requires Vec3")
    }

    ; Cross product (using bitwise XOR for uniqueness)
    __BitXor(other) {
        if other is Vec3 {
            return Vec3(
                this.y * other.z - this.z * other.y,
                this.z * other.x - this.x * other.z,
                this.x * other.y - this.y * other.x
            )
        }
        throw TypeError("Cross product requires Vec3")
    }

    ; Properties
    Length => Sqrt(this.x ** 2 + this.y ** 2 + this.z ** 2)

    Normalized() {
        len := this.Length
        return len > 0 ? this / len : Vec3()
    }

    ToString() => "(" this.x ", " this.y ", " this.z ")"
}

; =============================================================================
; 3. Set with Operator Overloading
; =============================================================================

class MathSet {
    __New(items*) {
        this.items := Map()
        for item in items
            this.items[item] := true
    }

    ; Union (using +)
    __Add(other) {
        result := MathSet()
        for key in this.items
            result.items[key] := true
        if other is MathSet {
            for key in other.items
                result.items[key] := true
        } else {
            result.items[other] := true
        }
        return result
    }

    ; Difference (using -)
    __Sub(other) {
        result := MathSet()
        for key in this.items {
            if other is MathSet {
                if !other.items.Has(key)
                    result.items[key] := true
            } else if key != other {
                result.items[key] := true
            }
        }
        return result
    }

    ; Intersection (using &)
    __BitAnd(other) {
        result := MathSet()
        if other is MathSet {
            for key in this.items
                if other.items.Has(key)
                    result.items[key] := true
        }
        return result
    }

    ; Symmetric difference (using ^)
    __BitXor(other) {
        if other is MathSet
            return (this - other) + (other - this)
        throw TypeError("Symmetric difference requires MathSet")
    }

    ; Contains check (using indexer)
    __Item[key] {
        get => this.items.Has(key)
    }

    Contains(item) => this.items.Has(item)
    Size => this.items.Count

    ToString() {
        items := []
        for key in this.items
            items.Push(String(key))
        return "{" items.Join(", ") "}"
    }
}

; Helper
Array.Prototype.Join := (this, sep := ",") => _ArrayJoinHelper(this, sep)

_ArrayJoinHelper(arr, sep) {
    r := ""
    for i, v in arr
        r .= (i > 1 ? sep : "") v
    return r
}

; =============================================================================
; 4. Expression Building with Operators
; =============================================================================

class Expr {
    ; Factory methods
    static Num(n) => ExprLiteral(n)
    static Var(name) => ExprVariable(name)
}

class ExprLiteral extends Expr {
    __New(value) => this.value := value

    __Add(other) => ExprBinOp(this, "+", other)
    __Sub(other) => ExprBinOp(this, "-", other)
    __Mul(other) => ExprBinOp(this, "*", other)
    __Div(other) => ExprBinOp(this, "/", other)

    Eval(vars := Map()) => this.value
    ToString() => String(this.value)
}

class ExprVariable extends Expr {
    __New(name) => this.name := name

    __Add(other) => ExprBinOp(this, "+", other)
    __Sub(other) => ExprBinOp(this, "-", other)
    __Mul(other) => ExprBinOp(this, "*", other)
    __Div(other) => ExprBinOp(this, "/", other)

    Eval(vars := Map()) => vars.Get(this.name, 0)
    ToString() => this.name
}

class ExprBinOp extends Expr {
    __New(left, op, right) {
        this.left := left is Expr ? left : ExprLiteral(left)
        this.op := op
        this.right := right is Expr ? right : ExprLiteral(right)
    }

    __Add(other) => ExprBinOp(this, "+", other)
    __Sub(other) => ExprBinOp(this, "-", other)
    __Mul(other) => ExprBinOp(this, "*", other)
    __Div(other) => ExprBinOp(this, "/", other)

    Eval(vars := Map()) {
        l := this.left.Eval(vars)
        r := this.right.Eval(vars)
        switch this.op {
            case "+": return l + r
            case "-": return l - r
            case "*": return l * r
            case "/": return l / r
        }
    }

    ToString() => "(" this.left.ToString() " " this.op " " this.right.ToString() ")"
}

; =============================================================================
; 5. Money Class with Currency Handling
; =============================================================================

class Money {
    __New(amount, currency := "USD") {
        this.amount := amount
        this.currency := currency
    }

    __Add(other) {
        if other is Money {
            if this.currency != other.currency
                throw Error("Cannot add different currencies")
            return Money(this.amount + other.amount, this.currency)
        }
        return Money(this.amount + other, this.currency)
    }

    __Sub(other) {
        if other is Money {
            if this.currency != other.currency
                throw Error("Cannot subtract different currencies")
            return Money(this.amount - other.amount, this.currency)
        }
        return Money(this.amount - other, this.currency)
    }

    __Mul(factor) => Money(this.amount * factor, this.currency)
    __Div(factor) => Money(this.amount / factor, this.currency)

    __Eq(other) {
        if other is Money
            return this.amount = other.amount && this.currency = other.currency
        return false
    }

    __Lt(other) {
        if other is Money {
            if this.currency != other.currency
                throw Error("Cannot compare different currencies")
            return this.amount < other.amount
        }
        return this.amount < other
    }

    ToString() => Format("{:.2f} {}", this.amount, this.currency)
}

; =============================================================================
; Demo
; =============================================================================

; Complex numbers
c1 := Complex(3, 4)
c2 := Complex(1, 2)
MsgBox("Complex Numbers:`n`n"
    . "c1 = " c1.ToString() "`n"
    . "c2 = " c2.ToString() "`n"
    . "c1 + c2 = " (c1 + c2).ToString() "`n"
    . "c1 - c2 = " (c1 - c2).ToString() "`n"
    . "c1 * c2 = " (c1 * c2).ToString() "`n"
    . "c1 / c2 = " (c1 / c2).ToString() "`n"
    . "|c1| = " Round(c1.Magnitude, 2))

; Vectors
v1 := Vec3(1, 2, 3)
v2 := Vec3(4, 5, 6)
dot := v1
dotResult := dot.__Mod(v2)
MsgBox("Vector3:`n`n"
    . "v1 = " v1.ToString() "`n"
    . "v2 = " v2.ToString() "`n"
    . "v1 + v2 = " (v1 + v2).ToString() "`n"
    . "v1 - v2 = " (v1 - v2).ToString() "`n"
    . "v1 * 2 = " (v1 * 2).ToString() "`n"
    . "v1 dot v2 = " dotResult "`n"
    . "v1 cross v2 = " (v1 ^ v2).ToString() "`n"
    . "|v1| = " Round(v1.Length, 2))

; Sets
s1 := MathSet(1, 2, 3, 4)
s2 := MathSet(3, 4, 5, 6)
MsgBox("Set Operations:`n`n"
    . "s1 = " s1.ToString() "`n"
    . "s2 = " s2.ToString() "`n"
    . "s1 ∪ s2 = " (s1 + s2).ToString() "`n"
    . "s1 ∩ s2 = " (s1 & s2).ToString() "`n"
    . "s1 - s2 = " (s1 - s2).ToString() "`n"
    . "s1 △ s2 = " (s1 ^ s2).ToString())

; Expression building
x := Expr.Var("x")
y := Expr.Var("y")
exprTree := (x + Expr.Num(5)) * (y - Expr.Num(2))
MsgBox("Expression Tree:`n`n"
    . "Expression: " exprTree.ToString() "`n"
    . "Eval(x=3, y=7): " exprTree.Eval(Map("x", 3, "y", 7)))

; Money
price := Money(99.99, "USD")
tax := price * 0.1
total := price + tax
MsgBox("Money Arithmetic:`n`n"
    . "Price: " price.ToString() "`n"
    . "Tax (10%): " tax.ToString() "`n"
    . "Total: " total.ToString())
