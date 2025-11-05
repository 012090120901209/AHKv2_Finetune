#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; OldStr := "The_quick_brown_fox"
NewStr := StrReplace(OldStr, "_", ,, , 1)
FileAppend(NewStr, "*")
