/**
 * @file BuiltIn_WinGetPID_01.ahk
 * @description Comprehensive examples demonstrating WinGetPID function for retrieving process IDs from windows in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Basic PID retrieval
 * Example 2: Process information gatherer
 * Example 3: Window-to-process mapper
 * Example 4: Process resource monitor
 * Example 5: Multi-window process detector
 * Example 6: Process hierarchy explorer
 * Example 7: PID-based window management
 * 
 * @section FEATURES
 * - Get process IDs from windows
 * - Link windows to processes
 * - Monitor process resources
 * - Detect multi-window processes
 * - Explore process hierarchies
 * - PID-based management
 * - Process analysis
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic PID Retrieval
; ========================================

/**
 * @function GetWindowPID
 * @description Get the process ID of a window
 * @param WinTitle Window identifier
 * @returns {Integer} Process ID
 */
GetWindowPID(WinTitle := "A") {
    try {
        return WinGetPID(WinTitle)
    } catch {
        return 0
    }
}

/**
 * @function ShowWindowPIDInfo
 * @description Display comprehensive PID information for a window
 * @param WinTitle Window identifier
 */
ShowWindowPIDInfo(WinTitle := "A") {
    try {
        pid := WinGetPID(WinTitle)
        processName := WinGetProcessName(WinTitle)
        processPath := WinGetProcessPath(WinTitle)
        winTitle := WinGetTitle(WinTitle)
        className := WinGetClass(WinTitle)

        info := "Window Process Information:`n`n"
        info .= "Window: " winTitle "`n"
        info .= "Class: " className "`n`n"
        info .= "Process ID (PID): " pid "`n"
        info .= "Process Name: " processName "`n"
        info .= "Process Path: " processPath

        MsgBox(info, "Window PID Info", "Icon!")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", "IconX")
    }
}

; Hotkey: Ctrl+Shift+P - Show window PID info
^+p:: ShowWindowPIDInfo("A")

; ========================================
; Example 2: Process Information Gatherer
; ========================================

/**
 * @class ProcessInfo
 * @description Gather detailed information about processes
 */
class ProcessInfo {
    /**
     * @method GetDetailedInfo
     * @description Get detailed process information
     * @param pid Process ID
     * @returns {Object} Process information
     */
    static GetDetailedInfo(pid) {
        try {
            ; Open process for query
            hProcess := DllCall("OpenProcess", "UInt", 0x1000, "Int", false, "UInt", pid, "Ptr")

            if !hProcess {
                return { Error: "Cannot open process" }
            }

            info := {
                PID: pid,
                ProcessName: this.GetProcessName(pid),
                ParentPID: this.GetParentPID(pid),
                ThreadCount: this.GetThreadCount(pid),
                HandleCount: this.GetHandleCount(hProcess),
                WorkingSetSize: this.GetWorkingSetSize(hProcess),
                StartTime: this.GetProcessStartTime(pid),
                CommandLine: this.GetCommandLine(pid)
            }

            DllCall("CloseHandle", "Ptr", hProcess)
            return info

        } catch as err {
            return { Error: err.Message }
        }
    }

    /**
     * @method GetProcessName
     * @description Get process name from PID
     * @param pid Process ID
     * @returns {String} Process name
     */
    static GetProcessName(pid) {
        try {
            ; Find window with this PID
            allWindows := WinGetList()
            for winId in allWindows {
                try {
                    if WinGetPID("ahk_id " winId) = pid {
                        return WinGetProcessName("ahk_id " winId)
                    }
                }
            }

            ; Alternative method using WMI
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()
            processes := service.ExecQuery("SELECT Name FROM Win32_Process WHERE ProcessId = " pid)

            for process in processes {
                return process.Name
            }

        } catch {
            return "Unknown"
        }

        return "Unknown"
    }

