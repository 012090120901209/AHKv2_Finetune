#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := "val"

var := "different"

if (var != "value") FileAppend(var, "*")
