#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-New-Opt.ah2

myGui := Gui()
ogcButton := myGui.Add("Button", "+Owner" . ThisHwnd) myGui1 := Gui("+Owner" . ThisHwnd, "Gui Name")
