#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex8.ah2

a := 0
Loop (var := Buffer(16, 0)).Size // 4 ; if 'var' is a UTF-16 string, use 'VarSetStrCapacity(&var, 16)' and replace all instances of 'var.Ptr' with 'StrPtr(var)' a + = 1
    MsgBox("Var's capacity of 16 fits {" a "} 4-byte variables")
