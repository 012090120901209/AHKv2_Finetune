#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/ByRef_ex5.ah2

MyFunc(&Param) {
    ; Stuff
} Param := Buffer(4, 4) ; if 'Param' is a UTF-16 string, use 'VarSetStrCapacity(&Param, 4)' and replace all instances of 'Param.Ptr' with 'StrPtr(Param)'
