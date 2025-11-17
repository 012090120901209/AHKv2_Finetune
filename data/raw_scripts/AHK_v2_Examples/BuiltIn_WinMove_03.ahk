#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * WinMove Examples - Part 3: Snap to Grid
 * ============================================================================
 *
 * This script demonstrates grid-based window positioning and snapping.
 * Professional window organization and tiling capabilities.
 *
 * @description Grid and snap window positioning
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Snap to Screen Edges
; ============================================================================

/**
 * Snaps window to nearest screen edge
 *
 * @hotkey F1 - Snap to edge
 */
F1:: {
    SnapToEdge()
}

SnapToEdge() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }
    
    WinGetPos(&x, &y, &w, &h, "A")
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)
    
    ; Calculate distances to edges
    distLeft := x - left
    distRight := (right - w) - x
    distTop := y - top
    distBottom := (bottom - h) - y
    
    ; Find minimum distance
    minDist := Min(distLeft, distRight, distTop, distBottom)
    
    ; Snap to closest edge
    if (minDist = distLeft) {
        WinMove(left, y, , , "A")
        ToolTip("Snapped to LEFT edge")
    } else if (minDist = distRight) {
        WinMove(right - w, y, , , "A")
        ToolTip("Snapped to RIGHT edge")
    } else if (minDist = distTop) {
        WinMove(x, top, , , "A")
        ToolTip("Snapped to TOP edge")
    } else {
        WinMove(x, bottom - h, , , "A")
        ToolTip("Snapped to BOTTOM edge")
    }
    
    SetTimer(() => ToolTip(), -1500)
}

; ============================================================================
; Example 2: Grid Layout System
; ============================================================================

/**
 * Positions windows on a grid
 *
 * @hotkey F2 - Grid layout
 */
F2:: {
    GridLayout()
}

GridLayout() {
    static gridGui := ""
    
    if gridGui {
        try gridGui.Destroy()
    }
    
    gridGui := Gui("+AlwaysOnTop", "Grid Layout")
    gridGui.SetFont("s10", "Segoe UI")
    
    gridGui.Add("Text", "w300", "Grid columns:")
    colSlider := gridGui.Add("Slider", "w300 vCols Range2-6 ToolTip", 3)
    colText := gridGui.Add("Text", "w300 vColText", "3 columns")
    
    gridGui.Add("Text", "w300", "Grid rows:")
    rowSlider := gridGui.Add("Slider", "w300 vRows Range2-6 ToolTip", 2)
    rowText := gridGui.Add("Text", "w300 vRowText", "2 rows")
    
    colSlider.OnEvent("Change", (*) => colText.Value := colSlider.Value " columns")
    rowSlider.OnEvent("Change", (*) => rowText.Value := rowSlider.Value " rows")
    
    gridGui.Add("Button", "w145 Default", "Apply").OnEvent("Click", Apply)
    gridGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => gridGui.Destroy())
    
    gridGui.Show()
    
    Apply(*) {
        submitted := gridGui.Submit()
        
        MonitorGetWorkArea(1, &left, &top, &right, &bottom)
        
        cols := submitted.Cols
        rows := submitted.Rows
        
        cellW := (right - left) // cols
        cellH := (bottom - top) // rows
        
        allWindows := WinGetList()
        winIdx := 0
        
        Loop rows {
            row := A_Index - 1
            Loop cols {
                col := A_Index - 1
                
                if (winIdx >= allWindows.Length) {
                    break 2
                }
                
                hwnd := allWindows[winIdx + 1]
                
                try {
                    title := WinGetTitle(hwnd)
                    if title != "" {
                        x := left + (col * cellW)
                        y := top + (row * cellH)
                        WinMove(x, y, cellW, cellH, hwnd)
                        winIdx++
                    }
                }
            }
        }
        
        gridGui.Destroy()
        MsgBox("Arranged " winIdx " windows in " cols "x" rows " grid.", "Success", 64)
    }
}

; ============================================================================
; Example 3: Magnetic Window Edges
; ============================================================================

/**
 * Enables magnetic snapping to other windows
 *
 * @hotkey F3 - Toggle magnetic edges
 */
F3:: {
    static magneticActive := false
    
    if !magneticActive {
        magneticActive := true
        StartMagnetic()
        ToolTip("Magnetic edges ENABLED")
    } else {
        magneticActive := false
        StopMagnetic()
        ToolTip("Magnetic edges DISABLED")
    }
    
    SetTimer(() => ToolTip(), -1500)
}

