#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_QuotedObjLiteral-WithVar.ah2

var := "C"
obj := {key%var%: "valueC"}
MsgBox(obj.keyC)
