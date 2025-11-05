#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow start := 7
Source := "Hello this is a test."
out := SubStr(Source, start, 4)
MsgBox(out)
