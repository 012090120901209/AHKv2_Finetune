#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinGetClass_ex1.ah2

class_ := WinGetClass("A")
MsgBox("The active window's class is `"" class_ "`".")
