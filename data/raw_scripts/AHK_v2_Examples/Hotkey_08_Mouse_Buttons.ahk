#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Mouse Button Hotkeys
 * XButton1 (back) and XButton2 (forward) on gaming mice
 */

; Middle mouse button
MButton::MsgBox("Middle mouse button clicked!")

; Extra mouse button 1 (usually 'back' button)
XButton1::MsgBox("XButton1 (Back) clicked")

; Extra mouse button 2 (usually 'forward' button)
XButton2::MsgBox("XButton2 (Forward) clicked")

; Ctrl + Right Click
^RButton::MsgBox("Ctrl + Right Click detected")
