#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; name := dir := ""
SplitPath("C:\My Documents\Address List.txt", &name)
SplitPath("C:\My Documents\Address List.txt", , &dir)
FileAppend(name "`n" dir, "*")
