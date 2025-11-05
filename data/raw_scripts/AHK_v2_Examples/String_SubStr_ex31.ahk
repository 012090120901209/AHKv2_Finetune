#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

Str := "hello world"
count := 5

OutputVar := SubStr(Str, 1, count)
FileAppend(OutputVar, "*")
