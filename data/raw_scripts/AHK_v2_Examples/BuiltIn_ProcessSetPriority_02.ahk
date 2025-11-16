#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Examples - ProcessSetPriority Function (Part 02: Performance tuning)
 * ============================================================================
 *
 * ProcessSetPriority changes a process's CPU priority level.
 *
 * @description Examples demonstrating performance tuning
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 *
 * SYNTAX:
 *   ProcessSetPriority(Level, PIDOrName)
 *
 * PRIORITY LEVELS:
 *   - "Low" or "L"
 *   - "BelowNormal" or "B"
 *   - "Normal" or "N"
 *   - "AboveNormal" or "A"
 *   - "High" or "H"
 *   - "Realtime" or "R"
 */

; ============================================================================
; Examples 1-7: Process priority management
; ============================================================================

Example1() {
    MsgBox("Example 1: Basic Priority Setting`n`nSet process priority levels:", "ProcessSetPriority - Example 1", "Icon!")
    
    MsgBox("Launching Notepad...", "Launching", "T1")
    Run("notepad.exe", , , &pid)
    Sleep(500)
    
    MsgBox("Setting Notepad priority to LOW...", "Setting", "T1")
    
    try {
        ProcessSetPriority("Low", pid)
        MsgBox("✓ Priority set to LOW`nPID: " . pid, "Success", "Icon! T2")
    } catch Error as err {
        MsgBox("Failed: " . err.Message, "Error")
    }
    
    Sleep(1500)
    
    MsgBox("Setting priority to HIGH...", "Setting", "T1")
    
    try {
        ProcessSetPriority("High", pid)
        MsgBox("✓ Priority set to HIGH`nPID: " . pid, "Success", "Icon! T2")
    } catch Error as err {
        MsgBox("Failed: " . err.Message, "Error")
    }
    
    Sleep(1500)
    ProcessClose(pid)
    MsgBox("Demonstration complete!", "Complete", "Icon!")
}

Example2() {
    MsgBox("Example 2: Priority Levels Comparison`n`nCompare all priority levels:", "Example 2", "Icon!")
    
    priorities := ["Low", "BelowNormal", "Normal", "AboveNormal", "High"]
    
    Run("notepad.exe", , , &pid)
    Sleep(500)
    
    for priority in priorities {
        MsgBox("Setting priority: " . priority, "Setting", "T1")
        
        try {
            ProcessSetPriority(priority, pid)
            MsgBox("✓ " . priority . " priority set", "Success", "T1")
        } catch Error as err {
            MsgBox("Failed: " . priority . " - " . err.Message, "Error", "T2")
        }
        
        Sleep(1000)
    }
    
    ProcessClose(pid)
    MsgBox("All priority levels tested!", "Complete", "Icon!")
}

Example3() {
    MsgBox("Example 3: Priority Manager GUI`n`nCreate interactive priority manager:", "Example 3", "Icon!")
    
    CreatePriorityManager()
}

CreatePriorityManager() {
    gui := Gui(, "Process Priority Manager")
    gui.SetFont("s10")
    
    gui.Add("Text", "w450", "Process Priority Management Tool")
    
    gui.Add("Text", "w450", "Process name or PID:")
    processEdit := gui.Add("Edit", "w450", "notepad.exe")
    
    gui.Add("Text", "w450", "Priority Level:")
    priorityDD := gui.Add("DropDownList", "w450", ["Low", "BelowNormal", "Normal", "AboveNormal", "High"])
    priorityDD.Choose(3)
    
    statusText := gui.Add("Edit", "w450 h150 +ReadOnly +Multi", "Select process and priority, then click Set Priority")
    
    gui.Add("Button", "w450 h35", "Set Priority").OnEvent("Click", SetPrio)
    gui.Add("Button", "w450 h35", "Launch Test Process").OnEvent("Click", LaunchTest)
    gui.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => gui.Destroy())
    
    testPID := 0
    
    LaunchTest(*) {
        Run("notepad.exe", , , &pid)
        testPID := pid
        processEdit.Value := pid
        statusText.Value := "Launched test process (PID: " . pid . ")"
    }
    
    SetPrio(*) {
        proc := processEdit.Value
        priority := priorityDD.Text
        
        try {
            ProcessSetPriority(priority, proc)
            statusText.Value := "✓ Set priority: " . priority . "`nProcess: " . proc . "`nTime: " . A_Now
        } catch Error as err {
            statusText.Value := "✗ Failed to set priority`nError: " . err.Message
        }
    }
    
    gui.OnClose := (*) => (testPID && ProcessExist(testPID) ? ProcessClose(testPID) : 0, gui.Destroy())
    
    gui.Show()
    MsgBox("Priority manager ready!", "Ready", "Icon!")
}

