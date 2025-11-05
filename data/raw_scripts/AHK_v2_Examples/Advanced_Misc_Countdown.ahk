#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Countdown Timer with Alerts
Persistent
countGui := Gui()
countGui.Title := "Countdown Timer"

countGui.Add("Text", "x10 y10", "Minutes:")
minutesInput := countGui.Add("Edit", "x80 y7 w60 Number", "5")
countGui.Add("Text", "x150 y10", "Seconds:")
secondsInput := countGui.Add("Edit", "x220 y7 w60 Number", "0")

timeDisplay := countGui.Add("Text", "x10 y40 w270 h50 Center", "00:00")
timeDisplay.SetFont("s30 Bold", "Consolas")

countGui.Add("Button", "x10 y100 w80", "Start").OnEvent("Click", StartCountdown)
countGui.Add("Button", "x100 y100 w80", "Pause").OnEvent("Click", PauseCountdown)
countGui.Add("Button", "x190 y100 w90", "Reset").OnEvent("Click", ResetCountdown)

countGui.Show("w290 h140")

global totalSeconds := 0
global remaining := 0
global isCountdown := false

StartCountdown(*) {
    global totalSeconds, remaining, isCountdown
    
    if (!isCountdown) {
        mins := Integer(minutesInput.Value)
        secs := Integer(secondsInput.Value)
        totalSeconds := mins * 60 + secs
        remaining := totalSeconds
        isCountdown := true
        SetTimer(UpdateCountdown, 1000)
    }
}

PauseCountdown(*) {
    global isCountdown
    isCountdown := false
    SetTimer(UpdateCountdown, 0)
}

ResetCountdown(*) {
    global remaining, totalSeconds, isCountdown
    PauseCountdown()
    remaining := totalSeconds
    UpdateDisplay()
}

UpdateCountdown() {
    global remaining
    
    if (remaining > 0) {
        remaining--
        UpdateDisplay()
    } else {
        PauseCountdown()
        MsgBox("Time's up!", "Countdown Complete", "Iconi T3")
        SoundBeep(1000, 500)
    }
}

UpdateDisplay() {
    global remaining
    mins := remaining // 60
    secs := Mod(remaining, 60)
    timeDisplay.Value := Format("{:02}:{:02}", mins, secs)
}
