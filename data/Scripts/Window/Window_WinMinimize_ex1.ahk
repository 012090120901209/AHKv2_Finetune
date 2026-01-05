#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinMinimize_ex1.ah2

Run("notepad.exe")
WinWait("Untitled - Notepad")
WinMinimize() ; Use the window found by WinWait.
