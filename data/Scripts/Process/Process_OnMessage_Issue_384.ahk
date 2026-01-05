#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_OnMessage_Issue_384.ah2
; https://github.com/mmikeww/AHK-v2-script-converter/issues/384
OnMessage(MsgNum, ShellMessage)

ShellMessage(wParam, lParam, msg, hwnd) {
    if !(wParam ~= "^(?i:" RegExReplace(RegExReplace(Filters, "[\\\.\*\?\+\[\{\|\(\)\^\$]", "\$0"), "\h*, \h*", "|") ")$") {
        ; Add any handling needed here
    }
}

OnMessage(WM_NOTIFY := 0x4E, LV_NOTIFY)

LV_NOTIFY(wParam, lParam, msg, hwnd) {
    MsgBox("add missing params and preserve originals")
}
