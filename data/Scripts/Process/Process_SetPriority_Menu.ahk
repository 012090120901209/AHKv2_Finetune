#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Process Priority Control
*
* Demonstrates adjusting process priority to optimize system
* performance and resource allocation.
*
* Source: xypha/AHK-v2-scripts - Showcase.ahk
* Inspired by: https://github.com/xypha/AHK-v2-scripts
*/

MsgBox("Process Priority Control Demo`n`n"
. "Hotkey: Win+P`n`n"
. "Opens a menu to adjust the priority of the active window's process.`n`n"
. "Priority Levels:`n"
. "- Low: Background tasks`n"
. "- Below Normal: Less important`n"
. "- Normal: Default`n"
. "- Above Normal: Important tasks`n"
. "- High: Critical tasks`n"
. "- Realtime: System-level (危险!)", , "T7")

; Open Notepad for demo
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")

MsgBox("Press Win+P to adjust Notepad's priority!", , "T3")

; Hotkey to show priority menu
#p::ShowPriorityMenu()

/**
* Show process priority adjustment menu
*/
ShowPriorityMenu() {
    ; Get active window
    hwnd := WinExist("A")
    if (!hwnd) {
        MsgBox("No active window", "Priority Control", "T2")
        return
    }

    ; Get process info
    title := WinGetTitle("ahk_id " hwnd)
    processName := WinGetProcessName("ahk_id " hwnd)
    pid := WinGetPID("ahk_id " hwnd)

    ; Get current priority
    currentPriority := ProcessGetPriority(pid)
    currentText := PriorityToText(currentPriority)

    ; Create menu
    priorityMenu := Menu()
    priorityMenu.Add("Low", (*) => SetPriority(pid, "L"))
    priorityMenu.Add("Below Normal", (*) => SetPriority(pid, "B"))
    priorityMenu.Add("Normal", (*) => SetPriority(pid, "N"))
    priorityMenu.Add("Above Normal", (*) => SetPriority(pid, "A"))
    priorityMenu.Add("High", (*) => SetPriority(pid, "H"))
    priorityMenu.Add()
    priorityMenu.Add("Realtime (危险!)", (*) => SetPriorityRealtime(pid))

    ; Check current priority
    switch currentPriority {
        case "L": priorityMenu.Check("Low")
        case "B": priorityMenu.Check("Below Normal")
        case "N": priorityMenu.Check("Normal")
        case "A": priorityMenu.Check("Above Normal")
        case "H": priorityMenu.Check("High")
        case "R": priorityMenu.Check("Realtime (危险!)")
    }

    ; Show info tooltip
    ToolTip("Process: " processName "`n"
    . "PID: " pid "`n"
    . "Current: " currentText)
    SetTimer(() => ToolTip(), -3000)

    ; Show menu
    priorityMenu.Show()
}

/**
* Set process priority
*/
SetPriority(pid, priority) {
    try {
        ProcessSetPriority(priority, pid)

        processName := ProcessGetName(pid)
        priorityText := PriorityToText(priority)

        ToolTip("Priority set to: " priorityText "`n" processName)
        SetTimer(() => ToolTip(), -2000)
    } catch Error as e {
        MsgBox("Failed to set priority:`n" e.Message, "Error", "Icon!")
    }
}

/**
* Set realtime priority with warning
*/
SetPriorityRealtime(pid) {
    result := MsgBox("⚠ WARNING ⚠`n`n"
    . "Realtime priority can make your system unstable!`n`n"
    . "The process will have higher priority than system processes.`n"
    . "Your mouse/keyboard may become unresponsive.`n`n"
    . "Continue?",
    "Realtime Warning", "YesNo Icon! Default2")

    if (result == "Yes")
    SetPriority(pid, "R")
}

/**
* Convert priority code to text
*/
PriorityToText(priority) {
    switch priority {
        case "L": return "Low"
        case "B": return "Below Normal"
        case "N": return "Normal"
        case "A": return "Above Normal"
        case "H": return "High"
        case "R": return "Realtime"
        default: return "Unknown"
    }
}

/*
* Key Concepts:
*
* 1. Process Priority Levels:
*    L = Low (Idle)
*    B = Below Normal
*    N = Normal (Default)
*    A = Above Normal
*    H = High
*    R = Realtime (Dangerous)
*
* 2. Priority Impact:
*    Low: Background tasks, minimal CPU
*    Normal: Standard applications
*    High: Time-critical tasks
*    Realtime: System-level priority
*
* 3. ProcessSetPriority:
*    ProcessSetPriority(level, PID)
*    Requires appropriate permissions
*    Affects entire process
*
* 4. Process Information:
*    WinGetPID() - Get process ID from window
*    ProcessGetName() - Get executable name
*    ProcessGetPriority() - Get current priority
*
* 5. Use Cases:
*    Low: Backup/sync tasks
*    High: Video encoding
*    High: Gaming performance
*    Above: Audio production
*
* 6. Realtime Warning:
*    Can freeze system
*    Only for critical tasks
*    Requires admin rights
*    Use with extreme caution
*
* 7. Best Practices:
*    ✅ Show current priority
*    ✅ Confirm dangerous changes
*    ✅ Display process info
*    ✅ Handle errors
*
* 8. Menu Pattern:
*    Radio-style selection
*    Check current value
*    Descriptive labels
*    Separate dangerous options
*
* 9. Error Handling:
*    try/catch for permission errors
*    Process may not exist
*    Admin rights required
*    Show error messages
*
* 10. Performance Impact:
*     Low: May slow down task
*     High: More responsive, higher CPU
*     Realtime: Maximum priority
*     Normal: Balanced approach
*
* 11. Related Functions:
*     ProcessClose() - Kill process
*     ProcessWait() - Wait for process
*     ProcessExist() - Check if running
*     Run(..., , , &PID) - Get PID on start
*
* 12. Advanced Usage:
*     - Save priority presets
*     - Auto-adjust by app
*     - CPU affinity control
*     - Thread priority
*     - Performance profiles
*/
