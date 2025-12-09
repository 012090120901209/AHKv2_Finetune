#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Tilde Prefix (~)
* Allows the native function of the key to pass through
*/

; This lets Ctrl+C still copy, but also triggers our custom action
~^c:: {
    ; The copy still happens because of ~
    ToolTip("Copied! (Ctrl+C passed through)")
    SetTimer(() => ToolTip(), -2000)
}

; Space still types a space, but we can detect it
~Space:: {
    ToolTip("Space pressed and passed through")
    SetTimer(() => ToolTip(), -1000)
}
