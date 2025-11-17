#Requires AutoHotkey v2.0
/**
 * BuiltIn_MonitorGet_03_Positioning.ahk
 *
 * DESCRIPTION:
 * Advanced window positioning techniques using MonitorGet. Demonstrates smart
 * window placement, constraint-based positioning, and multi-monitor aware
 * window management strategies.
 *
 * FEATURES:
 * - Smart window positioning within monitor bounds
 * - Percentage-based placement
 * - Grid-based window snapping
 * - Monitor-aware window sizing
 * - Boundary constraint enforcement
 * - Custom positioning presets
 * - Dynamic window cascading
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/MonitorGet.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - MonitorGet for precise positioning
 * - MonitorGetWorkArea for usable space
 * - Object literal syntax
 * - Class methods and properties
 * - Hotkey context sensitivity
 * - Modern GUI positioning
 *
 * LEARNING POINTS:
 * 1. Always constrain windows within monitor bounds
 * 2. Use working area for better taskbar handling
 * 3. Percentage-based positioning is resolution-independent
 * 4. Grid snapping improves window organization
 * 5. Monitor awareness prevents windows appearing off-screen
 * 6. Cascading requires offset calculation
 * 7. Window positioning should account for title bar and borders
 */

;=============================================================================
; EXAMPLE 1: Percentage-Based Window Positioner
;=============================================================================
; Positions windows using percentage coordinates within monitor
Example1_PercentagePositioner() {
    ; Create GUI
    g := Gui(, "Percentage-Based Positioner")
    g.SetFont("s10")

    g.Add("Text", "w100", "Monitor:")
    cmbMon := g.Add("ComboBox", "x+10 w60")
    Loop MonitorGetCount()
        cmbMon.Add([A_Index])
    cmbMon.Choose(1)

    g.Add("Text", "xm w100", "X Position %:")
    sldX := g.Add("Slider", "x+10 w200 Range0-100 ToolTip", 50)
    txtX := g.Add("Text", "x+10 w40", "50%")

    g.Add("Text", "xm w100", "Y Position %:")
    sldY := g.Add("Slider", "x+10 w200 Range0-100 ToolTip", 50)
    txtY := g.Add("Text", "x+10 w40", "50%")

    g.Add("Text", "xm w100", "Width %:")
    sldW := g.Add("Slider", "x+10 w200 Range10-100 ToolTip", 50)
    txtW := g.Add("Text", "x+10 w40", "50%")

    g.Add("Text", "xm w100", "Height %:")
    sldH := g.Add("Slider", "x+10 w200 Range10-100 ToolTip", 50)
    txtH := g.Add("Text", "x+10 w40", "50%")

    ; Update labels
    sldX.OnEvent("Change", (*) => txtX.Value := sldX.Value "%")
    sldY.OnEvent("Change", (*) => txtY.Value := sldY.Value "%")
    sldW.OnEvent("Change", (*) => txtW.Value := sldW.Value "%")
    sldH.OnEvent("Change", (*) => txtH.Value := sldH.Value "%")

    g.Add("Button", "xm w120", "Apply to Active").OnEvent("Click", ApplyPosition)
    g.Add("Button", "x+10 w120", "Preview").OnEvent("Click", Preview)

    ; Preset buttons
    g.Add("Text", "xm Section", "Presets:")
    g.Add("Button", "xs w80", "Center").OnEvent("Click", (*) => LoadPreset(50, 50, 50, 50))
    g.Add("Button", "x+5 w80", "Full").OnEvent("Click", (*) => LoadPreset(0, 0, 100, 100))
    g.Add("Button", "x+5 w80", "Left Half").OnEvent("Click", (*) => LoadPreset(0, 0, 50, 100))
    g.Add("Button", "xs w80", "Right Half").OnEvent("Click", (*) => LoadPreset(50, 0, 50, 100))
    g.Add("Button", "x+5 w80", "Top Half").OnEvent("Click", (*) => LoadPreset(0, 0, 100, 50))
    g.Add("Button", "x+5 w80", "Bottom Half").OnEvent("Click", (*) => LoadPreset(0, 50, 100, 50))

    g.Show()

    LoadPreset(x, y, w, h) {
        sldX.Value := x
        sldY.Value := y
        sldW.Value := w
        sldH.Value := h
        txtX.Value := x "%"
        txtY.Value := y "%"
        txtW.Value := w "%"
        txtH.Value := h "%"
    }

    ApplyPosition(*) {
        try {
            WinID := WinExist("A")
            if !WinID {
                MsgBox("No active window found!", "Error", "Icon!")
                return
            }

            MonNum := Integer(cmbMon.Text)
            MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

            MonWidth := Right - Left
            MonHeight := Bottom - Top

            ; Calculate position and size
            xPercent := sldX.Value / 100
            yPercent := sldY.Value / 100
            wPercent := sldW.Value / 100
            hPercent := sldH.Value / 100

            NewW := Round(MonWidth * wPercent)
            NewH := Round(MonHeight * hPercent)
            NewX := Left + Round(MonWidth * xPercent - NewW / 2)
            NewY := Top + Round(MonHeight * yPercent - NewH / 2)

            ; Constrain to monitor
            NewX := Max(Left, Min(NewX, Right - NewW))
            NewY := Max(Top, Min(NewY, Bottom - NewH))

            WinMove(NewX, NewY, NewW, NewH, WinID)
        }
    }

    Preview(*) {
        MonNum := Integer(cmbMon.Text)
        MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

        MonWidth := Right - Left
        MonHeight := Bottom - Top

        NewW := Round(MonWidth * sldW.Value / 100)
        NewH := Round(MonHeight * sldH.Value / 100)
        NewX := Left + Round(MonWidth * sldX.Value / 100 - NewW / 2)
        NewY := Top + Round(MonHeight * sldY.Value / 100 - NewH / 2)

        info := "Preview:`n"
        info .= "Position: " NewX ", " NewY "`n"
        info .= "Size: " NewW " x " NewH "`n"
        info .= "`nMonitor " MonNum " Working Area:`n"
        info .= Left "," Top " to " Right "," Bottom

        MsgBox(info, "Position Preview", "Icon!")
    }
}

