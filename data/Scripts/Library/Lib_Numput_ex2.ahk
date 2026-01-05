#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/Numput_ex2.ah2

NumPut("UInt", (WINDOWPLACEMENT := Buffer(44, 0)).Size, WINDOWPLACEMENT, 0) ; if 'WINDOWPLACEMENT' is a UTF-16 string, use 'VarSetStrCapacity(&WINDOWPLACEMENT, 44)' and replace all instances of 'WINDOWPLACEMENT.Ptr' with 'StrPtr(WINDOWPLACEMENT)'
