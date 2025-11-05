#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; name := dir := ""
FullFileName := "C:\My Documents\Address List.txt"
SplitPath(FullFileName, &name)
SplitPath(FullFileName, , &dir)
FileAppend(name "`n" dir, "*")
