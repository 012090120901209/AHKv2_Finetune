#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_Assignment_ex6.ah2 MyStr := "Regex: /\(.*?\)/g" MyVar := RegExReplace(MyStr, "/.*/\w+", "") MsgBox(MyStr "`n" MyVar)