    /**
     * @method GetParentPID
     * @description Get parent process ID
     * @param pid Child process ID
     * @returns {Integer} Parent PID
     */
    static GetParentPID(pid) {
        try {
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()
            processes := service.ExecQuery("SELECT ParentProcessId FROM Win32_Process WHERE ProcessId = " pid)

            for process in processes {
                return process.ParentProcessId
            }
        } catch {
            return 0
        }

        return 0
    }

    /**
     * @method GetThreadCount
     * @description Get number of threads
     * @param pid Process ID
     * @returns {Integer} Thread count
     */
    static GetThreadCount(pid) {
        try {
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()
            processes := service.ExecQuery("SELECT ThreadCount FROM Win32_Process WHERE ProcessId = " pid)

            for process in processes {
                return process.ThreadCount
            }
        } catch {
            return 0
        }

        return 0
    }

    /**
     * @method GetHandleCount
     * @description Get number of handles
     * @param hProcess Process handle
     * @returns {Integer} Handle count
     */
    static GetHandleCount(hProcess) {
        handleCount := 0
        DllCall("GetProcessHandleCount", "Ptr", hProcess, "UInt*", &handleCount)
        return handleCount
    }

    /**
     * @method GetWorkingSetSize
     * @description Get process memory working set size
     * @param hProcess Process handle
     * @returns {Integer} Working set size in bytes
     */
    static GetWorkingSetSize(hProcess) {
        memCounters := Buffer(72, 0)  ; PROCESS_MEMORY_COUNTERS_EX
        NumPut("UInt", 72, memCounters, 0)

        if DllCall("Psapi\GetProcessMemoryInfo", "Ptr", hProcess, "Ptr", memCounters, "UInt", 72) {
            return NumGet(memCounters, 8, "UPtr")  ; WorkingSetSize
        }

        return 0
    }

    /**
     * @method GetProcessStartTime
     * @description Get process start time
     * @param pid Process ID
     * @returns {String} Start time
     */
    static GetProcessStartTime(pid) {
        try {
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()
            processes := service.ExecQuery("SELECT CreationDate FROM Win32_Process WHERE ProcessId = " pid)

            for process in processes {
                wmiTime := process.CreationDate
                ; Convert WMI datetime to readable format
                year := SubStr(wmiTime, 1, 4)
                month := SubStr(wmiTime, 5, 2)
                day := SubStr(wmiTime, 7, 2)
                hour := SubStr(wmiTime, 9, 2)
                minute := SubStr(wmiTime, 11, 2)
                second := SubStr(wmiTime, 13, 2)

                return year "-" month "-" day " " hour ":" minute ":" second
            }
        } catch {
            return "Unknown"
        }

        return "Unknown"
    }

    /**
     * @method GetCommandLine
     * @description Get process command line
     * @param pid Process ID
     * @returns {String} Command line
     */
    static GetCommandLine(pid) {
        try {
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()
            processes := service.ExecQuery("SELECT CommandLine FROM Win32_Process WHERE ProcessId = " pid)

            for process in processes {
                return process.CommandLine ?? ""
            }
        } catch {
            return ""
        }

        return ""
    }

    /**
     * @method FormatSize
     * @description Format byte size to human readable
     * @param bytes Size in bytes
     * @returns {String} Formatted size
     */
    static FormatSize(bytes) {
        if bytes >= 1073741824
            return Round(bytes / 1073741824, 2) " GB"
        if bytes >= 1048576
            return Round(bytes / 1048576, 2) " MB"
        if bytes >= 1024
            return Round(bytes / 1024, 2) " KB"
        return bytes " bytes"
    }
}

