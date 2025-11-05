#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Window Arranger: Organize multiple windows
arrangeGui := Gui()
arrangeGui.Title := "Window Arranger"
LV := arrangeGui.Add("ListView", "x10 y10 w500 h200", ["Title", "Class", "PID"])
arrangeGui.Add("Button", "x10 y220 w100", "Refresh").OnEvent("Click", RefreshWindows)
arrangeGui.Add("Button", "x120 y220 w100", "Tile Left").OnEvent("Click", (*) => TileWindow("left"))
arrangeGui.Add("Button", "x230 y220 w100", "Tile Right").OnEvent("Click", (*) => TileWindow("right"))
arrangeGui.Add("Button", "x340 y220 w80", "Maximize").OnEvent("Click", MaxWin)
arrangeGui.Add("Button", "x430 y220 w80", "Minimize").OnEvent("Click", MinWin)
arrangeGui.Show("w520 h260")

RefreshWindows()

RefreshWindows(*) {
    LV.Delete()
    ids := WinGetList(,,)
    for id in ids {
        try {
            title := WinGetTitle("ahk_id " id)
            class := WinGetClass("ahk_id " id)
            pid := WinGetPID("ahk_id " id)
            if (title != "")
                LV.Add(, title, class, pid)
        }
    }
    LV.ModifyCol()
}

TileWindow(side) {
    row := LV.GetNext()
    if (!row)
        return
    pid := LV.GetText(row, 3)
    WinActivate("ahk_pid " pid)
    
    if (side = "left")
        WinMove(0, 0, A_ScreenWidth//2, A_ScreenHeight, "A")
    else
        WinMove(A_ScreenWidth//2, 0, A_ScreenWidth//2, A_ScreenHeight, "A")
}

MaxWin(*) {
    row := LV.GetNext()
    if (row) {
        pid := LV.GetText(row, 3)
        WinMaximize("ahk_pid " pid)
    }
}

MinWin(*) {
    row := LV.GetNext()
    if (row) {
        pid := LV.GetText(row, 3)
        WinMinimize("ahk_pid " pid)
    }
}
