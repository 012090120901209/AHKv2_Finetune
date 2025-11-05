#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := "boy"

var := "blue"

if ((StrCompare(var, "blue") >= 0) && (StrCompare(var, "red") <= 0)) FileAppend(var " is alphabetically between 'blue' and 'red'", "*")
