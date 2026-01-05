#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/MsgBox_wrong-timeout.ah2

MsgBox("Text, not timeout", "Title", 4)
MsgBox("Text", "Title", 4) ; blank (a comma that shouldn't appear)
