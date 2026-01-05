#Requires AutoHotkey v2.0
#SingleInstance Force

if WinExist("ahk_class Notepad")
    FileAppend("notepad is open", "*")
else
    FileAppend("notepad is not open", "*")
