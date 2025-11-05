#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex1.ah2 VarSetStrCapacity(&MyVar, 10240000) ; if 'MyVar' is NOT a UTF-16 string, use 'MyVar := Buffer(10240000)' and replace all instances of 'StrPtr(MyVar)' with 'MyVar.Ptr'
