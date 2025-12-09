#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Hotkey() Function - Dynamic Hotkey Creation
* Create, modify, enable, and disable hotkeys at runtime
*/

; Create a hotkey dynamically using Hotkey() function
Hotkey("F6", MyFunction)

; This function will be called when F6 is pressed
MyFunction(*) {
    MsgBox("F6 hotkey created dynamically!")
}

; Create another hotkey with an anonymous function
Hotkey("^!z", (*) => MsgBox("Ctrl+Alt+Z works!"))

; You can also enable/disable hotkeys
F7:: {
    Hotkey("F6", "Off")  ; Disable F6
    MsgBox("F6 hotkey disabled")
}

F8:: {
    Hotkey("F6", "On")   ; Enable F6
    MsgBox("F6 hotkey enabled")
}
