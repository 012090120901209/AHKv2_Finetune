#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/Input_ex3.ah2 ihVar := InputHook("T3", "f"), ihVar.Start(), ErrorLevel := ihVar.Wait(), Var := ihVar.Input
if (ErrorLevel = "Timeout") MsgBox("Timeout")
