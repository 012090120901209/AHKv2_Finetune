#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_ClipWait_ex1.ah2

A_Clipboard := "" ; Empty the clipboard
Send("^c")
Errorlevel := !ClipWait(2)
if ErrorLevel
{
    MsgBox("The attempt to copy text onto the clipboard failed.")
}
MsgBox("clipboard = " A_Clipboard)
