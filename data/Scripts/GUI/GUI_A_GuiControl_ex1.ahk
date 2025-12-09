#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/A_GuiControl_ex1.ah2

myGui := Gui()
ogcButtonName := myGui.Add("Button", "w100", "Name")
ogcButtonName.OnEvent("Click", ButtonName.Bind("Normal"))
ogcEditTestnTest := myGui.Add("Edit", "R2 w100", "Test`nTest")
ogcEditTestnTest.OnEvent("Change", ButtonName.Bind("Normal"))
myGui.Show("w120")
ButtonName()
ButtonName(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { A_GuiControl := HasProp(A_GuiControl, "Text") ? A_GuiControl.Text : A_GuiControl MsgBox("A_GuiEvent: " A_GuiEvent "`nA_GuiControl: " A_GuiControl)
}