Example4() {
    MsgBox("Example 4: Background Process Optimization`n`nOptimize background processes:", "Example 4", "Icon!")
    
    MsgBox("Launching 3 background processes...", "Launching", "T2")
    
    processes := []
    Loop 3 {
        Run("notepad.exe", , "Min", &pid)
        processes.Push(pid)
        Sleep(200)
    }
    
    MsgBox("Setting all to LOW priority for background operation...", "Optimizing", "T2")
    
    for pid in processes {
        try {
            ProcessSetPriority("Low", pid)
        }
    }
    
    MsgBox("All background processes optimized!`n`nPIDs: " . processes.Join(", ") . "`nPriority: LOW", "Complete", "Icon! T3")
    
    for pid in processes {
        ProcessClose(pid)
    }
}

Example5() {
    MsgBox("Example 5: Performance Tuning`n`nDemonstrate performance tuning scenarios:", "Example 5", "Icon!")
    
    gui := Gui(, "Performance Tuning")
    gui.SetFont("s10")
    
    gui.Add("Text", "w450", "Performance Tuning Scenarios")
    
    logText := gui.Add("Edit", "w450 h200 +ReadOnly +Multi", "Performance tuning scenarios:")
    
    gui.Add("Button", "w450 h35", "CPU-Intensive Task (High Priority)").OnEvent("Click", HighPrio)
    gui.Add("Button", "w450 h35", "Background Task (Low Priority)").OnEvent("Click", LowPrio)
    gui.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => gui.Destroy())
    
    HighPrio(*) {
        logText.Value .= "`nScenario: CPU-Intensive Task`n"
        Run("notepad.exe", , , &pid)
        
        try {
            ProcessSetPriority("High", pid)
            logText.Value .= "✓ Set to HIGH priority for better performance`nPID: " . pid . "`n"
        } catch Error as err {
            logText.Value .= "✗ Failed: " . err.Message . "`n"
        }
        
        Sleep(2000)
        ProcessClose(pid)
    }
    
    LowPrio(*) {
        logText.Value .= "`nScenario: Background Task`n"
        Run("notepad.exe", , "Min", &pid)
        
        try {
            ProcessSetPriority("Low", pid)
            logText.Value .= "✓ Set to LOW priority to save CPU`nPID: " . pid . "`n"
        } catch Error as err {
            logText.Value .= "✗ Failed: " . err.Message . "`n"
        }
        
        Sleep(2000)
        ProcessClose(pid)
    }
    
    gui.Show()
    MsgBox("Performance tuning tool ready!", "Ready", "Icon!")
}

