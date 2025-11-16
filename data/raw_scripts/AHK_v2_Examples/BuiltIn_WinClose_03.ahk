#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinClose Examples - Part 3: Batch Close
 * ============================================================================
 *
 * Demonstrates batch closing operations for multiple windows.
 * Advanced filtering and selection techniques.
 *
 * @description Batch window closing examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Close Windows by Process
; ============================================================================

/**
 * Closes all windows of selected processes
 *
 * @hotkey F1 - Close by process
 */
F1:: {
    CloseByProcess()
}

CloseByProcess() {
    static procGui := ""
    
    if procGui {
        try procGui.Destroy()
    }
    
    procGui := Gui("+AlwaysOnTop", "Close by Process")
    procGui.SetFont("s10", "Segoe UI")
    
    procGui.Add("Text", "w400", "Select processes to close all windows:")
    
    ; Get unique processes
    processes := Map()
    allWindows := WinGetList()
    
    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                proc := WinGetProcessName(hwnd)
                if !processes.Has(proc) {
                    processes[proc] := 0
                }
                processes[proc]++
            }
        }
    }
    
    lv := procGui.Add("ListView", "w400 h250 Checked vProcList", ["Process", "Window Count"])
    
    procArray := []
    for proc, count in processes {
        lv.Add("", proc, count)
        procArray.Push(proc)
    }
    
    lv.ModifyCol()
    
    procGui.Add("Button", "w195 Default", "Close Selected").OnEvent("Click", CloseSelected)
    procGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => procGui.Destroy())
    
    procGui.Show()
    
    CloseSelected(*) {
        closed := 0
        
        Loop lv.GetCount() {
            if lv.GetNext(A_Index - 1, "Checked") = A_Index {
                proc := procArray[A_Index]
                windows := WinGetList("ahk_exe " proc)
                
                for hwnd in windows {
                    try {
                        WinClose(hwnd)
                        closed++
                    }
                }
            }
        }
        
        procGui.Destroy()
        MsgBox("Closed " closed " window(s).", "Success", 64)
    }
}

; ============================================================================
; Example 2: Close Windows by Pattern
; ============================================================================

/**
 * Closes windows matching title pattern
 *
 * @hotkey F2 - Close by pattern
 */
F2:: {
    CloseByPattern()
}

CloseByPattern() {
    result := InputBox("Enter title pattern (supports wildcards):", "Close by Pattern", "w350 h130", "*Notepad*")
    
    if result.Result != "OK" || result.Value = "" {
        return
    }
    
    pattern := result.Value
    SetTitleMatchMode(2)  ; Contains
    
    windows := WinGetList(pattern)
    
    if windows.Length = 0 {
        MsgBox("No windows match pattern: " pattern, "Info", 64)
        return
    }
    
    confirm := MsgBox("Close " windows.Length " window(s) matching:`n" pattern, "Confirm", 4)
    
    if confirm = "Yes" {
        for hwnd in windows {
            try {
                WinClose(hwnd)
            }
        }
        
        MsgBox("Closed " windows.Length " window(s).", "Success", 64)
    }
}

; ============================================================================
; Example 3: Close Windows on Specific Monitor
; ============================================================================

/**
 * Closes all windows on a specific monitor
 *
 * @hotkey F3 - Close by monitor
 */
F3:: {
    CloseByMonitor()
}

CloseByMonitor() {
    monCount := MonitorGetCount()
    
    if monCount < 2 {
        MsgBox("Only one monitor detected.", "Info", 64)
        return
    }
    
    result := InputBox("Enter monitor number (1-" monCount "):", "Close by Monitor", "w300 h130", "2")
    
    if result.Result != "OK" || !IsNumber(result.Value) {
        return
    }
    
    targetMon := Integer(result.Value)
    
    if targetMon < 1 || targetMon > monCount {
        MsgBox("Invalid monitor number.", "Error", 16)
        return
    }
    
    MonitorGet(targetMon, &left, &top, &right, &bottom)
    
    allWindows := WinGetList()
    closed := 0
    
    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                WinGetPos(&x, &y, &w, &h, hwnd)
                centerX := x + (w // 2)
                centerY := y + (h // 2)
                
                if centerX >= left && centerX <= right && centerY >= top && centerY <= bottom {
                    WinClose(hwnd)
                    closed++
                }
            }
        }
    }
    
    MsgBox("Closed " closed " window(s) on monitor " targetMon ".", "Success", 64)
}

; ============================================================================
; Example 4: Close Minimized Windows
; ============================================================================

