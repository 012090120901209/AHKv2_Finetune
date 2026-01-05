#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/LoopReadFile_ex2.ah2

Loop read, "C:\Log File.txt" last_line := A_LoopReadLine ; When loop finishes, this will hold the last line.
