#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic AHK v2 example demon
strating variable assignment and control flow list := "one, two, three"
list := StrReplace(list, ", ", ", ", , &ErrorLevel)
MsgBox(ErrorLevel)
