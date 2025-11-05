#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Haystack := "abcdefghijklmnopqrs"
Needle := "xyz"
pos := InStr(Haystack, Needle) - 1
FileAppend("The string was found at position " pos ".", "*")
