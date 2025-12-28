#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * Mixins and Composition - Multiple Inheritance Workarounds
 * 
 * Demonstrates simulating multiple inheritance through mixins and
 * composition patterns since AHK v2 only supports single inheritance.
 * 
 * Source: AHK_Notes/Concepts/advanced-class-inheritance.md
 */

; Test mixin pattern
product := Product("Widget", 29.99)
product.Log("Product created")
json := product.Serialize()

MsgBox("Mixin Pattern:`n`n"
    . product.GetInfo() "`n`n"
    . "Serialized: " json, , "T5")

; Test composition pattern
app := Application()
app.ProcessA("DataA")
app.ProcessB("DataB")

/**
 * LoggerMixin - Reusable logging functionality
 */
class LoggerMixin {
    /**
     * Log message with timestamp
     */
    static Log(this, message) {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        output := "[" timestamp "] " message
        ToolTip(output)
        SetTimer(() => ToolTip(), -2000)
        return output
    }
}

/**
 * SerializableMixin - Reusable serialization
 */
class SerializableMixin {
    /**
     * Serialize object to JSON-like string
     */
    static Serialize(this) {
        parts := []
        for prop in this.OwnProps() {
            if (prop ~= "^_")  ; Skip private properties
                continue

            value := this.%prop%
            if (IsObject(value))
                continue  ; Skip objects for simplicity

            parts.Push('"' prop '":"' value '"')
        }
        return "{" parts.Join(",") "}"
    }

    /**
     * Join array helper
     */
    static Join(arr, delimiter := ",") {
        result := ""
        for index, value in arr {
            result .= value (index < arr.Length ? delimiter : "")
        }
        return result
    }
}

/**
 * Product - Class using mixins
 */
class Product {
    name := ""
    price := 0

    __New(name, price) {
        this.name := name
        this.price := price

        ; Apply mixins dynamically
        this.ApplyMixin(LoggerMixin)
        this.ApplyMixin(SerializableMixin)
    }

    /**
     * Apply mixin to instance
     */
    ApplyMixin(mixinClass) {
        ; Add mixin methods to this instance
        for prop, value in mixinClass.OwnProps() {
            if (IsFunc(value)) {
                ; Bind method to this instance
                this.DefineProp(prop, {
                    Call: (this, params*) => mixinClass.%prop%(this, params*)
                })
            }
        }
    }

    GetInfo() {
        return "Product: " this.name " - $" this.price
    }
}

/**
 * LibraryA - First library/capability
 */
class LibraryA {
    Process(data) {
        return "LibA processed: " data
    }
}

/**
 * LibraryB - Second library/capability
 */
class LibraryB {
    Process(data) {
        return "LibB processed: " data
    }
}

/**
 * Application - Uses composition to avoid conflicts
 */
class Application {
    _libA := LibraryA()
    _libB := LibraryB()

    /**
     * Delegate to LibraryA
     */
    ProcessA(data) {
        result := this._libA.Process(data)
        MsgBox(result, "Library A", "T2")
        return result
    }

    /**
     * Delegate to LibraryB
     */
    ProcessB(data) {
        result := this._libB.Process(data)
        MsgBox(result, "Library B", "T2")
        return result
    }
}

/*
* Key Concepts:
*
* 1. Multiple Inheritance Problem:
*    AHK v2 only supports single inheritance
*    class Child extends Parent1, Parent2  ; ✗ Not supported
*
* 2. Mixin Pattern:
*    Create mixin as static class
*    Apply methods dynamically to instances
*    Simulates multiple inheritance
*
* 3. Applying Mixins:
*    ApplyMixin(mixinClass) {
    *        for prop, value in mixinClass.OwnProps()
    *            this.DefineProp(prop, {Call: ...})
    *    }
    *
    * 4. Mixin Method Signature:
    *    static Method(this, params*) {
        *        ; 'this' is the target instance
        *    }
        *
        * 5. Composition Pattern:
        *    class App {
            *        _libA := LibraryA()  ; Composition
            *        _libB := LibraryB()
            *
            *        ProcessA(data) => this._libA.Process(data)
            *    }
            *
            * 6. Composition vs Inheritance:
            *    Inheritance: "is-a" relationship
            *    Composition: "has-a" relationship
            *    Composition more flexible
            *
            * 7. Benefits of Mixins:
            *    ✅ Reusable functionality
            *    ✅ No inheritance conflicts
            *    ✅ Applied to any class
            *    ✅ Multiple mixins possible
            *
            * 8. Benefits of Composition:
            *    ✅ Avoids name conflicts
            *    ✅ Clear delegation
            *    ✅ Easy to swap implementations
            *    ✅ Better encapsulation
            *
            * 9. When to Use Each:
            *    Mixins: Shared utility methods
            *    Composition: Distinct capabilities
            *    Inheritance: True "is-a" relationship
            *
            * 10. Common Mixins:
            *     LoggerMixin - Logging
            *     SerializableMixin - JSON conversion
            *     ValidatableMixin - Validation
            *     ObservableMixin - Change tracking
            *
            * 11. Design Principle:
            *     "Favor composition over inheritance"
            *     More maintainable
            *     More flexible
*/

