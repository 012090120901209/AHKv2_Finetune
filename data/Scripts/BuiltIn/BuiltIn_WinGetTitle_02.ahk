#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * ============================================================================
 * WinGetTitle Examples - Part 2: List All Window Titles
 * ============================================================================
 * 
 * This script demonstrates how to enumerate and list all window titles.
 * Essential for window management, monitoring, and organizational tasks.
 * 
 * @description List and manage multiple window titles
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: List All Window Titles
; ============================================================================

/**
 * Retrieves and displays all window titles in the system
 * Basic enumeration example
 * 
 * @hotkey F1 - List all window titles
 */
F1:: {
    ListAllWindowTitles()
}

/**
 * Displays all window titles in a list
 */
ListAllWindowTitles() {
    static listGui := ""

    if listGui {
        try listGui.Destroy()
    }

    listGui := Gui("+AlwaysOnTop +Resize", "All Window Titles")
    listGui.SetFont("s9", "Segoe UI")

    listGui.Add("Text", "w700", "All windows with titles:")

    lv := listGui.Add("ListView", "w700 h400 vWindowList", ["#", "Title", "Process", "PID", "HWND"])

    ; Enumerate all windows
    allWindows := WinGetList()
    count := 0

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                count++
                process := WinGetProcessName(hwnd)
                pid := WinGetPID(hwnd)
                lv.Add("", count, title, process, pid, Format("0x{:X}", hwnd))
            }
        }
    }

    ; Auto-size columns
    lv.ModifyCol(1, "AutoHdr")
    lv.ModifyCol(2, 350)
    lv.ModifyCol(3, "AutoHdr")
    lv.ModifyCol(4, "AutoHdr")
    lv.ModifyCol(5, "AutoHdr")

    listGui.Add("Text", "w700", "Total windows with titles: " count)

    listGui.Add("Button", "w170 Default", "Activate Selected").OnEvent("Click", ActivateWin)
    listGui.Add("Button", "w170 x+10 yp", "Copy Title").OnEvent("Click", CopyTitle)
    listGui.Add("Button", "w170 x+10 yp", "Refresh").OnEvent("Click", (*) => (listGui.Destroy(), ListAllWindowTitles()))
    listGui.Add("Button", "w170 x+10 yp", "Close").OnEvent("Click", (*) => listGui.Destroy())

    listGui.Show()

    ActivateWin(*) {
        if selectedRow := lv.GetNext() {
            hwndText := lv.GetText(selectedRow, 5)
            hwnd := Integer(hwndText)
            WinActivate(hwnd)
        }
    }

    CopyTitle(*) {
        if selectedRow := lv.GetNext() {
            title := lv.GetText(selectedRow, 2)
            A_Clipboard := title
            ToolTip("Title copied!")
            SetTimer(() => ToolTip(), -1500)
        }
    }
}

; ============================================================================
; Example 2: Categorize Windows by Application
; ============================================================================

/**
 * Groups windows by their parent application
 * Useful for understanding window distribution
 * 
 * @hotkey F2 - Categorize windows
 */
F2:: {
    CategorizeWindows()
}

/**
 * Creates categorized view of windows
 */
CategorizeWindows() {
    static catGui := ""

    if catGui {
        try catGui.Destroy()
    }

    catGui := Gui("+AlwaysOnTop +Resize", "Windows by Application")
    catGui.SetFont("s9", "Segoe UI")

    catGui.Add("Text", "w650", "Windows grouped by application:")

    tv := catGui.Add("TreeView", "w650 h400 vWindowTree")

    ; Collect windows by process
    processList := Map()
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                process := WinGetProcessName(hwnd)

                if !processList.Has(process) {
                    processList[process] := []
                }

                processList[process].Push({ hwnd: hwnd, title: title })
            }
        }
    }

    ; Build tree view
    for process, windows in processList {
        parentItem := tv.Add(process " (" windows.Length " window" (windows.Length > 1 ? "s" : "") ")")

        for win in windows {
            tv.Add(win.title, parentItem)
        }
    }

    catGui.Add("Text", "w650", "Total applications: " processList.Count)

    catGui.Add("Button", "w210 Default", "Expand All").OnEvent("Click", (*) => ExpandTree(tv, true))
    catGui.Add("Button", "w210 x+10 yp", "Collapse All").OnEvent("Click", (*) => ExpandTree(tv, false))
    catGui.Add("Button", "w210 x+10 yp", "Close").OnEvent("Click", (*) => catGui.Destroy())

    catGui.Show()
}

