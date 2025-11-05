#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Always on Top Manager
Persistent
A_TrayMenu.Add("Toggle Always On Top", ToggleAOT)
A_TrayMenu.Default := "Toggle Always On Top"

^!Space::ToggleAOT()

ToggleAOT(*) {
    activeWin := WinExist("A")
    style := WinGetExStyle(activeWin)
    
    if (style & 0x8) {  ; WS_EX_TOPMOST
        WinSetAlwaysOnTop(0, activeWin)
        TrayTip("Always on Top: OFF", WinGetTitle(activeWin))
    } else {
        WinSetAlwaysOnTop(1, activeWin)
        TrayTip("Always on Top: ON", WinGetTitle(activeWin))
    }
}
