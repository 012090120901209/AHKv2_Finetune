#Requires AutoHotkey v2.0

/**
* BuiltIn_CoordMode_01_MouseCoordinates.ahk
*
* DESCRIPTION:
* Demonstrates how to use CoordMode to control mouse coordinate systems
* for clicking, moving, and positioning relative to windows or screen.
*
* FEATURES:
* - Screen vs Window vs Client coordinate modes
* - Mouse clicking with different coordinate modes
* - Coordinate conversion between modes
* - Practical examples of coordinate-dependent automation
* - Mouse position tracking across modes
*
* SOURCE:
* AutoHotkey v2 Documentation
*
* KEY V2 FEATURES DEMONSTRATED:
* - CoordMode function syntax
* - MouseClick with coordinate modes
* - MouseMove coordinate handling
* - MouseGetPos coordinate retrieval
* - Window-relative positioning
*
* LEARNING POINTS:
* 1. CoordMode affects how coordinates are interpreted
* 2. Screen mode uses absolute screen coordinates
* 3. Window mode is relative to active window
* 4. Client mode excludes title bar and borders
* 5. Default mode can vary by function
* 6. Always set CoordMode explicitly for reliability
* 7. Coordinate modes persist until changed
*/

;===============================================================================
; EXAMPLE 1: Basic CoordMode - Screen vs Window vs Client
;===============================================================================

Example1_BasicCoordModes() {
    ; Create a test window
    testGui := Gui(, "CoordMode Test Window")
    testGui.Add("Text", "x10 y10 w300", "This window demonstrates coordinate modes")
    testGui.Add("Button", "x10 y40 w100 h30", "Target Button")
    testGui.Show("w320 h100")

    Sleep 1000

    ; Store original mode
    originalMode := CoordMode("Mouse")

    ; SCREEN MODE - Absolute screen coordinates
    CoordMode("Mouse", "Screen")
    MouseGetPos(&xScreen, &yScreen)
    MsgBox("Screen Mode Coordinates:`n"
    . "X: " xScreen " Y: " yScreen
    . "`n`nThese are absolute screen positions")

    ; WINDOW MODE - Relative to active window (includes title bar)
    CoordMode("Mouse", "Window")
    MouseGetPos(&xWindow, &yWindow)
    MsgBox("Window Mode Coordinates:`n"
    . "X: " xWindow " Y: " yWindow
    . "`n`nRelative to window top-left (includes title bar)")

    ; CLIENT MODE - Relative to client area (excludes title bar)
    CoordMode("Mouse", "Client")
    MouseGetPos(&xClient, &yClient)
    MsgBox("Client Mode Coordinates:`n"
    . "X: " xClient " Y: " yClient
    . "`n`nRelative to client area (excludes title bar)")

    ; Comparison
    MsgBox("Coordinate Comparison:`n"
    . "Screen: (" xScreen ", " yScreen ")`n"
    . "Window: (" xWindow ", " yWindow ")`n"
    . "Client: (" xClient ", " yClient ")`n`n"
    . "Notice how the values differ!")

    ; Restore original mode
    CoordMode("Mouse", originalMode)
    testGui.Destroy()
}

;===============================================================================
; EXAMPLE 2: Clicking with Different CoordModes
;===============================================================================

Example2_ClickingWithCoordModes() {
    ; Create a GUI with multiple buttons
    clickGui := Gui(, "Click Testing Window")
    clickGui.Add("Text", "x10 y10 w300", "Watch which button gets clicked in each mode")

    btn1 := clickGui.Add("Button", "x10 y40 w80 h30", "Button 1")
    btn2 := clickGui.Add("Button", "x100 y40 w80 h30", "Button 2")
    btn3 := clickGui.Add("Button", "x190 y40 w80 h30", "Button 3")

    btn1.OnEvent("Click", (*) => MsgBox("Button 1 clicked!"))
    btn2.OnEvent("Click", (*) => MsgBox("Button 2 clicked!"))
    btn3.OnEvent("Click", (*) => MsgBox("Button 3 clicked!"))

    clickGui.Show("w290 h90")
    WinWait("Click Testing Window")

    Sleep 500

    ; Click Button 2 using CLIENT coordinates
    CoordMode("Mouse", "Client")
    MsgBox("Clicking Button 2 using CLIENT coordinates (140, 55)")
    MouseClick("Left", 140, 55)
    Sleep 1000

    ; Click Button 1 using WINDOW coordinates (includes title bar)
    CoordMode("Mouse", "Window")
    WinGetPos(, , &width, &height, "Click Testing Window")
    titleBarHeight := 30  ; Approximate title bar height

    MsgBox("Clicking Button 1 using WINDOW coordinates`n"
    . "Y coordinate includes title bar height")
    MouseClick("Left", 50, 40 + titleBarHeight)
    Sleep 1000

    ; Click Button 3 using SCREEN coordinates
    CoordMode("Mouse", "Screen")
    WinGetPos(&winX, &winY, , , "Click Testing Window")
    screenX := winX + 230  ; Button 3 X position + window offset
    screenY := winY + 55   ; Button 3 Y position + window offset

    MsgBox("Clicking Button 3 using SCREEN coordinates`n"
    . "X: " screenX " Y: " screenY)
    MouseClick("Left", screenX, screenY)
    Sleep 1000

    clickGui.Destroy()
    CoordMode("Mouse", "Screen")  ; Reset to default
}

