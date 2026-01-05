#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinClose_ex1.ah2

if WinExist("Untitled - Notepad") WinClose() ; Use the window found by WinExist.
else WinClose("Calculator")
