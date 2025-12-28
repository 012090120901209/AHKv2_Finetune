#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Meta_03_Set.ahk
 * 
 * DESCRIPTION:
 * Demonstrates the __Set meta-function in AutoHotkey v2. __Set is invoked when
 * setting an undefined property, enabling property validation, type coercion,
 * readonly properties, and change tracking.
 * 
 * FEATURES:
 * - __Set meta-function basics
 * - Property validation on assignment
 * - Readonly property enforcement
 * - Property change tracking
 * - Type coercion
 * - Computed setters
 * - Property observers/watchers
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - __Set(name, params, value) signature
 * - Property assignment interception
 * - Value validation before assignment
 * - Preventing property modification
 * - Change notification patterns
 * - Type enforcement
 * 
 * LEARNING POINTS:
 * 1. __Set intercepts property assignments
 * 2. Can validate values before setting
 * 3. Enables readonly properties
 * 4. Can track property changes
 * 5. Allows type coercion
 * 6. Works with dot and bracket notation
 * 7. Can trigger side effects on assignment
 */

; ========================================
; EXAMPLE 1: Basic __Set Usage
; ========================================

class PropertyTracker {
    _data := Map()
    Changes := []

    __Set(name, params, value) {
        ; Track the change
        oldValue := this._data.Has(name) ? this._data[name] : "[not set]"

        this.Changes.Push({
            Property: name,
            OldValue: oldValue,
            NewValue: value,
            Time: A_Now
        })

        ; Set the value
        this._data[name] := value
    }

    __Get(name, params) {
        return this._data.Has(name) ? this._data[name] : ""
    }

    GetChangeLog() {
        log := "=== Property Change Log ===`n`n"

        for index, change in this.Changes {
            log .= index ". " change.Property "`n"
            log .= "   Old: " change.OldValue "`n"
            log .= "   New: " change.NewValue "`n"
            log .= "   Time: " FormatTime(change.Time, "HH:mm:ss") "`n`n"
        }

        return log
    }
}

tracker := PropertyTracker()
tracker.Name := "John"
tracker.Age := 30
tracker.Name := "John Doe"  ; Changed
tracker.City := "New York"

MsgBox(tracker.GetChangeLog())

; ========================================
; EXAMPLE 2: Readonly Properties
; ========================================

class Config {
    _data := Map()
    _readonly := Map()

    __New() {
        ; Mark some properties as readonly
        this._readonly["Version"] := true
        this._readonly["InstallDate"] := true

        ; Set initial readonly values
        this._data["Version"] := "1.0.0"
        this._data["InstallDate"] := A_Now
    }

    __Set(name, params, value) {
        ; Check if readonly
        if (this._readonly.Has(name)) {
            throw Error("Property '" name "' is readonly")
        }

        ; Allow setting
        this._data[name] := value
    }

    __Get(name, params) {
        return this._data.Has(name) ? this._data[name] : ""
    }

    SetReadonly(name) {
        this._readonly[name] := true
    }
}

config := Config()
MsgBox("Version: " config.Version)

config.AppName := "MyApp"  ; OK
MsgBox("AppName: " config.AppName)

try {
    config.Version := "2.0.0"  ; Error: readonly
} catch Error as err {
    MsgBox("Error: " err.Message)
}

; ========================================
; EXAMPLE 3: Type Validation
; ========================================

class TypedObject {
    _data := Map()
    _types := Map()

    SetType(name, expectedType) {
        this._types[name] := expectedType
    }

    __Set(name, params, value) {
        ; Check type if defined
        if (this._types.Has(name)) {
            expectedType := this._types[name]
            actualType := Type(value)

            if (actualType != expectedType) {
                ; Try to coerce
                if (expectedType = "Integer") {
                    if (IsNumber(value))
                        value := Integer(value)
                    else
                        throw TypeError("Cannot convert to Integer")
                }
                else if (expectedType = "String") {
                    value := String(value)
                }
                else {
                    throw TypeError("Expected " expectedType ", got " actualType)
                }
            }
        }

        this._data[name] := value
    }

    __Get(name, params) {
        return this._data.Has(name) ? this._data[name] : ""
    }
}

obj := TypedObject()
obj.SetType("Age", "Integer")
obj.SetType("Name", "String")

obj.Age := "30"  ; Coerced to integer
obj.Name := 123  ; Coerced to string

MsgBox("Age: " obj.Age " (type: " Type(obj.Age) ")")
MsgBox("Name: " obj.Name " (type: " Type(obj.Name) ")")

; ========================================
; EXAMPLE 4: Property Observers
; ========================================

