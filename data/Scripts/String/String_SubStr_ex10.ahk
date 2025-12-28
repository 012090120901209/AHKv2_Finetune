#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow InputVar := "The Red Fox"
out := SubStr(SubStr(InputVar, 1, 7), StrLen(InputVar) >= 7 ? -3 : StrLen(InputVar) - 7)
MsgBox(out)
