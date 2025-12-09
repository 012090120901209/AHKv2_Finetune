#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileExists_ex4.ah2

if InStr(FileExist("C:\My File.txt"), "H") MsgBox("The file is hidden.")
