#Requires AutoHotkey v2.0
#SingleInstance Force

OutputVar := WinGetTitle("A")
FileAppend(OutputVar, "*")
