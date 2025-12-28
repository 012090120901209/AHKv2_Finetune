#Requires AutoHotkey v2.0

/**
 * BuiltIn_DPI_01_Awareness.ahk
 * 
 * DESCRIPTION:
 * Demonstrates DPI awareness concepts and detection in AutoHotkey v2.
 * Shows how to detect DPI settings, understand DPI scaling, and create
 * DPI-aware applications that look correct on high-DPI displays.
 * 
 * FEATURES:
 * - DPI detection and querying
 * - DPI awareness mode detection
 * - Per-monitor DPI support
 * - DPI scaling calculations
 * - High-DPI display handling
 * - DPI-aware GUI creation
 * - Resolution-independent design
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * Windows DPI Awareness
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall for DPI functions
 * - Per-monitor DPI awareness
 * - Dynamic DPI adaptation
 * - Scaling calculations
 * - Modern high-DPI support
 * 
 * LEARNING POINTS:
 * 1. Standard DPI is 96 (100% scaling)
 * 2. Common scaling: 125% (120 DPI), 150% (144 DPI), 200% (192 DPI)
 * 3. Per-monitor DPI allows different scaling per display
 * 4. DPI awareness prevents Windows from scaling your app
 * 5. Calculate scale factor: currentDPI / 96
 * 6. Apply scaling to all sizes, fonts, and positions
 * 7. Test on multiple DPI settings for compatibility
 */

;=============================================================================
; EXAMPLE 1: Basic DPI Detection
;=============================================================================
; Detects and displays current DPI settings
Example1_DPIDetection() {
    ; Get DPI using DllCall
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    dpiX := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")  ; LOGPIXELSX
    dpiY := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 90, "Int")  ; LOGPIXELSY
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    ; Calculate scaling
    scaleX := dpiX / 96
    scaleY := dpiY / 96
    scalePercent := Round(scaleX * 100)

    ; Build information display
    info := "DPI DETECTION RESULTS`n"
    info .= "=====================`n`n"

    info .= "CURRENT DPI SETTINGS:`n"
    info .= "  Horizontal DPI: " dpiX "`n"
    info .= "  Vertical DPI:   " dpiY "`n`n"

    info .= "SCALING INFORMATION:`n"
    info .= "  Scale Factor X: " Round(scaleX, 2) "x`n"
    info .= "  Scale Factor Y: " Round(scaleY, 2) "x`n"
    info .= "  Scaling:        " scalePercent "%`n`n"

    info .= "INTERPRETATION:`n"
    if scalePercent = 100
        info .= "  ✓ Standard DPI (100%) - No scaling`n"
    else if scalePercent = 125
        info .= "  ✓ Medium DPI (125%) - Common for laptops`n"
    else if scalePercent = 150
        info .= "  ✓ Large DPI (150%) - High DPI displays`n"
    else if scalePercent = 200
        info .= "  ✓ Very Large (200%) - 4K displays`n"
    else
        info .= "  ⚠ Custom DPI (" scalePercent "%)`n"

    info .= "`nNOTE: Standard DPI is 96 (100% scaling)"

    MsgBox(info, "Example 1: DPI Detection", "Icon!")
}

;=============================================================================
; EXAMPLE 2: DPI Awareness Mode Checker
;=============================================================================
; Checks the DPI awareness mode of the application
Example2_AwarenessChecker() {
    ; Try to get DPI awareness (requires Windows 10 1607+)
    awareness := ""

    try {
        ; Try to get process DPI awareness
        DPI_AWARENESS_CONTEXT_UNAWARE := -1
        DPI_AWARENESS_CONTEXT_SYSTEM_AWARE := -2
        DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE := -3
        DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 := -4

        context := DllCall("GetThreadDpiAwarenessContext", "Ptr")
        awareness := "Context detected: " context
    } catch {
        awareness := "DPI Awareness API not available (older Windows)"
    }

    ; Get DPI
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    dpiX := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    ; Create GUI
    g := Gui(, "DPI Awareness Mode Checker")
    g.SetFont("s10")

    g.Add("Text", "w450", "DPI Awareness Information")

    info := "`nDPI SETTINGS:`n"
    info .= "  Current DPI: " dpiX " (" Round(dpiX / 96 * 100) "%)`n`n"

    info .= "AWARENESS MODE:`n"
    info .= "  " awareness "`n`n"

    info .= "MODES EXPLAINED:`n"
    info .= "  • Unaware: Windows scales the app (blurry)`n"
    info .= "  • System Aware: App handles one DPI`n"
    info .= "  • Per-Monitor: App adapts per monitor`n"
    info .= "  • Per-Monitor V2: Enhanced per-monitor`n`n"

    info .= "RECOMMENDATIONS:`n"
    info .= "  For multi-monitor: Use Per-Monitor Aware`n"
    info .= "  For single display: System Aware is sufficient"

    g.Add("Text", "xm w450 +Border", info)

    g.Show()
}

