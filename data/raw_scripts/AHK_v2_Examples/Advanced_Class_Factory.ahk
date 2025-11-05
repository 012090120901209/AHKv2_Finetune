#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Factory Pattern for Creating Objects
class Shape {
    Draw() {
        throw Error("Must implement Draw()")
    }
}

class Circle extends Shape {
    __New(radius) {
        this.radius := radius
    }
    
    Draw() {
        return "Drawing circle with radius " this.radius
    }
    
    Area() {
        return 3.14159 * this.radius ** 2
    }
}

class Rectangle extends Shape {
    __New(width, height) {
        this.width := width
        this.height := height
    }
    
    Draw() {
        return "Drawing rectangle " this.width "x" this.height
    }
    
    Area() {
        return this.width * this.height
    }
}

class ShapeFactory {
    static Create(type, params*) {
        Switch type {
            case "circle":
                return Circle(params*)
            case "rectangle":
                return Rectangle(params*)
            default:
                throw Error("Unknown shape type: " type)
        }
    }
}

; Demo
circle := ShapeFactory.Create("circle", 5)
rect := ShapeFactory.Create("rectangle", 10, 20)

MsgBox(circle.Draw() "`nArea: " Round(circle.Area(), 2))
MsgBox(rect.Draw() "`nArea: " rect.Area())
