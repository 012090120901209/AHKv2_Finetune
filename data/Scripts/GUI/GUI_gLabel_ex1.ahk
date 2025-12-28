#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/gLabel_ex1.ah2

myGui := Gui()
ogcButtonThing := myGui.Add("Button", "vThing", "Thing")
ogcButtonThing.OnEvent("Click", Thing.Bind("Normal"))
myGui.Show()
Thing()
Thing(A_GuiEvent := "", A_GuiControl := "", Info := "", *) {
    MsgBox("Thing")
}
