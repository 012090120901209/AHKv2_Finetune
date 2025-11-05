#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow OldStr := "The quick brown fox"
NewStr := StrReplace(OldStr, A_Space, "+", , &ErrorLevel)
MsgBox("number of replacements: " ErrorLevel)
