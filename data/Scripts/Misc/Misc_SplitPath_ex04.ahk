#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow name := dir := ""
SplitPath("C:\My Documents\Address List.txt", &name)
SplitPath("C:\My Documents\Address List.txt", , &dir)
MsgBox(name "`n" dir)
