#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinActivate Examples - Part 3: Activate by Process ID (PID)
 * ============================================================================
 *
 * This script demonstrates how to use WinActivate with Process IDs.
 * Using PIDs provides the most precise window identification, especially
 * when dealing with multiple instances of the same application.
 *
 * @description Advanced window activation using Process IDs and process management
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Activate Window by Process ID
; ============================================================================

/**
 * Activates a window using its Process ID
 * Most precise method for window identification
 *
 * @hotkey F1 - Activate window by PID
 */
F1:: {
    try {
        ; Get active window's PID
        if WinExist("A") {
            pid := WinGetPID("A")
            MsgBox("Current window PID: " pid "`nClick OK and this window will be reactivated.", "PID Info", 64)

            ; Simulate switching to another window
            Send("!{Tab}")
            Sleep(500)

            ; Reactivate using PID
            if WinExist("ahk_pid " pid) {
                WinActivate()
                ToolTip("Window reactivated using PID: " pid)
                SetTimer(() => ToolTip(), -2000)
            }
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Process Manager with PID Tracking
; ============================================================================

/**
 * Creates a process manager that tracks and activates windows by PID
 * Useful for managing multiple instances of the same application
 *
 * @hotkey F2 - Show process manager
 */
F2:: {
    ShowProcessManager()
}

/**
 * Displays a GUI to manage processes and their windows
 */
ShowProcessManager() {
    static pmGui := ""

    if pmGui {
        try pmGui.Destroy()
    }

    pmGui := Gui("+AlwaysOnTop +Resize", "Process Manager")
    pmGui.SetFont("s9", "Segoe UI")

    pmGui.Add("Text", "w600", "Processes with visible windows:")

    ; Create ListView
    lv := pmGui.Add("ListView", "w600 h300 vProcessList",
        ["Process Name", "PID", "Window Title", "Window Count"])

    ; Collect process information
    processMap := Map()
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            if WinGetTitle(hwnd) != "" {
                pid := WinGetPID(hwnd)
                procName := WinGetProcessName(hwnd)
                title := WinGetTitle(hwnd)

                key := procName "_" pid

                if !processMap.Has(key) {
                    processMap[key] := {
                        name: procName,
                        pid: pid,
                        windows: [],
                        mainWindow: hwnd
                    }
                }

                processMap[key].windows.Push({hwnd: hwnd, title: title})
            }
        }
    }

    ; Populate ListView
    for key, info in processMap {
        lv.Add("", info.name, info.pid, info.windows[1].title, info.windows.Length)
    }

    ; Auto-size columns
    lv.ModifyCol(1, 150)
    lv.ModifyCol(2, 80)
    lv.ModifyCol(3, 280)
    lv.ModifyCol(4, 90)

    ; Add buttons
    pmGui.Add("Button", "w145 Default", "Activate").OnEvent("Click", ActivateProcess)
    pmGui.Add("Button", "w145 x+10 yp", "Show All Windows").OnEvent("Click", ShowAllProcessWindows)
    pmGui.Add("Button", "w145 x+10 yp", "Refresh").OnEvent("Click", (*) => (pmGui.Destroy(), ShowProcessManager()))
    pmGui.Add("Button", "w145 x+10 yp", "Close").OnEvent("Click", (*) => pmGui.Destroy())

    pmGui.Show()

    ActivateProcess(*) {
        if selectedRow := lv.GetNext() {
            pid := Integer(lv.GetText(selectedRow, 2))
            if WinExist("ahk_pid " pid) {
                WinActivate()
                ToolTip("Activated process: PID " pid)
                SetTimer(() => ToolTip(), -2000)
            }
        } else {
            MsgBox("Please select a process first.", "Info", 64)
        }
    }

    ShowAllProcessWindows(*) {
        if selectedRow := lv.GetNext() {
            pid := Integer(lv.GetText(selectedRow, 2))
            ShowWindowsForPID(pid)
        } else {
            MsgBox("Please select a process first.", "Info", 64)
        }
    }
}

/**
 * Shows all windows for a specific PID
 *
 * @param {Integer} pid - Process ID
 */
ShowWindowsForPID(pid) {
    static winGui := ""

    if winGui {
        try winGui.Destroy()
    }

    winGui := Gui("+AlwaysOnTop", "Windows for PID: " pid)
    winGui.SetFont("s9", "Segoe UI")

    procName := ""
    windows := []

    ; Collect all windows for this PID
    allWindows := WinGetList("ahk_pid " pid)
    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                if procName = "" {
                    procName := WinGetProcessName(hwnd)
                }
                windows.Push({hwnd: hwnd, title: title})
            }
        }
    }

    winGui.Add("Text", "w500", "Process: " procName " (PID: " pid ")")
    winGui.Add("Text", "w500", "Found " windows.Length " window(s)")

    winList := winGui.Add("ListBox", "w500 h200 vSelectedWindow")

    for win in windows {
        winList.Add([win.title])
    }

    if windows.Length > 0 {
        winList.Choose(1)
    }

    winGui.Add("Button", "w240 Default", "Activate Selected").OnEvent("Click", ActivateWin)
    winGui.Add("Button", "w240 x+20 yp", "Close").OnEvent("Click", (*) => winGui.Destroy())

    winGui.Show()

    ActivateWin(*) {
        selectedIdx := winList.Value
        if selectedIdx > 0 && selectedIdx <= windows.Length {
            WinActivate(windows[selectedIdx].hwnd)
            winGui.Destroy()
        }
    }
}

