#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/GuiExample1.ah2 myGui := Gui()
myGui.Add("Text", , "Please enter your name:")
ogcEditName := myGui.Add("Edit", "vName")
myGui.Show()
