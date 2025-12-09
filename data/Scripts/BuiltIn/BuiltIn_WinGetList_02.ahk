/**
* @file BuiltIn_WinGetList_02.ahk
* @description Advanced window list operations, sorting, analysis, and monitoring using WinGetList in AutoHotkey v2
* @author AutoHotkey Foundation
* @version 2.0
* @date 2024-01-15
*
* @section EXAMPLES
* Example 1: Advanced window sorting
* Example 2: Window list comparator
* Example 3: Real-time window monitor
* Example 4: Window search engine
* Example 5: List-based automation
* Example 6: Window snapshot system
*
* @section FEATURES
* - Advanced sorting
* - List comparison
* - Real-time monitoring
* - Search functionality
* - Automation based on lists
* - Snapshot management
*/

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Advanced Window Sorting
; ========================================

class WindowSorter {
    static SortByTitle(ascending := true) {
        windowList := WinGetList()
        windows := []

        for winId in windowList {
            try {
                windows.Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId)
                })
            }
        }

        ; Sort
        n := windows.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                compare := ascending ? (windows[j].Title > windows[j + 1].Title) : (windows[j].Title < windows[j + 1].Title)

                if compare {
                    temp := windows[j]
                    windows[j] := windows[j + 1]
                    windows[j + 1] := temp
                }
            }
        }

        return windows
    }

    static SortByProcessName() {
        windowList := WinGetList()
        windows := []

        for winId in windowList {
            try {
                windows.Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Process: WinGetProcessName("ahk_id " winId)
                })
            }
        }

        ; Sort by process name
        n := windows.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if windows[j].Process > windows[j + 1].Process {
                    temp := windows[j]
                    windows[j] := windows[j + 1]
                    windows[j + 1] := temp
                }
            }
        }

        return windows
    }

    static SortByCustom(sortFunc) {
        windowList := WinGetList()
        windows := []

        for winId in windowList {
            try {
                windows.Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId),
                    Process: WinGetProcessName("ahk_id " winId)
                })
            }
        }

        ; Sort using custom function
        n := windows.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if sortFunc(windows[j], windows[j + 1]) > 0 {
                    temp := windows[j]
                    windows[j] := windows[j + 1]
                    windows[j + 1] := temp
                }
            }
        }

        return windows
    }
}

^+1:: {
    sorted := WindowSorter.SortByTitle(true)

    output := "Windows Sorted by Title:`n`n"
    for win in sorted {
        output .= win.Title "`n"
        if A_Index > 15
        break
    }

    MsgBox(output, "Sorted Windows", "Icon!")
}

; ========================================
; Example 2: Window List Comparator
; ========================================

class ListComparator {
    static snapshot1 := []
    static snapshot2 := []

    static TakeSnapshot() {
        windowList := WinGetList()
        snapshot := []

        for winId in windowList {
            try {
                snapshot.Push({
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId)
                })
            }
        }

        return snapshot
    }

    static Compare(snap1, snap2) {
        newWindows := []
        closedWindows := []

        ; Find new windows
        for win2 in snap2 {
            found := false
            for win1 in snap1 {
                if win1.ID = win2.ID {
                    found := true
                    break
                }
            }

            if !found {
                newWindows.Push(win2)
            }
        }

        ; Find closed windows
        for win1 in snap1 {
            found := false
            for win2 in snap2 {
                if win1.ID = win2.ID {
                    found := true
                    break
                }
            }

            if !found {
                closedWindows.Push(win1)
            }
        }

        return {
            New: newWindows,
            Closed: closedWindows,
            Changes: newWindows.Length + closedWindows.Length
        }
    }
}

^+2:: {
    ListComparator.snapshot1 := ListComparator.TakeSnapshot()
    TrayTip("Snapshot 1 taken: " ListComparator.snapshot1.Length " windows", "Comparator", "Icon!")
}

^+3:: {
    ListComparator.snapshot2 := ListComparator.TakeSnapshot()
    comparison := ListComparator.Compare(ListComparator.snapshot1, ListComparator.snapshot2)

    output := "Window Changes:`n`n"
    output .= "New Windows: " comparison.New.Length "`n"
    output .= "Closed Windows: " comparison.Closed.Length "`n"
    output .= "Total Changes: " comparison.Changes

    MsgBox(output, "List Comparison", "Icon!")
}

; ========================================
; Example 3: Real-Time Window Monitor
; ========================================

class RealtimeMonitor {
    static monitoring := false
    static lastList := []
    static gui := ""

    static Start() {
        this.monitoring := true
        this.lastList := this.GetCurrentList()

        this.gui := Gui("+AlwaysOnTop", "Realtime Window Monitor")
        this.gui.Add("Text", "w400", "Monitoring window changes...")
        this.gui.Add("ListView", "w400 h300 vChanges", ["Event", "Window"])
        this.gui.Add("Button", "w150", "Stop").OnEvent("Click", (*) => this.Stop())

        this.gui.Show()

        SetTimer(() => this.CheckChanges(), 1000)
    }

    static Stop() {
        this.monitoring := false
        SetTimer(() => this.CheckChanges(), 0)

        if this.gui {
            this.gui.Destroy()
            this.gui := ""
        }
    }

