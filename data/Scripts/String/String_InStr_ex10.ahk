#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow Haystack := "abcdefabcdef"
Needle := "cde"
var := 1
pos := InStr(Haystack, Needle, , (var + 2) + 1) - 1
if (pos >= 0) MsgBox("The string was found at position " pos ".")
