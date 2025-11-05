#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Str := "This is a test."
count := 5
OutputVar := SubStr(Str, (count*1)+1)
FileAppend(OutputVar, "*")
