#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Source: #Usage_and_Syntax/Associative_Arrays_ex1.ah2
array1 := Map("ten", 10, "twenty", 20, "thirty", 30)
For key, value in array1
    MsgBox(key " = " value)
