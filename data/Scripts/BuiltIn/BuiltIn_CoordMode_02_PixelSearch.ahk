#Requires AutoHotkey v2.0

/**
 * BuiltIn_CoordMode_02_PixelSearch.ahk
 * 
 * DESCRIPTION:
 * Demonstrates how CoordMode affects pixel search and color detection
 * operations, crucial for image-based automation and game scripting.
 * 
 * FEATURES:
 * - PixelSearch with different coordinate modes
 * - PixelGetColor coordinate handling
 * - Color matching and tolerance
 * - Region-based pixel detection
 * - Screen capture automation
 * - Color picker tool implementation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - CoordMode for Pixel operations
 * - PixelSearch function
 * - PixelGetColor function
 * - Error handling with Try/Catch
 * - Real-time color monitoring
 * 
 * LEARNING POINTS:
 * 1. Pixel operations default to Screen coordinates
 * 2. CoordMode affects search region interpretation
 * 3. Color values are in RGB hex format
 * 4. Variation parameter allows color tolerance
 * 5. Fast mode vs slow mode for pixel search
 * 6. Coordinate modes crucial for multi-window scenarios
 * 7. PixelGetColor always uses current coordinate mode
 */

;===============================================================================
; EXAMPLE 1: Basic Pixel Color Detection
;===============================================================================

Example1_BasicPixelColor() {
    ; Create a color palette window
    paletteGui := Gui(, "Pixel Color Detection Demo")

    ; Add colored boxes
    paletteGui.BackColor := "White"

    redBox := paletteGui.Add("Progress", "x10 y10 w80 h80 Background" "Red")
    greenBox := paletteGui.Add("Progress", "x100 y10 w80 h80 Background" "Green")
    blueBox := paletteGui.Add("Progress", "x190 y10 w80 h80 Background" "Blue")

    yellowBox := paletteGui.Add("Progress", "x10 y100 w80 h80 Background" "Yellow")
    cyanBox := paletteGui.Add("Progress", "x100 y100 w80 h80 Background" "Cyan")
    magentaBox := paletteGui.Add("Progress", "x190 y100 w80 h80 Background" "Magenta")

    ; Add info display
    paletteGui.Add("Text", "x10 y200", "Click on any color box")
    colorInfo := paletteGui.Add("Edit", "x10 y220 w260 h100 ReadOnly Multi", "")

    paletteGui.Show("w280 h340")

    ; Wait for window to be ready
    WinWait("Pixel Color Detection Demo")
    Sleep(500)

    ; Demonstrate pixel detection in different modes
    MsgBox("This demo shows pixel color detection.`n`n"
        . "We'll detect colors using different coordinate modes.", "Demo Start")

    ; Using SCREEN coordinates
    CoordMode("Pixel", "Screen")
    WinGetPos(&winX, &winY, , , "Pixel Color Detection Demo")

    ; Detect red box center (screen coordinates)
    redCenterX := winX + 50
    redCenterY := winY + 50

    color := PixelGetColor(redCenterX, redCenterY)
    colorInfo.Value := "SCREEN Mode Detection:`n"
    colorInfo.Value .= "Position: (" redCenterX ", " redCenterY ")`n"
    colorInfo.Value .= "Color: " color "`n"
    colorInfo.Value .= "This is the RED box`n`n"

    Sleep(2000)

    ; Using CLIENT coordinates
    CoordMode("Pixel", "Client")
    color := PixelGetColor(50, 50)
    colorInfo.Value .= "CLIENT Mode Detection:`n"
    colorInfo.Value .= "Position: (50, 50)`n"
    colorInfo.Value .= "Color: " color "`n"
    colorInfo.Value .= "Same RED box, different coordinate mode"

    MsgBox("Notice how we can detect the same pixel using different coordinate modes.",
        "Coordinate Modes")

    paletteGui.Destroy()
}

;===============================================================================
; EXAMPLE 2: PixelSearch for Finding Colors
;===============================================================================

