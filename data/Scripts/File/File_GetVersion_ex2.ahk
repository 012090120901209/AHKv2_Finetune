#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileGetVersion_ex2.ah2

Version := FileGetVersion(A_ProgramFiles "\AutoHotkey\AutoHotkey.exe")
MsgBox(Version)
