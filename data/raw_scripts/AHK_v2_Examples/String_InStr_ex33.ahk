#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Haystack := "abcdefghijklmnopqrs"

Haystack := "abcdefghijklm"

if InStr(Haystack, "jklm") FileAppend("found", "*")
