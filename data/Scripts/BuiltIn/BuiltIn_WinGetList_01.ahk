/**
 * @file BuiltIn_WinGetList_01.ahk
 * @description Comprehensive examples demonstrating WinGetList function for enumerating windows in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Basic window enumeration
 * Example 2: Filtered window lists
 * Example 3: Window catalog builder
 * Example 4: Process-based listing
 * Example 5: Window statistics generator
 * Example 6: Interactive window browser
 * Example 7: Window list exporter
 * 
 * @section FEATURES
 * - Enumerate all windows
 * - Filter and sort
 * - Build catalogs
 * - Process grouping
 * - Statistics
 * - Interactive browsing
 * - Export capabilities
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Window Enumeration
; ========================================

GetAllWindows() {
    windows := []
    windowList := WinGetList()

    for winId in windowList {
        try {
            windows.Push({
                ID: winId,
                Title: WinGetTitle("ahk_id " winId),
                Class: WinGetClass("ahk_id " winId),
                Process: WinGetProcessName("ahk_id " winId),
                PID: WinGetPID("ahk_id " winId)
            })
        }
    }

    return windows
}

^+l:: {
    windows := GetAllWindows()

    output := "Total Windows: " windows.Length "`n`n"

    for i, win in windows {
        if i > 15
            break

        output .= win.Class
        if win.Title != ""
            output .= " - " SubStr(win.Title, 1, 30)
        output .= "`n"
    }

    MsgBox(output, "Window List", "Icon!")
}

; ========================================
; Example 2: Filtered Window Lists
; ========================================

class WindowFilter {
    static FilterByTitle(pattern) {
        filtered := []
        windowList := WinGetList()

        for winId in windowList {
            try {
                title := WinGetTitle("ahk_id " winId)
                if InStr(title, pattern) {
                    filtered.Push({
                        ID: winId,
                        Title: title,
                        Class: WinGetClass("ahk_id " winId)
                    })
                }
            }
        }

        return filtered
    }

    static FilterByClass(className) {
        filtered := []
        windowList := WinGetList()

        for winId in windowList {
            try {
                if WinGetClass("ahk_id " winId) = className {
                    filtered.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId),
                        Class: className
                    })
                }
            }
        }

        return filtered
    }

    static FilterByProcess(processName) {
        filtered := []
        windowList := WinGetList()

        for winId in windowList {
            try {
                if WinGetProcessName("ahk_id " winId) = processName {
                    filtered.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId),
                        Process: processName
                    })
                }
            }
        }

        return filtered
    }

    static FilterVisible() {
        visible := []
        windowList := WinGetList()

        for winId in windowList {
            try {
                style := WinGetStyle("ahk_id " winId)
                if (style & 0x10000000) {  ; WS_VISIBLE
                    visible.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId)
                    })
                }
            }
        }

        return visible
    }

    static FilterByCustom(filterFunc) {
        filtered := []
        windowList := WinGetList()

        for winId in windowList {
            try {
                winData := {
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId),
                    Process: WinGetProcessName("ahk_id " winId)
                }

                if filterFunc(winData) {
                    filtered.Push(winData)
                }
            }
        }

        return filtered
    }
}

^+f:: {
    pattern := InputBox("Enter title pattern:", "Filter Windows").Value
    if pattern = ""
        return

    filtered := WindowFilter.FilterByTitle(pattern)

    output := "Found " filtered.Length " window(s):`n`n"
    for win in filtered {
        output .= win.Title "`n"
        if A_Index > 10
            break
    }

    MsgBox(output, "Filtered Windows", "Icon!")
}

; ========================================
; Example 3: Window Catalog Builder
; ========================================

class WindowCatalog {
    static catalog := Map()

    static BuildCatalog() {
        this.catalog := Map()
        windowList := WinGetList()

        for winId in windowList {
            try {
                className := WinGetClass("ahk_id " winId)

                if !this.catalog.Has(className) {
                    this.catalog[className] := []
                }

                this.catalog[className].Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Process: WinGetProcessName("ahk_id " winId),
                    PID: WinGetPID("ahk_id " winId)
                })
            }
        }

        return this.catalog
    }

    static GetStatistics() {
        stats := {
            TotalClasses: this.catalog.Count,
            TotalWindows: 0,
            LargestClass: { Name: "", Count: 0 }
        }

        for className, windows in this.catalog {
            stats.TotalWindows += windows.Length

            if windows.Length > stats.LargestClass.Count {
                stats.LargestClass.Name := className
                stats.LargestClass.Count := windows.Length
            }
        }

        return stats
    }

    static ExportCatalog() {
        output := "=== Window Catalog ===`n`n"

        for className, windows in this.catalog {
            output .= className " (" windows.Length " window"
            output .= windows.Length > 1 ? "s" : ""
            output .= ")`n"

            for win in windows {
                output .= "  - " win.Title "`n"
            }
            output .= "`n"
        }

        return output
    }
}

^+c:: {
    WindowCatalog.BuildCatalog()
    stats := WindowCatalog.GetStatistics()

    output := "Catalog Statistics:`n`n"
    output .= "Total Classes: " stats.TotalClasses "`n"
    output .= "Total Windows: " stats.TotalWindows "`n"
    output .= "Largest Class: " stats.LargestClass.Name " (" stats.LargestClass.Count ")`n`n"
    output .= "Export catalog to view details?"

    MsgBox(output, "Window Catalog", "Icon!")
}

; ========================================
; Example 4: Process-Based Listing
; ========================================

class ProcessWindowList {
    static GroupByProcess() {
        grouped := Map()
        windowList := WinGetList()

        for winId in windowList {
            try {
                processName := WinGetProcessName("ahk_id " winId)

                if !grouped.Has(processName) {
                    grouped[processName] := {
                        ProcessName: processName,
                        Windows: [],
                        PIDs: Map()
                    }
                }

                pid := WinGetPID("ahk_id " winId)
                grouped[processName].PIDs[pid] := true

                grouped[processName].Windows.Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    PID: pid
                })
            }
        }

        return grouped
    }

    static GetTopProcesses(count := 10) {
        grouped := this.GroupByProcess()
        processes := []

        for processName, data in grouped {
            processes.Push({
                Process: processName,
                WindowCount: data.Windows.Length,
                InstanceCount: data.PIDs.Count
            })
        }

        ; Sort by window count
        n := processes.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if processes[j].WindowCount < processes[j + 1].WindowCount {
                    temp := processes[j]
                    processes[j] := processes[j + 1]
                    processes[j + 1] := temp
                }
            }
        }

        ; Return top N
        result := []
        Loop Min(count, processes.Length) {
            result.Push(processes[A_Index])
        }

        return result
    }
}

^+p:: {
    top := ProcessWindowList.GetTopProcesses(10)

    output := "Top Processes by Window Count:`n`n"

    for data in top {
        output .= data.Process ": " data.WindowCount " windows, "
        output .= data.InstanceCount " instance(s)`n"
    }

    MsgBox(output, "Process Listing", "Icon!")
}

; ========================================
; Example 5: Window Statistics Generator
; ========================================

class WindowStats {
    static GenerateStats() {
        windowList := WinGetList()

        stats := {
            Total: windowList.Length,
            Visible: 0,
            Hidden: 0,
            WithTitle: 0,
            NoTitle: 0,
            Classes: Map(),
            Processes: Map()
        }

        for winId in windowList {
            try {
                ; Visibility
                style := WinGetStyle("ahk_id " winId)
                if style & 0x10000000 {
                    stats.Visible++
                } else {
                    stats.Hidden++
                }

                ; Title
                title := WinGetTitle("ahk_id " winId)
                if title != "" {
                    stats.WithTitle++
                } else {
                    stats.NoTitle++
                }

                ; Classes
                className := WinGetClass("ahk_id " winId)
                if !stats.Classes.Has(className) {
                    stats.Classes[className] := 0
                }
                stats.Classes[className]++

                ; Processes
                processName := WinGetProcessName("ahk_id " winId)
                if !stats.Processes.Has(processName) {
                    stats.Processes[processName] := 0
                }
                stats.Processes[processName]++
            }
        }

        return stats
    }

    static FormatStats(stats) {
        output := "=== Window Statistics ===`n`n"
        output .= "Total Windows: " stats.Total "`n"
        output .= "Visible: " stats.Visible "`n"
        output .= "Hidden: " stats.Hidden "`n"
        output .= "With Title: " stats.WithTitle "`n"
        output .= "No Title: " stats.NoTitle "`n"
        output .= "Unique Classes: " stats.Classes.Count "`n"
        output .= "Unique Processes: " stats.Processes.Count

        return output
    }
}

^+s:: {
    stats := WindowStats.GenerateStats()
    output := WindowStats.FormatStats(stats)
    MsgBox(output, "Window Statistics", "Icon!")
}

; ========================================
; Example 6: Interactive Window Browser
; ========================================

class WindowBrowser {
    static gui := ""

    static Show() {
        this.gui := Gui("+Resize", "Window Browser")

        ; Add controls
        this.gui.Add("Text", "w600", "All Windows (double-click to activate)")

        lv := this.gui.Add("ListView", "w600 h400 vWindowList", ["Title", "Class", "Process", "PID"])

        ; Populate list
        this.RefreshList(lv)

        ; Add buttons
        this.gui.Add("Button", "w100", "Refresh").OnEvent("Click", (*) => this.RefreshList(lv))
        this.gui.Add("Button", "x+10 w100", "Activate").OnEvent("Click", (*) => this.ActivateSelected(lv))
        this.gui.Add("Button", "x+10 w100", "Close").OnEvent("Click", (*) => this.gui.Destroy())

        ; Handle double-click
        lv.OnEvent("DoubleClick", (*) => this.ActivateSelected(lv))

        this.gui.Show()
    }

    static RefreshList(lv) {
        lv.Delete()
        windowList := WinGetList()

        for winId in windowList {
            try {
                title := WinGetTitle("ahk_id " winId)
                className := WinGetClass("ahk_id " winId)
                processName := WinGetProcessName("ahk_id " winId)
                pid := WinGetPID("ahk_id " winId)

                lv.Add(, title, className, processName, pid)
                lv.Modify(lv.GetCount(), "Ptr", winId)
            }
        }

        lv.ModifyCol()
    }

    static ActivateSelected(lv) {
        row := lv.GetNext()
        if !row
            return

        winId := lv.GetNext(0, "Ptr")

        try {
            WinActivate("ahk_id " winId)
        } catch {
            MsgBox("Failed to activate window", "Error", "IconX")
        }
    }
}

^+b:: WindowBrowser.Show()

; ========================================
; Example 7: Window List Exporter
; ========================================

class WindowExporter {
    static ExportToCSV(filePath) {
        windowList := WinGetList()

        content := "ID,Title,Class,Process,PID`n"

        for winId in windowList {
            try {
                title := WinGetTitle("ahk_id " winId)
                className := WinGetClass("ahk_id " winId)
                processName := WinGetProcessName("ahk_id " winId)
                pid := WinGetPID("ahk_id " winId)

                ; Escape commas in title
                title := StrReplace(title, ",", ";")

                content .= winId "," title "," className "," processName "," pid "`n"
            }
        }

        try {
            FileDelete(filePath)
        }
        FileAppend(content, filePath)

        return true
    }

    static ExportToText(filePath) {
        windowList := WinGetList()

        content := "=== Window List Export ===`n"
        content .= "Generated: " A_Now "`n"
        content .= "Total Windows: " windowList.Length "`n`n"

        for winId in windowList {
            try {
                content .= "Window ID: " winId "`n"
                content .= "  Title: " WinGetTitle("ahk_id " winId) "`n"
                content .= "  Class: " WinGetClass("ahk_id " winId) "`n"
                content .= "  Process: " WinGetProcessName("ahk_id " winId) "`n"
                content .= "  PID: " WinGetPID("ahk_id " winId) "`n`n"
            }
        }

        try {
            FileDelete(filePath)
        }
        FileAppend(content, filePath)

        return true
    }
}

^+e:: {
    filePath := A_ScriptDir "\windows.txt"
    WindowExporter.ExportToText(filePath)
    MsgBox("Window list exported to:`n" filePath, "Export Complete", "Icon!")
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetList Examples - Hotkeys:

    Ctrl+Shift+L  - List all windows
    Ctrl+Shift+F  - Filter windows
    Ctrl+Shift+C  - Build catalog
    Ctrl+Shift+P  - Process listing
    Ctrl+Shift+S  - Window statistics
    Ctrl+Shift+B  - Interactive browser
    Ctrl+Shift+E  - Export to file
    )"

    TrayTip(help, "WinGetList Examples Ready", "Icon!")
}
