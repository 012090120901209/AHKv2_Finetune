#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinSetTitle_ex2.ah2 Run("notepad.exe")
WinWaitActive("Untitled - Notepad")
WinSetTitle("This is a new title") ; Use the window found by WinWaitActive.
