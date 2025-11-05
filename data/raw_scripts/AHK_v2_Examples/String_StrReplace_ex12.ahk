#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow list := "one, two, three"
list := StrReplace(list, ", ", ", ", , &ErrorLevel)
MsgBox(ErrorLevel)