;=============================================================================
; EXAMPLE 2: Grid-Based Window Snapper
;=============================================================================
; Snaps windows to a customizable grid on the monitor
Example2_GridSnapper() {
    ; Create GUI
    g := Gui(, "Grid-Based Window Snapper")
    g.SetFont("s10")

    g.Add("Text", "w100", "Grid Columns:")
    edtCols := g.Add("Edit", "x+10 w60", "3")

    g.Add("Text", "xm w100", "Grid Rows:")
    edtRows := g.Add("Edit", "x+10 w60", "3")

    g.Add("Text", "xm w100", "Spacing (px):")
    edtGap := g.Add("Edit", "x+10 w60", "10")

    ; Grid visualization
    g.Add("Text", "xm Section", "Click a cell to position active window:")
    gridContainer := g.Add("Text", "xs w300 h200 +Border")

    g.Add("Button", "xs w140", "Generate Grid").OnEvent("Click", GenerateGrid)

    gridButtons := []

    g.Show()

    GenerateGrid(*) {
        ; Clear existing buttons
        for btn in gridButtons
            btn.Destroy()
        gridButtons := []

        cols := Integer(edtCols.Value)
        rows := Integer(edtRows.Value)
        gap := Integer(edtGap.Value)

        cellWidth := (300 - (cols + 1) * gap) // cols
        cellHeight := (200 - (rows + 1) * gap) // rows

        baseX := 20
        baseY := gridContainer.Pos().Y + 5

        Loop rows {
            row := A_Index - 1
            Loop cols {
                col := A_Index - 1

                x := baseX + (col * (cellWidth + gap)) + gap
                y := baseY + (row * (cellHeight + gap)) + gap

                btn := g.Add("Button", "x" x " y" y " w" cellWidth " h" cellHeight,
                            (col + 1) "," (row + 1))
                btn.OnEvent("Click", SnapToCell.Bind(col, row, cols, rows))
                gridButtons.Push(btn)
            }
        }
    }

    SnapToCell(col, row, totalCols, totalRows, *) {
        try {
            WinID := WinExist("A")
            if !WinID
                return

            ; Find which monitor the window is on
            WinGetPos(&WinX, &WinY, , , WinID)
            MonNum := 1

            Loop MonitorGetCount() {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                if (WinX >= Left && WinX < Right && WinY >= Top && WinY < Bottom) {
                    MonNum := A_Index
                    break
                }
            }

            MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

            gap := Integer(edtGap.Value)
            MonWidth := Right - Left
            MonHeight := Bottom - Top

            cellWidth := (MonWidth - (totalCols + 1) * gap) // totalCols
            cellHeight := (MonHeight - (totalRows + 1) * gap) // totalRows

            NewX := Left + (col * (cellWidth + gap)) + gap
            NewY := Top + (row * (cellHeight + gap)) + gap

            WinMove(NewX, NewY, cellWidth, cellHeight, WinID)
        }
    }
}

