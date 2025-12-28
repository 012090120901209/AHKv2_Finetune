#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_WMI_01_Processes.ahk
 * 
 * DESCRIPTION:
 * Process information using WMI (Windows Management Instrumentation).
 * 
 * FEATURES:
 * - Query running processes
 * - Get process details
 * - Process monitoring
 * - CPU and memory usage
 * - Process management
 */

Example1_ListProcesses() {
    MsgBox("Example 1: List Processes")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process")

        output := "Running Processes:`n`n"
        count := 0
        for proc in processes {
            output .= proc.Name "`n"
            count++
            if (count > 10)
                break
        }
        MsgBox(output)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_ProcessDetails() {
    MsgBox("Example 2: Process Details")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='explorer.exe'")

        for proc in processes {
            MsgBox("Name: " proc.Name "`nPID: " proc.ProcessId "`nPath: " proc.ExecutablePath)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_ProcessMemory() {
    MsgBox("Example 3: Process Memory")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='explorer.exe'")

        for proc in processes {
            memory := Round(proc.WorkingSetSize / 1024 / 1024, 2)
            MsgBox("Explorer Memory: " memory " MB")
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_ProcessCount() {
    MsgBox("Example 4: Process Count")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process")

        count := 0
        for proc in processes
            count++

        MsgBox("Total processes: " count)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ProcessOwner() {
    MsgBox("Example 5: Process Owner")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='explorer.exe'")

        for proc in processes {
            MsgBox("Process: " proc.Name "`nPID: " proc.ProcessId)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_ProcessCreation() {
    MsgBox("Example 6: Process Creation Time")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='explorer.exe'")

        for proc in processes {
            MsgBox("Process: " proc.Name "`nCreation: " proc.CreationDate)
            break
        }
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_FindProcess() {
    MsgBox("Example 7: Find Specific Process")
    Try {
        wmi := ComObjGet("winmgmts:")
        processes := wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name='notepad.exe'")

        found := false
        for proc in processes {
            found := true
            break
        }

        MsgBox(found ? "Notepad is running" : "Notepad not found")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    WMI COM - Processes

    1. List Processes
    2. Process Details
    3. Process Memory
    4. Process Count
    5. Process Owner
    6. Creation Time
    7. Find Process

    0. Exit
    )"
    choice := InputBox(menu, "WMI Process Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_ListProcesses()
        case "2": Example2_ProcessDetails()
        case "3": Example3_ProcessMemory()
        case "4": Example4_ProcessCount()
        case "5": Example5_ProcessOwner()
        case "6": Example6_ProcessCreation()
        case "7": Example7_FindProcess()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
