#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Examples - ProcessClose Function (Part 04: Batch close)
 * ============================================================================
 * 
 * ProcessClose terminates a running process.
 * 
 * @description Examples demonstrating batch close
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * SYNTAX:
 *   ProcessClose(PIDOrName)
 *   Returns: PID of closed process, or 0 if not found
 */

; ============================================================================
; Examples 1-7: Process closing and termination
; ============================================================================

Example1() {
    MsgBox("Example 1: Basic Process Closing`n`nDemonstrate ProcessClose basics:", "ProcessClose - Example 1", "Icon!")

    MsgBox("Launching Notepad to close it...", "Launching", "T1")
    Run("notepad.exe", , , &pid)
    Sleep(1000)

    result := MsgBox("Close Notepad (PID: " . pid . ")?", "Close?", "YesNo")
    if result = "Yes" {
        closedPID := ProcessClose(pid)

        if closedPID {
            MsgBox("Successfully closed process!`nPID: " . closedPID, "Closed", "Icon!")
        } else {
            MsgBox("Failed to close process", "Failed")
        }
    }
}

Example2() {
    MsgBox("Example 2: Close by Name`n`nClose process using process name:", "Example 2", "Icon!")

    ; Launch multiple instances
    Loop 3 {
        Run("notepad.exe")
        Sleep(200)
    }

    MsgBox("Launched 3 Notepad instances.`nWill close them by name...", "Launched", "T2")

    closed := 0
    while ProcessClose("notepad.exe") {
        closed++
        Sleep(100)
    }

    MsgBox("Closed " . closed . " Notepad instance(s)", "Complete", "Icon!")
}

Example3() {
    MsgBox("Example 3: Cleanup Tool`n`nCreate a process cleanup utility:", "Example 3", "Icon!")

    CreateCleanupTool()
}

CreateCleanupTool() {
    gui := Gui(, "Process Cleanup Tool")
    gui.SetFont("s10")

    gui.Add("Text", "w450", "Process Cleanup and Termination Tool")

    gui.Add("Text", "w450", "Process to close:")
    processEdit := gui.Add("Edit", "w450", "notepad.exe")

    statusText := gui.Add("Edit", "w450 h150 +ReadOnly +Multi", "Enter process name and click Close Process")

    gui.Add("Button", "w450 h35", "Close Process").OnEvent("Click", CloseProc)
    gui.Add("Button", "w450 h35", "Close All Instances").OnEvent("Click", CloseAll)
    gui.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => gui.Destroy())

    CloseProc(*) {
        proc := processEdit.Value

        if pid := ProcessExist(proc) {
            if ProcessClose(pid) {
                statusText.Value := "✓ Closed: " . proc . " (PID: " . pid . ")`nTime: " . A_Now
            } else {
                statusText.Value := "✗ Failed to close: " . proc
            }
        } else {
            statusText.Value := "Process not found: " . proc
        }
    }

    CloseAll(*) {
        proc := processEdit.Value
        closed := 0

        statusText.Value := "Closing all instances of " . proc . "...`n"

        while pid := ProcessExist(proc) {
            if ProcessClose(pid) {
                closed++
                statusText.Value .= "Closed PID: " . pid . "`n"
                Sleep(100)
            } else {
                break
            }
        }

        statusText.Value .= "`nTotal closed: " . closed
    }

    gui.Show()
    MsgBox("Cleanup tool ready!", "Ready", "Icon!")
}

Example4() {
    MsgBox("Example 4: Safe Process Termination`n`nDemonstrate safe termination with checks:", "Example 4", "Icon!")

    Run("notepad.exe", , , &pid)
    Sleep(500)

    if ProcessExist(pid) {
        MsgBox("Process running: " . pid . "`nAttempting safe termination...", "Status", "T2")

        if ProcessClose(pid) {
            Sleep(500)

            if !ProcessExist(pid) {
                MsgBox("✓ Process terminated successfully`nVerified process no longer exists", "Success", "Icon!")
            } else {
                MsgBox("⚠ Process still running after close attempt!", "Warning")
            }
        }
    }
}

Example5() {
    MsgBox("Example 5: Batch Process Termination`n`nClose multiple processes:", "Example 5", "Icon!")

    processes := []

    ; Launch test processes
    Loop 5 {
        Run("notepad.exe", , , &pid)
        processes.Push(pid)
        Sleep(200)
    }

    MsgBox("Launched " . processes.Length . " processes`nPIDs: " . processes.Join(", "), "Launched", "T2")

    closed := 0
    failed := 0

    for pid in processes {
        if ProcessClose(pid) {
            closed++
        } else {
            failed++
        }
        Sleep(100)
    }

    MsgBox("Batch termination complete:`n`nClosed: " . closed . "`nFailed: " . failed, "Results", "Icon!")
}

