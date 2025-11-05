#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; list := "one, two, three"
list := StrReplace(list, ", ", ", ", , &ErrorLevel)
FileAppend(ErrorLevel, "*")
