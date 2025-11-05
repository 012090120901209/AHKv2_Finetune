#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex12.ah2 char := Buffer(4, 0) ; if 'char' is a UTF-16 string, use 'VarSetStrCapacity(&char, 4)' and replace all instances of 'char.Ptr' with 'StrPtr(char)'
MsgBox(char.Ptr)
; MsgBox % &char
