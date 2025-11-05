#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow Haystack := "abcdefghijklmnopqrs"
if InStr(Haystack, "jklm") { Sleep(10) MsgBox("found")
}
