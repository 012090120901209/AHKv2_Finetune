/**
 * @file BuiltIn_WinGetPID_03.ahk
 * @description PID correlation, process analysis, and advanced window-process linking using WinGetPID in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: PID-based window searcher
 * Example 2: Process instance counter
 * Example 3: PID collision detector
 * Example 4: Process window tracker
 * Example 5: PID-based automation scripts
 * Example 6: Process performance analyzer
 * Example 7: Multi-instance manager
 * 
 * @section FEATURES
 * - PID-based searching
 * - Instance counting
 * - Collision detection
 * - Window tracking
 * - Automation scripting
 * - Performance analysis
 */

#Requires AutoHotkey v2.0

; Global PID database
global PIDDatabase := Map()

; ========================================
; Example 1: PID-Based Window Searcher
; ========================================

class PIDSearcher {
    static SearchByPID(pid) {
        results := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if WinGetPID("ahk_id " winId) = pid {
                    results.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId),
                        Class: WinGetClass("ahk_id " winId),
                        Visible: WinGetStyle("ahk_id " winId) & 0x10000000
                    })
                }
            }
        }
        return results
    }

    static SearchByProcessName(processName) {
        pidResults := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if InStr(WinGetProcessName("ahk_id " winId), processName) {
                    pid := WinGetPID("ahk_id " winId)
                    if !pidResults.Has(pid)
                        pidResults[pid] := []

                    pidResults[pid].Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId)
                    })
                }
            }
        }
        return pidResults
    }
}

^+s:: {
    pid := InputBox("Enter PID to search:", "PID Search").Value
    if pid = ""
        return

    results := PIDSearcher.SearchByPID(Integer(pid))

    if results.Length = 0 {
        MsgBox("No windows found for PID: " pid, "Search Results", "Icon!")
        return
    }

    output := "Found " results.Length " window(s) for PID " pid ":`n`n"
    for win in results {
        output .= win.Class " - " win.Title "`n"
        if A_Index > 10
            break
    }

    MsgBox(output, "PID Search Results", "Icon!")
}

; ========================================
; Example 2: Process Instance Counter
; ========================================

class InstanceCounter {
    static CountInstances(processName) {
        instances := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if WinGetProcessName("ahk_id " winId) = processName {
                    pid := WinGetPID("ahk_id " winId)
                    instances[pid] := true
                }
            }
        }

        return instances.Count
    }

    static GetAllInstanceCounts() {
        processCounts := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                pid := WinGetPID("ahk_id " winId)
                processName := WinGetProcessName("ahk_id " winId)

                if !processCounts.Has(processName)
                    processCounts[processName] := Map()

                processCounts[processName][pid] := true
            }
        }

        results := []
        for processName, pids in processCounts {
            results.Push({
                Process: processName,
                InstanceCount: pids.Count
            })
        }

        return results
    }
}

^+n:: {
    counts := InstanceCounter.GetAllInstanceCounts()

    output := "Process Instance Counts:`n`n"
    for data in counts {
        if data.InstanceCount > 1
            output .= data.Process ": " data.InstanceCount " instances`n"

        if A_Index > 15
            break
    }

    MsgBox(output, "Instance Counter", "Icon!")
}

; ========================================
; Example 3: PID Collision Detector
; ========================================

class PIDCollisionDetector {
    static detectedPIDs := Map()

    static CheckForReusedPIDs() {
        currentPIDs := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                pid := WinGetPID("ahk_id " winId)
                processName := WinGetProcessName("ahk_id " winId)

                key := pid

                if !currentPIDs.Has(key)
                    currentPIDs[key] := []

                currentPIDs[key].Push({
                    Process: processName,
                    WinID: winId,
                    Time: A_TickCount
                })
            }
        }

        ; Check for PID reuse
        collisions := []
        for pid, data in currentPIDs {
            if this.detectedPIDs.Has(pid) {
                oldData := this.detectedPIDs[pid]
                if oldData.Process != data[1].Process {
                    collisions.Push({
                        PID: pid,
                        OldProcess: oldData.Process,
                        NewProcess: data[1].Process
                    })
                }
            }
        }

        ; Update database
        for pid, data in currentPIDs {
            this.detectedPIDs[pid] := data[1]
        }

        return collisions
    }
}

; ========================================
; Example 4: Process Window Tracker
; ========================================

class WindowTracker {
    static trackedProcesses := Map()
    static tracking := false

