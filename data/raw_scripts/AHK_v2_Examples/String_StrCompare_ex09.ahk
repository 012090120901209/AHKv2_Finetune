#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := "hhh"

var := "value"

if (StrCompare(var, "value") <= 0) FileAppend(var, "*")
