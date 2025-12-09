#Requires AutoHotkey v2.0
#SingleInstance Force

var := A_Now
var := DateAdd(var, 7, "days")
var := FormatTime(var, "ShortDate")
FileAppend(var, "*")
