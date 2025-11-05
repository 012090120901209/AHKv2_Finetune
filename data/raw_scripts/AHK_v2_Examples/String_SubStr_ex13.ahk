#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; start := 7
Source := "Hello this is a test."
out := SubStr(Source, start, 4)
FileAppend(out, "*")
