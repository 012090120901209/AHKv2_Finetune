#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: File, Directory and Disk/DriveSpaceFree_ex1.ah2 FreeSpace := DriveGetSpaceFree("C:\")
MsgBox(FreeSpace)
