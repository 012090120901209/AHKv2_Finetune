#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-Hwnd_ex1.ah2 myGui := Gui()
myVar := myGui.Hwnd
myGui.Opt("+AlwaysOnTop -Caption +Owner +LastFound"), myVar := myGui.Hwnd
myGui.Opt("+AlwaysOnTop -Caption +Owner +LastFound"), myVar := myGui.Hwnd
myGui.Opt("+AlwaysOnTop -Caption +Owner +LastFound"), myVar := myGui.Hwnd var1 := myGui.Hwnd, var2 := myGui.Hwnd
myGui.Opt("-Caption"), var1 := myGui.Hwnd, var2 := myGui.Hwnd
myGui.Opt("+AlwaysOnTop -Caption +Owner +LastFound"), var1 := myGui.Hwnd, var2 := myGui.Hwnd
