#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Str := "This is a test."
count := 6
OutputVar := SubStr(Str, -1*(count-1))
FileAppend(OutputVar, "*")
