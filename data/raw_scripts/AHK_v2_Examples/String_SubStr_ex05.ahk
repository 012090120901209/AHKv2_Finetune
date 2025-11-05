#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source := "Hello this is a test."
out := SubStr(Source, 7)
FileAppend(out, "*")
