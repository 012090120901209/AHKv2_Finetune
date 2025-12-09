#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Event Emitter - Node.js style event handling
; Demonstrates pub/sub with named events

class EventEmitter {
    __New() {
        this.listeners := Map()
        this.onceListeners := Map()
        this.maxListeners := 10
    }

    On(event, listener) {
        if !this.listeners.Has(event)
            this.listeners[event] := []
        
        if this.listeners[event].Length >= this.maxListeners
            OutputDebug("[Warning] Max listeners exceeded for event: " event "`n")
        
        this.listeners[event].Push(listener)
        return this
    }

    Once(event, listener) {
        if !this.onceListeners.Has(event)
            this.onceListeners[event] := []
        
        this.onceListeners[event].Push(listener)
        return this
    }

    Off(event, listener := "") {
        if listener = "" {
            ; Remove all listeners for event
            this.listeners.Delete(event)
            this.onceListeners.Delete(event)
        } else {
            ; Remove specific listener
            if this.listeners.Has(event) {
                for i, fn in this.listeners[event] {
                    if fn = listener {
                        this.listeners[event].RemoveAt(i)
                        break
                    }
                }
            }
        }
        return this
    }

    Emit(event, data*) {
        count := 0

        ; Regular listeners
        if this.listeners.Has(event) {
            for listener in this.listeners[event] {
                listener(data*)
                count++
            }
        }

        ; One-time listeners
        if this.onceListeners.Has(event) {
            listeners := this.onceListeners[event]
            this.onceListeners.Delete(event)
            
            for listener in listeners {
                listener(data*)
                count++
            }
        }

        return count
    }

    ListenerCount(event) {
        count := 0
        if this.listeners.Has(event)
            count += this.listeners[event].Length
        if this.onceListeners.Has(event)
            count += this.onceListeners[event].Length
        return count
    }

    EventNames() {
        names := []
        for name, _ in this.listeners
            names.Push(name)
        for name, _ in this.onceListeners
            if !this._contains(names, name)
                names.Push(name)
        return names
    }

    _contains(arr, value) {
        for v in arr
            if v = value
                return true
        return false
    }

    RemoveAllListeners() {
        this.listeners := Map()
        this.onceListeners := Map()
        return this
    }
}

; Typed Event Emitter with event map
class TypedEventEmitter extends EventEmitter {
    __New(eventTypes := "") {
        super.__New()
        this.eventTypes := eventTypes ?? Map()
    }

    DefineEvent(name, schema := "") {
        this.eventTypes[name] := schema
        return this
    }

    Emit(event, data*) {
        ; Validate event type if defined
        if this.eventTypes.Count && !this.eventTypes.Has(event) {
            OutputDebug("[Warning] Emitting undefined event: " event "`n")
        }
        
        return super.Emit(event, data*)
    }
}

; Demo - Basic event emitter
emitter := EventEmitter()
logs := []

; Add listeners
emitter.On("message", (text) => logs.Push("Message: " text))
emitter.On("message", (text) => logs.Push("Also got: " text))

; Add one-time listener
emitter.Once("connect", () => logs.Push("Connected! (once)"))

; Emit events
emitter.Emit("connect")
emitter.Emit("connect")  ; Won't trigger once listener again
emitter.Emit("message", "Hello, World!")

result := "Event Emitter Demo:`n`n"
for log in logs
    result .= log "`n"

result .= "`nListener count for 'message': " emitter.ListenerCount("message")
result .= "`nListener count for 'connect': " emitter.ListenerCount("connect")

MsgBox(result)

; Demo - Custom event class
class Button extends EventEmitter {
    __New(label) {
        super.__New()
        this.label := label
        this.enabled := true
    }

    Click() {
        if this.enabled
            this.Emit("click", this)
    }

    Enable() {
        this.enabled := true
        this.Emit("enable", this)
    }

    Disable() {
        this.enabled := false
        this.Emit("disable", this)
    }
}

logs := []
btn := Button("Submit")

btn.On("click", (b) => logs.Push("Button '" b.label "' clicked"))
btn.On("disable", (b) => logs.Push("Button '" b.label "' disabled"))
btn.On("enable", (b) => logs.Push("Button '" b.label "' enabled"))

btn.Click()
btn.Disable()
btn.Click()  ; Won't log (disabled)
btn.Enable()
btn.Click()

result := "Button Event Demo:`n`n"
for log in logs
    result .= log "`n"

MsgBox(result)

; Demo - Typed events
userEmitter := TypedEventEmitter()
    .DefineEvent("user:created")
    .DefineEvent("user:updated")
    .DefineEvent("user:deleted")

logs := []

userEmitter.On("user:created", (user) => logs.Push("Created: " user["name"]))
userEmitter.On("user:updated", (user, changes) => logs.Push("Updated: " user["name"]))

userEmitter.Emit("user:created", Map("id", 1, "name", "Alice"))
userEmitter.Emit("user:updated", Map("id", 1, "name", "Alice"), Map("email", "new@email.com"))
userEmitter.Emit("user:unknown", Map())  ; Warning in debug

result := "Typed Event Demo:`n`n"
for log in logs
    result .= log "`n"

result .= "`nDefined events: "
for name, _ in userEmitter.eventTypes
    result .= name " "

MsgBox(result)
