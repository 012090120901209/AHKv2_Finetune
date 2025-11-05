#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
var := 10
value := 3

var := 10var := 10
value := 6
var -= value
FileAppend(var, "*")