/**
 * Expands or collapses tree view
 */
ExpandTree(treeView, expand) {
    itemID := 0
    while (itemID := treeView.GetNext(itemID)) {
        if expand {
            treeView.Modify(itemID, "Expand")
        } else {
            treeView.Modify(itemID, "-Expand")
        }
    }
}

; ============================================================================
; Example 3: Export Window Titles to File
; ============================================================================

/**
 * Exports all window titles to various file formats
 * Useful for documentation and reporting
 * 
 * @hotkey F3 - Export window titles
 */
F3:: {
    ExportWindowTitles()
}

/**
 * Exports window titles to file
 */
ExportWindowTitles() {
    static exportGui := ""

    if exportGui {
        try exportGui.Destroy()
    }

    exportGui := Gui("+AlwaysOnTop", "Export Window Titles")
    exportGui.SetFont("s10", "Segoe UI")

    exportGui.Add("Text", "w400", "Select export format:")
    formatDrop := exportGui.Add("DropDownList", "w400 vFormat Choose1", ["Plain Text (.txt)", "CSV (.csv)", "HTML (.html)", "JSON (.json)"])

    exportGui.Add("Text", "w400", "Include process information:")
    includeProc := exportGui.Add("CheckBox", "vIncludeProc Checked", "Yes")

    exportGui.Add("Button", "w195 Default", "Export").OnEvent("Click", DoExport)
    exportGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => exportGui.Destroy())

    exportGui.Show()

    DoExport(*) {
        submitted := exportGui.Submit(false)
        format := submitted.Format
        includeProcess := submitted.IncludeProc

        ; Collect window data
        windowData := []
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    entry := { title: title }

                    if includeProcess {
                        entry.process := WinGetProcessName(hwnd)
                        entry.pid := WinGetPID(hwnd)
                    }

                    windowData.Push(entry)
                }
            }
        }

        ; Generate content based on format
        content := ""
        fileExt := ""

        switch format {
            case 1:  ; Plain Text
                fileExt := ".txt"
                content := "Window Titles - " A_Now "`n"
                content .= StrRepeat("=", 60) "`n`n"

                for win in windowData {
                    content .= win.title
                    if includeProcess {
                        content .= " [" win.process "]"
                    }
                    content .= "`n"
                }

            case 2:  ; CSV
                fileExt := ".csv"
                if includeProcess {
                    content := "Title,Process,PID`n"
                    for win in windowData {
                        content .= '"' win.title '","' win.process '",' win.pid "`n"
                    }
                } else {
                    content := "Title`n"
                    for win in windowData {
                        content .= '"' win.title '"`n'
                    }
                }

            case 3:  ; HTML
                fileExt := ".html"
                content := "<!DOCTYPE html>`n<html>`n<head>`n<title>Window Titles</title>`n"
                content .= "<style>table{border-collapse:collapse;width:100%;}th,td{border:1px solid black;padding:8px;text-align:left;}th{background-color:#4CAF50;color:white;}</style>`n"
                content .= "</head>`n<body>`n"
                content .= "<h1>Window Titles - " A_Now "</h1>`n"
                content .= "<table>`n<tr><th>Title</th>"

                if includeProcess {
                    content .= "<th>Process</th><th>PID</th>"
                }

                content .= "</tr>`n"

                for win in windowData {
                    content .= "<tr><td>" win.title "</td>"
                    if includeProcess {
                        content .= "<td>" win.process "</td><td>" win.pid "</td>"
                    }
                    content .= "</tr>`n"
                }

                content .= "</table>`n</body>`n</html>"

            case 4:  ; JSON
                fileExt := ".json"
                content := "[\n"

                for index, win in windowData {
                    content .= "  {\n"
                    content .= '    "title": "' StrReplace(win.title, '"', '\"') '"'

                    if includeProcess {
                        content .= ',\n    "process": "' win.process '"'
                        content .= ',\n    "pid": ' win.pid
                    }

                    content .= "\n  }"

                    if index < windowData.Length {
                        content .= ","
                    }

                    content .= "\n"
                }

                content .= "]"
        }

        ; Save file
        fileName := "WindowTitles_" A_YYYY A_MM A_DD "_" A_Hour A_Min A_Sec fileExt
        filePath := A_Desktop "\" fileName

        try {
            FileAppend(content, filePath)
            exportGui.Destroy()
            MsgBox("Window titles exported successfully!`n`nFile: " filePath "`nWindows: " windowData.Length, "Export Complete", 64)
        } catch Error as err {
            MsgBox("Error exporting file: " err.Message, "Error", 16)
        }
    }
}

