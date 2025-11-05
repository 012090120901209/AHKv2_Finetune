#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Process_OnMessage_ex8.ah2 Persistent myGui := Gui()
myGui.Show("w100 h100") OnMessage(0x201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(a, b, msg, hwnd) { ToolTip(a "`n" b)
} var := "value"
OnMessage(0x204, WM_RBUTTONDOWN.Bind(var))
WM_RBUTTONDOWN(bindedParam, wParam, lParam, msg, hwnd) { ToolTip(bindedParam "`n" wParam "`n" lParam)
}
