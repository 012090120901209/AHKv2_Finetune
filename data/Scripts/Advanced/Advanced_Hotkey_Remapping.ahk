#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced Hotkey Example: Key Remapping with Toggle
; Demonstrates: Hotkey remapping, toggle functionality, tray menu integration

global remappingEnabled := true

; Create tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle Remapping", ToggleRemapping)
A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.Check("Toggle Remapping")

; Remap CapsLock to Escape
#HotIf remappingEnabled

CapsLock::Escape
#HotIf

; Remap numeric keypad to arrow keys (when NumLock is off)
#HotIf remappingEnabled && !GetKeyState("NumLock", "T")

Numpad8::Up
Numpad2::Down
Numpad4::Left
Numpad6::Right
Numpad5::Enter
#HotIf

; Remap Windows key combinations
#HotIf remappingEnabled
#e::

{
    ; Win+E opens Downloads folder instead of Explorer
    Run(A_MyDocuments "\Downloads")
}

#n::

{
    ; Win+N opens Notepad
    Run("notepad.exe")
}

#c::

{
    ; Win+C opens Calculator
    Run("calc.exe")
}
#HotIf

; Show notification when script starts
TrayTip("Key Remapping Active", "CapsLock→Esc, Win+E→Downloads, Numpad→Arrows", "Iconi Mute")

ToggleRemapping(ItemName, ItemPos, MyMenu) {
    global remappingEnabled

    remappingEnabled := !remappingEnabled

    if (remappingEnabled) {
        MyMenu.Check(ItemName)
        TrayTip("Remapping Enabled", "Custom key mappings are now active", "Iconi")
    } else {
        MyMenu.Uncheck(ItemName)
        TrayTip("Remapping Disabled", "Keys will function normally", "Iconi")
    }
}
