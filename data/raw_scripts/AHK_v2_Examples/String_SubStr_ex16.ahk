#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow start := 2
count := 4
Source := "Hello this is a test."
out := SubStr(Source, start+5, count)
MsgBox(out)
