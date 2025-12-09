#Requires AutoHotkey v2.0
#SingleInstance Force

var := "hhh"

var := "value"

if (StrCompare(var, "value") <= 0) FileAppend(var, "*")
