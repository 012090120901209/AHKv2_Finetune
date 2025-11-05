#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := "zzz"

var := "xyz"

if (StrCompare(var, "value") > 0) FileAppend(var, "*")
