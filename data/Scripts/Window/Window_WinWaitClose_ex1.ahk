#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinWaitClose_ex1.ah2

Run("notepad.exe")
WinWait("Untitled - Notepad")
WinWaitClose() ; Use the window found by WinWait.
MsgBox("Notepad is now closed.")
