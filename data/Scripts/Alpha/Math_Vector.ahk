#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Vector - N-dimensional vector math
; Demonstrates geometric and algebraic vector operations

class Vector {
    __New(components*) {
        if components.Length = 1 && IsObject(components[1])
            this.components := components[1]
        else
            this.components := components
    }

    static FromArray(arr) => Vector(arr)

    Dimension() => this.components.Length

    Get(i) => this.components[i]
    Set(i, value) => this.components[i] := value

    Add(other) {
        result := []
        for i, v in this.components
            result.Push(v + other.Get(i))
        return Vector(result)
    }

    Subtract(other) {
        result := []
        for i, v in this.components
            result.Push(v - other.Get(i))
        return Vector(result)
    }

    Scale(scalar) {
        result := []
        for v in this.components
            result.Push(v * scalar)
        return Vector(result)
    }

    Dot(other) {
        sum := 0
        for i, v in this.components
            sum += v * other.Get(i)
        return sum
    }

    ; Cross product (3D only)
    Cross(other) {
        if this.Dimension() != 3 || other.Dimension() != 3
            throw Error("Cross product only for 3D vectors")

        return Vector(
            this.Get(2) * other.Get(3) - this.Get(3) * other.Get(2),
            this.Get(3) * other.Get(1) - this.Get(1) * other.Get(3),
            this.Get(1) * other.Get(2) - this.Get(2) * other.Get(1)
        )
    }

    Magnitude() => Sqrt(this.Dot(this))

    Normalize() {
        mag := this.Magnitude()
        return mag > 0 ? this.Scale(1 / mag) : this
    }

    Distance(other) => this.Subtract(other).Magnitude()

    Angle(other) {
        cosTheta := this.Dot(other) / (this.Magnitude() * other.Magnitude())
        return ACos(cosTheta)  ; Returns radians
    }

    Project(other) {
        ; Project this onto other
        return other.Scale(this.Dot(other) / other.Dot(other))
    }

    Reflect(normal) {
        ; Reflect this vector across normal
        return this.Subtract(normal.Scale(2 * this.Dot(normal)))
    }

    Lerp(other, t) {
        ; Linear interpolation
        return this.Add(other.Subtract(this).Scale(t))
    }

    ToArray() => this.components.Clone()

    ToString() {
        result := "("
        for i, v in this.components
            result .= (i > 1 ? ", " : "") Round(v, 3)
        return result ")"
    }
}

; Helper
RadToDeg(rad) => rad * 180 / 3.14159265359

; Demo - Basic operations
v1 := Vector(1, 2, 3)
v2 := Vector(4, 5, 6)

result := "Vector Operations:`n"
result .= "v1 = " v1.ToString() "`n"
result .= "v2 = " v2.ToString() "`n"
result .= "v1 + v2 = " v1.Add(v2).ToString() "`n"
result .= "v1 - v2 = " v1.Subtract(v2).ToString() "`n"
result .= "v1 × 2 = " v1.Scale(2).ToString() "`n"
result .= "v1 · v2 = " v1.Dot(v2) "`n"
result .= "v1 × v2 = " v1.Cross(v2).ToString() "`n"

MsgBox(result)

; Demo - Properties
result := "Vector Properties:`n"
result .= "|v1| = " Round(v1.Magnitude(), 3) "`n"
result .= "v1 normalized = " v1.Normalize().ToString() "`n"
result .= "Distance v1 to v2 = " Round(v1.Distance(v2), 3) "`n"
result .= "Angle between = " Round(RadToDeg(v1.Angle(v2)), 1) "°`n"

MsgBox(result)

; Demo - Interpolation
start := Vector(0, 0)
endpt := Vector(10, 5)

result := "Linear Interpolation:`n"
Loop 5 {
    t := (A_Index - 1) / 4
    point := start.Lerp(endpt, t)
    result .= "t=" Round(t, 2) ": " point.ToString() "`n"
}

MsgBox(result)

; Demo - Reflection
incident := Vector(1, -1)
normal := Vector(0, 1).Normalize()
reflected := incident.Reflect(normal)

MsgBox("Reflection:`n"
    . "Incident: " incident.ToString() "`n"
    . "Normal: " normal.ToString() "`n"
    . "Reflected: " reflected.ToString())
