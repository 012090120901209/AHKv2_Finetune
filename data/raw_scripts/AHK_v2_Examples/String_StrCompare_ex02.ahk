#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow var := "boy"
if ((StrCompare(var, "blue") >= 0) && (StrCompare(var, "red") <= 0)) MsgBox(var " is alphabetically between 'blue' and 'red'")
