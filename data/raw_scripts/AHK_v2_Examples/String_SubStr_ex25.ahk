#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Str := "This is a test."
OutputVar := SubStr(Str, 1, -1*(6))
FileAppend("[" OutputVar "]", "*")
