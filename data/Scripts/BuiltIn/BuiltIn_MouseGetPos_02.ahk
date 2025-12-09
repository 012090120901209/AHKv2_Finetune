#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 MouseGetPos - Monitor Coordinates
* ============================================================================
*
* Demonstrates multi-monitor support, coordinate translation between monitors,
* and monitor-specific positioning logic.
*
* @module BuiltIn_MouseGetPos_02
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Basic Monitor Detection
; ============================================================================

/**
* Detects which monitor the cursor is on.
* Works with single or multiple monitor setups.
*
* @example
* ; Press F1 to show current monitor
*/
F1:: {
    MouseGetPos(&x, &y)

    monitorCount := MonitorGetCount()
    monitorPrimary := MonitorGetPrimary()

    currentMonitor := 0

    ; Find which monitor contains the cursor
    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        if (x >= left && x < right && y >= top && y < bottom) {
            currentMonitor := A_Index
            break
        }
    }

    info := "Monitor Information:`n`n"
    info .= "Total Monitors: " monitorCount "`n"
    info .= "Primary Monitor: " monitorPrimary "`n"
    info .= "Current Monitor: " (currentMonitor ? currentMonitor : "None") "`n`n"
    info .= "Cursor Position:`nX: " x ", Y: " y

    if (currentMonitor) {
        MonitorGet(currentMonitor, &left, &top, &right, &bottom)
        info .= "`n`nMonitor " currentMonitor " Bounds:`n"
        info .= "Left: " left ", Top: " top "`n"
        info .= "Right: " right ", Bottom: " bottom "`n"
        info .= "Size: " (right-left) "x" (bottom-top)
    }

    MsgBox(info, "Monitor Detection")
}

/**
* Shows all monitors and cursor position
* Displays complete multi-monitor layout
*/
F2:: {
    MouseGetPos(&mouseX, &mouseY)

    monitorCount := MonitorGetCount()
    info := "Multi-Monitor Layout:`n`n"

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        MonitorGetWorkArea(A_Index, &waLeft, &waTop, &waRight, &waBottom)

        info .= "Monitor " A_Index
        if (A_Index = MonitorGetPrimary())
        info .= " (Primary)"
        info .= ":`n"

        info .= "  Full: " left "," top " to " right "," bottom
        info .= " (" (right-left) "x" (bottom-top) ")`n"

        info .= "  Work: " waLeft "," waTop " to " waRight "," waBottom
        info .= " (" (waRight-waLeft) "x" (waBottom-waTop) ")`n"

        ; Check if cursor is on this monitor
        if (mouseX >= left && mouseX < right && mouseY >= top && mouseY < bottom)
        info .= "  >>> CURSOR IS HERE <<<`n"

        info .= "`n"
    }

    info .= "Cursor: X=" mouseX ", Y=" mouseY

    MsgBox(info, "All Monitors")
}

; ============================================================================
; Example 2: Monitor-Relative Coordinates
; ============================================================================

/**
* Converts screen coordinates to monitor-relative.
* Shows position relative to current monitor's top-left.
*
* @description
* Useful for monitor-independent automation
*/
^F1:: {
    MouseGetPos(&x, &y)

    ; Find current monitor
    monitorCount := MonitorGetCount()
    currentMonitor := 0

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        if (x >= left && x < right && y >= top && y < bottom) {
            currentMonitor := A_Index

            ; Calculate relative position
            relX := x - left
            relY := y - top

            ; Calculate percentage
            percentX := Round((relX / (right - left)) * 100, 1)
            percentY := Round((relY / (bottom - top)) * 100, 1)

            info := "Monitor-Relative Coordinates:`n`n"
            info .= "Monitor: " currentMonitor "`n`n"
            info .= "Screen Absolute:`n"
            info .= "  X: " x ", Y: " y "`n`n"
            info .= "Monitor Relative:`n"
            info .= "  X: " relX ", Y: " relY "`n`n"
            info .= "Monitor Percentage:`n"
            info .= "  X: " percentX "%, Y: " percentY "%`n`n"
            info .= "Monitor Size: " (right-left) "x" (bottom-top)

            MsgBox(info, "Relative Coordinates")
            break
        }
    }

    if (!currentMonitor)
    MsgBox("Cursor not on any monitor!", "Error")
}

/**
* Work area vs full monitor coordinates
* Shows difference between full screen and work area
*/
^F2:: {
    MouseGetPos(&x, &y)

    monitorCount := MonitorGetCount()

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        if (x >= left && x < right && y >= top && y < bottom) {
            MonitorGetWorkArea(A_Index, &waLeft, &waTop, &waRight, &waBottom)

            ; Calculate positions
            fullRelX := x - left
            fullRelY := y - top
            workRelX := x - waLeft
            workRelY := y - waTop

            info := "Full Monitor vs Work Area:`n`n"
            info .= "=== Full Monitor ===`n"
            info .= "Bounds: " (right-left) "x" (bottom-top) "`n"
            info .= "Relative: X=" fullRelX ", Y=" fullRelY "`n`n"

            info .= "=== Work Area ===`n"
            info .= "Bounds: " (waRight-waLeft) "x" (waBottom-waTop) "`n"
            info .= "Relative: X=" workRelX ", Y=" workRelY "`n`n"

            info .= "=== Taskbar Space ===`n"
            info .= "Top: " (waTop - top) " pixels`n"
            info .= "Bottom: " (bottom - waBottom) " pixels`n"
            info .= "Left: " (waLeft - left) " pixels`n"
            info .= "Right: " (right - waRight) " pixels"

            MsgBox(info, "Monitor Analysis")
            break
        }
    }
}

