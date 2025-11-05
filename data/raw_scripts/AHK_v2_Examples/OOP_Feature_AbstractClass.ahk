#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Feature: Abstract Classes and Interfaces
; Demonstrates: Base classes, interface contracts, polymorphism

class Shape {
    __New(x, y) => (this.x := x, this.y := y)
    Area() => throw Error("Abstract method - must override")
    Perimeter() => throw Error("Abstract method - must override")
    Draw() => MsgBox(this.ToString())
    ToString() => Format("{} at ({}, {}): Area={:.2f}, Perimeter={:.2f}", 
        Type(this), this.x, this.y, this.Area(), this.Perimeter())
}

class Circle extends Shape {
    __New(x, y, radius) => (super.__New(x, y), this.radius := radius)
    Area() => 3.14159 * this.radius ** 2
    Perimeter() => 2 * 3.14159 * this.radius
}

class Rectangle extends Shape {
    __New(x, y, width, height) => (super.__New(x, y), this.width := width, this.height := height)
    Area() => this.width * this.height
    Perimeter() => 2 * (this.width + this.height)
}

class Triangle extends Shape {
    __New(x, y, base, height, sideA, sideB, sideC) => (super.__New(x, y), this.base := base, this.height := height, this.sideA := sideA, this.sideB := sideB, this.sideC := sideC)
    Area() => 0.5 * this.base * this.height
    Perimeter() => this.sideA + this.sideB + this.sideC
}

shapes := [Circle(0, 0, 5), Rectangle(10, 10, 4, 6), Triangle(20, 20, 3, 4, 3, 4, 5)]
for shape in shapes
    shape.Draw()
