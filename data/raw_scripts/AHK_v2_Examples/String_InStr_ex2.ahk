#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_InStr_ex2.ah2 Haystack := "The Quick Brown Fox Jumps Over the Lazy Dog"
Needle := "Fox"
If InStr(Haystack, Needle) MsgBox("The string was found.")
Else MsgBox("The string was not found.")
