#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow OldStr := "The_quick_brown_fox"
NewStr := StrReplace(OldStr, "_", , , , 1)
MsgBox(NewStr)
