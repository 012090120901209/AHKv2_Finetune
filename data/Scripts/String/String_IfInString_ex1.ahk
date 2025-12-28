#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_IfInString_ex1.ah2

Haystack := "z.y.x.w"
if InStr(Haystack, "y.x") mouse_btns := SysGet(43)
    MsgBox(mouse_btns)
