#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_MonitorGet_02_MultiMonitor.ahk
 * 
 * DESCRIPTION:
 * Advanced multi-monitor scenarios using MonitorGet function. Demonstrates
 * working with multiple displays, identifying monitor arrangements, and
 * managing windows across different screens.
 * 
 * FEATURES:
 * - Detecting multi-monitor configurations
 * - Identifying monitor arrangement (horizontal/vertical)
 * - Finding monitor relationships (left/right/above/below)
 * - Window positioning across monitors
 * - Virtual desktop calculations
 * - Monitor identification and labeling
 * - Cross-monitor coordinate translation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/MonitorGet.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Multi-monitor coordinate systems
 * - Array and Map collections
 * - Class-based organization
 * - Modern GUI controls
 * - Method chaining
 * - Property accessors
 * 
 * LEARNING POINTS:
 * 1. Monitors can have negative coordinates
 * 2. Virtual desktop spans all monitors
 * 3. Monitors can be arranged in any configuration
 * 4. Monitor numbers may not correspond to physical position
 * 5. Coordinate systems can overlap in multi-monitor setups
 * 6. Working area varies per monitor based on taskbar position
 * 7. Monitor arrangement affects window spanning
 */

;=============================================================================
; EXAMPLE 1: Multi-Monitor Configuration Detector
;=============================================================================
; Detects and displays the configuration of all connected monitors
Example1_ConfigurationDetector() {
    MonCount := MonitorGetCount()

    if MonCount = 1 {
        MsgBox("Single monitor detected. Multi-monitor examples require multiple displays.",
            "Configuration Detector", "Icon!")
        return
    }

    ; Collect monitor data
    monitors := Map()
    virtualLeft := 99999
    virtualTop := 99999
    virtualRight := -99999
    virtualBottom := -99999

    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        monitors[MonNum] := {
            Left: Left,
            Top: Top,
            Right: Right,
            Bottom: Bottom,
            Width: Right - Left,
            Height: Bottom - Top
        }

        ; Update virtual desktop bounds
        virtualLeft := Min(virtualLeft, Left)
        virtualTop := Min(virtualTop, Top)
        virtualRight := Max(virtualRight, Right)
        virtualBottom := Max(virtualBottom, Bottom)
    }

    ; Analyze arrangement
    result := "MULTI-MONITOR CONFIGURATION`n"
    result .= "===========================`n`n"
    result .= "Total Monitors: " MonCount "`n`n"

    result .= "VIRTUAL DESKTOP:`n"
    result .= "  Bounds: " virtualLeft "," virtualTop " to " virtualRight "," virtualBottom "`n"
    result .= "  Total Size: " (virtualRight - virtualLeft) " x " (virtualBottom - virtualTop) "`n`n"

    result .= "INDIVIDUAL MONITORS:`n"
    for MonNum, data in monitors {
        result .= "`nMonitor " MonNum ":`n"
        result .= "  Position: " data.Left "," data.Top " to " data.Right "," data.Bottom "`n"
        result .= "  Size: " data.Width " x " data.Height "`n"
        result .= "  Relative to virtual: "

        if data.Left = virtualLeft && data.Top = virtualTop
            result .= "Top-Left corner`n"
        else if data.Right = virtualRight && data.Top = virtualTop
            result .= "Top-Right corner`n"
        else if data.Left = virtualLeft && data.Bottom = virtualBottom
            result .= "Bottom-Left corner`n"
        else if data.Right = virtualRight && data.Bottom = virtualBottom
            result .= "Bottom-Right corner`n"
        else
            result .= "Interior position`n"
    }

    MsgBox(result, "Example 1: Configuration Detector", "Icon!")
}

