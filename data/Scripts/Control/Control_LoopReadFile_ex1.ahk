#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/LoopReadFile_ex1.ah2
;FileDelete, C:\Docs\Family Addresses.txt Loop read, "C:\Docs\Address List.txt", "C:\Docs\Family Addresses.txt"
{
    if InStr(A_LoopReadLine, "family") FileAppend(A_LoopReadLine "`n")
}