Example6() {
    MsgBox("Example 6: Conditional Termination`n`nClose processes based on conditions:", "Example 6", "Icon!")

    gui := Gui(, "Conditional Process Killer")
    gui.SetFont("s10")

    gui.Add("Text", "w450", "Conditional Process Termination")

    processList := gui.Add("ListBox", "w450 h100")

    gui.Add("Button", "w450 h35", "Scan Running Processes").OnEvent("Click", ScanProcs)
    gui.Add("Button", "w450 h35", "Close Selected").OnEvent("Click", CloseSelected)
    gui.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => gui.Destroy())

    processes := Map()

    ScanProcs(*) {
        processList.Delete()
        processes.Clear()

        commonProcs := ["notepad.exe", "calc.exe", "mspaint.exe", "cmd.exe"]

        for proc in commonProcs {
            if pid := ProcessExist(proc) {
                processList.Add([proc . " (PID: " . pid . ")"])
                processes[proc] := pid
            }
        }
    }

    CloseSelected(*) {
        selection := processList.Text
        if selection = "" {
            MsgBox("Please select a process", "Error")
            return
        }

        ; Extract process name
        procName := RegExReplace(selection, " \(PID:.*\)", "")

        if processes.Has(procName) {
            if ProcessClose(processes[procName]) {
                MsgBox("Closed: " . procName, "Success", "Icon!")
                ScanProcs()
            }
        }
    }

    gui.Show()
    MsgBox("Conditional termination tool ready!", "Ready", "Icon!")
}

Example7() {
    MsgBox("Example 7: Advanced Process Manager`n`nComprehensive process management:", "Example 7", "Icon!")

    CreateProcessManager()
}

CreateProcessManager() {
    gui := Gui(, "Advanced Process Manager")
    gui.SetFont("s10")

    gui.Add("Text", "w500", "Advanced Process Management System")

    processView := gui.Add("ListView", "w500 h200", ["Process", "PID", "Status"])

    logText := gui.Add("Edit", "w500 h100 +ReadOnly +Multi", "Activity log...")

    gui.Add("Button", "w240 h35", "Refresh List").OnEvent("Click", RefreshList)
    gui.Add("Button", "x+20 yp w240 h35", "Close Selected").OnEvent("Click", CloseSelected)

    gui.Add("Button", "xm w500 h30", "Exit").OnEvent("Click", (*) => gui.Destroy())

    RefreshList(*) {
        processView.Delete()

        monitoredProcs := ["notepad.exe", "calc.exe", "mspaint.exe", "explorer.exe"]

        for proc in monitoredProcs {
            pid := ProcessExist(proc)
            status := pid ? "Running" : "Not Running"
            processView.Add(, proc, pid ? pid : "-", status)
        }

        logText.Value .= FormatTime(A_Now, "HH:mm:ss") . " - List refreshed`n"
    }

    CloseSelected(*) {
        row := processView.GetNext()
        if !row {
            MsgBox("Please select a process", "Error")
            return
        }

        proc := processView.GetText(row, 1)
        pid := processView.GetText(row, 2)

        if pid != "-" {
            if ProcessClose(Integer(pid)) {
                logText.Value .= FormatTime(A_Now, "HH:mm:ss") . " - Closed: " . proc . " (" . pid . ")`n"
                RefreshList()
            }
        }
    }

    RefreshList()
    gui.Show()
    MsgBox("Process manager ready!", "Ready", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "ProcessClose Examples (Part 04) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w450", "AutoHotkey v2 - ProcessClose (Batch close)")
    menu.SetFont("s9")

    menu.Add("Button", "w450 h35", "Example 1: Basic Process Closing").OnEvent("Click", (*) => (menu.Hide(), Example1(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 2: Close by Name").OnEvent("Click", (*) => (menu.Hide(), Example2(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 3: Cleanup Tool").OnEvent("Click", (*) => (menu.Hide(), Example3(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 4: Safe Termination").OnEvent("Click", (*) => (menu.Hide(), Example4(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 5: Batch Termination").OnEvent("Click", (*) => (menu.Hide(), Example5(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 6: Conditional Termination").OnEvent("Click", (*) => (menu.Hide(), Example6(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 7: Advanced Manager").OnEvent("Click", (*) => (menu.Hide(), Example7(), menu.Show()))

    menu.Add("Text", "w450 0x10")
    menu.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
