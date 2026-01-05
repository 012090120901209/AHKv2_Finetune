#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Timer Patterns in AHK v2
 * Source: Patterns from notification examples
 * 
 * Demonstrates:
 * - SetTimer with arrow functions
 * - One-shot timers (negative period)
 * - Repeating timers
 * - Timer cleanup
 * - Timer with closures
 */

; Example 1: One-shot timer (runs once after delay)
OneShotTimer() {
    MsgBox("Timer will trigger in 2 seconds...")

    ; Negative value = run once after 2000ms
    SetTimer(() => MsgBox("One-shot timer fired!"), -2000)
}

; Example 2: Repeating timer
RepeatingTimer() {
    count := 0

    MsgBox("Repeating timer will trigger 5 times...")

    ; Positive value = repeat every 1000ms
    timerFunc := () => (
        global count,
        count++,
        ToolTip("Timer tick: " count),
        count >= 5 ? (SetTimer(timerFunc, 0), ToolTip()) : ""
    )

    SetTimer(timerFunc, 1000)
}

; Example 3: Timer with cleanup
TimerWithCleanup() {
    cleanup := () => (
        ToolTip("Cleaning up..."),
        Sleep(1000),
        ToolTip()
    )

    MsgBox("Timer will auto-cleanup in 3 seconds...")
    SetTimer(cleanup, -3000)
}

; Example 4: Multiple timers
MultipleTimers() {
    MsgBox("Starting 3 different timers...")

    SetTimer(() => ToolTip("Timer 1"), -1000)
    SetTimer(() => ToolTip("Timer 2"), -2000)
    SetTimer(() => ToolTip("Timer 3"), -3000)
}

; Menu to choose examples
choice := MsgBox("Choose timer example:`n`n"
    . "Yes = One-shot`n"
    . "No = Repeating`n"
    . "Cancel = Multiple", "Timer Examples", "YNC")

if (choice = "Yes")
    OneShotTimer()
else if (choice = "No")
    RepeatingTimer()
else if (choice = "Cancel")
    MultipleTimers()

; Keep script running for timers
Persistent
Esc:: ExitApp
