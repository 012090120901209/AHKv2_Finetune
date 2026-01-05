#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Gui_ListWithVar_ex1.ah2

MyArr := "a|b|c"
myGui := Gui()
myGui.Add("DDL", "x10", StrSplit(MyArr, "|")) ; Check that this DDL has the correct choose value
myGui.Show()
