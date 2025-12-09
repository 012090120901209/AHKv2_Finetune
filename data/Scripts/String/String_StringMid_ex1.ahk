#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_StringMid_ex1.ah2

InputVar := "Count is missing, so L goes to 1"
OutputVar := SubStr(InputVar, 1, 16)
MsgBox(OutputVar)
