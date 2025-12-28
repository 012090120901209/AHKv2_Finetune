#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 MouseGetPos - Hover Detection
 * ============================================================================
 * 
 * Demonstrates hover detection, dwell time tracking, cursor presence monitoring,
 * and hover-based automation triggers.
 * 
 * @module BuiltIn_MouseGetPos_03
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Hover Detection
; ============================================================================

/**
 * Detects when cursor hovers over a specific region.
 * Creates invisible hotspot that triggers when mouse enters.
 * 
 * @example
 * ; Press F1 to start hover detection
 */
F1:: {
    global hoverDetecting := true

    ; Define hover region (top-left corner)
    hotspotLeft := 0
    hotspotTop := 0
    hotspotRight := 200
    hotspotBottom := 200

    SetTimer(CheckHover, 50)

    ToolTip("Hover detection active`nMove cursor to top-left corner`nPress F1 to stop")

    CheckHover() {
        if (!hoverDetecting)
            return

        MouseGetPos(&x, &y)

        if (x >= hotspotLeft && x < hotspotRight && y >= hotspotTop && y < hotspotBottom) {
            ToolTip("HOVERING over hotspot!`nPress F1 to stop")
            SoundBeep(800, 50)
        } else {
            ToolTip("Hover detection active`nMove cursor to top-left corner`nPress F1 to stop")
        }
    }
}

F1 up:: {
    global hoverDetecting := false
    SetTimer(CheckHover, 0)
    ToolTip()
}

/**
 * Multiple hover regions
 * Detects hover over different areas
 */
F2:: {
    global multiHoverActive := true

    ; Define multiple regions
    regions := [{
        name: "Top-Left", left: 0, top: 0, right: 200, bottom: 200 }, {
            name: "Top-Right", left: A_ScreenWidth - 200, top: 0, right: A_ScreenWidth, bottom: 200 }, {
                name: "Center", left: A_ScreenWidth // 2 - 100, top: A_ScreenHeight // 2 - 100, right: A_ScreenWidth // 2 + 100, bottom: A_ScreenHeight // 2 + 100
            }
    ]

    SetTimer(CheckMultiHover, 50)

    ToolTip("Multi-region hover detection active`nPress F2 to stop")

    CheckMultiHover() {
        if (!multiHoverActive)
            return

        MouseGetPos(&x, &y)

        foundRegion := false

        for region in regions {
            if (x >= region.left && x < region.right && y >= region.top && y < region.bottom) {
                ToolTip("Hovering: " region.name "`nPress F2 to stop")
                foundRegion := true
                break
            }
        }

        if (!foundRegion)
            ToolTip("Not hovering any region`nPress F2 to stop")
    }
}

F2 up:: {
    global multiHoverActive := false
    SetTimer(CheckMultiHover, 0)
    ToolTip()
}

; ============================================================================
; Example 2: Dwell Time Detection
; ============================================================================

/**
 * Triggers action after cursor dwells for specified time.
 * Detects how long cursor stays in one place.
 * 
 * @description
 * Useful for hover-activated menus or tooltips
 */
^F1:: {
    global dwellDetecting := true
    global dwellStartTime := 0
    global dwellX := 0
    global dwellY := 0

    dwellThreshold := 1000  ; 1 second
    moveThreshold := 10     ; 10 pixel movement tolerance

    SetTimer(CheckDwell, 50)

    ToolTip("Dwell detection active`nHold cursor still for 1 second`nPress Ctrl+F1 to stop")

    CheckDwell() {
        if (!dwellDetecting)
            return

        MouseGetPos(&x, &y)

        ; Check if cursor moved significantly
        if (dwellStartTime > 0) {
            distance := Sqrt((x - dwellX) ** 2 + (y - dwellY) ** 2)

            if (distance > moveThreshold) {
                ; Cursor moved, reset dwell timer
                dwellStartTime := A_TickCount
                dwellX := x
                dwellY := y
                ToolTip("Dwell detection active`nHold cursor still for 1 second`nPress Ctrl+F1 to stop")
            } else {
                ; Check if dwell time exceeded
                dwellTime := A_TickCount - dwellStartTime

                if (dwellTime >= dwellThreshold) {
                    ToolTip("DWELL DETECTED!`nDwell time: " dwellTime "ms`nPress Ctrl+F1 to stop")
                    SoundBeep(1000, 100)

                    ; Reset to avoid repeated triggers
                    dwellStartTime := A_TickCount
                } else {
                    ToolTip("Dwelling... " dwellTime "ms / " dwellThreshold "ms`nPress Ctrl+F1 to stop")
                }
            }
        } else {
            ; Initialize dwell tracking
            dwellStartTime := A_TickCount
            dwellX := x
            dwellY := y
        }
    }
}