; ============================================================================
; Example 3: Launch and Track Application by PID
; ============================================================================

/**
 * Launches applications and tracks them by PID for later activation
 * Demonstrates PID-based application management
 *
 * @hotkey F3 - Launch and track Notepad
 */
F3:: {
    LaunchAndTrack()
}

; Global map to track launched applications
global launchedApps := Map()

/**
 * Launches an application and stores its PID
 */
LaunchAndTrack() {
    try {
        ; Launch Notepad
        Run("notepad.exe", , , &pid)

        ; Wait for window to appear
        if WinWait("ahk_pid " pid, , 5) {
            title := WinGetTitle("ahk_pid " pid)

            ; Store in tracking map
            launchedApps[pid] := {
                exe: "notepad.exe",
                title: title,
                launchTime: A_Now
            }

            MsgBox("Launched Notepad`nPID: " pid "`nTitle: " title "`n`nPress F8 to view all tracked applications.", "Launch Successful", 64)
        } else {
            MsgBox("Failed to detect Notepad window.", "Error", 16)
        }
    } catch Error as err {
        MsgBox("Error launching application: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 4: Multi-Instance Application Switcher
; ============================================================================

/**
 * Switches between multiple instances of the same application
 * Uses PID to distinguish between instances
 *
 * @hotkey F4 - Cycle through Notepad instances
 */
F4:: {
    CycleNotepadInstances()
}

/**
 * Cycles through all Notepad instances using PID
 */
CycleNotepadInstances() {
    static lastPID := 0

    try {
        ; Get all Notepad windows
        windows := WinGetList("ahk_class Notepad")

        if windows.Length = 0 {
            MsgBox("No Notepad windows found.", "Info", 64)
            return
        }

        ; Find current position
        currentIndex := 0
        for index, hwnd in windows {
            pid := WinGetPID(hwnd)
            if pid = lastPID {
                currentIndex := index
                break
            }
        }

        ; Move to next window
        nextIndex := Mod(currentIndex, windows.Length) + 1
        nextHwnd := windows[nextIndex]
        nextPID := WinGetPID(nextHwnd)

        ; Activate
        WinActivate("ahk_pid " nextPID)
        lastPID := nextPID

        title := WinGetTitle(nextHwnd)
        ToolTip("Activated Notepad #" nextIndex " (PID: " nextPID ")`n" title)
        SetTimer(() => ToolTip(), -2500)

    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 5: PID-Based Window Group Management
; ============================================================================

/**
 * Creates window groups based on PIDs for batch operations
 *
 * @hotkey F5 - Create PID-based window group
 */
F5:: {
    CreatePIDGroup()
}

; Global group storage
global windowGroups := Map()

/**
 * Creates a named group of windows by PID
 */
CreatePIDGroup() {
    static groupGui := ""

    if groupGui {
        try groupGui.Destroy()
    }

    groupGui := Gui("+AlwaysOnTop", "Create Window Group")
    groupGui.SetFont("s10", "Segoe UI")

    groupGui.Add("Text", "w400", "Enter group name:")
    groupName := groupGui.Add("Edit", "w400 vGroupName")

    groupGui.Add("Text", "w400", "Select windows to include:")

    ; List available windows
    winList := groupGui.Add("ListBox", "w400 h200 Multi vSelectedWindows")

    windows := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                pid := WinGetPID(hwnd)
                procName := WinGetProcessName(hwnd)
                displayText := title " [" procName " - PID: " pid "]"
                windows.Push({hwnd: hwnd, pid: pid, display: displayText})
                winList.Add([displayText])
            }
        }
    }

    groupGui.Add("Button", "w195 Default", "Create Group").OnEvent("Click", CreateGroup)
    groupGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => groupGui.Destroy())

    groupGui.Show()

    CreateGroup(*) {
        name := groupName.Value
        if name = "" {
            MsgBox("Please enter a group name.", "Error", 16)
            return
        }

        selected := []
        Loop winList.GetCount() {
            if winList.GetSelection(A_Index) {
                selected.Push(windows[A_Index].pid)
            }
        }

        if selected.Length = 0 {
            MsgBox("Please select at least one window.", "Error", 16)
            return
        }

        windowGroups[name] := selected
        MsgBox("Group '" name "' created with " selected.Length " windows.`n`nPress F6 to activate groups.", "Success", 64)
        groupGui.Destroy()
    }
}

; ============================================================================
; Example 6: Activate Window Group by PID
; ============================================================================

/**
 * Activates all windows in a PID-based group
 *
 * @hotkey F6 - Activate window group
 */
F6:: {
    ActivateWindowGroup()
}

/**
 * Shows GUI to select and activate window groups
 */
ActivateWindowGroup() {
    static groupGui := ""

    if windowGroups.Count = 0 {
        MsgBox("No window groups defined. Press F5 to create a group.", "Info", 64)
        return
    }

    if groupGui {
        try groupGui.Destroy()
    }

    groupGui := Gui("+AlwaysOnTop", "Activate Window Group")
    groupGui.SetFont("s10", "Segoe UI")

    groupGui.Add("Text", "w400", "Select group to activate:")

    groupList := groupGui.Add("ListBox", "w400 h150 vSelectedGroup")

    for groupName in windowGroups {
        pids := windowGroups[groupName]
        groupList.Add([groupName " (" pids.Length " windows)"])
    }

    groupList.Choose(1)

    groupGui.Add("Button", "w195 Default", "Activate All").OnEvent("Click", ActivateAll)
    groupGui.Add("Button", "w195 x+10 yp", "Close").OnEvent("Click", (*) => groupGui.Destroy())

    groupGui.Show()

    ActivateAll(*) {
        selected := groupList.Text
        groupName := RegExReplace(selected, " \(.*\)$", "")

        if windowGroups.Has(groupName) {
            pids := windowGroups[groupName]
            activatedCount := 0

            for pid in pids {
                if WinExist("ahk_pid " pid) {
                    WinActivate()
                    activatedCount++
                    Sleep(100)  ; Brief pause between activations
                }
            }

            MsgBox("Activated " activatedCount " of " pids.Length " windows in group '" groupName "'.", "Complete", 64)
            groupGui.Destroy()
        }
    }
}

; ============================================================================
; Example 7: Process Tree Window Activator
; ============================================================================

/**
 * Activates windows based on process parent-child relationships
 * Useful for activating all windows spawned by a parent process
 *
 * @hotkey F7 - Show process tree
 */
F7:: {
    ShowProcessTree()
}

/**
 * Displays process tree and allows activation of child windows
 */
ShowProcessTree() {
    static treeGui := ""

    if treeGui {
        try treeGui.Destroy()
    }

    treeGui := Gui("+AlwaysOnTop +Resize", "Process Tree")
    treeGui.SetFont("s9", "Consolas")

    treeGui.Add("Text", "w500", "Process hierarchy with windows:")

    tv := treeGui.Add("TreeView", "w500 h300 vProcessTree")

    ; Build process tree
    processes := Map()
    allWindows := WinGetList()

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                pid := WinGetPID(hwnd)
                procName := WinGetProcessName(hwnd)

                if !processes.Has(pid) {
                    processes[pid] := {
                        name: procName,
                        windows: []
                    }
                }

                processes[pid].windows.Push({hwnd: hwnd, title: title})
            }
        }
    }

    ; Add to TreeView
    for pid, info in processes {
        parentItem := tv.Add(info.name " (PID: " pid ")")

        for win in info.windows {
            tv.Add(win.title, parentItem)
        }
    }

    treeGui.Add("Button", "w240 Default", "Activate Selected").OnEvent("Click", ActivateFromTree)
    treeGui.Add("Button", "w240 x+20 yp", "Close").OnEvent("Click", (*) => treeGui.Destroy())

    treeGui.Show()

    ActivateFromTree(*) {
        selected := tv.GetSelection()
        if selected {
            text := tv.GetText(selected)

            ; Extract PID if it's a process item
            if RegExMatch(text, "PID: (\d+)", &match) {
                pid := Integer(match[1])
                if WinExist("ahk_pid " pid) {
                    WinActivate()
                }
            }
        }
    }
}