global magneticTimer := 0

StartMagnetic() {
    global magneticTimer
    magneticTimer := SetTimer(CheckMagnetic, 100)
}

StopMagnetic() {
    global magneticTimer
    if magneticTimer {
        SetTimer(magneticTimer, 0)
    }
}

CheckMagnetic() {
    ; Placeholder for magnetic window detection
    ; This would check window positions and snap nearby windows
}

; ============================================================================
; Example 4: Window Tiling Manager
; ============================================================================

/**
 * Professional tiling window manager
 *
 * @hotkey F4 - Tiling manager
 */
F4:: {
    TilingManager()
}

TilingManager() {
    static tileGui := ""
    
    if tileGui {
        try tileGui.Destroy()
    }
    
    tileGui := Gui("+AlwaysOnTop", "Tiling Manager")
    tileGui.SetFont("s10", "Segoe UI")
    
    tileGui.Add("Text", "w350", "Select tiling pattern:")
    
    patterns := [
        "Two Columns (50/50)",
        "Three Columns (33/33/33)",
        "Main + Sidebar (70/30)",
        "Sidebar + Main (30/70)",
        "Top + Bottom (50/50)",
        "Main + Two Sidebar (50/25/25)"
    ]
    
    patternList := tileGui.Add("ListBox", "w350 h140 vPattern")
    patternList.Add(patterns)
    patternList.Choose(1)
    
    tileGui.Add("Button", "w170 Default", "Apply").OnEvent("Click", Apply)
    tileGui.Add("Button", "w170 x+10 yp", "Cancel").OnEvent("Click", (*) => tileGui.Destroy())
    
    tileGui.Show()
    
    Apply(*) {
        submitted := tileGui.Submit()
        
        MonitorGetWorkArea(1, &left, &top, &right, &bottom)
        w := right - left
        h := bottom - top
        
        allWindows := WinGetList()
        visibleWindows := []
        
        for hwnd in allWindows {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    visibleWindows.Push(hwnd)
                }
            }
        }
        
        switch submitted.Pattern {
            case 1:  ; Two Columns
                if visibleWindows.Length >= 1 {
                    WinMove(left, top, w//2, h, visibleWindows[1])
                }
                if visibleWindows.Length >= 2 {
                    WinMove(left + w//2, top, w//2, h, visibleWindows[2])
                }
            
            case 2:  ; Three Columns
                colW := w // 3
                if visibleWindows.Length >= 1 {
                    WinMove(left, top, colW, h, visibleWindows[1])
                }
                if visibleWindows.Length >= 2 {
                    WinMove(left + colW, top, colW, h, visibleWindows[2])
                }
                if visibleWindows.Length >= 3 {
                    WinMove(left + colW*2, top, colW, h, visibleWindows[3])
                }
            
            case 3:  ; Main + Sidebar (70/30)
                if visibleWindows.Length >= 1 {
                    WinMove(left, top, Round(w*0.7), h, visibleWindows[1])
                }
                if visibleWindows.Length >= 2 {
                    WinMove(left + Round(w*0.7), top, Round(w*0.3), h, visibleWindows[2])
                }
        }
        
        tileGui.Destroy()
        MsgBox("Applied tiling pattern.", "Success", 64)
    }
}

; ============================================================================
; Example 5: Custom Grid Snapping
; ============================================================================

/**
 * Snaps window to custom grid positions
 *
 * @hotkey F5 - Custom grid snap
 */
F5:: {
    CustomGridSnap()
}

