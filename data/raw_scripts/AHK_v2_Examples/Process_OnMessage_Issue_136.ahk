#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Process_OnMessage_Issue_136.ah2 myGui := Gui()
myGui.OnEvent("Close", GuiClose)
myGui.Add("Text", , "Click anywhere in this window.")
ogcMyEdit := myGui.Add("Edit", "w200 vMyEdit")
myGui.Show()
OnMessage(0x0201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) { ToolTip("GUI Clicked")
} F5:: HK1_F5()
GuiClose()
ExitApp()
HK1_F5() { OnMessage(0x0201, WM_LBUTTONDOWN, 0)
}
GuiClose(*) { ExitApp()
}
