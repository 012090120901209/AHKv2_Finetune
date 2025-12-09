#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Assignment_ex5.ah2

Str := "`"Hello`" "
var := "`"Test`" "
Str .= var "`"World`"" MsgBox(Str)