/**
 * Closes all minimized windows
 *
 * @hotkey F4 - Close minimized
 */
F4:: {
    CloseMinimized()
}

CloseMinimized() {
    allWindows := WinGetList()
    closed := 0
    
    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                minMax := WinGetMinMax(hwnd)
                if minMax = -1 {  ; Minimized
                    WinClose(hwnd)
                    closed++
                }
            }
        }
    }
    
    MsgBox("Closed " closed " minimized window(s).", "Success", 64)
}

; ============================================================================
; Example 5: Scheduled Batch Close
; ============================================================================

/**
 * Schedules batch close for specified time
 *
 * @hotkey F5 - Schedule batch close
 */
F5:: {
    ScheduleBatchClose()
}

ScheduleBatchClose() {
    result := InputBox("Close all windows in X minutes:", "Schedule Close", "w300 h130", "5")
    
    if result.Result != "OK" || !IsNumber(result.Value) {
        return
    }
    
    minutes := Integer(result.Value)
    
    MsgBox("All windows will close in " minutes " minute(s).`n`nPress F5 again to cancel.", "Scheduled", 64)
    
    SetTimer(CloseAll, minutes * 60000)
    
    CloseAll() {
        SetTimer(CloseAll, 0)
        
        allWindows := WinGetList()
        
        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" && !InStr(WinGetProcessName(hwnd), "AutoHotkey") {
                    WinClose(hwnd)
                }
            }
        }
        
        MsgBox("Scheduled close complete.", "Done", 64)
    }
}

; ============================================================================
; Example 6: Close Duplicate Windows
; ============================================================================

/**
 * Closes duplicate windows (same title)
 *
 * @hotkey F6 - Close duplicates
 */
F6:: {
    CloseDuplicates()
}

CloseDuplicates() {
    titleMap := Map()
    allWindows := WinGetList()
    duplicates := []
    
    ; Find duplicates
    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                if !titleMap.Has(title) {
                    titleMap[title] := []
                }
                titleMap[title].Push(hwnd)
            }
        }
    }
    
    ; Close duplicates (keep first)
    closed := 0
    for title, windows in titleMap {
        if windows.Length > 1 {
            Loop windows.Length - 1 {
                try {
                    WinClose(windows[A_Index + 1])
                    closed++
                }
            }
        }
    }
    
    MsgBox("Closed " closed " duplicate window(s).", "Success", 64)
}

; ============================================================================
; Example 7: Close Old Windows
; ============================================================================

/**
 * Closes windows by custom criteria
 *
 * @hotkey F7 - Custom batch close
 */
F7:: {
    CustomBatchClose()
}

CustomBatchClose() {
    static customGui := ""
    
    if customGui {
        try customGui.Destroy()
    }
    
    customGui := Gui("+AlwaysOnTop", "Custom Batch Close")
    customGui.SetFont("s10", "Segoe UI")
    
    customGui.Add("Text", "w400", "Select criteria:")
    
    customGui.Add("CheckBox", "vMinimized", "Minimized windows")
    customGui.Add("CheckBox", "vNotActive", "All except active")
    customGui.Add("CheckBox", "vNoTitle Checked", "Windows with no title")
    
    customGui.Add("Button", "w195 Default", "Close Matching").OnEvent("Click", CloseMatching)
    customGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => customGui.Destroy())
    
    customGui.Show()
    
    CloseMatching(*) {
        submitted := customGui.Submit()
        
        allWindows := WinGetList()
        activeHwnd := WinGetID("A")
        closed := 0
        
        for hwnd in allWindows {
            try {
                shouldClose := false
                
                if submitted.Minimized && WinGetMinMax(hwnd) = -1 {
                    shouldClose := true
                }
                
                if submitted.NotActive && hwnd != activeHwnd {
                    if WinGetTitle(hwnd) != "" {
                        shouldClose := true
                    }
                }
                
                if submitted.NoTitle && WinGetTitle(hwnd) = "" {
                    shouldClose := true
                }
                
                if shouldClose {
                    WinClose(hwnd)
                    closed++
                }
            }
        }
        
        customGui.Destroy()
        MsgBox("Closed " closed " window(s) matching criteria.", "Success", 64)
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinClose Examples - Part 3 (Batch Close)
    =========================================

    Hotkeys:
    F1 - Close windows by process
    F2 - Close windows by pattern
    F3 - Close windows on specific monitor
    F4 - Close all minimized windows
    F5 - Schedule batch close
    F6 - Close duplicate windows
    F7 - Custom batch close
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
