#Requires AutoHotkey v2.0

/**
* BuiltIn_MonitorGetCount_01_BasicUsage.ahk
*
* DESCRIPTION:
* Demonstrates basic usage of MonitorGetCount function for determining the
* number of connected monitors. Shows how to query monitor count and use
* this information for adaptive UI and window management.
*
* FEATURES:
* - Retrieving total monitor count
* - Validating monitor numbers
* - Iterating through all monitors
* - Conditional logic based on monitor count
* - Monitor count change detection
* - Single vs multi-monitor handling
* - Monitor availability checks
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/MonitorGetCount.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - MonitorGetCount function
* - Loop iteration with monitor count
* - Modern GUI controls
* - Timer-based monitoring
* - Fat arrow functions
* - Object-based data structures
*
* LEARNING POINTS:
* 1. MonitorGetCount returns total number of connected monitors
* 2. Monitor numbers range from 1 to MonitorGetCount()
* 3. Count includes all connected displays, even if inactive
* 4. Monitor count can change when displays are connected/disconnected
* 5. Always validate monitor numbers against current count
* 6. Use count for loop boundaries when iterating monitors
* 7. Count > 1 indicates multi-monitor setup
*/

;=============================================================================
; EXAMPLE 1: Basic Monitor Count Display
;=============================================================================
; Simple display of monitor count with basic information
Example1_BasicDisplay() {
    ; Get monitor count
    MonCount := MonitorGetCount()

    ; Build information message
    info := "MONITOR COUNT INFORMATION`n"
    info .= "=========================`n`n"
    info .= "Total Monitors Detected: " MonCount "`n`n"

    ; Add interpretation
    if MonCount = 1
    info .= "Configuration: Single Monitor Setup`n"
    else if MonCount = 2
    info .= "Configuration: Dual Monitor Setup`n"
    else if MonCount = 3
    info .= "Configuration: Triple Monitor Setup`n"
    else
    info .= "Configuration: Multi-Monitor Setup (" MonCount " displays)`n"

    info .= "`nMonitor Range: 1 to " MonCount "`n"

    ; Add some basic stats for each monitor
    info .= "`nPer-Monitor Summary:`n"
    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)
        Width := Right - Left
        Height := Bottom - Top

        info .= "  Monitor " MonNum ": " Width "x" Height
        if A_Index = MonitorGetPrimary()
        info .= " (Primary)"
        info .= "`n"
    }

    MsgBox(info, "Example 1: Basic Monitor Count", "Icon!")
}

;=============================================================================
; EXAMPLE 2: Monitor Count Validator
;=============================================================================
; Validates monitor numbers against current count
Example2_MonitorValidator() {
    ; Create GUI
    g := Gui(, "Monitor Number Validator")
    g.SetFont("s10")

    MonCount := MonitorGetCount()

    g.Add("Text", , "Current Monitor Count: " MonCount)
    g.Add("Text", , "Valid Range: 1 to " MonCount)

    g.Add("Text", "xm Section", "Enter Monitor Number to Validate:")
    edtMonitor := g.Add("Edit", "xs w100")

    g.Add("Button", "xs w120", "Validate").OnEvent("Click", ValidateMonitor)
    txtResult := g.Add("Text", "xs w400 h200 +Border")

    g.Show()

    ValidateMonitor(*) {
        testNum := edtMonitor.Value

        result := "VALIDATION RESULTS`n"
        result .= "==================`n`n"
        result .= "Input: " testNum "`n"
        result .= "Current Monitor Count: " MonCount "`n`n"

        ; Check if numeric
        if !IsNumber(testNum) {
            result .= "Status: ✗ INVALID`n"
            result .= "Reason: Not a number`n"
            txtResult.Value := result
            return
        }

        testNum := Integer(testNum)

        ; Check if in range
        if testNum < 1 {
            result .= "Status: ✗ INVALID`n"
            result .= "Reason: Below minimum (1)`n"
            result .= "Offset: " (testNum - 1) " below range"
        } else if testNum > MonCount {
            result .= "Status: ✗ INVALID`n"
            result .= "Reason: Above maximum (" MonCount ")`n"
            result .= "Offset: " (testNum - MonCount) " above range"
        } else {
            result .= "Status: ✓ VALID`n`n"
            result .= "Monitor Information:`n"

            try {
                MonitorGet(testNum, &Left, &Top, &Right, &Bottom)
                result .= "  Bounds: " Left "," Top " to " Right "," Bottom "`n"
                result .= "  Size: " (Right-Left) "x" (Bottom-Top) "`n"

                if testNum = MonitorGetPrimary()
                result .= "  Type: Primary Monitor`n"
                else
                result .= "  Type: Secondary Monitor`n"
            } catch as err {
                result .= "  Error retrieving info: " err.Message
            }
        }

        txtResult.Value := result
    }
}

