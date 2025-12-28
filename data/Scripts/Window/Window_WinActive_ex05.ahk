#Requires AutoHotkey v2.0
#SingleInstance Force

if WinActive()
    MsgBox("last found window is Active")
else
    MsgBox("last found window is not Active")