; Hotkey: Ctrl+Shift+I - Show detailed process info
^+i:: {
    pid := WinGetPID("A")
    info := ProcessInfo.GetDetailedInfo(pid)

    if info.HasOwnProp("Error") {
        MsgBox(info.Error, "Error", "IconX")
        return
    }

    output := "=== Detailed Process Information ===`n`n"
    output .= "PID: " info.PID "`n"
    output .= "Process Name: " info.ProcessName "`n"
    output .= "Parent PID: " info.ParentPID "`n"
    output .= "Threads: " info.ThreadCount "`n"
    output .= "Handles: " info.HandleCount "`n"
    output .= "Memory: " ProcessInfo.FormatSize(info.WorkingSetSize) "`n"
    output .= "Start Time: " info.StartTime "`n`n"

    if info.CommandLine != ""
        output .= "Command Line:`n" info.CommandLine

    MsgBox(output, "Process Info", "Icon!")
}

; ========================================
; Example 3: Window-to-Process Mapper
; ========================================

/**
 * @class WindowProcessMapper
 * @description Map windows to their parent processes
 */
class WindowProcessMapper {
    /**
     * @method GetProcessWindows
     * @description Get all windows for a specific process ID
     * @param pid Process ID
     * @returns {Array} Array of window information
     */
    static GetProcessWindows(pid) {
        windows := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if WinGetPID("ahk_id " winId) = pid {
                    windows.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId),
                        Class: WinGetClass("ahk_id " winId),
                        Visible: WinGetStyle("ahk_id " winId) & 0x10000000
                    })
                }
            }
        }

        return windows
    }

    /**
     * @method GetProcessMap
     * @description Get complete map of processes and their windows
     * @returns {Map} Process map
     */
    static GetProcessMap() {
        processMap := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                pid := WinGetPID("ahk_id " winId)

                if !processMap.Has(pid) {
                    processMap[pid] := {
                        PID: pid,
                        ProcessName: WinGetProcessName("ahk_id " winId),
                        Windows: []
                    }
                }

                processMap[pid].Windows.Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId)
                })
            }
        }

        return processMap
    }

    /**
     * @method GetMultiWindowProcesses
     * @description Get processes that have multiple windows
     * @returns {Array} Processes with multiple windows
     */
    static GetMultiWindowProcesses() {
        processMap := this.GetProcessMap()
        multiWindow := []

        for pid, data in processMap {
            if data.Windows.Length > 1 {
                multiWindow.Push(data)
            }
        }

        return multiWindow
    }

    /**
     * @method CountWindowsForProcess
     * @description Count windows for a process
     * @param pid Process ID
     * @returns {Integer} Window count
     */
    static CountWindowsForProcess(pid) {
        count := 0
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if WinGetPID("ahk_id " winId) = pid {
                    count++
                }
            }
        }

        return count
    }
}

; Hotkey: Ctrl+Shift+M - Show process window map
^+m:: {
    pid := WinGetPID("A")
    windows := WindowProcessMapper.GetProcessWindows(pid)

    if windows.Length = 0 {
        MsgBox("No windows found for this process", "Info", "Icon!")
        return
    }

    output := "Process has " windows.Length " window(s):`n`n"

    for i, win in windows {
        if i > 15
            break

        output .= win.Class
        if win.Title != ""
            output .= " - " SubStr(win.Title, 1, 40)
        output .= "`n"
    }

    MsgBox(output, "Process Windows", "Icon!")
}

; ========================================
; Example 4: Process Resource Monitor
; ========================================

/**
 * @class ProcessMonitor
 * @description Monitor process resource usage
 */
class ProcessMonitor {
    static monitoredPID := 0
    static monitorGui := ""
    static updateTimer := 0

