#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Ternary_ex2.ah2

a := b ? "" : (c = "" ? "" : " ")
a .= b ? "" : (c = "" ? "" : " ")
