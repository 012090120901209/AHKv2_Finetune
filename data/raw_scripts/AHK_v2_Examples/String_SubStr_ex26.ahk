#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow Str := "This is a test."
OutputVar := SubStr(Str, 1, -1*(6))
MsgBox("[" OutputVar "]")
