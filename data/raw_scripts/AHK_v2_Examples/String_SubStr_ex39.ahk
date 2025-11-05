#Requires AutoHotkey v2.1-alpha.16

Str := "hello world"
count := 7
two_letters := "nt"
OutputVar := SubStr(Str, 1, SubStr("count", 1, 2) . two_letters)
FileAppend(OutputVar, "*")