;=============================================================================
; EXAMPLE 2: Monitor Relationship Finder
;=============================================================================
; Finds spatial relationships between monitors (which is left/right/above/below)
Example2_RelationshipFinder() {
    MonCount := MonitorGetCount()

    if MonCount < 2 {
        MsgBox("This example requires at least 2 monitors.", "Relationship Finder", "Icon!")
        return
    }

    ; Create GUI
    g := Gui(, "Monitor Relationship Finder")
    g.SetFont("s10")

    g.Add("Text", "w80", "Monitor #:")
    cmbMon := g.Add("ComboBox", "x+10 w60")

    Loop MonCount
        cmbMon.Add([A_Index])
    cmbMon.Choose(1)

    txtResult := g.Add("Text", "xm w500 h300 +Border")
    g.Add("Button", "xm w100", "Analyze").OnEvent("Click", AnalyzeRelationships)

    g.Show()

    AnalyzeRelationships(*) {
        MonNum := Integer(cmbMon.Text)
        MonitorGet(MonNum, &RefLeft, &RefTop, &RefRight, &RefBottom)

        result := "Monitor " MonNum " Relationships:`n"
        result .= "========================`n`n"

        leftOf := []
        rightOf := []
        above := []
        below := []

        Loop MonCount {
            if A_Index = MonNum
                continue

            TestNum := A_Index
            MonitorGet(TestNum, &TestLeft, &TestTop, &TestRight, &TestBottom)

            ; Check horizontal relationships
            if TestRight <= RefLeft
                leftOf.Push(TestNum)
            else if TestLeft >= RefRight
                rightOf.Push(TestNum)

            ; Check vertical relationships
            if TestBottom <= RefTop
                above.Push(TestNum)
            else if TestTop >= RefBottom
                below.Push(TestNum)
        }

        result .= "Monitors to the LEFT: " (leftOf.Length ? ArrayToString(leftOf) : "None") "`n"
        result .= "Monitors to the RIGHT: " (rightOf.Length ? ArrayToString(rightOf) : "None") "`n"
        result .= "Monitors ABOVE: " (above.Length ? ArrayToString(above) : "None") "`n"
        result .= "Monitors BELOW: " (below.Length ? ArrayToString(below) : "None") "`n`n"

        ; Find adjacent monitors (touching edges)
        adjacent := []
        Loop MonCount {
            if A_Index = MonNum
                continue

            TestNum := A_Index
            MonitorGet(TestNum, &TestLeft, &TestTop, &TestRight, &TestBottom)

            ; Check if edges touch
            if (TestRight = RefLeft) or (TestLeft = RefRight) or
                (TestBottom = RefTop) or (TestTop = RefBottom)
                adjacent.Push(TestNum)
        }

        result .= "ADJACENT Monitors (touching): " (adjacent.Length ? ArrayToString(adjacent) : "None")

        txtResult.Value := result
    }

    ArrayToString(arr) {
        str := ""
        for item in arr
            str .= item ", "
        return SubStr(str, 1, -2)
    }
}

