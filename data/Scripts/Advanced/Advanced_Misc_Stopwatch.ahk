#Requires AutoHotkey v2.0
#SingleInstance Force
; Stopwatch Timer with Lap Times
Persistent
stopGui := Gui()
stopGui.Title := "Stopwatch"

timeDisplay := stopGui.Add("Text", "x10 y10 w200 h40 Center", "00:00:00.000")
timeDisplay.SetFont("s20 Bold", "Consolas")

stopGui.Add("Button", "x10 y60 w60", "Start").OnEvent("Click", StartTimer)
stopGui.Add("Button", "x80 y60 w60", "Stop").OnEvent("Click", StopTimer)
stopGui.Add("Button", "x150 y60 w60", "Reset").OnEvent("Click", ResetTimer)
stopGui.Add("Button", "x10 y90 w200", "Lap").OnEvent("Click", AddLap)

lapList := stopGui.Add("ListBox", "x10 y120 w200 h150")

stopGui.Show("w220 h285")

global startTime := 0
global elapsed := 0
global isRunning := false
global lapCount := 0

StartTimer(*) {
    global startTime, isRunning
    if (!isRunning) {
        startTime := A_TickCount - elapsed
        isRunning := true
        SetTimer(UpdateDisplay, 10)
    }
}

StopTimer(*) {
    global isRunning
    isRunning := false
    SetTimer(UpdateDisplay, 0)
}

ResetTimer(*) {
    global startTime, elapsed, isRunning, lapCount
    StopTimer()
    startTime := 0
    elapsed := 0
    lapCount := 0
    timeDisplay.Value := "00:00:00.000"
    lapList.Delete()
}

AddLap(*) {
    global lapCount
    if (isRunning) {
        lapCount++
        lapList.Add(["Lap " lapCount ": " timeDisplay.Value])
    }
}

UpdateDisplay() {
    global elapsed
    elapsed := A_TickCount - startTime

    ms := Mod(elapsed, 1000)
    seconds := Mod(elapsed // 1000, 60)
    minutes := Mod(elapsed // 60000, 60)
    hours := elapsed // 3600000

    timeDisplay.Value := Format("{:02}:{:02}:{:02}.{:03}", hours, minutes, seconds, ms)
}
