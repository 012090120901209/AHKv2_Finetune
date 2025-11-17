#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Examples - ProcessExist Function (Part 1: Check Process)
 * ============================================================================
 *
 * ProcessExist checks if a process is running and returns its PID.
 *
 * @description Examples demonstrating basic process checking
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 *
 * SYNTAX:
 *   PID := ProcessExist([PIDOrName])
 *   - If parameter omitted: returns script's own PID
 *   - If PID given: returns PID if exists, 0 if not
 *   - If name given: returns PID of first matching process, 0 if not found
 *
 * RETURN VALUE:
 *   - Process ID (PID) if process exists
 *   - 0 if process not found
 */

; ============================================================================
; Example 1: Basic Process Detection
; ============================================================================
; Check if common processes are running

Example1_BasicDetection() {
    MsgBox("Example 1: Basic Process Detection`n`n" .
           "Check if common processes are running:",
           "ProcessExist - Example 1", "Icon!")

    ; Check several common processes
    processes := [
        "explorer.exe",
        "notepad.exe",
        "calc.exe",
        "cmd.exe",
        "powershell.exe"
    ]

    results := ""

    for processName in processes {
        pid := ProcessExist(processName)

        if pid {
            results .= "✓ " . processName . " - Running (PID: " . pid . ")`n"
        } else {
            results .= "✗ " . processName . " - Not running`n"
        }
    }

    MsgBox("Process Detection Results:`n`n" . results, "Results", "Icon!")

    ; Get script's own PID
    myPID := ProcessExist()
    MsgBox("This script's PID: " . myPID . "`n`n" .
           "Use ProcessExist() without parameters to get your own PID.",
           "Script PID", "Icon!")
}

; ============================================================================
; Example 2: Launch and Verify
; ============================================================================
; Launch program and verify it's running

