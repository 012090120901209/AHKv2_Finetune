#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinHide_ex1.ah2

Run("notepad.exe")
WinWait("Untitled - Notepad")
Sleep(500)
WinHide() ; Use the window found by WinWait.
Sleep(1000)
WinShow() ; Use the window found by WinWait.
