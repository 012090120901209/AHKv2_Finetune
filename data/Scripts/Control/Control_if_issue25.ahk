#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/if_issue25.ah2

var := 3
if (var = 3) {
    if (var > 1) {
        MsgBox("Var is greater than 1")
    }
}
