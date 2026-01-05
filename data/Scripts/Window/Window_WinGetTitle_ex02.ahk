#Requires AutoHotkey v2.0
#SingleInstance Force

title := WinGetTitle("A")
WinGetPos(&x, &y, &w, &h, "A")
FileAppend(title "-" w "-" h "-" x "-" y, "*")
