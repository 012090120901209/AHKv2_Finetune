#Requires AutoHotkey v2.0

/**
* BuiltIn_SysGet_01_Metrics.ahk
*
* DESCRIPTION:
* Demonstrates using SysGet to retrieve system metrics in AutoHotkey v2.
* Shows how to query various system measurements, dimensions, and display
* information for adaptive UI design and system-aware positioning.
*
* FEATURES:
* - Retrieving system metric values
* - Screen dimension queries
* - Virtual desktop metrics
* - System element sizing
* - DPI and scaling information
* - Mouse and cursor metrics
* - System capability detection
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/SysGet.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - SysGet function with numeric indices
* - System metric constant values
* - Dynamic system information retrieval
* - Resolution-independent design
* - System-aware UI adaptation
*
* LEARNING POINTS:
* 1. SysGet retrieves Windows system metrics
* 2. Metrics use SM_* constants (numeric values)
* 3. Important for resolution-independent UIs
* 4. Metrics vary by system configuration
* 5. Virtual desktop spans all monitors
* 6. Some metrics reflect DPI scaling
* 7. System metrics change with display settings
*/

;=============================================================================
; EXAMPLE 1: Basic System Metrics Display
;=============================================================================
; Displays common system metrics
Example1_BasicMetrics() {
    ; Retrieve common metrics
    screenWidth := SysGet(0)   ; SM_CXSCREEN
    screenHeight := SysGet(1)  ; SM_CYSCREEN

    virtualWidth := SysGet(78)   ; SM_CXVIRTUALSCREEN
    virtualHeight := SysGet(79)  ; SM_CYVIRTUALSCREEN

    monitorCount := SysGet(80)  ; SM_CMONITORS

    ; Build information display
    info := "BASIC SYSTEM METRICS`n"
    info .= "====================`n`n"

    info .= "PRIMARY SCREEN:`n"
    info .= "  Width:  " screenWidth " pixels (SM_CXSCREEN=0)`n"
    info .= "  Height: " screenHeight " pixels (SM_CYSCREEN=1)`n"
    info .= "  Area:   " Format("{:,}", screenWidth * screenHeight) " pixels²`n`n"

    info .= "VIRTUAL DESKTOP:`n"
    info .= "  Width:  " virtualWidth " pixels (SM_CXVIRTUALSCREEN=78)`n"
    info .= "  Height: " virtualHeight " pixels (SM_CYVIRTUALSCREEN=79)`n"
    info .= "  Area:   " Format("{:,}", virtualWidth * virtualHeight) " pixels²`n`n"

    info .= "MONITORS:`n"
    info .= "  Count:  " monitorCount " (SM_CMONITORS=80)`n`n"

    info .= "COMPARISON:`n"
    if virtualWidth > screenWidth || virtualHeight > screenHeight
    info .= "  Multi-monitor setup detected`n"
    else
    info .= "  Single monitor setup`n"

    info .= "  Virtual/Primary Ratio: " Round(virtualWidth / screenWidth, 2) "x"

    MsgBox(info, "Example 1: Basic System Metrics", "Icon!")
}

