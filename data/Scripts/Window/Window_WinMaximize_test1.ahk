#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinMaximize_test1.ah2

Run("notepad.exe")
WinWait("Untitled - Notepad")
WinMaximize() ; Use the window found by WinWait.
