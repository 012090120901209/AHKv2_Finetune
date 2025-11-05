#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Haystack := "abcdefghijklmnopqrs"

Haystack := "abcdefghij"

if (pos >= 0) FileAppend("The string was found at position " pos ".", "*")