;=============================================================================
; EXAMPLE 2: Comprehensive Metrics Browser
;=============================================================================
; Creates browser for exploring all system metrics
Example2_MetricsBrowser() {
    ; Create GUI
    g := Gui("+Resize", "System Metrics Browser")
    g.SetFont("s9", "Consolas")

    g.Add("Text", "w700", "Browse all system metrics (SysGet values)")

    ; Create ListView
    lv := g.Add("ListView", "w750 h400", ["Index", "Name", "Value", "Description"])

    ; Define commonly used metrics
    metrics := [
    {
        Index: 0, Name: "SM_CXSCREEN", Desc: "Primary screen width"},
        {
            Index: 1, Name: "SM_CYSCREEN", Desc: "Primary screen height"},
            {
                Index: 2, Name: "SM_CXVSCROLL", Desc: "Vertical scroll bar width"},
                {
                    Index: 3, Name: "SM_CYHSCROLL", Desc: "Horizontal scroll bar height"},
                    {
                        Index: 4, Name: "SM_CYCAPTION", Desc: "Caption bar height"},
                        {
                            Index: 5, Name: "SM_CXBORDER", Desc: "Window border width"},
                            {
                                Index: 6, Name: "SM_CYBORDER", Desc: "Window border height"},
                                {
                                    Index: 7, Name: "SM_CXDLGFRAME", Desc: "Dialog frame width"},
                                    {
                                        Index: 8, Name: "SM_CYDLGFRAME", Desc: "Dialog frame height"},
                                        {
                                            Index: 11, Name: "SM_CXMIN", Desc: "Minimum window width"},
                                            {
                                                Index: 12, Name: "SM_CYMIN", Desc: "Minimum window height"},
                                                {
                                                    Index: 13, Name: "SM_CXSIZE", Desc: "Title bar button width"},
                                                    {
                                                        Index: 14, Name: "SM_CYSIZE", Desc: "Title bar button height"},
                                                        {
                                                            Index: 15, Name: "SM_CXFRAME", Desc: "Window frame width"},
                                                            {
                                                                Index: 16, Name: "SM_CYFRAME", Desc: "Window frame height"},
                                                                {
                                                                    Index: 28, Name: "SM_CXMIN", Desc: "Minimized window width"},
                                                                    {
                                                                        Index: 29, Name: "SM_CYMIN", Desc: "Minimized window height"},
                                                                        {
                                                                            Index: 30, Name: "SM_CXMINTRACK", Desc: "Min tracking width"},
                                                                            {
                                                                                Index: 31, Name: "SM_CYMINTRACK", Desc: "Min tracking height"},
                                                                                {
                                                                                    Index: 32, Name: "SM_CXDOUBLECLK", Desc: "Double-click width"},
                                                                                    {
                                                                                        Index: 33, Name: "SM_CYDOUBLECLK", Desc: "Double-click height"},
                                                                                        {
                                                                                            Index: 76, Name: "SM_XVIRTUALSCREEN", Desc: "Virtual screen left"},
                                                                                            {
                                                                                                Index: 77, Name: "SM_YVIRTUALSCREEN", Desc: "Virtual screen top"},
                                                                                                {
                                                                                                    Index: 78, Name: "SM_CXVIRTUALSCREEN", Desc: "Virtual screen width"},
                                                                                                    {
                                                                                                        Index: 79, Name: "SM_CYVIRTUALSCREEN", Desc: "Virtual screen height"},
                                                                                                        {
                                                                                                            Index: 80, Name: "SM_CMONITORS", Desc: "Number of monitors"
                                                                                                        }
                                                                                                        ]

                                                                                                        ; Populate ListView
                                                                                                        for metric in metrics {
                                                                                                            value := SysGet(metric.Index)
                                                                                                            lv.Add("", metric.Index, metric.Name, value, metric.Desc)
                                                                                                        }

                                                                                                        ; Auto-size columns
                                                                                                        Loop lv.GetCount("Column")
                                                                                                        lv.ModifyCol(A_Index, "AutoHdr")

                                                                                                        ; Add search/filter
                                                                                                        g.Add("Text", "xm", "Search:")
                                                                                                        edtSearch := g.Add("Edit", "x+10 w200")
                                                                                                        edtSearch.OnEvent("Change", FilterMetrics)

                                                                                                        g.Add("Button", "x+10 w100", "Refresh All").OnEvent("Click", RefreshMetrics)

                                                                                                        g.Show()

                                                                                                        FilterMetrics(*) {
                                                                                                            searchText := edtSearch.Value

                                                                                                            lv.Delete()

                                                                                                            for metric in metrics {
                                                                                                                if searchText = "" || InStr(metric.Name, searchText) || InStr(metric.Desc, searchText) {
                                                                                                                    value := SysGet(metric.Index)
                                                                                                                    lv.Add("", metric.Index, metric.Name, value, metric.Desc)
                                                                                                                }
                                                                                                            }

                                                                                                            Loop lv.GetCount("Column")
                                                                                                            lv.ModifyCol(A_Index, "AutoHdr")
                                                                                                        }

                                                                                                        RefreshMetrics(*) {
                                                                                                            edtSearch.Value := ""
                                                                                                            FilterMetrics()
                                                                                                        }
                                                                                                    }

                                                                                                    ;=============================================================================
                                                                                                    ; EXAMPLE 3: Screen Dimension Calculator
                                                                                                    ;=============================================================================
                                                                                                    ; Calculates and displays various screen dimension metrics
                                                                                                    Example3_DimensionCalculator() {
                                                                                                        ; Get dimensions
                                                                                                        primaryWidth := SysGet(0)
                                                                                                        primaryHeight := SysGet(1)

                                                                                                        virtualLeft := SysGet(76)
                                                                                                        virtualTop := SysGet(77)
                                                                                                        virtualWidth := SysGet(78)
                                                                                                        virtualHeight := SysGet(79)

                                                                                                        monitorCount := SysGet(80)

                                                                                                        ; Create GUI
                                                                                                        g := Gui(, "Screen Dimension Calculator")
                                                                                                        g.SetFont("s9", "Consolas")

                                                                                                        report := "SCREEN DIMENSION ANALYSIS`n"
                                                                                                        report .= "═════════════════════════════════════════════`n`n"

                                                                                                        report .= "PRIMARY DISPLAY:`n"
                                                                                                        report .= "  Dimensions:  " primaryWidth " × " primaryHeight " pixels`n"
                                                                                                        report .= "  Area:        " Format("{:,}", primaryWidth * primaryHeight) " pixels²`n"
                                                                                                        report .= "  Aspect:      " Round(primaryWidth / primaryHeight, 3) ":1`n"
                                                                                                        report .= "  Diagonal:    " Round(Sqrt(primaryWidth**2 + primaryHeight**2)) " pixels`n`n"

                                                                                                        report .= "VIRTUAL DESKTOP:`n"
                                                                                                        report .= "  Origin:      (" virtualLeft ", " virtualTop ")`n"
                                                                                                        report .= "  Dimensions:  " virtualWidth " × " virtualHeight " pixels`n"
                                                                                                        report .= "  Area:        " Format("{:,}", virtualWidth * virtualHeight) " pixels²`n"
                                                                                                        report .= "  Aspect:      " Round(virtualWidth / virtualHeight, 3) ":1`n`n"

                                                                                                        report .= "MULTI-MONITOR INFO:`n"
                                                                                                        report .= "  Monitor Count: " monitorCount "`n"
                                                                                                        report .= "  Configuration: "

                                                                                                        if monitorCount = 1
                                                                                                        report .= "Single Monitor`n"
                                                                                                        else if virtualWidth > primaryWidth && virtualHeight = primaryHeight
                                                                                                        report .= "Horizontal (side-by-side)`n"
                                                                                                        else if virtualHeight > primaryHeight && virtualWidth = primaryWidth
                                                                                                        report .= "Vertical (stacked)`n"
                                                                                                        else
                                                                                                        report .= "Mixed/Complex`n"

                                                                                                        report .= "`nCALCULATIONS:`n"

                                                                                                        totalVirtualArea := virtualWidth * virtualHeight
                                                                                                        primaryArea := primaryWidth * primaryHeight
                                                                                                        if monitorCount > 1 {
                                                                                                            avgMonitorArea := totalVirtualArea // monitorCount
                                                                                                            report .= "  Avg Monitor Area:  " Format("{:,}", avgMonitorArea) " pixels²`n"
                                                                                                            report .= "  Coverage Ratio:    " Round((primaryArea / totalVirtualArea) * 100, 1) "%`n"
                                                                                                        }

                                                                                                        report .= "`nCOMMON RESOLUTIONS:`n"

                                                                                                        ; Check against common resolutions
                                                                                                        resolutions := [
                                                                                                        {
                                                                                                            Name: "HD (1280×720)", W: 1280, H: 720},
                                                                                                            {
                                                                                                                Name: "Full HD (1920×1080)", W: 1920, H: 1080},
                                                                                                                {
                                                                                                                    Name: "QHD (2560×1440)", W: 2560, H: 1440},
                                                                                                                    {
                                                                                                                        Name: "4K UHD (3840×2160)", W: 3840, H: 2160},
                                                                                                                        {
                                                                                                                            Name: "5K (5120×2880)", W: 5120, H: 2880
                                                                                                                        }
                                                                                                                        ]

                                                                                                                        for res in resolutions {
                                                                                                                            if res.W = primaryWidth && res.H = primaryHeight
                                                                                                                            report .= "  ✓ Primary matches: " res.Name "`n"
                                                                                                                        }

                                                                                                                        g.Add("Text", "w600", report)

                                                                                                                        g.Show()
                                                                                                                    }

                                                                                                                    ;=============================================================================
                                                                                                                    ; EXAMPLE 4: Window Frame Size Calculator
                                                                                                                    ;=============================================================================
                                                                                                                    ; Calculates window frame and border sizes
                                                                                                                    Example4_FrameSizeCalculator() {
                                                                                                                        ; Get frame metrics
                                                                                                                        borderWidth := SysGet(5)    ; SM_CXBORDER
                                                                                                                        borderHeight := SysGet(6)   ; SM_CYBORDER
                                                                                                                        frameWidth := SysGet(32)    ; SM_CXSIZEFRAME
                                                                                                                        frameHeight := SysGet(33)   ; SM_CYSIZEFRAME
                                                                                                                        captionHeight := SysGet(4)  ; SM_CYCAPTION
                                                                                                                        menuHeight := SysGet(15)    ; SM_CYMENU

                                                                                                                        ; Create GUI
                                                                                                                        g := Gui(, "Window Frame Size Calculator")
                                                                                                                        g.SetFont("s10")

                                                                                                                        g.Add("Text", "w400", "Window Frame and Border Metrics")

                                                                                                                        info := "`nBORDERS:`n"
                                                                                                                        info .= "  Border Width (SM_CXBORDER):    " borderWidth " px`n"
                                                                                                                        info .= "  Border Height (SM_CYBORDER):   " borderHeight " px`n`n"

                                                                                                                        info .= "FRAMES:`n"
                                                                                                                        info .= "  Frame Width (SM_CXSIZEFRAME):  " frameWidth " px`n"
                                                                                                                        info .= "  Frame Height (SM_CYSIZEFRAME): " frameHeight " px`n`n"

                                                                                                                        info .= "CAPTION/MENU:`n"
                                                                                                                        info .= "  Caption Height (SM_CYCAPTION): " captionHeight " px`n"
                                                                                                                        info .= "  Menu Height (SM_CYMENU):       " menuHeight " px`n`n"

                                                                                                                        info .= "CALCULATIONS:`n"

                                                                                                                        totalVertical := captionHeight + (frameHeight * 2)
                                                                                                                        totalHorizontal := frameWidth * 2

                                                                                                                        info .= "  Total Vertical Frame:   " totalVertical " px`n"
                                                                                                                        info .= "  Total Horizontal Frame: " totalHorizontal " px`n`n"

                                                                                                                        info .= "CLIENT AREA CALCULATION:`n"
                                                                                                                        info .= "  For 800×600 window:`n"

                                                                                                                        clientW := 800 - totalHorizontal
                                                                                                                        clientH := 600 - totalVertical

                                                                                                                        info .= "    Client Width:  " clientW " px`n"
                                                                                                                        info .= "    Client Height: " clientH " px`n"
                                                                                                                        info .= "    Lost to frame: " (800 - clientW) "×" (600 - clientH) " px"

                                                                                                                        g.Add("Text", "xm w400 +Border", info)

                                                                                                                        ; Add demo
                                                                                                                        g.Add("Button", "xm w200", "Create Demo Window").OnEvent("Click", CreateDemo)

                                                                                                                        g.Show()

                                                                                                                        CreateDemo(*) {
                                                                                                                            demo := Gui(, "Demo Window (800×600)")
                                                                                                                            demo.Add("Text", "w" clientW " h" clientH " +Border",
                                                                                                                            "Client Area`n`n" clientW " × " clientH " pixels`n`nFrame overhead: "
                                                                                                                            totalHorizontal "×" totalVertical " pixels")
                                                                                                                            demo.Show("w800 h600")
                                                                                                                        }
                                                                                                                    }

                                                                                                                    ;=============================================================================
                                                                                                                    ; EXAMPLE 5: System Capabilities Detector
                                                                                                                    ;=============================================================================
                                                                                                                    ; Detects system capabilities using SysGet
                                                                                                                    Example5_CapabilitiesDetector() {
                                                                                                                        ; Get capability metrics
                                                                                                                        mousePresent := SysGet(19)       ; SM_MOUSEPRESENT
                                                                                                                        mouseWheelPresent := SysGet(75)  ; SM_MOUSEWHEELPRESENT
                                                                                                                        monitorCount := SysGet(80)       ; SM_CMONITORS
                                                                                                                        tabletPC := SysGet(86)           ; SM_TABLETPC
                                                                                                                        mediaCenter := SysGet(87)        ; SM_MEDIACENTER

                                                                                                                        ; Create GUI
                                                                                                                        g := Gui(, "System Capabilities Detector")
                                                                                                                        g.SetFont("s10")

                                                                                                                        g.Add("Text", "w400", "System Hardware Capabilities")

                                                                                                                        capabilities := "`nINPUT DEVICES:`n"
                                                                                                                        capabilities .= "  Mouse Present (SM_MOUSEPRESENT):     " (mousePresent ? "✓ Yes" : "✗ No") "`n"
                                                                                                                        capabilities .= "  Mouse Wheel (SM_MOUSEWHEELPRESENT):  " (mouseWheelPresent ? "✓ Yes" : "✗ No") "`n`n"

                                                                                                                        capabilities .= "DISPLAY:`n"
                                                                                                                        capabilities .= "  Monitor Count (SM_CMONITORS):        " monitorCount "`n"
                                                                                                                        capabilities .= "  Configuration:                       "

                                                                                                                        if monitorCount = 1
                                                                                                                        capabilities .= "Single Display`n"
                                                                                                                        else if monitorCount = 2
                                                                                                                        capabilities .= "Dual Display`n"
                                                                                                                        else
                                                                                                                        capabilities .= "Multi-Display (" monitorCount " monitors)`n"

                                                                                                                        capabilities .= "`nSYSTEM TYPE:`n"
                                                                                                                        capabilities .= "  Tablet PC (SM_TABLETPC):             " (tabletPC ? "✓ Yes" : "✗ No") "`n"
                                                                                                                        capabilities .= "  Media Center (SM_MEDIACENTER):       " (mediaCenter ? "✓ Yes" : "✗ No") "`n`n"

                                                                                                                        capabilities .= "RECOMMENDATIONS:`n"
                                                                                                                        if !mousePresent
                                                                                                                        capabilities .= "  • Design for touch/keyboard only`n"
                                                                                                                        if mouseWheelPresent
                                                                                                                        capabilities .= "  • Mouse wheel support available`n"
                                                                                                                        if monitorCount > 1
                                                                                                                        capabilities .= "  • Multi-monitor features enabled`n"
                                                                                                                        if tabletPC
                                                                                                                        capabilities .= "  • Touch-optimized UI recommended`n"

                                                                                                                        g.Add("Text", "xm w400 +Border", capabilities)

                                                                                                                        g.Show()
                                                                                                                    }

                                                                                                                    ;=============================================================================
                                                                                                                    ; EXAMPLE 6: DPI and Scaling Information
                                                                                                                    ;=============================================================================
                                                                                                                    ; Retrieves DPI and scaling-related metrics
                                                                                                                    Example6_DPIScalingInfo() {
                                                                                                                        ; Get screen dimensions
                                                                                                                        screenWidth := SysGet(0)
                                                                                                                        screenHeight := SysGet(1)

                                                                                                                        ; Standard DPI is 96
                                                                                                                        standardDPI := 96

                                                                                                                        ; Try to get actual DPI (Note: SysGet doesn't directly provide DPI in v2)
                                                                                                                        ; This example shows how to work with assumed/standard DPI

                                                                                                                        ; Create GUI
                                                                                                                        g := Gui(, "DPI and Scaling Information")
                                                                                                                        g.SetFont("s9", "Consolas")

                                                                                                                        info := "DPI AND SCALING INFORMATION`n"
                                                                                                                        info .= "═══════════════════════════════════════`n`n"

                                                                                                                        info .= "SCREEN DIMENSIONS:`n"
                                                                                                                        info .= "  Width:  " screenWidth " pixels`n"
                                                                                                                        info .= "  Height: " screenHeight " pixels`n`n"

                                                                                                                        info .= "STANDARD DPI:`n"
                                                                                                                        info .= "  Base DPI: " standardDPI " (Windows standard)`n`n"

                                                                                                                        ; Calculate approximate physical dimensions at 96 DPI
                                                                                                                        widthInches := Round(screenWidth / standardDPI, 1)
                                                                                                                        heightInches := Round(screenHeight / standardDPI, 1)
                                                                                                                        diagonal := Round(Sqrt(widthInches**2 + heightInches**2), 1)

                                                                                                                        info .= "APPROXIMATE PHYSICAL SIZE (at 96 DPI):`n"
                                                                                                                        info .= "  Width:    " widthInches " inches`n"
                                                                                                                        info .= "  Height:   " heightInches " inches`n"
                                                                                                                        info .= "  Diagonal: " diagonal " inches`n`n"

                                                                                                                        info .= "COMMON SCALING FACTORS:`n"
                                                                                                                        info .= "  100% (96 DPI)   - Standard`n"
                                                                                                                        info .= "  125% (120 DPI)  - Small laptops`n"
                                                                                                                        info .= "  150% (144 DPI)  - High DPI displays`n"
                                                                                                                        info .= "  200% (192 DPI)  - 4K monitors`n`n"

                                                                                                                        info .= "NOTE:`n"
                                                                                                                        info .= "  For actual DPI, use DllCall with GetDpiForMonitor`n"
                                                                                                                        info .= "  or A_ScreenDPI variable if available`n"

                                                                                                                        g.Add("Text", "w500", info)

                                                                                                                        g.Show()
                                                                                                                    }

                                                                                                                    ;=============================================================================
                                                                                                                    ; EXAMPLE 7: System Metrics Dashboard
                                                                                                                    ;=============================================================================
                                                                                                                    ; Comprehensive dashboard of all important system metrics
                                                                                                                    Example7_MetricsDashboard() {
                                                                                                                        ; Create GUI
                                                                                                                        g := Gui("+Resize", "System Metrics Dashboard")
                                                                                                                        g.SetFont("s9", "Consolas")
                                                                                                                        g.BackColor := "0xF0F0F0"

                                                                                                                        g.Add("Text", "w700 Center", "═══ SYSTEM METRICS DASHBOARD ═══")

                                                                                                                        ; Screen metrics
                                                                                                                        g.Add("GroupBox", "xm w340 h120 Section", "Primary Screen")
                                                                                                                        g.Add("Text", "xs+10 ys+25", "Width:")
                                                                                                                        g.Add("Text", "x+80", SysGet(0) " px")
                                                                                                                        g.Add("Text", "xs+10", "Height:")
                                                                                                                        g.Add("Text", "x+77", SysGet(1) " px")
                                                                                                                        g.Add("Text", "xs+10", "Area:")
                                                                                                                        g.Add("Text", "x+84", Format("{:,}", SysGet(0) * SysGet(1)) " px²")

                                                                                                                        ; Virtual desktop
                                                                                                                        g.Add("GroupBox", "x+10 ys w340 h120 Section", "Virtual Desktop")
                                                                                                                        g.Add("Text", "xs+10 ys+25", "Width:")
                                                                                                                        g.Add("Text", "x+80", SysGet(78) " px")
                                                                                                                        g.Add("Text", "xs+10", "Height:")
                                                                                                                        g.Add("Text", "x+77", SysGet(79) " px")
                                                                                                                        g.Add("Text", "xs+10", "Monitors:")
                                                                                                                        g.Add("Text", "x+68", SysGet(80))

                                                                                                                        ; Window frames
                                                                                                                        g.Add("GroupBox", "xm w340 h120 Section", "Window Frames")
                                                                                                                        g.Add("Text", "xs+10 ys+25", "Caption:")
                                                                                                                        g.Add("Text", "x+72", SysGet(4) " px")
                                                                                                                        g.Add("Text", "xs+10", "Frame Width:")
                                                                                                                        g.Add("Text", "x+48", SysGet(32) " px")
                                                                                                                        g.Add("Text", "xs+10", "Border:")
                                                                                                                        g.Add("Text", "x+78", SysGet(5) " px")

                                                                                                                        ; Input devices
                                                                                                                        g.Add("GroupBox", "x+10 ys w340 h120 Section", "Input Devices")
                                                                                                                        g.Add("Text", "xs+10 ys+25", "Mouse:")
                                                                                                                        g.Add("Text", "x+90", SysGet(19) ? "Present" : "Not Present")
                                                                                                                        g.Add("Text", "xs+10", "Mouse Wheel:")
                                                                                                                        g.Add("Text", "x+50", SysGet(75) ? "Present" : "Not Present")
                                                                                                                        g.Add("Text", "xs+10", "Tablet PC:")
                                                                                                                        g.Add("Text", "x+70", SysGet(86) ? "Yes" : "No")

                                                                                                                        ; Refresh button
                                                                                                                        g.Add("Button", "xm w100", "Refresh").OnEvent("Click", (*) => (g.Destroy(), Example7_MetricsDashboard()))

                                                                                                                        ; Export button
                                                                                                                        g.Add("Button", "x+10 w100", "Export").OnEvent("Click", ExportMetrics)

                                                                                                                        g.Show()

                                                                                                                        ExportMetrics(*) {
                                                                                                                            export := "System Metrics Export`n"
                                                                                                                            export .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"
                                                                                                                            export .= "Screen: " SysGet(0) "×" SysGet(1) "`n"
                                                                                                                            export .= "Virtual: " SysGet(78) "×" SysGet(79) "`n"
                                                                                                                            export .= "Monitors: " SysGet(80) "`n"

                                                                                                                            A_Clipboard := export
                                                                                                                            MsgBox("Metrics exported to clipboard!", "Export", "Icon! T2")
                                                                                                                        }
                                                                                                                    }

                                                                                                                    ;=============================================================================
                                                                                                                    ; MAIN MENU
                                                                                                                    ;=============================================================================
                                                                                                                    CreateMainMenu() {
                                                                                                                        g := Gui(, "SysGet System Metrics Examples")
                                                                                                                        g.SetFont("s10")

                                                                                                                        g.Add("Text", "w450", "System Metrics Examples:")

                                                                                                                        g.Add("Button", "w450", "Example 1: Basic Metrics Display").OnEvent("Click", (*) => Example1_BasicMetrics())
                                                                                                                        g.Add("Button", "w450", "Example 2: Metrics Browser").OnEvent("Click", (*) => Example2_MetricsBrowser())
                                                                                                                        g.Add("Button", "w450", "Example 3: Dimension Calculator").OnEvent("Click", (*) => Example3_DimensionCalculator())
                                                                                                                        g.Add("Button", "w450", "Example 4: Frame Size Calculator").OnEvent("Click", (*) => Example4_FrameSizeCalculator())
                                                                                                                        g.Add("Button", "w450", "Example 5: Capabilities Detector").OnEvent("Click", (*) => Example5_CapabilitiesDetector())
                                                                                                                        g.Add("Button", "w450", "Example 6: DPI and Scaling Info").OnEvent("Click", (*) => Example6_DPIScalingInfo())
                                                                                                                        g.Add("Button", "w450", "Example 7: Metrics Dashboard").OnEvent("Click", (*) => Example7_MetricsDashboard())

                                                                                                                        g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

                                                                                                                        g.Show()
                                                                                                                    }

                                                                                                                    CreateMainMenu()
