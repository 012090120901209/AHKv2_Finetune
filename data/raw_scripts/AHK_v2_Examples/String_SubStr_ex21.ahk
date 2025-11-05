#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Str := "This is a test."
OutputVar := SubStr(Str, (5)+1)
FileAppend(OutputVar, "*")
