#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_QuotedObjLiterals_ex1.ah2

obj := { keyA: "valueA" }
MsgBox(obj.keyA) obj := { keyB: "valueB" }
MsgBox(obj.keyB)
