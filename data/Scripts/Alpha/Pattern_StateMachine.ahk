#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Finite State Machine - Declarative state transitions
; Demonstrates event-driven state management

class StateMachine {
    __New(initial) {
        this.current := initial
        this.transitions := Map()
        this.onEnter := Map()
        this.onExit := Map()
        this.onTransition := ""
    }

    AddTransition(from, event, to) {
        key := from ":" event
        this.transitions[key] := to
        return this
    }

    OnEnter(state, action) {
        this.onEnter[state] := action
        return this
    }

    OnExit(state, action) {
        this.onExit[state] := action
        return this
    }

    OnAnyTransition(callback) {
        this.onTransition := callback
        return this
    }

    Trigger(event) {
        key := this.current ":" event
        if !this.transitions.Has(key)
            return false

        fromState := this.current
        toState := this.transitions[key]

        ; Exit current state
        if this.onExit.Has(fromState)
            this.onExit[fromState]()

        ; Transition
        this.current := toState

        if this.onTransition
            this.onTransition(fromState, event, toState)

        ; Enter new state
        if this.onEnter.Has(toState)
            this.onEnter[toState]()

        return true
    }

    GetState() => this.current

    CanTrigger(event) => this.transitions.Has(this.current ":" event)
}

; Demo - Order processing state machine
order := StateMachine("pending")
    ; Define transitions
    .AddTransition("pending", "pay", "paid")
    .AddTransition("paid", "ship", "shipped")
    .AddTransition("shipped", "deliver", "delivered")
    .AddTransition("pending", "cancel", "cancelled")
    .AddTransition("paid", "cancel", "refunded")
    ; State hooks
    .OnEnter("paid", () => OutputDebug("Payment received!`n"))
    .OnEnter("shipped", () => OutputDebug("Order shipped!`n"))
    .OnEnter("delivered", () => OutputDebug("Order delivered!`n"))
    .OnAnyTransition((from, event, to) => OutputDebug(from " --[" event "]--> " to "`n"))

; Process order
history := [order.GetState()]

order.Trigger("pay")
history.Push(order.GetState())

order.Trigger("ship")
history.Push(order.GetState())

order.Trigger("deliver")
history.Push(order.GetState())

result := "Order State History:`n"
for state in history
    result .= "-> " state "`n"

MsgBox(result)
