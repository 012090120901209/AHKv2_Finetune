#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/Numput.ah2

MyVar := Buffer(4, 0) ; if 'MyVar' is a UTF-16 string, use 'VarSetStrCapacity(&MyVar, 4)' and replace all instances of 'MyVar.Ptr' with 'StrPtr(MyVar)'
NumPut("int", 1, MyVar)
