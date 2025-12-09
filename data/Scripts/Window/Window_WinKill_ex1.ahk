#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinKill_ex1.ah2

if WinExist("Untitled - Notepad") WinKill() ; Use the window found by WinExist.
else WinKill("Calculator")
