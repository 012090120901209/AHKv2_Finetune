#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 MouseGetPos Function - Get Position
 * ============================================================================
 * 
 * The MouseGetPos function retrieves the current mouse cursor position and
 * optionally the window/control under the cursor. Essential for position-based
 * automation and cursor tracking.
 * 
 * Syntax: MouseGetPos([&OutputVarX, &OutputVarY, &OutputVarWin, &OutputVarControl, Flag])
 * 
 * @module BuiltIn_MouseGetPos_01
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Position Retrieval
; ============================================================================

/**
 * Gets current cursor coordinates.
 * Demonstrates basic X, Y position retrieval.
 * 
 * @example
 * ; Press F1 to show current mouse position
 */
F1:: {
    MouseGetPos(&xPos, &yPos)
    ToolTip("Mouse Position:`nX: " xPos "`nY: " yPos)
    Sleep(2000)
    ToolTip()
}

/**
 * Continuous position display
 * Shows real-time cursor coordinates
 */
F2:: {
    global tracking := true

    SetTimer(ShowPosition, 100)

    ToolTip("Position tracking active (Press F2 again to stop)")

    ShowPosition() {
        if (!tracking)
            return

        MouseGetPos(&x, &y)
        ToolTip("X: " x " | Y: " y "`nPress F2 to stop")
    }
}

; Stop tracking
F2 up:: {
    global tracking := false
    SetTimer(ShowPosition, 0)
    ToolTip()
}

/**
 * Position in different coordinate modes
 * Shows how CoordMode affects returned values
 */
F3:: {
    ; Screen coordinates
    CoordMode("Mouse", "Screen")
    MouseGetPos(&screenX, &screenY)

    ; Window coordinates (if window exists)
    if WinExist("A") {
        CoordMode("Mouse", "Window")
        MouseGetPos(&windowX, &windowY)

        CoordMode("Mouse", "Client")
        MouseGetPos(&clientX, &clientY)

        result := "Mouse Position:`n`n"
        result .= "Screen:  X=" screenX ", Y=" screenY "`n"
        result .= "Window:  X=" windowX ", Y=" windowY "`n"
        result .= "Client:  X=" clientX ", Y=" clientY

        MsgBox(result, "Coordinate Modes")

        CoordMode("Mouse", "Screen")
    }
}

; ============================================================================
; Example 2: Window and Control Detection
; ============================================================================

/**
 * Gets window under cursor.
 * Retrieves window ID and title.
 * 
 * @description
 * Useful for window-specific automation
 */
^F1:: {
    MouseGetPos(, , &winID)

    if (winID) {
        winTitle := WinGetTitle("ahk_id " winID)
        winClass := WinGetClass("ahk_id " winID)
        winProcess := WinGetProcessName("ahk_id " winID)

        info := "Window Under Cursor:`n`n"
        info .= "Title: " winTitle "`n"
        info .= "Class: " winClass "`n"
        info .= "Process: " winProcess "`n"
        info .= "ID: " winID

        MsgBox(info, "Window Information")
    } else {
        MsgBox("No window under cursor", "Window Information")
    }
}

/**
 * Gets control under cursor
 * Identifies specific UI control
 */
^F2:: {
    MouseGetPos(&x, &y, &winID, &control)

    if (control) {
        controlClass := ""
        try {
            controlClass := ControlGetClassNN(control, "ahk_id " winID)
        }

        info := "Control Under Cursor:`n`n"
        info .= "Control: " control "`n"
        info .= "Class: " (controlClass ? controlClass : "N/A") "`n"
        info .= "Position: X=" x ", Y=" y "`n"
        info .= "Window ID: " winID

        MsgBox(info, "Control Information")
    } else {
        MsgBox("No control under cursor", "Control Information")
    }
}

/**
 * Complete cursor information
 * Gets all available data at once
 */
^F3:: {
    MouseGetPos(&x, &y, &winID, &control, 1)  ; Flag=1 for child window

    info := "Complete Cursor Information:`n`n"
    info .= "=== Position ===`n"
    info .= "X: " x "`n"
    info .= "Y: " y "`n`n"

    if (winID) {
        info .= "=== Window ===`n"
        info .= "Title: " WinGetTitle("ahk_id " winID) "`n"
        info .= "Class: " WinGetClass("ahk_id " winID) "`n"
        info .= "ID: " winID "`n`n"
    }

    if (control) {
        info .= "=== Control ===`n"
        info .= "Control: " control "`n"
    }

    MsgBox(info, "Complete Information")
}

; ============================================================================
; Example 3: Position-Based Automation
; ============================================================================

/**
 * Click at saved position.
 * Saves current position and clicks there later.
 * 
 * @description
 * Demonstrates position memory for automation
 */
