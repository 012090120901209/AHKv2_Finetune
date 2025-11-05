#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-Hwnd_ex3.ah2 myGui := Gui()
ListBox1 := myGui.Add("ListBox", "w300 h200"), hOutput := ListBox1.hwnd
myGui.Show()
MsgBox(hOutput)
