#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Array_ex2.ah2

MyArray := ["A", "B", "C"]
Var := 2
MyArray.InsertAt(Var, "4", "5") ; InsertAt for i, v in MyArray MsgBox(v)