;=============================================================================
; EXAMPLE 3: Monitor Count Iterator
;=============================================================================
; Demonstrates iterating through all monitors using count
Example3_MonitorIterator() {
    ; Create GUI
    g := Gui("+Resize", "Monitor Iterator")
    g.SetFont("s9", "Consolas")

    MonCount := MonitorGetCount()

    ; Add header
    g.Add("Text", "w600", "Iterating through " MonCount " monitor(s):")

    ; Create ListView
    lv := g.Add("ListView", "w700 h300", [
    "#", "Left", "Top", "Right", "Bottom",
    "Width", "Height", "Area (px²)", "Type"
    ])

    ; Iterate through all monitors
    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        Width := Right - Left
        Height := Bottom - Top
        Area := Width * Height
        MonType := (MonNum = MonitorGetPrimary()) ? "Primary" : "Secondary"

        lv.Add("", MonNum, Left, Top, Right, Bottom, Width, Height, Format("{:,}", Area), MonType)
    }

    ; Auto-size columns
    Loop lv.GetCount("Column")
    lv.ModifyCol(A_Index, "AutoHdr")

    ; Add statistics
    g.Add("Text", "xm w700 Section", "Statistics:")

    totalArea := 0
    Loop MonCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        totalArea += (Right - Left) * (Bottom - Top)
    }

    avgArea := totalArea // MonCount

    stats := "  Total Monitors: " MonCount "`n"
    stats .= "  Total Screen Area: " Format("{:,}", totalArea) " pixels²`n"
    stats .= "  Average Monitor Area: " Format("{:,}", avgArea) " pixels²"

    g.Add("Text", "xs", stats)

    ; Refresh button
    g.Add("Button", "xm w100", "Refresh").OnEvent("Click", (*) => (g.Destroy(), Example3_MonitorIterator()))

    g.Show()
}

