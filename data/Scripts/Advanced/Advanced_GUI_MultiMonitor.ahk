#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: Multi-Monitor Information Display
; Demonstrates: Monitor detection, SysGet, MonitorGet, displaying system info

myGui := Gui()
myGui.Title := "Multi-Monitor Information"

myGui.Add("Text", "x10 y10 w400", "System Monitor Configuration:")

; Get monitor count
monitorCount := MonitorGetCount()
primaryMonitor := MonitorGetPrimary()

myGui.Add("Text", "x10 y35", "Total Monitors:")
myGui.Add("Edit", "x120 y32 w50 ReadOnly", monitorCount)

myGui.Add("Text", "x180 y35", "Primary:")
myGui.Add("Edit", "x245 y32 w50 ReadOnly", primaryMonitor)

; Virtual screen size
myGui.Add("Text", "x10 y65", "Virtual Screen Size:")
myGui.Add("Edit", "x140 y62 w120 ReadOnly", A_ScreenWidth " x " A_ScreenHeight)

myGui.Add("GroupBox", "x10 y95 w460 h250", "Monitor Details")

yPos := 115

; List all monitors
Loop monitorCount {
    monNum := A_Index

    ; Get monitor bounds
    MonitorGet(monNum, &Left, &Top, &Right, &Bottom)
    width := Right - Left
    height := Bottom - Top

    ; Get work area (excluding taskbar)
    MonitorGetWorkArea(monNum, &WLeft, &WTop, &WRight, &WBottom)
    workWidth := WRight - WLeft
    workHeight := WBottom - WTop

    ; Monitor label
    isPrimary := (monNum = primaryMonitor) ? " (Primary)" : ""
    myGui.SetFont("Bold")
    myGui.Add("Text", "x20 y" yPos, "Monitor " monNum isPrimary ":")
    myGui.SetFont()

    ; Monitor info
    yPos += 25
    info := "Position: (" Left ", " Top ")  Size: " width " x " height "`n"
    info .= "Work Area: " workWidth " x " workHeight
    myGui.Add("Text", "x30 y" yPos, info)

    yPos += 45
}

; DPI Information
myGui.Add("GroupBox", "x10 y355 w460 h70", "DPI & Scaling")
myGui.Add("Text", "x20 y375", "Screen DPI:")
myGui.Add("Edit", "x100 y372 w80 ReadOnly", A_ScreenDPI)

scaling := Round((A_ScreenDPI / 96) * 100)
myGui.Add("Text", "x200 y375", "Scaling:")
myGui.Add("Edit", "x260 y372 w80 ReadOnly", scaling "%")

; Button to show current mouse monitor
myGui.Add("Button", "x10 y435 w150", "Current Mouse Monitor").OnEvent("Click", ShowMouseMonitor)
myGui.Add("Button", "x170 y435 w150", "Refresh").OnEvent("Click", (*) => (myGui.Destroy(), ReloadScript()))
myGui.Add("Button", "x330 y435 w140", "Copy Info").OnEvent("Click", CopyInfo)

myGui.Show("w480 h475")

ShowMouseMonitor(*) {
    MouseGetPos(&mouseX, &mouseY)

    Loop MonitorGetCount() {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)

        if (mouseX >= Left && mouseX < Right && mouseY >= Top && mouseY < Bottom) {
            MsgBox("Mouse is on Monitor " A_Index "`nPosition: (" mouseX ", " mouseY ")", "Mouse Monitor")
            return
        }
    }

    MsgBox("Could not determine monitor", "Error")
}

CopyInfo(*) {
    info := "Multi-Monitor Configuration`n"
    info .= "Total Monitors: " monitorCount "`n"
    info .= "Primary Monitor: " primaryMonitor "`n"
    info .= "Virtual Screen: " A_ScreenWidth " x " A_ScreenHeight "`n"
    info .= "DPI: " A_ScreenDPI " (Scaling: " Round((A_ScreenDPI / 96) * 100) "%)`n`n"

    Loop monitorCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        width := Right - Left
        height := Bottom - Top
        info .= "Monitor " A_Index ": " width " x " height " at (" Left ", " Top ")`n"
    }

    A_Clipboard := info
    ToolTip("Monitor info copied to clipboard!")
    SetTimer(() => ToolTip(), -2000)
}

ReloadScript() {
    Reload
}