;===============================================================================
; EXAMPLE 3: Coordinate Conversion Utility
;===============================================================================

Example3_CoordinateConverter() {
    ; Create a coordinate converter tool
    converterGui := Gui(, "Coordinate Converter")
    converterGui.Add("Text", "x10 y10 w300", "Click anywhere to see coordinates in all modes")

    ; Add text fields to display coordinates
    converterGui.Add("Text", "x10 y40", "Screen:")
    screenText := converterGui.Add("Edit", "x80 y35 w200 ReadOnly", "")

    converterGui.Add("Text", "x10 y70", "Window:")
    windowText := converterGui.Add("Edit", "x80 y65 w200 ReadOnly", "")

    converterGui.Add("Text", "x10 y100", "Client:")
    clientText := converterGui.Add("Edit", "x80 y95 w200 ReadOnly", "")

    btnTrack := converterGui.Add("Button", "x10 y130 w270 h30", "Start Tracking (F2 to capture)")
    btnStop := converterGui.Add("Button", "x10 y170 w270 h30", "Stop Tracking")

    tracking := false

    TrackMouse(*) {
        tracking := true
        SetTimer(UpdateCoordinates, 100)
        btnTrack.Enabled := false
        btnStop.Enabled := true
    }

    StopTracking(*) {
        tracking := false
        SetTimer(UpdateCoordinates, 0)
        btnTrack.Enabled := true
        btnStop.Enabled := false
    }

    UpdateCoordinates() {
        if !tracking
        return

        ; Get screen coordinates
        CoordMode("Mouse", "Screen")
        MouseGetPos(&xScreen, &yScreen)

        ; Get window coordinates
        CoordMode("Mouse", "Window")
        MouseGetPos(&xWindow, &yWindow)

        ; Get client coordinates
        CoordMode("Mouse", "Client")
        MouseGetPos(&xClient, &yClient)

        ; Update display
        screenText.Value := "X: " xScreen ", Y: " yScreen
        windowText.Value := "X: " xWindow ", Y: " yWindow
        clientText.Value := "X: " xClient ", Y: " yClient
    }

    btnTrack.OnEvent("Click", TrackMouse)
    btnStop.OnEvent("Click", StopTracking)
    btnStop.Enabled := false

    ; Hotkey to capture current position
    HotKey("F2", (*) => MsgBox("Current Position:`n"
    . "Screen: " screenText.Value "`n"
    . "Window: " windowText.Value "`n"
    . "Client: " clientText.Value, "Captured"))

    converterGui.OnEvent("Close", (*) => (StopTracking(), converterGui.Destroy()))
    converterGui.Show("w300 h220")

    MsgBox("Click 'Start Tracking' to see real-time coordinates`n"
    . "Press F2 to capture current position", "Instructions")
}

;===============================================================================
; EXAMPLE 4: Multi-Monitor Coordinate Handling
;===============================================================================

