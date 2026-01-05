#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; State Pattern - Allows object to alter behavior when internal state changes
; Demonstrates finite state machine with encapsulated state transitions

class TrafficLight {
    __New() => this.state := RedState(this)

    SetState(state) => this.state := state
    Change() => this.state.Change()
    GetColor() => this.state.color
}

class RedState {
    color := "RED"
    __New(light) => this.light := light
    Change() => this.light.SetState(GreenState(this.light))
}

class GreenState {
    color := "GREEN"
    __New(light) => this.light := light
    Change() => this.light.SetState(YellowState(this.light))
}

class YellowState {
    color := "YELLOW"
    __New(light) => this.light := light
    Change() => this.light.SetState(RedState(this.light))
}

; Demo
light := TrafficLight()
colors := []

Loop 6 {
    colors.Push(light.GetColor())
    light.Change()
}

result := ""
for color in colors
    result .= color " -> "

MsgBox(result "...")