^F4:: {
    static savedX := 0
    static savedY := 0

    if (savedX = 0) {
        ; Save position
        MouseGetPos(&savedX, &savedY)
        ToolTip("Position saved: X=" savedX ", Y=" savedY "`n`nPress Ctrl+F4 again to click there")
        Sleep(2000)
        ToolTip()
    } else {
        ; Click saved position
        ToolTip("Clicking saved position...")
        Click(savedX, savedY)
        Sleep(1000)
        ToolTip()

        ; Reset
        savedX := 0
        savedY := 0
    }
}

/**
 * Record and replay mouse path
 * Captures positions over time and replays
 */
^F5:: {
    static recording := false
    static positions := []

    if (!recording) {
        ; Start recording
        positions := []
        recording := true

        ToolTip("Recording mouse path...`nPress Ctrl+F5 to stop and replay")

        SetTimer(RecordPosition, 50)

        RecordPosition() {
            if (!recording) {
                SetTimer(RecordPosition, 0)
                return
            }

            MouseGetPos(&x, &y)
            positions.Push({ x: x, y: y, time: A_TickCount })
        }
    } else {
        ; Stop recording and replay
        recording := false
        SetTimer(RecordPosition, 0)

        if (positions.Length > 0) {
            ToolTip("Replaying path (" positions.Length " points)...")
            Sleep(1000)

            ; Replay recorded positions
            startTime := A_TickCount
            for index, pos in positions {
                if (index = 1)
                    continue

                ; Calculate delay
                delay := positions[index].time - positions[index - 1].time

                MouseMove(pos.x, pos.y, 0)
                Sleep(delay)
            }

            ToolTip("Replay complete!")
            Sleep(1000)
            ToolTip()
        }

        positions := []
    }
}

; ============================================================================
; Example 4: Distance and Angle Calculations
; ============================================================================

/**
 * Calculates distance from screen center.
 * Shows how far cursor is from center point.
 * 
 * @description
 * Demonstrates mathematical operations with position
 */
^F6:: {
    MouseGetPos(&x, &y)

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2

    ; Calculate distance using Pythagorean theorem
    deltaX := x - centerX
    deltaY := y - centerY
    distance := Sqrt(deltaX ** 2 + deltaY ** 2)

    ; Calculate angle
    angle := ATan(deltaY / deltaX) * 180 / 3.14159
    if (deltaX < 0)
        angle += 180

    info := "Distance from Screen Center:`n`n"
    info .= "Current: X=" x ", Y=" y "`n"
    info .= "Center: X=" centerX ", Y=" centerY "`n`n"
    info .= "Distance: " Round(distance, 2) " pixels`n"
    info .= "Angle: " Round(angle, 2) "°"

    MsgBox(info, "Position Analysis")
}

/**
 * Monitor cursor boundaries
 * Alerts when cursor approaches screen edges
 */
^F7:: {
    global monitoring := true

    SetTimer(CheckBoundaries, 100)

    ToolTip("Boundary monitoring active (Press Ctrl+F7 to stop)")

    CheckBoundaries() {
        if (!monitoring)
            return

        MouseGetPos(&x, &y)

        margin := 50
        warnings := []

        if (x < margin)
            warnings.Push("Left edge")
        if (x > A_ScreenWidth - margin)
            warnings.Push("Right edge")
        if (y < margin)
            warnings.Push("Top edge")
        if (y > A_ScreenHeight - margin)
            warnings.Push("Bottom edge")

        if (warnings.Length > 0) {
            msg := "WARNING: Near "
            for index, warning in warnings {
                msg .= warning
                if (index < warnings.Length)
                    msg .= ", "
            }
            ToolTip(msg "`n`nPress Ctrl+F7 to stop")
        } else {
            ToolTip("Position: X=" x ", Y=" y "`nPress Ctrl+F7 to stop")
        }
    }
}

^F7 up:: {
    global monitoring := false
    SetTimer(CheckBoundaries, 0)
    ToolTip()
}

; ============================================================================
; Example 5: Position Logger
; ============================================================================

/**
 * Logs cursor positions to array.
 * Creates detailed position log with timestamps.
 * 
 * @description
 * Useful for analyzing cursor movement patterns
 */
