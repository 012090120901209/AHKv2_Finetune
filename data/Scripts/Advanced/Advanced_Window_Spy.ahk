#Requires AutoHotkey v2.0
#SingleInstance Force
; Window Spy Tool (like AU3 Window Spy)
Persistent
spyGui := Gui("+AlwaysOnTop")
spyGui.Title := "Window Spy"

spyGui.Add("Text", "x10 y10", "Window Title:")
titleText := spyGui.Add("Edit", "x100 y7 w300 ReadOnly")

spyGui.Add("Text", "x10 y40", "Class:")
classText := spyGui.Add("Edit", "x100 y37 w300 ReadOnly")

spyGui.Add("Text", "x10 y70", "Process:")
procText := spyGui.Add("Edit", "x100 y67 w300 ReadOnly")

spyGui.Add("Text", "x10 y100", "PID:")
pidText := spyGui.Add("Edit", "x100 y97 w100 ReadOnly")

spyGui.Add("Text", "x10 y130", "Position:")
posText := spyGui.Add("Edit", "x100 y127 w200 ReadOnly")

spyGui.Add("Text", "x10 y160", "Size:")
sizeText := spyGui.Add("Edit", "x100 y157 w200 ReadOnly")

spyGui.Add("Text", "x10 y190", "Mouse Position:")
mouseText := spyGui.Add("Edit", "x120 y187 w180 ReadOnly")

spyGui.Add("Checkbox", "x10 y220 vAutoUpdate Checked", "Auto-update").OnEvent("Click", ToggleUpdate)

spyGui.Show("w410 h260")

SetTimer(UpdateInfo, 100)

UpdateInfo() {
    if (!spyGui["AutoUpdate"].Value)
        return

    try {
        MouseGetPos(&mx, &my, &winId)

        title := WinGetTitle("ahk_id " winId)
        class := WinGetClass("ahk_id " winId)
        proc := WinGetProcessName("ahk_id " winId)
        pid := WinGetPID("ahk_id " winId)

        WinGetPos(&x, &y, &w, &h, "ahk_id " winId)

        titleText.Value := title
        classText.Value := class
        procText.Value := proc
        pidText.Value := pid
        posText.Value := "X: " x " Y: " y
        sizeText.Value := "W: " w " H: " h
        mouseText.Value := "X: " mx " Y: " my
    }
}

ToggleUpdate(*) {
    if (spyGui["AutoUpdate"].Value) {
        SetTimer(UpdateInfo, 100)
    } else {
        SetTimer(UpdateInfo, 0)
    }
}
