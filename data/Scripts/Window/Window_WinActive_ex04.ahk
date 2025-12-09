#Requires AutoHotkey v2.0
#SingleInstance Force

if WinActive()
FileAppend("last found window is Active", "*")
else
FileAppend("last found window is not Active", "*")
