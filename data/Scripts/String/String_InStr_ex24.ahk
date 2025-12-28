#Requires AutoHotkey v2.0
#SingleInstance Force
; Basic AHK v2 example demonstrating variable assignment and control flow

Haystack := "abcdefabcdef"
Needle := "bcd"
pos := InStr(Haystack, Needle, , -1 * ((0) + 1)) - 1

if (pos >= 0)
    MsgBox("The string was found at position " pos ".")
