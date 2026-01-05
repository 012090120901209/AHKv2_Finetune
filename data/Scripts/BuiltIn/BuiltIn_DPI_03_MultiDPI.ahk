#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_DPI_03_MultiDPI.ahk
 * 
 * DESCRIPTION:
 * Advanced multi-monitor DPI handling in AutoHotkey v2. Demonstrates managing
 * applications across monitors with different DPI settings, per-monitor DPI
 * awareness, and dynamic adaptation to DPI changes.
 * 
 * FEATURES:
 * - Per-monitor DPI detection
 * - Cross-monitor DPI adaptation
 * - DPI-aware window positioning
 * - Mixed DPI environment handling
 * - DPI change notifications
 * - Multi-DPI GUI management
 * - DPI topology visualization
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * Windows Per-Monitor DPI Awareness
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Per-monitor DPI querying
 * - DPI-aware multi-monitor support
 * - Dynamic DPI adaptation
 * - Cross-DPI window management
 * - DPI event handling
 * 
 * LEARNING POINTS:
 * 1. Each monitor can have different DPI settings
 * 2. Windows 8.1+ supports per-monitor DPI
 * 3. Apps must adapt when moving between monitors
 * 4. Use GetDpiForMonitor for per-monitor DPI
 * 5. Monitor DPI can change dynamically
 * 6. Test with mixed DPI configurations
 * 7. Per-monitor DPI v2 provides best experience
 */

;=============================================================================
; HELPER: Get DPI for Specific Monitor
;=============================================================================
GetMonitorDPI(monNum) {
    ; Get monitor bounds
    MonitorGet(monNum, &Left, &Top, &Right, &Bottom)

    ; Get center point
    centerX := (Left + Right) // 2
    centerY := (Top + Bottom) // 2

    ; Get monitor handle
    MONITOR_DEFAULTTONEAREST := 2
    hMonitor := DllCall("MonitorFromPoint",
        "Int64", (centerY << 32) | (centerX & 0xFFFFFFFF),
        "UInt", MONITOR_DEFAULTTONEAREST,
        "Ptr")

    ; Try to get per-monitor DPI
    try {
        dpiX := 0
        dpiY := 0
        MDT_EFFECTIVE_DPI := 0

        result := DllCall("Shcore\GetDpiForMonitor",
            "Ptr", hMonitor,
            "Int", MDT_EFFECTIVE_DPI,
            "UInt*", &dpiX,
            "UInt*", &dpiY,
            "Int")

        if result = 0
            return { DPI: dpiX, Scale: dpiX / 96, Percent: Round(dpiX / 96 * 100) }
    }

    ; Fallback to system DPI
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    dpi := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    return { DPI: dpi, Scale: dpi / 96, Percent: Round(dpi / 96 * 100) }
}

;=============================================================================
; EXAMPLE 1: Per-Monitor DPI Map
;=============================================================================
; Creates visual map showing DPI for each monitor
Example1_DPIMap() {
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Per-Monitor DPI Map")
    g.SetFont("s10")

    g.Add("Text", "w600", "DPI Settings Across All Monitors")

    lv := g.Add("ListView", "w650 h250", [
        "Monitor", "DPI", "Scaling %", "Resolution", "Type", "Status"
    ])

    ; Check each monitor
    dpiSettings := Map()
    uniqueDPIs := Map()

    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        dpiInfo := GetMonitorDPI(MonNum)
        dpiSettings[MonNum] := dpiInfo

        ; Track unique DPI values
        if !uniqueDPIs.Has(dpiInfo.DPI)
            uniqueDPIs[dpiInfo.DPI] := []
        uniqueDPIs[dpiInfo.DPI].Push(MonNum)

        resolution := (Right - Left) "×" (Bottom - Top)
        type := (MonNum = MonitorGetPrimary()) ? "Primary" : "Secondary"

        status := ""
        if dpiInfo.DPI = 96
            status := "Standard"
        else if dpiInfo.DPI > 144
            status := "High DPI"
        else
            status := "Scaled"

        lv.Add("", MonNum, dpiInfo.DPI, dpiInfo.Percent "%", resolution, type, status)
    }

    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    ; Summary
    summary := "`nDPI Configuration Summary:`n"
    summary .= "  Total Monitors: " MonCount "`n"
    summary .= "  Unique DPI Settings: " uniqueDPIs.Count "`n`n"

    if uniqueDPIs.Count = 1
        summary .= "  ✓ Uniform DPI across all monitors`n"
    else {
        summary .= "  ⚠ Mixed DPI configuration:`n"
        for dpi, monitors in uniqueDPIs {
            summary .= "    " dpi " DPI: Monitor(s) "
            for mon in monitors
                summary .= mon " "
            summary .= "`n"
        }
    }

    g.Add("Text", "xm w650 +Border", summary)

    g.Show()
}

