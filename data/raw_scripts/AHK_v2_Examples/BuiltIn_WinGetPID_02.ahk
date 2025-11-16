/**
 * @file BuiltIn_WinGetPID_02.ahk
 * @description Advanced PID-based automation, process linking, and window correlation examples using WinGetPID in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 *
 * @section EXAMPLES
 * Example 1: Process grouping by executable
 * Example 2: PID-based hotkey router
 * Example 3: Process lifecycle monitor
 * Example 4: Cross-process window coordinator
 * Example 5: Process affinity manager
 * Example 6: PID-based clipboard manager
 *
 * @section FEATURES
 * - Process grouping
 * - PID-based routing
 * - Lifecycle monitoring
 * - Window coordination
 * - Affinity management
 * - Clipboard management
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Process Grouping by Executable
; ========================================

/**
 * @class ProcessGrouper
 * @description Group windows by their process executable
 */
class ProcessGrouper {
    static groups := Map()

    static GroupAllWindows() {
        this.groups := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                pid := WinGetPID("ahk_id " winId)
                processName := WinGetProcessName("ahk_id " winId)

                if !this.groups.Has(processName)
                    this.groups[processName] := []

                this.groups[processName].Push({
                    WinID: winId,
                    PID: pid,
                    Title: WinGetTitle("ahk_id " winId)
                })
            }
        }

        return this.groups
    }

    static GetGroupStatistics() {
        groups := this.GroupAllWindows()
        stats := []

        for processName, windows in groups {
            uniquePIDs := Map()
            for win in windows
                uniquePIDs[win.PID] := true

            stats.Push({
                Process: processName,
                Windows: windows.Length,
                Instances: uniquePIDs.Count
            })
        }

        return stats
    }
}

^+g:: {
    stats := ProcessGrouper.GetGroupStatistics()

    output := "Process Groups:`n`n"
    for data in stats {
        output .= data.Process ": " data.Windows " windows, " data.Instances " instance(s)`n"
        if A_Index > 15
            break
    }

    MsgBox(output, "Process Groups", "Icon!")
}

; ========================================
; Example 2: PID-Based Hotkey Router
; ========================================

/**
 * @class PIDRouter
 * @description Route hotkeys based on process ID
 */
class PIDRouter {
    static routes := Map()

    static RegisterRoute(processName, hotkey, action) {
        if !this.routes.Has(processName)
            this.routes[processName] := Map()

        if !this.routes[processName].Has(hotkey) {
            this.routes[processName][hotkey] := action
            try {
                Hotkey(hotkey, (*) => this.RouteHotkey(hotkey))
            }
        }
    }

    static RouteHotkey(hotkey) {
        try {
            processName := WinGetProcessName("A")

            if this.routes.Has(processName) && this.routes[processName].Has(hotkey) {
                this.routes[processName][hotkey]()
                return
            }
        }

        ; Default action - send the hotkey through
        Send("{" StrReplace(hotkey, "+", "Shift ") "}")
    }
}

; Example: Route Ctrl+T differently based on process
PIDRouter.RegisterRoute("notepad.exe", "^t", () => MsgBox("Notepad Ctrl+T"))
PIDRouter.RegisterRoute("chrome.exe", "^t", () => Send("^t"))

; ========================================
; Example 3: Process Lifecycle Monitor
; ========================================

/**
 * @class LifecycleMonitor
 * @description Monitor process creation and termination
 */
class LifecycleMonitor {
    static knownPIDs := Map()
    static monitoring := false
    static callbacks := {Created: [], Terminated: []}

    static StartMonitoring() {
        this.monitoring := true
        this.ScanCurrent()
        SetTimer(() => this.CheckChanges(), 2000)
        TrayTip("Lifecycle monitoring started", "Process Monitor", "Icon!")
    }

    static ScanCurrent() {
        allWindows := WinGetList()
        for winId in allWindows {
            try {
                pid := WinGetPID("ahk_id " winId)
                if !this.knownPIDs.Has(pid) {
                    this.knownPIDs[pid] := {
                        PID: pid,
                        ProcessName: WinGetProcessName("ahk_id " winId),
                        FirstSeen: A_TickCount
                    }
                }
            }
        }
    }

    static CheckChanges() {
        currentPIDs := Map()
        allWindows := WinGetList()

        ; Find current PIDs
        for winId in allWindows {
            try {
                pid := WinGetPID("ahk_id " winId)
                currentPIDs[pid] := true

                if !this.knownPIDs.Has(pid) {
                    ; New process detected
                    processData := {
                        PID: pid,
                        ProcessName: WinGetProcessName("ahk_id " winId),
                        FirstSeen: A_TickCount
                    }
                    this.knownPIDs[pid] := processData

                    for callback in this.callbacks.Created
                        callback(processData)
                }
            }
        }

        ; Check for terminated processes
        for pid, data in this.knownPIDs {
            if !currentPIDs.Has(pid) {
                for callback in this.callbacks.Terminated
                    callback(data)

                this.knownPIDs.Delete(pid)
            }
        }
    }

    static OnProcessCreated(callback) {
        this.callbacks.Created.Push(callback)
    }

    static OnProcessTerminated(callback) {
        this.callbacks.Terminated.Push(callback)
    }
}

; Example callbacks
LifecycleMonitor.OnProcessCreated((data) => TrayTip("Process created: " data.ProcessName, "PID: " data.PID))
LifecycleMonitor.OnProcessTerminated((data) => TrayTip("Process terminated: " data.ProcessName, "PID: " data.PID))

^+l:: LifecycleMonitor.StartMonitoring()

; ========================================
; Example 4: Cross-Process Window Coordinator
; ========================================

/**
 * @class WindowCoordinator
 * @description Coordinate windows across multiple processes
 */
