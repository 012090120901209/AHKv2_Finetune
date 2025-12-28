#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Reactive Value / Observable Pattern
; Demonstrates reactive programming with computed values

class Observable {
    __New(initialValue := "") {
        this._value := initialValue
        this._subscribers := []
        this._computedDeps := []
    }

    Get() => this._value

    Set(newValue) {
        if this._value = newValue
            return this

        oldValue := this._value
        this._value := newValue
        this._notify(oldValue, newValue)
        return this
    }

    Subscribe(callback) {
        this._subscribers.Push(callback)

        ; Return unsubscribe function
        return () {
            for i, sub in this._subscribers {
                if sub = callback {
                    this._subscribers.RemoveAt(i)
                    break
                }
            }
        }
    }

    _notify(oldValue, newValue) {
        for callback in this._subscribers
            callback(newValue, oldValue)

        ; Notify computed dependents
        for computed in this._computedDeps
            computed._recompute()
    }

    ; Create computed value
    static Computed(dependencies, computeFn) {
        computed := ComputedObservable(dependencies, computeFn)

        ; Register as dependent
        for dep in dependencies
            dep._computedDeps.Push(computed)

        return computed
    }

    ; Map transformation
    Map(fn) {
        return Observable.Computed([this], () => fn(this.Get()))
    }

    ; Combine multiple observables
    static CombineLatest(observables, combiner) {
        return Observable.Computed(observables, () {
            values := []
            for obs in observables
                values.Push(obs.Get())
            return combiner(values*)
        })
    }
}

class ComputedObservable extends Observable {
    __New(dependencies, computeFn) {
        super.__New()
        this._deps := dependencies
        this._computeFn := computeFn
        this._recompute()
    }

    _recompute() {
        oldValue := this._value
        this._value := this._computeFn()

        if oldValue != this._value
            this._notify(oldValue, this._value)
    }

    ; Computed values are read-only
    Set(value) {
        throw Error("Cannot set computed value")
    }
}

; Reactive Form Field
class ReactiveField extends Observable {
    __New(initialValue := "", validators := "") {
        super.__New(initialValue)
        this.validators := validators ?? []
        this.errors := []
        this.touched := false
    }

    Validate() {
        this.errors := []

        for validator in this.validators {
            error := validator(this._value)
            if error
                this.errors.Push(error)
        }

        return !this.errors.Length
    }

    Touch() {
        this.touched := true
        this.Validate()
        return this
    }

    IsValid() => !this.errors.Length
    HasErrors() => this.errors.Length > 0
}

; Demo - Basic Observable
firstName := Observable("John")
logs := []

; Subscribe to changes
unsubscribe := firstName.Subscribe((newVal, oldVal) {
    logs.Push(Format("Changed: '{}' → '{}'", oldVal, newVal))
})

firstName.Set("Jane")
firstName.Set("Bob")
firstName.Set("Bob")  ; No change, no notification

result := "Observable Demo:`n`n"
for log in logs
    result .= log "`n"

MsgBox(result)

; Demo - Computed values
width := Observable(10)
height := Observable(5)

; Computed area
area := Observable.Computed([width, height], () => width.Get() * height.Get())

; Computed perimeter
perimeter := Observable.Computed([width, height], () => 2 * (width.Get() + height.Get()))

result := "Computed Values Demo:`n`n"
result .= Format("Width: {}, Height: {}`n", width.Get(), height.Get())
result .= Format("Area: {} (computed)`n", area.Get())
result .= Format("Perimeter: {} (computed)`n`n", perimeter.Get())

width.Set(15)
result .= "After width = 15:`n"
result .= Format("Area: {}`n", area.Get())
result .= Format("Perimeter: {}`n", perimeter.Get())

MsgBox(result)

; Demo - Map transformation
temperature := Observable(20)  ; Celsius

fahrenheit := temperature.Map((c) => c * 9 / 5 + 32)

result := "Map Transformation Demo:`n`n"
result .= "Celsius → Fahrenheit`n`n"

temps := [0, 20, 37, 100]
for temp in temps {
    temperature.Set(temp)
    result .= Format("{}°C = {}°F`n", temperature.Get(), fahrenheit.Get())
}

MsgBox(result)

; Demo - CombineLatest
price := Observable(100)
quantity := Observable(2)
taxRate := Observable(0.1)

total := Observable.CombineLatest(
    [price, quantity, taxRate],
    (p, q, t) => p * q * (1 + t)
)

result := "CombineLatest Demo:`n`n"
result .= "Price: $" price.Get() "`n"
result .= "Quantity: " quantity.Get() "`n"
result .= "Tax Rate: " (taxRate.Get() * 100) "%`n"
result .= "Total: $" total.Get() "`n`n"

quantity.Set(5)
result .= "After quantity = 5:`n"
result .= "Total: $" total.Get() "`n`n"

taxRate.Set(0.2)
result .= "After tax = 20%:`n"
result .= "Total: $" total.Get()

MsgBox(result)

; Demo - Reactive Form
; Validators
required := (value) => value = "" ? "Field is required" : ""
minLength := (min) => (value) => StrLen(value) < min ? "Minimum length is " min : ""
email := (value) => !InStr(value, "@") ? "Invalid email" : ""

emailField := ReactiveField("", [required, email])
nameField := ReactiveField("", [required, minLength(2)])

result := "Reactive Form Demo:`n`n"

; Test validation
emailField.Set("invalid")
emailField.Touch()
result .= "Email 'invalid':`n"
result .= "  Valid: " emailField.IsValid() "`n"
result .= "  Errors: " _join(emailField.errors) "`n`n"

emailField.Set("test@example.com")
emailField.Touch()
result .= "Email 'test@example.com':`n"
result .= "  Valid: " emailField.IsValid() "`n`n"

nameField.Set("A")
nameField.Touch()
result .= "Name 'A':`n"
result .= "  Valid: " nameField.IsValid() "`n"
result .= "  Errors: " _join(nameField.errors) "`n`n"

nameField.Set("Alice")
nameField.Touch()
result .= "Name 'Alice':`n"
result .= "  Valid: " nameField.IsValid()

_join(arr, sep := ", ") {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") v
    return result
}

MsgBox(result)
