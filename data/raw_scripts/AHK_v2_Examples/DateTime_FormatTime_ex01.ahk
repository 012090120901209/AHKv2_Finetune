#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; TimeString := FormatTime(, "Time")

TimeString := A_Now

FileAppend("the current time is " TimeString, "*")

