#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_ifVar_ex2.ah2

var := "11"
if (var~ = "^(?i:1|2|3|5|7|11)$") ; Avoid spaces in list. MsgBox(var " is a small prime number.")