;=============================================================================
; EXAMPLE 2: DPI-Aware Window Mover
;=============================================================================
; Moves windows between monitors with DPI adaptation
Example2_DPIAwareWindowMover() {
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "DPI-Aware Window Mover")
    g.SetFont("s10")

    g.Add("Text", "w450", "Move windows between monitors with DPI adaptation")

    ; Monitor selection
    g.Add("Text", "xm Section", "Target Monitor:")
    cmbMonitor := g.Add("ComboBox", "xs w150 Choose1")

    Loop MonCount {
        dpiInfo := GetMonitorDPI(A_Index)
        cmbMonitor.Add(["Monitor " A_Index " (" dpiInfo.Percent "%)"])
    }

    chkAdaptSize := g.Add("Checkbox", "xm Checked", "Adapt window size to target DPI")
    chkAdaptPos := g.Add("Checkbox", "xm Checked", "Center on target monitor")

    g.Add("Button", "xm w200", "Move Active Window").OnEvent("Click", MoveWindow)

    txtLog := g.Add("Edit", "xm w450 h200 ReadOnly +Multi")

    g.Show()

    MoveWindow(*) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd {
                Log("No suitable window to move")
                return
            }

            targetMon := cmbMonitor.Value
            WinTitle := WinGetTitle(WinID)

            ; Get current window info
            WinGetPos(&WinX, &WinY, &WinW, &WinH, WinID)

            ; Find current monitor
            currentMon := 1
            Loop MonCount {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
                if (WinX >= Left && WinX < Right && WinY >= Top && WinY < Bottom) {
                    currentMon := A_Index
                    break
                }
            }

            ; Get DPI info
            sourceDPI := GetMonitorDPI(currentMon)
            targetDPI := GetMonitorDPI(targetMon)

            Log("Moving window: " SubStr(WinTitle, 1, 30))
            Log("  From: Monitor " currentMon " (" sourceDPI.Percent "%)")
            Log("  To: Monitor " targetMon " (" targetDPI.Percent "%)")

            ; Get target monitor bounds
            MonitorGetWorkArea(targetMon, &Left, &Top, &Right, &Bottom)

            ; Calculate new size if adapting
            if chkAdaptSize.Value {
                scaleFactor := targetDPI.Scale / sourceDPI.Scale
                NewW := Round(WinW * scaleFactor)
                NewH := Round(WinH * scaleFactor)
                Log("  Adapted size: " WinW "×" WinH " → " NewW "×" NewH)
            } else {
                NewW := WinW
                NewH := WinH
                Log("  Keeping original size: " WinW "×" WinH)
            }

            ; Calculate position
            if chkAdaptPos.Value {
                NewX := Left + ((Right - Left - NewW) // 2)
                NewY := Top + ((Bottom - Top - NewH) // 2)
                Log("  Centered at: " NewX "," NewY)
            } else {
                NewX := Left + 50
                NewY := Top + 50
                Log("  Positioned at: " NewX "," NewY)
            }

            ; Move window
            WinMove(NewX, NewY, NewW, NewH, WinID)
            Log("  ✓ Move complete`n")
        }
    }

    Log(msg) {
        txtLog.Value .= msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 3: Multi-DPI Window Creator
;=============================================================================
; Creates windows properly sized for each monitor's DPI
Example3_MultiDPIWindowCreator() {
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Multi-DPI Window Creator")
    g.SetFont("s10")

    g.Add("Text", "w450", "Create DPI-appropriate windows on each monitor")

    g.Add("Text", "xm Section", "Base Size (at 100% DPI):")
    edtWidth := g.Add("Edit", "xs w80", "400")
    g.Add("Text", "x+10", "×")
    edtHeight := g.Add("Edit", "x+10 w80", "300")

    g.Add("Button", "xm w200", "Create Windows").OnEvent("Click", CreateWindows)
    g.Add("Button", "x+10 w200", "Close All Test Windows").OnEvent("Click", CloseAllTest)

    txtStatus := g.Add("Text", "xm w450 h150 +Border")

    testWindows := []

    g.Show()

    CreateWindows(*) {
        baseW := Integer(edtWidth.Value)
        baseH := Integer(edtHeight.Value)

        testWindows := []

        status := "Creating DPI-appropriate windows...`n`n"

        Loop MonCount {
            MonNum := A_Index
            dpiInfo := GetMonitorDPI(MonNum)

            ; Calculate scaled size
            scaledW := Round(baseW * dpiInfo.Scale)
            scaledH := Round(baseH * dpiInfo.Scale)

            ; Get monitor position
            MonitorGetWorkArea(MonNum, &Left, &Top, &Right, &Bottom)

            ; Create window
            testWin := Gui("+AlwaysOnTop", "Monitor " MonNum " - " dpiInfo.Percent "%")
            testWin.BackColor := MonNum = MonitorGetPrimary() ? "0xFFD700" : "0x4169E1"
            testWin.SetFont("s" Round(10 * dpiInfo.Scale))

            info := "Monitor " MonNum "`n"
            info .= dpiInfo.Percent "% DPI`n"
            info .= scaledW "×" scaledH " pixels"

            testWin.Add("Text", "w" (scaledW - 40) " h" (scaledH - 40) " +Center c0xFFFFFF", info)

            X := Left + ((Right - Left - scaledW) // 2)
            Y := Top + ((Bottom - Top - scaledH) // 2)

            testWin.Show("x" X " y" Y " w" scaledW " h" scaledH " NA")

            testWindows.Push(testWin.Hwnd)

            status .= "Monitor " MonNum ": " scaledW "×" scaledH " at " dpiInfo.Percent "%`n"
        }

        txtStatus.Value := status
    }

    CloseAllTest(*) {
        for hwnd in testWindows {
            if WinExist(hwnd)
                WinClose(hwnd)
        }
        testWindows := []
        txtStatus.Value := "All test windows closed"
    }
}

;=============================================================================
; EXAMPLE 4: DPI Topology Visualizer
;=============================================================================
; Visual representation of DPI distribution across monitors
Example4_DPITopology() {
    MonCount := MonitorGetCount()

    ; Get virtual desktop bounds
    virtualLeft := 999999
    virtualTop := 999999
    virtualRight := -999999
    virtualBottom := -999999

    monitors := []

    Loop MonCount {
        MonitorGet(A_Index, &L, &T, &R, &B)
        dpiInfo := GetMonitorDPI(A_Index)

        monitors.Push({
            Num: A_Index,
            Left: L,
            Top: T,
            Right: R,
            Bottom: B,
            DPI: dpiInfo
        })

        virtualLeft := Min(virtualLeft, L)
        virtualTop := Min(virtualTop, T)
        virtualRight := Max(virtualRight, R)
        virtualBottom := Max(virtualBottom, B)
    }

    ; Create GUI
    g := Gui(, "DPI Topology Visualizer")
    g.BackColor := "0x2B2B2B"

    g.Add("Text", "w750 cWhite Center", "DPI Distribution Across Monitors")

    ; Calculate scale
    virtualWidth := virtualRight - virtualLeft
    virtualHeight := virtualBottom - virtualTop
    scale := Min(700 / virtualWidth, 450 / virtualHeight)

    ; Draw monitors with DPI-based colors
    for mon in monitors {
        x := Round((mon.Left - virtualLeft) * scale) + 25
        y := Round((mon.Top - virtualTop) * scale) + 60
        w := Round((mon.Right - mon.Left) * scale)
        h := Round((mon.Bottom - mon.Top) * scale)

        ; Color based on DPI
        switch mon.DPI.Percent {
            case 100: color := "0x00AA00"  ; Green - Standard
            case 125: color := "0xFFAA00"  ; Orange - Medium
            case 150: color := "0xFF6600"  ; Dark Orange - Large
            case 200: color := "0xFF0000"  ; Red - Very Large
            default: color := "0x4169E1"  ; Blue - Custom
        }

        ; Monitor rectangle
        g.Add("Progress", "x" x " y" y " w" w " h" h " Background" color " c" color, 100)

        ; Labels
        labelText := "Monitor " mon.Num "`n" mon.DPI.Percent "%`n" mon.DPI.DPI " DPI"
        g.Add("Text", "x" (x + w // 2 - 40) " y" (y + h // 2 - 20) " w80 h40 +Center BackgroundTrans cWhite",
            labelText)
    }

    ; Legend
    g.Add("Text", "x25 y+20 cWhite", "■ Green: 100%  ■ Orange: 125%  ■ Dark Orange: 150%  ■ Red: 200%  ■ Blue: Custom")

    g.Show("w800 h" (Round(virtualHeight * scale) + 120))
}

;=============================================================================
; EXAMPLE 5: Cross-DPI Content Manager
;=============================================================================
; Manages content that needs to work across different DPI settings
Example5_ContentManager() {
    ; Create GUI
    g := Gui(, "Cross-DPI Content Manager")
    g.SetFont("s10")

    g.Add("Text", "w500", "Manage content for multiple DPI settings")

    MonCount := MonitorGetCount()

    ; Analyze DPI distribution
    dpiSummary := "Monitor DPI Summary:`n"

    dpiMap := Map()
    Loop MonCount {
        dpiInfo := GetMonitorDPI(A_Index)

        if !dpiMap.Has(dpiInfo.DPI)
            dpiMap[dpiInfo.DPI] := []
        dpiMap[dpiInfo.DPI].Push(A_Index)
    }

    for dpi, monitors in dpiMap {
        dpiSummary .= "  " dpi " DPI (" Round(dpi / 96 * 100) "%): Monitor(s) "
        for mon in monitors
            dpiSummary .= mon " "
        dpiSummary .= "`n"
    }

    g.Add("Text", "xm w500 +Border", dpiSummary)

    ; Content scaling recommendations
    g.Add("Text", "xm Section", "`nContent Scaling Recommendations:")

    recommendations := ""

    if dpiMap.Count = 1 {
        recommendations := "  ✓ Uniform DPI - Single set of assets sufficient`n"
        recommendations .= "  • Create assets at current DPI`n"
        recommendations .= "  • No cross-DPI adaptation needed"
    } else {
        recommendations := "  ⚠ Mixed DPI - Multiple asset sets recommended`n"
        recommendations .= "  • Create assets for each DPI setting:`n"

        for dpi in dpiMap
            recommendations .= "    - " dpi " DPI (" Round(dpi / 96 * 100) "%) version`n"

        recommendations .= "  • Implement dynamic asset loading`n"
        recommendations .= "  • Test on each monitor configuration"
    }

    g.Add("Text", "xs w500", recommendations)

    g.Show()
}

;=============================================================================
; EXAMPLE 6: DPI Change Event Handler
;=============================================================================
; Handles DPI changes when window moves between monitors
Example6_DPIChangeHandler() {
    currentDPI := 0
    currentMon := 0

    ; Create GUI
    g := Gui("+Resize", "DPI Change Event Handler")
    g.SetFont("s10")

    g.Add("Text", "w450", "Drag window between monitors to detect DPI changes")

    txtStatus := g.Add("Text", "xm w450 h80 +Border")
    txtLog := g.Add("Edit", "xm w450 h200 ReadOnly +Multi")

    UpdateDPI()

    ; Monitor for changes
    SetTimer(CheckDPIChange, 500)

    g.OnEvent("Close", (*) => (SetTimer(CheckDPIChange, 0), g.Destroy()))
    g.Show()

    CheckDPIChange() {
        ; Get window position
        g.GetPos(&X, &Y)

        ; Find current monitor
        newMon := 1
        Loop MonitorGetCount() {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (X >= Left && X < Right && Y >= Top && Y < Bottom) {
                newMon := A_Index
                break
            }
        }

        ; Check if monitor or DPI changed
        newDPIInfo := GetMonitorDPI(newMon)

        if newMon != currentMon || newDPIInfo.DPI != currentDPI {
            Log("Monitor changed: " currentMon " → " newMon)
            Log("DPI changed: " currentDPI " → " newDPIInfo.DPI)
            Log("Scaling changed: " Round(currentDPI / 96 * 100) "% → " newDPIInfo.Percent "%`n")

            currentMon := newMon
            currentDPI := newDPIInfo.DPI

            UpdateDPI()
        }
    }

    UpdateDPI() {
        dpiInfo := GetMonitorDPI(currentMon)
        currentDPI := dpiInfo.DPI

        status := "Current Monitor: " currentMon "`n"
        status .= "Current DPI: " dpiInfo.DPI " (" dpiInfo.Percent "%)`n"
        status .= "Scale Factor: " Round(dpiInfo.Scale, 2) "x"

        txtStatus.Value := status
    }

    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 7: Multi-DPI Testing Suite
;=============================================================================
; Comprehensive testing tool for multi-DPI scenarios
Example7_TestingSuite() {
    ; Create GUI
    g := Gui(, "Multi-DPI Testing Suite")
    g.SetFont("s10")

    g.Add("Text", "w550", "Comprehensive Multi-DPI Testing and Validation")

    ; Test categories
    g.Add("GroupBox", "xm w550 h150 Section", "Test Scenarios")

    tests := [
        "Uniform DPI (all monitors same)",
        "Mixed DPI (different DPI per monitor)",
        "Window movement across DPI boundaries",
        "Dynamic content scaling",
        "Font rendering at different DPIs",
        "Image quality across DPIs"
    ]

    for test in tests
        g.Add("Checkbox", "xs+10", test)

    g.Add("Button", "xm w150", "Run Tests").OnEvent("Click", RunTests)
    g.Add("Button", "x+10 w150", "Generate Report").OnEvent("Click", GenerateReport)

    txtResults := g.Add("Edit", "xm w550 h200 ReadOnly +Multi")

    g.Show()

    RunTests(*) {
        MonCount := MonitorGetCount()

        results := "MULTI-DPI TEST RESULTS`n"
        results .= "═══════════════════════════════════════`n`n"

        ; Test 1: DPI uniformity
        dpiSet := Map()
        Loop MonCount {
            dpiInfo := GetMonitorDPI(A_Index)
            dpiSet[dpiInfo.DPI] := true
        }

        results .= "[TEST 1] DPI Uniformity:`n"
        if dpiSet.Count = 1
            results .= "  ✓ PASS - All monitors have same DPI`n"
        else
            results .= "  ⚠ INFO - " dpiSet.Count " different DPI settings detected`n"

        results .= "`n[TEST 2] Per-Monitor DPI Support:`n"
        hasDifferentDPI := dpiSet.Count > 1
        if hasDifferentDPI
            results .= "  ✓ ACTIVE - Multi-DPI configuration`n"
        else
            results .= "  ℹ N/A - Single DPI configuration`n"

        results .= "`n[TEST 3] Monitor Count:`n"
        results .= "  Total: " MonCount " monitor(s)`n"

        results .= "`n[TEST 4] DPI Distribution:`n"
        Loop MonCount {
            dpiInfo := GetMonitorDPI(A_Index)
            results .= "  Monitor " A_Index ": " dpiInfo.DPI " DPI (" dpiInfo.Percent "%)`n"
        }

        results .= "`n═══════════════════════════════════════`n"
        results .= "Testing complete - Review results above"

        txtResults.Value := results
    }

    GenerateReport(*) {
        report := txtResults.Value

        if report = "" {
            MsgBox("Run tests first!", "Error", "Icon!")
            return
        }

        fileName := "DPI_Test_Report_" FormatTime(, "yyyyMMdd_HHmmss") ".txt"
        try {
            FileAppend(report, A_Desktop "\" fileName)
            MsgBox("Report saved to:`n" A_Desktop "\" fileName, "Saved", "Icon!")
        } catch as err {
            MsgBox("Error saving file:`n" err.Message, "Error", "Iconx")
        }
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "Multi-DPI Examples")
    g.SetFont("s10")

    MonCount := MonitorGetCount()
    g.Add("Text", "w450", "System: " MonCount " monitor(s)")
    g.Add("Text", "w450", "Multi-DPI Management Examples:")

    g.Add("Button", "w450", "Example 1: Per-Monitor DPI Map").OnEvent("Click", (*) => Example1_DPIMap())
    g.Add("Button", "w450", "Example 2: DPI-Aware Window Mover").OnEvent("Click", (*) => Example2_DPIAwareWindowMover())
    g.Add("Button", "w450", "Example 3: Multi-DPI Window Creator").OnEvent("Click", (*) => Example3_MultiDPIWindowCreator())
    g.Add("Button", "w450", "Example 4: DPI Topology Visualizer").OnEvent("Click", (*) => Example4_DPITopology())
    g.Add("Button", "w450", "Example 5: Cross-DPI Content Manager").OnEvent("Click", (*) => Example5_ContentManager())
    g.Add("Button", "w450", "Example 6: DPI Change Event Handler").OnEvent("Click", (*) => Example6_DPIChangeHandler())
    g.Add("Button", "w450", "Example 7: Multi-DPI Testing Suite").OnEvent("Click", (*) => Example7_TestingSuite())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
