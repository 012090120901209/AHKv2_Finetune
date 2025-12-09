#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Observer Pattern - Defines one-to-many dependency between objects
; Demonstrates event-driven architecture with publish/subscribe

class EventEmitter {
    __New() => this.listeners := Map()

    On(event, callback) {
        if !this.listeners.Has(event)
            this.listeners[event] := []
        this.listeners[event].Push(callback)
    }

    Off(event, callback) {
        if !this.listeners.Has(event)
            return
        
        for i, cb in this.listeners[event] {
            if cb = callback {
                this.listeners[event].RemoveAt(i)
                return
            }
        }
    }

    Emit(event, data*) {
        if this.listeners.Has(event)
            for cb in this.listeners[event]
                cb(data*)
    }
}

; Demo
emitter := EventEmitter()
emitter.On("message", (msg) => MsgBox("Received: " msg))
emitter.On("message", (msg) => OutputDebug("Log: " msg "`n"))
emitter.Emit("message", "Hello from Observer!")
