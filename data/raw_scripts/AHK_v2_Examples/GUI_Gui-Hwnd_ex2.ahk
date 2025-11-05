#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/Gui-Hwnd_ex2.ah2 myGui := Gui()
ogcTextC := myGui.Add("Text", "vTextC", "HWND Test")
ogcEditFirstName := myGui.Add("Edit", "vFirstName"), test := ogcEditFirstName.hwnd
ogcButtonSubmit := myGui.Add("Button", , "Submit")
ogcButtonSubmit.OnEvent("Click", Clicked.Bind("Normal"))
myGui.Show()
Clicked()
Clicked(A_GuiEvent := "", A_GuiControl := "", Info := "", *) { MsgBox(test)
}
