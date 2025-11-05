#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := 4

var := 5

if (var > 3) FileAppend(var, "*")
