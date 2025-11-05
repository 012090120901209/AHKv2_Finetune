#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_StringCaseSense_ex1.ah2 A_StringCaseSense := true
Haystack := "abcdefabcDEF"
Needle := "DEF"
pos := InStr(Haystack, Needle, A_StringCaseSense) - 1
MsgBox("The string was found at position " pos)
