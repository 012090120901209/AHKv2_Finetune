#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Numpad Keys
 * Specific hotkeys for the numeric keypad
 */

; Individual numpad numbers
Numpad0:: MsgBox("Numpad 0")
Numpad1:: MsgBox("Numpad 1")
Numpad5:: MsgBox("Numpad 5 (Center)")

; Numpad operators
NumpadAdd:: MsgBox("Numpad +")
NumpadSub:: MsgBox("Numpad -")
NumpadMult:: MsgBox("Numpad *")
NumpadDiv:: MsgBox("Numpad /")

; NumLock state
NumLock:: MsgBox("NumLock toggled")

; Combine with modifiers
^Numpad5:: MsgBox("Ctrl+Numpad5 - Custom action")
