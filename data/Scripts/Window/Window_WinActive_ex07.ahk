#Requires AutoHotkey v2.0
#SingleInstance Force

if !WinActive("ahk_class Notepad")
    MsgBox("notepad is not Active")
else
    MsgBox("notepad is Active")
