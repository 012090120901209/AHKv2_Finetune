#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/IfExists_ex2.ah2

if FileExist("D:\Docs\*.txt")
    MsgBox("At least one .txt file exists.")