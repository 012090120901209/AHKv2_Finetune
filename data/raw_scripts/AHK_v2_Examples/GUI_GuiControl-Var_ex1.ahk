#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/GuiControl-Var_ex1.ah2 myGui := Gui()
ogcButtonButton1 := myGui.Add("Button", , "Button 1")
ogcButtonButton1.OnEvent("Click", b1.Bind("Normal"))
ogcEdite1 := myGui.Add("Edit", "ve1", "Some Text")
myGui.Show()
b1()
b1(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { Var := "Focus" ; This fix works with focus, others won't ogcEdite1.%var%() ; SubCommand passed as variable, check variable contents and docs
}
