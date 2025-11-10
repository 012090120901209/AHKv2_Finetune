#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Timer-Based Window Detection
 *
 * Demonstrates detecting window creation and destruction using timers
 * and state tracking with static variables.
 *
 * Source: AHK_Notes/Snippets/TimerBasedWindowDetection.md
 */

MsgBox("Window Detection Demo`n`n"
     . "Monitoring Notepad windows...`n"
     . "Open/close Notepad to see detection.`n`n"
     . "Will run for 20 seconds.", , "T3")

; Start single window monitor
SetTimer(MonitorNotepad, 500)

; Start multiple window monitor
SetTimer(MonitorAllWindows, 1000)

; Run for 20 seconds
Sleep(20000)

; Stop timers
SetTimer(MonitorNotepad, 0)
SetTimer(MonitorAllWindows, 0)

MsgBox("Monitoring stopped", , "T2")

/**
 * MonitorNotepad - Detect single window (Notepad)
 * Uses static variable to track previous state
 */
MonitorNotepad() {
    static wasOpen := false

    isOpen := WinExist("ahk_exe notepad.exe")

    ; Window opened
    if (isOpen && !wasOpen) {
        title := WinGetTitle("ahk_exe notepad.exe")
        ToolTip("Notepad OPENED: " title)
        SetTimer(() => ToolTip(), -3000)
    }
    ; Window closed
    else if (!isOpen && wasOpen) {
        ToolTip("Notepad CLOSED")
        SetTimer(() => ToolTip(), -3000)
    }

    wasOpen := isOpen
}

/**
 * MonitorAllWindows - Track all windows using Map
 */
MonitorAllWindows() {
    static prevWindows := Map()

    ; Get current windows
    currentWindows := Map()
    windows := WinGetList()

    for hwnd in windows {
        try {
            ; Skip invisible and minimized windows
            if (!WinGetTitle("ahk_id " hwnd))
                continue

            title := WinGetTitle("ahk_id " hwnd)
            class := WinGetClass("ahk_id " hwnd)

            currentWindows[hwnd] := {
                title: title,
                class: class
            }
        }
    }

    ; Check for new windows
    for hwnd, info in currentWindows {
        if (!prevWindows.Has(hwnd)) {
            ; Filter out certain windows
            if (info.class ~= "i)Shell_TrayWnd|WorkerW")
                continue

            ToolTip("NEW WINDOW: " info.title)
            SetTimer(() => ToolTip(), -2000)
        }
    }

    ; Check for closed windows
    for hwnd, info in prevWindows {
        if (!currentWindows.Has(hwnd)) {
            ToolTip("CLOSED WINDOW: " info.title)
            SetTimer(() => ToolTip(), -2000)
        }
    }

    ; Update previous state
    prevWindows := currentWindows
}

/**
 * MonitorMultiple - Monitor multiple specific applications
 */
MonitorMultiple() {
    static notepadWasOpen := false
    static calculatorWasOpen := false

    ; Check Notepad
    notepadOpen := WinExist("ahk_exe notepad.exe")
    if (notepadOpen && !notepadWasOpen)
        MsgBox("Notepad opened", , "T2")
    else if (!notepadOpen && notepadWasOpen)
        MsgBox("Notepad closed", , "T2")
    notepadWasOpen := notepadOpen

    ; Check Calculator
    calcOpen := WinExist("ahk_exe calc.exe")
    if (calcOpen && !calculatorWasOpen)
        MsgBox("Calculator opened", , "T2")
    else if (!calcOpen && calculatorWasOpen)
        MsgBox("Calculator closed", , "T2")
    calculatorWasOpen := calcOpen
}

/*
 * Key Concepts:
 *
 * 1. Timer Setup:
 *    SetTimer(FunctionRef, interval)
 *    SetTimer(FunctionRef, 0)  ; Stop timer
 *    Interval in milliseconds
 *
 * 2. State Tracking:
 *    static wasOpen := false  ; Persistent across calls
 *    Compare current vs previous
 *    Detect changes
 *
 * 3. Window Detection:
 *    WinExist("ahk_exe notepad.exe")
 *    WinGetList()  ; All windows
 *    WinGetTitle(), WinGetClass()
 *
 * 4. Change Detection Pattern:
 *    if (isOpen && !wasOpen)      ; Opened
 *    if (!isOpen && wasOpen)      ; Closed
 *    wasOpen := isOpen            ; Update state
 *
 * 5. Map for Multiple Windows:
 *    prevWindows := Map()
 *    currentWindows := Map()
 *    Compare maps to find changes
 *
 * 6. Timer Intervals:
 *    250-500ms: Responsive, higher CPU
 *    1000ms: Balanced
 *    2000ms+: Low CPU, less responsive
 *
 * 7. Window Filtering:
 *    Skip invisible windows
 *    Filter system windows
 *    class ~= "i)Shell_TrayWnd"
 *
 * 8. Benefits:
 *    ✅ Simple implementation
 *    ✅ Works with any application
 *    ✅ No complex APIs
 *    ✅ Reliable detection
 *
 * 9. Drawbacks:
 *    ⚠ Constant polling (CPU usage)
 *    ⚠ Delay based on interval
 *    ⚠ May miss brief windows
 *    ⚠ Not real-time
 *
 * 10. Best Practices:
 *     ✅ Use appropriate interval
 *     ✅ Filter unnecessary windows
 *     ✅ Stop timers when done
 *     ✅ Use static for state
 *     ✅ Handle window title changes
 *
 * 11. Alternative Approaches:
 *     ShellHook - Event-driven (more efficient)
 *     WinEventHook - Detailed events
 *     Both covered in other examples
 */
