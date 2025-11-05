#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := ", "

var := ","

if (var = ", ") FileAppend("var is a comma", "*")
