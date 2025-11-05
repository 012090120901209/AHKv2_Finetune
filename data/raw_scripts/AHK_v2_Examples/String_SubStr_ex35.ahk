#Requires AutoHotkey v2.1-alpha.16

Str := "hello world"
count := 7
OutputVar := SubStr(Str, 1, count)
FileAppend(OutputVar, "*")
