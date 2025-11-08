#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - Mouse Position
 * Hotkeys based on what window the mouse is hovering over
 */

; Custom function to check mouse position
MouseIsOver(WinTitle) {
    MouseGetPos(,, &Win)
    return WinExist(WinTitle " ahk_id " Win)
}

; Ctrl+Click only works when mouse is over Notepad
#HotIf MouseIsOver("ahk_exe notepad.exe")
^LButton::MsgBox("Ctrl+Click over Notepad!")
#HotIf

; MButton only when hovering over taskbar
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
MButton::MsgBox("Middle-click on Taskbar!")
#HotIf

; Wheel scroll behavior changes based on mouse position
#HotIf MouseIsOver("ahk_exe explorer.exe")
^WheelUp::MsgBox("Ctrl+Scroll Up in Explorer")
^WheelDown::MsgBox("Ctrl+Scroll Down in Explorer")
#HotIf
