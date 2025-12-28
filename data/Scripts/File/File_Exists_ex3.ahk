#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileExists_ex3.ah2

if !FileExist("C:\Temp\FlagFile.txt") MsgBox("The target file does not exist.")