^F8:: {
    static log := []
    static logging := false

    if (!logging) {
        log := []
        logging := true
        startTime := A_TickCount

        SetTimer(LogPosition, 200)

        ToolTip("Position logging started...`nPress Ctrl+F8 to stop and view log")

        LogPosition() {
            if (!logging) {
                SetTimer(LogPosition, 0)
                return
            }

            MouseGetPos(&x, &y, &winID)

            log.Push({
                time: A_TickCount - startTime,
                x: x,
                y: y,
                window: winID
            })
        }
    } else {
        logging := false
        SetTimer(LogPosition, 0)
        ToolTip()

        if (log.Length > 0) {
            ; Display log summary
            logText := "Position Log (" log.Length " entries):`n`n"
            logText .= "Time(ms) | X    | Y    | Window`n"
            logText .= "---------|------|------|--------`n"

            ; Show first 10 entries
            maxShow := Min(10, log.Length)
            for index, entry in log {
                if (index > maxShow)
                    break

                logText .= Format("{:8} | {:4} | {:4} | {:6}`n",
                    entry.time, entry.x, entry.y, entry.window)
            }

            if (log.Length > maxShow)
                logText .= "`n... and " (log.Length - maxShow) " more entries"

            MsgBox(logText, "Position Log")
        }

        log := []
    }
}

; ============================================================================
; Example 6: Quadrant Detection
; ============================================================================

/**
 * Detects which screen quadrant cursor is in.
 * Divides screen into 4 sections.
 * 
 * @description
 * Useful for region-based automation
 */
^F9:: {
    MouseGetPos(&x, &y)

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2

    ; Determine quadrant
    if (x < centerX && y < centerY)
        quadrant := "Top-Left"
    else if (x >= centerX && y < centerY)
        quadrant := "Top-Right"
    else if (x < centerX && y >= centerY)
        quadrant := "Bottom-Left"
    else
        quadrant := "Bottom-Right"

    ; Calculate percentages
    percentX := Round((x / A_ScreenWidth) * 100, 1)
    percentY := Round((y / A_ScreenHeight) * 100, 1)

    info := "Screen Quadrant Analysis:`n`n"
    info .= "Quadrant: " quadrant "`n`n"
    info .= "Position: X=" x ", Y=" y "`n"
    info .= "Screen %: X=" percentX "%, Y=" percentY "%`n"
    info .= "Screen Size: " A_ScreenWidth "x" A_ScreenHeight

    MsgBox(info, "Quadrant Detection")
}

; ============================================================================
; Example 7: Position-Based Hotkeys
; ============================================================================

/**
 * Different actions based on cursor position.
 * Executes different code depending on screen location.
 * 
 * @description
 * Demonstrates position-aware scripting
 */
^F10:: {
    MouseGetPos(&x, &y)

    ; Define regions
    leftThird := A_ScreenWidth // 3
    rightThird := (A_ScreenWidth // 3) * 2

    if (x < leftThird) {
        ToolTip("Left region action executed!")
        ; Do left-region specific action
    } else if (x >= leftThird && x < rightThird) {
        ToolTip("Center region action executed!")
        ; Do center-region specific action
    } else {
        ToolTip("Right region action executed!")
        ; Do right-region specific action
    }

    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Get cursor velocity
 * Calculates how fast cursor is moving
 * 
 * @returns {Number} Velocity in pixels per second
 */
GetCursorVelocity() {
    static lastX := 0
    static lastY := 0
    static lastTime := 0

    MouseGetPos(&x, &y)
    currentTime := A_TickCount

    if (lastTime = 0) {
        lastX := x
        lastY := y
        lastTime := currentTime
        return 0
    }

    deltaX := x - lastX
    deltaY := y - lastY
    deltaTime := currentTime - lastTime

    distance := Sqrt(deltaX ** 2 + deltaY ** 2)
    velocity := (distance / deltaTime) * 1000  ; pixels per second

    lastX := x
    lastY := y
    lastTime := currentTime

    return velocity
}

; Test velocity
^F11:: {
    ToolTip("Move your mouse to measure velocity...`nPress Ctrl+F11 again to stop")

    global velocityMonitoring := true
    SetTimer(ShowVelocity, 50)

    ShowVelocity() {
        if (!velocityMonitoring) {
            SetTimer(ShowVelocity, 0)
            return
        }

        velocity := GetCursorVelocity()
        MouseGetPos(&x, &y)

        ToolTip("Position: X=" x ", Y=" y "`nVelocity: " Round(velocity, 0) " px/s`nPress Ctrl+F11 to stop")
    }
}

^F11 up:: {
    global velocityMonitoring := false
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc:: ExitApp()

F12:: {
    helpText := "
    (
    MouseGetPos - Get Position
    ==========================

    F1 - Show current position
    F2 - Toggle position tracking
    F3 - Show all coordinate modes

    Ctrl+F1  - Window info under cursor
    Ctrl+F2  - Control info under cursor
    Ctrl+F3  - Complete cursor info
    Ctrl+F4  - Save/click position
    Ctrl+F5  - Record/replay path
    Ctrl+F6  - Distance from center
    Ctrl+F7  - Toggle boundary monitoring
    Ctrl+F8  - Toggle position logger
    Ctrl+F9  - Quadrant detection
    Ctrl+F10 - Position-based action
    Ctrl+F11 - Toggle velocity monitor

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "MouseGetPos Examples Help")
}
