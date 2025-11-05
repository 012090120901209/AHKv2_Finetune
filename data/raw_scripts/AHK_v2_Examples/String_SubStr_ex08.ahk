#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow Source := "Hello this is a test."
out := SubStr(Source, 7, 4)
MsgBox(out)
