#Requires AutoHotkey v2.0

/**
* ============================================================================
* WinMove Examples - Part 1: Position Window
* ============================================================================
*
* This script demonstrates how to move windows to specific positions.
* Essential for window organization, multi-monitor setups, and layouts.
*
* @description Comprehensive window positioning examples
* @author AutoHotkey Community
* @version 2.0.0
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Move Window to Specific Position
; ============================================================================

/**
* Moves the active window to specific coordinates
* Basic positioning example
*
* @hotkey F1 - Move to top-left corner
*/
F1:: {
    try {
        if !WinExist("A") {
            MsgBox("No active window.", "Error", 16)
            return
        }

        ; Move to top-left corner
        WinMove(0, 0, , , "A")
        ToolTip("Window moved to top-left (0, 0)")
        SetTimer(() => ToolTip(), -1500)
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Center Window on Screen
; ============================================================================

/**
* Centers the active window on the current monitor
* Useful for focusing attention
*
* @hotkey F2 - Center window
*/
F2:: {
    CenterWindow()
}

/**
* Centers active window on screen
*/
CenterWindow() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    ; Get window dimensions
    WinGetPos(&winX, &winY, &winW, &winH, "A")

    ; Get monitor info for window
    monitorNum := GetMonitorUnderWindow()
    MonitorGetWorkArea(monitorNum, &left, &top, &right, &bottom)

    ; Calculate center position
    newX := left + ((right - left - winW) // 2)
    newY := top + ((bottom - top - winH) // 2)

    ; Move window
    WinMove(newX, newY, , , "A")

    ToolTip("Window centered on monitor " monitorNum)
    SetTimer(() => ToolTip(), -1500)
}

/**
* Gets monitor number containing most of window
*/
GetMonitorUnderWindow() {
    WinGetPos(&x, &y, &w, &h, "A")
    centerX := x + (w // 2)
    centerY := y + (h // 2)

    monitorCount := MonitorGetCount()
    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        if (centerX >= left && centerX <= right && centerY >= top && centerY <= bottom) {
            return A_Index
        }
    }
    return 1
}

; ============================================================================
; Example 3: Position Window at Specific Corner
; ============================================================================

/**
* Moves window to screen corners
* Quick window organization
*
* @hotkey F3 - Show corner menu
*/
F3:: {
    PositionAtCorner()
}

/**
* GUI for corner positioning
*/
PositionAtCorner() {
    static cornerGui := ""

    if cornerGui {
        try cornerGui.Destroy()
    }

    cornerGui := Gui("+AlwaysOnTop", "Position at Corner")
    cornerGui.SetFont("s10", "Segoe UI")

    cornerGui.Add("Text", "w300", "Select corner:")

    corners := [
    "Top-Left",
    "Top-Right",
    "Bottom-Left",
    "Bottom-Right",
    "Center"
    ]

    cornerList := cornerGui.Add("ListBox", "w300 h120 vCorner")
    cornerList.Add(corners)
    cornerList.Choose(1)

    cornerGui.Add("CheckBox", "vWithMargin Checked", "Add 10px margin")

    cornerGui.Add("Button", "w145 Default", "Apply").OnEvent("Click", Apply)
    cornerGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => cornerGui.Destroy())

    cornerGui.Show()

    Apply(*) {
        if !WinExist("A") {
            MsgBox("No active window.", "Error", 16)
            return
        }

        submitted := cornerGui.Submit()
        margin := submitted.WithMargin ? 10 : 0

        WinGetPos(, , &w, &h, "A")
        monNum := GetMonitorUnderWindow()
        MonitorGetWorkArea(monNum, &left, &top, &right, &bottom)

        switch submitted.Corner {
            case 1:  ; Top-Left
            WinMove(left + margin, top + margin, , , "A")
            case 2:  ; Top-Right
            WinMove(right - w - margin, top + margin, , , "A")
            case 3:  ; Bottom-Left
            WinMove(left + margin, bottom - h - margin, , , "A")
            case 4:  ; Bottom-Right
            WinMove(right - w - margin, bottom - h - margin, , , "A")
            case 5:  ; Center
            WinMove(left + ((right - left - w) // 2), top + ((bottom - top - h) // 2), , , "A")
        }

        cornerGui.Destroy()
        ToolTip("Window positioned at " corners[submitted.Corner])
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 4: Cascade Windows
; ============================================================================

/**
* Arranges multiple windows in a cascade pattern
* Classic window management
*
* @hotkey F4 - Cascade windows
*/
F4:: {
    CascadeWindows()
}

/**
* Cascades all windows
*/
CascadeWindows() {
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)

    startX := left + 20
    startY := top + 20
    offsetX := 30
    offsetY := 30

    windowWidth := 800
    windowHeight := 600

    allWindows := WinGetList()
    count := 0

    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                x := startX + (count * offsetX)
                y := startY + (count * offsetY)

                ; Don't cascade off screen
                if (x + windowWidth > right || y + windowHeight > bottom) {
                    count := 0
                    x := startX
                    y := startY
                }

                WinMove(x, y, windowWidth, windowHeight, hwnd)
                count++
            }
        }
    }

    MsgBox("Cascaded " count " windows.", "Success", 64)
}

; ============================================================================
; Example 5: Multi-Monitor Window Mover
; ============================================================================

/**
* Moves windows between monitors
* Essential for multi-monitor setups
*
* @hotkey F5 - Move to next monitor
*/
F5:: {
    MoveToNextMonitor()
}

/**
* Moves active window to next monitor
*/
MoveToNextMonitor() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    monCount := MonitorGetCount()

    if monCount < 2 {
        MsgBox("Only one monitor detected.", "Info", 64)
        return
    }

    ; Get current monitor
    currentMon := GetMonitorUnderWindow()

    ; Get next monitor (wraps around)
    nextMon := Mod(currentMon, monCount) + 1

    ; Get window dimensions
    WinGetPos(&winX, &winY, &winW, &winH, "A")

    ; Get next monitor work area
    MonitorGetWorkArea(nextMon, &left, &top, &right, &bottom)

    ; Calculate relative position
    MonitorGetWorkArea(currentMon, &curLeft, &curTop, &curRight, &curBottom)

    relX := (winX - curLeft) / (curRight - curLeft)
    relY := (winY - curTop) / (curBottom - curTop)

    ; Apply to new monitor
    newX := left + Round((right - left) * relX)
    newY := top + Round((bottom - top) * relY)

    ; Ensure window fits
    if (newX + winW > right) {
        newX := right - winW
    }
    if (newY + winH > bottom) {
        newY := bottom - winH
    }

    WinMove(newX, newY, , , "A")

    ToolTip("Moved to monitor " nextMon)
    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 6: Precise Position Input
; ============================================================================

/**
* Allows precise positioning via input
* For exact window placement
*
* @hotkey F6 - Precise position input
*/
F6:: {
    PrecisePosition()
}

/**
* GUI for precise positioning
*/
PrecisePosition() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    static preciseGui := ""

    if preciseGui {
        try preciseGui.Destroy()
    }

    WinGetPos(&curX, &curY, &curW, &curH, "A")

    preciseGui := Gui("+AlwaysOnTop", "Precise Position")
    preciseGui.SetFont("s10", "Segoe UI")

    preciseGui.Add("Text", "w80", "X Position:")
    xEdit := preciseGui.Add("Edit", "w200 x+10 yp-3 vXPos Number", curX)

    preciseGui.Add("Text", "w80 xm", "Y Position:")
    yEdit := preciseGui.Add("Edit", "w200 x+10 yp-3 vYPos Number", curY)

    preciseGui.Add("Text", "w290", "Current: " curX ", " curY)

    preciseGui.Add("Button", "w140 Default", "Apply").OnEvent("Click", Apply)
    preciseGui.Add("Button", "w140 x+10 yp", "Cancel").OnEvent("Click", (*) => preciseGui.Destroy())

    preciseGui.Show()

    Apply(*) {
        submitted := preciseGui.Submit()
        WinMove(submitted.XPos, submitted.YPos, , , "A")
        preciseGui.Destroy()
        ToolTip("Moved to " submitted.XPos ", " submitted.YPos)
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 7: Save and Restore Window Positions
; ============================================================================

/**
* Saves and restores window positions
* Layout management
*
* @hotkey F7 - Save/restore positions
*/
F7:: {
    ManagePositions()
}

; Global position storage
global savedPositions := Map()

/**
* Position management GUI
*/
ManagePositions() {
    static posGui := ""

    if posGui {
        try posGui.Destroy()
    }

    posGui := Gui("+AlwaysOnTop", "Position Manager")
    posGui.SetFont("s10", "Segoe UI")

    posGui.Add("Button", "w350", "Save All Window Positions").OnEvent("Click", SaveAll)
    posGui.Add("Button", "w350", "Restore All Window Positions").OnEvent("Click", RestoreAll)

    posGui.Add("Text", "w350", "Saved positions:")
    lv := posGui.Add("ListView", "w350 h200 vPosList", ["Title", "X", "Y"])

    posGui.Add("Button", "w350", "Close").OnEvent("Click", (*) => posGui.Destroy())

    posGui.Show()

    UpdateList()

    SaveAll(*) {
        savedPositions := Map()
        allWindows := WinGetList()

        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    WinGetPos(&x, &y, &w, &h, hwnd)
                    savedPositions[hwnd] := {title: title, x: x, y: y, w: w, h: h}
                }
            }
        }

        UpdateList()
        MsgBox("Saved positions for " savedPositions.Count " windows.", "Success", 64)
    }

    RestoreAll(*) {
        if savedPositions.Count = 0 {
            MsgBox("No saved positions. Please save first.", "Error", 16)
            return
        }

        restored := 0

        for hwnd, pos in savedPositions {
            try {
                if WinExist(hwnd) {
                    WinMove(pos.x, pos.y, pos.w, pos.h, hwnd)
                    restored++
                }
            }
        }

        MsgBox("Restored " restored " window positions.", "Success", 64)
    }

    UpdateList() {
        lv.Delete()

        for hwnd, pos in savedPositions {
            if WinExist(hwnd) {
                lv.Add("", pos.title, pos.x, pos.y)
            }
        }

        lv.ModifyCol()
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinMove Examples - Part 1 (Position Window)
    ============================================

    Hotkeys:
    F1 - Move to top-left corner
    F2 - Center window on screen
    F3 - Position at corner (menu)
    F4 - Cascade all windows
    F5 - Move to next monitor
    F6 - Precise position input
    F7 - Save/restore positions
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
