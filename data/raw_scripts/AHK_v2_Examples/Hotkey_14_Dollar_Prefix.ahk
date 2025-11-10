#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Dollar Prefix ($)
 * Prevents the hotkey from triggering itself when using Send
 */

; Without $, this could create an infinite loop
$F1:: {
    MsgBox("F1 pressed once`n`n$ prevents Send from triggering this again")
    ; If we send F1 here, it won't trigger this hotkey again
    ; Send("{F1}")  ; Uncomment to test - won't cause infinite loop
}

; Useful for remapping keys
$a:: {
    Send("b")  ; Types 'b' instead of 'a', won't retrigger this hotkey
}
