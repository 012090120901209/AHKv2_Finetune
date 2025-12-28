#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Point and Rectangle - Geometry value objects
; Demonstrates 2D math operations and spatial queries

class Point {
    __New(x := 0, y := 0) {
        this.x := x
        this.y := y
    }

    Add(other) => Point(this.x + other.x, this.y + other.y)
    Subtract(other) => Point(this.x - other.x, this.y - other.y)
    Scale(factor) => Point(this.x * factor, this.y * factor)

    Distance(other) => Sqrt((this.x - other.x) ** 2 + (this.y - other.y) ** 2)

    Magnitude() => Sqrt(this.x ** 2 + this.y ** 2)

    Normalize() {
        mag := this.Magnitude()
        return mag > 0 ? this.Scale(1 / mag) : Point()
    }

    Dot(other) => this.x * other.x + this.y * other.y

    Rotate(angle, origin := "") {
        if !origin
            origin := Point(0, 0)

        translated := this.Subtract(origin)
        cos := Cos(angle)
        sin := Sin(angle)

        rotated := Point(
            translated.x * cos - translated.y * sin,
            translated.x * sin + translated.y * cos
        )

        return rotated.Add(origin)
    }

    ToString() => "(" Round(this.x, 2) ", " Round(this.y, 2) ")"
}

class Rectangle {
    __New(x, y, width, height) {
        this.x := x
        this.y := y
        this.width := width
        this.height := height
    }

    Left => this.x
    Right => this.x + this.width
    Top => this.y
    Bottom => this.y + this.height

    Center => Point(this.x + this.width / 2, this.y + this.height / 2)
    Area => this.width * this.height
    Perimeter => 2 * (this.width + this.height)

    Contains(point) {
        return point.x >= this.Left && point.x <= this.Right
            && point.y >= this.Top && point.y <= this.Bottom
    }

    Intersects(other) {
        return this.Left < other.Right && this.Right > other.Left
            && this.Top < other.Bottom && this.Bottom > other.Top
    }

    Intersection(other) {
        if !this.Intersects(other)
            return ""

        return Rectangle(
            Max(this.Left, other.Left),
            Max(this.Top, other.Top),
            Min(this.Right, other.Right) - Max(this.Left, other.Left),
            Min(this.Bottom, other.Bottom) - Max(this.Top, other.Top)
        )
    }

    Union(other) {
        return Rectangle(
            Min(this.Left, other.Left),
            Min(this.Top, other.Top),
            Max(this.Right, other.Right) - Min(this.Left, other.Left),
            Max(this.Bottom, other.Bottom) - Min(this.Top, other.Top)
        )
    }

    ToString() => Format("Rect({}, {}, {}x{})", this.x, this.y, this.width, this.height)
}

; Demo
p1 := Point(3, 4)
p2 := Point(6, 8)

MsgBox("Point Operations:`n"
    . "P1: " p1.ToString() "`n"
    . "P2: " p2.ToString() "`n"
    . "Distance: " Round(p1.Distance(p2), 2) "`n"
    . "P1 Magnitude: " p1.Magnitude() "`n"
    . "P1 + P2: " p1.Add(p2).ToString())

rect1 := Rectangle(0, 0, 100, 80)
rect2 := Rectangle(50, 40, 100, 80)

MsgBox("Rectangle Operations:`n"
    . "Rect1: " rect1.ToString() "`n"
    . "Rect2: " rect2.ToString() "`n"
    . "Intersects: " rect1.Intersects(rect2) "`n"
    . "Intersection: " rect1.Intersection(rect2).ToString() "`n"
    . "Union: " rect1.Union(rect2).ToString())
