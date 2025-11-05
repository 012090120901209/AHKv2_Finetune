#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinGet_ex1.ah2 active_id := WinGetID("A")
WinMaximize("ahk_id " active_id)
MsgBox("The active window's ID is `"" active_id "`".")
