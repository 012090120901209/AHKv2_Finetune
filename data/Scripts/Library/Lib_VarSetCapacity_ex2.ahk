#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/VarSetCapacity_ex2.ah2

vTarget := Buffer(RequestedCapacity, FillByte) ; if 'vTarget' is a UTF-16 string, use 'VarSetStrCapacity(&vTarget, RequestedCapacity)' and replace all instances of 'vTarget.Ptr' with 'StrPtr(vTarget)'
