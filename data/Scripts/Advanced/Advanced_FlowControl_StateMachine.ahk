#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced Flow Control Example: State Machine
; Demonstrates: State pattern, FSM implementation, state transitions

Persistent

; State machine for a simple traffic light
global currentState := "RED"
global stateTimer := 0

; State durations (in seconds)
global stateDurations := Map(
"RED", 5,
"GREEN", 5,
"YELLOW", 2
)

; Create GUI
trafficGui := Gui()
trafficGui.Title := "Traffic Light State Machine"

; Traffic light display
redLight := trafficGui.Add("Progress", "x50 y30 w100 h100 BackgroundRed")
yellowLight := trafficGui.Add("Progress", "x50 y140 w100 h100 BackgroundYellow")
greenLight := trafficGui.Add("Progress", "x50 y250 w100 h100 BackgroundGreen")

; State info
stateText := trafficGui.Add("Text", "x170 y30 w200", "Current State: RED")
timerText := trafficGui.Add("Text", "x170 y60 w200", "Time Remaining: 5s")
cycleText := trafficGui.Add("Text", "x170 y90 w200", "Cycles: 0")

; State log
trafficGui.Add("Text", "x170 y120", "State History:")
logText := trafficGui.Add("Edit", "x170 y140 w200 h210 ReadOnly Multi")

; Control buttons
startBtn := trafficGui.Add("Button", "x50 y370 w100", "Start").OnEvent("Click", StartTrafficLight)
stopBtn := trafficGui.Add("Button", "x160 y370 w100", "Stop").OnEvent("Click", StopTrafficLight)
resetBtn := trafficGui.Add("Button", "x270 y370 w100", "Reset").OnEvent("Click", ResetTrafficLight)

stopBtn.Enabled := false

trafficGui.Show("w380 h410")

global isRunning := false
global cycleCount := 0
global stateLog := ""

StartTrafficLight(*) {
    global isRunning, startBtn, stopBtn

    if (isRunning)
    return

    isRunning := true
    startBtn.Enabled := false
    stopBtn.Enabled := true

    SetTimer(UpdateTrafficLight, 100)
    LogState("Started")
}

StopTrafficLight(*) {
    global isRunning, startBtn, stopBtn

    if (!isRunning)
    return

    isRunning := false
    SetTimer(UpdateTrafficLight, 0)

    startBtn.Enabled := true
    stopBtn.Enabled := false

    LogState("Stopped")
}

ResetTrafficLight(*) {
    global currentState, stateTimer, cycleCount, stateLog

    StopTrafficLight()

    currentState := "RED"
    stateTimer := 0
    cycleCount := 0
    stateLog := ""

    UpdateDisplay()
    logText.Value := ""

    LogState("Reset")
}

UpdateTrafficLight() {
    global currentState, stateTimer, isRunning

    if (!isRunning)
    return

    stateTimer += 0.1

    ; Check if state should transition
    if (stateTimer >= stateDurations[currentState]) {
        TransitionState()
        stateTimer := 0
    }

    UpdateDisplay()
}

TransitionState() {
    global currentState, cycleCount

    ; State transition logic
    Switch currentState {
        case "RED":
        currentState := "GREEN"
        LogState("RED → GREEN")

        case "GREEN":
        currentState := "YELLOW"
        LogState("GREEN → YELLOW")

        case "YELLOW":
        currentState := "RED"
        cycleCount++
        LogState("YELLOW → RED (Cycle " cycleCount " complete)")
    }
}

UpdateDisplay() {
    global currentState, stateTimer

    ; Update light colors (brighten active, dim inactive)
    redLight.Opt("Background" (currentState = "RED" ? "Red" : "660000"))
    yellowLight.Opt("Background" (currentState = "YELLOW" ? "Yellow" : "666600"))
    greenLight.Opt("Background" (currentState = "GREEN" ? "Lime" : "006600"))

    ; Update state text
    stateText.Value := "Current State: " currentState
    remaining := stateDurations[currentState] - stateTimer
    timerText.Value := "Time Remaining: " Round(remaining, 1) "s"
    cycleText.Value := "Cycles: " cycleCount
}

LogState(message) {
    global stateLog

    timestamp := FormatTime(, "HH:mm:ss")
    logEntry := "[" timestamp "] " message "`n"
    stateLog .= logEntry
    logText.Value := stateLog

    ; Scroll to bottom
    Send("^{End}")
}
