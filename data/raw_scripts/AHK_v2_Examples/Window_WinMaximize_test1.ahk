#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinMaximize_test1.ah2 Run("notepad.exe")
WinWait("Untitled - Notepad")
WinMaximize() ; Use the window found by WinWait.
