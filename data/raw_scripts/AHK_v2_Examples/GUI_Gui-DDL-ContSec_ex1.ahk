#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-DDL-ContSec_ex1.ah2 myGui := Gui()
myGui.Add("DDL", "Choose5", ["A", "B", "C", "D", "E", "F"])
MsgBox("Line 1") myGui.Add("DDL", "Choose6", ["A", "B", "C", "D", "E", "F"]) MsgBox("Line 2") myGui.Show()