    static GetCurrentList() {
        windowList := WinGetList()
        current := []

        for winId in windowList {
            current.Push(winId)
        }

        return current
    }

    static CheckChanges() {
        if !this.monitoring
        return

        currentList := this.GetCurrentList()

        ; Check for new windows
        for winId in currentList {
            if !this.InList(winId, this.lastList) {
                this.LogChange("New", winId)
            }
        }

        ; Check for closed windows
        for winId in this.lastList {
            if !this.InList(winId, currentList) {
                this.LogChange("Closed", winId)
            }
        }

        this.lastList := currentList
    }

    static InList(winId, list) {
        for id in list {
            if id = winId
            return true
        }
        return false
    }

    static LogChange(event, winId) {
        try {
            title := WinGetTitle("ahk_id " winId)
        } catch {
            title := "Unknown"
        }

        if this.gui {
            lv := this.gui["Changes"]
            lv.Add(, event, title)
        }
    }
}

^+4:: RealtimeMonitor.Start()

; ========================================
; Example 4: Window Search Engine
; ========================================

class WindowSearch {
    static Search(criteria) {
        windowList := WinGetList()
        results := []

        for winId in windowList {
            try {
                winData := {
                    ID: winId,
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId),
                    Process: WinGetProcessName("ahk_id " winId)
                }

                if this.MatchesCriteria(winData, criteria) {
                    results.Push(winData)
                }
            }
        }

        return results
    }

    static MatchesCriteria(winData, criteria) {
        if criteria.HasOwnProp("TitleContains") {
            if !InStr(winData.Title, criteria.TitleContains)
            return false
        }

        if criteria.HasOwnProp("ClassEquals") {
            if winData.Class != criteria.ClassEquals
            return false
        }

        if criteria.HasOwnProp("ProcessEquals") {
            if winData.Process != criteria.ProcessEquals
            return false
        }

        if criteria.HasOwnProp("TitleRegex") {
            if !(winData.Title ~= criteria.TitleRegex)
            return false
        }

        return true
    }
}

^+5:: {
    criteria := {
        TitleContains: "Notepad"
    }

    results := WindowSearch.Search(criteria)

    output := "Search Results: " results.Length "`n`n"
    for win in results {
        output .= win.Title "`n"
    }

    MsgBox(output, "Window Search", "Icon!")
}

; ========================================
; Example 5: List-Based Automation
; ========================================

class ListAutomation {
    static ExecuteOnList(criteria, action) {
        results := WindowSearch.Search(criteria)

        for win in results {
            try {
                action(win)
            } catch as err {
                TrayTip("Action failed for: " win.Title, err.Message, "IconX")
            }
        }

        return results.Length
    }

    static MinimizeMatching(criteria) {
        count := this.ExecuteOnList(criteria, (win) => WinMinimize("ahk_id " win.ID))
        TrayTip("Minimized " count " windows", "Automation", "Icon!")
    }

    static CloseMatching(criteria) {
        count := this.ExecuteOnList(criteria, (win) => WinClose("ahk_id " win.ID))
        TrayTip("Closed " count " windows", "Automation", "Icon!")
    }
}

^+6:: {
    criteria := {ClassEquals: "Notepad"}
    ListAutomation.MinimizeMatching(criteria)
}

; ========================================
; Example 6: Window Snapshot System
; ========================================

class SnapshotSystem {
    static snapshots := Map()

    static CreateSnapshot(name) {
        windowList := WinGetList()
        windows := []

        for winId in windowList {
            try {
                WinGetPos(&x, &y, &w, &h, "ahk_id " winId)

                windows.Push({
                    Title: WinGetTitle("ahk_id " winId),
                    Class: WinGetClass("ahk_id " winId),
                    Process: WinGetProcessName("ahk_id " winId),
                    Position: {X: x, Y: y, Width: w, Height: h}
                })
            }
        }

        this.snapshots[name] := {
            Name: name,
            Windows: windows,
            Timestamp: A_Now,
            Count: windows.Length
        }

        TrayTip("Snapshot created: " name, windows.Length " windows", "Icon!")
    }

    static RestoreSnapshot(name) {
        if !this.snapshots.Has(name) {
            MsgBox("Snapshot not found: " name, "Error", "IconX")
            return
        }

        snapshot := this.snapshots[name]
        restored := 0

        for winData in snapshot.Windows {
            ; Find matching window
            windowList := WinGetList()

            for winId in windowList {
                try {
                    if WinGetClass("ahk_id " winId) = winData.Class && WinGetProcessName("ahk_id " winId) = winData.Process {
                        WinMove(winData.Position.X, winData.Position.Y, winData.Position.Width, winData.Position.Height, "ahk_id " winId)
                        restored++
                        break
                    }
                }
            }
        }

        TrayTip("Restored " restored " of " snapshot.Count " windows", "Snapshot", "Icon!")
    }
}

^+7:: {
    name := InputBox("Enter snapshot name:", "Create Snapshot").Value
    if name != ""
    SnapshotSystem.CreateSnapshot(name)
}

^+8:: {
    name := InputBox("Enter snapshot name to restore:", "Restore Snapshot").Value
    if name != ""
    SnapshotSystem.RestoreSnapshot(name)
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinGetList Advanced Examples Ready", "Multiple patterns available", "Icon!")
}
