#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow MyVar := "5, 3, 7, 9, 1, 13, 999, -4"
MyVar := Sort(MyVar, "N D, ") ; Sort numerically, use comma as delimiter.
MsgBox(MyVar)
