#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinGet_ex4.ah2

Persistent
SetTimer(WatchActiveWindow, 200)
WatchActiveWindow()
WatchActiveWindow() {
    oControlList := WinGetControls("A")
    ControlList := ""
    for v in oControlList {
        ControlList .= (A_index = 1 ? "" : "`r`n") . v
    }
    ToolTip(ControlList)
}
