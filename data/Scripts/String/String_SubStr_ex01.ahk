#Requires AutoHotkey v2.0
#SingleInstance Force

Str := "This is a test."
OutputVar := SubStr(Str, 1, 4)
FileAppend(OutputVar, "*")
