#Requires AutoHotkey v2.0
#SingleInstance Force

Haystack := "abcdefabcdef"
Needle := "cde"
pos := InStr(Haystack, Needle, , -1*((4)+1)) - 1
if (pos >= 0) FileAppend("The string was found at position " pos ".", "*")
