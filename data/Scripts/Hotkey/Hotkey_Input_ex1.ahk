#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/Input_ex1.ah2

CtrlC := Chr(3) ; Store the character for Ctrl-C in the CtrlC var.
ihOutputVar := InputHook("L1 M"), ihOutputVar.Start(), ihOutputVar.Wait(), OutputVar := ihOutputVar.Input
if (OutputVar = CtrlC) MsgBox("You pressed Control-C.")
    ExitApp()
