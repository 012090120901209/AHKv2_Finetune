#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_OnMessage_ex5.ah2

Persistent myGui := Gui()
myGui.Show("w100 h100") OnMessage(0x201, WM_LBUTTONDOWN)
WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
    MsgBox("LClicked")
} OnMessage(0x204, WM_RBUTTONDOWN.Bind("with bind"))
WM_RBUTTONDOWN(test, wParam, lParam, msg, hwnd) {
    MsgBox("RClicked " test)
} funcName := "WM_KEYDOWN"
OnMessage(0x100, %funcName%)
WM_KEYDOWN(wParam, lParam, msg, hwnd) {
    MsgBox("Key Pressed")
}
