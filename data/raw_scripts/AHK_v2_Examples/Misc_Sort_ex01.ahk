#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; MyVar := "5, 3, 7, 9, 1, 13, 999, -4"
MyVar := Sort(MyVar, "N D, ") ; Sort numerically, use comma as delimiter.
FileAppend(MyVar, "*")