;=============================================================================
; EXAMPLE 3: Smart Window Constrainer
;=============================================================================
; Ensures windows stay within monitor bounds with automatic adjustment
Example3_SmartConstrainer() {
    ; Create monitoring GUI
    g := Gui("+AlwaysOnTop", "Smart Window Constrainer")
    g.SetFont("s9")

    chkEnabled := g.Add("Checkbox", "Checked", "Enable Auto-Constraint")
    chkWork := g.Add("Checkbox", "Checked", "Use Working Area")
    txtStatus := g.Add("Text", "w300 h100 +Border")

    g.Add("Button", "w140", "Constrain Active Now").OnEvent("Click", ConstrainNow)

    constrainedCount := 0

    ; Timer to monitor windows
    SetTimer(MonitorWindows, 1000)

    g.OnEvent("Close", (*) => (SetTimer(MonitorWindows, 0), g.Destroy()))
    g.Show()

    MonitorWindows() {
        if !chkEnabled.Value
            return

        ; Get all windows
        windowList := WinGetList(, , "Program Manager")

        for winID in windowList {
            try {
                if !WinExist(winID)
                    continue

                WinGetPos(&X, &Y, &W, &H, winID)

                ; Find the primary monitor for this window
                MonNum := GetMonitorForPoint(X, Y)
                if !MonNum
                    MonNum := 1

                if chkWork.Value
                    MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)
                else
                    MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

                ; Check if window is out of bounds
                needsMove := false
                NewX := X
                NewY := Y

                if X < Left {
                    NewX := Left
                    needsMove := true
                }
                if Y < Top {
                    NewY := Top
                    needsMove := true
                }
                if X + W > Right {
                    NewX := Right - W
                    needsMove := true
                }
                if Y + H > Bottom {
                    NewY := Bottom - H
                    needsMove := true
                }

                if needsMove {
                    WinMove(NewX, NewY, , , winID)
                    constrainedCount++
                    UpdateStatus()
                }
            }
        }
    }

    ConstrainNow(*) {
        try {
            WinID := WinExist("A")
            if !WinID
                return

            WinGetPos(&X, &Y, &W, &H, winID)
            MonNum := GetMonitorForPoint(X, Y)
            if !MonNum
                MonNum := 1

            if chkWork.Value
                MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)
            else
                MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

            NewX := Max(Left, Min(X, Right - W))
            NewY := Max(Top, Min(Y, Bottom - H))

            if (NewX != X || NewY != Y) {
                WinMove(NewX, NewY, , , winID)
                constrainedCount++
                UpdateStatus()
                MsgBox("Window constrained to Monitor " MonNum, "Constrained", "Icon!")
            } else {
                MsgBox("Window already within bounds", "Status", "Icon!")
            }
        }
    }

    UpdateStatus() {
        status := "Status: Active`n"
        status .= "Windows Constrained: " constrainedCount "`n"
        status .= "Mode: " (chkWork.Value ? "Working Area" : "Full Monitor") "`n"
        status .= "Last Check: " A_Hour ":" A_Min ":" A_Sec
        txtStatus.Value := status
    }

    GetMonitorForPoint(X, Y) {
        Loop MonitorGetCount() {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (X >= Left && X < Right && Y >= Top && Y < Bottom)
                return A_Index
        }
        return 0
    }

    UpdateStatus()
}