Example4_MultiMonitorCoords() {
    ; Get monitor information
    monitorCount := MonitorGetCount()
    primaryMonitor := MonitorGetPrimary()

    info := "Multi-Monitor Setup:`n"
    info .= "Monitor Count: " monitorCount "`n"
    info .= "Primary Monitor: " primaryMonitor "`n`n"

    ; Get bounds for each monitor
    Loop monitorCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        info .= "Monitor " A_Index ":`n"
        info .= "  Left: " Left ", Top: " Top "`n"
        info .= "  Right: " Right ", Bottom: " Bottom "`n"
        info .= "  Width: " (Right - Left) ", Height: " (Bottom - Top) "`n`n"
    }

    MsgBox(info, "Monitor Information")

    ; Demonstrate moving mouse across monitors using Screen coordinates
    CoordMode("Mouse", "Screen")

    if monitorCount > 1 {
        MsgBox("Will move mouse to center of each monitor", "Multi-Monitor Demo")

        Loop monitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            centerX := Left + (Right - Left) // 2
            centerY := Top + (Bottom - Top) // 2

            ToolTip("Moving to Monitor " A_Index " center")
            MouseMove(centerX, centerY)
            Sleep(1000)
        }

        ToolTip()
    } else {
        MsgBox("Single monitor detected. Screen coordinates cover entire display.",
        "Single Monitor")
    }
}

;===============================================================================
; EXAMPLE 5: Drawing Application with CoordMode
;===============================================================================

Example5_DrawingWithCoordMode() {
    ; Create a simple drawing canvas
    drawGui := Gui(, "Drawing Canvas - Hold Left Button to Draw")
    drawGui.BackColor := "White"

    ; Create a picture control for drawing
    canvas := drawGui.Add("Picture", "x10 y10 w400 h300 Border")

    ; Add mode selector
    drawGui.Add("Text", "x10 y320", "Coordinate Mode:")
    modeSelect := drawGui.Add("DropDownList", "x110 y315 w100 Choose1",
    ["Client", "Window", "Screen"])

    btnClear := drawGui.Add("Button", "x220 y315 w80", "Clear")
    btnClose := drawGui.Add("Button", "x310 y315 w100", "Close")

    drawGui.Show("w420 h355")

    ; Drawing state
    isDrawing := false
    lastX := 0
    lastY := 0
    points := []

    ; Set up drawing with mouse
    drawGui.OnEvent("Close", (*) => drawGui.Destroy())
    btnClose.OnEvent("Click", (*) => drawGui.Destroy())

    btnClear.OnEvent("Click", (*) => (
    points := [],
    canvas.Value := "",
    MsgBox("Canvas cleared!", "Drawing")
    ))

    modeSelect.OnEvent("Change", (*) => (
    CoordMode("Mouse", modeSelect.Text),
    MsgBox("Coordinate mode changed to: " modeSelect.Text, "Mode Changed")
    ))

    ; Set initial coordinate mode
    CoordMode("Mouse", "Client")

    ; Note: Full drawing implementation would require Windows GDI calls
    MsgBox("This demonstrates how CoordMode affects drawing applications.`n`n"
    . "Key Points:`n"
    . "- CLIENT mode: Best for drawing within a control`n"
    . "- WINDOW mode: Includes title bar in coordinates`n"
    . "- SCREEN mode: For cross-window drawing`n`n"
    . "The coordinate mode affects how mouse positions are interpreted.",
    "Drawing Demo")
}

;===============================================================================
; EXAMPLE 6: Window Element Inspector
;===============================================================================

