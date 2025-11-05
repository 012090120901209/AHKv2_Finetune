#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow MyVar := "joe"
MyVar2 := "`"hello`" joe"
if (MyVar2 = "`"hello`" " MyVar) MsgBox("The contents of MyVar and MyVar2 are identical.")
