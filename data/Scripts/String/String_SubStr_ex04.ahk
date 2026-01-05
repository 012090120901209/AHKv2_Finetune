#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic AHK v2 example demon
strating variable assignment and control flow Str := "This is a test."
count := 3
OutputVar := SubStr(Str, 1, count + 1)
MsgBox(OutputVar)
