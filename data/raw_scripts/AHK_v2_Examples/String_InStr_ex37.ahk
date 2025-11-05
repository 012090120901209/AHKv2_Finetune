#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Haystack := "abcdefghijklmnopqrs"
if ! InStr(Haystack, "jklm") FileAppend("found", "*")
