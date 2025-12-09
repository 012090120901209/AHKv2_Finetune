#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Assignment_ex1.ah2

str1 := "`"Hello World`""
str2 := "`"Hello World`""
str3 := "Hello `"test`" World" MsgBox(str1 "`n`n" str2 "`n`n" str3)
