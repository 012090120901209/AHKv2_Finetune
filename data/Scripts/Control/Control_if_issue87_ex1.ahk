#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/if_issue87_ex1.ah2

var := 1
if var {
    try MsgBox("yes")
} else {
    MsgBox("no")
}
