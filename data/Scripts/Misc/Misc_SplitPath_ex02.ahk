#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow name := dir := ""
FullFileName := "C:\My Documents\Address List.txt"
SplitPath(FullFileName, &name)
SplitPath(FullFileName, , &dir)
MsgBox(name "`n" dir)
