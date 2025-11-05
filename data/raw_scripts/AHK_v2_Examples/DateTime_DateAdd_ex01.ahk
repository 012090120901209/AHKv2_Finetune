#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := A_Now
var := DateAdd(var, 7, "days")
var := FormatTime(var, "ShortDate")
FileAppend(var, "*")
