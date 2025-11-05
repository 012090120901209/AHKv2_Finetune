#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: File, Directory and Disk/FileReadLine_Issue20.ah2 ; fix issue #20
line := StrSplit(FileRead(A_Desktop "\List.txt"), "`n", "`r")[5]
MsgBox(line)
