#Requires AutoHotkey v2.0

/**
* BuiltIn_MonitorGet_01_BasicUsage.ahk
*
* DESCRIPTION:
* Demonstrates basic usage of MonitorGet function for retrieving monitor boundaries
* and working area coordinates in AutoHotkey v2. Shows how to identify monitor
* positions, dimensions, and available desktop space.
*
* FEATURES:
* - Retrieving monitor boundaries (full screen area)
* - Getting working area (excluding taskbar)
* - Calculating monitor dimensions
* - Identifying monitor positions
* - Determining available desktop space
* - Monitor information display
* - Error handling for invalid monitors
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/MonitorGet.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - MonitorGet function with output variables
* - Fat arrow function syntax (=>)
* - GUI v2 syntax and controls
* - Try-catch error handling
* - String interpolation
* - Modern parameter passing
*
* LEARNING POINTS:
* 1. MonitorGet retrieves both full monitor bounds and working area
* 2. Left, Top, Right, Bottom define the monitor's screen coordinates
* 3. Working area excludes taskbar and other system UI elements
* 4. Monitor numbers start at 1, not 0
* 5. Coordinates can be negative in multi-monitor setups
* 6. Width = Right - Left, Height = Bottom - Top
* 7. Invalid monitor numbers return empty values
*/

;=============================================================================
; EXAMPLE 1: Basic Monitor Information Retrieval
;=============================================================================
; Demonstrates retrieving and displaying basic monitor boundaries
Example1_BasicMonitorInfo() {
    ; Get primary monitor (usually monitor 1)
    MonitorGet(1, &MonLeft, &MonTop, &MonRight, &MonBottom)

    ; Calculate dimensions
    Width := MonRight - MonLeft
    Height := MonBottom - MonTop

    ; Display results
    result := "
    (
    Monitor 1 Information:
    =====================
    Left:   " MonLeft "
    Top:    " MonTop "
    Right:  " MonRight "
    Bottom: " MonBottom "

    Dimensions:
    Width:  " Width " pixels
    Height: " Height " pixels

    Position:
    Top-left corner: (" MonLeft ", " MonTop ")
    Bottom-right corner: (" MonRight ", " MonBottom ")
    )"

    MsgBox(result, "Example 1: Basic Monitor Info", "Icon!")
}

;=============================================================================
; EXAMPLE 2: Working Area vs Full Monitor
;=============================================================================
; Shows the difference between full monitor bounds and working area
Example2_WorkingAreaComparison() {
    MonNum := 1

    ; Get full monitor bounds
    MonitorGet(MonNum, &MonLeft, &MonTop, &MonRight, &MonBottom)

    ; Get working area (excludes taskbar)
    MonitorGetWorkArea(MonNum, &WorkLeft, &WorkTop, &WorkRight, &WorkBottom)

    ; Calculate dimensions
    MonWidth := MonRight - MonLeft
    MonHeight := MonBottom - MonTop
    WorkWidth := WorkRight - WorkLeft
    WorkHeight := WorkBottom - WorkTop

    ; Calculate taskbar size
    TaskbarHeight := MonHeight - WorkHeight
    TaskbarWidth := MonWidth - WorkWidth

    result := "
    (
    Monitor " MonNum " Comparison:
    ==========================

    FULL MONITOR BOUNDS:
    Left:   " MonLeft " | Right:  " MonRight "
    Top:    " MonTop " | Bottom: " MonBottom "
    Size:   " MonWidth " x " MonHeight "

    WORKING AREA (usable space):
    Left:   " WorkLeft " | Right:  " WorkRight "
    Top:    " WorkTop " | Bottom: " WorkBottom "
    Size:   " WorkWidth " x " WorkHeight "

    TASKBAR/SYSTEM UI:
    Lost Height: " TaskbarHeight " pixels
    Lost Width:  " TaskbarWidth " pixels

    Available: " Round((WorkWidth*WorkHeight)/(MonWidth*MonHeight)*100, 2) "%
    )"

    MsgBox(result, "Example 2: Working Area vs Full Monitor", "Icon!")
}

;=============================================================================
; EXAMPLE 3: Multi-Monitor Information Display
;=============================================================================
; Creates a GUI that displays information for all connected monitors
Example3_AllMonitorsGUI() {
    ; Create GUI
    g := Gui("+Resize", "All Monitors Information")
    g.SetFont("s9", "Consolas")

    ; Add ListView with columns
    lv := g.Add("ListView", "w800 h400", [
    "Monitor", "Left", "Top", "Right", "Bottom",
    "Width", "Height", "Aspect Ratio"
    ])

    ; Get monitor count
    MonCount := MonitorGetCount()

    ; Populate with data
    Loop MonCount {
        MonNum := A_Index

        ; Get monitor bounds
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        ; Calculate dimensions
        Width := Right - Left
        Height := Bottom - Top
        Aspect := Round(Width / Height, 2)

        ; Add row to ListView
        lv.Add("", MonNum, Left, Top, Right, Bottom, Width, Height, Aspect)
    }

    ; Auto-size columns
    Loop lv.GetCount("Column")
    lv.ModifyCol(A_Index, "AutoHdr")

    ; Add refresh button
    g.Add("Button", "w100", "Refresh").OnEvent("Click", (*) => RefreshMonitors(lv))

    ; Add close button
    g.Add("Button", "x+10 w100", "Close").OnEvent("Click", (*) => g.Destroy())

    ; Show GUI
    g.Show()

    ; Refresh function
    RefreshMonitors(lvControl) {
        lvControl.Delete()
        MonCount := MonitorGetCount()

        Loop MonCount {
            MonNum := A_Index
            MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)
            Width := Right - Left
            Height := Bottom - Top
            Aspect := Round(Width / Height, 2)
            lvControl.Add("", MonNum, Left, Top, Right, Bottom, Width, Height, Aspect)
        }

        Loop lvControl.GetCount("Column")
        lvControl.ModifyCol(A_Index, "AutoHdr")
    }
}

