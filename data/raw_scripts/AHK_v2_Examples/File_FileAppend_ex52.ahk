#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := 1

var := 2

if (var < 4) FileAppend(var, "*")
