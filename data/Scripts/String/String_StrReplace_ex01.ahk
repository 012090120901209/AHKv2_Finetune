#Requires AutoHotkey v2.0
#SingleInstance Force

OldStr := "The_quick_brown_fox"
NewStr := StrReplace(OldStr, "_", , , , 1)
FileAppend(NewStr, "*")
