#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-Cancel_ex1.ah2 myGui := Gui()
ogcButtonOK := myGui.Add("Button", , "OK")
ogcButtonOK.OnEvent("Click", ButtonOK.Bind("Normal"))
myGui.Show()
ButtonOK()
ButtonOK(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { myGui.Hide()
}