Example2_PixelSearchDemo() {
    ; Create a target finding game
    gameGui := Gui(, "Find the Target Game")
    gameGui.BackColor := "0xCCCCCC"

    ; Random target position
    ; Random target position
    targetX := Random(50, 350)
    targetY := Random(50, 250)

    ; Add instructions
    gameGui.Add("Text", "x10 y10 w380",
        "A red target is hidden somewhere. Click 'Search' to find it!")

    searchBtn := gameGui.Add("Button", "x10 y40 w100 h30", "Search")
    resultText := gameGui.Add("Edit", "x10 y80 w380 h200 ReadOnly Multi", "")

    gameGui.Show("w400 h300")

    ; Create target (small red square)
    targetGui := Gui("+ToolWindow -Caption +AlwaysOnTop")
    targetGui.BackColor := "Red"
    targetGui.Show("x" targetX " y" targetY " w20 h20")

    SearchForTarget(*) {
        resultText.Value := "Searching for red pixel...$n`n"

        ; Use SCREEN coordinates for search
        CoordMode("Pixel", "Screen")

        ; Get search area (entire screen)
        MonitorGet(MonitorGetPrimary(), &Left, &Top, &Right, &Bottom)

        resultText.Value .= "Search Area:`n"
        resultText.Value .= "  Left: " Left ", Top: " Top "`n"
        resultText.Value .= "  Right: " Right ", Bottom: " Bottom "`n`n"

        ; Search for pure red color (0xFF0000)
        startTime := A_TickCount

        try {
            if PixelSearch(&foundX, &foundY, Left, Top, Right, Bottom, 0xFF0000, 0) {
                endTime := A_TickCount
                duration := endTime - startTime

                resultText.Value .= "TARGET FOUND!`n"
                resultText.Value .= "Position: (" foundX ", " foundY ")`n"
                resultText.Value .= "Search Time: " duration "ms`n`n"

                ; Highlight the found target
                CoordMode("Mouse", "Screen")
                MouseMove(foundX, foundY)

                ; Draw circle around it using ToolTip
                ToolTip("Found Here!", foundX + 25, foundY)
                SetTimer(() => ToolTip(), -3000)
            } else {
                resultText.Value .= "Target not found!`n"
            }
        } catch Error as err {
            resultText.Value .= "Error: " err.Message "`n"
        }
    }

    searchBtn.OnEvent("Click", SearchForTarget)

    gameGui.OnEvent("Close", (*) => (targetGui.Destroy(), gameGui.Destroy()))

    MsgBox("Click 'Search' to automatically find the red target!", "Instructions")
}

;===============================================================================
; EXAMPLE 3: Color Picker Tool with Real-time Display
;===============================================================================

Example3_ColorPickerTool() {
    ; Create color picker GUI
    pickerGui := Gui(, "Advanced Color Picker Tool")

    pickerGui.Add("Text", "x10 y10 w300",
        "Hover anywhere on screen to pick colors (F4 to freeze)")

    ; Color preview box
    pickerGui.Add("Text", "x10 y40", "Preview:")
    colorPreview := pickerGui.Add("Progress", "x70 y35 w100 h40 Background" "White")

    ; Coordinate display
    pickerGui.Add("Text", "x10 y85", "Position:")
    posDisplay := pickerGui.Add("Edit", "x70 y80 w200 ReadOnly", "")

    ; Color values
    pickerGui.Add("Text", "x10 y115", "Hex:")
    hexDisplay := pickerGui.Add("Edit", "x70 y110 w200 ReadOnly", "")

    pickerGui.Add("Text", "x10 y145", "RGB:")
    rgbDisplay := pickerGui.Add("Edit", "x70 y140 w200 ReadOnly", "")

    pickerGui.Add("Text", "x10 y175", "Red:")
    redValue := pickerGui.Add("Edit", "x70 y170 w60 ReadOnly", "")

    pickerGui.Add("Text", "x140 y175", "Green:")
    greenValue := pickerGui.Add("Edit", "x190 y170 w60 ReadOnly", "")

    pickerGui.Add("Text", "x10 y205", "Blue:")
    blueValue := pickerGui.Add("Edit", "x70 y200 w60 ReadOnly", "")

    ; Color history
    pickerGui.Add("Text", "x10 y235", "History:")
    historyList := pickerGui.Add("ListBox", "x70 y230 w200 h80", [])

    btnStart := pickerGui.Add("Button", "x10 y320 w130 h30", "Start Picking")
    btnStop := pickerGui.Add("Button", "x150 y320 w120 h30", "Stop")

    pickerGui.Show("w285 h365")

    isPicking := false
    colorHistory := []

    StartPicking(*) {
        isPicking := true
        SetTimer(UpdateColorInfo, 50)
        btnStart.Enabled := false
        btnStop.Enabled := true
    }

    StopPicking(*) {
        isPicking := false
        SetTimer(UpdateColorInfo, 0)
        btnStart.Enabled := true
        btnStop.Enabled := false
    }

    UpdateColorInfo() {
        if !isPicking
            return

        ; Use screen coordinates
        CoordMode("Pixel", "Screen")
        CoordMode("Mouse", "Screen")

        MouseGetPos(&x, &y)
        color := PixelGetColor(x, y)

        ; Update position
        posDisplay.Value := x ", " y

        ; Update color preview
        colorPreview.Opt("Background" color)

        ; Update hex value
        hexDisplay.Value := color

        ; Extract RGB components
        red := (color >> 16) & 0xFF
        green := (color >> 8) & 0xFF
        blue := color & 0xFF

        ; Update RGB display
        rgbDisplay.Value := red ", " green ", " blue
        redValue.Value := red
        greenValue.Value := green
        blueValue.Value := blue
    }

    ; Freeze color on F4
    HotKey("F4", (*) => (
        SaveColor(),
        MsgBox("Color saved to history!", "Saved")
    ))

    SaveColor() {
        if !isPicking
            return

        CoordMode("Pixel", "Screen")
        CoordMode("Mouse", "Screen")
        MouseGetPos(&x, &y)
        color := PixelGetColor(x, y)

        ; Add to history
        colorHistory.Push(color)
        historyList.Add([color])

        StopPicking()
    }

    btnStart.OnEvent("Click", StartPicking)
    btnStop.OnEvent("Click", StopPicking)
    btnStop.Enabled := false

    pickerGui.OnEvent("Close", (*) => (StopPicking(), pickerGui.Destroy()))

    MsgBox("Move mouse anywhere and press F4 to capture color!", "Instructions")
}

