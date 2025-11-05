#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow Str := "This is a test."
count := 7
two_letters := "nt"
OutputVar := SubStr(Str, 1, cou%two_letters%)
MsgBox(OutputVar)
