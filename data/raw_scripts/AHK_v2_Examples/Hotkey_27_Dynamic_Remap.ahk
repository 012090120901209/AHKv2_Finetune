#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Dynamic Key Remapping
 * Change what keys do at runtime
 */

; F1 to toggle between two different behaviors for 'a' key
mode := 1

F1:: {
    global mode
    mode := mode = 1 ? 2 : 1

    if (mode = 1) {
        ; Remap 'a' to type 'apple'
        Hotkey("a", (*) => Send("apple"))
        MsgBox("Mode 1: 'a' types 'apple'")
    } else {
        ; Remap 'a' to type 'amazing'
        Hotkey("a", (*) => Send("amazing"))
        MsgBox("Mode 2: 'a' types 'amazing'")
    }
}

; F2 to reset 'a' to normal
F2:: {
    Hotkey("a", "Off")
    MsgBox("'a' key reset to normal")
}
