#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/MsgBox_smart-mode-mix-2.ah2

; 1-param mode
MsgBox("1")

; 1-param mode with embedded newlines
MsgBox("a, 22,`n( 33 ), 44")

; 4-param mode examples
MsgBox("", "22`n( )", 1)
MsgBox("33", "Title", 1)
MsgBox("33", "Title", "1 T44")
MsgBox("33`n), dd", "Title", 1)
MsgBox("33`n), 44, 55", "Title", 1)
