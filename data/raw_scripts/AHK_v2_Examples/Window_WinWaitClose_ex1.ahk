#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinWaitClose_ex1.ah2 Run("notepad.exe")
WinWait("Untitled - Notepad")
WinWaitClose() ; Use the window found by WinWait.
MsgBox("Notepad is now closed.")
