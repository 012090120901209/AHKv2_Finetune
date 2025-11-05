#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: External Libraries/NumputInNumput_Inline.ah2 MyVar := Buffer(16, 0) ; if 'MyVar' is a UTF-16 string, use 'VarSetStrCapacity(&MyVar, 16)' and replace all instances of 'MyVar.Ptr' with 'StrPtr(MyVar)'
NumPut("int", 4, "int", 3, "int", 2, "int", 1, MyVar)
