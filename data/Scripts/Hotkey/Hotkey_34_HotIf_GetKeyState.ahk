#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - Key State
 * Hotkeys based on whether other keys are held down
 */

; Only works when CapsLock is ON
#HotIf GetKeyState("CapsLock", "T")

a:: MsgBox("'a' pressed while CapsLock is ON")
#HotIf

; Only works when CapsLock is OFF
#HotIf !GetKeyState("CapsLock", "T")

a:: Send("apple")  ; Auto-expand 'a' to 'apple' when CapsLock OFF
#HotIf

; Only works when ScrollLock is ON
#HotIf GetKeyState("ScrollLock", "T")

Up:: MsgBox("Arrow Up while ScrollLock ON")
Down:: MsgBox("Arrow Down while ScrollLock ON")
#HotIf

; Only when Ctrl is PHYSICALLY held down
#HotIf GetKeyState("Ctrl", "P")

WheelUp:: MsgBox("Ctrl+Wheel Up (Ctrl is physically pressed)")
#HotIf

#HotIf  ; Reset context

