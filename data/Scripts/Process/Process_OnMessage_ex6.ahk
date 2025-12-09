#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_OnMessage_ex6.ah2

Persistent myGui := Gui()
myGui.Show("w100 h100") var := "WM_LBUTTONDOWN"
OnMessage(0x201, %var%)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) { MsgBox("LClicked")
}
