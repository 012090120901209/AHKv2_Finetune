#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var1 := 20050126
var2 := 20040126
var1 := DateDiff(var1, var2, "days")
FileAppend(var1, "*")
