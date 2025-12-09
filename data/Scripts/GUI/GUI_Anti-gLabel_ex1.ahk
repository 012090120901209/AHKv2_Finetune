#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Anti-gLabel_ex1.ah2

greenGuiMargin := 16 myGui := Gui()
myGui.MarginX := greenGuiMargin, myGui.MarginY := greenGuiMargin
myGui.SetFont("s22", "Georgia")
myGui.Add("Text", , "Hello World ! ")
myGui.Title := "Anti gLabel Test"
myGui.Show("w256 h256")
