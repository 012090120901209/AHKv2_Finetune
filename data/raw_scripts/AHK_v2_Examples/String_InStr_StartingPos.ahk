#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_InStr_StartingPos.ah2 MsgBox(InStr("ababab", "b", , 1)) ; Returns 2
MsgBox(InStr("ababab", "b", , -1)) ; Returns 6
MsgBox(InStr("ababab", "b", , -2)) ; Returns 4
