#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; if WinActive("ahk_class Notepad") FileAppend("notepad is Active", "*")
else FileAppend("notepad is not Active", "*")
