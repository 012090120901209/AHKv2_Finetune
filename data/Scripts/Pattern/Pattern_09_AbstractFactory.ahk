#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Abstract Base Class with Factory Pattern
 * 
 * Demonstrates abstract base classes and factory pattern for creating
 * polymorphic shape objects with specialized implementations.
 * 
 * Source: AHK_Notes/Patterns/inheritance-design-patterns.md
 */

; Factory creates shapes based on type parameter
shapes := [
    ShapeFactory.Create("circle", 5),
    ShapeFactory.Create("rectangle", 4, 6),
    ShapeFactory.Create("triangle", 3, 4, 5)
]

result := "Shape Areas:`n`n"
for shape in shapes {
    result .= shape.GetInfo() "`n"
}
MsgBox(result, , "T5")

/**
 * ShapeFactory - Centralized Object Creation
 */
class ShapeFactory {
    /**
     * Create shape instance based on type
     * @param {string} type - Shape type (circle, rectangle, triangle)
     * @param {number} params* - Dimensions for the shape
     * @return {Shape} Shape instance
     */
    static Create(type, params*) {
        switch type, 0 {
            case "circle":
                return Circle(params[1])
            case "rectangle":
                return Rectangle(params[1], params[2])
            case "triangle":
                return Triangle(params[1], params[2], params[3])
            default:
                throw ValueError("Unknown shape type: " type)
        }
    }
}

/**
 * Shape - Abstract Base Class
 * Defines interface that all shapes must implement
 */
class Shape {
    type := ""

    /**
     * Calculate area (must override in subclass)
     */
    Area() {
        throw Error("Subclass must implement Area() method")
    }

    /**
     * Get shape information
     */
    GetInfo() {
        return this.type ": Area = " Round(this.Area(), 2)
    }
}

/**
 * Circle - Concrete Shape Implementation
 */
class Circle extends Shape {
    radius := 0

    __New(radius) {
        super.__New()  ; Initialize parent class
        this.type := "Circle"
        this.radius := radius
    }

    /**
     * Override Area calculation
     */
    Area() {
        return 3.14159 * this.radius ** 2
    }
}

/**
 * Rectangle - Concrete Shape Implementation
 */
class Rectangle extends Shape {
    width := 0
    height := 0

    __New(width, height) {
        super.__New()
        this.type := "Rectangle"
        this.width := width
        this.height := height
    }

    Area() {
        return this.width * this.height
    }
}

/**
 * Triangle - Concrete Shape Implementation
 */
class Triangle extends Shape {
    a := 0
    b := 0
    c := 0

    __New(a, b, c) {
        super.__New()
        this.type := "Triangle"
        this.a := a
        this.b := b
        this.c := c
    }

    Area() {
        ; Heron's formula
        s := (this.a + this.b + this.c) / 2
        return Sqrt(s * (s - this.a) * (s - this.b) * (s - this.c))
    }
}

/*
* Key Concepts:
*
* 1. Abstract Base Class:
*    - Shape.Area() throws error
*    - Forces subclasses to implement
*    - Defines interface contract
*
* 2. Factory Pattern:
*    - Centralized object creation
*    - Type-based instantiation
*    - Hides complexity from client
*
* 3. Constructor Chaining:
*    super.__New()  ; Initialize parent first
*    Then initialize child properties
*
* 4. Polymorphism:
*    shape.Area()  ; Different implementation per type
*    Same interface, different behavior
*
* 5. Benefits:
*    ✅ Type-safe object creation
*    ✅ Easy to add new shapes
*    ✅ Consistent interface
*    ✅ Maintainable code
*/

