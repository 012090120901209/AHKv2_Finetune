#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Feature: Operator-like Behavior through Methods
; Demonstrates: Method chaining for arithmetic-like operations

class Vector {
    __New(x, y) => (this.x := x, this.y := y)

    Add(other) => Vector(this.x + other.x, this.y + other.y)
    Sub(other) => Vector(this.x - other.x, this.y - other.y)
    Mul(scalar) => Vector(this.x * scalar, this.y * scalar)
    Dot(other) => this.x * other.x + this.y * other.y
    Length() => Sqrt(this.x ** 2 + this.y ** 2)
    Normalized() => this.Mul(1 / this.Length())

    ToString() => Format("Vector({:.2f}, {:.2f})", this.x, this.y)
    
    ; Fluent arithmetic
    static FromPolar(magnitude, angle) => Vector(magnitude * Cos(angle), magnitude * Sin(angle))
}

class Matrix2x2 {
    __New(a, b, c, d) => (this.a := a, this.b := b, this.c := c, this.d := d)

    Mul(other) => Matrix2x2(
        this.a * other.a + this.b * other.c,
        this.a * other.b + this.b * other.d,
        this.c * other.a + this.d * other.c,
        this.c * other.b + this.d * other.d
    )

    Transform(vec) => Vector(
        this.a * vec.x + this.b * vec.y,
        this.c * vec.x + this.d * vec.y
    )

    static Identity() => Matrix2x2(1, 0, 0, 1)
    static Rotation(angle) => Matrix2x2(Cos(angle), -Sin(angle), Sin(angle), Cos(angle))
}

v1 := Vector(3, 4)
v2 := Vector(1, 2)
v3 := v1.Add(v2).Mul(2)
MsgBox(v1.ToString() " + " v2.ToString() " * 2 = " v3.ToString())
MsgBox("Length: " v3.Length())