;=============================================================================
; EXAMPLE 4: Window Cascade Manager
;=============================================================================
; Cascades windows with proper offsets within monitor bounds
Example4_CascadeManager() {
    ; Create GUI
    g := Gui(, "Window Cascade Manager")
    g.SetFont("s10")

    g.Add("Text", "w100", "Monitor:")
    cmbMon := g.Add("ComboBox", "x+10 w60")
    Loop MonitorGetCount()
        cmbMon.Add([A_Index])
    cmbMon.Choose(1)

    g.Add("Text", "xm w100", "Cascade Offset:")
    edtOffset := g.Add("Edit", "x+10 w60", "30")

    g.Add("Text", "xm w100", "Window Width:")
    edtWidth := g.Add("Edit", "x+10 w80", "800")

    g.Add("Text", "xm w100", "Window Height:")
    edtHeight := g.Add("Edit", "x+10 w80", "600")

    g.Add("Button", "xm w200", "Cascade All Windows").OnEvent("Click", CascadeAll)
    g.Add("Button", "xm w200", "Reset Cascade").OnEvent("Click", ResetCascade)

    txtInfo := g.Add("Text", "xm w300 h80 +Border")

    cascadeIndex := 0

    g.Show()

    CascadeAll(*) {
        MonNum := Integer(cmbMon.Text)
        offset := Integer(edtOffset.Value)
        winWidth := Integer(edtWidth.Value)
        winHeight := Integer(edtHeight.Value)

        MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

        MonWidth := Right - Left
        MonHeight := Bottom - Top

        ; Calculate max cascade positions
        maxCascades := Min(
            (MonWidth - winWidth) // offset,
            (MonHeight - winHeight) // offset
        )

        windowList := WinGetList(, , "Program Manager")
        cascadedCount := 0
        currentIndex := cascadeIndex

        for winID in windowList {
            try {
                if !WinExist(winID)
                    continue

                ; Calculate position
                offsetX := (currentIndex * offset) mod (maxCascades * offset)
                offsetY := offsetX

                NewX := Left + offsetX
                NewY := Top + offsetY

                ; Ensure within bounds
                if (NewX + winWidth <= Right && NewY + winHeight <= Bottom) {
                    WinMove(NewX, NewY, winWidth, winHeight, winID)
                    cascadedCount++
                    currentIndex++

                    if currentIndex >= maxCascades
                        currentIndex := 0
                }
            }
        }

        cascadeIndex := currentIndex

        txtInfo.Value := "Cascaded: " cascadedCount " windows`n"
        txtInfo.Value .= "Monitor: " MonNum "`n"
        txtInfo.Value .= "Max cascades: " maxCascades "`n"
        txtInfo.Value .= "Next offset: " (cascadeIndex * offset)
    }

    ResetCascade(*) {
        cascadeIndex := 0
        txtInfo.Value := "Cascade index reset to 0"
    }
}

;=============================================================================
; EXAMPLE 5: Anchor-Based Positioner
;=============================================================================
; Positions windows relative to monitor anchors (corners, edges, center)
Example5_AnchorPositioner() {
    ; Create GUI
    g := Gui(, "Anchor-Based Window Positioner")
    g.SetFont("s9")

    anchors := ["Top-Left", "Top-Center", "Top-Right",
                "Middle-Left", "Center", "Middle-Right",
                "Bottom-Left", "Bottom-Center", "Bottom-Right"]

    g.Add("Text", , "Select anchor point:")

    for anchor in anchors {
        g.Add("Button", "w130", anchor).OnEvent("Click", PositionToAnchor.Bind(anchor))
        if Mod(A_Index, 3) = 0
            g.Add("Text", "xm", "")  ; New row
    }

    g.Add("Text", "xm Section", "Offset from anchor:")
    g.Add("Text", "xs w60", "X Offset:")
    edtOffsetX := g.Add("Edit", "x+5 w60", "0")
    g.Add("Text", "x+10 w60", "Y Offset:")
    edtOffsetY := g.Add("Edit", "x+5 w60", "0")

    g.Show()

    PositionToAnchor(anchor, *) {
        try {
            WinID := WinExist("A")
            if !WinID
                return

            WinGetPos(&WinX, &WinY, &WinW, &WinH, WinID)

            ; Find current monitor
            MonNum := 1
            Loop MonitorGetCount() {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                if (WinX >= Left && WinX < Right && WinY >= Top && WinY < Bottom) {
                    MonNum := A_Index
                    break
                }
            }

            MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

            MonWidth := Right - Left
            MonHeight := Bottom - Top

            ; Get offsets
            offsetX := Integer(edtOffsetX.Value)
            offsetY := Integer(edtOffsetY.Value)

            ; Calculate anchor position
            switch anchor {
                case "Top-Left":
                    NewX := Left + offsetX
                    NewY := Top + offsetY
                case "Top-Center":
                    NewX := Left + (MonWidth - WinW) // 2 + offsetX
                    NewY := Top + offsetY
                case "Top-Right":
                    NewX := Right - WinW + offsetX
                    NewY := Top + offsetY
                case "Middle-Left":
                    NewX := Left + offsetX
                    NewY := Top + (MonHeight - WinH) // 2 + offsetY
                case "Center":
                    NewX := Left + (MonWidth - WinW) // 2 + offsetX
                    NewY := Top + (MonHeight - WinH) // 2 + offsetY
                case "Middle-Right":
                    NewX := Right - WinW + offsetX
                    NewY := Top + (MonHeight - WinH) // 2 + offsetY
                case "Bottom-Left":
                    NewX := Left + offsetX
                    NewY := Bottom - WinH + offsetY
                case "Bottom-Center":
                    NewX := Left + (MonWidth - WinW) // 2 + offsetX
                    NewY := Bottom - WinH + offsetY
                case "Bottom-Right":
                    NewX := Right - WinW + offsetX
                    NewY := Bottom - WinH + offsetY
            }

            ; Constrain to monitor
            NewX := Max(Left, Min(NewX, Right - WinW))
            NewY := Max(Top, Min(NewY, Bottom - WinH))

            WinMove(NewX, NewY, , , WinID)
        }
    }
}

