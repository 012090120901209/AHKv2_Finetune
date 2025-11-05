#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinSet_ex6.ah2 Persistent
SetTimer(WatchForMenu, 5)
return ; End of auto-execute section. WatchForMenu()
WatchForMenu() { DetectHiddenWindows(true) ; Might allow detection of menu sooner. if WinExist("ahk_class #32768") WinSetTransparent(150) ; Uses the window found by the above line.
}
