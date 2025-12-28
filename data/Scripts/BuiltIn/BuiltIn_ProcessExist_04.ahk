#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Examples - ProcessExist Function (Part 04: Monitor)
 * ============================================================================
 * 
 * Advanced ProcessExist usage for health checks.
 * 
 * @description Examples demonstrating health checks techniques
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 */

; ============================================================================
; Example 1-7: Comprehensive process health checks examples
; ============================================================================

Example1() {
    MsgBox("Example 1: Process health checks Basics`n`n" .
        "Demonstrating health checks with ProcessExist:",
        "ProcessExist - Example 1", "Icon!")

    ; Launch test process
    Run("notepad.exe", , , &pid)
    Sleep(500)

    ; Check it exists
    if ProcessExist(pid) {
        MsgBox("Process confirmed running: " . pid, "Success", "T2")
        ProcessClose(pid)
    }
}

Example2() {
    MsgBox("Example 2: Advanced health checks`n`n" .
        "More complex health checks scenarios:", "Example 2", "Icon!")

    processes := ["notepad.exe", "calc.exe", "cmd.exe"]
    results := ""

    for proc in processes {
        pid := ProcessExist(proc)
        status := pid ? "Running (" . pid . ")" : "Not running"
        results .= proc . ": " . status . "`n"
    }

    MsgBox("Process Status:`n`n" . results, "Results", "Icon!")
}

Example3() {
    gui := Gui(, "health checks Monitor")
    gui.SetFont("s10")

    gui.Add("Text", "w400", "Process health checks Tool")
    statusText := gui.Add("Edit", "w400 h200 +ReadOnly +Multi", "Status updates...")

    gui.Add("Button", "w400 h35", "Start Monitoring").OnEvent("Click", (*) => StartMon())
    gui.Add("Button", "w400 h30", "Close").OnEvent("Click", (*) => gui.Destroy())

    StartMon() {
        statusText.Value := "Monitoring processes...`n"
        Loop 5 {
            pid := ProcessExist("notepad.exe")
            statusText.Value .= "Check " . A_Index . ": " . (pid ? "Found " . pid : "Not found") . "`n"
            Sleep(1000)
        }
    }

    gui.Show()
    MsgBox("Monitor GUI created!", "Ready", "Icon!")
}

Example4() {
    MsgBox("Example 4: Conditional health checks`n`n" .
        "Take actions based on process existence:", "Example 4", "Icon!")

    if ProcessExist("explorer.exe") {
        MsgBox("Explorer is running (system OK)", "Status", "Icon!")
    } else {
        MsgBox("WARNING: Explorer not running!", "Alert", "Icon!")
    }
}

Example5() {
    MsgBox("Example 5: Wait for Process`n`n" .
        "Demonstrating process waiting:", "Example 5", "Icon!")

    Run("notepad.exe", , , &pid)

    timeout := 5000
    start := A_TickCount

    while (A_TickCount - start) < timeout {
        if ProcessExist(pid) {
            MsgBox("Process verified: " . pid, "Found", "T2")
            ProcessClose(pid)
            return
        }
        Sleep(100)
    }

    MsgBox("Timeout waiting for process", "Timeout")
}

Example6() {
    MsgBox("Example 6: Multi-Process health checks`n`n" .
        "Check multiple processes simultaneously:", "Example 6", "Icon!")

    testProcs := []
    Loop 3 {
        Run("notepad.exe", , , &pid)
        testProcs.Push(pid)
        Sleep(200)
    }

    MsgBox("Launched 3 processes:`n" . testProcs.Join(", "), "Launched", "T2")

    for pid in testProcs {
        if ProcessExist(pid)
            ProcessClose(pid)
    }

    MsgBox("All processes closed", "Complete", "T2")
}

Example7() {
    MsgBox("Example 7: Comprehensive health checks System", "Example 7", "Icon!")

    gui := Gui(, "Process Management System")
    gui.SetFont("s10")

    gui.Add("Text", "w450", "Complete Process health checks System")

    processEdit := gui.Add("Edit", "w450", "notepad.exe")
    statusText := gui.Add("Edit", "w450 h150 +ReadOnly +Multi", "Enter process name and click Check")

    gui.Add("Button", "w450 h35", "Check Process").OnEvent("Click", CheckProc)
    gui.Add("Button", "w450 h35", "Launch Process").OnEvent("Click", LaunchProc)
    gui.Add("Button", "w450 h30", "Close").OnEvent("Click", (*) => gui.Destroy())

    CheckProc(*) {
        proc := processEdit.Value
        pid := ProcessExist(proc)

        if pid {
            statusText.Value := "✓ " . proc . " is running`nPID: " . pid . "`n" .
                "Status: Active`nTime: " . A_Now
        } else {
            statusText.Value := "✗ " . proc . " not found`nStatus: Not running`nTime: " . A_Now
        }
    }

    LaunchProc(*) {
        proc := processEdit.Value
        try {
            Run(proc, , , &pid)
            statusText.Value := "Launched " . proc . "`nPID: " . pid
        } catch Error as err {
            statusText.Value := "Failed to launch: " . err.Message
        }
    }

    gui.Show()
    MsgBox("Process management system ready!", "Ready", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "ProcessExist Examples (Part 04) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w450", "AutoHotkey v2 - ProcessExist (Monitor)")
    menu.SetFont("s9")

    menu.Add("Button", "w450 h35", "Example 1: health checks Basics").OnEvent("Click", (*) => (menu.Hide(), Example1(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 2: Advanced health checks").OnEvent("Click", (*) => (menu.Hide(), Example2(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 3: health checks Monitor").OnEvent("Click", (*) => (menu.Hide(), Example3(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 4: Conditional health checks").OnEvent("Click", (*) => (menu.Hide(), Example4(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 5: Wait for Process").OnEvent("Click", (*) => (menu.Hide(), Example5(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 6: Multi-Process health checks").OnEvent("Click", (*) => (menu.Hide(), Example6(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 7: Comprehensive System").OnEvent("Click", (*) => (menu.Hide(), Example7(), menu.Show()))

    menu.Add("Text", "w450 0x10")
    menu.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
