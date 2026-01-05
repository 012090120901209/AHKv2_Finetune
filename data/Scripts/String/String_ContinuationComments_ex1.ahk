#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_ContinuationComments_ex1.ah2

; This demonstrates DllCall with parameters
DllCall("Func", "Str", "ABC", "Str", "123", "Str", "DEF")
