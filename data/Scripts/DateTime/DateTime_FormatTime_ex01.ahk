#Requires AutoHotkey v2.0
#SingleInstance Force

TimeString := FormatTime(, "Time")

TimeString := A_Now

FileAppend("the current time is " TimeString, "*")