CustomGridSnap() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }
    
    static snapGui := ""
    
    if snapGui {
        try snapGui.Destroy()
    }
    
    snapGui := Gui("+AlwaysOnTop", "Grid Snap")
    snapGui.SetFont("s10", "Segoe UI")
    
    snapGui.Add("Text", "w300", "Grid cell size (pixels):")
    gridEdit := snapGui.Add("Edit", "w300 vGridSize Number", "100")
    
    snapGui.Add("Text", "w300", "Snap position:")
    snapGui.Add("Button", "w145 Default", "Snap Window").OnEvent("Click", Snap)
    snapGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => snapGui.Destroy())
    
    snapGui.Show()
    
    Snap(*) {
        submitted := snapGui.Submit()
        gridSize := Integer(submitted.GridSize)
        
        WinGetPos(&x, &y, , , "A")
        
        ; Snap to nearest grid point
        newX := Round(x / gridSize) * gridSize
        newY := Round(y / gridSize) * gridSize
        
        WinMove(newX, newY, , , "A")
        
        snapGui.Destroy()
        ToolTip("Snapped to grid: " newX ", " newY)
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 6: Window Zones
; ============================================================================

/**
 * Divides screen into zones for quick window placement
 *
 * @hotkey F6 - Show zones
 */
F6:: {
    ShowZones()
}

ShowZones() {
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)
    
    ; Create zone overlay (simplified)
    zoneText := "
    (
    Screen Zones:
    
    [1] [2] [3]
    [4] [5] [6]
    [7] [8] [9]
    
    Number keys to place window in zone
    Esc to cancel
    )"
    
    MsgBox(zoneText, "Window Zones", 64)
}

; Hotkeys for zones 1-9
^NumPad1::PlaceInZone(7)
^NumPad2::PlaceInZone(8)
^NumPad3::PlaceInZone(9)
^NumPad4::PlaceInZone(4)
^NumPad5::PlaceInZone(5)
^NumPad6::PlaceInZone(6)
^NumPad7::PlaceInZone(1)
^NumPad8::PlaceInZone(2)
^NumPad9::PlaceInZone(3)

PlaceInZone(zone) {
    if !WinExist("A") {
        return
    }
    
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)
    
    w := (right - left) // 3
    h := (bottom - top) // 3
    
    row := (zone - 1) // 3
    col := Mod(zone - 1, 3)
    
    x := left + (col * w)
    y := top + (row * h)
    
    WinMove(x, y, w, h, "A")
    ToolTip("Placed in zone " zone)
    SetTimer(() => ToolTip(), -1000)
}

; ============================================================================
; Example 7: Smart Window Arrangement
; ============================================================================

/**
 * Automatically arranges windows intelligently
 *
 * @hotkey F7 - Smart arrange
 */
F7:: {
    SmartArrange()
}

SmartArrange() {
    allWindows := WinGetList()
    visibleWindows := []
    
    for hwnd in allWindows {
        try {
            title := WinGetTitle(hwnd)
            if title != "" {
                visibleWindows.Push(hwnd)
            }
        }
    }
    
    count := visibleWindows.Length
    
    if count = 0 {
        MsgBox("No windows to arrange.", "Info", 64)
        return
    }
    
    MonitorGetWorkArea(1, &left, &top, &right, &bottom)
    screenW := right - left
    screenH := bottom - top
    
    ; Determine best layout
    if count = 1 {
        ; Maximize single window
        WinMove(left, top, screenW, screenH, visibleWindows[1])
    } else if count = 2 {
        ; Side by side
        WinMove(left, top, screenW//2, screenH, visibleWindows[1])
        WinMove(left + screenW//2, top, screenW//2, screenH, visibleWindows[2])
    } else if count = 3 {
        ; One large, two stacked
        WinMove(left, top, screenW//2, screenH, visibleWindows[1])
        WinMove(left + screenW//2, top, screenW//2, screenH//2, visibleWindows[2])
        WinMove(left + screenW//2, top + screenH//2, screenW//2, screenH//2, visibleWindows[3])
    } else {
        ; Grid layout
        cols := Ceil(Sqrt(count))
        rows := Ceil(count / cols)
        
        cellW := screenW // cols
        cellH := screenH // rows
        
        idx := 0
        Loop rows {
            row := A_Index - 1
            Loop cols {
                col := A_Index - 1
                if idx >= count {
                    break 2
                }
                WinMove(left + col*cellW, top + row*cellH, cellW, cellH, visibleWindows[++idx])
            }
        }
    }
    
    MsgBox("Arranged " count " windows intelligently.", "Success", 64)
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc::ExitApp()

^F1:: {
    help := "
    (
    WinMove Examples - Part 3 (Snap to Grid)
    =========================================

    Hotkeys:
    F1 - Snap to nearest edge
    F2 - Grid layout system
    F3 - Toggle magnetic edges
    F4 - Tiling manager
    F5 - Custom grid snapping
    F6 - Show window zones
    F7 - Smart auto-arrange
    Ctrl+NumPad1-9 - Place in zone
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
