#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; if ! WinExist("ahk_class Notepad") FileAppend("notepad is not open", "*")
else FileAppend("notepad is open", "*")
