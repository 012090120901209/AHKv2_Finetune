#Requires AutoHotkey v2.0
#SingleInstance Force

Haystack := "abcdefghijklmnopqrs"
Needle := "def"
pos := InStr(Haystack, Needle) - 1
if (pos >= 0) FileAppend("The string was found at position " pos ".", "*")
