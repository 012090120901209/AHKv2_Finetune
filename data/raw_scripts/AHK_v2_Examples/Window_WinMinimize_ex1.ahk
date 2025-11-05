#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinMinimize_ex1.ah2 Run("notepad.exe")
WinWait("Untitled - Notepad")
WinMinimize() ; Use the window found by WinWait.
