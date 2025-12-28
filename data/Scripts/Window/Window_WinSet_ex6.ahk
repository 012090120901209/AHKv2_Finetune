#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinSet_ex6.ah2

Persistent
SetTimer(WatchForMenu, 5)
return ; End of auto-execute section. WatchForMenu()
WatchForMenu() {
    DetectHiddenWindows(true)
    if WinExist("ahk_class #32768")
        WinSetTransparent(150)
}
