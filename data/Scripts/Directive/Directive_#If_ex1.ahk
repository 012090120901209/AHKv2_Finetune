#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: _Directives/#If_ex1.ah2
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")

WheelUp:: Send("{Volume_Up}")
WheelDown:: Send("{Volume_Down}") MouseIsOver(WinTitle) {
    MouseGetPos(, , &Win) return WinExist(WinTitle . " ahk_id " . Win)
}
