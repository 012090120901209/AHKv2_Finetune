#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Priority Hotkey Option
 * Set thread priority for hotkeys
 */

; Set high priority for this hotkey using Hotkey() function
; P100 = Priority 100 (higher = more important)
Hotkey("^!p", HighPriorityFunction, "P100")

HighPriorityFunction(*) {
    MsgBox("High priority hotkey!`n`nThis runs at priority 100")
}

; Normal priority hotkey (default is 0)
^!n:: MsgBox("Normal priority hotkey")

; Note: In AHK v2, these settings are handled via Hotkey() function options
; #HotKeyInterval 2000  ; Time window in milliseconds (v1 directive)
; #MaxThreadsPerHotkey 1  ; (v1 directive)

F12:: {
    MsgBox("Priority can affect which hotkey fires first`nwhen multiple are triggered rapidly")
}
