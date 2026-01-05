#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex3.ah2

vTarget := Buffer(RequestedCapacity, FillByte) ; if 'vTarget' is a UTF-16 string, use 'VarSetStrCapacity(&vTarget, RequestedCapacity)' and replace all instances of 'vTarget.Ptr' with 'StrPtr(vTarget)' NB ! if this is part of a control flow block without {}, please enclose this and the next line in {} !