class WindowCoordinator {
    static TileByProcess() {
        groups := ProcessGrouper.GroupAllWindows()

        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        workWidth := right - left
        workHeight := bottom - top

        processCount := 0
        for processName, windows in groups {
            if windows.Length > 0
                processCount++
        }

        if processCount = 0
            return

        cols := Ceil(Sqrt(processCount))
        rows := Ceil(processCount / cols)
        cellWidth := workWidth // cols
        cellHeight := workHeight // rows

        index := 0
        for processName, windows in groups {
            if windows.Length = 0
                continue

            row := index // cols
            col := Mod(index, cols)

            x := left + (col * cellWidth)
            y := top + (row * cellHeight)

            ; Position first window of each process
            try {
                WinMove(x, y, cellWidth, cellHeight, "ahk_id " windows[1].WinID)
            }

            index++
        }

        TrayTip("Tiled windows by process", "Window Coordinator", "Icon!")
    }

    static GroupByPID() {
        pid := WinGetPID("A")
        windows := WindowProcessMapper.GetProcessWindows(pid)

        if windows.Length <= 1
            return

        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        workWidth := right - left
        workHeight := bottom - top

        winWidth := workWidth // windows.Length
        x := left

        for win in windows {
            try {
                WinMove(x, top, winWidth, workHeight, "ahk_id " win.ID)
                x += winWidth
            }
        }

        TrayTip("Grouped " windows.Length " windows", "Window Coordinator", "Icon!")
    }
}

^+y:: WindowCoordinator.TileByProcess()
^+u:: WindowCoordinator.GroupByPID()

; ========================================
; Example 5: Process Affinity Manager
; ========================================

/**
 * @class AffinityManager
 * @description Manage CPU affinity for processes
 */
class AffinityManager {
    static GetProcessAffinity(pid) {
        try {
            hProcess := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", pid, "Ptr")
            if !hProcess
                return 0

            processAffinity := 0
            systemAffinity := 0

            DllCall("GetProcessAffinityMask", "Ptr", hProcess, "UInt*", &processAffinity, "UInt*", &systemAffinity)
            DllCall("CloseHandle", "Ptr", hProcess)

            return processAffinity
        }
        return 0
    }

    static SetProcessAffinity(pid, affinityMask) {
        try {
            hProcess := DllCall("OpenProcess", "UInt", 0x0200, "Int", false, "UInt", pid, "Ptr")
            if !hProcess
                return false

            result := DllCall("SetProcessAffinityMask", "Ptr", hProcess, "UInt", affinityMask)
            DllCall("CloseHandle", "Ptr", hProcess)

            return result
        }
        return false
    }

    static GetCPUCount() {
        return A_NumberOfProcessors ?? 1
    }

    static FormatAffinityMask(mask) {
        cpuList := []
        Loop this.GetCPUCount() {
            if mask & (1 << (A_Index - 1))
                cpuList.Push("CPU" (A_Index - 1))
        }
        return cpuList.Length > 0 ? StrJoin(cpuList, ", ") : "None"
    }
}

StrJoin(arr, delim) {
    result := ""
    for i, val in arr
        result .= (i > 1 ? delim : "") val
    return result
}

^+f:: {
    pid := WinGetPID("A")
    affinity := AffinityManager.GetProcessAffinity(pid)

    output := "Process Affinity:`n`n"
    output .= "PID: " pid "`n"
    output .= "Affinity Mask: " affinity "`n"
    output .= "CPUs: " AffinityManager.FormatAffinityMask(affinity)

    MsgBox(output, "Process Affinity", "Icon!")
}

; ========================================
; Example 6: PID-Based Clipboard Manager
; ========================================

/**
 * @class PIDClipboard
 * @description Manage clipboards per process
 */
class PIDClipboard {
    static clipboards := Map()
    static maxHistory := 10

    static CopyToProcessClipboard() {
        try {
            pid := WinGetPID("A")

            ; Copy to system clipboard first
            Send("^c")
            Sleep(100)

            content := A_Clipboard

            if !this.clipboards.Has(pid)
                this.clipboards[pid] := []

            this.clipboards[pid].Push({
                Content: content,
                Time: A_Now
            })

            if this.clipboards[pid].Length > this.maxHistory
                this.clipboards[pid].RemoveAt(1)

            TrayTip("Copied to PID " pid " clipboard", "PID Clipboard", "Icon!")
        }
    }

    static PasteFromProcessClipboard() {
        try {
            pid := WinGetPID("A")

            if !this.clipboards.Has(pid) || this.clipboards[pid].Length = 0 {
                MsgBox("No clipboard history for this process", "Info", "Icon!")
                return
            }

            ; Get last item
            lastItem := this.clipboards[pid][-1]
            A_Clipboard := lastItem.Content

            Send("^v")
            TrayTip("Pasted from PID " pid " clipboard", "PID Clipboard", "Icon!")
        }
    }

    static ShowHistory() {
        pid := WinGetPID("A")

        if !this.clipboards.Has(pid) || this.clipboards[pid].Length = 0 {
            MsgBox("No clipboard history for this process", "Info", "Icon!")
            return
        }

        output := "Clipboard History (PID: " pid "):`n`n"

        for i, item in this.clipboards[pid] {
            output .= i ". " SubStr(item.Content, 1, 50)
            if StrLen(item.Content) > 50
                output .= "..."
            output .= "`n"
        }

        MsgBox(output, "PID Clipboard History", "Icon!")
    }
}

^!x:: PIDClipboard.CopyToProcessClipboard()
^!v:: PIDClipboard.PasteFromProcessClipboard()
^!h:: PIDClipboard.ShowHistory()

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinGetPID Advanced Examples Ready", "Hotkeys available", "Icon!")
}