    /**
     * @method StartMonitoring
     * @description Begin monitoring a process
     * @param pid Process ID
     */
    static StartMonitoring(pid) {
        this.monitoredPID := pid

        ; Create GUI
        this.monitorGui := Gui("+AlwaysOnTop", "Process Monitor - PID: " pid)
        this.monitorGui.SetFont("s10", "Consolas")

        this.monitorGui.Add("Text", "w400", "Process Resource Monitor")
        this.monitorGui.Add("Text", "w400 vProcessName", "Process: ")
        this.monitorGui.Add("Text", "w400 vMemory", "Memory: ")
        this.monitorGui.Add("Text", "w400 vThreads", "Threads: ")
        this.monitorGui.Add("Text", "w400 vHandles", "Handles: ")
        this.monitorGui.Add("Text", "w400 vWindows", "Windows: ")

        this.monitorGui.Add("Button", "w200", "Stop Monitoring").OnEvent("Click", (*) => this.StopMonitoring())

        this.monitorGui.Show()

        ; Start update timer
        this.updateTimer := SetTimer(() => this.UpdateMonitor(), 1000)
    }

    /**
     * @method StopMonitoring
     * @description Stop monitoring
     */
    static StopMonitoring() {
        if this.updateTimer {
            SetTimer(this.updateTimer, 0)
            this.updateTimer := 0
        }

        if this.monitorGui {
            this.monitorGui.Destroy()
            this.monitorGui := ""
        }

        this.monitoredPID := 0
    }

    /**
     * @method UpdateMonitor
     * @description Update monitor display
     */
    static UpdateMonitor() {
        if !this.monitorGui || !this.monitoredPID
            return

        try {
            info := ProcessInfo.GetDetailedInfo(this.monitoredPID)

            if info.HasOwnProp("Error") {
                this.StopMonitoring()
                MsgBox("Process no longer exists", "Monitor Stopped", "Icon!")
                return
            }

            windowCount := WindowProcessMapper.CountWindowsForProcess(this.monitoredPID)

            this.monitorGui["ProcessName"].Value := "Process: " info.ProcessName
            this.monitorGui["Memory"].Value := "Memory: " ProcessInfo.FormatSize(info.WorkingSetSize)
            this.monitorGui["Threads"].Value := "Threads: " info.ThreadCount
            this.monitorGui["Handles"].Value := "Handles: " info.HandleCount
            this.monitorGui["Windows"].Value := "Windows: " windowCount

        } catch {
            this.StopMonitoring()
        }
    }
}

; Hotkey: Ctrl+Shift+R - Start resource monitoring
^+r:: {
    pid := WinGetPID("A")
    ProcessMonitor.StartMonitoring(pid)
}

; ========================================
; Example 5: Multi-Window Process Detector
; ========================================

/**
 * @function DetectMultiWindowProcesses
 * @description Detect and report processes with multiple windows
 */
DetectMultiWindowProcesses() {
    multiProc := WindowProcessMapper.GetMultiWindowProcesses()

    if multiProc.Length = 0 {
        MsgBox("No multi-window processes detected", "Info", "Icon!")
        return
    }

    output := "Multi-Window Processes (" multiProc.Length "):`n`n"

    for data in multiProc {
        output .= data.ProcessName " (PID: " data.PID ")`n"
        output .= "  Windows: " data.Windows.Length "`n`n"

        if A_Index > 10
            break
    }

    MsgBox(output, "Multi-Window Processes", "Icon!")
}

; Hotkey: Ctrl+Shift+D - Detect multi-window processes
^+d:: DetectMultiWindowProcesses()

; ========================================
; Example 6: Process Hierarchy Explorer
; ========================================

/**
 * @class ProcessHierarchy
 * @description Explore process parent-child relationships
 */
class ProcessHierarchy {
    /**
     * @method GetProcessTree
     * @description Get process tree starting from a PID
     * @param pid Root process ID
     * @returns {Object} Process tree
     */
    static GetProcessTree(pid) {
        tree := {
            PID: pid,
            ProcessName: ProcessInfo.GetProcessName(pid),
            Parent: {},
            Children: []
        }

        ; Get parent
        parentPID := ProcessInfo.GetParentPID(pid)
        if parentPID && parentPID != 0 {
            tree.Parent := {
                PID: parentPID,
                ProcessName: ProcessInfo.GetProcessName(parentPID)
            }
        }

        ; Get children
        children := this.GetChildProcesses(pid)
        for childPID in children {
            tree.Children.Push({
                PID: childPID,
                ProcessName: ProcessInfo.GetProcessName(childPID)
            })
        }

        return tree
    }

