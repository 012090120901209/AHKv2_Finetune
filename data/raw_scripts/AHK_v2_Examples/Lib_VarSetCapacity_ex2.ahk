#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex2.ah2 vTarget := Buffer(RequestedCapacity, FillByte) ; if 'vTarget' is a UTF-16 string, use 'VarSetStrCapacity(&vTarget, RequestedCapacity)' and replace all instances of 'vTarget.Ptr' with 'StrPtr(vTarget)'
