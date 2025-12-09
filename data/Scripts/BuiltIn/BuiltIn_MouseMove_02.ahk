#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 MouseMove - Relative and Absolute Movement
* ============================================================================
*
* Demonstrates both absolute (screen) and relative (offset) mouse movement.
* Covers coordinate modes, relative positioning, and practical applications.
*
* @module BuiltIn_MouseMove_02
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Absolute vs Relative Movement Basics
; ============================================================================

/**
* Absolute movement to fixed screen coordinates.
* Cursor moves to exact position regardless of current location.
*
* @example
* ; Press F1 for absolute movement
*/
F1:: {
    ToolTip("Absolute move to (400, 300)...")
    MouseMove(400, 300, 25)
    Sleep(1000)
    ToolTip()
}

/**
* Relative movement using R option
* Moves cursor relative to current position
*/
F2:: {
    MouseGetPos(&currentX, &currentY)
    ToolTip("Current: (" currentX ", " currentY ")`nMoving +100 pixels right, +50 down...")

    ; Move 100 pixels right and 50 pixels down from current position
    MouseMove(100, 50, 25, "R")
    Sleep(1000)
    ToolTip()
}

/**
* Negative relative movement
* Moves cursor left and up
*/
F3:: {
    MouseGetPos(&currentX, &currentY)
    ToolTip("Current: (" currentX ", " currentY ")`nMoving -100 pixels left, -50 up...")

    ; Move 100 pixels left and 50 pixels up
    MouseMove(-100, -50, 25, "R")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Coordinate Mode Switching
; ============================================================================

/**
* Demonstrates different coordinate modes.
* Screen, Window, and Client coordinate systems.
*
* @description
* Shows how CoordMode affects mouse positioning
*/
^F1:: {
    ; Open Notepad for demonstration
    Run("notepad.exe")
    Sleep(1000)

    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        ; Screen coordinates (default)
        ToolTip("Using Screen coordinates...")
        CoordMode("Mouse", "Screen")
        MouseMove(500, 400, 20)
        Sleep(1000)

        ; Window coordinates (relative to window)
        ToolTip("Using Window coordinates...")
        CoordMode("Mouse", "Window")
        MouseMove(100, 100, 20)  ; 100,100 from window's top-left
        Sleep(1000)

        ; Client coordinates (relative to client area)
        ToolTip("Using Client coordinates...")
        CoordMode("Mouse", "Client")
        MouseMove(150, 80, 20)  ; 150,80 from client area
        Sleep(1000)

        ; Reset to screen
        CoordMode("Mouse", "Screen")
        ToolTip("Reset to Screen coordinates")
        Sleep(1000)
        ToolTip()

        WinClose("Notepad")
        Sleep(100)
        if WinWait("Notepad", , 2) {
            Send("n")
        }
    }
}

