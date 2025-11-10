#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Toggle Hotkeys On/Off
 * Enable and disable hotkeys dynamically
 */

hotkeyEnabled := true

; Toggle the state of F9 hotkey
F1:: {
    global hotkeyEnabled
    hotkeyEnabled := !hotkeyEnabled

    if hotkeyEnabled {
        Hotkey("F9", "On")
        MsgBox("F9 hotkey ENABLED")
    } else {
        Hotkey("F9", "Off")
        MsgBox("F9 hotkey DISABLED")
    }
}

; F9 hotkey that can be toggled
F9::MsgBox("F9 is active!`n`nPress F1 to toggle this hotkey")
