#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; OldStr := "The quick brown fox"
NewStr := StrReplace(OldStr, A_Space, "+", ,, 1)
FileAppend(NewStr, "*")
