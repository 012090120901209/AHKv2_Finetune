#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinSetTitle Examples - Part 3: Dynamic Titles
 * ============================================================================
 *
 * This script demonstrates dynamic title updates and real-time modifications.
 * Focuses on live updates, progress indicators, and status displays.
 *
 * @description Dynamic and real-time window title manipulation
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Real-Time Clock in Title
; ============================================================================

/**
 * Displays a real-time clock in the window title
 * Updates every second
 *
 * @hotkey F1 - Start/stop title clock
 */
F1:: {
    static clockRunning := false

    if !clockRunning {
        clockRunning := true
        StartTitleClock()
    } else {
        clockRunning := false
    }
}

/**
 * Shows live clock in window title
 */
StartTitleClock() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    global clockHwnd := WinGetID("A")
    global originalTitle := WinGetTitle(clockHwnd)

    ToolTip("Title clock started. Press F1 to stop.")
    SetTimer(() => ToolTip(), -2000)

    SetTimer(UpdateClock, 1000)

    UpdateClock() {
        if !WinExist(clockHwnd) {
            SetTimer(UpdateClock, 0)
            return
        }

        timeStr := "[" A_Hour ":" A_Min ":" A_Sec "] " originalTitle
        WinSetTitle(timeStr, clockHwnd)
    }

    ; Stop and restore
    SetTimer(StopClock, 0)
    StopClock() {
        Sleep(1000)  ; Wait for next F1 press
        if !clockRunning {
            SetTimer(UpdateClock, 0)
            if WinExist(clockHwnd) {
                WinSetTitle(originalTitle, clockHwnd)
            }
            ToolTip("Title clock stopped.")
            SetTimer(() => ToolTip(), -2000)
        }
    }
}

; ============================================================================
; Example 2: Progress Indicator in Title
; ============================================================================

/**
 * Shows a progress bar in the window title
 * Simulates a long-running operation
 *
 * @hotkey F2 - Show progress in title
 */
F2:: {
    ShowProgressInTitle()
}

/**
 * Demonstrates progress indication in title
 */
ShowProgressInTitle() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")
    baseTitle := WinGetTitle(hwnd)

    ; Simulate progress
    Loop 100 {
        percent := A_Index

        ; Create visual progress bar
        barLength := 20
        filled := Round(barLength * percent / 100)
        progressBar := "[" StrRepeat("█", filled) StrRepeat("░", barLength - filled) "] "

        newTitle := progressBar percent "% - " baseTitle
        WinSetTitle(newTitle, hwnd)

        Sleep(50)  ; Simulate work
    }

    ; Restore original
    WinSetTitle(baseTitle, hwnd)
    ToolTip("Progress complete!")
    SetTimer(() => ToolTip(), -2000)
}

/**
 * Helper function
 */
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 3: CPU/Memory Usage in Title
; ============================================================================

/**
 * Displays system resource usage in window title
 * Updates in real-time
 *
 * @hotkey F3 - Show system stats in title
 */
F3:: {
    static statsRunning := false

    if !statsRunning {
        statsRunning := true
        StartSystemStats()
    } else {
        statsRunning := false
    }
}

/**
 * Shows system statistics in title
 */
StartSystemStats() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    global statsHwnd := WinGetID("A")
    global statsOriginalTitle := WinGetTitle(statsHwnd)

    SetTimer(UpdateStats, 2000)

    UpdateStats() {
        if !WinExist(statsHwnd) || !statsRunning {
            SetTimer(UpdateStats, 0)
            if WinExist(statsHwnd) {
                WinSetTitle(statsOriginalTitle, statsHwnd)
            }
            return
        }

        ; Get memory info using ComObject
        try {
            objWMI := ComObject("winmgmts:\\.\root\cimv2")
            query := "SELECT * FROM Win32_OperatingSystem"
            results := objWMI.ExecQuery(query)

            for os in results {
                totalMem := Round(os.TotalVisibleMemorySize / 1024 / 1024, 1)
                freeMem := Round(os.FreePhysicalMemory / 1024 / 1024, 1)
                usedMem := Round(totalMem - freeMem, 1)
                memPercent := Round((usedMem / totalMem) * 100)

                statsStr := "[MEM: " usedMem "/" totalMem "GB (" memPercent "%)] " statsOriginalTitle
                WinSetTitle(statsStr, statsHwnd)
                break
            }
        } catch {
            WinSetTitle("[MEM: N/A] " statsOriginalTitle, statsHwnd)
        }
    }
}

; ============================================================================
; Example 4: Countdown Timer in Title
; ============================================================================

/**
 * Runs a countdown timer in the window title
 * Useful for time-boxed tasks
 *
 * @hotkey F4 - Start countdown timer
 */
F4:: {
    StartCountdown()
}

/**
 * Countdown timer in window title
 */
StartCountdown() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    result := InputBox("Enter countdown time (minutes):", "Countdown Timer", "w250 h130", "5")

    if result.Result != "OK" || !IsNumber(result.Value) {
        return
    }

    hwnd := WinGetID("A")
    baseTitle := WinGetTitle(hwnd)
    totalSeconds := Integer(result.Value) * 60

    global remainingSeconds := totalSeconds

    SetTimer(UpdateCountdown, 1000)

    UpdateCountdown() {
        if remainingSeconds <= 0 || !WinExist(hwnd) {
            SetTimer(UpdateCountdown, 0)
            if WinExist(hwnd) {
                WinSetTitle(baseTitle, hwnd)
            }
            MsgBox("Countdown complete!", "Timer", 64)
            SoundBeep(1000, 500)
            return
        }

        minutes := remainingSeconds // 60
        seconds := Mod(remainingSeconds, 60)
        timeStr := Format("[{:02d}:{:02d}] ", minutes, seconds)

        WinSetTitle(timeStr baseTitle, hwnd)
        remainingSeconds--
    }
}

