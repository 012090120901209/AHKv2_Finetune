#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
var := 5
var2 := 3

var := 5var := 5
/*
var = hello
*/
var2 := "hello2"
FileAppend("var = " var "`nvar2 = " var2, "*")