;=============================================================================
; EXAMPLE 4: Monitor Position Calculator
;=============================================================================
; Calculates the center point and corners of a monitor
Example4_MonitorPositionCalculator() {
    MonNum := 1

    ; Get monitor bounds
    MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

    ; Calculate key positions
    CenterX := (Left + Right) // 2
    CenterY := (Top + Bottom) // 2
    Width := Right - Left
    Height := Bottom - Top

    ; Calculate quarter points
    QuarterX := Width // 4
    QuarterY := Height // 4

    result := "
    (
    Monitor " MonNum " Position Calculator:
    ================================

    CORNERS:
    Top-Left:     (" Left ", " Top ")
    Top-Right:    (" Right ", " Top ")
    Bottom-Left:  (" Left ", " Bottom ")
    Bottom-Right: (" Right ", " Bottom ")

    CENTER POINT:
    (" CenterX ", " CenterY ")

    QUARTER POINTS (from top-left):
    1/4 Width:  " QuarterX " pixels
    1/4 Height: " QuarterY " pixels

    MIDDLE EDGES:
    Top Middle:    (" CenterX ", " Top ")
    Bottom Middle: (" CenterX ", " Bottom ")
    Left Middle:   (" Left ", " CenterY ")
    Right Middle:  (" Right ", " CenterY ")
    )"

    MsgBox(result, "Example 4: Position Calculator", "Icon!")
}

;=============================================================================
; EXAMPLE 5: Monitor Boundary Validator
;=============================================================================
; Validates if a coordinate point is within monitor boundaries
Example5_BoundaryValidator() {
    ; Create GUI
    g := Gui(, "Monitor Boundary Validator")
    g.SetFont("s10")

    ; Input fields
    g.Add("Text", "w80", "Monitor #:")
    edtMon := g.Add("Edit", "x+10 w50", "1")

    g.Add("Text", "xm w80", "X Coordinate:")
    edtX := g.Add("Edit", "x+10 w100", "0")

    g.Add("Text", "xm w80", "Y Coordinate:")
    edtY := g.Add("Edit", "x+10 w100", "0")

    ; Result display
    txtResult := g.Add("Text", "xm w400 h150 +Border")

    ; Check button
    g.Add("Button", "xm w100", "Validate").OnEvent("Click", ValidatePoint)
    g.Add("Button", "x+10 w100", "Get Mouse Pos").OnEvent("Click", GetMouse)

    g.Show()

    ; Validation function
    ValidatePoint(*) {
        MonNum := Integer(edtMon.Value)
        TestX := Integer(edtX.Value)
        TestY := Integer(edtY.Value)

        try {
            ; Get monitor bounds
            MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

            ; Check if point is within bounds
            IsInside := (TestX >= Left && TestX <= Right && TestY >= Top && TestY <= Bottom)

            ; Calculate distances from edges
            DistLeft := TestX - Left
            DistRight := Right - TestX
            DistTop := TestY - Top
            DistBottom := Bottom - TestY

            result := "Point (" TestX ", " TestY ")`n"
            result .= "Monitor " MonNum " bounds: " Left "," Top " to " Right "," Bottom "`n`n"

            if IsInside {
                result .= "✓ INSIDE MONITOR BOUNDS`n`n"
                result .= "Distance from edges:`n"
                result .= "Left:   " DistLeft " pixels`n"
                result .= "Right:  " DistRight " pixels`n"
                result .= "Top:    " DistTop " pixels`n"
                result .= "Bottom: " DistBottom " pixels"
            } else {
                result .= "✗ OUTSIDE MONITOR BOUNDS`n`n"
                result .= "Overflow:`n"
                if TestX < Left
                result .= "Left:   " Abs(DistLeft) " pixels`n"
                else if TestX > Right
                result .= "Right:  " Abs(DistRight) " pixels`n"
                if TestY < Top
                result .= "Top:    " Abs(DistTop) " pixels`n"
                else if TestY > Bottom
                result .= "Bottom: " Abs(DistBottom) " pixels"
            }

            txtResult.Value := result
        } catch {
            txtResult.Value := "Error: Invalid monitor number"
        }
    }

    ; Get current mouse position
    GetMouse(*) {
        MouseGetPos(&X, &Y)
        edtX.Value := X
        edtY.Value := Y
        ValidatePoint()
    }
}

