#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * BuiltIn_ControlClick_02 - Coordinate-Based Control Clicking
 * ============================================================================
 *
 * Demonstrates advanced ControlClick with coordinates, position control,
 * and pixel-perfect clicking within controls.
 *
 * @description
 * ControlClick can target specific coordinates within a control, enabling
 * precise interaction with complex controls like canvases, images, and
 * custom-drawn elements.
 *
 * Key Features:
 * - Coordinate-based clicking within controls
 * - Relative vs absolute positioning
 * - Control area mapping
 * - Multi-point clicking patterns
 * - Visual feedback and validation
 *
 * @syntax ControlClick Control, WinTitle, WinText, WhichButton, ClickCount, "X# Y#"
 *
 * @author AutoHotkey Community
 * @version 1.0.0
 * @since 2024-01-16
 *
 * @example
 * ; Click at specific coordinates within a control
 * ControlClick "Edit1", "Notepad",, "Left", 1, "X50 Y20"
 *
 * @see https://www.autohotkey.com/docs/v2/lib/ControlClick.htm
 */

; ============================================================================
; Example 1: Basic Coordinate Clicking
; ============================================================================

/**
 * @function Example1_CoordinateClicking
 * @description Demonstrates clicking at specific coordinates within a control
 * Shows how to target precise positions
 */
