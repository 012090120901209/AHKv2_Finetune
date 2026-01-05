#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Click Function - Basic Click Operations
 * ============================================================================
 * 
 * The Click function simulates mouse clicks at specified coordinates or
 * at the current cursor position. It's essential for GUI automation,
 * testing, and user interaction simulation.
 * 
 * Syntax: Click([Options])
 * 
 * @module BuiltIn_Click_01
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Left Click at Current Position
; ============================================================================

/**
 * Demonstrates basic left mouse button clicking at the current cursor position.
 * This is the simplest form of Click and is useful for automating button presses.
 * 
 * @example
 * ; Press F1 to perform a single left click at cursor position
 */
F1:: {
    ToolTip("Clicking at current position...")
    Click()  ; Single left click at current mouse position
    Sleep(1000)
    ToolTip()
}

/**
 * Right-click demonstration
 * Shows how to perform a right-click, useful for context menus
 */
F2:: {
    ToolTip("Right-clicking at current position...")
    Click("Right")  ; Right click at current position
    Sleep(1000)
    ToolTip()
}

/**
 * Middle-click demonstration
 * Useful for opening links in new tabs or special application functions
 */
F3:: {
    ToolTip("Middle-clicking at current position...")
    Click("Middle")  ; Middle mouse button click
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Clicking at Specific Coordinates
; ============================================================================

/**
 * Demonstrates clicking at specific screen coordinates.
 * Coordinates can be absolute (screen) or relative to the active window.
 * 
 * @param {Number} x - X coordinate on screen
 * @param {Number} y - Y coordinate on screen
 * @example
 * ; Press F4 to click at specific screen position
 */
F4:: {
    ToolTip("Clicking at coordinates (100, 100)...")
    Click(100, 100)  ; Click at screen position X=100, Y=100
    Sleep(1000)
    ToolTip()
}

/**
 * Multiple clicks at specific position
 * Demonstrates click count parameter for double/triple clicks
 */
F5:: {
    ToolTip("Double-clicking at (200, 200)...")
    Click(200, 200, 2)  ; Double-click at position
    Sleep(1000)
    ToolTip()
}

/**
 * Right-click at specific coordinates
 * Combines coordinate targeting with right-click button
 */
F6:: {
    ToolTip("Right-clicking at (300, 300)...")
    Click(300, 300, "Right")  ; Right-click at specific position
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: Automated Form Filling Simulation
; ============================================================================

/**
 * Simulates clicking through a form with multiple input fields.
 * This demonstrates practical automation for repetitive data entry tasks.
 * 
 * @description
 * Clicks on different form field positions and types data.
 * Useful for automated testing or repetitive form submissions.
 */
^F1:: {
    ToolTip("Starting automated form filling...")

    ; Click on first name field (example coordinates)
    Click(400, 200)
    Sleep(100)
    Send("John")
    Sleep(200)

    ; Click on last name field
    Click(400, 250)
    Sleep(100)
    Send("Doe")
    Sleep(200)

    ; Click on email field
    Click(400, 300)
    Sleep(100)
    Send("john.doe@example.com")
    Sleep(200)

    ; Click on submit button
    Click(400, 400)

    ToolTip("Form filling completed!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Click with Relative Positioning
; ============================================================================

/**
 * Demonstrates relative coordinate mode where clicks are positioned
 * relative to the active window instead of the entire screen.
 * 
 * @description
 * Uses CoordMode to switch between relative and absolute positioning
 */
F7:: {
    ; Set coordinate mode to relative to active window
    CoordMode("Mouse", "Window")

    ToolTip("Clicking relative to active window at (50, 50)...")
    Click(50, 50)  ; Click 50 pixels from top-left of active window
    Sleep(1000)

    ; Restore to screen coordinates
    CoordMode("Mouse", "Screen")
    ToolTip()
}

/**
 * Automated window interaction example
 * Clicks relative positions within a specific window
 */
^F2:: {
    ; Find and activate target window
    if WinExist("Notepad") {
        WinActivate("Notepad")
        Sleep(200)

        CoordMode("Mouse", "Window")

        ; Click in text area (relative to Notepad window)
        Click(100, 100)
        Sleep(100)
        Send("Text inserted via automated clicking!")

        CoordMode("Mouse", "Screen")
        ToolTip("Automated Notepad interaction complete!")
        Sleep(1000)
        ToolTip()
    } else {
        MsgBox("Notepad not found!")
    }
}

; ============================================================================
; Example 5: Click Down and Up States
; ============================================================================

/**
 * Demonstrates click down and up states separately.
 * Useful for drag operations or custom click behaviors.
 * 
 * @description
 * Separates the mouse button press and release into distinct actions
 */
F8:: {
    ToolTip("Mouse button down...")
    Click("Down")  ; Press and hold left button
    Sleep(1000)

    ToolTip("Mouse button up...")
    Click("Up")    ; Release left button
    Sleep(500)
    ToolTip()
}

/**
 * Right-click down/up demonstration
 * Shows button down/up with right mouse button
 */
F9:: {
    ToolTip("Right button down...")
    Click("Right Down")  ; Press and hold right button
    Sleep(1000)

    ToolTip("Right button up...")
    Click("Right Up")    ; Release right button
    Sleep(500)
    ToolTip()
}

; ============================================================================
; Example 6: UI Testing Automation
; ============================================================================

/**
 * Comprehensive UI testing simulation.
 * Demonstrates clicking through a series of UI elements with validation.
 * 
 * @description
 * Simulates a complete UI interaction flow including:
 * - Menu navigation
 * - Button clicking
 * - Dialog interaction
 * - Result validation
 */
^F3:: {
    testResults := []

    ToolTip("Starting UI test sequence...")
    Sleep(500)

    ; Test 1: Click menu item
    ToolTip("Test 1: Clicking menu...")
    Click(50, 30)  ; Menu position
    Sleep(200)
    testResults.Push("Menu click: OK")

    ; Test 2: Click submenu
    ToolTip("Test 2: Clicking submenu...")
    Click(50, 80)  ; Submenu item
    Sleep(200)
    testResults.Push("Submenu click: OK")

    ; Test 3: Click dialog button
    ToolTip("Test 3: Clicking dialog button...")
    Click(400, 350)  ; Dialog button
    Sleep(200)
    testResults.Push("Dialog button: OK")

    ; Test 4: Click confirmation
    ToolTip("Test 4: Clicking confirmation...")
    Click(450, 400)  ; Confirm button
    Sleep(200)
    testResults.Push("Confirmation: OK")

    ; Display results
    resultText := "UI Test Results:`n`n"
    for index, result in testResults {
        resultText .= index ". " result "`n"
    }

    ToolTip(resultText)
    Sleep(3000)
    ToolTip()
}

; ============================================================================
; Example 7: Click with Different Timing and Speed
; ============================================================================

/**
 * Demonstrates various click speeds and delays for different scenarios.
 * Some applications require slower clicks to register properly.
 * 
 * @description
 * Uses SetDefaultMouseSpeed to control click execution speed
 */
^F4:: {
    ; Save original mouse speed
    originalSpeed := A_DefaultMouseSpeed

    ToolTip("Fast clicks (speed 0)...")
    SetDefaultMouseSpeed(0)  ; Instant movement
    Click(100, 100)
    Sleep(200)
    Click(200, 100)
    Sleep(200)
    Click(300, 100)
    Sleep(500)

    ToolTip("Medium speed clicks (speed 50)...")
    SetDefaultMouseSpeed(50)  ; Medium speed
    Click(100, 200)
    Sleep(200)
    Click(200, 200)
    Sleep(200)
    Click(300, 200)
    Sleep(500)

    ToolTip("Slow clicks (speed 100)...")
    SetDefaultMouseSpeed(100)  ; Slow movement
    Click(100, 300)
    Sleep(200)
    Click(200, 300)
    Sleep(200)
    Click(300, 300)

    ; Restore original speed
    SetDefaultMouseSpeed(originalSpeed)

    ToolTip("Click speed demonstration complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Rapid fire clicking for gaming or stress testing
 * Demonstrates multiple rapid clicks at same position
 */
^F5:: {
    ToolTip("Rapid fire clicking (10 clicks)...")

    Loop 10 {
        Click()
        Sleep(50)  ; 50ms between clicks = 20 clicks per second
    }

    ToolTip("Rapid clicking complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Pattern clicking demonstration
 * Creates a clicking pattern useful for grid-based interactions
 */
^F6:: {
    ToolTip("Pattern clicking in progress...")

    ; Click in a square pattern
    startX := 200
    startY := 200
    spacing := 50

    ; Top row
    Click(startX, startY)
    Sleep(100)
    Click(startX + spacing, startY)
    Sleep(100)
    Click(startX + spacing * 2, startY)
    Sleep(100)

    ; Middle row
    Click(startX, startY + spacing)
    Sleep(100)
    Click(startX + spacing, startY + spacing)
    Sleep(100)
    Click(startX + spacing * 2, startY + spacing)
    Sleep(100)

    ; Bottom row
    Click(startX, startY + spacing * 2)
    Sleep(100)
    Click(startX + spacing, startY + spacing * 2)
    Sleep(100)
    Click(startX + spacing * 2, startY + spacing * 2)

    ToolTip("Pattern clicking complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Safe click function with error handling
 * 
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @param {String} button - Mouse button (optional)
 * @param {Number} count - Number of clicks (optional)
 * @returns {Boolean} Success status
 */
SafeClick(x := "", y := "", button := "Left", count := 1) {
    try {
        if (x != "" && y != "") {
            Click(x, y, button, count)
        } else {
            Click(button, count)
        }
        return true
    } catch as err {
        MsgBox("Click failed: " err.Message)
        return false
    }
}

/**
 * Click with verification
 * Clicks and verifies the action was successful
 * 
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @returns {Boolean} Verification result
 */
ClickWithVerify(x, y) {
    Click(x, y)
    Sleep(50)

    ; Verify cursor moved to position
    MouseGetPos(&currentX, &currentY)

    ; Allow small margin of error
    tolerance := 5
    if (Abs(currentX - x) <= tolerance && Abs(currentY - y) <= tolerance) {
        return true
    }
    return false
}

; Test the utility functions
^F7:: {
    result := SafeClick(150, 150, "Left", 2)
    ToolTip("SafeClick result: " (result ? "Success" : "Failed"))
    Sleep(1000)
    ToolTip()
}

^F8:: {
    result := ClickWithVerify(250, 250)
    ToolTip("ClickWithVerify result: " (result ? "Position verified" : "Position mismatch"))
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Exit Hotkey
; ============================================================================

/**
 * Emergency stop - Press ESC to exit script
 */
Esc:: ExitApp()

/**
 * Show help information
 */
F12:: {
    helpText := "
    (
    Click Function - Basic Operations
    ==================================

    F1  - Basic left click at cursor
    F2  - Right click at cursor
    F3  - Middle click at cursor
    F4  - Click at coordinates (100,100)
    F5  - Double-click at (200,200)
    F6  - Right-click at (300,300)
    F7  - Click relative to window
    F8  - Click down/up states
    F9  - Right button down/up

    Ctrl+F1 - Automated form filling
    Ctrl+F2 - Notepad automation
    Ctrl+F3 - UI testing sequence
    Ctrl+F4 - Click speed demo
    Ctrl+F5 - Rapid fire clicking
    Ctrl+F6 - Pattern clicking
    Ctrl+F7 - Safe click test
    Ctrl+F8 - Click verification test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Click Examples Help")
}
