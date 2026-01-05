#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: File, Directory and Disk/FileCreateShortcut_ex1.ah2

FileCreateShortcut("Notepad.exe", A_Desktop "\My Shortcut.lnk", "C:\", "`"" A_ScriptFullPath "`"", "My Description", "C:\My Icon.ico", "i")
