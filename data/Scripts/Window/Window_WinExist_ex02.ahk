#Requires AutoHotkey v2.0
#SingleInstance Force

if WinExist("ahk_class Notepad")
    MsgBox("notepad is open")
else
    MsgBox("notepad is not open")
