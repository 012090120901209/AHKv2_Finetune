#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: File, Directory and Disk/FileObj_ex1.ah2 FileObj := FileOpen("testV2.ahk", "w") MsgBox(FileObj.Handle "`n" FileObj.Handle) FileObj.Pos := 2
MsgBox(FileObj.Pos "`n" FileObj.Pos) MsgBox(FileObj.Pos)
