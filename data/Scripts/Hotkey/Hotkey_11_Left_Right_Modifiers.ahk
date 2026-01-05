#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Left vs Right Modifiers
 * Distinguish between left and right Ctrl, Alt, Shift, Win keys
 */

; Left Ctrl
<^j:: MsgBox("Left Ctrl+J pressed")

; Right Ctrl
>^j:: MsgBox("Right Ctrl+J pressed")

; Left Alt
<!a:: MsgBox("Left Alt+A pressed")

; Right Alt (AltGr on international keyboards)
>!a:: MsgBox("Right Alt+A pressed")

; Left Win key
<#w:: MsgBox("Left Win+W pressed")

; Right Win key
>#w:: MsgBox("Right Win+W pressed")