Example6() {
    MsgBox("Example 6: Priority-Based Task Scheduler`n`nSchedule tasks with different priorities:", "Example 6", "Icon!")
    
    tasks := [
        {name: "Critical Task", priority: "High"},
        {name: "Normal Task", priority: "Normal"},
        {name: "Background Task", priority: "Low"}
    ]
    
    results := "Task Scheduling Results:`n`n"
    
    for task in tasks {
        Run("notepad.exe", , , &pid)
        Sleep(200)
        
        try {
            ProcessSetPriority(task.priority, pid)
            results .= "✓ " . task.name . " (Priority: " . task.priority . ", PID: " . pid . ")`n"
            Sleep(1000)
            ProcessClose(pid)
        } catch Error as err {
            results .= "✗ " . task.name . " failed`n"
        }
    }
    
    MsgBox(results, "Scheduling Complete", "Icon!")
}

Example7() {
    MsgBox("Example 7: System Resource Manager`n`nComprehensive resource management:", "Example 7", "Icon!")
    
    CreateResourceManager()
}

CreateResourceManager() {
    gui := Gui(, "System Resource Manager")
    gui.SetFont("s10")
    
    gui.Add("Text", "w500", "System Resource Management Dashboard")
    
    processView := gui.Add("ListView", "w500 h150", ["Process", "PID", "Priority"])
    
    gui.Add("Text", "w500", "Set Priority:")
    priorityDD := gui.Add("DropDownList", "w500", ["Low", "BelowNormal", "Normal", "AboveNormal", "High"])
    priorityDD.Choose(3)
    
    logText := gui.Add("Edit", "w500 h100 +ReadOnly +Multi", "System log...")
    
    gui.Add("Button", "w240 h35", "Refresh List").OnEvent("Click", RefreshList)
    gui.Add("Button", "x+20 yp w240 h35", "Set Priority").OnEvent("Click", SetPrio)
    
    gui.Add("Button", "xm w500 h30", "Exit").OnEvent("Click", (*) => gui.Destroy())
    
    processes := []
    
    RefreshList(*) {
        processView.Delete()
        processes := []
        
        monProcs := ["notepad.exe", "calc.exe", "mspaint.exe"]
        
        for proc in monProcs {
            if pid := ProcessExist(proc) {
                processes.Push({name: proc, pid: pid})
                processView.Add(, proc, pid, "Unknown")
            }
        }
        
        logText.Value .= FormatTime(A_Now, "HH:mm:ss") . " - Refreshed`n"
    }
    
    SetPrio(*) {
        row := processView.GetNext()
        if !row {
            MsgBox("Select a process", "Error")
            return
        }
        
        pid := Integer(processView.GetText(row, 2))
        priority := priorityDD.Text
        
        try {
            ProcessSetPriority(priority, pid)
            processView.Modify(row, , , , priority)
            logText.Value .= FormatTime(A_Now, "HH:mm:ss") . " - Set " . pid . " to " . priority . "`n"
        } catch Error as err {
            logText.Value .= "Error: " . err.Message . "`n"
        }
    }
    
    RefreshList()
    gui.Show()
    MsgBox("Resource manager ready!", "Ready", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "ProcessSetPriority Examples (Part 02) - Main Menu")
    menu.SetFont("s10")
    
    menu.Add("Text", "w500", "AutoHotkey v2 - ProcessSetPriority (Performance tuning)")
    menu.SetFont("s9")
    
    menu.Add("Button", "w500 h35", "Example 1: Basic Priority Setting").OnEvent("Click", (*) => (menu.Hide(), Example1(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 2: Priority Levels Comparison").OnEvent("Click", (*) => (menu.Hide(), Example2(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 3: Priority Manager GUI").OnEvent("Click", (*) => (menu.Hide(), Example3(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 4: Background Process Optimization").OnEvent("Click", (*) => (menu.Hide(), Example4(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 5: Performance Tuning").OnEvent("Click", (*) => (menu.Hide(), Example5(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 6: Priority-Based Task Scheduler").OnEvent("Click", (*) => (menu.Hide(), Example6(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 7: System Resource Manager").OnEvent("Click", (*) => (menu.Hide(), Example7(), menu.Show()))
    
    menu.Add("Text", "w500 0x10")
    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())
    
    menu.Show()
}

ShowMainMenu()
