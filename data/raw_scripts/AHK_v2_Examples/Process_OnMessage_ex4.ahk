#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Process_OnMessage_ex4.ah2 myGui := Gui()
myGui.OnEvent("Close", GuiClose)
myGui.Add("Text", , "Click anywhere in this window.")
ogcMyEdit := myGui.Add("Edit", "w200 vMyEdit")
myGui.Show()
On()
^l:: Off() WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) { X := lParam & 0xFFFF Y := lParam >> 16 ToolTip("You left-clicked in Gui window at client coordinates x" X "y" Y)
} GuiClose()
ExitApp()
Off() { ToolTip() OnMessage(0x0201, WM_LBUTTONDOWN, 0)
} On() { OnMessage(0x0201, WM_LBUTTONDOWN)
}
GuiClose(*) { ExitApp()
}