    static TrackProcess(processName) {
        if !this.trackedProcesses.Has(processName) {
            this.trackedProcesses[processName] := {
                ProcessName: processName,
                PIDs: Map(),
                WindowHistory: [],
                FirstSeen: A_Now
            }
        }

        if !this.tracking {
            this.tracking := true
            SetTimer(() => this.UpdateTracking(), 1000)
        }

        TrayTip("Now tracking: " processName, "Window Tracker", "Icon!")
    }

    static UpdateTracking() {
        allWindows := WinGetList()

        for processName, trackData in this.trackedProcesses {
            currentPIDs := Map()

            for winId in allWindows {
                try {
                    if WinGetProcessName("ahk_id " winId) = processName {
                        pid := WinGetPID("ahk_id " winId)
                        currentPIDs[pid] := true

                        if !trackData.PIDs.Has(pid) {
                            trackData.PIDs[pid] := {
                                PID: pid,
                                FirstWindow: A_Now,
                                WindowCount: 0
                            }
                        }

                        trackData.PIDs[pid].WindowCount++
                    }
                }
            }

            ; Remove terminated PIDs
            for pid, data in trackData.PIDs {
                if !currentPIDs.Has(pid) {
                    trackData.WindowHistory.Push({
                        Event: "ProcessTerminated",
                        PID: pid,
                        Time: A_Now
                    })
                    trackData.PIDs.Delete(pid)
                }
            }
        }
    }

    static GetReport(processName) {
        if !this.trackedProcesses.Has(processName)
            return "Process not tracked"

        trackData := this.trackedProcesses[processName]

        output := "Tracking Report: " processName "`n`n"
        output .= "Active Instances: " trackData.PIDs.Count "`n"
        output .= "Total Events: " trackData.WindowHistory.Length "`n`n"

        output .= "Current PIDs:`n"
        for pid, data in trackData.PIDs {
            output .= "  PID " pid ": " data.WindowCount " windows`n"
        }

        return output
    }
}

^+k:: {
    processName := WinGetProcessName("A")
    WindowTracker.TrackProcess(processName)
}

; ========================================
; Example 5: PID-Based Automation Scripts
; ========================================

class PIDAutomation {
    static scripts := Map()

    static RegisterScript(processName, scriptFunc) {
        this.scripts[processName] := scriptFunc
    }

    static RunForActiveWindow() {
        try {
            processName := WinGetProcessName("A")
            pid := WinGetPID("A")

            if this.scripts.Has(processName) {
                this.scripts[processName](pid)
            } else {
                TrayTip("No script for: " processName, "Automation", "Icon!")
            }
        }
    }

    static RunForAllInstances(processName) {
        if !this.scripts.Has(processName) {
            MsgBox("No script registered for: " processName, "Error", "IconX")
            return
        }

        results := PIDSearcher.SearchByProcessName(processName)

        for pid, windows in results {
            try {
                this.scripts[processName](pid)
            }
        }

        TrayTip("Ran script for " results.Count " instance(s)", "Automation", "Icon!")
    }
}

; Example automation script
PIDAutomation.RegisterScript("notepad.exe", (pid) => {
    TrayTip("Notepad automation ran", "PID: " pid, "Icon!")
})

^+x:: PIDAutomation.RunForActiveWindow()

; ========================================
; Example 6: Process Performance Analyzer
; ========================================

class PerformanceAnalyzer {
    static AnalyzeProcess(pid) {
        try {
            ; Get CPU usage (simplified)
            query := ComObject("WbemScripting.SWbemLocator")
            service := query.ConnectServer()

            ; Get memory info
            hProcess := DllCall("OpenProcess", "UInt", 0x1000, "Int", false, "UInt", pid, "Ptr")
            if !hProcess
                return { Error: "Cannot open process" }

            memCounters := Buffer(72, 0)
            NumPut("UInt", 72, memCounters, 0)

            memUsage := 0
            if DllCall("Psapi\GetProcessMemoryInfo", "Ptr", hProcess, "Ptr", memCounters, "UInt", 72) {
                memUsage := NumGet(memCounters, 8, "UPtr")
            }

            ; Get handle count
            handleCount := 0
            DllCall("GetProcessHandleCount", "Ptr", hProcess, "UInt*", &handleCount)

            ; Get thread count
            threadCount := 0
            processes := service.ExecQuery("SELECT ThreadCount FROM Win32_Process WHERE ProcessId = " pid)
            for process in processes {
                threadCount := process.ThreadCount
            }

            DllCall("CloseHandle", "Ptr", hProcess)

            return {
                PID: pid,
                MemoryUsage: memUsage,
                HandleCount: handleCount,
                ThreadCount: threadCount,
                WindowCount: WindowProcessMapper.CountWindowsForProcess(pid)
            }

        } catch as err {
            return { Error: err.Message }
        }
    }

