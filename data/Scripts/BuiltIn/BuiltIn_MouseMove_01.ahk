#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 MouseMove Function - Basic Cursor Movement
* ============================================================================
*
* The MouseMove function moves the mouse cursor to specified coordinates.
* Essential for automation, UI testing, and cursor positioning.
*
* Syntax: MouseMove(X, Y [, Speed])
*
* @module BuiltIn_MouseMove_01
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Basic Mouse Movement
; ============================================================================

/**
* Moves cursor to absolute screen coordinates.
* Speed parameter controls movement velocity (0 = instant, 100 = slow).
*
* @example
* ; Press F1 to move cursor to (500, 500)
*/
F1:: {
    ToolTip("Moving cursor to (500, 500)...")
    MouseMove(500, 500)  ; Instant movement (default speed)
    Sleep(1000)
    ToolTip()
}

/**
* Slow cursor movement
* Visible movement for user-friendly automation
*/
F2:: {
    ToolTip("Slow movement to (300, 300)...")
    MouseMove(300, 300, 50)  ; Speed 50 = medium slow
    Sleep(1000)
    ToolTip()
}

/**
* Very slow cursor movement
* Maximum visibility for demonstrations
*/
F3:: {
    ToolTip("Very slow movement to (700, 400)...")
    MouseMove(700, 400, 100)  ; Speed 100 = very slow
    Sleep(1000)
    ToolTip()
}

/**
* Fast cursor movement
* Quick but still visible
*/
F4:: {
    ToolTip("Fast movement to (200, 600)...")
    MouseMove(200, 600, 10)  ; Speed 10 = fast
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Screen Corner Navigation
; ============================================================================

/**
* Moves cursor to screen corners.
* Uses built-in variables for screen dimensions.
*
* @description
* Demonstrates using A_ScreenWidth and A_ScreenHeight
*/
^F1:: {
    ToolTip("Moving to top-left corner...")
    MouseMove(0, 0, 30)
    Sleep(800)

    ToolTip("Moving to top-right corner...")
    MouseMove(A_ScreenWidth - 1, 0, 30)
    Sleep(800)

    ToolTip("Moving to bottom-right corner...")
    MouseMove(A_ScreenWidth - 1, A_ScreenHeight - 1, 30)
    Sleep(800)

    ToolTip("Moving to bottom-left corner...")
    MouseMove(0, A_ScreenHeight - 1, 30)
    Sleep(800)

    ToolTip("Returning to center...")
    MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2, 30)
    Sleep(500)
    ToolTip()
}

/**
* Edge midpoint navigation
* Moves to center of each screen edge
*/
^F2:: {
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2

    ToolTip("Top edge center...")
    MouseMove(centerX, 0, 25)
    Sleep(600)

    ToolTip("Right edge center...")
    MouseMove(A_ScreenWidth - 1, centerY, 25)
    Sleep(600)

    ToolTip("Bottom edge center...")
    MouseMove(centerX, A_ScreenHeight - 1, 25)
    Sleep(600)

    ToolTip("Left edge center...")
    MouseMove(0, centerY, 25)
    Sleep(600)

    ToolTip("Back to center...")
    MouseMove(centerX, centerY, 25)
    Sleep(500)
    ToolTip()
}

; ============================================================================
; Example 3: Sequential Movement Patterns
; ============================================================================