Example1_CoordinateClicking() {
    MsgBox("Example 1: Coordinate-Based Clicking`n`n" .
           "Click at specific coordinates within a control.",
           "Coordinate Clicking", "OK Icon!")

    ; Create a canvas-like GUI
    myGui := Gui("+AlwaysOnTop", "Coordinate Click Demo")
    myGui.Add("Text", "w400", "Click at different coordinates in the area below:")

    ; Large edit control as click target
    canvas := myGui.Add("Edit", "w400 h300 y+10 ReadOnly",
                        "Click Area - Coordinates will appear here`n`n")

    ; Coordinate display
    myGui.Add("Text", "w400 y+10", "Click Coordinates:")
    coordText := myGui.Add("Text", "w400 h20 Border", "X: 0, Y: 0")

    ; Preset coordinate buttons
    myGui.Add("Text", "w400 y+20", "Preset Positions:")

    topLeftBtn := myGui.Add("Button", "w95 y+10", "Top-Left")
    topLeftBtn.OnEvent("Click", (*) => ClickAt(10, 10))

    topRightBtn := myGui.Add("Button", "w95 x+10", "Top-Right")
    topRightBtn.OnEvent("Click", (*) => ClickAt(390, 10))

    centerBtn := myGui.Add("Button", "w95 x+10", "Center")
    centerBtn.OnEvent("Click", (*) => ClickAt(200, 150))

    bottomBtn := myGui.Add("Button", "w95 x+10", "Bottom")
    bottomBtn.OnEvent("Click", (*) => ClickAt(200, 290))

    ; Custom coordinate input
    myGui.Add("Text", "w400 y+20", "Custom Coordinates:")
    myGui.Add("Text", "w50 y+10", "X:")
    xEdit := myGui.Add("Edit", "w60 x+5", "100")
    myGui.Add("Text", "w50 x+20", "Y:")
    yEdit := myGui.Add("Edit", "w60 x+5", "100")

    customBtn := myGui.Add("Button", "w120 x+20", "Click Custom")
    customBtn.OnEvent("Click", (*) => ClickCustom())

    ; Clear and close buttons
    clearBtn := myGui.Add("Button", "w190 y+20", "Clear Markers")
    clearBtn.OnEvent("Click", (*) => ClearMarkers())

    closeBtn := myGui.Add("Button", "w190 x+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    clickCount := 0

    ; Click at specific coordinates
    ClickAt(x, y) {
        try {
            ; Perform the coordinate-based click
            ControlClick("Edit1", "Coordinate Click Demo",, "Left", 1, "X" . x . " Y" . y)

            clickCount++

            ; Update display
            coordText.Value := "X: " . x . ", Y: " . y . " (Click #" . clickCount . ")"

            ; Add marker to canvas
            current := canvas.Value
            marker := "    [Click " . clickCount . " @ X:" . x . ", Y:" . y . "]`n"
            canvas.Value := current . marker

            ; Visual feedback
            ToolTip("Clicked at (" . x . ", " . y . ")")
            SetTimer(() => ToolTip(), -1000)

        } catch Error as err {
            MsgBox("Error clicking at coordinates: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Click at custom coordinates
    ClickCustom() {
        x := Integer(xEdit.Value)
        y := Integer(yEdit.Value)

        if (x < 0 || x > 400 || y < 0 || y > 300) {
            MsgBox("Coordinates out of range!`nX: 0-400, Y: 0-300", "Error", "OK IconX")
            return
        }

        ClickAt(x, y)
    }

    ; Clear markers
    ClearMarkers() {
        canvas.Value := "Click Area - Coordinates will appear here`n`n"
        clickCount := 0
        coordText.Value := "X: 0, Y: 0"
    }

    MsgBox("Coordinate clicking demo started!`n`n" .
           "Use buttons to click at preset or custom coordinates.",
           "Info", "OK Icon! T3")
}

; ============================================================================
; Example 2: Grid-Based Clicking Pattern
; ============================================================================

/**
 * @function Example2_GridPattern
 * @description Demonstrates clicking in a grid pattern across a control
 * Useful for testing grid layouts and table interactions
 */
Example2_GridPattern() {
    MsgBox("Example 2: Grid-Based Clicking Pattern`n`n" .
           "Demonstrates clicking in a grid pattern.",
           "Grid Pattern", "OK Icon!")

    ; Create GUI with grid visualization
    myGui := Gui("+AlwaysOnTop", "Grid Pattern Demo")
    myGui.Add("Text", "w450", "Grid-based clicking pattern (5x5 grid):")

    ; Grid display area
    gridArea := myGui.Add("Edit", "w450 h350 y+10 ReadOnly Multi",
                          "Grid Clicks:`n`n")

    ; Grid configuration
    myGui.Add("Text", "w450 y+10", "Grid Settings:")
    myGui.Add("Text", "w80 y+10", "Rows:")
    rowEdit := myGui.Add("Edit", "w50 x+5", "5")
    myGui.Add("Text", "w80 x+20", "Columns:")
    colEdit := myGui.Add("Edit", "w50 x+5", "5")

    ; Control buttons
    fillBtn := myGui.Add("Button", "w140 y+20", "Fill Grid")
    fillBtn.OnEvent("Click", (*) => FillGrid())

    diagonalBtn := myGui.Add("Button", "w140 x+10", "Diagonal Pattern")
    diagonalBtn.OnEvent("Click", (*) => DiagonalPattern())

    borderBtn := myGui.Add("Button", "w140 x+10", "Border Pattern")
    borderBtn.OnEvent("Click", (*) => BorderPattern())

    clearBtn := myGui.Add("Button", "w140 y+10", "Clear Grid")
    clearBtn.OnEvent("Click", (*) => ClearGrid())

    closeBtn := myGui.Add("Button", "w140 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Fill entire grid
    FillGrid() {
        rows := Integer(rowEdit.Value)
        cols := Integer(colEdit.Value)

        if (rows < 1 || rows > 10 || cols < 1 || cols > 10) {
            MsgBox("Grid size must be between 1 and 10!", "Error", "OK IconX")
            return
        }

        ClearGrid()
        gridArea.Value .= "Filling " . rows . "x" . cols . " grid...`n`n"

        ; Calculate cell dimensions (350 is the grid area height)
        cellWidth := 450 / cols
        cellHeight := 350 / rows

        Loop rows {
            row := A_Index
            Loop cols {
                col := A_Index

                ; Calculate center of each cell
                x := Integer((col - 0.5) * cellWidth)
                y := Integer((row - 0.5) * cellHeight)

                ; Click at cell center
                try {
                    ControlClick("Edit1", "Grid Pattern Demo",, "Left", 1, "X" . x . " Y" . y)
                    gridArea.Value .= Format("[{:d},{:d}] ", row, col)

                    if (Mod(col, cols) = 0)
                        gridArea.Value .= "`n"

                    Sleep(50)  ; Brief pause for visualization
                } catch Error as err {
                    gridArea.Value .= "`nError at [" . row . "," . col . "]: " . err.Message
                    return
                }
            }
        }

        gridArea.Value .= "`n✓ Grid fill complete!"
    }

    ; Diagonal pattern
    DiagonalPattern() {
        size := Min(Integer(rowEdit.Value), Integer(colEdit.Value))

        ClearGrid()
        gridArea.Value .= "Diagonal pattern (" . size . " clicks)...`n`n"

        cellWidth := 450 / size
        cellHeight := 350 / size

        Loop size {
            i := A_Index
            x := Integer((i - 0.5) * cellWidth)
            y := Integer((i - 0.5) * cellHeight)

            try {
                ControlClick("Edit1", "Grid Pattern Demo",, "Left", 1, "X" . x . " Y" . y)
                gridArea.Value .= "[" . i . "," . i . "] "
                Sleep(100)
            } catch Error as err {
                gridArea.Value .= "`nError: " . err.Message
                return
            }
        }

        gridArea.Value .= "`n✓ Diagonal complete!"
    }

    ; Border pattern
    BorderPattern() {
        rows := Integer(rowEdit.Value)
        cols := Integer(colEdit.Value)

        ClearGrid()
        gridArea.Value .= "Border pattern...`n`n"

        cellWidth := 450 / cols
        cellHeight := 350 / rows

        ; Top row
        gridArea.Value .= "Top: "
        Loop cols {
            x := Integer((A_Index - 0.5) * cellWidth)
            y := Integer(0.5 * cellHeight)
            ControlClick("Edit1", "Grid Pattern Demo",, "Left", 1, "X" . x . " Y" . y)
            gridArea.Value .= A_Index . " "
            Sleep(50)
        }

        ; Right column (excluding corners)
        gridArea.Value .= "`nRight: "
        Loop rows - 2 {
            x := Integer((cols - 0.5) * cellWidth)
            y := Integer((A_Index + 0.5) * cellHeight)
            ControlClick("Edit1", "Grid Pattern Demo",, "Left", 1, "X" . x . " Y" . y)
            gridArea.Value .= (A_Index + 1) . " "
            Sleep(50)
        }

        ; Bottom row (reverse)
        if (rows > 1) {
            gridArea.Value .= "`nBottom: "
            Loop cols {
                x := Integer((cols - A_Index + 0.5) * cellWidth)
                y := Integer((rows - 0.5) * cellHeight)
                ControlClick("Edit1", "Grid Pattern Demo",, "Left", 1, "X" . x . " Y" . y)
                gridArea.Value .= A_Index . " "
                Sleep(50)
            }
        }

        ; Left column (excluding corners)
        if (cols > 1 && rows > 2) {
            gridArea.Value .= "`nLeft: "
            Loop rows - 2 {
                x := Integer(0.5 * cellWidth)
                y := Integer((rows - A_Index - 0.5) * cellHeight)
                ControlClick("Edit1", "Grid Pattern Demo",, "Left", 1, "X" . x . " Y" . y)
                gridArea.Value .= A_Index . " "
                Sleep(50)
            }
        }

        gridArea.Value .= "`n✓ Border complete!"
    }

    ; Clear grid
    ClearGrid() {
        gridArea.Value := "Grid Clicks:`n`n"
    }

    MsgBox("Grid pattern demo started!`n`n" .
           "Use buttons to create different clicking patterns.",
           "Info", "OK Icon! T3")
}

; ============================================================================
; Example 3: Interactive Canvas Clicking
; ============================================================================

/**
 * @function Example3_InteractiveCanvas
 * @description Interactive canvas with coordinate tracking and drawing
 * Demonstrates practical use of coordinate-based clicking
 */
Example3_InteractiveCanvas() {
    MsgBox("Example 3: Interactive Canvas`n`n" .
           "Draw and interact with a virtual canvas.",
           "Interactive Canvas", "OK Icon!")

    ; Create main GUI
    myGui := Gui("+AlwaysOnTop", "Interactive Canvas Demo")
    myGui.Add("Text", "w500", "Virtual Drawing Canvas:")

    ; Canvas area (using Edit control for demonstration)
    canvas := myGui.Add("Edit", "w500 h400 y+10 ReadOnly Multi Background000000 cFFFFFF",
                        "")

    ; Drawing tools
    myGui.Add("Text", "w500 y+10", "Drawing Tools:")

    ; Tool selection
    toolGroup := myGui.Add("Text", "w500 y+10", "Tool:")
    dotBtn := myGui.Add("Radio", "w80 Checked", "Dot")
    lineBtn := myGui.Add("Radio", "w80 x+10", "Line")
    squareBtn := myGui.Add("Radio", "w80 x+10", "Square")
    circleBtn := myGui.Add("Radio", "w80 x+10", "Circle")
    clearBtn := myGui.Add("Button", "w80 x+10", "Clear")
    clearBtn.OnEvent("Click", (*) => ClearCanvas())

    ; Coordinate input for precision
    myGui.Add("Text", "w500 y+10", "Precision Input:")
    myGui.Add("Text", "w30 y+10", "X:")
    xInput := myGui.Add("Edit", "w60 x+5", "250")
    myGui.Add("Text", "w30 x+10", "Y:")
    yInput := myGui.Add("Edit", "w60 x+5", "200")

    drawBtn := myGui.Add("Button", "w100 x+10", "Draw at Point")
    drawBtn.OnEvent("Click", (*) => DrawAtPoint())

    ; Pattern buttons
    myGui.Add("Text", "w500 y+20", "Quick Patterns:")

    starBtn := myGui.Add("Button", "w95 y+10", "Star")
    starBtn.OnEvent("Click", (*) => DrawStar())

    spiralBtn := myGui.Add("Button", "w95 x+10", "Spiral")
    spiralBtn.OnEvent("Click", (*) => DrawSpiral())

    crossBtn := myGui.Add("Button", "w95 x+10", "Cross")
    crossBtn.OnEvent("Click", (*) => DrawCross())

    gridBtn := myGui.Add("Button", "w95 x+10", "Grid")
    gridBtn.OnEvent("Click", (*) => DrawGrid())

    closeBtn2 := myGui.Add("Button", "w95 x+10", "Close")
    closeBtn2.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Drawing state
    points := []
    lastX := 0
    lastY := 0

    ; Clear canvas
    ClearCanvas() {
        canvas.Value := ""
        points := []
    }

    ; Draw at specific point
    DrawAtPoint() {
        try {
            x := Integer(xInput.Value)
            y := Integer(yInput.Value)

            if (x < 0 || x > 500 || y < 0 || y > 400) {
                MsgBox("Coordinates out of range!`nX: 0-500, Y: 0-400", "Error", "OK IconX")
                return
            }

            ; Perform click
            ControlClick("Edit1", "Interactive Canvas Demo",, "Left", 1, "X" . x . " Y" . y)

            ; Add to canvas visualization
            AddPoint(x, y)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Add point to canvas
    AddPoint(x, y) {
        points.Push({x: x, y: y})

        ; Visual representation (text-based)
        marker := Format("● ({:3d},{:3d})  ", x, y)
        current := canvas.Value

        ; Add marker
        if (Mod(points.Length, 4) = 0)
            marker .= "`n"

        canvas.Value := current . marker
    }

    ; Draw star pattern
    DrawStar() {
        centerX := 250
        centerY := 200
        radius := 100
        numPoints := 5

        ClearCanvas()

        Loop numPoints * 2 {
            angle := (A_Index - 1) * 3.14159 / numPoints
            r := (Mod(A_Index, 2) = 1) ? radius : radius / 2

            x := Integer(centerX + r * Cos(angle))
            y := Integer(centerY + r * Sin(angle))

            ControlClick("Edit1", "Interactive Canvas Demo",, "Left", 1, "X" . x . " Y" . y)
            AddPoint(x, y)
            Sleep(50)
        }
    }

    ; Draw spiral pattern
    DrawSpiral() {
        centerX := 250
        centerY := 200
        maxRadius := 150

        ClearCanvas()

        Loop 30 {
            angle := A_Index * 0.5
            r := A_Index * maxRadius / 30

            x := Integer(centerX + r * Cos(angle))
            y := Integer(centerY + r * Sin(angle))

            ControlClick("Edit1", "Interactive Canvas Demo",, "Left", 1, "X" . x . " Y" . y)
            AddPoint(x, y)
            Sleep(30)
        }
    }

    ; Draw cross pattern
    DrawCross() {
        ClearCanvas()

        ; Horizontal line
        Loop 11 {
            x := 50 + (A_Index - 1) * 40
            y := 200

            ControlClick("Edit1", "Interactive Canvas Demo",, "Left", 1, "X" . x . " Y" . y)
            AddPoint(x, y)
            Sleep(30)
        }

        ; Vertical line
        Loop 11 {
            x := 250
            y := 50 + (A_Index - 1) * 30

            ControlClick("Edit1", "Interactive Canvas Demo",, "Left", 1, "X" . x . " Y" . y)
            AddPoint(x, y)
            Sleep(30)
        }
    }

    ; Draw grid pattern
    DrawGrid() {
        ClearCanvas()

        ; Vertical lines
        Loop 11 {
            x := (A_Index - 1) * 50
            Loop 9 {
                y := (A_Index - 1) * 50

                ControlClick("Edit1", "Interactive Canvas Demo",, "Left", 1, "X" . x . " Y" . y)
                Sleep(10)
            }
        }

        ; Mark corners
        corners := [{x: 0, y: 0}, {x: 500, y: 0}, {x: 0, y: 400}, {x: 500, y: 400}]
        for corner in corners {
            AddPoint(corner.x, corner.y)
        }
    }

    MsgBox("Interactive canvas demo started!`n`n" .
           "Use tools and patterns to draw on the virtual canvas.",
           "Info", "OK Icon! T3")
}

; ============================================================================
; Example 4: Multi-Region Clicking
; ============================================================================

/**
 * @function Example4_MultiRegion
 * @description Click different regions of a control with validation
 * Demonstrates area-based interaction logic
 */
Example4_MultiRegion() {
    MsgBox("Example 4: Multi-Region Clicking`n`n" .
           "Click different regions with automatic detection.",
           "Multi-Region", "OK Icon!")

    ; Create GUI with region map
    myGui := Gui("+AlwaysOnTop", "Multi-Region Demo")
    myGui.Add("Text", "w400", "Click different regions (400x300 area divided into 9 regions):")

    ; Region display
    regionArea := myGui.Add("Edit", "w400 h300 y+10 ReadOnly", "")

    ; Region labels
    myGui.Add("Text", "w400 y+10", "Region Map:")
    myGui.Add("Text", "w400", "Top:    Left | Center | Right`nMiddle: Left | Center | Right`nBottom: Left | Center | Right")

    ; Click log
    myGui.Add("Text", "w400 y+10", "Click Log:")
    logArea := myGui.Add("Edit", "w400 h100 ReadOnly", "")

    ; Test buttons
    myGui.Add("Text", "w400 y+10", "Test Regions:")

    testAllBtn := myGui.Add("Button", "w190 y+10", "Test All Regions")
    testAllBtn.OnEvent("Click", (*) => TestAllRegions())

    randomBtn := myGui.Add("Button", "w190 x+20", "Random Clicks")
    randomBtn.OnEvent("Click", (*) => RandomClicks())

    clearBtn := myGui.Add("Button", "w190 y+10", "Clear Log")
    clearBtn.OnEvent("Click", (*) => logArea.Value := "")

    closeBtn := myGui.Add("Button", "w190 x+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Define regions (9 regions in 3x3 grid)
    regions := Map(
        "Top-Left", {x1: 0, y1: 0, x2: 133, y2: 100},
        "Top-Center", {x1: 133, y1: 0, x2: 267, y2: 100},
        "Top-Right", {x1: 267, y1: 0, x2: 400, y2: 100},
        "Middle-Left", {x1: 0, y1: 100, x2: 133, y2: 200},
        "Middle-Center", {x1: 133, y1: 100, x2: 267, y2: 200},
        "Middle-Right", {x1: 267, y1: 100, x2: 400, y2: 200},
        "Bottom-Left", {x1: 0, y1: 200, x2: 133, y2: 300},
        "Bottom-Center", {x1: 133, y1: 200, x2: 267, y2: 300},
        "Bottom-Right", {x1: 267, y1: 200, x2: 400, y2: 300}
    )

    ; Get region name from coordinates
    GetRegionName(x, y) {
        for name, bounds in regions {
            if (x >= bounds.x1 && x < bounds.x2 && y >= bounds.y1 && y < bounds.y2)
                return name
        }
        return "Unknown"
    }

    ; Click in region
    ClickRegion(regionName) {
        if !regions.Has(regionName) {
            MsgBox("Invalid region: " . regionName, "Error", "OK IconX")
            return
        }

        bounds := regions[regionName]

        ; Calculate center of region
        x := Integer((bounds.x1 + bounds.x2) / 2)
        y := Integer((bounds.y1 + bounds.y2) / 2)

        try {
            ControlClick("Edit1", "Multi-Region Demo",, "Left", 1, "X" . x . " Y" . y)

            ; Log the click
            timestamp := FormatTime(, "HH:mm:ss")
            logEntry := timestamp . " - Clicked: " . regionName . " @ (" . x . "," . y . ")`n"
            logArea.Value .= logEntry

            ; Visual feedback
            ToolTip("Clicked: " . regionName)
            SetTimer(() => ToolTip(), -800)

        } catch Error as err {
            logArea.Value .= "Error: " . err.Message . "`n"
        }
    }

    ; Test all regions
    TestAllRegions() {
        logArea.Value := "Testing all 9 regions...`n"

        for name, bounds in regions {
            ClickRegion(name)
            Sleep(200)
        }

        logArea.Value .= "`n✓ All regions tested!"
    }

    ; Random clicks
    RandomClicks() {
        logArea.Value := "Performing 10 random clicks...`n"

        Loop 10 {
            ; Random coordinates
            x := Random(0, 400)
            y := Random(0, 300)

            try {
                ControlClick("Edit1", "Multi-Region Demo",, "Left", 1, "X" . x . " Y" . y)

                region := GetRegionName(x, y)
                timestamp := FormatTime(, "HH:mm:ss")
                logEntry := timestamp . " - Random: " . region . " @ (" . x . "," . y . ")`n"
                logArea.Value .= logEntry

                Sleep(150)

            } catch Error as err {
                logArea.Value .= "Error: " . err.Message . "`n"
            }
        }

        logArea.Value .= "`n✓ Random clicks complete!"
    }

    MsgBox("Multi-region demo started!`n`n" .
           "Test clicking different regions of the control.",
           "Info", "OK Icon! T3")
}

; ============================================================================
; Example 5: Coordinate Validation and Boundary Testing
; ============================================================================

/**
 * @function Example5_BoundaryTesting
 * @description Test clicking at control boundaries and edge cases
 * Demonstrates coordinate validation and error handling
 */
Example5_BoundaryTesting() {
    MsgBox("Example 5: Boundary Testing`n`n" .
           "Test clicks at control edges and boundaries.",
           "Boundary Testing", "OK Icon!")

    ; Create GUI
    myGui := Gui("+AlwaysOnTop", "Boundary Testing Demo")
    myGui.Add("Text", "w450", "Test Area (450x350):")

    testArea := myGui.Add("Edit", "w450 h350 y+10 ReadOnly", "")

    myGui.Add("Text", "w450 y+10", "Test Results:")
    resultArea := myGui.Add("Edit", "w450 h150 ReadOnly", "")

    ; Test controls
    myGui.Add("Text", "w450 y+10", "Boundary Tests:")

    cornersBtn := myGui.Add("Button", "w140 y+10", "Test Corners")
    cornersBtn.OnEvent("Click", (*) => TestCorners())

    edgesBtn := myGui.Add("Button", "w140 x+10", "Test Edges")
    edgesBtn.OnEvent("Click", (*) => TestEdges())

    outOfBoundsBtn := myGui.Add("Button", "w140 x+10", "Test Out of Bounds")
    outOfBoundsBtn.OnEvent("Click", (*) => TestOutOfBounds())

    clearBtn := myGui.Add("Button", "w140 y+10", "Clear Results")
    clearBtn.OnEvent("Click", (*) => resultArea.Value := "")

    closeBtn := myGui.Add("Button", "w140 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Test corners
    TestCorners() {
        resultArea.Value := "Testing 4 corners...`n`n"

        corners := [
            {name: "Top-Left", x: 0, y: 0},
            {name: "Top-Right", x: 449, y: 0},
            {name: "Bottom-Left", x: 0, y: 349},
            {name: "Bottom-Right", x: 449, y: 349}
        ]

        for corner in corners {
            try {
                ControlClick("Edit1", "Boundary Testing Demo",, "Left", 1,
                           "X" . corner.x . " Y" . corner.y)

                resultArea.Value .= "✓ " . corner.name . " (" . corner.x . "," .
                                   corner.y . ") - Success`n"
                Sleep(200)

            } catch Error as err {
                resultArea.Value .= "✗ " . corner.name . " - Error: " . err.Message . "`n"
            }
        }

        resultArea.Value .= "`n✓ Corner test complete!"
    }

    ; Test edges
    TestEdges() {
        resultArea.Value := "Testing edge midpoints...`n`n"

        edges := [
            {name: "Top Edge", x: 225, y: 0},
            {name: "Right Edge", x: 449, y: 175},
            {name: "Bottom Edge", x: 225, y: 349},
            {name: "Left Edge", x: 0, y: 175}
        ]

        for edge in edges {
            try {
                ControlClick("Edit1", "Boundary Testing Demo",, "Left", 1,
                           "X" . edge.x . " Y" . edge.y)

                resultArea.Value .= "✓ " . edge.name . " (" . edge.x . "," .
                                   edge.y . ") - Success`n"
                Sleep(200)

            } catch Error as err {
                resultArea.Value .= "✗ " . edge.name . " - Error: " . err.Message . "`n"
            }
        }

        resultArea.Value .= "`n✓ Edge test complete!"
    }

    ; Test out of bounds
    TestOutOfBounds() {
        resultArea.Value := "Testing out of bounds coordinates...`n`n"

        tests := [
            {name: "Negative X", x: -10, y: 100},
            {name: "Negative Y", x: 100, y: -10},
            {name: "Beyond Width", x: 500, y: 100},
            {name: "Beyond Height", x: 100, y: 400},
            {name: "Way Out", x: 1000, y: 1000}
        ]

        for test in tests {
            try {
                ControlClick("Edit1", "Boundary Testing Demo",, "Left", 1,
                           "X" . test.x . " Y" . test.y)

                resultArea.Value .= "? " . test.name . " (" . test.x . "," .
                                   test.y . ") - Accepted (clipped?)`n"

            } catch Error as err {
                resultArea.Value .= "✓ " . test.name . " - Properly rejected`n"
            }

            Sleep(100)
        }

        resultArea.Value .= "`n✓ Out of bounds test complete!"
    }

    MsgBox("Boundary testing demo started!`n`n" .
           "Test clicks at various boundary conditions.",
           "Info", "OK Icon! T3")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menuText := "
    (
    ControlClick Examples - Coordinates
    ====================================

    1. Basic Coordinate Clicking
    2. Grid-Based Clicking Pattern
    3. Interactive Canvas
    4. Multi-Region Clicking
    5. Boundary Testing

    Select an example (1-5) or press Esc to exit
    )"

    choice := InputBox(menuText, "ControlClick Coordinate Examples", "w400 h280")

    if (choice.Result = "Cancel")
        return

    switch choice.Value {
        case "1": Example1_CoordinateClicking()
        case "2": Example2_GridPattern()
        case "3": Example3_InteractiveCanvas()
        case "4": Example4_MultiRegion()
        case "5": Example5_BoundaryTesting()
        default:
            MsgBox("Invalid choice! Please select 1-5.", "Error", "OK IconX")
    }

    ; Show menu again
    SetTimer(() => ShowMainMenu(), -500)
}

; Start the demo
ShowMainMenu()
