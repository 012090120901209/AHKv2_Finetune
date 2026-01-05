#Requires AutoHotkey v2.0
#SingleInstance Force

if WinActive("ahk_class Notepad")
    FileAppend("notepad is Active", "*")
else
    FileAppend("notepad is not Active", "*")