/**
* Horizontal line movement pattern.
* Moves cursor along a horizontal line.
*
* @description
* Creates smooth horizontal movement across screen
*/
^F3:: {
    y := A_ScreenHeight // 2
    startX := 100
    endX := A_ScreenWidth - 100
    steps := 5

    ToolTip("Horizontal line movement...")

    ; Move from left to right in steps
    Loop steps {
        progress := A_Index / steps
        x := startX + (endX - startX) * progress

        MouseMove(x, y, 20)
        Sleep(300)
    }

    ToolTip("Horizontal movement complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Vertical line movement pattern
* Moves cursor along a vertical line
*/
^F4:: {
    x := A_ScreenWidth // 2
    startY := 100
    endY := A_ScreenHeight - 100
    steps := 5

    ToolTip("Vertical line movement...")

    ; Move from top to bottom in steps
    Loop steps {
        progress := A_Index / steps
        y := startY + (endY - startY) * progress

        MouseMove(x, y, 20)
        Sleep(300)
    }

    ToolTip("Vertical movement complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Diagonal movement pattern
* Moves from corner to corner diagonally
*/
^F5:: {
    ToolTip("Diagonal movement pattern...")

    ; Top-left to bottom-right
    MouseMove(100, 100, 30)
    Sleep(500)
    MouseMove(A_ScreenWidth - 100, A_ScreenHeight - 100, 30)
    Sleep(500)

    ; Bottom-right to top-right
    MouseMove(A_ScreenWidth - 100, 100, 30)
    Sleep(500)

    ; Top-right to bottom-left
    MouseMove(100, A_ScreenHeight - 100, 30)
    Sleep(500)

    ToolTip("Diagonal pattern complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Cursor Positioning for UI Elements
; ============================================================================

/**
* Simulates navigating through a menu bar.
* Moves cursor to typical menu positions.
*
* @description
* Demonstrates positioning for UI automation
*/
^F6:: {
    ToolTip("Simulating menu navigation...")

    menuY := 30  ; Typical menu bar height
    spacing := 80  ; Space between menu items

    ; File menu
    ToolTip("File menu...")
    MouseMove(50, menuY, 20)
    Sleep(500)

    ; Edit menu
    ToolTip("Edit menu...")
    MouseMove(50 + spacing, menuY, 20)
    Sleep(500)

    ; View menu
    ToolTip("View menu...")
    MouseMove(50 + spacing*2, menuY, 20)
    Sleep(500)

    ; Tools menu
    ToolTip("Tools menu...")
    MouseMove(50 + spacing*3, menuY, 20)
    Sleep(500)

    ; Help menu
    ToolTip("Help menu...")
    MouseMove(50 + spacing*4, menuY, 20)
    Sleep(500)

    ToolTip("Menu navigation complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Form field navigation simulation
* Moves cursor through typical form layout
*/
^F7:: {
    ToolTip("Form field navigation...")

    formX := 400
    startY := 200
    fieldSpacing := 60

    ; Move through form fields
    fields := ["Name", "Email", "Phone", "Address", "City", "Zip"]

    for index, fieldName in fields {
        y := startY + (index - 1) * fieldSpacing
        ToolTip("Moving to " fieldName " field...")
        MouseMove(formX, y, 15)
        Sleep(400)
    }

    ToolTip("Form navigation complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 5: Cursor Path Animation
; ============================================================================

/**
* Creates smooth curved path movement.
* Demonstrates advanced cursor animation.
*
* @description
* Uses mathematical curves for smooth motion
*/
^F8:: {
    ToolTip("Smooth curve animation...")

    startX := 200
    startY := A_ScreenHeight // 2
    endX := A_ScreenWidth - 200
    amplitude := 200
    steps := 50

    Loop steps {
        progress := A_Index / steps
        x := startX + (endX - startX) * progress

        ; Sine wave for Y position
        angle := progress * 3.14159 * 2  ; Two full waves
        y := (A_ScreenHeight // 2) + amplitude * Sin(angle)

        MouseMove(x, y, 0)
        Sleep(30)
    }

    ToolTip("Curve animation complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Circular motion pattern
* Moves cursor in a circle
*/
^F9:: {
    ToolTip("Circular motion...")

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    radius := 200
    steps := 60

    Loop steps {
        angle := (A_Index / steps) * 2 * 3.14159
        x := centerX + radius * Cos(angle)
        y := centerY + radius * Sin(angle)

        MouseMove(x, y, 0)
        Sleep(30)
    }

    ToolTip("Circle complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Figure-8 motion pattern
* Creates infinity symbol motion
*/
^F10:: {
    ToolTip("Figure-8 motion...")

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    radiusX := 300
    radiusY := 150
    steps := 80

    Loop steps {
        t := (A_Index / steps) * 2 * 3.14159

        ; Lissajous curve for figure-8
        x := centerX + radiusX * Sin(t)
        y := centerY + radiusY * Sin(2 * t)

        MouseMove(x, y, 0)
        Sleep(25)
    }

    ToolTip("Figure-8 complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 6: Multi-Monitor Support
; ============================================================================

/**
* Moves cursor across multiple monitors.
* Uses SysGet to detect monitor configurations.
*
* @description
* Demonstrates multi-monitor cursor movement
*/
^F11:: {
    monitorCount := MonitorGetCount()

    ToolTip("Detected " monitorCount " monitor(s)")
    Sleep(1000)

    if (monitorCount > 1) {
        ; Move to center of each monitor
        Loop monitorCount {
            MonitorGet(A_Index, &left, &top, &right, &bottom)

            centerX := left + (right - left) // 2
            centerY := top + (bottom - top) // 2

            ToolTip("Monitor " A_Index " center")
            MouseMove(centerX, centerY, 30)
            Sleep(1500)
        }
    } else {
        ToolTip("Single monitor detected")
        Sleep(1500)
    }

    ToolTip()
}

; ============================================================================
; Example 7: Smart Cursor Positioning
; ============================================================================

/**
* Positions cursor relative to active window.
* Uses window coordinates instead of screen coordinates.
*
* @description
* Demonstrates window-relative cursor movement
*/
^F12:: {
    ToolTip("Opening Notepad for window-relative positioning...")

    Run("notepad.exe")
    Sleep(1000)

    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        ; Get window position and size
        WinGetPos(&winX, &winY, &winW, &winH, "Notepad")

        ; Set coordinate mode to window
        CoordMode("Mouse", "Window")

        ToolTip("Moving to window top-left...")
        MouseMove(10, 10, 20)
        Sleep(500)

        ToolTip("Moving to window center...")
        MouseMove(winW // 2, winH // 2, 20)
        Sleep(500)

        ToolTip("Moving to window bottom-right...")
        MouseMove(winW - 10, winH - 10, 20)
        Sleep(500)

        ; Reset to screen coordinates
        CoordMode("Mouse", "Screen")

        ToolTip("Window positioning complete!")
        Sleep(1000)
        ToolTip()

        WinClose("Notepad")
        Sleep(100)
        if WinWait("Notepad", , 2) {
            Send("n")
        }
    }
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Smooth movement to target with easing
*
* @param {Number} targetX - Target X coordinate
* @param {Number} targetY - Target Y coordinate
* @param {Number} steps - Number of steps (default: 30)
*/
SmoothMoveTo(targetX, targetY, steps := 30) {
    MouseGetPos(&currentX, &currentY)

    Loop steps {
        progress := A_Index / steps

        ; Ease-in-out formula
        easeProgress := progress < 0.5
        ? 2 * progress * progress
        : 1 - (-2 * progress + 2) ** 2 / 2

        x := currentX + (targetX - currentX) * easeProgress
        y := currentY + (targetY - currentY) * easeProgress

        MouseMove(x, y, 0)
        Sleep(10)
    }

    ; Ensure we reach exact target
    MouseMove(targetX, targetY, 0)
}

/**
* Move cursor in grid pattern
*
* @param {Number} startX - Grid start X
* @param {Number} startY - Grid start Y
* @param {Number} cols - Number of columns
* @param {Number} rows - Number of rows
* @param {Number} spacing - Spacing between points
*/
MoveInGrid(startX, startY, cols, rows, spacing) {
    Loop rows {
        rowIndex := A_Index
        Loop cols {
            colIndex := A_Index

            x := startX + (colIndex - 1) * spacing
            y := startY + (rowIndex - 1) * spacing

            MouseMove(x, y, 15)
            Sleep(200)
        }
    }
}

; Test utility functions
!F1:: {
    ToolTip("Testing SmoothMoveTo...")
    SmoothMoveTo(A_ScreenWidth // 2, A_ScreenHeight // 2, 40)
    Sleep(500)
    ToolTip()
}

!F2:: {
    ToolTip("Testing MoveInGrid...")
    MoveInGrid(200, 200, 4, 3, 80)
    Sleep(500)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    MouseMove - Basic Cursor Movement
    ==================================

    F1 - Move to (500,500)
    F2 - Slow movement
    F3 - Very slow movement
    F4 - Fast movement

    Ctrl+F1  - Screen corners tour
    Ctrl+F2  - Edge midpoints tour
    Ctrl+F3  - Horizontal line
    Ctrl+F4  - Vertical line
    Ctrl+F5  - Diagonal pattern
    Ctrl+F6  - Menu navigation
    Ctrl+F7  - Form navigation
    Ctrl+F8  - Curve animation
    Ctrl+F9  - Circular motion
    Ctrl+F10 - Figure-8 motion
    Ctrl+F11 - Multi-monitor
    Ctrl+F12 - Window-relative

    Alt+F1 - Smooth move test
    Alt+F2 - Grid pattern test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "MouseMove Examples Help")
}
