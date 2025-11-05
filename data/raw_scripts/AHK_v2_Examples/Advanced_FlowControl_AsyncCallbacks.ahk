#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Flow Control Example: Asynchronous Callbacks and Timers
; Demonstrates: Callback functions, timer management, async patterns

Persistent

; Callback manager class
class CallbackManager {
    __New() {
        this.callbacks := Map()
        this.nextId := 1
    }

    ; Register a callback to run after delay
    SetTimeout(callback, delay) {
        id := this.nextId++
        this.callbacks[id] := callback

        ; Use closure to capture id
        SetTimer(() => this.ExecuteCallback(id), -delay)

        return id
    }

    ; Register a recurring callback
    SetInterval(callback, interval) {
        id := this.nextId++
        this.callbacks[id] := callback

        SetTimer(() => this.ExecuteCallback(id, true), interval)

        return id
    }

    ; Cancel a callback
    ClearCallback(id) {
        if (this.callbacks.Has(id)) {
            this.callbacks.Delete(id)
            return true
        }
        return false
    }

    ; Execute callback and optionally keep it for intervals
    ExecuteCallback(id, keepAlive := false) {
        if (this.callbacks.Has(id)) {
            callback := this.callbacks[id]
            callback()

            if (!keepAlive)
                this.callbacks.Delete(id)
        }
    }
}

; Create GUI
cbGui := Gui()
cbGui.Title := "Async Callbacks and Timers Demo"

cbGui.Add("Text", "x10 y10", "Demonstrate asynchronous execution with callbacks and timers")

; SetTimeout demo
cbGui.Add("GroupBox", "x10 y35 w460 h100", "SetTimeout (Execute Once After Delay)")
cbGui.Add("Text", "x20 y60", "Delay (ms):")
timeoutDelay := cbGui.Add("Edit", "x100 y57 w100 Number", "2000")
cbGui.Add("Text", "x210 y60", "Message:")
timeoutMsg := cbGui.Add("Edit", "x280 y57 w180", "Hello after timeout")
cbGui.Add("Button", "x20 y90 w140", "Set Timeout").OnEvent("Click", DoSetTimeout)
cbGui.Add("Button", "x170 y90 w140", "Set Multiple").OnEvent("Click", SetMultipleTimeouts)

; SetInterval demo
cbGui.Add("GroupBox", "x10 y145 w460 h100", "SetInterval (Execute Repeatedly)")
cbGui.Add("Text", "x20 y170", "Interval (ms):")
intervalDelay := cbGui.Add("Edit", "x100 y167 w100 Number", "1000")
cbGui.Add("Text", "x210 y170", "Message:")
intervalMsg := cbGui.Add("Edit", "x280 y167 w180", "Tick")
cbGui.Add("Button", "x20 y200 w140", "Start Interval").OnEvent("Click", DoSetInterval)
cbGui.Add("Button", "x170 y200 w140", "Stop Interval").OnEvent("Click", StopInterval)

; Callback chain demo
cbGui.Add("GroupBox", "x10 y255 w460 h80", "Callback Chain")
cbGui.Add("Text", "x20 y280 w440", "Execute a sequence of callbacks with delays between them")
cbGui.Add("Button", "x20 y305 w200", "Run Callback Chain").OnEvent("Click", RunCallbackChain)

; Activity log
cbGui.Add("Text", "x10 y345", "Activity Log:")
activityLog := cbGui.Add("Edit", "x10 y365 w460 h150 ReadOnly Multi")

cbGui.Show("w480 h530")

global manager := CallbackManager()
global activeIntervalId := 0
global logText := ""

DoSetTimeout(*) {
    delay := Integer(timeoutDelay.Value)
    message := timeoutMsg.Value

    Log("Timeout set for " delay "ms")

    manager.SetTimeout(() => ShowTimeoutMessage(message), delay)
}

ShowTimeoutMessage(msg) {
    Log("Timeout executed: " msg)
    MsgBox(msg, "Timeout Callback")
}

SetMultipleTimeouts(*) {
    Log("Setting multiple timeouts...")

    ; Set 5 timeouts with increasing delays
    Loop 5 {
        delay := A_Index * 1000
        msg := "Timeout #" A_Index " at " delay "ms"

        manager.SetTimeout(() => Log(msg), delay)
    }

    Log("5 timeouts scheduled (1s, 2s, 3s, 4s, 5s)")
}

DoSetInterval(*) {
    global activeIntervalId

    if (activeIntervalId != 0) {
        MsgBox("Interval already running! Stop it first.", "Warning")
        return
    }

    interval := Integer(intervalDelay.Value)
    message := intervalMsg.Value

    Log("Interval started (" interval "ms)")

    activeIntervalId := manager.SetInterval(() => IntervalTick(message), interval)
}

IntervalTick(msg) {
    static count := 0
    count++
    Log("Interval tick #" count ": " msg)
}

StopInterval(*) {
    global activeIntervalId

    if (activeIntervalId = 0) {
        MsgBox("No interval running!", "Warning")
        return
    }

    manager.ClearCallback(activeIntervalId)
    activeIntervalId := 0

    Log("Interval stopped")
}

RunCallbackChain(*) {
    Log("Starting callback chain...")

    ; Step 1
    manager.SetTimeout(() => ChainStep1(), 500)
}

ChainStep1() {
    Log("Chain Step 1: Initializing...")

    ; Step 2
    manager.SetTimeout(() => ChainStep2(), 1000)
}

ChainStep2() {
    Log("Chain Step 2: Processing...")

    ; Step 3
    manager.SetTimeout(() => ChainStep3(), 1000)
}

ChainStep3() {
    Log("Chain Step 3: Finalizing...")

    ; Complete
    manager.SetTimeout(() => ChainComplete(), 1000)
}

ChainComplete() {
    Log("Chain Complete!")
    MsgBox("Callback chain completed successfully!", "Success")
}

Log(message) {
    global logText

    timestamp := FormatTime(, "HH:mm:ss.") . A_MSec
    logText .= "[" timestamp "] " message "`n"

    ; Keep only last 50 lines
    lines := StrSplit(logText, "`n")
    if (lines.Length > 50) {
        logText := ""
        Loop Min(50, lines.Length) {
            idx := lines.Length - 50 + A_Index
            if (idx > 0 && idx <= lines.Length)
                logText .= lines[idx] "`n"
        }
    }

    activityLog.Value := logText

    ; Scroll to bottom
    ControlSend("^{End}", , "ahk_id " activityLog.Hwnd)
}