;=============================================================================
; EXAMPLE 3: Per-Monitor DPI Detector
;=============================================================================
; Detects DPI for each monitor individually
Example3_PerMonitorDPI() {
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui("+Resize", "Per-Monitor DPI Detector")
    g.SetFont("s9", "Consolas")

    g.Add("Text", "w600", "DPI Settings for Each Monitor")

    lv := g.Add("ListView", "w650 h300", [
        "Monitor", "DPI X", "DPI Y", "Scale %", "Resolution", "Status"
    ])

    ; Check each monitor
    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        ; For per-monitor DPI, we need to use GetDpiForMonitor
        ; This requires a monitor handle from MonitorFromPoint
        centerX := (Left + Right) // 2
        centerY := (Top + Bottom) // 2

        ; Get monitor handle
        MONITOR_DEFAULTTONEAREST := 2
        hMonitor := DllCall("MonitorFromPoint",
            "Int64", (centerY << 32) | (centerX & 0xFFFFFFFF),
            "UInt", MONITOR_DEFAULTTONEAREST,
            "Ptr")

        ; Try to get DPI for this monitor
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

            if result != 0 {
                ; Fallback to system DPI
                hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
                dpiX := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
                dpiY := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 90, "Int")
                DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
                status := "System DPI (Fallback)"
            } else {
                status := "Per-Monitor DPI"
            }
        } catch {
            ; Fallback to system DPI
            hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
            dpiX := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
            dpiY := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 90, "Int")
            DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)
            status := "System DPI (API N/A)"
        }

        scalePercent := Round(dpiX / 96 * 100)
        resolution := (Right - Left) "×" (Bottom - Top)

        lv.Add("", MonNum, dpiX, dpiY, scalePercent "%", resolution, status)
    }

    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    g.Add("Text", "xm", "`nNote: Per-monitor DPI requires Windows 8.1 or later")

    g.Show()
}

;=============================================================================
; EXAMPLE 4: DPI Scaling Calculator
;=============================================================================
; Calculates scaled sizes for different DPI settings
Example4_ScalingCalculator() {
    ; Get current DPI
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    currentDPI := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    ; Create GUI
    g := Gui(, "DPI Scaling Calculator")
    g.SetFont("s10")

    g.Add("Text", "w400", "Calculate scaled sizes for DPI settings")
    g.Add("Text", "xm", "Current DPI: " currentDPI " (" Round(currentDPI / 96 * 100) "%)")

    g.Add("Text", "xm Section", "Original Size:")
    edtOriginal := g.Add("Edit", "xs w100", "100")

    g.Add("Button", "xm w200", "Calculate Scaled Sizes").OnEvent("Click", Calculate)

    txtResult := g.Add("Text", "xm w400 h250 +Border")

    g.Show()

    Calculate(*) {
        originalSize := Integer(edtOriginal.Value)

        result := "SCALED SIZES FOR " originalSize " PIXELS`n"
        result .= "═══════════════════════════════════════`n`n"

        dpiSettings := [{
            DPI: 96, Percent: 100, Name: "Standard" }, {
                DPI: 120, Percent: 125, Name: "Medium" }, {
                    DPI: 144, Percent: 150, Name: "Large" }, {
                        DPI: 168, Percent: 175, Name: "Larger" }, {
                            DPI: 192, Percent: 200, Name: "Very Large"
                        }
        ]

        for setting in dpiSettings {
            scaleFactor := setting.DPI / 96
            scaledSize := Round(originalSize * scaleFactor)

            result .= setting.Percent "% (" setting.DPI " DPI) - " setting.Name "`n"
            result .= "  Scaled size: " scaledSize " pixels"

            if setting.DPI = currentDPI
                result .= " ← CURRENT"

            result .= "`n`n"
        }

        result .= "FORMULA:`n"
        result .= "scaledSize = originalSize × (targetDPI / 96)"

        txtResult.Value := result
    }
}

;=============================================================================
; EXAMPLE 5: DPI-Aware GUI Demo
;=============================================================================
; Creates GUI that properly scales with DPI
Example5_DPIAwareGUI() {
    ; Get current DPI and calculate scale factor
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    dpi := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    scale := dpi / 96

    ; Define base sizes (at 96 DPI)
    baseWidth := 400
    baseHeight := 300
    baseFontSize := 10
    baseButtonWidth := 100
    baseButtonHeight := 30

    ; Calculate scaled sizes
    scaledWidth := Round(baseWidth * scale)
    scaledHeight := Round(baseHeight * scale)
    scaledFontSize := Round(baseFontSize * scale)
    scaledButtonWidth := Round(baseButtonWidth * scale)
    scaledButtonHeight := Round(baseButtonHeight * scale)

    ; Create DPI-aware GUI
    g := Gui(, "DPI-Aware GUI Demo")
    g.SetFont("s" scaledFontSize)

    g.Add("Text", "w" (scaledWidth - 20), "This GUI scales properly with DPI!")

    g.Add("GroupBox", "xm w" (scaledWidth - 20) " h100 Section", "DPI Information")

    g.Add("Text", "xs+10 ys+25", "Current DPI: " dpi " (" Round(scale * 100) "%)")
    g.Add("Text", "xs+10", "Scale Factor: " Round(scale, 2) "x")
    g.Add("Text", "xs+10", "Font Size: " scaledFontSize " pt")

    g.Add("Button", "xm w" scaledButtonWidth " h" scaledButtonHeight, "Scaled Button")

    g.Add("Text", "xm", "`nAll elements scale proportionally`nwith your DPI setting!")

    g.Show("w" scaledWidth " h" scaledHeight)
}

