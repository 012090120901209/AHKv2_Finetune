#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow Haystack := "abcdefghijklmnopqrs"
Needle := "abc"
if InStr(Haystack, Needle) MsgBox("found")