class Observable {
    _data := Map()
    _observers := Map()

    __Set(name, params, value) {
        oldValue := this._data.Has(name) ? this._data[name] : ""
        this._data[name] := value

        ; Notify observers
        if (this._observers.Has(name)) {
            for observer in this._observers[name] {
                observer.Call(name, oldValue, value)
            }
        }
    }

    __Get(name, params) {
        return this._data.Has(name) ? this._data[name] : ""
    }

    Watch(property, callback) {
        if (!this._observers.Has(property))
            this._observers[property] := []

        this._observers[property].Push(callback)
    }
}

model := Observable()

; Add observer
model.Watch("Name", (prop, old, new) => MsgBox("Name changed from '" old "' to '" new "'"))
model.Watch("Age", (prop, old, new) => MsgBox("Age changed from " old " to " new))

; Trigger notifications
model.Name := "Alice"  ; Shows notification
model.Age := 25        ; Shows notification
model.Name := "Bob"    ; Shows notification

; ========================================
; EXAMPLE 5: Range Validation
; ========================================

class RangeValidator {
    _data := Map()
    _ranges := Map()

    SetRange(name, min, max) {
        this._ranges[name] := { Min: min, Max: max }
    }

    __Set(name, params, value) {
        ; Validate range if defined
        if (this._ranges.Has(name)) {
            range := this._ranges[name]

            if (!IsNumber(value))
                throw TypeError("Value must be numeric")

            if (value < range.Min || value > range.Max)
                throw ValueError(name " must be between " range.Min " and " range.Max)
        }

        this._data[name] := value
    }

    __Get(name, params) {
        return this._data.Has(name) ? this._data[name] : ""
    }
}

validator := RangeValidator()
validator.SetRange("Age", 0, 150)
validator.SetRange("Score", 0, 100)

validator.Age := 30  ; OK
MsgBox("Age: " validator.Age)

try {
    validator.Age := 200  ; Error: out of range
} catch ValueError as err {
    MsgBox("Error: " err.Message)
}

validator.Score := 95  ; OK
MsgBox("Score: " validator.Score)

; ========================================
; EXAMPLE 6: Computed Setters
; ========================================

class Temperature {
    _celsius := 0

    __Set(name, params, value) {
        if (name = "Celsius") {
            this._celsius := value
        }
        else if (name = "Fahrenheit") {
            this._celsius := (value - 32) * 5 / 9
        }
        else if (name = "Kelvin") {
            this._celsius := value - 273.15
        }
        else {
            throw Error("Unknown property: " name)
        }
    }

    __Get(name, params) {
        if (name = "Celsius")
            return this._celsius
        if (name = "Fahrenheit")
            return (this._celsius * 9 / 5) + 32
        if (name = "Kelvin")
            return this._celsius + 273.15

        throw Error("Unknown property: " name)
    }
}

temp := Temperature()

temp.Celsius := 25
MsgBox("Set Celsius to 25:`nFahrenheit: " Round(temp.Fahrenheit, 1))

temp.Fahrenheit := 98.6
MsgBox("Set Fahrenheit to 98.6:`nCelsius: " Round(temp.Celsius, 1))

temp.Kelvin := 300
MsgBox("Set Kelvin to 300:`nCelsius: " Round(temp.Celsius, 1))

; ========================================
; EXAMPLE 7: Property Normalization
; ========================================

class User {
    _data := Map()

    __Set(name, params, value) {
        ; Normalize based on property name
        if (name = "Email") {
            value := Trim(StrLower(value))
        }
        else if (name = "Username") {
            value := Trim(value)
            ; Remove invalid characters
            value := RegExReplace(value, "[^a-zA-Z0-9_]", "")
        }
        else if (name = "PhoneNumber") {
            ; Remove all non-digits
            value := RegExReplace(value, "[^0-9]", "")
        }

        this._data[name] := value
    }

    __Get(name, params) {
        return this._data.Has(name) ? this._data[name] : ""
    }
}

user := User()

user.Email := "  JOHN@EXAMPLE.COM  "
MsgBox("Normalized email: " user.Email)

user.Username := "john.doe@123"
MsgBox("Normalized username: " user.Username)

user.PhoneNumber := "(555) 123-4567"
MsgBox("Normalized phone: " user.PhoneNumber)

MsgBox("=== OOP __Set Meta-Function Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic __Set interception`n"
    . "- Readonly properties`n"
    . "- Type validation and coercion`n"
    . "- Property observers`n"
    . "- Range validation`n"
    . "- Computed setters`n"
    . "- Property normalization")
