#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow InputVar := "The Red Fox"
left := "LOL"
if (SubStr(left, 1, 1) = "L") out := SubStr(SubStr(InputVar, 1, 7), -3)
else out := SubStr(InputVar, 7, 3)
MsgBox(out)
