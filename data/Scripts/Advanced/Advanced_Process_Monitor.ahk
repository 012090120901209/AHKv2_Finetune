#Requires AutoHotkey v2.0
#SingleInstance Force
; Process Monitor and Manager
Persistent
procGui := Gui()
procGui.Title := "Process Monitor"
LV := procGui.Add("ListView", "x10 y10 w580 h300", ["Process Name", "PID", "Memory (KB)"])
procGui.Add("Button", "x10 y320 w100", "Refresh").OnEvent("Click", RefreshProc)
procGui.Add("Button", "x120 y320 w100", "Kill Process").OnEvent("Click", KillProc)
procGui.Add("Checkbox", "x240 y322 vAutoRefresh", "Auto-refresh").OnEvent("Click", ToggleAuto)
procGui.Show("w600 h360")

SetTimer(RefreshProc, 2000)
RefreshProc()

RefreshProc(*) {
    if (!procGui["AutoRefresh"].Value)
    return

    LV.Delete()

    for proc in ComObjGet("winmgmts:").ExecQuery("SELECT * FROM Win32_Process") {
        try LV.Add(, proc.Name, proc.ProcessId, Round(proc.WorkingSetSize/1024))
    }

    LV.ModifyCol()
}

KillProc(*) {
    row := LV.GetNext()
    if (!row)
    return

    pid := LV.GetText(row, 2)
    name := LV.GetText(row, 1)

    result := MsgBox("Kill process " name " (PID: " pid ")?", "Confirm", "YesNo Icon?")
    if (result = "Yes") {
        ProcessClose(pid)
        RefreshProc()
    }
}

ToggleAuto(*) {
    if (procGui["AutoRefresh"].Value) {
        SetTimer(RefreshProc, 2000)
    } else {
        SetTimer(RefreshProc, 0)
    }
}
