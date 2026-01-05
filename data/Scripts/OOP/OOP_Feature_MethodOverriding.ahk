#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Feature: Method Overriding and Polymorphism
; Demonstrates: Virtual methods, polymorphic behavior, dynamic dispatch

class Animal {
    __New(name) => (this.name := name)

    Speak() => MsgBox(this.name " makes a sound")
    Move() => MsgBox(this.name " moves")
    Describe() => Format("{1} is a {2}", this.name, Type(this))
}

class Dog extends Animal {
    __New(name, breed) => (super.__New(name), this.breed := breed)

    Speak() => MsgBox(this.name " says: Woof! Woof!")
    Move() => MsgBox(this.name " runs on four legs")
    Fetch() => MsgBox(this.name " fetches the ball")
    Describe() => super.Describe() " (" this.breed ")"
}

class Cat extends Animal {
    __New(name, indoor := true) => (super.__New(name), this.indoor := indoor)

    Speak() => MsgBox(this.name " says: Meow!")
    Move() => MsgBox(this.name " prowls silently")
    Scratch() => MsgBox(this.name " scratches the furniture")
    Describe() => super.Describe() " (" (this.indoor ? "Indoor" : "Outdoor") ")"
}

class Bird extends Animal {
    __New(name, canFly := true) => (super.__New(name), this.canFly := canFly)

    Speak() => MsgBox(this.name " says: Tweet! Tweet!")
    Move() => MsgBox(this.name (this.canFly ? " flies through the air" : " hops on the ground"))
    Sing() => MsgBox(this.name " sings a beautiful melody")
    Describe() => super.Describe() " (" (this.canFly ? "Flying" : "Flightless") ")"
}

class Shape {
    Draw() => throw Error("Abstract method - override in subclass")
    Area() => throw Error("Abstract method - override in subclass")
}

class Circle extends Shape {
    __New(radius) => this.radius := radius
    Draw() => MsgBox("Drawing a circle with radius " this.radius)
    Area() => 3.14159 * this.radius ** 2
}

class Square extends Shape {
    __New(side) => this.side := side
    Draw() => MsgBox("Drawing a square with side " this.side)
    Area() => this.side ** 2
}

; Polymorphic function - works with any Animal
ProcessAnimal(animal) {
    MsgBox("Processing: " animalobj .Describe())
    animalobj .Speak()
    animalobj .Move()
}

; Polymorphic array processing
ProcessShapes(shapes) {
    totalArea := 0
    for shape in shapes {
        shape.Draw()
        totalArea += shape.Area()
    }
    MsgBox(Format("Total area of all shapes: {:.2f}", totalArea))
}

; Demonstrate polymorphism
animals := [
    Dog("Buddy", "Golden Retriever"),
    Cat("Whiskers", true),
    Bird("Tweety", true),
    Bird("Penguin", false)
]

for animalItem in  animals
    ProcessAnimal(animal)

; Dog-specific method
animals[1].Fetch()

; Cat-specific method
animals[2].Scratch()

; Bird-specific method
animals[3].Sing()

; Demonstrate shape polymorphism
shapes := [Circle(5), Square(4), Circle(3)]
ProcessShapes(shapes)
