#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/IfExists_ex1.ah2

if FileExist("C:\")
    MsgBox("The drive exists.")