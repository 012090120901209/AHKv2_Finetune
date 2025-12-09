#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileSetAttrib_ex1.ah2

FileSetAttrib("+RH", "C:\MyFiles\*.*", "DF") ; +RH is identical to +R+H
