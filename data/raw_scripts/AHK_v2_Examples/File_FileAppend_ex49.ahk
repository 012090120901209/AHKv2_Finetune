#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := "hello, world"

var := "hello, world"

if (var = "hello, world") FileAppend("var matches", "*")
