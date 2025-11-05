#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/GuiControl-Font_ex1.ah2 myGui := Gui()
ogcMyEdit := myGui.Add("Edit", "vMyEdit w100 h100", "Test")
myGui.SetFont("s30 cRed", "Verdana") ; If desired, use a line like this to set a new default font for the window.
ogcMyEdit.SetFont("s30 cRed", "Verdana") ; Put the above font into effect for a control.
myGui.Show()
