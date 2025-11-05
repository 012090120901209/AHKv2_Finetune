#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow name := dir := ""
SplitPath("C:\My Documents\Address List.txt", &name)
SplitPath("C:\My Documents\Address List.txt", , &dir)
MsgBox(name "`n" dir)
