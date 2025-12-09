#Requires AutoHotkey v2.0
#SingleInstance Force

list := "one, two, three"
list := StrReplace(list, ", ", ", ", , &ErrorLevel)
FileAppend(ErrorLevel, "*")
