#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow var1 := 20050126
var2 := 20040126
var1 := DateDiff(var1, var2, "days")
MsgBox(var1)
