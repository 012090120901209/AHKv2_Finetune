#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_StringCaseSense_ex2.ah2

A_StringCaseSense := true var := "abc" if InStr(var, "ABC", A_StringCaseSense) MsgBox("true") msg := InStr(var, "ABC", A_StringCaseSense) - 1
    MsgBox(msg) msg := StrReplace(var, "ABC", , A_StringCaseSense, , 1)
MsgBox(msg) msg := StrReplace("aA", "A", , A_StringCaseSense)
MsgBox(msg) msg := InStr("aA", "A", A_StringCaseSense)
MsgBox(msg)
