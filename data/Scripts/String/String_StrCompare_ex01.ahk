#Requires AutoHotkey v2.0
#SingleInstance Force

var := "boy"

var := "blue"

if ((StrCompare(var, "blue") >= 0) && (StrCompare(var, "red") <= 0)) FileAppend(var " is alphabetically between 'blue' and 'red'", "*")