/**
 * Helper to repeat strings
 */
StrRepeat(str, count) {
    result := ""
    Loop count {
        result .= str
    }
    return result
}

; ============================================================================
; Example 4: Filter and Search Window Titles
; ============================================================================

/**
 * Advanced filtering and searching of window titles
 * Supports multiple filter criteria
 * 
 * @hotkey F4 - Filter window titles
 */
F4:: {
    FilterWindowTitles()
}

/**
 * Creates advanced filtering GUI
 */
FilterWindowTitles() {
    static filterGui := ""

    if filterGui {
        try filterGui.Destroy()
    }

    filterGui := Gui("+AlwaysOnTop +Resize", "Filter Window Titles")
    filterGui.SetFont("s9", "Segoe UI")

    filterGui.Add("Text", "w700", "Filter criteria:")

    filterGui.Add("Text", "w100", "Title contains:")
    titleFilter := filterGui.Add("Edit", "w590 x+10 yp-3 vTitleFilter")

    filterGui.Add("Text", "w100 xm", "Process:")
    procFilter := filterGui.Add("Edit", "w590 x+10 yp-3 vProcessFilter")

    filterGui.Add("Text", "w100 xm", "Min length:")
    minLen := filterGui.Add("Edit", "w100 x+10 yp-3 vMinLen Number", "0")

    filterGui.Add("Text", "w100 x+20 yp+3", "Max length:")
    maxLen := filterGui.Add("Edit", "w100 x+10 yp-3 vMaxLen Number", "9999")

    filterGui.Add("CheckBox", "xm vCaseSens", "Case sensitive")

    lv := filterGui.Add("ListView", "w700 h300 xm vResults", ["Title", "Process", "Length"])

    filterGui.Add("Button", "w170 Default", "Apply Filter").OnEvent("Click", ApplyFilter)
    filterGui.Add("Button", "w170 x+10 yp", "Clear Filters").OnEvent("Click", ClearFilters)
    filterGui.Add("Button", "w170 x+10 yp", "Activate").OnEvent("Click", ActivateSelected)
    filterGui.Add("Button", "w170 x+10 yp", "Close").OnEvent("Click", (*) => filterGui.Destroy())

    filterGui.Show()

    global filteredWindows := []

    ApplyFilter(*) {
        submitted := filterGui.Submit(false)
        titleText := submitted.TitleFilter
        processText := submitted.ProcessFilter
        minLength := Integer(submitted.MinLen)
        maxLength := Integer(submitted.MaxLen)
        caseSensitive := submitted.CaseSens

        lv.Delete()
        filteredWindows := []

        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title = "" {
                    continue
                }

                process := WinGetProcessName(hwnd)
                titleLen := StrLen(title)

                ; Apply filters
                titleMatch := true
                processMatch := true

                if titleText != "" {
                    searchTitle := caseSensitive ? title : StrLower(title)
                    searchPattern := caseSensitive ? titleText : StrLower(titleText)
                    titleMatch := InStr(searchTitle, searchPattern)
                }

                if processText != "" {
                    searchProc := caseSensitive ? process : StrLower(process)
                    searchPattern := caseSensitive ? processText : StrLower(processText)
                    processMatch := InStr(searchProc, searchPattern)
                }

                lengthMatch := (titleLen >= minLength && titleLen <= maxLength)

                if titleMatch && processMatch && lengthMatch {
                    lv.Add("", title, process, titleLen)
                    filteredWindows.Push(hwnd)
                }
            }
        }

        lv.ModifyCol(1, 450)
        lv.ModifyCol(2, "AutoHdr")
        lv.ModifyCol(3, "AutoHdr")
    }

    ClearFilters(*) {
        titleFilter.Value := ""
        procFilter.Value := ""
        minLen.Value := "0"
        maxLen.Value := "9999"
        lv.Delete()
        filteredWindows := []
    }

    ActivateSelected(*) {
        if selectedRow := lv.GetNext() {
            if selectedRow <= filteredWindows.Length {
                WinActivate(filteredWindows[selectedRow])
            }
        }
    }
}