;=============================================================================
; EXAMPLE 6: Proportional Window Sizer
;=============================================================================
; Sizes windows based on monitor dimensions with aspect ratio preservation
Example6_ProportionalSizer() {
    ; Create GUI
    g := Gui(, "Proportional Window Sizer")
    g.SetFont("s10")

    g.Add("Text", "w120", "Monitor Fraction:")

    fractions := ["1/4", "1/3", "1/2", "2/3", "3/4", "Full"]
    for frac in fractions {
        g.Add("Button", "w80", frac).OnEvent("Click", ApplyFraction.Bind(frac))
        if Mod(A_Index, 3) = 0 && A_Index < fractions.Length
            g.Add("Text", "xm", "")
    }

    g.Add("Text", "xm Section", "Options:")
    chkAspect := g.Add("Checkbox", "xs", "Preserve Aspect Ratio")
    chkCenter := g.Add("Checkbox", "xs Checked", "Center After Resize")

    g.Show()

    ApplyFraction(fraction, *) {
        try {
            WinID := WinExist("A")
            if !WinID
                return

            WinGetPos(&X, &Y, &CurrentW, &CurrentH, WinID)

            ; Find monitor
            MonNum := 1
            Loop MonitorGetCount() {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                if (X >= Left && X < Right && Y >= Top && Y < Bottom) {
                    MonNum := A_Index
                    break
                }
            }

            MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

            MonWidth := Right - Left
            MonHeight := Bottom - Top

            ; Calculate fraction
            switch fraction {
                case "1/4": mult := 0.25
                case "1/3": mult := 0.333
                case "1/2": mult := 0.5
                case "2/3": mult := 0.667
                case "3/4": mult := 0.75
                case "Full": mult := 1.0
            }

            if chkAspect.Value {
                ; Preserve aspect ratio
                currentAspect := CurrentW / CurrentH
                NewW := Round(MonWidth * mult)
                NewH := Round(NewW / currentAspect)

                ; If height exceeds monitor, scale based on height instead
                if NewH > MonHeight * mult {
                    NewH := Round(MonHeight * mult)
                    NewW := Round(NewH * currentAspect)
                }
            } else {
                NewW := Round(MonWidth * mult)
                NewH := Round(MonHeight * mult)
            }

            if chkCenter.Value {
                NewX := Left + (MonWidth - NewW) // 2
                NewY := Top + (MonHeight - NewH) // 2
                WinMove(NewX, NewY, NewW, NewH, WinID)
            } else {
                WinMove(X, Y, NewW, NewH, WinID)
            }
        }
    }
}