^F1 up:: {
    global dwellDetecting := false
    SetTimer(CheckDwell, 0)
    ToolTip()
}

/**
 * Progressive dwell actions
 * Different actions at different dwell times
 */
^F2:: {
    global progressiveDwell := true
    global startTime := A_TickCount
    global startX := 0
    global startY := 0
    global level := 0

    SetTimer(CheckProgressiveDwell, 50)

    ToolTip("Progressive dwell active`nHold still for increasing effects`nPress Ctrl+F2 to stop")

    CheckProgressiveDwell() {
        if (!progressiveDwell)
            return

        MouseGetPos(&x, &y)

        if (startX = 0) {
            startX := x
            startY := y
            startTime := A_TickCount
            level := 0
        }

        distance := Sqrt((x - startX) ** 2 + (y - startY) ** 2)

        if (distance > 15) {
            ; Reset on movement
            startX := x
            startY := y
            startTime := A_TickCount
            level := 0
            ToolTip("Progressive dwell active`nHold still for increasing effects`nPress Ctrl+F2 to stop")
        } else {
            elapsed := A_TickCount - startTime

            newLevel := 0
            if (elapsed >= 3000)
                newLevel := 3
            else if (elapsed >= 2000)
                newLevel := 2
            else if (elapsed >= 1000)
                newLevel := 1

            if (newLevel > level) {
                level := newLevel
                ToolTip("Level " level " activated!`nPress Ctrl+F2 to stop")
                SoundBeep(500 + level * 200, 100)
            } else {
                ToolTip("Dwell time: " elapsed "ms | Level: " level "`nPress Ctrl+F2 to stop")
            }
        }
    }
}

^F2 up:: {
    global progressiveDwell := false
    SetTimer(CheckProgressiveDwell, 0)
    ToolTip()
}

; ============================================================================
; Example 3: Hover-Activated Tooltips
; ============================================================================

/**
 * Shows tooltips when hovering over specific areas.
 * Simulates hover help system.
 * 
 * @description
 * Creates interactive hover-based information display
 */
^F3:: {
    global tooltipHovering := true

    ; Define help regions
    helpRegions := [{
        left: 100, top: 100, right: 300, bottom: 200, text: "Region 1: File Operations`nClick here for file management" }, {
            left: 350, top: 100, right: 550, bottom: 200, text: "Region 2: Edit Tools`nClick here for editing options" }, {
                left: 600, top: 100, right: 800, bottom: 200, text: "Region 3: View Settings`nClick here for display options"
            }
    ]

    SetTimer(ShowHoverTooltip, 100)

    ToolTip("Hover tooltip system active`nMove cursor over regions`nPress Ctrl+F3 to stop")
    Sleep(2000)

    ShowHoverTooltip() {
        if (!tooltipHovering)
            return

        MouseGetPos(&x, &y)

        found := false

        for region in helpRegions {
            if (x >= region.left && x < region.right && y >= region.top && y < region.bottom) {
                ToolTip(region.text "`n`nPress Ctrl+F3 to stop")
                found := true
                break
            }
        }

        if (!found)
            ToolTip("Hover over regions for information`nPress Ctrl+F3 to stop")
    }
}

^F3 up:: {
    global tooltipHovering := false
    SetTimer(ShowHoverTooltip, 0)
    ToolTip()
}

; ============================================================================
; Example 4: Window Hover Detection
; ============================================================================

/**
 * Detects which window cursor is hovering over.
 * Tracks window changes as cursor moves.
 * 
 * @description
 * Useful for window-specific automation triggers
 */
