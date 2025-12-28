#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinClose Examples - Part 2: Force Close
 * ============================================================================
 * 
 * Demonstrates forceful window closing when normal close fails.
 * Handles unresponsive applications.
 * 
 * @description Force close and kill process examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Force Close vs Normal Close
; ============================================================================

/**
 * Tries normal close first, then forces if needed
 * 
 * @hotkey F1 - Smart force close
 */
F1:: {
    SmartForceClose()
}

SmartForceClose() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")
    title := WinGetTitle(hwnd)

    ; Try normal close
    WinClose(hwnd)

    ; Wait to see if it closes
    Sleep(2000)

    if WinExist(hwnd) {
        result := MsgBox("Window did not close normally.`n`nForce close (terminate process)?", "Force Close?", 4)

        if result = "Yes" {
            pid := WinGetPID(hwnd)
            ProcessClose(pid)
            MsgBox("Process terminated.", "Success", 64)
        }
    } else {
        ToolTip("Window closed normally")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 2: Kill Unresponsive Windows
; ============================================================================

/**
 * Identifies and kills unresponsive windows
 * 
 * @hotkey F2 - Kill unresponsive
 */
F2:: {
    KillUnresponsive()
}

KillUnresponsive() {
    MsgBox("Scanning for unresponsive windows...", "Scanning", 64)

    allWindows := WinGetList()
    killed := 0

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)

            ; Check if window contains "Not Responding"
            if InStr(title, "Not Responding") {
                pid := WinGetPID(hwnd)
                ProcessClose(pid)
                killed++
            }
        }
    }

    MsgBox("Killed " killed " unresponsive window(s).", "Complete", 64)
}

; ============================================================================
; Example 3: Force Close with WM_CLOSE Message
; ============================================================================

/**
 * Sends WM_CLOSE message to window
 * 
 * @hotkey F3 - Send WM_CLOSE
 */
F3:: {
    SendWMClose()
}

SendWMClose() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    hwnd := WinGetID("A")
    title := WinGetTitle(hwnd)

    result := MsgBox("Send WM_CLOSE to:`n" title, "Confirm", 4)

    if result = "Yes" {
        ; Send WM_CLOSE message (0x0010)
        SendMessage(0x0010, 0, 0, , hwnd)
        ToolTip("WM_CLOSE sent")
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 4: Batch Force Close
; ============================================================================

/**
 * Force closes multiple selected windows
 * 
 * @hotkey F4 - Batch force close
 */
F4:: {
    BatchForceClose()
}

BatchForceClose() {
    static batchGui := ""

    if batchGui {
        try batchGui.Destroy()
    }

    batchGui := Gui("+AlwaysOnTop", "Batch Force Close")
    batchGui.SetFont("s10", "Segoe UI")

    batchGui.Add("Text", "w500", "Select windows to force close:")

    lv := batchGui.Add("ListView", "w500 h300 Checked vWinList", ["Title", "Process"])

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

    batchGui.Add("Button", "w240 Default", "Force Close Selected").OnEvent("Click", ForceClose)
    batchGui.Add("Button", "w240 x+20 yp", "Cancel").OnEvent("Click", (*) => batchGui.Destroy())

    batchGui.Show()

    ForceClose(*) {
        killed := 0

        Loop lv.GetCount() {
            if lv.GetNext(A_Index - 1, "Checked") = A_Index {
                try {
                    pid := WinGetPID(windows[A_Index])
                    ProcessClose(pid)
                    killed++
                }
            }
        }

        batchGui.Destroy()
        MsgBox("Force closed " killed " window(s).", "Success", 64)
    }
}

; ============================================================================
; Example 5: Kill Process by Name
; ============================================================================

/**
 * Kills all processes by executable name
 * 
 * @hotkey F5 - Kill process by name
 */
F5:: {
    KillProcessByName()
}

KillProcessByName() {
    result := InputBox("Enter process name (e.g., notepad.exe):", "Kill Process", "w300 h130")

    if result.Result != "OK" || result.Value = "" {
        return
    }

    processName := result.Value

    confirm := MsgBox("Kill ALL instances of " processName "?", "Confirm", 4)

    if confirm != "Yes" {
        return
    }

    killed := 0

    ; Get all windows of this process
    windows := WinGetList("ahk_exe " processName)

    for hwnd in windows {
        try {
            pid := WinGetPID(hwnd)
            ProcessClose(pid)
            killed++
        }
    }

    MsgBox("Killed " killed " instance(s) of " processName, "Success", 64)
}

; ============================================================================
; Example 6: Emergency Kill All
; ============================================================================

/**
 * Emergency function to close/kill all non-system windows
 * 
 * @hotkey F6 - Emergency kill all
 */
F6:: {
    EmergencyKillAll()
}

EmergencyKillAll() {
    result := MsgBox("WARNING: This will force close ALL windows!`n`nContinue?", "Emergency Kill", 52)

    if result != "Yes" {
        return
    }

    allWindows := WinGetList()
    killed := 0

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            process := WinGetProcessName(hwnd)

            ; Skip system critical processes
            if !InStr(process, "explorer.exe") && !InStr(process, "AutoHotkey") {
                if title != "" {
                    pid := WinGetPID(hwnd)
                    ProcessClose(pid)
                    killed++
                }
            }
        }
    }

    MsgBox("Emergency kill complete. Closed " killed " windows.", "Complete", 64)
}

; ============================================================================
; Example 7: Process Monitor and Kill
; ============================================================================

/**
 * Monitors and kills processes using too much resources
 * 
 * @hotkey F7 - Resource monitor
 */
F7:: {
    ; Simplified version
    MsgBox("This feature would monitor CPU/Memory usage and kill resource-heavy processes.", "Info", 64)
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinClose Examples - Part 2 (Force Close)
    =========================================

    Hotkeys:
    F1 - Smart force close (try normal first)
    F2 - Kill unresponsive windows
    F3 - Send WM_CLOSE message
    F4 - Batch force close
    F5 - Kill process by name
    F6 - Emergency kill all (WARNING!)
    F7 - Resource monitor
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
