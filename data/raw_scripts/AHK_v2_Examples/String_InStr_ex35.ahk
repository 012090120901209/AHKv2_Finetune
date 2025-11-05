#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Haystack := "abcdefghijklmnopqrs"

Haystack := "abcdefghijklm"
Needle := "jklm"

Needle := "abc"
if InStr(Haystack, Needle) FileAppend("found", "*")
