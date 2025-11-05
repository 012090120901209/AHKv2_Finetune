#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow name := dir := ""
FullFileName := "C:\My Documents\Address List.txt"
SplitPath(FullFileName, &name)
SplitPath(FullFileName, , &dir)
MsgBox(name "`n" dir)
