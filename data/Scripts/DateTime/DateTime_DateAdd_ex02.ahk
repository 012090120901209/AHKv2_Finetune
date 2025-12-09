#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow var := A_Now
var := DateAdd(var, 7, "days")
var := FormatTime(var, "ShortDate")
MsgBox(var)