    /**
     * @method GetChildProcesses
     * @description Get child processes of a PID
     * @param parentPID Parent process ID
     * @returns {Array} Child PIDs
     */
    static GetChildProcesses(parentPID) {
        children := []

        try {
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()
            processes := service.ExecQuery("SELECT ProcessId FROM Win32_Process WHERE ParentProcessId = " parentPID)

            for process in processes {
                children.Push(process.ProcessId)
            }
        }

        return children
    }
}

; Hotkey: Ctrl+Shift+T - Show process tree
^+t:: {
    pid := WinGetPID("A")
    tree := ProcessHierarchy.GetProcessTree(pid)

    output := "=== Process Hierarchy ===`n`n"

    if tree.Parent.HasOwnProp("PID") {
        output .= "Parent Process:`n"
        output .= "  " tree.Parent.ProcessName " (PID: " tree.Parent.PID ")`n`n"
    }

    output .= "Current Process:`n"
    output .= "  " tree.ProcessName " (PID: " tree.PID ")`n`n"

    if tree.Children.Length > 0 {
        output .= "Child Processes: " tree.Children.Length "`n"
        for child in tree.Children {
            output .= "  " child.ProcessName " (PID: " child.PID ")`n"
        }
    } else {
        output .= "No child processes"
    }

    MsgBox(output, "Process Hierarchy", "Icon!")
}

; ========================================
; Example 7: PID-Based Window Management
; ========================================

/**
 * @class PIDWindowManager
 * @description Manage windows based on their process ID
 */
class PIDWindowManager {
    /**
     * @method CloseProcessWindows
     * @description Close all windows for a process
     * @param pid Process ID
     */
    static CloseProcessWindows(pid) {
        windows := WindowProcessMapper.GetProcessWindows(pid)

        result := MsgBox("Close " windows.Length " window(s)?", "Confirm", "YesNo Icon?")
        if result = "No"
            return

        for win in windows {
            try {
                WinClose("ahk_id " win.ID)
            }
        }
    }

    /**
     * @method MinimizeProcessWindows
     * @description Minimize all windows for a process
     * @param pid Process ID
     */
    static MinimizeProcessWindows(pid) {
        windows := WindowProcessMapper.GetProcessWindows(pid)

        for win in windows {
            try {
                WinMinimize("ahk_id " win.ID)
            }
        }

        TrayTip("Minimized " windows.Length " windows", "PID Manager", "Icon!")
    }

    /**
     * @method TerminateProcess
     * @description Terminate a process by PID
     * @param pid Process ID
     */
    static TerminateProcess(pid) {
        result := MsgBox("Terminate process " pid "?", "Confirm", "YesNo Icon!")
        if result = "No"
            return

        try {
            Run("taskkill /F /PID " pid, , "Hide")
            TrayTip("Process terminated: " pid, "PID Manager", "Icon!")
        } catch as err {
            MsgBox("Failed to terminate: " err.Message, "Error", "IconX")
        }
    }
}

; Hotkey: Ctrl+Alt+C - Close all process windows
^!c:: {
    pid := WinGetPID("A")
    PIDWindowManager.CloseProcessWindows(pid)
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetPID Examples - Hotkeys:

    Ctrl+Shift+P  - Show window PID info
    Ctrl+Shift+I  - Show detailed process info
    Ctrl+Shift+M  - Show process window map
    Ctrl+Shift+R  - Start resource monitoring
    Ctrl+Shift+D  - Detect multi-window processes
    Ctrl+Shift+T  - Show process tree
    Ctrl+Alt+C    - Close all process windows
    )"

    TrayTip(help, "WinGetPID Examples Ready", "Icon!")
}
