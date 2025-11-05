#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

System.Object[]
var := "hello"
msg := var . " world"
FileAppend(msg, "*")