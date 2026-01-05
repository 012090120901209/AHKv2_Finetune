#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/LoopParse_issue_77.ah2

prefix := "dyn"
dyn_dynamic := "a, b" Loop Parse, dyn_dynamic, ", " MsgBox(A_LoopField) Loop Parse, %prefix%_dynamic, ", " MsgBox(A_LoopField) Loop Parse, %prefix%_dynamic, ", " MsgBox(A_LoopField)