;===============================================================================
; EXAMPLE 4: Region-Based Pixel Search
;===============================================================================

Example4_RegionPixelSearch() {
    ; Create a GUI with multiple regions
    regionGui := Gui(, "Region-Based Pixel Search")

    ; Region 1: Red zone
    regionGui.Add("Text", "x10 y10", "Region 1 (Red)")
    region1 := regionGui.Add("Progress", "x10 y30 w150 h100 Background" "Red")

    ; Region 2: Green zone
    regionGui.Add("Text", "x170 y10", "Region 2 (Green)")
    region2 := regionGui.Add("Progress", "x170 y30 w150 h100 Background" "Green")

    ; Region 3: Blue zone
    regionGui.Add("Text", "x10 y140", "Region 3 (Blue)")
    region3 := regionGui.Add("Progress", "x10 y170 w150 h100 Background" "Blue")

    ; Region 4: Yellow zone
    regionGui.Add("Text", "x170 y140", "Region 4 (Yellow)")
    region4 := regionGui.Add("Progress", "x170 y170 w150 h100 Background" "Yellow")

    ; Search controls
    regionGui.Add("Text", "x10 y285", "Search for:")
    colorInput := regionGui.Add("Edit", "x80 y280 w80", "0xFF0000")
    searchBtn := regionGui.Add("Button", "x170 y278 w80", "Search")

    resultDisplay := regionGui.Add("Edit", "x10 y310 w310 h80 ReadOnly Multi", "")

    regionGui.Show("w340 h410")
    WinWait("Region-Based Pixel Search")

    SearchInRegions(*) {
        searchColor := colorInput.Value
        resultDisplay.Value := "Searching for color: " searchColor "`n`n"

        ; Convert hex string to number
        colorNum := Integer(searchColor)

        ; Use CLIENT coordinates for searching within window
        CoordMode("Pixel", "Client")

        ; Define regions (in client coordinates)
        regions := [{
            name: "Region 1 (Red)", x1: 10, y1: 30, x2: 160, y2: 130 }, {
                name: "Region 2 (Green)", x1: 170, y1: 30, x2: 320, y2: 130 }, {
                    name: "Region 3 (Blue)", x1: 10, y1: 170, x2: 160, y2: 270 }, {
                        name: "Region 4 (Yellow)", x1: 170, y1: 170, x2: 320, y2: 270
                    }
        ]

        foundCount := 0

        ; Search each region
        for index, region in regions {
            try {
                if PixelSearch(&fx, &fy, region.x1, region.y1,
                    region.x2, region.y2, colorNum, 3) {
                    resultDisplay.Value .= "✓ Found in " region.name "`n"
                    resultDisplay.Value .= "  at (" fx ", " fy ")`n"
                    foundCount++
                } else {
                    resultDisplay.Value .= "✗ Not in " region.name "`n"
                }
            } catch {
                resultDisplay.Value .= "✗ Error searching " region.name "`n"
            }
        }

        resultDisplay.Value .= "`nTotal regions with color: " foundCount
    }

    searchBtn.OnEvent("Click", SearchInRegions)

    MsgBox("Enter a color in hex format (e.g., 0xFF0000 for red)`n"
        . "and click Search to find it in specific regions.", "Instructions")

    regionGui.Destroy()
}

;===============================================================================
; EXAMPLE 5: Screen Change Detection
;===============================================================================

