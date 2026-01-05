#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Single Key with Multiple Actions
 * Hotkeys can execute multiple lines using braces
 */

F2:: {
    currentTime := FormatTime(, "HH:mm:ss")
    MsgBox("F2 pressed at " currentTime)
    ToolTip("Hotkey triggered!")
    Sleep(2000)
    ToolTip()  ; Clear tooltip
}
