#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Hotkey Variants with HotIf
 * Same hotkey, different behavior based on conditions
 */

global mode := "normal"

; F1 in normal mode
#HotIf mode = "normal"
F5::MsgBox("F5 in NORMAL mode")
#HotIf

; F1 in edit mode
#HotIf mode = "edit"
F5::MsgBox("F5 in EDIT mode")
#HotIf

; F1 in special mode
#HotIf mode = "special"
F5::MsgBox("F5 in SPECIAL mode")
#HotIf

; Switch modes with F1-F3
F1:: {
    global mode := "normal"
    ToolTip("Mode: NORMAL")
    SetTimer(() => ToolTip(), -2000)
}

F2:: {
    global mode := "edit"
    ToolTip("Mode: EDIT")
    SetTimer(() => ToolTip(), -2000)
}

F3:: {
    global mode := "special"
    ToolTip("Mode: SPECIAL")
    SetTimer(() => ToolTip(), -2000)
}
