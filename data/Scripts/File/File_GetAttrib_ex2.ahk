#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileGetAttrib_ex2.ah2

Attributes := FileGetAttrib("C:\My File.txt")
if InStr(Attributes, "H")
    MsgBox("The file is hidden.")
