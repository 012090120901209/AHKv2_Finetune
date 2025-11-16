#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Click Function - Drag Operations
 * ============================================================================
 *
 * This module demonstrates mouse drag operations using Click down/up states.
 * Covers drag-and-drop, window dragging, selection dragging, and painting
 * applications.
 *
 * @module BuiltIn_Click_03
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Drag Operations
; ============================================================================

/**
 * Simple drag from one point to another.
 * Uses Click Down, MouseMove, and Click Up sequence.
 *
 * @example
 * ; Press F1 to perform basic drag
 */
F1:: {
    ToolTip("Dragging from (100,100) to (300,300)...")

    ; Press and hold at start position
    Click(100, 100, "Down")
    Sleep(100)

    ; Move to end position
    MouseMove(300, 300, 50)  ; Speed 50
    Sleep(100)

    ; Release button
    Click("Up")

    ToolTip("Drag complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Right-button drag operation
 * Some applications use right-drag for special functions
 */
F2:: {
    ToolTip("Right-button drag operation...")

    Click(150, 150, "Right Down")
    Sleep(100)
    MouseMove(350, 350, 30)
    Sleep(100)
    Click("Right Up")

    ToolTip("Right-drag complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Slow, smooth drag operation
 * Useful for precise movements
 */
F3:: {
    ToolTip("Slow, smooth drag...")

    Click(200, 200, "Down")
    Sleep(50)

    ; Very slow movement for precision
    MouseMove(400, 200, 2)  ; Speed 2 = very slow
    Sleep(50)

    Click("Up")

    ToolTip("Smooth drag complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: File Drag-and-Drop Simulation
; ============================================================================

/**
 * Simulates dragging files in Windows Explorer.
 * Demonstrates practical file management automation.
 *
 * @description
 * Opens Explorer and simulates drag-and-drop between folders
 */
^F1:: {
    ToolTip("Starting file drag-and-drop simulation...")

    ; Open File Explorer
    Run("explorer.exe C:\")
    Sleep(1000)

    if WinWait("File Explorer", , 5) {
        WinActivate("File Explorer")
        Sleep(500)

        CoordMode("Mouse", "Window")

        ; Click and drag first file to new location
        ToolTip("Dragging file...")

        ; Start at file position
        Click(150, 200, "Down")
        Sleep(200)

        ; Drag to new folder location
        MouseMove(150, 400, 30)
        Sleep(300)

        ; Release
        Click("Up")

        ToolTip("File drag simulation complete!")
        Sleep(2000)
        ToolTip()

        CoordMode("Mouse", "Screen")
    }
}

/**
 * Desktop icon rearrangement
 * Drags desktop icons to new positions
 */
^F2:: {
    ; Show desktop
    Send("#d")
    Sleep(500)

    ToolTip("Rearranging desktop icons...")

    ; Drag first icon to new position
    Click(100, 100, "Down")
    Sleep(100)
    MouseMove(300, 250, 40)
    Sleep(100)
    Click("Up")
    Sleep(500)

    ; Drag another icon
    Click(100, 200, "Down")
    Sleep(100)
    MouseMove(300, 350, 40)
    Sleep(100)
    Click("Up")

    ToolTip("Desktop rearrangement complete!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Example 3: Window Dragging
; ============================================================================

/**
 * Drags application windows to new positions.
 * Useful for window management automation.
 *
 * @description
 * Demonstrates dragging windows by their title bars
 */
^F3:: {
    ToolTip("Opening Notepad to demonstrate window dragging...")

    Run("notepad.exe")
    Sleep(1000)

    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        ; Get window position
        WinGetPos(&winX, &winY, &winW, &winH, "Notepad")

        CoordMode("Mouse", "Screen")

        ; Calculate title bar center
        titleBarX := winX + winW // 2
        titleBarY := winY + 15  ; Title bar is about 30 pixels high

        ToolTip("Dragging window...")

        ; Drag window to new position
        Click(titleBarX, titleBarY, "Down")
        Sleep(100)

        ; Move window to center of screen
        centerX := A_ScreenWidth // 2
        centerY := A_ScreenHeight // 2
        MouseMove(centerX, centerY, 30)
        Sleep(100)

        Click("Up")

        ToolTip("Window dragged to center!")
        Sleep(2000)
        ToolTip()

        ; Close Notepad
        WinClose("Notepad")
        Sleep(100)
        if WinWait("Notepad", , 2) {
            Send("n")
        }
    }
}

/**
 * Multiple window arrangement via dragging
 * Organizes windows into specific positions
 */
^F4:: {
    ToolTip("Arranging multiple windows...")

    ; Open two Notepad windows
    Run("notepad.exe")
    Sleep(500)
    Run("notepad.exe")
    Sleep(1000)

    ; Get all Notepad windows
    notepadWindows := WinGetList("ahk_class Notepad")

    if (notepadWindows.Length >= 2) {
        ; Drag first window to left half
        WinActivate("ahk_id " notepadWindows[1])
        Sleep(200)

        WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " notepadWindows[1])
        titleBarX := winX + winW // 2
        titleBarY := winY + 15

        Click(titleBarX, titleBarY, "Down")
        Sleep(100)
        MouseMove(A_ScreenWidth // 4, A_ScreenHeight // 2, 30)
        Sleep(100)
        Click("Up")
        Sleep(300)

        ; Drag second window to right half
        WinActivate("ahk_id " notepadWindows[2])
        Sleep(200)

        WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " notepadWindows[2])
        titleBarX := winX + winW // 2
        titleBarY := winY + 15

        Click(titleBarX, titleBarY, "Down")
        Sleep(100)
        MouseMove(A_ScreenWidth * 3 // 4, A_ScreenHeight // 2, 30)
        Sleep(100)
        Click("Up")

        ToolTip("Windows arranged!")
        Sleep(2000)
        ToolTip()

        ; Close windows
        WinClose("ahk_id " notepadWindows[1])
        WinClose("ahk_id " notepadWindows[2])
        Sleep(200)
        ; Don't save
        Send("nn")
    }
}

; ============================================================================
; Example 4: Selection Box Dragging
; ============================================================================

/**
 * Creates selection boxes by dragging.
 * Common in image editors, desktop selection, etc.
 *
 * @description
 * Simulates creating selection rectangles
 */
^F5:: {
    ToolTip("Creating selection box on desktop...")

    ; Show desktop
    Send("#d")
    Sleep(500)

    ; Create selection box by dragging
    startX := 200
    startY := 200
    endX := 500
    endY := 400

    ToolTip("Dragging selection box...")

    Click(startX, startY, "Down")
    Sleep(100)

    ; Drag to create selection rectangle
    MouseMove(endX, endY, 20)
    Sleep(500)  ; Hold to show selection

    Click("Up")

    ToolTip("Selection box created!")
    Sleep(1500)
    ToolTip()

    ; Click elsewhere to deselect
    Click(100, 100)
}

/**
 * Multi-item selection via drag
 * Selects multiple items with selection box
 */
^F6:: {
    ToolTip("Opening Explorer for multi-select demo...")

    Run("explorer.exe C:\Windows\System32")
    Sleep(1500)

    if WinWait("System32", , 5) {
        WinActivate("System32")
        Sleep(500)

        CoordMode("Mouse", "Window")

        ToolTip("Creating selection box over files...")

        ; Create selection box in file area
        Click(100, 150, "Down")
        Sleep(100)
        MouseMove(400, 350, 25)
        Sleep(500)
        Click("Up")

        ToolTip("Multiple files selected!")
        Sleep(2000)
        ToolTip()

        WinClose("System32")
        CoordMode("Mouse", "Screen")
    }
}

; ============================================================================
; Example 5: Paint/Drawing Dragging
; ============================================================================

/**
 * Simulates drawing in Paint or similar applications.
 * Demonstrates continuous dragging for artistic applications.
 *
 * @description
 * Opens Paint and draws shapes via dragging
 */
^F7:: {
    ToolTip("Opening Paint for drawing demo...")

    Run("mspaint.exe")
    Sleep(2000)

    if WinWait("Paint", , 5) {
        WinActivate("Paint")
        Sleep(500)

        CoordMode("Mouse", "Window")

        ToolTip("Drawing a line...")

        ; Draw a straight line
        Click(200, 200, "Down")
        Sleep(50)
        MouseMove(400, 200, 15)
        Sleep(50)
        Click("Up")
        Sleep(500)

        ToolTip("Drawing a diagonal line...")

        ; Draw diagonal line
        Click(200, 250, "Down")
        Sleep(50)
        MouseMove(400, 350, 15)
        Sleep(50)
        Click("Up")
        Sleep(500)

        ToolTip("Drawing a square...")

        ; Draw a square (four lines)
        ; Top
        Click(250, 400, "Down")
        Sleep(50)
        MouseMove(450, 400, 10)
        Sleep(50)
        Click("Up")
        Sleep(100)

        ; Right
        Click(450, 400, "Down")
        Sleep(50)
        MouseMove(450, 550, 10)
        Sleep(50)
        Click("Up")
        Sleep(100)

        ; Bottom
        Click(450, 550, "Down")
        Sleep(50)
        MouseMove(250, 550, 10)
        Sleep(50)
        Click("Up")
        Sleep(100)

        ; Left
        Click(250, 550, "Down")
        Sleep(50)
        MouseMove(250, 400, 10)
        Sleep(50)
        Click("Up")

        ToolTip("Drawing complete!")
        Sleep(2000)
        ToolTip()

        ; Close Paint without saving
        WinClose("Paint")
        Sleep(500)
        if WinWait("Paint", , 2) {
            Send("n")  ; Don't save
        }

        CoordMode("Mouse", "Screen")
    }
}

/**
 * Freehand drawing demonstration
 * Creates curved lines and shapes
 */
^F8:: {
    ToolTip("Freehand drawing demo...")

    Run("mspaint.exe")
    Sleep(2000)

    if WinWait("Paint", , 5) {
        WinActivate("Paint")
        Sleep(500)

        CoordMode("Mouse", "Window")

        ToolTip("Drawing freehand curve...")

        ; Draw a curved line by moving through multiple points
        Click(150, 300, "Down")
        Sleep(50)

        ; Create curve with intermediate points
        MouseMove(200, 250, 5)
        Sleep(30)
        MouseMove(250, 230, 5)
        Sleep(30)
        MouseMove(300, 250, 5)
        Sleep(30)
        MouseMove(350, 300, 5)
        Sleep(30)
        MouseMove(400, 380, 5)
        Sleep(50)

        Click("Up")

        ToolTip("Freehand curve complete!")
        Sleep(2000)
        ToolTip()

        WinClose("Paint")
        Sleep(500)
        if WinWait("Paint", , 2) {
            Send("n")
        }

        CoordMode("Mouse", "Screen")
    }
}

; ============================================================================
; Example 6: Slider Dragging
; ============================================================================

/**
 * Drags slider controls to specific values.
 * Useful for UI automation and testing.
 *
 * @description
 * Demonstrates precise slider manipulation
 */
^F9:: {
    ToolTip("Creating slider test GUI...")

    ; Create test GUI with slider
    sliderGui := Gui("+AlwaysOnTop", "Slider Drag Test")
    sliderGui.Add("Text", "w300", "Volume Control:")

    slider := sliderGui.Add("Slider", "w300 Range0-100 TickInterval10", 50)
    valueText := sliderGui.Add("Text", "w300", "Value: 50")

    ; Update text when slider changes
    slider.OnEvent("Change", (*) => valueText.Text := "Value: " slider.Value)

    sliderGui.Show("w320 h150")

    Sleep(1000)

    ; Get slider position
    slider.GetPos(&sliderX, &sliderY, &sliderW, &sliderH)
    sliderGui.GetPos(&guiX, &guiY)

    ; Calculate slider center
    sliderCenterX := guiX + sliderX + sliderW // 2
    sliderCenterY := guiY + sliderY + sliderH // 2

    ToolTip("Dragging slider to maximum...")

    ; Drag slider to maximum
    Click(sliderCenterX, sliderCenterY, "Down")
    Sleep(100)
    MouseMove(guiX + sliderX + sliderW - 10, sliderCenterY, 20)
    Sleep(100)
    Click("Up")
    Sleep(1000)

    ToolTip("Dragging slider to minimum...")

    ; Drag to minimum
    Click(sliderCenterX, sliderCenterY, "Down")
    Sleep(100)
    MouseMove(guiX + sliderX + 10, sliderCenterY, 20)
    Sleep(100)
    Click("Up")
    Sleep(1000)

    ToolTip("Dragging slider to center...")

    ; Drag to center
    Click(sliderCenterX, sliderCenterY, "Down")
    Sleep(100)
    MouseMove(guiX + sliderX + sliderW // 2, sliderCenterY, 20)
    Sleep(100)
    Click("Up")

    ToolTip("Slider test complete!")
    Sleep(2000)
    ToolTip()

    sliderGui.Destroy()
}

; ============================================================================
; Example 7: Advanced Drag Patterns
; ============================================================================

/**
 * Complex drag patterns for various applications.
 * Demonstrates circular, zigzag, and spiral dragging.
 *
 * @description
 * Useful for testing drag behavior and creating complex interactions
 */
^F10:: {
    ToolTip("Circular drag pattern...")

    ; Draw a circle using drag
    centerX := 400
    centerY := 400
    radius := 100
    steps := 36  ; 36 points for smooth circle

    ; Calculate start position
    startX := centerX + radius
    startY := centerY

    Click(startX, startY, "Down")
    Sleep(50)

    ; Draw circle
    Loop steps {
        angle := (A_Index / steps) * 2 * 3.14159
        x := centerX + radius * Cos(angle)
        y := centerY + radius * Sin(angle)

        MouseMove(x, y, 0)
        Sleep(20)
    }

    Click("Up")

    ToolTip("Circle complete!")
    Sleep(1500)
    ToolTip()
}

/**
 * Zigzag drag pattern
 * Creates back-and-forth dragging motion
 */
^F11:: {
    ToolTip("Zigzag drag pattern...")

    startX := 200
    startY := 300
    amplitude := 50
    length := 400

    Click(startX, startY, "Down")
    Sleep(50)

    ; Create zigzag
    steps := 20
    Loop steps {
        progress := A_Index / steps
        x := startX + (length * progress)
        y := startY + (Mod(A_Index, 2) = 0 ? amplitude : -amplitude)

        MouseMove(x, y, 5)
        Sleep(30)
    }

    Click("Up")

    ToolTip("Zigzag complete!")
    Sleep(1500)
    ToolTip()
}

/**
 * Spiral drag pattern
 * Creates expanding spiral motion
 */
^F12:: {
    ToolTip("Spiral drag pattern...")

    centerX := 400
    centerY := 400
    maxRadius := 150
    revolutions := 3

    startX := centerX
    startY := centerY

    Click(startX, startY, "Down")
    Sleep(50)

    ; Draw spiral
    steps := 100
    Loop steps {
        progress := A_Index / steps
        angle := progress * revolutions * 2 * 3.14159
        radius := maxRadius * progress

        x := centerX + radius * Cos(angle)
        y := centerY + radius * Sin(angle)

        MouseMove(x, y, 0)
        Sleep(15)
    }

    Click("Up")

    ToolTip("Spiral complete!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Smooth drag function with acceleration
 *
 * @param {Number} x1 - Start X
 * @param {Number} y1 - Start Y
 * @param {Number} x2 - End X
 * @param {Number} y2 - End Y
 * @param {Number} steps - Number of intermediate steps
 */
SmoothDrag(x1, y1, x2, y2, steps := 20) {
    Click(x1, y1, "Down")
    Sleep(50)

    Loop steps {
        progress := A_Index / steps
        x := x1 + (x2 - x1) * progress
        y := y1 + (y2 - y1) * progress

        MouseMove(x, y, 0)
        Sleep(20)
    }

    Click("Up")
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    Drag Operations Help
    ====================

    F1 - Basic drag operation
    F2 - Right-button drag
    F3 - Slow smooth drag

    Ctrl+F1  - File drag-and-drop
    Ctrl+F2  - Desktop icon rearrange
    Ctrl+F3  - Window dragging
    Ctrl+F4  - Multiple window arrangement
    Ctrl+F5  - Selection box dragging
    Ctrl+F6  - Multi-item selection
    Ctrl+F7  - Paint drawing demo
    Ctrl+F8  - Freehand drawing
    Ctrl+F9  - Slider dragging
    Ctrl+F10 - Circular drag pattern
    Ctrl+F11 - Zigzag pattern
    Ctrl+F12 - Spiral pattern

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Drag Operations Help")
}