    static CompareProcesses(pids) {
        results := []

        for pid in pids {
            analysis := this.AnalyzeProcess(pid)
            if !analysis.HasOwnProp("Error")
                results.Push(analysis)
        }

        return results
    }

    static FormatBytes(bytes) {
        if bytes >= 1073741824
            return Round(bytes / 1073741824, 2) " GB"
        if bytes >= 1048576
            return Round(bytes / 1048576, 2) " MB"
        if bytes >= 1024
            return Round(bytes / 1024, 2) " KB"
        return bytes " bytes"
    }
}

^+q:: {
    pid := WinGetPID("A")
    analysis := PerformanceAnalyzer.AnalyzeProcess(pid)

    if analysis.HasOwnProp("Error") {
        MsgBox(analysis.Error, "Error", "IconX")
        return
    }

    output := "Performance Analysis (PID: " pid "):`n`n"
    output .= "Memory: " PerformanceAnalyzer.FormatBytes(analysis.MemoryUsage) "`n"
    output .= "Handles: " analysis.HandleCount "`n"
    output .= "Threads: " analysis.ThreadCount "`n"
    output .= "Windows: " analysis.WindowCount

    MsgBox(output, "Performance Analysis", "Icon!")
}

; ========================================
; Example 7: Multi-Instance Manager
; ========================================

class MultiInstanceManager {
    static GetInstanceInfo(processName) {
        instances := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if WinGetProcessName("ahk_id " winId) = processName {
                    pid := WinGetPID("ahk_id " winId)

                    if !instances.Has(pid) {
                        instances[pid] := {
                            PID: pid,
                            Windows: [],
                            StartTime: ""
                        }
                    }

                    instances[pid].Windows.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId),
                        Class: WinGetClass("ahk_id " winId)
                    })
                }
            }
        }

        return instances
    }

    static ManageInstances(processName) {
        instances := this.GetInstanceInfo(processName)

        if instances.Count = 0 {
            MsgBox("No instances found for: " processName, "Info", "Icon!")
            return
        }

        gui := Gui("+Resize", "Multi-Instance Manager - " processName)
        lv := gui.Add("ListView", "w600 h300", ["PID", "Windows", "Action"])

        for pid, data in instances {
            lv.Add(, pid, data.Windows.Length, "")
        }

        lv.ModifyCol()

        gui.Add("Button", "w150", "Close Selected").OnEvent("Click", (*) => this.CloseInstance(lv, instances))
        gui.Add("Button", "x+10 w150", "Minimize All").OnEvent("Click", (*) => this.MinimizeAll(instances))
        gui.Add("Button", "x+10 w150", "Refresh").OnEvent("Click", (*) => gui.Destroy())

        gui.Show()
    }

    static CloseInstance(lv, instances) {
        row := lv.GetNext()
        if !row
            return

        pid := Integer(lv.GetText(row, 1))

        result := MsgBox("Close all windows for PID " pid "?", "Confirm", "YesNo Icon?")
        if result = "No"
            return

        if instances.Has(pid) {
            for win in instances[pid].Windows {
                try {
                    WinClose("ahk_id " win.ID)
                }
            }
        }

        lv.Delete(row)
    }

    static MinimizeAll(instances) {
        for pid, data in instances {
            for win in data.Windows {
                try {
                    WinMinimize("ahk_id " win.ID)
                }
            }
        }

        TrayTip("Minimized all instances", "Instance Manager", "Icon!")
    }
}

^+j:: {
    processName := WinGetProcessName("A")
    MultiInstanceManager.ManageInstances(processName)
}

; ========================================
; Utility Classes
; ========================================

class WindowProcessMapper {
    static CountWindowsForProcess(pid) {
        count := 0
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                if WinGetPID("ahk_id " winId) = pid
                    count++
            }
        }

        return count
    }
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetPID Advanced Examples - Hotkeys:

    Ctrl+Shift+S  - Search by PID
    Ctrl+Shift+N  - Instance counter
    Ctrl+Shift+K  - Track process
    Ctrl+Shift+X  - Run automation
    Ctrl+Shift+Q  - Performance analysis
    Ctrl+Shift+J  - Multi-instance manager
    )"

    TrayTip(help, "WinGetPID Advanced Ready", "Icon!")
}
