#Requires AutoHotkey v2.0
#SingleInstance Force
; Event Emitter Pattern (Observer/PubSub)
class EventEmitter {
    __New() {
        this.listeners := Map()
    }

    On(event, callback) {
        if (!this.listeners.Has(event))
        this.listeners[event] := []
        this.listeners[event].Push(callback)
    }

    Off(event, callback := "") {
        if (!this.listeners.Has(event))
        return

        if (callback = "") {
            this.listeners.Delete(event)
        } else {
            listeners := this.listeners[event]
            Loop listeners.Length {
                if (listeners[A_Index] = callback) {
                    listeners.RemoveAt(A_Index)
                    break
                }
            }
        }
    }

    Emit(event, data := "") {
        if (!this.listeners.Has(event))
        return

        for callback in this.listeners[event] {
            callback(data)
        }
    }
}

; Demo
emitter := EventEmitter()

emitter.On("userLogin", (data) => MsgBox("User logged in: " data.name))
emitter.On("userLogout", (data) => MsgBox("User logged out: " data.name))

emitter.Emit("userLogin", {name: "John"})
emitter.Emit("userLogout", {name: "John"})
