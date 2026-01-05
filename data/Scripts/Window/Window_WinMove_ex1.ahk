#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinMove_ex1.ah2

Run("calc.exe")
WinWait("Calculator")
WinMove(0, 0) ; Use the window found by WinWait.
