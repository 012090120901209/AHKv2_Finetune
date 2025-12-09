#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Factory Pattern - Creates objects without specifying exact class
; Demonstrates polymorphism and encapsulated object creation

class ShapeFactory {
    static Create(type, size) {
        switch type {
            case "circle": return Circle(size)
            case "square": return Square(size)
            default: throw Error("Unknown shape")
        }
    }
}

class Shape {
    __New(size) => this.size := size
    Area() => 0
}

class Circle extends Shape {
    Area() => 3.14159 * this.size ** 2
}

class Square extends Shape {
    Area() => this.size ** 2
}

; Demo
myCircle := ShapeFactory.Create("circle", 5)
mySquare := ShapeFactory.Create("square", 4)
MsgBox("Circle area: " myCircle.Area() "`nSquare area: " mySquare.Area())
