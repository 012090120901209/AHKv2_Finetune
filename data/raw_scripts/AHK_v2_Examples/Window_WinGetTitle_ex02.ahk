#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; title := WinGetTitle("A")
WinGetPos(&x, &y, &w, &h, "A")
FileAppend(title "-" w "-" h "-" x "-" y, "*")