; ============================================================================
; Example 5: Notification Counter in Title
; ============================================================================

/**
 * Displays a notification/message counter in title
 * Simulates unread message count
 *
 * @hotkey F5 - Start notification counter
 */
F5:: {
    StartNotificationCounter()
}

; Global counter
global notificationCount := 0

/**
 * Shows notification counter in title
 */
StartNotificationCounter() {
    static counterGui := ""

    if counterGui {
        try counterGui.Destroy()
    }

    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    global counterHwnd := WinGetID("A")
    global counterBaseTitle := WinGetTitle(counterHwnd)

    counterGui := Gui("+AlwaysOnTop +ToolWindow", "Notification Counter")
    counterGui.SetFont("s10", "Segoe UI")

    counterGui.Add("Text", "w250", "Current count: 0")
    countText := counterGui.Add("Text", "w250 vCount", "Click buttons to update counter:")

    counterGui.Add("Button", "w120 Default", "+1 Notification").OnEvent("Click", (*) => UpdateCount(1))
    counterGui.Add("Button", "w120 x+10 yp", "+5 Notifications").OnEvent("Click", (*) => UpdateCount(5))

    counterGui.Add("Button", "w120 xm", "-1 Notification").OnEvent("Click", (*) => UpdateCount(-1))
    counterGui.Add("Button", "w120 x+10 yp", "Reset Count").OnEvent("Click", (*) => UpdateCount(-notificationCount))

    counterGui.Add("Button", "w250 xm", "Close").OnEvent("Click", (*) => (counterGui.Destroy(), RestoreTitle()))

    counterGui.Show()

    UpdateCount(delta) {
        global notificationCount
        notificationCount := Max(0, notificationCount + delta)

        ; Update window title
        if WinExist(counterHwnd) {
            if notificationCount > 0 {
                WinSetTitle("(" notificationCount ") " counterBaseTitle, counterHwnd)
            } else {
                WinSetTitle(counterBaseTitle, counterHwnd)
            }
        }

        countText.Value := "Current count: " notificationCount
    }

    RestoreTitle() {
        if WinExist(counterHwnd) {
            WinSetTitle(counterBaseTitle, counterHwnd)
        }
    }
}

; ============================================================================
; Example 6: Status Cycle Animation
; ============================================================================

/**
 * Animates the window title with rotating status
 * Creates visual activity indicator
 *
 * @hotkey F6 - Start status animation
 */
F6:: {
    static animating := false

    if !animating {
        animating := true
        StartStatusAnimation()
    } else {
        animating := false
    }
}

/**
 * Animates status in title
 */
StartStatusAnimation() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    global animHwnd := WinGetID("A")
    global animBaseTitle := WinGetTitle(animHwnd)
    global animFrames := ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
    global animIndex := 0

    SetTimer(AnimateTitle, 100)

    AnimateTitle() {
        if !WinExist(animHwnd) || !animating {
            SetTimer(AnimateTitle, 0)
            if WinExist(animHwnd) {
                WinSetTitle(animBaseTitle, animHwnd)
            }
            return
        }

        animIndex := Mod(animIndex, animFrames.Length) + 1
        WinSetTitle(animFrames[animIndex] " Processing... " animBaseTitle, animHwnd)
    }
}

; ============================================================================
; Example 7: Multi-Window Title Synchronization
; ============================================================================

/**
 * Synchronizes titles across multiple windows
 * Updates all selected windows simultaneously
 *
 * @hotkey F7 - Synchronize window titles
 */
F7:: {
    SynchronizeWindowTitles()
}

/**
 * Syncs titles across windows
 */
SynchronizeWindowTitles() {
    static syncGui := ""

    if syncGui {
        try syncGui.Destroy()
    }

    syncGui := Gui("+AlwaysOnTop", "Synchronize Window Titles")
    syncGui.SetFont("s10", "Segoe UI")

    syncGui.Add("Text", "w500", "Select windows to synchronize:")

    lv := syncGui.Add("ListView", "w500 h200 Checked vWinList", ["Title", "Process"])

    windows := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                process := WinGetProcessName(hwnd)
                lv.Add("", title, process)
                windows.Push(hwnd)
            }
        }
    }

    lv.ModifyCol(1, 350)
    lv.ModifyCol(2, "AutoHdr")

    syncGui.Add("Text", "w500", "Synchronized title:")
    titleEdit := syncGui.Add("Edit", "w500 vSyncTitle", "Synchronized Window")

    syncGui.Add("Button", "w240 Default", "Apply to Selected").OnEvent("Click", ApplySync)
    syncGui.Add("Button", "w240 x+20 yp", "Cancel").OnEvent("Click", (*) => syncGui.Destroy())

    syncGui.Show()

    ApplySync(*) {
        submitted := syncGui.Submit(false)
        newTitle := submitted.SyncTitle

        if newTitle = "" {
            MsgBox("Please enter a title.", "Error", 16)
            return
        }

        count := 0

        Loop lv.GetCount() {
            if lv.GetNext(A_Index - 1, "Checked") = A_Index {
                try {
                    WinSetTitle(newTitle " #" (++count), windows[A_Index])
                }
            }
        }

        syncGui.Destroy()
        MsgBox("Synchronized " count " windows.", "Success", 64)
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinSetTitle Examples - Part 3 (Dynamic Titles)
    ===============================================

    Hotkeys:
    F1 - Start/stop real-time clock in title
    F2 - Show progress indicator
    F3 - Start/stop system stats display
    F4 - Start countdown timer
    F5 - Start notification counter
    F6 - Start/stop status animation
    F7 - Synchronize window titles
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
