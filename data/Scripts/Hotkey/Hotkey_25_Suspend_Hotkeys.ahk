#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Suspend Hotkeys
 * Temporarily disable all or specific hotkeys
 */

; Ctrl+Alt+S to suspend ALL hotkeys
^!s:: {
    Suspend(-1)  ; Toggle suspend
    state := A_IsSuspended ? "SUSPENDED" : "ACTIVE"
    MsgBox("Hotkeys are now: " state "`n`n(Except this one!)")
}

; These hotkeys will be suspended
F1:: MsgBox("F1 works (unless suspended)")
F2:: MsgBox("F2 works (unless suspended)")
F3:: MsgBox("F3 works (unless suspended)")

; Exempt specific hotkeys from suspension using ~ prefix before Suspend
; The suspension toggle hotkey itself is always exempt

