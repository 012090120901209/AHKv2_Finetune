#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/DriveSpaceFree_ex1.ah2

FreeSpace := DriveGetSpaceFree("C:\")
MsgBox(FreeSpace)
