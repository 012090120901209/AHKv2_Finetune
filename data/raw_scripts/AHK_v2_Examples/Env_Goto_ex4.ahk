#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Environment_Goto_ex4.ah2 myGui := Gui()
ogcButtonbtn := myGui.Add("Button", , "btn")
ogcButtonbtn.OnEvent("Click", Lbl.Bind("Normal"))
myGui.Show() Goto("Lbl")
;Goto, Lbl Lbl()
Lbl(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox()
}
