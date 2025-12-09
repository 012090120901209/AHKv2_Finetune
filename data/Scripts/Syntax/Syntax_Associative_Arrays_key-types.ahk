#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: #Usage_and_Syntax/Associative_Arrays_key-types.ah2

array1 := map("ten", 10, "twenty", 20)
For key, value in array1 MsgBox(key " = " value)