; ============================================================================
; Example 8: View All Tracked Applications
; ============================================================================

/**
 * Shows all applications tracked by PID
 *
 * @hotkey F8 - View tracked applications
 */
F8:: {
    ViewTrackedApps()
}

/**
 * Displays GUI with all tracked applications
 */
ViewTrackedApps() {
    if launchedApps.Count = 0 {
        MsgBox("No tracked applications. Press F3 to launch and track an application.", "Info", 64)
        return
    }

    static trackGui := ""

    if trackGui {
        try trackGui.Destroy()
    }

    trackGui := Gui("+AlwaysOnTop", "Tracked Applications")
    trackGui.SetFont("s9", "Segoe UI")

    lv := trackGui.Add("ListView", "w600 h200", ["PID", "Executable", "Title", "Launch Time", "Status"])

    for pid, info in launchedApps {
        status := WinExist("ahk_pid " pid) ? "Running" : "Closed"
        lv.Add("", pid, info.exe, info.title, info.launchTime, status)
    }

    lv.ModifyCol()

    trackGui.Add("Button", "w145 Default", "Activate").OnEvent("Click", ActivateTracked)
    trackGui.Add("Button", "w145 x+10 yp", "Clear Closed").OnEvent("Click", ClearClosed)
    trackGui.Add("Button", "w145 x+10 yp", "Refresh").OnEvent("Click", (*) => (trackGui.Destroy(), ViewTrackedApps()))
    trackGui.Add("Button", "w145 x+10 yp", "Close").OnEvent("Click", (*) => trackGui.Destroy())

    trackGui.Show()

    ActivateTracked(*) {
        if selectedRow := lv.GetNext() {
            pid := Integer(lv.GetText(selectedRow, 1))
            if WinExist("ahk_pid " pid) {
                WinActivate()
                trackGui.Destroy()
            } else {
                MsgBox("This window is no longer running.", "Error", 16)
            }
        }
    }

    ClearClosed(*) {
        toRemove := []
        for pid in launchedApps {
            if !WinExist("ahk_pid " pid) {
                toRemove.Push(pid)
            }
        }

        for pid in toRemove {
            launchedApps.Delete(pid)
        }

        trackGui.Destroy()
        ViewTrackedApps()
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinActivate Examples - Part 3 (Process ID)
    ===========================================

    Hotkeys:
    F1 - Activate window by PID
    F2 - Show process manager
    F3 - Launch and track Notepad
    F4 - Cycle through Notepad instances
    F5 - Create PID-based window group
    F6 - Activate window group
    F7 - Show process tree
    F8 - View tracked applications
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
