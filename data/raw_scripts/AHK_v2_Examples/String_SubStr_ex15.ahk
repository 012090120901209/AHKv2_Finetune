#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; start := 2
count := 4
Source := "Hello this is a test."
out := SubStr(Source, start+5, count)
FileAppend(out, "*")
