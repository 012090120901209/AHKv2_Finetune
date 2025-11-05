#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_WinGet_ex4.ah2 Persistent
SetTimer(WatchActiveWindow, 200)
WatchActiveWindow()
WatchActiveWindow() { oControlList := WinGetControls("A", ,, ) For v in oControlList { ControlList . = A_index = 1 ? v : "`r`n" v } ToolTip(ControlList)
}
