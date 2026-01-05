#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-Hwnd_ex5.ah2

myGui := Gui()
myGui.Add("Text", , "Test")
if 1
{
    ogcabcVar := myGui.Add("Edit", , "abc")
    Var := ogcabcVar.hwnd
}
else
{
    MsgBox("else")
}
myGui.Show()