^F4:: {
    global windowHovering := true
    global lastWindowID := 0

    SetTimer(CheckWindowHover, 100)

    ToolTip("Window hover detection active`nPress Ctrl+F4 to stop")

    CheckWindowHover() {
        if (!windowHovering)
            return

        MouseGetPos(, , &winID)

        if (winID) {
            if (winID != lastWindowID) {
                ; Window changed
                title := WinGetTitle("ahk_id " winID)
                class := WinGetClass("ahk_id " winID)
                process := WinGetProcessName("ahk_id " winID)

                ToolTip("Hovering Window:`n" title "`n`nClass: " class "`nProcess: " process "`n`nPress Ctrl+F4 to stop")

                lastWindowID := winID
            }
        } else {
            ToolTip("No window under cursor`nPress Ctrl+F4 to stop")
            lastWindowID := 0
        }
    }
}

^F4 up:: {
    global windowHovering := false
    SetTimer(CheckWindowHover, 0)
    ToolTip()
}

/**
 * Control hover detection
 * Identifies UI controls under cursor
 */
^F5:: {
    global controlHovering := true
    global lastControl := ""

    SetTimer(CheckControlHover, 100)

    ToolTip("Control hover detection active`nPress Ctrl+F5 to stop")

    CheckControlHover() {
        if (!controlHovering)
            return

        MouseGetPos(, , &winID, &control)

        if (control) {
            if (control != lastControl) {
                controlText := ""
                try {
                    controlText := ControlGetText(control, "ahk_id " winID)
                }

                info := "Control: " control "`n"
                if (controlText)
                    info .= "Text: " controlText "`n"
                info .= "`nPress Ctrl+F5 to stop"

                ToolTip(info)

                lastControl := control
            }
        } else {
            ToolTip("No control under cursor`nPress Ctrl+F5 to stop")
            lastControl := ""
        }
    }
}

^F5 up:: {
    global controlHovering := false
    SetTimer(CheckControlHover, 0)
    ToolTip()
}

; ============================================================================
; Example 5: Hover-Based Menu Activation
; ============================================================================

/**
 * Activates menu when hovering at screen edge.
 * Creates edge-activated context menu.
 * 
 * @description
 * Simulates hot corners or edge triggers
 */
^F6:: {
    global edgeMenuActive := true

    SetTimer(CheckEdgeHover, 50)

    ToolTip("Edge menu system active`nHover at screen edges`nPress Ctrl+F6 to stop")

    CheckEdgeHover() {
        if (!edgeMenuActive)
            return

        MouseGetPos(&x, &y)

        edgeThreshold := 5
        message := ""

        if (x < edgeThreshold)
            message := "Left Edge Menu Available"
        else if (x > A_ScreenWidth - edgeThreshold)
            message := "Right Edge Menu Available"
        else if (y < edgeThreshold)
            message := "Top Edge Menu Available"
        else if (y > A_ScreenHeight - edgeThreshold)
            message := "Bottom Edge Menu Available"

        if (message)
            ToolTip(message "`nClick for menu`nPress Ctrl+F6 to stop")
        else
            ToolTip("Edge menu system active`nHover at screen edges`nPress Ctrl+F6 to stop")
    }
}

^F6 up:: {
    global edgeMenuActive := false
    SetTimer(CheckEdgeHover, 0)
    ToolTip()
}

; ============================================================================
; Example 6: Pixel Color Hover Detection
; ============================================================================

/**
 * Detects hover based on pixel color under cursor.
 * Shows color information in real-time.
 * 
 * @description
 * Useful for graphics work or color-based automation
 */
^F7:: {
    global colorDetecting := true

    SetTimer(ShowColorInfo, 100)

    ToolTip("Color detection active`nPress Ctrl+F7 to stop")

    ShowColorInfo() {
        if (!colorDetecting)
            return

        MouseGetPos(&x, &y)
        color := PixelGetColor(x, y)

        ; Convert to RGB
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        info := "Pixel Color at (" x ", " y "):`n`n"
        info .= "Hex: " Format("0x{:06X}", color) "`n"
        info .= "RGB: " r ", " g ", " b "`n`n"
        info .= "Press Ctrl+F7 to stop"

        ToolTip(info)
    }
}

^F7 up:: {
    global colorDetecting := false
    SetTimer(ShowColorInfo, 0)
    ToolTip()
}

/**
 * Hover detection on specific color
 * Triggers when cursor is over certain color
 */