; ============================================================================
; Example 5: Window Title Statistics
; ============================================================================

/**
 * Analyzes window title statistics
 * Provides insights into window title patterns
 * 
 * @hotkey F5 - Show title statistics
 */
F5:: {
    ShowTitleStatistics()
}

/**
 * Displays statistical analysis of window titles
 */
ShowTitleStatistics() {
    allWindows := WinGetList()

    totalWindows := 0
    totalChars := 0
    longestTitle := ""
    shortestTitle := ""
    processCount := Map()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                totalWindows++
                titleLen := StrLen(title)
                totalChars += titleLen

                if longestTitle = "" || titleLen > StrLen(longestTitle) {
                    longestTitle := title
                }

                if shortestTitle = "" || titleLen < StrLen(shortestTitle) {
                    shortestTitle := title
                }

                process := WinGetProcessName(hwnd)
                processCount[process] := processCount.Has(process) ? processCount[process] + 1 : 1
            }
        }
    }

    ; Find most common process
    mostCommon := ""
    maxCount := 0

    for process, count in processCount {
        if count > maxCount {
            maxCount := count
            mostCommon := process
        }
    }

    avgLength := totalWindows > 0 ? Round(totalChars / totalWindows, 1) : 0

    stats := "Window Title Statistics`n"
    stats .= StrRepeat("=", 50) . "`n`n"
    stats .= "Total windows: " totalWindows "`n"
    stats .= "Total characters: " totalChars "`n"
    stats .= "Average title length: " avgLength " chars`n`n"
    stats .= "Longest title (" StrLen(longestTitle) " chars):`n" SubStr(longestTitle, 1, 100) (StrLen(longestTitle) > 100 ? "..." : "") "`n`n"
    stats .= "Shortest title (" StrLen(shortestTitle) " chars):`n" shortestTitle "`n`n"
    stats .= "Most common process:`n" mostCommon " (" maxCount " windows)"

    MsgBox(stats, "Title Statistics", 64)
}

; ============================================================================
; Example 6: Duplicate Title Finder
; ============================================================================

/**
 * Finds windows with duplicate or similar titles
 * Useful for identifying redundant windows
 * 
 * @hotkey F6 - Find duplicate titles
 */
F6:: {
    FindDuplicateTitles()
}

/**
 * Finds and displays duplicate window titles
 */
