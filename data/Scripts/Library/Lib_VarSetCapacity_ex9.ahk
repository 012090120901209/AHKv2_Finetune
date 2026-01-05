#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex9.ah2

vsv1 := Buffer(1, 0) ; if 'vsv1' is a UTF-16 string, use 'VarSetStrCapacity(&vsv1, 1)' and replace all instances of 'vsv1.Ptr' with 'StrPtr(vsv1)' NB ! if this is part of a control flow block without {}, please enclose this and the next line in {} ! vsv2 := Buffer(2, 0) ; if 'vsv2' is a UTF-16 string, use 'VarSetStrCapacity(&vsv2, 2)' and replace all instances of 'vsv2.Ptr' with 'StrPtr(vsv2)' NB ! if this is part of a control flow block without {}, please enclose this and the next line in {} ! DllCall("f", "Ptr", vsv1) + DllCall("f", "Ptr", vsv2) ;hello
