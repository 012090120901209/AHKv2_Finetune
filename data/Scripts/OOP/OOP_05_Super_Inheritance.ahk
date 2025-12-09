#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Super Operator - Calling Parent Methods
*
* Demonstrates using super to access parent class implementations
* in overridden methods and properties.
*
* Source: AHK_Notes/Concepts/super-operator.md
*/

; Create instances
dog := Dog("Buddy")
dog.Speak()

calc := AdvancedCalculator()
result := calc.Calculate(10, 5, "+")

car := Car()
car.Speed := 100
MsgBox("Set speed to 100: Actual = " car.Speed)

car.Speed := 200
MsgBox("Set speed to 200: Actual = " car.Speed " (capped at max)")

/**
* Animal - Base Class
*/
class Animal {
    name := ""

    __New(name) {
        this.name := name
    }

    Speak() {
        MsgBox("Animal " this.name " makes a sound", , "T3")
    }
}

/**
* Dog - Derived Class using super
*/
class Dog extends Animal {
    /**
    * Override Speak but call parent implementation first
    */
    Speak() {
        super.Speak()  ; Call parent method
        MsgBox(this.name " barks: Woof! Woof!", , "T3")
    }
}

/**
* Calculator - Base Class
*/
class Calculator {
    static Calculate(a, b, op) {
        switch op {
            case "+": return a + b
            case "-": return a - b
            case "*": return a * b
            case "/": return a / b
            default: throw ValueError("Invalid operator")
        }
    }
}

/**
* AdvancedCalculator - Adds logging to parent
*/
class AdvancedCalculator extends Calculator {
    static Calculate(a, b, op) {
        result := super.Calculate(a, b, op)  ; Call parent
        MsgBox("Calculation: " a " " op " " b " = " result, , "T3")
        return result
    }
}

/**
* Vehicle - Base Class with property
*/
class Vehicle {
    _speed := 0

    Speed {
        get => this._speed
        set => this._speed := value
    }
}

/**
* Car - Constrains speed using super
*/
class Car extends Vehicle {
    maxSpeed := 120

    Speed {
        get => super.Speed  ; Use parent getter

        set {
            if (value > this.maxSpeed) {
                super.Speed := this.maxSpeed  ; Use parent setter
            } else {
                super.Speed := value
            }
        }
    }
}

/*
* Key Concepts:
*
* 1. super Keyword:
*    super.MethodName()  ; Call parent method
*    super.PropertyName  ; Access parent property
*    Only works within class methods
*
* 2. Method Override + super:
*    Speak() {
    *        super.Speak()  ; Execute parent logic
    *        ; Add child-specific behavior
    *    }
    *
    * 3. Constructor Chaining:
    *    __New(params) {
        *        super.__New(params)  ; Initialize parent first
        *        ; Initialize child properties
        *    }
        *
        * 4. Property Access:
        *    set {
            *        super.Speed := value  ; Use parent setter
            *    }
            *
            * 5. Static Methods:
            *    Works with static methods too
            *    super.Calculate() from static context
            *
            * 6. Benefits:
            *    ✅ Code reuse
            *    ✅ Extend behavior without duplication
            *    ✅ Maintain parent functionality
            *    ✅ Clear inheritance chain
            */