;=============================================================================
; EXAMPLE 3: Visual Monitor Layout Mapper
;=============================================================================
; Creates a visual representation of monitor arrangement
Example3_VisualLayoutMapper() {
    MonCount := MonitorGetCount()

    ; Get virtual desktop bounds
    virtualLeft := 99999
    virtualTop := 99999
    virtualRight := -99999
    virtualBottom := -99999

    monitors := []

    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        monitors.Push({
            Num: MonNum,
            Left: Left,
            Top: Top,
            Right: Right,
            Bottom: Bottom
        })

        virtualLeft := Min(virtualLeft, Left)
        virtualTop := Min(virtualTop, Top)
        virtualRight := Max(virtualRight, Right)
        virtualBottom := Max(virtualBottom, Bottom)
    }

    ; Create visual GUI
    g := Gui(, "Monitor Layout Map")
    g.BackColor := "White"

    ; Calculate scaling
    virtualWidth := virtualRight - virtualLeft
    virtualHeight := virtualBottom - virtualTop
    maxCanvasWidth := 800
    maxCanvasHeight := 600

    scale := Min(maxCanvasWidth / virtualWidth, maxCanvasHeight / virtualHeight) * 0.9

    ; Draw monitors
    for mon in monitors {
        ; Calculate scaled position
        x := Round((mon.Left - virtualLeft) * scale) + 20
        y := Round((mon.Top - virtualTop) * scale) + 20
        w := Round((mon.Right - mon.Left) * scale)
        h := Round((mon.Bottom - mon.Top) * scale)

        ; Create monitor rectangle
        g.Add("Progress", "x" x " y" y " w" w " h" h " Background0x0078D7")

        ; Add monitor number label
        labelX := x + (w // 2) - 20
        labelY := y + (h // 2) - 10
        g.Add("Text", "x" labelX " y" labelY " w40 h20 +Center BackgroundTrans c0xFFFFFF",
            "M" mon.Num)

        ; Add dimension label
        dimX := x + 5
        dimY := y + h - 20
        g.Add("Text", "x" dimX " y" dimY " w" (w - 10) " h15 +Center BackgroundTrans c0xFFFFFF",
            (mon.Right - mon.Left) "x" (mon.Bottom - mon.Top))
    }

    ; Add legend
    legendY := Round((virtualBottom - virtualTop) * scale) + 50
    g.Add("Text", "x20 y" legendY " w800",
        "Scale: 1 pixel = " Round(1 / scale, 2) " screen pixels | "
        "Virtual Desktop: " virtualWidth "x" virtualHeight)

    g.Show("w" (maxCanvasWidth + 40) " h" (legendY + 40))
}

;=============================================================================
; EXAMPLE 4: Cross-Monitor Window Mover
;=============================================================================
; Moves active window between monitors
Example4_CrossMonitorMover() {
    ; Create GUI
    g := Gui(, "Cross-Monitor Window Mover")
    g.SetFont("s10")

    MonCount := MonitorGetCount()

    g.Add("Text", , "Move Active Window to Monitor:")

    Loop MonCount {
        MonNum := A_Index
        g.Add("Button", "w200", "Monitor " MonNum).OnEvent("Click", (*) => MoveToMonitor(MonNum))
    }

    g.Add("Text", "xm", "Window Positioning:")
    g.Add("Button", "w95", "Top-Left").OnEvent("Click", (*) => MoveToPosition("TL"))
    g.Add("Button", "x+5 w95", "Top-Right").OnEvent("Click", (*) => MoveToPosition("TR"))
    g.Add("Button", "xm w95", "Bottom-Left").OnEvent("Click", (*) => MoveToPosition("BL"))
    g.Add("Button", "x+5 w95", "Bottom-Right").OnEvent("Click", (*) => MoveToPosition("BR"))
    g.Add("Button", "xm w200", "Center").OnEvent("Click", (*) => MoveToPosition("C"))

    currentMonVar := g.Add("Text", "xm w200 h30 +Border")
    UpdateCurrentMonitor()

    ; Timer to update current monitor display
    SetTimer(UpdateCurrentMonitor, 1000)

    g.OnEvent("Close", (*) => (SetTimer(UpdateCurrentMonitor, 0), g.Destroy()))
    g.Show()

    MoveToMonitor(MonNum) {
        try {
            WinID := WinExist("A")
            if !WinID
                return

            ; Get target monitor bounds
            MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

            ; Get window size
            WinGetPos(&WinX, &WinY, &WinW, &WinH, WinID)

            ; Center window on target monitor
            NewX := Left + ((Right - Left - WinW) // 2)
            NewY := Top + ((Bottom - Top - WinH) // 2)

            WinMove(NewX, NewY, , , WinID)
        }
    }

    MoveToPosition(pos) {
        try {
            WinID := WinExist("A")
            if !WinID
                return

            ; Find which monitor the window is currently on
            WinGetPos(&WinX, &WinY, &WinW, &WinH, WinID)
            CurrentMon := 1

            Loop MonitorGetCount() {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                if (WinX >= Left && WinX < Right && WinY >= Top && WinY < Bottom) {
                    CurrentMon := A_Index
                    break
                }
            }

            ; Get current monitor bounds
            MonitorGetWorkArea(CurrentMon, &Left, &Top, &Right, &Bottom)

            ; Calculate position
            switch pos {
                case "TL": NewX := Left, NewY := Top
                case "TR": NewX := Right - WinW, NewY := Top
                case "BL": NewX := Left, NewY := Bottom - WinH
                case "BR": NewX := Right - WinW, NewY := Bottom - WinH
                case "C": NewX := Left + ((Right - Left - WinW) // 2),
                    NewY := Top + ((Bottom - Top - WinH) // 2)
            }

            WinMove(NewX, NewY, , , WinID)
        }
    }

    UpdateCurrentMonitor() {
        try {
            if !WinExist("A")
                return

            WinGetPos(&X, &Y, , , "A")
            WinTitle := WinGetTitle("A")

            ; Find which monitor
            Loop MonitorGetCount() {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                if (X >= Left && X < Right && Y >= Top && Y < Bottom) {
                    currentMonVar.Value := "Current: Monitor " A_Index "`n" SubStr(WinTitle, 1, 30)
                    return
                }
            }
        }
    }
}

;=============================================================================
; EXAMPLE 5: Monitor Spanning Calculator
;=============================================================================
; Calculates which monitors a window or coordinate range spans
Example5_SpanningCalculator() {
    ; Create GUI
    g := Gui(, "Monitor Spanning Calculator")
    g.SetFont("s9")

    g.Add("Text", "w60", "Left:")
    edtLeft := g.Add("Edit", "x+5 w80", "0")

    g.Add("Text", "xm w60", "Top:")
    edtTop := g.Add("Edit", "x+5 w80", "0")

    g.Add("Text", "xm w60", "Right:")
    edtRight := g.Add("Edit", "x+5 w80", "1920")

    g.Add("Text", "xm w60", "Bottom:")
    edtBottom := g.Add("Edit", "x+5 w80", "1080")

    txtResult := g.Add("Text", "xm w400 h250 +Border")

    g.Add("Button", "xm w120", "Calculate Span").OnEvent("Click", Calculate)
    g.Add("Button", "x+5 w120", "Use Active Window").OnEvent("Click", UseActiveWindow)

    g.Show()

    Calculate(*) {
        Left := Integer(edtLeft.Value)
        Top := Integer(edtTop.Value)
        Right := Integer(edtRight.Value)
        Bottom := Integer(edtBottom.Value)

        Width := Right - Left
        Height := Bottom - Top
        Area := Width * Height

        result := "SPANNING ANALYSIS`n"
        result .= "==================`n`n"
        result .= "Rectangle: " Left "," Top " to " Right "," Bottom "`n"
        result .= "Size: " Width " x " Height " (" Format("{:,}", Area) " pixels²)`n`n"

        spannedMonitors := []
        coverage := Map()

        Loop MonitorGetCount() {
            MonNum := A_Index
            MonitorGet(MonNum, &ML, &MT, &MR, &MB)

            ; Calculate intersection
            IntLeft := Max(Left, ML)
            IntTop := Max(Top, MT)
            IntRight := Min(Right, MR)
            IntBottom := Min(Bottom, MB)

            ; Check if there's an intersection
            if (IntLeft < IntRight && IntTop < IntBottom) {
                IntWidth := IntRight - IntLeft
                IntHeight := IntBottom - IntTop
                IntArea := IntWidth * IntHeight
                Percent := Round((IntArea / Area) * 100, 2)

                spannedMonitors.Push(MonNum)
                coverage[MonNum] := {
                    Area: IntArea,
                    Percent: Percent,
                    Width: IntWidth,
                    Height: IntHeight
                }
            }
        }

        result .= "Spans " spannedMonitors.Length " monitor(s): "

        if spannedMonitors.Length = 0 {
            result .= "None (outside all monitors)"
        } else {
            for MonNum in spannedMonitors
                result .= MonNum " "

            result .= "`n`nCOVERAGE BREAKDOWN:`n"
            for MonNum in spannedMonitors {
                data := coverage[MonNum]
                result .= "`nMonitor " MonNum ":`n"
                result .= "  Area: " Format("{:,}", data.Area) " pixels² (" data.Percent "%)`n"
                result .= "  Dimensions: " data.Width " x " data.Height
                if spannedMonitors.Length > 1
                    result .= "`n"
            }

            ; Find primary monitor
            maxCoverage := 0
            primaryMon := 0
            for MonNum in spannedMonitors {
                if coverage[MonNum].Percent > maxCoverage {
                    maxCoverage := coverage[MonNum].Percent
                    primaryMon := MonNum
                }
            }

            result .= "`n`nPrimary Monitor: " primaryMon " (" maxCoverage "% coverage)"
        }

        txtResult.Value := result
    }

    UseActiveWindow(*) {
        try {
            WinGetPos(&X, &Y, &W, &H, "A")
            edtLeft.Value := X
            edtTop.Value := Y
            edtRight.Value := X + W
            edtBottom.Value := Y + H
            Calculate()
        }
    }
}

;=============================================================================
; EXAMPLE 6: Monitor Arrangement Detector
;=============================================================================
; Detects if monitors are arranged horizontally, vertically, or mixed
Example6_ArrangementDetector() {
    MonCount := MonitorGetCount()

    if MonCount < 2 {
        MsgBox("This example requires multiple monitors.", "Arrangement Detector", "Icon!")
        return
    }

    monitors := []
    Loop MonCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        monitors.Push({
            Num: A_Index,
            Left: Left,
            Top: Top,
            Right: Right,
            Bottom: Bottom,
            CenterX: (Left + Right) // 2,
            CenterY: (Top + Bottom) // 2
        })
    }

    ; Analyze arrangement
    horizontalPairs := 0
    verticalPairs := 0
    tolerance := 50  ; pixels

    for i, mon1 in monitors {
        for j, mon2 in monitors {
            if i >= j
                continue

            ; Check if horizontally aligned (similar Y centers)
            if Abs(mon1.CenterY - mon2.CenterY) < tolerance
                horizontalPairs++

            ; Check if vertically aligned (similar X centers)
            if Abs(mon1.CenterX - mon2.CenterX) < tolerance
                verticalPairs++
        }
    }

    result := "MONITOR ARRANGEMENT ANALYSIS`n"
    result .= "============================`n`n"
    result .= "Total Monitors: " MonCount "`n`n"

    result .= "Alignment Detection:`n"
    result .= "  Horizontal pairs: " horizontalPairs "`n"
    result .= "  Vertical pairs: " verticalPairs "`n`n"

    if horizontalPairs > verticalPairs
        arrangement := "Primarily HORIZONTAL"
    else if verticalPairs > horizontalPairs
        arrangement := "Primarily VERTICAL"
    else if horizontalPairs = 0 && verticalPairs = 0
        arrangement := "SCATTERED (no alignment)"
    else
        arrangement := "MIXED arrangement"

    result .= "Configuration: " arrangement "`n`n"

    result .= "Monitor Positions (by center point):`n"
    for mon in monitors
        result .= "  Monitor " mon.Num ": Center at (" mon.CenterX ", " mon.CenterY ")`n"

    MsgBox(result, "Example 6: Arrangement Detector", "Icon!")
}

;=============================================================================
; EXAMPLE 7: Virtual Desktop Calculator
;=============================================================================
; Calculates total virtual desktop space and finds dead zones
Example7_VirtualDesktopCalculator() {
    MonCount := MonitorGetCount()

    ; Get all monitor bounds
    monitors := []
    virtualLeft := 99999
    virtualTop := 99999
    virtualRight := -99999
    virtualBottom := -99999

    Loop MonCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        monitors.Push({ Left: Left, Top: Top, Right: Right, Bottom: Bottom })

        virtualLeft := Min(virtualLeft, Left)
        virtualTop := Min(virtualTop, Top)
        virtualRight := Max(virtualRight, Right)
        virtualBottom := Max(virtualBottom, Bottom)
    }

    ; Calculate virtual desktop
    virtualWidth := virtualRight - virtualLeft
    virtualHeight := virtualBottom - virtualTop
    virtualArea := virtualWidth * virtualHeight

    ; Calculate actual monitor area
    monitorArea := 0
    for mon in monitors
        monitorArea += (mon.Right - mon.Left) * (mon.Bottom - mon.Top)

    ; Calculate dead space
    deadSpace := virtualArea - monitorArea
    deadPercent := Round((deadSpace / virtualArea) * 100, 2)

    result := "VIRTUAL DESKTOP ANALYSIS`n"
    result .= "========================`n`n"

    result .= "Virtual Desktop Bounds:`n"
    result .= "  Top-Left: (" virtualLeft ", " virtualTop ")`n"
    result .= "  Bottom-Right: (" virtualRight ", " virtualBottom ")`n"
    result .= "  Dimensions: " virtualWidth " x " virtualHeight "`n"
    result .= "  Total Area: " Format("{:,}", virtualArea) " pixels²`n`n"

    result .= "Monitor Coverage:`n"
    result .= "  Actual Monitor Area: " Format("{:,}", monitorArea) " pixels²`n"
    result .= "  Dead Space: " Format("{:,}", deadSpace) " pixels²`n"
    result .= "  Efficiency: " (100 - deadPercent) "%`n`n"

    result .= "Monitor Layout:`n"
    for i, mon in monitors {
        area := (mon.Right - mon.Left) * (mon.Bottom - mon.Top)
        result .= "  Monitor " i ": " Format("{:,}", area) " pixels² "
        result .= "(" Round((area / virtualArea) * 100, 1) "% of virtual)`n"
    }

    if deadPercent > 5
        result .= "`nNote: High dead space suggests gaps in monitor arrangement."

    MsgBox(result, "Example 7: Virtual Desktop Calculator", "Icon!")
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGet Multi-Monitor Examples")
    g.SetFont("s10")

    g.Add("Text", "w450", "Select an example to run:")

    g.Add("Button", "w450", "Example 1: Configuration Detector").OnEvent("Click", (*) => Example1_ConfigurationDetector())
    g.Add("Button", "w450", "Example 2: Relationship Finder").OnEvent("Click", (*) => Example2_RelationshipFinder())
    g.Add("Button", "w450", "Example 3: Visual Layout Mapper").OnEvent("Click", (*) => Example3_VisualLayoutMapper())
    g.Add("Button", "w450", "Example 4: Cross-Monitor Window Mover").OnEvent("Click", (*) => Example4_CrossMonitorMover())
    g.Add("Button", "w450", "Example 5: Spanning Calculator").OnEvent("Click", (*) => Example5_SpanningCalculator())
    g.Add("Button", "w450", "Example 6: Arrangement Detector").OnEvent("Click", (*) => Example6_ArrangementDetector())
    g.Add("Button", "w450", "Example 7: Virtual Desktop Calculator").OnEvent("Click", (*) => Example7_VirtualDesktopCalculator())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