Example6_WindowInspector() {
    ; Create inspector GUI
    inspectorGui := Gui(, "Window Element Inspector")

    inspectorGui.Add("Text", "x10 y10 w300",
    "Hover over window elements to inspect coordinates")

    inspectorGui.Add("Text", "x10 y40", "Window Title:")
    winTitle := inspectorGui.Add("Edit", "x100 y35 w280 ReadOnly", "")

    inspectorGui.Add("Text", "x10 y70", "Control:")
    ctrlInfo := inspectorGui.Add("Edit", "x100 y65 w280 ReadOnly", "")

    inspectorGui.Add("Text", "x10 y100", "Screen Pos:")
    screenPos := inspectorGui.Add("Edit", "x100 y95 w280 ReadOnly", "")

    inspectorGui.Add("Text", "x10 y130", "Window Pos:")
    windowPos := inspectorGui.Add("Edit", "x100 y125 w280 ReadOnly", "")

    inspectorGui.Add("Text", "x10 y160", "Client Pos:")
    clientPos := inspectorGui.Add("Edit", "x100 y155 w280 ReadOnly", "")

    btnStart := inspectorGui.Add("Button", "x10 y190 w180 h30", "Start Inspecting (F3)")
    btnStop := inspectorGui.Add("Button", "x200 y190 w180 h30", "Stop")

    inspecting := false

    StartInspecting(*) {
        inspecting := true
        SetTimer(InspectElement, 100)
        btnStart.Enabled := false
        btnStop.Enabled := true
    }

    StopInspecting(*) {
        inspecting := false
        SetTimer(InspectElement, 0)
        btnStart.Enabled := true
        btnStop.Enabled := false
    }

    InspectElement() {
        if !inspecting
        return

        ; Get window under mouse
        CoordMode("Mouse", "Screen")
        MouseGetPos(&xScr, &yScr, &windowID, &controlID)

        ; Get window title
        try {
            title := WinGetTitle("ahk_id " windowID)
            winTitle.Value := title
        } catch {
            winTitle.Value := "N/A"
        }

        ; Get control info
        try {
            ctrl := ControlGetClassNN(controlID)
            ctrlInfo.Value := ctrl
        } catch {
            ctrlInfo.Value := "N/A"
        }

        ; Update coordinates in all modes
        CoordMode("Mouse", "Screen")
        MouseGetPos(&xs, &ys)
        screenPos.Value := "X: " xs ", Y: " ys

        CoordMode("Mouse", "Window")
        MouseGetPos(&xw, &yw)
        windowPos.Value := "X: " xw ", Y: " yw

        CoordMode("Mouse", "Client")
        MouseGetPos(&xc, &yc)
        clientPos.Value := "X: " xc ", Y: " yc
    }

    btnStart.OnEvent("Click", StartInspecting)
    btnStop.OnEvent("Click", StopInspecting)
    btnStop.Enabled := false

    HotKey("F3", (*) => inspecting ? StopInspecting() : StartInspecting())

    inspectorGui.OnEvent("Close", (*) => (StopInspecting(), inspectorGui.Destroy()))
    inspectorGui.Show("w400 h240")
}

;===============================================================================
; EXAMPLE 7: Automated Form Filling with CoordMode
;===============================================================================

Example7_FormFillingAutomation() {
    ; Create a sample form
    formGui := Gui(, "Sample Registration Form")

    formGui.Add("Text", "x10 y10", "First Name:")
    firstName := formGui.Add("Edit", "x100 y5 w200", "")

    formGui.Add("Text", "x10 y40", "Last Name:")
    lastName := formGui.Add("Edit", "x100 y35 w200", "")

    formGui.Add("Text", "x10 y70", "Email:")
    email := formGui.Add("Edit", "x100 y65 w200", "")

    formGui.Add("Text", "x10 y100", "Phone:")
    phone := formGui.Add("Edit", "x100 y95 w200", "")

    submit := formGui.Add("Button", "x100 y130 w100 h30", "Submit")
    autoFill := formGui.Add("Button", "x210 y130 w90 h30", "Auto-Fill")

    submit.OnEvent("Click", (*) => MsgBox("Form submitted!", "Success"))

    ; Auto-fill function using CLIENT coordinates
    AutoFillForm(*) {
        ; Ensure we're using client coordinates
        CoordMode("Mouse", "Client")

        ; Store original mouse position
        MouseGetPos(&origX, &origY)

        ; Fill first name
        MouseClick("Left", 200, 20)
        Send("John")
        Sleep(200)

        ; Fill last name
        MouseClick("Left", 200, 50)
        Send("Doe")
        Sleep(200)

        ; Fill email
        MouseClick("Left", 200, 80)
        Send("john.doe@example.com")
        Sleep(200)

        ; Fill phone
        MouseClick("Left", 200, 110)
        Send("555-1234")
        Sleep(200)

        ; Return to original position
        MouseMove(origX, origY)

        MsgBox("Form auto-filled using CLIENT coordinate mode!`n`n"
        . "This ensures coordinates are relative to the form,`n"
        . "not the screen or window frame.", "Auto-Fill Complete")
    }

    autoFill.OnEvent("Click", AutoFillForm)

    formGui.Show("w320 h180")

    MsgBox("Click 'Auto-Fill' to see automated form filling.`n`n"
    . "Using CLIENT coordinates ensures the automation`n"
    . "works regardless of window position.", "Form Demo")
}

;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run specific examples:
; Example1_BasicCoordModes()
; Example2_ClickingWithCoordModes()
; Example3_CoordinateConverter()
; Example4_MultiMonitorCoords()
; Example5_DrawingWithCoordMode()
; Example6_WindowInspector()
; Example7_FormFillingAutomation()
