#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinActivate_1.ah2

if WinExist("Untitled - Notepad") WinActivate() ; Use the window found by WinExist.
else WinActivate("Calculator")
