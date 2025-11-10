#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * InputLevel Hotkey Option
 * Control which hotkeys can trigger other hotkeys
 */

; Level 0 hotkeys (default) - triggered by physical input
F1:: {
    MsgBox("F1 - Level 0`n`nPress F2 to see Send triggering F3")
}

; This sends F3, which will trigger the Level 1 hotkey below
F2:: {
    SendLevel(1)  ; Set send level to 1
    Send("{F3}")
    SendLevel(0)  ; Reset to default
}

; Level 1 hotkey - can be triggered by SendLevel 1
#InputLevel 1
F3::MsgBox("F3 triggered!`n`nThis is a Level 1 hotkey`n(Can be triggered by Send)")
#InputLevel 0

; Practical use: Prevent hotkey chains while allowing specific triggers