FindDuplicateTitles() {
    static dupGui := ""

    if dupGui {
        try dupGui.Destroy()
    }

    dupGui := Gui("+AlwaysOnTop", "Duplicate Title Finder")
    dupGui.SetFont("s9", "Segoe UI")

    dupGui.Add("Text", "w600", "Windows with duplicate titles:")

    lv := dupGui.Add("ListView", "w600 h350 vDuplicates", ["Title", "Count", "Processes"])

    ; Find duplicates
    titleMap := Map()
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                if !titleMap.Has(title) {
                    titleMap[title] := []
                }

                process := WinGetProcessName(hwnd)
                titleMap[title].Push(process)
            }
        }
    }

    ; Add only duplicates to list
    duplicateCount := 0

    for title, processes in titleMap {
        if processes.Length > 1 {
            duplicateCount++
            uniqueProcs := ""
            procMap := Map()

            for proc in processes {
                procMap[proc] := true
            }

            for proc in procMap {
                uniqueProcs .= (uniqueProcs != "" ? ", " : "") proc
            }

            lv.Add("", title, processes.Length, uniqueProcs)
        }
    }

    lv.ModifyCol(1, 300)
    lv.ModifyCol(2, "AutoHdr")
    lv.ModifyCol(3, 250)

    dupGui.Add("Text", "w600", "Found " duplicateCount " title(s) with duplicates")

    dupGui.Add("Button", "w290 Default", "Close").OnEvent("Click", (*) => dupGui.Destroy())

    dupGui.Show()
}

; ============================================================================
; Example 7: Real-Time Title Monitor
; ============================================================================

/**
 * Monitors all window titles in real-time
 * Shows additions and removals
 * 
 * @hotkey F7 - Start real-time monitor
 */
F7:: {
    static monitoring := false

    if !monitoring {
        monitoring := true
        StartRealtimeMonitor()
    } else {
        monitoring := false
    }
}

/**
 * Creates real-time monitoring display
 */
StartRealtimeMonitor() {
    static monGui := ""
    static lv := ""
    static lastTitles := Map()

    if monGui {
        try monGui.Destroy()
    }

    monGui := Gui("+AlwaysOnTop +Resize", "Real-Time Title Monitor")
    monGui.SetFont("s9", "Consolas")

    monGui.Add("Text", "w700", "Monitoring all window titles (updates every 2 seconds):")

    lv := monGui.Add("ListView", "w700 h400 vMonitor", ["Title", "Process", "Status"])

    monGui.Add("Button", "w340 Default", "Stop Monitor").OnEvent("Click", StopMon)
    monGui.Add("Button", "w340 x+20 yp", "Close").OnEvent("Click", (*) => monGui.Destroy())

    monGui.Show()

    ; Initialize
    UpdateTitles()

    ; Start monitoring
    SetTimer(UpdateTitles, 2000)

    UpdateTitles() {
        currentTitles := Map()
        allWindows := WinGetList()

        ; Collect current titles
        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    process := WinGetProcessName(hwnd)
                    key := title "|" process
                    currentTitles[key] := true
                }
            }
        }

        ; Update ListView
        lv.Delete()

        for key in currentTitles {
            parts := StrSplit(key, "|")
            title := parts[1]
            process := parts[2]

            status := lastTitles.Has(key) ? "" : "NEW"
            lv.Add("", title, process, status)
        }

        lv.ModifyCol(1, 400)
        lv.ModifyCol(2, "AutoHdr")
        lv.ModifyCol(3, "AutoHdr")

        lastTitles := currentTitles
    }

    StopMon(*) {
        SetTimer(UpdateTitles, 0)
        monGui.Destroy()
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinGetTitle Examples - Part 2 (List All Titles)
    ================================================

    Hotkeys:
    F1 - List all window titles
    F2 - Categorize windows by application
    F3 - Export window titles
    F4 - Filter window titles
    F5 - Show title statistics
    F6 - Find duplicate titles
    F7 - Start/stop real-time monitor
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
