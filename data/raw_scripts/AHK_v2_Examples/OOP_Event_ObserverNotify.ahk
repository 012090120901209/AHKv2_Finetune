#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Event-Driven System
class EventSystem {
    __New() => (this.listeners := Map())
    On(event, callback) => (this.listeners.Has(event) || this.listeners[event] := [], this.listeners[event].Push(callback), this)
    Emit(event, data := "") => (this.listeners.Has(event) && this.listeners[event].Map((cb) => cb.Call(data)))
}
system := EventSystem()
system.On("test", (data) => MsgBox("Event fired: " . data))
system.Emit("test", "Hello from OOP Event System!")
