#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

str := "line1`nline2"
var := (
    "line1" "`n" "line2"
)
FileAppend(var, "*")

