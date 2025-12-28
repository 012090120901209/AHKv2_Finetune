#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Reactive Properties - Observable values with automatic updates
; Demonstrates data binding and computed properties

class Reactive {
    __New(value) {
        this._value := value
        this.subscribers := []
    }

    Value {
        get => this._value
        set {
            old := this._value
            if old = value
                return
            this._value := value
            for sub in this.subscribers
                sub(value, old)
        }
    }

    Subscribe(callback) {
        this.subscribers.Push(callback)
        ; Return unsubscribe function
        return () => this.Unsubscribe(callback)
    }

    Unsubscribe(callback) {
        for i, sub in this.subscribers {
            if sub = callback {
                this.subscribers.RemoveAt(i)
                return
            }
        }
    }
}

class Computed {
    __New(dependencies, compute) {
        this.compute := compute
        this._value := compute()

        ; Subscribe to all dependencies
        for dep in dependencies
            dep.Subscribe((*) => this._value := this.compute())
    }

    Value => this._value
}

; Two-way binding helper
class Binding {
    __New(source, target) {
        this.updating := false

        source.Subscribe((val, *) {
            if this.updating
                return
            this.updating := true
            target.Value := val
            this.updating := false
        })

        target.Subscribe((val, *) {
            if this.updating
                return
            this.updating := true
            source.Value := val
            this.updating := false
        })
    }
}

; Demo
firstName := Reactive("John")
lastName := Reactive("Doe")

; Computed property - automatically updates
fullName := Computed([firstName, lastName], () => firstName.Value " " lastName.Value)

; Subscribe to changes
firstName.Subscribe((newVal, oldVal) =>
    OutputDebug("firstName changed: " oldVal " -> " newVal "`n"))

lastName.Subscribe((newVal, oldVal) =>
    OutputDebug("lastName changed: " oldVal " -> " newVal "`n"))

MsgBox("Initial: " fullName.Value)

firstName.Value := "Jane"
MsgBox("After firstName change: " fullName.Value)

lastName.Value := "Smith"
MsgBox("After lastName change: " fullName.Value)