Example5_ScreenChangeDetection() {
    ; Create monitoring GUI
    monitorGui := Gui(, "Screen Change Detector")

    monitorGui.Add("Text", "x10 y10 w380",
        "Monitor a screen region for color changes")

    ; Region selection
    monitorGui.Add("Text", "x10 y40", "Monitor Region:")
    monitorGui.Add("Text", "x10 y65", "X1:")
    x1Input := monitorGui.Add("Edit", "x35 y60 w50", "100")
    monitorGui.Add("Text", "x95 y65", "Y1:")
    y1Input := monitorGui.Add("Edit", "x120 y60 w50", "100")

    monitorGui.Add("Text", "x10 y95", "X2:")
    x2Input := monitorGui.Add("Edit", "x35 y90 w50", "200")
    monitorGui.Add("Text", "x95 y95", "Y2:")
    y2Input := monitorGui.Add("Edit", "x120 y90 w50", "200")

    btnCapture := monitorGui.Add("Button", "x180 y60 w100 h30", "Capture")
    btnStart := monitorGui.Add("Button", "x180 y95 w100 h30", "Start Monitor")
    btnStop := monitorGui.Add("Button", "x290 y95 w100 h30", "Stop")

    ; Log display
    logDisplay := monitorGui.Add("Edit", "x10 y135 w380 h200 ReadOnly Multi", "")

    monitorGui.Show("w400 h355")

    isMonitoring := false
    baselineColors := Map()

    CaptureBaseline(*) {
        CoordMode("Pixel", "Screen")

        x1 := Integer(x1Input.Value)
        y1 := Integer(y1Input.Value)
        x2 := Integer(x2Input.Value)
        y2 := Integer(y2Input.Value)

        logDisplay.Value := "Capturing baseline colors...`n"

        ; Sample multiple points in the region
        samplePoints := []
        stepX := (x2 - x1) // 5
        stepY := (y2 - y1) // 5

        Loop 25 {
            row := (A_Index - 1) // 5
            col := Mod(A_Index - 1, 5)
            px := x1 + (col * stepX)
            py := y1 + (row * stepY)

            color := PixelGetColor(px, py)
            baselineColors[A_Index] := color
            samplePoints.Push({ x: px, y: py, color: color })
        }

        logDisplay.Value .= "Captured " baselineColors.Count " sample points`n"
        logDisplay.Value .= "Ready to monitor for changes!`n"

        btnStart.Enabled := true
    }

    StartMonitoring(*) {
        if baselineColors.Count = 0 {
            MsgBox("Please capture baseline first!", "Error")
            return
        }

        isMonitoring := true
        SetTimer(CheckForChanges, 500)
        btnStart.Enabled := false
        btnStop.Enabled := true
        logDisplay.Value .= "`nMonitoring started...`n"
    }

    StopMonitoring(*) {
        isMonitoring := false
        SetTimer(CheckForChanges, 0)
        btnStart.Enabled := true
        btnStop.Enabled := false
        logDisplay.Value .= "Monitoring stopped.`n"
    }

    CheckForChanges() {
        if !isMonitoring
            return

        CoordMode("Pixel", "Screen")

        x1 := Integer(x1Input.Value)
        y1 := Integer(y1Input.Value)
        x2 := Integer(x2Input.Value)
        y2 := Integer(y2Input.Value)

        stepX := (x2 - x1) // 5
        stepY := (y2 - y1) // 5

        changesDetected := 0

        Loop 25 {
            row := (A_Index - 1) // 5
            col := Mod(A_Index - 1, 5)
            px := x1 + (col * stepX)
            py := y1 + (row * stepY)

            currentColor := PixelGetColor(px, py)
            baselineColor := baselineColors[A_Index]

            if currentColor != baselineColor {
                changesDetected++
            }
        }

        if changesDetected > 0 {
            timestamp := FormatTime(, "HH:mm:ss")
            logDisplay.Value .= "[" timestamp "] Change detected! "
            logDisplay.Value .= changesDetected " points changed`n"

            ; Optional: Stop monitoring after detection
            ; StopMonitoring()
        }
    }

    btnCapture.OnEvent("Click", CaptureBaseline)
    btnStart.OnEvent("Click", StartMonitoring)
    btnStop.OnEvent("Click", StopMonitoring)
    btnStart.Enabled := false
    btnStop.Enabled := false

    monitorGui.OnEvent("Close", (*) => (StopMonitoring(), monitorGui.Destroy()))
}

;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run specific examples:
; Example1_BasicPixelColor()
; Example2_PixelSearchDemo()
; Example3_ColorPickerTool()
; Example4_RegionPixelSearch()
; Example5_ScreenChangeDetection()