/**
* Practical window-relative positioning
* Always positions relative to active window
*/
^F2:: {
    if activeWin := WinGetTitle("A") {
        WinGetPos(&winX, &winY, &winW, &winH, "A")

        ToolTip("Active window: " activeWin)
        Sleep(500)

        CoordMode("Mouse", "Window")

        ; Move to window's center
        ToolTip("Moving to window center...")
        MouseMove(winW // 2, winH // 2, 20)
        Sleep(1000)

        ; Move to top-right corner of window
        ToolTip("Moving to window top-right...")
        MouseMove(winW - 50, 50, 20)
        Sleep(1000)

        CoordMode("Mouse", "Screen")
        ToolTip()
    }
}

; ============================================================================
; Example 3: Relative Movement Patterns
; ============================================================================

/**
* Step-by-step relative movement.
* Builds a path using relative offsets.
*
* @description
* Creates patterns using only relative movements
*/
^F3:: {
    ; Start from center
    MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2)
    Sleep(300)

    ToolTip("Drawing square with relative movements...")

    stepSize := 100

    ; Right
    ToolTip("Right...")
    MouseMove(stepSize, 0, 15, "R")
    Sleep(400)

    ; Down
    ToolTip("Down...")
    MouseMove(0, stepSize, 15, "R")
    Sleep(400)

    ; Left
    ToolTip("Left...")
    MouseMove(-stepSize, 0, 15, "R")
    Sleep(400)

    ; Up
    ToolTip("Up...")
    MouseMove(0, -stepSize, 15, "R")
    Sleep(400)

    ToolTip("Square complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Spiral pattern using relative movements
* Each step increases in size
*/
^F4:: {
    ; Start from center
    MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2)
    Sleep(300)

    ToolTip("Creating spiral with relative movements...")

    baseStep := 20

    Loop 8 {
        stepSize := baseStep * A_Index

        ; Right
        MouseMove(stepSize, 0, 10, "R")
        Sleep(100)

        ; Down
        MouseMove(0, stepSize, 10, "R")
        Sleep(100)

        ; Left
        MouseMove(-stepSize, 0, 10, "R")
        Sleep(100)

        ; Up (slightly more to expand)
        MouseMove(0, -stepSize - baseStep, 10, "R")
        Sleep(100)
    }

    ToolTip("Spiral complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Incremental Movement for Precision
; ============================================================================

/**
* Small incremental movements for fine control.
* Useful for precise positioning tasks.
*
* @description
* Demonstrates pixel-by-pixel movement
*/
^F5:: {
    ToolTip("Incremental movement demo...")

    ; Move to starting position
    MouseMove(300, 300)
    Sleep(300)

    ; Move in small increments
    increment := 5
    steps := 40

    ToolTip("Moving right in small increments...")
    Loop steps {
        MouseMove(increment, 0, 0, "R")
        Sleep(30)
    }

    Sleep(500)

    ToolTip("Moving down in small increments...")
    Loop steps {
        MouseMove(0, increment, 0, "R")
        Sleep(30)
    }

    ToolTip("Incremental movement complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Precision alignment using relative movements
* Makes fine adjustments to cursor position
*/
^F6:: {
    ; Move to approximate position
    MouseMove(400, 400)
    Sleep(300)

    ToolTip("Making fine adjustments...")

    ; Fine tune position with small relative movements
    adjustments := [
    {
        x: 3, y: 0, desc: "Right 3px"},
        {
            x: 0, y: -2, desc: "Up 2px"},
            {
                x: -1, y: 0, desc: "Left 1px"},
                {
                    x: 0, y: 1, desc: "Down 1px"
                }
                ]

                for adjustment in adjustments {
                    ToolTip(adjustment.desc)
                    MouseMove(adjustment.x, adjustment.y, 5, "R")
                    Sleep(500)
                }

                ToolTip("Precision alignment complete!")
                Sleep(1000)
                ToolTip()
            }

            ; ============================================================================
            ; Example 5: Dynamic Offset Calculations
            ; ============================================================================

            /**
            * Calculates offsets based on current position.
            * Useful for screen-size-independent automation.
            *
            * @description
            * Demonstrates adaptive relative positioning
            */
            ^F7:: {
                MouseGetPos(&startX, &startY)
                ToolTip("Starting at (" startX ", " startY ")")
                Sleep(500)

                ; Calculate offsets based on screen size
                screenCenterX := A_ScreenWidth // 2
                screenCenterY := A_ScreenHeight // 2

                offsetX := screenCenterX - startX
                offsetY := screenCenterY - startY

                ToolTip("Moving to screen center (offset: " offsetX ", " offsetY ")...")
                MouseMove(offsetX, offsetY, 25, "R")
                Sleep(1000)

                ; Calculate offset to top-right
                targetX := A_ScreenWidth - 100
                targetY := 100

                MouseGetPos(&currentX, &currentY)
                offsetX := targetX - currentX
                offsetY := targetY - currentY

                ToolTip("Moving to top-right (offset: " offsetX ", " offsetY ")...")
                MouseMove(offsetX, offsetY, 25, "R")
                Sleep(1000)
                ToolTip()
            }

            /**
            * Proportional movement based on screen size
            * Moves cursor by percentage of screen dimensions
            */
            ^F8:: {
                ; Move to center first
                MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2)
                Sleep(300)

                ToolTip("Moving by 25% of screen width right...")
                offsetX := A_ScreenWidth * 0.25
                MouseMove(offsetX, 0, 20, "R")
                Sleep(800)

                ToolTip("Moving by 25% of screen height down...")
                offsetY := A_ScreenHeight * 0.25
                MouseMove(0, offsetY, 20, "R")
                Sleep(800)

                ToolTip("Moving by 25% screen width left...")
                MouseMove(-offsetX, 0, 20, "R")
                Sleep(800)

                ToolTip("Moving by 25% screen height up...")
                MouseMove(0, -offsetY, 20, "R")
                Sleep(800)

                ToolTip("Proportional movement complete!")
                Sleep(1000)
                ToolTip()
            }

            ; ============================================================================
            ; Example 6: Multi-Step Relative Navigation
            ; ============================================================================

            /**
            * Complex navigation using multiple relative moves.
            * Simulates navigating through nested menus.
            *
            * @description
            * Demonstrates practical menu navigation
            */
            ^F9:: {
                ; Start at top-left area (typical menu bar position)
                MouseMove(100, 50)
                Sleep(300)

                ToolTip("Navigating through menu system...")

                ; Open File menu
                ToolTip("File menu...")
                Sleep(500)

                ; Move down to submenu
                ToolTip("Moving to first menu item...")
                MouseMove(0, 30, 15, "R")
                Sleep(500)

                ; Move to submenu that appears to the right
                ToolTip("Opening submenu...")
                MouseMove(120, 0, 15, "R")
                Sleep(500)

                ; Navigate down in submenu
                ToolTip("Navigating submenu items...")
                Loop 3 {
                    MouseMove(0, 25, 15, "R")
                    Sleep(300)
                }

                ToolTip("Menu navigation complete!")
                Sleep(1000)
                ToolTip()
            }

            /**
            * Form field navigation using relative movements
            * Tabs through form fields with consistent offsets
            */
            ^F10:: {
                ; Start at first form field
                MouseMove(400, 200)
                Sleep(300)

                ToolTip("Navigating form fields...")

                fieldSpacing := 60
                fieldCount := 6

                Loop fieldCount {
                    ToolTip("Field " A_Index " of " fieldCount)
                    Sleep(400)

                    ; Move to next field (down)
                    if (A_Index < fieldCount) {
                        MouseMove(0, fieldSpacing, 15, "R")
                    }
                }

                ToolTip("Form navigation complete!")
                Sleep(1000)
                ToolTip()
            }

            ; ============================================================================
            ; Example 7: Advanced Relative Movement Techniques
            ; ============================================================================

            /**
            * Zigzag pattern using relative movements.
            * Creates alternating left-right pattern.
            *
            * @description
            * Demonstrates complex relative patterns
            */
            ^F11:: {
                MouseMove(200, A_ScreenHeight // 2)
                Sleep(300)

                ToolTip("Zigzag pattern...")

                horizontalStep := 80
                verticalStep := 40

                Loop 10 {
                    ; Move down and right
                    MouseMove(horizontalStep, verticalStep, 10, "R")
                    Sleep(150)

                    ; Move down and left
                    MouseMove(-horizontalStep, verticalStep, 10, "R")
                    Sleep(150)
                }

                ToolTip("Zigzag complete!")
                Sleep(1000)
                ToolTip()
            }

            /**
            * Random walk using relative movements
            * Creates unpredictable but controlled movement
            */
            ^F12:: {
                MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2)
                Sleep(300)

                ToolTip("Random walk pattern...")

                Loop 30 {
                    ; Random offsets between -50 and +50
                    offsetX := Random(-50, 50)
                    offsetY := Random(-50, 50)

                    MouseMove(offsetX, offsetY, 5, "R")
                    Sleep(100)

                    ; Keep cursor on screen
                    MouseGetPos(&x, &y)
                    if (x < 50 || x > A_ScreenWidth - 50 || y < 50 || y > A_ScreenHeight - 50) {
                        ; Move back to center if near edge
                        MouseMove(A_ScreenWidth // 2, A_ScreenHeight // 2, 15)
                        Sleep(200)
                    }
                }

                ToolTip("Random walk complete!")
                Sleep(1000)
                ToolTip()
            }

            ; ============================================================================
            ; Utility Functions
            ; ============================================================================

            /**
            * Move relative with bounds checking
            *
            * @param {Number} offsetX - X offset
            * @param {Number} offsetY - Y offset
            * @param {Number} speed - Movement speed
            * @returns {Boolean} Success status
            */
            SafeRelativeMove(offsetX, offsetY, speed := 10) {
                MouseGetPos(&currentX, &currentY)

                newX := currentX + offsetX
                newY := currentY + offsetY

                ; Check bounds
                margin := 10
                if (newX < margin || newX > A_ScreenWidth - margin ||
                newY < margin || newY > A_ScreenHeight - margin) {
                    ToolTip("Movement would go off-screen!")
                    Sleep(1000)
                    ToolTip()
                    return false
                }

                MouseMove(offsetX, offsetY, speed, "R")
                return true
            }

            /**
            * Step pattern movement
            * Moves in specified pattern using relative movements
            *
            * @param {Array} pattern - Array of {x, y} offsets
            * @param {Number} speed - Movement speed
            */
            MoveInPattern(pattern, speed := 15) {
                for step in pattern {
                    MouseMove(step.x, step.y, speed, "R")
                    Sleep(200)
                }
            }

            ; Test utility functions
            !F1:: {
                result := SafeRelativeMove(200, 150, 20)
                ToolTip("SafeRelativeMove result: " (result ? "Success" : "Blocked"))
                Sleep(1000)
                ToolTip()
            }

            !F2:: {
                pattern := [
                {
                    x: 50, y: 0},
                    {
                        x: 0, y: 50},
                        {
                            x: -50, y: 0},
                            {
                                x: 0, y: -50
                            }
                            ]
                            MoveInPattern(pattern, 20)
                        }

                        ; ============================================================================
                        ; Exit and Help
                        ; ============================================================================

                        Esc::ExitApp()

                        F12:: {
                            helpText := "
                            (
                            MouseMove - Relative/Absolute Movement
                            =======================================

                            F1 - Absolute movement
                            F2 - Relative movement (right/down)
                            F3 - Relative movement (left/up)

                            Ctrl+F1  - Coordinate modes demo
                            Ctrl+F2  - Window-relative positioning
                            Ctrl+F3  - Square pattern (relative)
                            Ctrl+F4  - Spiral pattern
                            Ctrl+F5  - Incremental movement
                            Ctrl+F6  - Precision alignment
                            Ctrl+F7  - Dynamic offset calculation
                            Ctrl+F8  - Proportional movement
                            Ctrl+F9  - Menu navigation
                            Ctrl+F10 - Form navigation
                            Ctrl+F11 - Zigzag pattern
                            Ctrl+F12 - Random walk

                            Alt+F1 - Safe relative move test
                            Alt+F2 - Pattern move test

                            F12 - Show this help
                            ESC - Exit script
                            )"

                            MsgBox(helpText, "Relative/Absolute Movement Help")
                        }
