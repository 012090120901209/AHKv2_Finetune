#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Gui_pr_137_fixed.ah2

myGui := Gui()
myGui.Add("DDL", "Choose5", ["1", "2", "3", "4", "", "", "5"])
myGui.Add("DDL", "Choose7", ["6", "", "7", "", "8", "", "9"])
myGui.Show()
