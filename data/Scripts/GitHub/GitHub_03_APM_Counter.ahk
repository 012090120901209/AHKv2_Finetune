#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * APM Counter - Actions Per Minute Tracker
 * 
 * Demonstrates real-time input tracking and APM calculation,
 * useful for competitive gaming (StarCraft, League of Legends, etc.)
 * and productivity monitoring.
 * 
 * Source: jotnguyen/autohotkey-productivity-scripts - APM-Counter.ahk
 * Inspired by: https://github.com/jotnguyen/autohotkey-productivity-scripts
 */

; Global state
global actionCount := 0
global actionHistory := []
global startTime := A_TickCount
global apmGui := ""
global apmText := ""
global totalText := ""
global avgText := ""
global peakAPM := 0

; Create GUI
CreateAPMGUI()

MsgBox("APM Counter Active!`n`n"
    . "This will track your keyboard/mouse actions.`n`n"
    . "Metrics shown:`n"
    . "- Current APM (last 60 seconds)`n"
    . "- Total actions`n"
    . "- Average APM`n"
    . "- Peak APM`n`n"
    . "Hotkeys:`n"
    . "Win+R - Reset counter`n"
    . "Win+P - Pause/Resume`n`n"
    . "Try typing or clicking to see it work!", , "T7")

; Update display every 500ms
SetTimer(UpdateDisplay, 500)

; ===============================================
; GUI CREATION
; ===============================================

CreateAPMGUI() {
    global apmGui, apmText, totalText, avgText

    apmGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "APM Counter")
    apmGui.BackColor := "0x000000"
    apmGui.SetFont("s10 cWhite", "Consolas")

    ; Title
    apmGui.Add("Text", "w250 Center cYellow", "⚡ APM COUNTER ⚡").SetFont("s11 Bold")

    ; Current APM (large display)
    apmGui.Add("Text", "w250 Center y+5", "CURRENT APM").SetFont("s8 c0x888888")
    apmText := apmGui.Add("Text", "w250 Center y+2", "0").SetFont("s32 Bold cLime")

    ; Statistics
    apmGui.Add("Text", "w250 y+10", "─────────────────────────").SetFont("s8 c0x444444")

    totalText := apmGui.Add("Text", "w250 y+5", "Total Actions: 0")
    avgText := apmGui.Add("Text", "w250 y+2", "Average APM: 0")
    global peakText := apmGui.Add("Text", "w250 y+2", "Peak APM: 0")

    ; Time elapsed
    global timeText := apmGui.Add("Text", "w250 y+2", "Time: 0:00")

    ; Controls hint
    apmGui.Add("Text", "w250 y+10 c0x666666", "Win+R: Reset | Win+P: Pause").SetFont("s8")

    ; Show in top-right corner
    apmGui.Show("w270 x" (A_ScreenWidth - 290) " y20")
}

; ===============================================
; INPUT HOOKS
; ===============================================

/**
 * Track keyboard input
 */
~*a::
~*b:: ~ * c: : ~ * d: : ~ * e: : ~ * f: : ~ * g: : ~ * h: : ~ * i: : ~ * j: :
    ~*k:: ~ * l: : ~ * m: : ~ * n: : ~ * o: : ~ * p: : ~ * q: : ~ * r: : ~ * s: :
    ~*t:: ~ * u: : ~ * v: : ~ * w: : ~ * x: : ~ * y: : ~ * z: :
    ~*0:: ~ * 1: : ~ * 2: : ~ * 3: : ~ * 4: : ~ * 5: : ~ * 6: : ~ * 7: : ~ * 8: : ~ * 9: :
    ~*Space:: ~ * Enter: : ~ * Backspace: : ~ * Tab: :
    RecordAction()

/**
 * Track mouse clicks
 */
~LButton:: RecordAction()
~RButton:: RecordAction()
~MButton:: RecordAction()

; ===============================================
; ACTION RECORDING
; ===============================================

/**
 * Record an action with timestamp
 */
RecordAction() {
    global actionCount, actionHistory

    actionCount++
    actionHistory.Push(A_TickCount)

    ; Keep only last 2 minutes of history
    currentTime := A_TickCount
    while (actionHistory.Length > 0 && currentTime - actionHistory[1] > 120000)
        actionHistory.RemoveAt(1)
}

; ===============================================
; APM CALCULATION & DISPLAY
; ===============================================

/**
 * Update APM display
 */
