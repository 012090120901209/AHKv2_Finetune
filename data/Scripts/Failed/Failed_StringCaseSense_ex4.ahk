#Requires AutoHotkey v2.0
#SingleInstance Force

; Source: Failed_Conversions_StringCaseSense_ex4.ah2

; Note: This is a failed conversion example - StringCaseSense handling

var1 := "abc"
var2 := "ABC"

if ((A_StringCaseSense && var1 == var2) || (!A_StringCaseSense && var1 = var2))
    MsgBox("Match")
