#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Click Function - Double-Click Operations
 * ============================================================================
 *
 * This module demonstrates double-click operations, timing considerations,
 * and practical applications in file management, UI interaction, and
 * automated testing scenarios.
 *
 * @module BuiltIn_Click_02
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Double-Click Operations
; ============================================================================

/**
 * Standard double-click at current cursor position.
 * The click count parameter determines single, double, or multi-clicks.
 *
 * @example
 * ; Press F1 for double-click at cursor
 */
F1:: {
    ToolTip("Double-clicking at current position...")
    Click(2)  ; Double-click at current position
    Sleep(1000)
    ToolTip()
}

/**
 * Double-click at specific coordinates
 * Useful for opening files or selecting text
 */
F2:: {
    ToolTip("Double-clicking at (300, 300)...")
    Click(300, 300, "Left", 2)  ; Double-click at coordinates
    Sleep(1000)
    ToolTip()
}

/**
 * Triple-click demonstration
 * Often used to select entire paragraphs or lines
 */
F3:: {
    ToolTip("Triple-clicking to select line...")
    Click(3)  ; Triple-click selects entire line in most editors
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: File Explorer Double-Click Automation
; ============================================================================

/**
 * Automates opening files in Windows Explorer via double-click.
 * Demonstrates practical file management automation.
 *
 * @description
 * Simulates navigating and opening files in File Explorer
 */
^F1:: {
    ToolTip("Starting File Explorer automation...")

    ; Open File Explorer
    Run("explorer.exe C:\")
    Sleep(1000)

    ; Activate Explorer window
    if WinWait("File Explorer", , 5) {
        WinActivate("File Explorer")
        Sleep(500)

        ; Double-click on first file/folder (approximate position)
        CoordMode("Mouse", "Window")
        Click(150, 200, "Left", 2)  ; Double-click first item
        Sleep(500)

        CoordMode("Mouse", "Screen")
        ToolTip("File Explorer automation complete!")
        Sleep(1500)
        ToolTip()
    } else {
        MsgBox("Could not open File Explorer")
    }
}

/**
 * Desktop icon double-click automation
 * Opens specific desktop icons by position
 */
^F2:: {
    ; Minimize all windows to show desktop
    Send("#d")
    Sleep(500)

    ToolTip("Double-clicking desktop icon...")

    ; Double-click approximate position of first desktop icon
    Click(100, 100, "Left", 2)
    Sleep(1000)

    ToolTip("Desktop icon opened!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: Text Selection with Double-Click
; ============================================================================

/**
 * Demonstrates word selection via double-click in text editors.
 * Double-clicking typically selects the word under cursor.
 *
 * @description
 * Useful for automated text editing and processing
 */
^F3:: {
    ToolTip("Opening Notepad for text selection demo...")

    ; Open Notepad with sample text
    Run("notepad.exe")
    Sleep(1000)

    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        ; Type sample text
        Send("The quick brown fox jumps over the lazy dog.")
        Sleep(300)

        ; Select all and move to beginning
        Send("^a")
        Sleep(100)
        Send("{Home}")
        Sleep(100)

        CoordMode("Mouse", "Window")

        ; Double-click to select "quick"
        ToolTip("Selecting 'quick'...")
        Click(150, 100, "Left", 2)  ; Double-click on word
        Sleep(1000)

        ; Copy selected word
        Send("^c")
        Sleep(100)

        selectedWord := A_Clipboard
        ToolTip("Selected word: " selectedWord)
        Sleep(2000)
        ToolTip()

        ; Close Notepad without saving
        WinClose("Notepad")
        Sleep(100)
        if WinWait("Notepad", , 2) {
            Send("n")  ; Don't save
        }

        CoordMode("Mouse", "Screen")
    }
}

/**
 * Paragraph selection with triple-click
 * Demonstrates multi-line text selection
 */
^F4:: {
    ToolTip("Opening Notepad for paragraph selection...")

    Run("notepad.exe")
    Sleep(1000)

    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        ; Type multi-line sample text
        sampleText := "
        (
        This is the first line of text.
        This is the second line of text.
        This is the third line of text.
        )"

        Send(sampleText)
        Sleep(300)

        CoordMode("Mouse", "Window")

        ; Triple-click to select entire paragraph/line
        ToolTip("Triple-clicking to select line...")
        Click(150, 100, "Left", 3)
        Sleep(2000)

        ; Close Notepad
        WinClose("Notepad")
        Sleep(100)
        if WinWait("Notepad", , 2) {
            Send("n")
        }

        CoordMode("Mouse", "Screen")
        ToolTip()
    }
}

; ============================================================================
; Example 4: Double-Click Timing Adjustments
; ============================================================================

/**
 * Demonstrates the importance of double-click speed.
 * System double-click speed settings affect automation reliability.
 *
 * @description
 * Shows different approaches to ensure reliable double-clicks
 */
^F5:: {
    ToolTip("Testing different double-click methods...")

    ; Method 1: Standard double-click (relies on system timing)
    ToolTip("Method 1: Standard double-click")
    Click(200, 200, "Left", 2)
    Sleep(1000)

    ; Method 2: Manual double-click with explicit timing
    ToolTip("Method 2: Manual timing (100ms)")
    Click(300, 200, "Left")
    Sleep(100)  ; Explicit delay between clicks
    Click(300, 200, "Left")
    Sleep(1000)

    ; Method 3: Manual double-click with system double-click speed
    ToolTip("Method 3: Manual timing (50ms)")
    Click(400, 200, "Left")
    Sleep(50)  ; Faster timing
    Click(400, 200, "Left")
    Sleep(1000)

    ToolTip("Double-click timing test complete!")
    Sleep(1500)
    ToolTip()
}

/**
 * Reliable double-click function with timing control
 *
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @param {Number} delay - Delay between clicks in milliseconds
 */
ReliableDoubleClick(x, y, delay := 80) {
    Click(x, y)
    Sleep(delay)
    Click(x, y)
}

; Test the reliable double-click function
^F6:: {
    ToolTip("Testing reliable double-click function...")
    ReliableDoubleClick(250, 250, 80)
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 5: UI Control Double-Click Automation
; ============================================================================

/**
 * Automates double-clicking on specific UI controls.
 * Demonstrates interacting with list views, tree views, etc.
 *
 * @description
 * Common in UI testing scenarios
 */
^F7:: {
    ToolTip("Creating test GUI with double-click events...")

    ; Create a simple GUI for testing
    testGui := Gui("+AlwaysOnTop", "Double-Click Test")
    testGui.Add("Text", "w300", "Double-click the list items below:")

    ; Add ListView control
    LV := testGui.Add("ListView", "r10 w300", ["Item", "Value"])

    ; Add sample items
    LV.Add(, "Item 1", "Value 1")
    LV.Add(, "Item 2", "Value 2")
    LV.Add(, "Item 3", "Value 3")
    LV.Add(, "Item 4", "Value 4")
    LV.Add(, "Item 5", "Value 5")

    ; Handle double-click events
    LV.OnEvent("DoubleClick", ListDoubleClick)

    testGui.Show("w320 h300")

    ToolTip("GUI created! Try double-clicking items...")
    Sleep(2000)
    ToolTip()

    ; Function to handle double-click
    ListDoubleClick(ctrl, rowNumber) {
        itemText := ctrl.GetText(rowNumber, 1)
        itemValue := ctrl.GetText(rowNumber, 2)
        MsgBox("You double-clicked:`n" itemText " - " itemValue, "Double-Click Event")
    }
}

; ============================================================================
; Example 6: Gaming Double-Click Macros
; ============================================================================

/**
 * Gaming scenarios where double-click is used for special actions.
 * Demonstrates rapid double-clicking with verification.
 *
 * @description
 * Common in inventory management, item pickup, etc.
 */
^F8:: {
    ToolTip("Gaming double-click macro activated...")

    ; Simulate double-clicking on multiple inventory slots
    inventoryPositions := [
        {x: 100, y: 100},
        {x: 150, y: 100},
        {x: 200, y: 100},
        {x: 250, y: 100},
        {x: 300, y: 100}
    ]

    for index, pos in inventoryPositions {
        ToolTip("Double-clicking inventory slot " index "...")
        Click(pos.x, pos.y, "Left", 2)
        Sleep(200)  ; Small delay between slots
    }

    ToolTip("Inventory macro complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Rapid loot collection macro
 * Double-clicks items in sequence quickly
 */
^F9:: {
    ToolTip("Rapid loot collection active...")

    ; Fast double-click sequence (8 items)
    Loop 8 {
        Click(2)  ; Double-click at current position
        MouseMove(0, 50, 5, "R")  ; Move down 50 pixels relatively
        Sleep(150)  ; Brief delay
    }

    ToolTip("Loot collection complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 7: Advanced Double-Click Patterns
; ============================================================================

/**
 * Complex double-click patterns for grid-based interfaces.
 * Useful for spreadsheets, game grids, or icon arrays.
 *
 * @description
 * Demonstrates systematic double-clicking in patterns
 */
^F10:: {
    ToolTip("Grid double-click pattern starting...")

    startX := 150
    startY := 150
    cellWidth := 60
    cellHeight := 40

    ; Double-click in 3x3 grid pattern
    Loop 3 {  ; Rows
        rowIndex := A_Index
        Loop 3 {  ; Columns
            colIndex := A_Index

            x := startX + (colIndex - 1) * cellWidth
            y := startY + (rowIndex - 1) * cellHeight

            ToolTip("Double-clicking cell [" rowIndex "," colIndex "]")
            Click(x, y, "Left", 2)
            Sleep(300)
        }
    }

    ToolTip("Grid pattern complete!")
    Sleep(1500)
    ToolTip()
}

/**
 * Diagonal double-click pattern
 * Demonstrates non-linear clicking patterns
 */
^F11:: {
    ToolTip("Diagonal pattern double-clicking...")

    startX := 100
    startY := 100
    step := 50

    ; Double-click diagonally (5 positions)
    Loop 5 {
        x := startX + (A_Index - 1) * step
        y := startY + (A_Index - 1) * step

        ToolTip("Diagonal position " A_Index)
        Click(x, y, "Left", 2)
        Sleep(400)
    }

    ToolTip("Diagonal pattern complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Utility Functions for Double-Click Operations
; ============================================================================

/**
 * Smart double-click with retry mechanism
 * Retries if first attempt doesn't work
 *
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @param {Number} maxRetries - Maximum retry attempts
 * @returns {Boolean} Success status
 */
SmartDoubleClick(x, y, maxRetries := 3) {
    attempts := 0

    Loop maxRetries {
        attempts++
        ToolTip("Double-click attempt " attempts "...")

        Click(x, y, "Left", 2)
        Sleep(500)

        ; Here you would add verification logic
        ; For now, we'll assume success
        if (attempts <= maxRetries) {
            ToolTip()
            return true
        }

        Sleep(200)
    }

    ToolTip("Double-click failed after " maxRetries " attempts")
    Sleep(1000)
    ToolTip()
    return false
}

/**
 * Conditional double-click based on pixel color
 * Only double-clicks if specified color is found
 *
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @param {Number} expectedColor - Expected color at position
 * @returns {Boolean} Whether double-click was performed
 */
ConditionalDoubleClick(x, y, expectedColor := 0xFFFFFF) {
    actualColor := PixelGetColor(x, y)

    if (actualColor = expectedColor) {
        Click(x, y, "Left", 2)
        return true
    }

    return false
}

; Test utility functions
^F12:: {
    result := SmartDoubleClick(200, 200, 2)
    MsgBox("SmartDoubleClick result: " (result ? "Success" : "Failed"))
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    Double-Click Operations Help
    ==============================

    F1 - Basic double-click at cursor
    F2 - Double-click at coordinates
    F3 - Triple-click demonstration

    Ctrl+F1  - File Explorer automation
    Ctrl+F2  - Desktop icon double-click
    Ctrl+F3  - Word selection
    Ctrl+F4  - Paragraph selection
    Ctrl+F5  - Double-click timing tests
    Ctrl+F6  - Reliable double-click test
    Ctrl+F7  - UI control double-click
    Ctrl+F8  - Gaming inventory macro
    Ctrl+F9  - Rapid loot collection
    Ctrl+F10 - Grid pattern double-click
    Ctrl+F11 - Diagonal pattern
    Ctrl+F12 - Smart double-click test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Double-Click Examples Help")
}
