#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_Goto_ex2.ah2

myGui := Gui()
ogcButtonMakeMsgBox := myGui.Add("Button", , "Make MsgBox")
ogcButtonMakeMsgBox.OnEvent("Click", InitVars.Bind("Normal"))
myGui.Show() ^l:: HK1_l() InitVars(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox("Created MsgBox")
} HK1_l() { InitVars()
}