;=============================================================================
; EXAMPLE 6: DPI Change Monitor
;=============================================================================
; Monitors for DPI changes (when moving between monitors)
Example6_DPIChangeMonitor() {
    ; Create GUI
    g := Gui("+AlwaysOnTop", "DPI Change Monitor")
    g.SetFont("s10")

    g.Add("Text", "w350", "Monitoring DPI changes...")

    txtCurrent := g.Add("Text", "xm w350 h60 +Border")
    txtLog := g.Add("Edit", "xm w350 h200 ReadOnly +Multi")

    ; Get initial DPI
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    lastDPI := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    Log("Monitoring started - Initial DPI: " lastDPI)
    UpdateDisplay()

    ; Monitor for changes
    SetTimer(CheckDPI, 1000)

    g.OnEvent("Close", (*) => (SetTimer(CheckDPI, 0), g.Destroy()))
    g.Show()

    CheckDPI() {
        hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
        currentDPI := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

        if currentDPI != lastDPI {
            Log("DPI CHANGED: " lastDPI " → " currentDPI " (" Round(currentDPI / 96 * 100) "%)")
            lastDPI := currentDPI
            UpdateDisplay()
        }
    }

    UpdateDisplay() {
        txtCurrent.Value := "Current DPI: " lastDPI "`nScaling: " Round(lastDPI / 96 * 100) "%`nScale Factor: " Round(lastDPI / 96, 2) "x"
    }

    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 7: DPI Compatibility Tester
;=============================================================================
; Tests GUI appearance at different DPI settings
Example7_CompatibilityTester() {
    ; Create GUI
    g := Gui(, "DPI Compatibility Tester")
    g.SetFont("s10")

    g.Add("Text", "w450", "Test how your sizes look at different DPI settings")

    g.Add("Text", "xm Section", "Base Size (at 96 DPI):")
    edtSize := g.Add("Edit", "xs w80", "100")

    g.Add("Text", "xm Section", "Test Results:")

    lv := g.Add("ListView", "xs w450 h200", [
        "DPI", "Scaling %", "Scaled Size", "Visual Representation"
    ])

    g.Add("Button", "xm w200", "Run Test").OnEvent("Click", RunTest)

    g.Show()

    RunTest(*) {
        baseSize := Integer(edtSize.Value)

        lv.Delete()

        dpiSettings := [96, 120, 144, 168, 192]

        for dpi in dpiSettings {
            scaleFactor := dpi / 96
            scaledSize := Round(baseSize * scaleFactor)
            scalePercent := Round(scaleFactor * 100)

            ; Create visual representation
            barLength := Min(Round(scaledSize / 5), 50)
            visualBar := ""
            Loop barLength
                visualBar .= "█"

            lv.Add("", dpi, scalePercent "%", scaledSize " px", visualBar)
        }

        Loop lv.GetCount("Column")
            lv.ModifyCol(A_Index, "AutoHdr")
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "DPI Awareness Examples")
    g.SetFont("s10")

    ; Get current DPI
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    dpi := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    g.Add("Text", "w450", "Current System DPI: " dpi " (" Round(dpi / 96 * 100) "%)")
    g.Add("Text", "w450", "DPI Awareness Examples:")

    g.Add("Button", "w450", "Example 1: DPI Detection").OnEvent("Click", (*) => Example1_DPIDetection())
    g.Add("Button", "w450", "Example 2: Awareness Mode Checker").OnEvent("Click", (*) => Example2_AwarenessChecker())
    g.Add("Button", "w450", "Example 3: Per-Monitor DPI").OnEvent("Click", (*) => Example3_PerMonitorDPI())
    g.Add("Button", "w450", "Example 4: Scaling Calculator").OnEvent("Click", (*) => Example4_ScalingCalculator())
    g.Add("Button", "w450", "Example 5: DPI-Aware GUI Demo").OnEvent("Click", (*) => Example5_DPIAwareGUI())
    g.Add("Button", "w450", "Example 6: DPI Change Monitor").OnEvent("Click", (*) => Example6_DPIChangeMonitor())
    g.Add("Button", "w450", "Example 7: Compatibility Tester").OnEvent("Click", (*) => Example7_CompatibilityTester())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
