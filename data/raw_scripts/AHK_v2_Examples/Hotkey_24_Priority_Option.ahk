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
^!n::MsgBox("Normal priority hotkey")

; You can also use #MaxThreadsPerHotkey and set priority
#HotKeyInterval 2000  ; Time window in milliseconds
#MaxThreadsPerHotkey 1

F12:: {
    MsgBox("Priority can affect which hotkey fires first`nwhen multiple are triggered rapidly")
}