; ============================================================================
; Example 3: Multi-Monitor Navigation
; ============================================================================

/**
* Tours all monitors with cursor.
* Moves cursor to center of each monitor.
*
* @description
* Demonstrates multi-monitor cursor control
*/
^F3:: {
    monitorCount := MonitorGetCount()

    ToolTip("Touring " monitorCount " monitor(s)...")
    Sleep(1000)

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        centerX := left + (right - left) // 2
        centerY := top + (bottom - top) // 2

        ToolTip("Monitor " A_Index " of " monitorCount)
        MouseMove(centerX, centerY, 30)
        Sleep(1500)
    }

    ToolTip("Tour complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Cycle cursor through monitor corners
* Visits corners of each monitor
*/
^F4:: {
    monitorCount := MonitorGetCount()

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        ToolTip("Monitor " A_Index " - Top-Left")
        MouseMove(left + 10, top + 10, 25)
        Sleep(600)

        ToolTip("Monitor " A_Index " - Top-Right")
        MouseMove(right - 10, top + 10, 25)
        Sleep(600)

        ToolTip("Monitor " A_Index " - Bottom-Right")
        MouseMove(right - 10, bottom - 10, 25)
        Sleep(600)

        ToolTip("Monitor " A_Index " - Bottom-Left")
        MouseMove(left + 10, bottom - 10, 25)
        Sleep(600)
    }

    ToolTip("Corner tour complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Monitor Boundary Detection
; ============================================================================

/**
* Detects when cursor crosses monitor boundaries.
* Monitors cursor movement between screens.
*
* @description
* Useful for multi-monitor-aware automation
*/
^F5:: {
    global boundaryMonitoring := true
    global lastMonitor := 0

    SetTimer(CheckMonitorBoundary, 100)

    ToolTip("Monitor boundary detection active`nPress Ctrl+F5 to stop")

    CheckMonitorBoundary() {
        if (!boundaryMonitoring)
        return

        MouseGetPos(&x, &y)
        monitorCount := MonitorGetCount()

        currentMonitor := 0

        Loop monitorCount {
            MonitorGet(A_Index, &left, &top, &right, &bottom)

            if (x >= left && x < right && y >= top && y < bottom) {
                currentMonitor := A_Index
                break
            }
        }

        if (currentMonitor != lastMonitor && lastMonitor != 0) {
            ToolTip("Crossed to Monitor " currentMonitor "`nPress Ctrl+F5 to stop")
            SoundBeep(1000, 100)
        } else if (currentMonitor) {
            ToolTip("Monitor " currentMonitor "`nPress Ctrl+F5 to stop")
        }

        lastMonitor := currentMonitor
    }
}

^F5 up:: {
    global boundaryMonitoring := false
    SetTimer(CheckMonitorBoundary, 0)
    ToolTip()
}

; ============================================================================
; Example 5: Monitor-Aware Positioning
; ============================================================================

/**
* Positions cursor at same relative position on each monitor.
* Demonstrates proportional positioning across monitors.
*
* @description
* Maintains relative position across different screen sizes
*/
^F6:: {
    MouseGetPos(&x, &y)

    ; Find current monitor and relative position
    monitorCount := MonitorGetCount()
    relativeX := 0
    relativeY := 0

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        if (x >= left && x < right && y >= top && y < bottom) {
            relativeX := (x - left) / (right - left)
            relativeY := (y - top) / (bottom - top)
            break
        }
    }

    ToolTip("Applying position (" Round(relativeX*100) "%, " Round(relativeY*100) "%) to all monitors...")
    Sleep(1000)

    ; Apply same relative position to all monitors
    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        targetX := left + (right - left) * relativeX
        targetY := top + (bottom - top) * relativeY

        ToolTip("Monitor " A_Index)
        MouseMove(targetX, targetY, 20)
        Sleep(1000)
    }

    ToolTip("Proportional positioning complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 6: Monitor Configuration Analysis
; ============================================================================

/**
* Analyzes monitor arrangement.
* Detects horizontal/vertical monitor layouts.
*
* @description
* Provides detailed multi-monitor configuration info
*/
^F7:: {
    monitorCount := MonitorGetCount()

    if (monitorCount = 1) {
        MsgBox("Single monitor detected", "Monitor Configuration")
        return
    }

    ; Analyze arrangement
    MonitorGet(1, &mon1Left, &mon1Top, &mon1Right, &mon1Bottom)
    MonitorGet(2, &mon2Left, &mon2Top, &mon2Right, &mon2Bottom)

    arrangement := ""

    if (mon2Left >= mon1Right)
    arrangement := "Monitor 2 is RIGHT of Monitor 1"
    else if (mon2Right <= mon1Left)
    arrangement := "Monitor 2 is LEFT of Monitor 1"
    else if (mon2Top >= mon1Bottom)
    arrangement := "Monitor 2 is BELOW Monitor 1"
    else if (mon2Bottom <= mon1Top)
    arrangement := "Monitor 2 is ABOVE Monitor 1"
    else
    arrangement := "Monitors OVERLAP"

    ; Calculate virtual screen bounds
    minLeft := 999999
    minTop := 999999
    maxRight := -999999
    maxBottom := -999999

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        minLeft := Min(minLeft, left)
        minTop := Min(minTop, top)
        maxRight := Max(maxRight, right)
        maxBottom := Max(maxBottom, bottom)
    }

    virtualWidth := maxRight - minLeft
    virtualHeight := maxBottom - minTop

    info := "Monitor Configuration Analysis:`n`n"
    info .= "Monitor Count: " monitorCount "`n"
    info .= "Arrangement: " arrangement "`n`n"
    info .= "Virtual Desktop:`n"
    info .= "  Bounds: " minLeft "," minTop " to " maxRight "," maxBottom "`n"
    info .= "  Size: " virtualWidth "x" virtualHeight

    MsgBox(info, "Configuration Analysis")
}

; ============================================================================
; Example 7: Smart Monitor Snapping
; ============================================================================

/**
* Snaps cursor to nearest monitor edge or center.
* Provides quick navigation within monitor.
*
* @description
* Useful for rapid positioning on large monitors
*/
^F8:: {
    MouseGetPos(&x, &y)

    monitorCount := MonitorGetCount()

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        if (x >= left && x < right && y >= top && y < bottom) {
            ; Calculate distances to edges and center
            centerX := left + (right - left) // 2
            centerY := top + (bottom - top) // 2

            distToLeft := x - left
            distToRight := right - x
            distToTop := y - top
            distToBottom := bottom - y
            distToCenter := Sqrt((x - centerX)**2 + (y - centerY)**2)

            ; Find nearest point
            minDist := Min(distToLeft, distToRight, distToTop, distToBottom, distToCenter)

            if (minDist = distToCenter) {
                ToolTip("Snapping to center...")
                MouseMove(centerX, centerY, 15)
            } else if (minDist = distToLeft) {
                ToolTip("Snapping to left edge...")
                MouseMove(left + 10, y, 15)
            } else if (minDist = distToRight) {
                ToolTip("Snapping to right edge...")
                MouseMove(right - 10, y, 15)
            } else if (minDist = distToTop) {
                ToolTip("Snapping to top edge...")
                MouseMove(x, top + 10, 15)
            } else if (minDist = distToBottom) {
                ToolTip("Snapping to bottom edge...")
                MouseMove(x, bottom - 10, 15)
            }

            Sleep(1000)
            ToolTip()
            break
        }
    }
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Get monitor at coordinates
*
* @param {Number} x - X coordinate
* @param {Number} y - Y coordinate
* @returns {Number} Monitor number (0 if not found)
*/
GetMonitorAt(x, y) {
    monitorCount := MonitorGetCount()

    Loop monitorCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)

        if (x >= left && x < right && y >= top && y < bottom)
        return A_Index
    }

    return 0
}

