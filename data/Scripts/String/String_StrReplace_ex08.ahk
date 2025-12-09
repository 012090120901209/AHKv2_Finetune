#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow OldStr := "The quick brown fox"
NewStr := StrReplace(OldStr, A_Space, "+", ,, 1)
MsgBox(NewStr)