UpdateDisplay() {
    global actionHistory, actionCount, startTime, peakAPM
    global apmText, totalText, avgText, peakText, timeText

    currentTime := A_TickCount

    ; Calculate current APM (last 60 seconds)
    currentAPM := CalculateCurrentAPM(currentTime)

    ; Update peak
    if (currentAPM > peakAPM)
        peakAPM := currentAPM

    ; Calculate average APM (overall)
    elapsedMinutes := (currentTime - startTime) / 60000
    averageAPM := elapsedMinutes > 0 ? Round(actionCount / elapsedMinutes) : 0

    ; Format time elapsed
    elapsedSeconds := Round((currentTime - startTime) / 1000)
    minutes := Floor(elapsedSeconds / 60)
    seconds := Mod(elapsedSeconds, 60)
    timeStr := Format("{:d}:{:02d}", minutes, seconds)

    ; Update display
    apmText.Value := currentAPM
    totalText.Value := "Total Actions: " actionCount
    avgText.Value := "Average APM: " averageAPM
    peakText.Value := "Peak APM: " peakAPM
    timeText.Value := "Time: " timeStr

    ; Color coding for current APM
    if (currentAPM >= 300)
        apmText.SetFont("cRed")      ; Insane
    else if (currentAPM >= 200)
        apmText.SetFont("cYellow")   ; Very High
    else if (currentAPM >= 100)
        apmText.SetFont("cLime")     ; High
    else
        apmText.SetFont("cWhite")    ; Normal
}

/**
 * Calculate APM for last 60 seconds
 */
CalculateCurrentAPM(currentTime) {
    global actionHistory

    ; Count actions in last 60 seconds
    recentActions := 0
    for timestamp in actionHistory {
        if (currentTime - timestamp <= 60000)  ; 60 seconds
            recentActions++
    }

    return recentActions
}

; ===============================================
; HOTKEY CONTROLS
; ===============================================

/**
 * Reset counter
 */
#r:: ResetCounter()

ResetCounter() {
    global actionCount, actionHistory, startTime, peakAPM

    result := MsgBox("Reset APM Counter?", "Confirm Reset", "YesNo Icon?")
    if (result == "No")
        return

    actionCount := 0
    actionHistory := []
    startTime := A_TickCount
    peakAPM := 0

    UpdateDisplay()
    ToolTip("APM Counter Reset!")
    SetTimer(() => ToolTip(), -1500)
}

/**
 * Pause/Resume tracking
 */
global paused := false
#p:: TogglePause()

TogglePause() {
    global paused, apmGui

    paused := !paused

    if (paused) {
        Suspend(true)
        apmGui.BackColor := "0x330000"  ; Red tint
        ToolTip("APM Tracking PAUSED")
    } else {
        Suspend(false)
        apmGui.BackColor := "0x000000"  ; Black
        ToolTip("APM Tracking RESUMED")
    }

    SetTimer(() => ToolTip(), -1500)
}

/*
* Key Concepts:
*
* 1. APM (Actions Per Minute):
*    Gaming metric
*    Measures input speed
*    Higher = faster actions
*    Competitive benchmark
*
* 2. Input Tracking:
*    ~ prefix - Don't block input
*    * prefix - Wildcard (all variations)
*    Track keyboard and mouse
*    Timestamp each action
*
* 3. Sliding Window:
*    Keep last 60 seconds of actions
*    Remove older entries
*    Efficient memory usage
*    Real-time calculation
*
* 4. Metrics Displayed:
*    Current APM - Last 60 seconds
*    Total Actions - All time
*    Average APM - Overall rate
*    Peak APM - Highest recorded
*
* 5. Use Cases:
*    ✅ Gaming performance tracking
*    ✅ Productivity monitoring
*    ✅ Typing speed analysis
*    ✅ Workflow optimization
*    ✅ Training feedback
*
* 6. APM Benchmarks (Gaming):
*    50-100 - Casual
*    100-150 - Intermediate
*    150-200 - Advanced
*    200-300 - Professional
*    300+ - Elite (StarCraft pros)
*
* 7. Timestamp Management:
*    A_TickCount - Millisecond timer
*    Array of timestamps
*    Pruning old entries
*    60-second sliding window
*
* 8. GUI Features:
*    Always on top
*    No caption (frameless)
*    Tool window (no taskbar)
*    Color-coded APM
*    Real-time updates
*
* 9. Color Coding:
*    White - 0-99 APM
*    Lime - 100-199 APM
*    Yellow - 200-299 APM
*    Red - 300+ APM
*
* 10. Performance:
*     Lightweight hooks
*     Efficient array pruning
*     500ms update interval
*     Minimal CPU usage
*
* 11. Best Practices:
*     ✅ Sliding window, not full history
*     ✅ Color feedback
*     ✅ Pause capability
*     ✅ Reset option
*     ✅ Peak tracking
*
* 12. Advanced Features:
*     - Per-key heatmap
*     - Session recording
*     - Graph visualization
*     - Export statistics
*     - Comparison with average
*
* 13. Game-Specific:
*     StarCraft 2: 200+ APM competitive
*     League of Legends: 60-120 typical
*     Dota 2: 80-150 typical
*     FPS games: Lower, but precision matters
*
* 14. Productivity Use:
*     Track coding speed
*     Monitor work intensity
*     Identify productive hours
*     Compare task types
*     Prevent overwork
*/