/**
* Get monitor center
*
* @param {Number} monitorNum - Monitor number
* @returns {Object} {x, y} coordinates
*/
GetMonitorCenter(monitorNum) {
    MonitorGet(monitorNum, &left, &top, &right, &bottom)

    return {
        x: left + (right - left) // 2,
        y: top + (bottom - top) // 2
    }
}

; Test utilities
^F9:: {
    MouseGetPos(&x, &y)
    monNum := GetMonitorAt(x, y)
    MsgBox("Cursor is on Monitor " monNum, "GetMonitorAt Test")
}

^F10:: {
    center := GetMonitorCenter(MonitorGetPrimary())
    MouseMove(center.x, center.y, 25)
    ToolTip("Moved to primary monitor center")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    MouseGetPos - Monitor Coordinates
    ==================================

    F1 - Current monitor info
    F2 - All monitors layout

    Ctrl+F1  - Monitor-relative coordinates
    Ctrl+F2  - Work area vs full monitor
    Ctrl+F3  - Tour all monitors
    Ctrl+F4  - Visit monitor corners
    Ctrl+F5  - Toggle boundary detection
    Ctrl+F6  - Proportional positioning
    Ctrl+F7  - Configuration analysis
    Ctrl+F8  - Smart snap to edge/center
    Ctrl+F9  - GetMonitorAt test
    Ctrl+F10 - Move to primary center

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Monitor Coordinates Help")
}
