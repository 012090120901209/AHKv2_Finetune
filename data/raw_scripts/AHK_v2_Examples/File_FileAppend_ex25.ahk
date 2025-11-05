#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
var := 2
var2 := 3

var := 2var := 2
var2 := 2
var *= var2
FileAppend(var, "*")