;=============================================================================
; EXAMPLE 4: Conditional Monitor Logic
;=============================================================================
; Shows different behaviors based on monitor count
Example4_ConditionalLogic() {
    MonCount := MonitorGetCount()

    ; Create appropriate GUI based on monitor count
    g := Gui(, "Adaptive Monitor Layout")
    g.SetFont("s10")

    g.Add("Text", , "Detected: " MonCount " Monitor(s)")

    if MonCount = 1 {
        ; Single monitor mode
        g.Add("Text", "xm Section w400", "SINGLE MONITOR MODE")
        g.Add("Text", "xs w400", "")
        g.Add("Text", "xs", "Available Features:")
        g.Add("Button", "xs w200", "Center Window").OnEvent("Click", CenterOnMain)
        g.Add("Button", "xs w200", "Maximize Window").OnEvent("Click", MaximizeOnMain)
        g.Add("Button", "xs w200", "Tile Windows").OnEvent("Click", TileOnMain)

    } else if MonCount = 2 {
        ; Dual monitor mode
        g.Add("Text", "xm Section w400", "DUAL MONITOR MODE")
        g.Add("Text", "xs w400", "")
        g.Add("Text", "xs", "Available Features:")
        g.Add("Button", "xs w200", "Span Across Monitors").OnEvent("Click", SpanBoth)
        g.Add("Button", "xs w200", "Move to Monitor 1").OnEvent("Click", (*) => MoveToMon(1))
        g.Add("Button", "xs w200", "Move to Monitor 2").OnEvent("Click", (*) => MoveToMon(2))
        g.Add("Button", "xs w200", "Clone to Both").OnEvent("Click", CloneToBoth)

    } else {
        ; Multi-monitor mode (3+)
        g.Add("Text", "xm Section w400", "MULTI-MONITOR MODE (" MonCount " displays)")
        g.Add("Text", "xs w400", "")
        g.Add("Text", "xs", "Select Target Monitor:")

        Loop MonCount {
            MonNum := A_Index
            isPrimary := (MonNum = MonitorGetPrimary())
            label := "Monitor " MonNum (isPrimary ? " (Primary)" : "")
            g.Add("Button", "xs w200", label).OnEvent("Click", (*) => MoveToMon(MonNum))
        }

        g.Add("Button", "xs w200", "Distribute Windows").OnEvent("Click", DistributeAll)
    }

    g.Show()

    ; Helper functions
    CenterOnMain(*) {
        try {
            WinID := WinExist("A")
            if !WinID
            return

            MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)
            WinGetPos(, , &W, &H, WinID)

            NewX := Left + ((Right - Left - W) // 2)
            NewY := Top + ((Bottom - Top - H) // 2)

            WinMove(NewX, NewY, , , WinID)
        }
    }

    MaximizeOnMain(*) {
        try {
            WinID := WinExist("A")
            if WinID
            WinMaximize(WinID)
        }
    }

    TileOnMain(*) {
        MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)
        windowList := WinGetList()

        count := 0
        for winID in windowList {
            if WinExist(winID)
            count++
        }

        if count = 0
        return

        cols := Ceil(Sqrt(count))
        rows := Ceil(count / cols)

        Width := (Right - Left) // cols
        Height := (Bottom - Top) // rows

        index := 0
        for winID in windowList {
            if !WinExist(winID)
            continue

            row := index // cols
            col := Mod(index, cols)

            X := Left + (col * Width)
            Y := Top + (row * Height)

            WinMove(X, Y, Width, Height, winID)
            index++
        }
    }

    SpanBoth(*) {
        try {
            WinID := WinExist("A")
            if !WinID
            return

            ; Get bounds of both monitors
            MonitorGet(1, &L1, &T1, &R1, &B1)
            MonitorGet(2, &L2, &T2, &R2, &B2)

            ; Calculate spanning bounds
            Left := Min(L1, L2)
            Top := Min(T1, T2)
            Right := Max(R1, R2)
            Bottom := Max(B1, B2)

            WinMove(Left, Top, Right - Left, Bottom - Top, WinID)
        }
    }

    MoveToMon(MonNum) {
        try {
            WinID := WinExist("A")
            if !WinID
            return

            MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)
            WinGetPos(, , &W, &H, WinID)

            NewX := Left + ((Right - Left - W) // 2)
            NewY := Top + ((Bottom - Top - H) // 2)

            WinMove(NewX, NewY, , , WinID)
        }
    }

    CloneToBoth(*) {
        MsgBox("Clone feature would duplicate window to both monitors", "Info", "Icon!")
    }

    DistributeAll(*) {
        windowList := WinGetList()
        monIndex := 1

        for winID in windowList {
            if !WinExist(winID)
            continue

            MonitorGetWorkArea(monIndex, &Left, &Top, &Right, &Bottom)
            WinGetPos(, , &W, &H, winID)

            NewX := Left + ((Right - Left - W) // 2)
            NewY := Top + ((Bottom - Top - H) // 2)

            WinMove(NewX, NewY, , , winID)

            monIndex++
            if monIndex > MonCount
            monIndex := 1
        }
    }
}

;=============================================================================
; EXAMPLE 5: Monitor Count Range Checker
;=============================================================================
; Provides utilities for checking if count is within expected ranges
Example5_RangeChecker() {
    ; Create GUI
    g := Gui(, "Monitor Count Range Checker")
    g.SetFont("s10")

    MonCount := MonitorGetCount()

    g.Add("Text", "w300", "Current Monitor Count: " MonCount)

    ; Define common range checks
    checks := [
    {
        Name: "Has Any Monitors", Min: 1, Max: 999},
        {
            Name: "Single Monitor Only", Min: 1, Max: 1},
            {
                Name: "Multi-Monitor Setup", Min: 2, Max: 999},
                {
                    Name: "Dual Monitor Setup", Min: 2, Max: 2},
                    {
                        Name: "Triple Monitor Setup", Min: 3, Max: 3},
                        {
                            Name: "Gaming Setup (1-3)", Min: 1, Max: 3},
                            {
                                Name: "Workstation (3+)", Min: 3, Max: 999},
                                {
                                    Name: "Ultra-Wide Equivalent (1-2)", Min: 1, Max: 2
                                }
                                ]

                                g.Add("Text", "xm Section", "Configuration Checks:")

                                lv := g.Add("ListView", "xs w500 h250", ["Check", "Status", "Range", "Result"])

                                for check in checks {
                                    inRange := (MonCount >= check.Min && MonCount <= check.Max)
                                    status := inRange ? "✓ PASS" : "✗ FAIL"
                                    rangeStr := check.Min "-" (check.Max = 999 ? "∞" : check.Max)
                                    result := inRange ? "Compatible" : "Not Compatible"

                                    lv.Add("", check.Name, status, rangeStr, result)
                                }

                                Loop lv.GetCount("Column")
                                lv.ModifyCol(A_Index, "AutoHdr")

                                g.Show()
                            }

                            ;=============================================================================
                            ; EXAMPLE 6: Monitor Count-Based Window Sizing
                            ;=============================================================================
                            ; Adjusts window sizes based on total number of monitors
                            Example6_AdaptiveSizing() {
                                ; Create GUI
                                g := Gui(, "Monitor Count-Based Sizing")
                                g.SetFont("s10")

                                MonCount := MonitorGetCount()

                                g.Add("Text", , "Monitor Count: " MonCount)
                                g.Add("Text", , "Window Size Strategy:")

                                ; Calculate recommended window size based on monitor count
                                MonitorGet(1, &Left, &Top, &Right, &Bottom)
                                MonWidth := Right - Left
                                MonHeight := Bottom - Top

                                ; Adjust sizing strategy based on count
                                if MonCount = 1 {
                                    strategy := "Maximize Usage (80% screen)"
                                    widthPercent := 0.8
                                    heightPercent := 0.8
                                } else if MonCount = 2 {
                                    strategy := "Dual-Optimized (60% screen)"
                                    widthPercent := 0.6
                                    heightPercent := 0.7
                                } else {
                                    strategy := "Multi-Monitor (50% screen)"
                                    widthPercent := 0.5
                                    heightPercent := 0.6
                                }

                                recommendedW := Round(MonWidth * widthPercent)
                                recommendedH := Round(MonHeight * heightPercent)

                                g.Add("Text", "xm", "  " strategy)
                                g.Add("Text", "xm", "  Recommended: " recommendedW " x " recommendedH)

                                g.Add("Button", "xm w200", "Apply to Active Window").OnEvent("Click", ApplySize)

                                g.Add("Text", "xm Section", "Size Breakdown:")
                                info := "  Monitor 1 Size: " MonWidth " x " MonHeight "`n"
                                info .= "  Width Multiplier: " Round(widthPercent * 100) "%`n"
                                info .= "  Height Multiplier: " Round(heightPercent * 100) "%`n"
                                info .= "  Total Monitors: " MonCount

                                g.Add("Text", "xs", info)

                                g.Show()

                                ApplySize(*) {
                                    try {
                                        WinID := WinExist("A")
                                        if !WinID
                                        return

                                        MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)

                                        NewW := recommendedW
                                        NewH := recommendedH
                                        NewX := Left + ((Right - Left - NewW) // 2)
                                        NewY := Top + ((Bottom - Top - NewH) // 2)

                                        WinMove(NewX, NewY, NewW, NewH, WinID)
                                    }
                                }
                            }

                            ;=============================================================================
                            ; EXAMPLE 7: Monitor Count Information Panel
                            ;=============================================================================
                            ; Comprehensive information panel about monitor count
                            Example7_InformationPanel() {
                                MonCount := MonitorGetCount()
                                PrimaryNum := MonitorGetPrimary()

                                ; Create GUI
                                g := Gui(, "Monitor Count Information Panel")
                                g.SetFont("s9", "Consolas")

                                info := "╔════════════════════════════════════════════╗`n"
                                info .= "║     MONITOR CONFIGURATION DETAILS          ║`n"
                                info .= "╚════════════════════════════════════════════╝`n`n"

                                info .= "Total Monitors: " MonCount "`n"
                                info .= "Primary Monitor: #" PrimaryNum "`n"
                                info .= "Secondary Monitors: " (MonCount - 1) "`n`n"

                                info .= "Valid Monitor Range: 1 to " MonCount "`n`n"

                                info .= "Configuration Type:`n"
                                switch MonCount {
                                    case 1: info .= "  → Single Monitor`n"
                                    case 2: info .= "  → Dual Monitor`n"
                                    case 3: info .= "  → Triple Monitor`n"
                                    case 4: info .= "  → Quad Monitor`n"
                                    default: info .= "  → Multi-Monitor (" MonCount " displays)`n"
                                }

                                info .= "`nRecommendations:`n"
                                if MonCount = 1 {
                                    info .= "  • Use full-screen or maximized layouts`n"
                                    info .= "  • Consider window tiling utilities`n"
                                }
                                else if MonCount = 2 {
                                    info .= "  • Extend workspace across both monitors`n"
                                    info .= "  • Use one for main work, one for reference`n"
                                }
                                else {
                                    info .= "  • Distribute applications by function`n"
                                    info .= "  • Consider specialized monitor roles`n"
                                }

                                info .= "
                                (
                                Iteration Example:
                                Loop " MonCount " {
                                    MonNum := A_Index
                                    ; Process monitor MonNum
                                }
                                )"

                                g.Add("Text", "w500", info)

                                g.Add("Button", "xm w200", "Copy to Clipboard").OnEvent("Click", (*) => (A_Clipboard := info, MsgBox("Copied!", "Success")))

                                g.Show()
                            }

                            ;=============================================================================
                            ; MAIN MENU
                            ;=============================================================================
                            CreateMainMenu() {
                                g := Gui(, "MonitorGetCount Basic Usage Examples")
                                g.SetFont("s10")

                                MonCount := MonitorGetCount()
                                g.Add("Text", "w450", "Current System: " MonCount " Monitor(s) Detected")
                                g.Add("Text", "w450", "Select an example to run:")

                                g.Add("Button", "w450", "Example 1: Basic Display").OnEvent("Click", (*) => Example1_BasicDisplay())
                                g.Add("Button", "w450", "Example 2: Monitor Validator").OnEvent("Click", (*) => Example2_MonitorValidator())
                                g.Add("Button", "w450", "Example 3: Monitor Iterator").OnEvent("Click", (*) => Example3_MonitorIterator())
                                g.Add("Button", "w450", "Example 4: Conditional Logic").OnEvent("Click", (*) => Example4_ConditionalLogic())
                                g.Add("Button", "w450", "Example 5: Range Checker").OnEvent("Click", (*) => Example5_RangeChecker())
                                g.Add("Button", "w450", "Example 6: Adaptive Sizing").OnEvent("Click", (*) => Example6_AdaptiveSizing())
                                g.Add("Button", "w450", "Example 7: Information Panel").OnEvent("Click", (*) => Example7_InformationPanel())

                                g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

                                g.Show()
                            }

                            CreateMainMenu()
