#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow title := WinGetTitle("A")
WinGetPos(&x, &y, &w, &h, "A")
MsgBox(title "-" w "-" h "-" x "-" y)
