#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic AHK v2 example demon
strating variable assignment and control flow var := "boy"
if ((StrCompare(var, "blue") >= 0) && (StrCompare(var, "red") <= 0)) MsgBox(var " is alphabetically between 'blue' and 'red'")
