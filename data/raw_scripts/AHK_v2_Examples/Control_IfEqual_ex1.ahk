#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/IfEqual_ex1.ah2 var := "value"
if (var = "value") size := FileGetSize(A_ScriptFullPath)
MsgBox(size)
