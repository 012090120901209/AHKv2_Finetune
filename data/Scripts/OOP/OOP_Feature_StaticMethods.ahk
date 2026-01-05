#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Static Methods and Properties
; Demonstrates: Class-level members, factory methods, utility methods

class MathUtils {
    static PI := 3.14159265359
    static E := 2.71828182846

    static Square(x) => x * x
    static Cube(x) => x * x * x
    static Power(base, exp) => base ** exp

    static Circle {
        static Area(r) => MathUtils.PI * MathUtils.Square(r)
        static Circumference(r) => 2 * MathUtils.PI * r
    }

    static Factorial(n) => n <= 1 ? 1 : n * MathUtils.Factorial(n - 1)
}

class Color {
    static instanceCount := 0

    __New(r, g, b) => (this.r := r, this.g := g, this.b := b, Color.instanceCount++)

    static Red() => Color(255, 0, 0)
    static Green() => Color(0, 255, 0)
    static Blue() => Color(0, 0, 255)
    static Random() => Color(Random(0, 255), Random(0, 255), Random(0, 255))

    ToHex() => Format("#{:02X}{:02X}{:02X}", this.r, this.g, this.b)
}

MsgBox("Circle area (r=5): " MathUtils.Circle.Area(5))
MsgBox("Factorial(5): " MathUtils.Factorial(5))

red := Color.Red()
random := Color.Random()
MsgBox("Red: " red.ToHex() "`nRandom: " random.ToHex() "`nTotal colors: " Color.instanceCount)