;=============================================================================
; EXAMPLE 6: Monitor Dimension Reporter
;=============================================================================
; Reports detailed dimension information for all monitors
Example6_DimensionReporter() {
    MonCount := MonitorGetCount()

    report := "MONITOR DIMENSION REPORT`n"
    report .= "========================`n`n"

    TotalWidth := 0
    TotalHeight := 0
    TotalArea := 0

    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        Width := Right - Left
        Height := Bottom - Top
        Area := Width * Height
        Diagonal := Round(Sqrt(Width**2 + Height**2), 2)

        TotalWidth += Width
        TotalHeight := Max(TotalHeight, Height)
        TotalArea += Area

        report .= "Monitor " MonNum ":`n"
        report .= "  Position: " Left "," Top " to " Right "," Bottom "`n"
        report .= "  Dimensions: " Width " x " Height "`n"
        report .= "  Area: " Format("{:,}", Area) " pixels²`n"
        report .= "  Diagonal: " Diagonal " pixels`n"
        report .= "  Aspect: " Round(Width/Height, 2) ":1`n`n"
    }

    report .= "SUMMARY:`n"
    report .= "  Total Monitors: " MonCount "`n"
    report .= "  Combined Width: " TotalWidth " pixels`n"
    report .= "  Max Height: " TotalHeight " pixels`n"
    report .= "  Total Area: " Format("{:,}", TotalArea) " pixels²`n"
    report .= "  Avg Area/Monitor: " Format("{:,}", Round(TotalArea/MonCount)) " pixels²"

    MsgBox(report, "Example 6: Dimension Reporter", "Icon!")
}

;=============================================================================
; EXAMPLE 7: Monitor Corner Highlighter
;=============================================================================
; Creates small GUI windows at each corner of a monitor to visualize boundaries
Example7_CornerHighlighter() {
    MonNum := 1

    ; Get monitor bounds
    MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

    ; Create corner markers
    corners := []
    cornerSize := 50

    ; Top-Left
    g1 := Gui("+AlwaysOnTop -Caption +ToolWindow", "TL")
    g1.BackColor := "Red"
    g1.Show("x" Left " y" Top " w" cornerSize " h" cornerSize " NA")
    corners.Push(g1)

    ; Top-Right
    g2 := Gui("+AlwaysOnTop -Caption +ToolWindow", "TR")
    g2.BackColor := "Green"
    g2.Show("x" (Right-cornerSize) " y" Top " w" cornerSize " h" cornerSize " NA")
    corners.Push(g2)

    ; Bottom-Left
    g3 := Gui("+AlwaysOnTop -Caption +ToolWindow", "BL")
    g3.BackColor := "Blue"
    g3.Show("x" Left " y" (Bottom-cornerSize) " w" cornerSize " h" cornerSize " NA")
    corners.Push(g3)

    ; Bottom-Right
    g4 := Gui("+AlwaysOnTop -Caption +ToolWindow", "BR")
    g4.BackColor := "Yellow"
    g4.Show("x" (Right-cornerSize) " y" (Bottom-cornerSize) " w" cornerSize " h" cornerSize " NA")
    corners.Push(g4)

    ; Info message
    MsgBox("
    (
    Corner markers displayed on Monitor " MonNum ":

    Red    = Top-Left (" Left ", " Top ")
    Green  = Top-Right (" (Right-cornerSize) ", " Top ")
    Blue   = Bottom-Left (" Left ", " (Bottom-cornerSize) ")
    Yellow = Bottom-Right (" (Right-cornerSize) ", " (Bottom-cornerSize) ")

    Click OK to remove markers.
    )", "Example 7: Corner Highlighter", "Icon!")

    ; Clean up
    for corner in corners
    corner.Destroy()
}

;=============================================================================
; MAIN MENU
;=============================================================================
; Create main menu GUI for all examples
CreateMainMenu() {
    g := Gui(, "MonitorGet Basic Usage Examples")
    g.SetFont("s10")

    g.Add("Text", "w400", "Select an example to run:")

    g.Add("Button", "w400", "Example 1: Basic Monitor Info").OnEvent("Click", (*) => Example1_BasicMonitorInfo())
    g.Add("Button", "w400", "Example 2: Working Area Comparison").OnEvent("Click", (*) => Example2_WorkingAreaComparison())
    g.Add("Button", "w400", "Example 3: All Monitors GUI").OnEvent("Click", (*) => Example3_AllMonitorsGUI())
    g.Add("Button", "w400", "Example 4: Position Calculator").OnEvent("Click", (*) => Example4_MonitorPositionCalculator())
    g.Add("Button", "w400", "Example 5: Boundary Validator").OnEvent("Click", (*) => Example5_BoundaryValidator())
    g.Add("Button", "w400", "Example 6: Dimension Reporter").OnEvent("Click", (*) => Example6_DimensionReporter())
    g.Add("Button", "w400", "Example 7: Corner Highlighter").OnEvent("Click", (*) => Example7_CornerHighlighter())

    g.Add("Button", "w400", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

; Run main menu
CreateMainMenu()
