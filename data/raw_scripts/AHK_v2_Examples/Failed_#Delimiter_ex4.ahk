#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

; Source: Failed_Conversions_Delimiter_ex4.ah2

MsgBox("Test")
MsgBox("Test `; This-is-not-a-comment")
MsgBox("Not options first - So delimiters don't need to be escaped")
MsgBox("Or in this case- replaced")