Example2_LaunchAndVerify() {
    MsgBox("Example 2: Launch and Verify`n`n" .
           "Launch a program and verify it started successfully:",
           "ProcessExist - Example 2", "Icon!")

    MsgBox("Launching Notepad...", "Launching", "T1")

    ; Launch Notepad
    try {
        Run("notepad.exe", , , &launchedPID)

        ; Wait a moment for it to start
        Sleep(500)

        ; Verify it's running
        verifyPID := ProcessExist(launchedPID)

        if verifyPID {
            MsgBox("SUCCESS!`n`n" .
                   "Launched PID: " . launchedPID . "`n" .
                   "Verified PID: " . verifyPID . "`n`n" .
                   "Notepad is confirmed running.",
                   "Verified", "Icon! T3")

            Sleep(2000)

            ; Close it
            ProcessClose(launchedPID)
            MsgBox("Closed Notepad.", "Closed", "T2")
        } else {
            MsgBox("Process verification failed!`n" .
                   "Launched PID: " . launchedPID . "`n" .
                   "But ProcessExist returned: " . verifyPID,
                   "Failed")
        }

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 3: Process Monitor
; ============================================================================
; Create real-time process monitor

Example3_ProcessMonitor() {
    MsgBox("Example 3: Real-Time Process Monitor`n`n" .
           "Monitor specific processes in real-time:",
           "ProcessExist - Example 3", "Icon!")

    CreateProcessMonitor()
}

CreateProcessMonitor() {
    monitor := Gui(, "Process Monitor")
    monitor.SetFont("s10")

    monitor.Add("Text", "w500", "Real-Time Process Monitor")
    monitor.Add("Text", "w500", "Monitors selected processes every second:")

    monitor.Add("Text", "w500 0x10")

    ; Process to monitor
    monitor.Add("Text", "xm", "Process to monitor:")
    processEdit := monitor.Add("Edit", "w400", "notepad.exe")
    monitor.Add("Button", "x+5 yp-1 w90", "Add").OnEvent("Click", AddProcess)

    ; Monitor list
    monitor.Add("Text", "xm", "Monitored Processes:")
    processList := monitor.Add("ListBox", "w500 h100")

    ; Status display
    statusText := monitor.Add("Edit", "w500 h150 +ReadOnly +Multi", "Status updates will appear here...")

    ; Control buttons
    startBtn := monitor.Add("Button", "w240 h35", "Start Monitoring")
    startBtn.OnEvent("Click", StartMonitoring)

    stopBtn := monitor.Add("Button", "x+20 yp w240 h35 Disabled", "Stop Monitoring")
    stopBtn.OnEvent("Click", StopMonitoring)

    monitor.Add("Button", "xm w500 h30", "Close").OnEvent("Click", (*) => (StopMonitoring(), monitor.Destroy()))

    monitorTimer := 0
    monitoredProcesses := []

    AddProcess(*) {
        processName := Trim(processEdit.Value)
        if processName = "" {
            MsgBox("Please enter a process name!", "Error")
            return
        }

        ; Add to monitored list
        monitoredProcesses.Push(processName)
        processList.Add([processName])
        processEdit.Value := ""
        statusText.Value .= "Added to monitor: " . processName . "`n"
    }

    StartMonitoring(*) {
        if monitoredProcesses.Length = 0 {
            MsgBox("Please add at least one process to monitor!", "Error")
            return
        }

        startBtn.Enabled := false
        stopBtn.Enabled := true
        statusText.Value := "Monitoring started...`n`n"

        monitorTimer := SetTimer(CheckProcesses, 1000)

        CheckProcesses() {
            timestamp := FormatTime(A_Now, "HH:mm:ss")
            update := "[" . timestamp . "] `n"

            for processName in monitoredProcesses {
                pid := ProcessExist(processName)

                if pid {
                    update .= "  ✓ " . processName . " (PID: " . pid . ")`n"
                } else {
                    update .= "  ✗ " . processName . " - Not running`n"
                }
            }

            statusText.Value .= update . "`n"

            ; Auto-scroll to bottom
            SendMessage(0x115, 7, 0, statusText)  ; WM_VSCROLL, SB_BOTTOM
        }
    }

    StopMonitoring(*) {
        if monitorTimer {
            SetTimer(monitorTimer, 0)
            monitorTimer := 0
        }

        startBtn.Enabled := true
        stopBtn.Enabled := false
        statusText.Value .= "`nMonitoring stopped.`n"
    }

    monitor.Show()

    MsgBox("Process Monitor Created!`n`n" .
           "Add process names to monitor (e.g., 'notepad.exe').`n" .
           "Click 'Start Monitoring' to begin real-time monitoring.",
           "Monitor Ready", "Icon!")
}

; ============================================================================
; Example 4: Conditional Actions
; ============================================================================
; Perform actions based on process existence

Example4_ConditionalActions() {
    MsgBox("Example 4: Conditional Actions`n`n" .
           "Perform different actions based on whether processes exist:",
           "ProcessExist - Example 4", "Icon!")

    ; Check if Notepad is running
    if ProcessExist("notepad.exe") {
        result := MsgBox("Notepad is currently running.`n`n" .
                        "Would you like to close all Notepad instances?",
                        "Notepad Running", "YesNo Icon?")

        if result = "Yes" {
            closed := 0
            while pid := ProcessExist("notepad.exe") {
                ProcessClose(pid)
                closed++
                Sleep(200)
            }

            MsgBox("Closed " . closed . " Notepad instance(s).", "Closed", "Icon!")
        }
    } else {
        result := MsgBox("Notepad is not currently running.`n`n" .
                        "Would you like to launch it?",
                        "Notepad Not Running", "YesNo Icon?")

        if result = "Yes" {
            Run("notepad.exe", , , &pid)
            MsgBox("Launched Notepad (PID: " . pid . ")", "Launched", "Icon!")
        }
    }
}

; ============================================================================
; Example 5: Multiple Instance Detection
; ============================================================================
; Detect and count multiple instances of a process

Example5_MultipleInstances() {
    MsgBox("Example 5: Multiple Instance Detection`n`n" .
           "Detect and count multiple instances of a process:",
           "ProcessExist - Example 5", "Icon!")

    result := MsgBox("Launch 3 Notepad instances to demonstrate?", "Demo", "YesNo Icon?")

    if result = "Yes" {
        ; Launch 3 instances
        pids := []
        Loop 3 {
            Run("notepad.exe", , , &pid)
            pids.Push(pid)
            Sleep(300)
        }

        MsgBox("Launched 3 Notepad instances:`n" .
               "PIDs: " . pids.Join(", "), "Launched", "T2")

        ; Count instances using WMI
        count := CountProcessInstances("notepad.exe")

        MsgBox("Detection Results:`n`n" .
               "ProcessExist found PID: " . ProcessExist("notepad.exe") . "`n" .
               "Total instances running: " . count . "`n`n" .
               "Note: ProcessExist returns only ONE PID even if multiple instances exist!",
               "Multiple Instances", "Icon! T4")

        ; Close all instances
        for pid in pids {
            if ProcessExist(pid)
                ProcessClose(pid)
        }

        MsgBox("Closed all test instances.", "Cleanup", "T2")
    }
}

CountProcessInstances(processName) {
    count := 0
    for proc in ComObjGet("winmgmts:").ExecQuery("SELECT * FROM Win32_Process WHERE Name='" . processName . "'") {
        count++
    }
    return count
}

; ============================================================================
; Example 6: Process Existence Check Loop
; ============================================================================
; Wait for process to appear or disappear

Example6_WaitForProcess() {
    MsgBox("Example 6: Wait for Process`n`n" .
           "Demonstrate waiting for a process to appear or disappear:",
           "ProcessExist - Example 6", "Icon!")

    result := MsgBox("Wait for Notepad to be launched?`n`n" .
                     "The script will wait up to 10 seconds.`n" .
                     "Launch Notepad within 10 seconds!",
                     "Wait for Launch", "YesNo Icon?")

    if result = "Yes" {
        MsgBox("Waiting for Notepad to launch...`n`n" .
               "Launch Notepad now!", "Waiting", "T2")

        startTime := A_TickCount
        timeout := 10000  ; 10 seconds
        found := false
        pid := 0

        while (A_TickCount - startTime) < timeout {
            pid := ProcessExist("notepad.exe")
            if pid {
                found := true
                break
            }
            Sleep(100)
        }

        elapsed := (A_TickCount - startTime) / 1000

        if found {
            MsgBox("SUCCESS!`n`n" .
                   "Notepad detected after " . Format("{:.1f}", elapsed) . " seconds`n" .
                   "PID: " . pid,
                   "Found", "Icon!")

            Sleep(2000)
            ProcessClose(pid)
        } else {
            MsgBox("TIMEOUT!`n`n" .
                   "Notepad was not launched within 10 seconds.",
                   "Timeout", "Icon!")
        }
    }
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "ProcessExist Function Examples (Part 1) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w500", "AutoHotkey v2 - ProcessExist Function (Check Process)")
    menu.SetFont("s9")
    menu.Add("Text", "w500", "Select an example to run:")

    menu.Add("Button", "w500 h35", "Example 1: Basic Process Detection").OnEvent("Click", (*) => (menu.Hide(), Example1_BasicDetection(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 2: Launch and Verify").OnEvent("Click", (*) => (menu.Hide(), Example2_LaunchAndVerify(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 3: Real-Time Process Monitor").OnEvent("Click", (*) => (menu.Hide(), Example3_ProcessMonitor(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 4: Conditional Actions").OnEvent("Click", (*) => (menu.Hide(), Example4_ConditionalActions(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 5: Multiple Instance Detection").OnEvent("Click", (*) => (menu.Hide(), Example5_MultipleInstances(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 6: Wait for Process").OnEvent("Click", (*) => (menu.Hide(), Example6_WaitForProcess(), menu.Show()))

    menu.Add("Text", "w500 0x10")
    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