;=============================================================================
; EXAMPLE 7: Multi-Monitor Window Distributor
;=============================================================================
; Evenly distributes windows across all monitors
Example7_WindowDistributor() {
    ; Create GUI
    g := Gui(, "Multi-Monitor Window Distributor")
    g.SetFont("s10")

    MonCount := MonitorGetCount()

    g.Add("Text", , "Distribution Strategy:")
    ddlStrategy := g.Add("DropDownList", "w200 Choose1", ["Even Distribution", "Fill Monitor by Monitor", "Round Robin"])

    g.Add("Text", "xm", "Window Size:")
    edtSize := g.Add("Edit", "w200", "70")
    g.Add("Text", , "% of monitor working area")

    g.Add("Button", "xm w200", "Distribute Windows").OnEvent("Click", Distribute)
    txtResult := g.Add("Text", "xm w300 h100 +Border")

    g.Show()

    Distribute(*) {
        strategy := ddlStrategy.Value
        sizePercent := Integer(edtSize.Value) / 100

        windowList := WinGetList(, , "Program Manager")
        winCount := 0
        for winID in windowList {
            if WinExist(winID)
                winCount++
        }

        if winCount = 0 {
            txtResult.Value := "No windows to distribute"
            return
        }

        switch strategy {
            case 1:  ; Even distribution
                winsPerMonitor := Ceil(winCount / MonCount)
                currentMon := 1
                monIndex := 0

                for winID in windowList {
                    if !WinExist(winID)
                        continue

                    MonitorGetWorkArea(currentMon, &Left, &Top, &Right, &Bottom)

                    MonWidth := Right - Left
                    MonHeight := Bottom - Top

                    NewW := Round(MonWidth * sizePercent)
                    NewH := Round(MonHeight * sizePercent)
                    NewX := Left + (MonWidth - NewW) // 2
                    NewY := Top + (MonHeight - NewH) // 2 + (monIndex * 30)

                    WinMove(NewX, NewY, NewW, NewH, winID)

                    monIndex++
                    if monIndex >= winsPerMonitor {
                        currentMon++
                        monIndex := 0
                        if currentMon > MonCount
                            currentMon := 1
                    }
                }

            case 2:  ; Fill monitor by monitor
                currentMon := 1
                for winID in windowList {
                    if !WinExist(winID)
                        continue

                    MonitorGetWorkArea(currentMon, &Left, &Top, &Right, &Bottom)

                    MonWidth := Right - Left
                    MonHeight := Bottom - Top

                    NewW := Round(MonWidth * sizePercent)
                    NewH := Round(MonHeight * sizePercent)
                    NewX := Left + (MonWidth - NewW) // 2
                    NewY := Top + (MonHeight - NewH) // 2

                    WinMove(NewX, NewY, NewW, NewH, winID)

                    currentMon++
                    if currentMon > MonCount
                        currentMon := 1
                }

            case 3:  ; Round robin
                monIndex := 1
                for winID in windowList {
                    if !WinExist(winID)
                        continue

                    MonitorGetWorkArea(monIndex, &Left, &Top, &Right, &Bottom)

                    MonWidth := Right - Left
                    MonHeight := Bottom - Top

                    NewW := Round(MonWidth * sizePercent)
                    NewH := Round(MonHeight * sizePercent)
                    NewX := Left + (MonWidth - NewW) // 2
                    NewY := Top + (MonHeight - NewH) // 2

                    WinMove(NewX, NewY, NewW, NewH, winID)

                    monIndex++
                    if monIndex > MonCount
                        monIndex := 1
                }
        }

        txtResult.Value := "Distributed " winCount " windows`n"
        txtResult.Value .= "Across " MonCount " monitor(s)`n"
        txtResult.Value .= "Strategy: " ddlStrategy.Text
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGet Window Positioning Examples")
    g.SetFont("s10")

    g.Add("Text", "w450", "Select an example to run:")

    g.Add("Button", "w450", "Example 1: Percentage-Based Positioner").OnEvent("Click", (*) => Example1_PercentagePositioner())
    g.Add("Button", "w450", "Example 2: Grid-Based Snapper").OnEvent("Click", (*) => Example2_GridSnapper())
    g.Add("Button", "w450", "Example 3: Smart Window Constrainer").OnEvent("Click", (*) => Example3_SmartConstrainer())
    g.Add("Button", "w450", "Example 4: Window Cascade Manager").OnEvent("Click", (*) => Example4_CascadeManager())
    g.Add("Button", "w450", "Example 5: Anchor-Based Positioner").OnEvent("Click", (*) => Example5_AnchorPositioner())
    g.Add("Button", "w450", "Example 6: Proportional Window Sizer").OnEvent("Click", (*) => Example6_ProportionalSizer())
    g.Add("Button", "w450", "Example 7: Multi-Monitor Distributor").OnEvent("Click", (*) => Example7_WindowDistributor())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
