#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

Haystack := "abcdefghijklm"

if InStr(Haystack, "jklm") {
    Sleep(10)
    FileAppend("found", "*")
}
