#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/if_between_ex1.ah2

Color := "blue"
if ((StrCompare(color, "blue") >= 0) && (StrCompare(color, "red") <= 0)) {
    MsgBox("yes")
} else {
    MsgBox("no")
}
