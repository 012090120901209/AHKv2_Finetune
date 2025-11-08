#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * HotIf with Expressions
 * Create complex conditions for hotkey activation
 */

global counter := 0

; Only works when counter is even
#HotIf Mod(counter, 2) = 0
F8::MsgBox("F8 works! Counter is EVEN: " counter)
#HotIf

; Only works when counter is odd
#HotIf Mod(counter, 2) = 1
F8::MsgBox("F8 works! Counter is ODD: " counter)
#HotIf

; Increment counter
F9:: {
    global counter
    counter++
    ToolTip("Counter: " counter " (" (Mod(counter, 2) = 0 ? "EVEN" : "ODD") ")")
    SetTimer(() => ToolTip(), -2000)
}

; Reset to always available (no condition)
#HotIf
F10::MsgBox("F10 always works, regardless of counter")
#HotIf
