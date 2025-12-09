#Requires AutoHotkey v2.0
#SingleInstance Force

var := "zzz"

var := "xyz"

if (StrCompare(var, "value") > 0) FileAppend(var, "*")