^F8:: {
    global colorMatchDetecting := true

    ; Target color (white)
    targetColor := 0xFFFFFF
    tolerance := 30

    SetTimer(CheckColorMatch, 100)

    ToolTip("Color match detection active`nLooking for white pixels`nPress Ctrl+F8 to stop")

    CheckColorMatch() {
        if (!colorMatchDetecting)
            return

        MouseGetPos(&x, &y)
        color := PixelGetColor(x, y)

        ; Extract RGB components
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        targetR := (targetColor >> 16) & 0xFF
        targetG := (targetColor >> 8) & 0xFF
        targetB := targetColor & 0xFF

        ; Calculate color distance
        distance := Sqrt((r - targetR) ** 2 + (g - targetG) ** 2 + (b - targetB) ** 2)

        if (distance <= tolerance) {
            ToolTip("WHITE DETECTED!`nColor: " Format("0x{:06X}", color) "`nPress Ctrl+F8 to stop")
            SoundBeep(1200, 50)
        } else {
            ToolTip("Searching for white...`nCurrent: " Format("0x{:06X}", color) "`nPress Ctrl+F8 to stop")
        }
    }
}

^F8 up:: {
    global colorMatchDetecting := false
    SetTimer(CheckColorMatch, 0)
    ToolTip()
}

; ============================================================================
; Example 7: Hover Analytics
; ============================================================================

/**
 * Tracks and analyzes hover patterns.
 * Records hover time in different screen regions.
 * 
 * @description
 * Useful for UI/UX analysis
 */
^F9:: {
    global analyticsActive := true
    global hoverData := Map()

    ; Define regions to track
    regions := ["TopLeft", "TopRight", "BottomLeft", "BottomRight", "Center"]

    for region in regions
        hoverData[region] := 0

    startTime := A_TickCount

    SetTimer(TrackHover, 100)

    ToolTip("Hover analytics started`nMove cursor around`nPress Ctrl+F9 to see results")

    TrackHover() {
        if (!analyticsActive)
            return

        MouseGetPos(&x, &y)

        centerX := A_ScreenWidth // 2
        centerY := A_ScreenHeight // 2

        region := ""

        ; Determine region
        if (x < centerX - 100 && y < centerY - 100)
            region := "TopLeft"
        else if (x > centerX + 100 && y < centerY - 100)
            region := "TopRight"
        else if (x < centerX - 100 && y > centerY + 100)
            region := "BottomLeft"
        else if (x > centerX + 100 && y > centerY + 100)
            region := "BottomRight"
        else
            region := "Center"

        hoverData[region] += 100  ; Add 100ms

        ToolTip("Tracking hover patterns...`nPress Ctrl+F9 to see results")
    }
}

^F9 up:: {
    global analyticsActive := false
    SetTimer(TrackHover, 0)

    ; Calculate results
    total := 0
    for region, time in hoverData
        total += time

    results := "Hover Analytics Results:`n`n"

    for region, time in hoverData {
        percentage := total > 0 ? Round((time / total) * 100, 1) : 0
        results .= region ": " (time / 1000) "s (" percentage "%)`n"
    }

    results .= "`nTotal time: " (total / 1000) "s"

    MsgBox(results, "Hover Analytics")
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Check if cursor is in region
 * 
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @param {Object} region - {left, top, right, bottom}
 * @returns {Boolean}
 */
IsInRegion(x, y, region) {
    return (x >= region.left && x < region.right && y >= region.top && y < region.bottom)
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc:: ExitApp()

F12:: {
    helpText := "
                    (
                    MouseGetPos - Hover Detection
                    ==============================

                    F1 - Basic hover detection
                    F2 - Multi-region hover

                    Ctrl+F1 - Dwell time detection
                    Ctrl+F2 - Progressive dwell
                    Ctrl+F3 - Hover tooltips
                    Ctrl+F4 - Window hover detection
                    Ctrl+F5 - Control hover detection
                    Ctrl+F6 - Edge menu activation
                    Ctrl+F7 - Pixel color info
                    Ctrl+F8 - Color match detection
                    Ctrl+F9 - Hover analytics

                    F12 - Show this help
                    ESC - Exit script
                    )"

    MsgBox(helpText, "Hover Detection Help")
}
