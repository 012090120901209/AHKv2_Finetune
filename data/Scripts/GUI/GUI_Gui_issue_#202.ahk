#Requires AutoHotkey v2.0
#SingleInstance Force

guiName := Gui()
guiName.Add("Text", , "text text text text")
ogcButtonAAAA := guiName.Add("Button", "Default", "AAAA")
ogcButtonAAAA.OnEvent("Click", guiNameButtonAAAA.Bind("Normal"))
guiName.Show()

guiName1 := Gui()
guiName1.OnEvent("Close", GuiClose)
guiName1.OnEvent("Escape", GuiClose)
guiName1.Add("Text", , "text2 text2 text2 text2")
ogcButtonBBBB := guiName1.Add("Button", "Default", "BBBB")
ogcButtonBBBB.OnEvent("Click", ButtonBBBB.Bind("Normal"))
guiName1.Show()

guiNameButtonAAAA(A_GuiEvent := "", A_GuiControl := "", Info := "", *) {
	MsgBox("Button AAAA is call")
}

ButtonBBBB(A_GuiEvent := "", A_GuiControl := "", Info := "", *) {
	MsgBox("Button BBBB is call")
}

GuiClose(*) {
	GuiEscape()
}

GuiEscape() {
	ExitApp()
}
