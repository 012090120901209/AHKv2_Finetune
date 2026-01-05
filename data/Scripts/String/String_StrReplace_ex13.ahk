#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic AHK v2 example demon
strating variable assignment and control flow OldStr := "The quick brown fox"
NewStr := StrReplace(OldStr, " ", "+")
MsgBox(NewStr)
