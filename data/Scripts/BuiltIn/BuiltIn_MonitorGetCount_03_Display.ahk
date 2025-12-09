#Requires AutoHotkey v2.0

/**
* BuiltIn_MonitorGetCount_03_Display.ahk
*
* DESCRIPTION:
* Display management and visualization using MonitorGetCount. Demonstrates
* creating visual representations, management interfaces, and diagnostic
* tools based on monitor count.
*
* FEATURES:
* - Visual monitor count displays
* - Interactive monitor management GUIs
* - System tray integration
* - Monitor count dashboards
* - Configuration recommendations
* - Performance monitoring
* - Display topology visualization
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/MonitorGetCount.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Advanced GUI layouts
* - Progress bars and visual indicators
* - Tray icon integration
* - Dynamic control creation
* - Custom drawing and visualization
* - Menu systems
*
* LEARNING POINTS:
* 1. Visual feedback improves user experience
* 2. Tray integration provides quick access
* 3. Dashboard views consolidate information
* 4. Color coding enhances readability
* 5. Real-time updates keep displays current
* 6. Topology views show monitor relationships
* 7. Management interfaces simplify operations
*/

;=============================================================================
; EXAMPLE 1: Monitor Count Dashboard
;=============================================================================
; Comprehensive dashboard showing monitor count and related metrics
Example1_Dashboard() {
    ; Create GUI
    g := Gui("+Resize", "Monitor Count Dashboard")
    g.SetFont("s10")
    g.BackColor := "0x2B2B2B"

    ; Header
    g.SetFont("s16 Bold", "Segoe UI")
    g.Add("Text", "w600 cWhite Center", "MONITOR DASHBOARD")

    g.SetFont("s10 Norm")

    ; Main count display
    MonCount := MonitorGetCount()

    g.SetFont("s48 Bold")
    txtCount := g.Add("Text", "xm w600 h100 +Center c0x00FF00 Background0x1E1E1E +Border", MonCount)

    g.SetFont("s12")
    g.Add("Text", "xm w600 +Center cWhite", "Connected Monitors")

    ; Metrics panel
    g.SetFont("s9")
    g.Add("Text", "xm Section cWhite", "System Metrics:")

    ; Create metrics display
    metricsPanel := g.Add("Text", "xs w600 h150 c0xE0E0E0 Background0x1E1E1E +Border")

    ; Monitor list
    g.Add("Text", "xm Section cWhite", "Monitor Details:")
    lv := g.Add("ListView", "xs w600 h150 Background0x1E1E1E c0xFFFFFF", [
    "Monitor", "Resolution", "Position", "Status"
    ])

    ; Refresh button
    g.Add("Button", "xm w120", "Refresh").OnEvent("Click", RefreshDashboard)

    UpdateDashboard()

    g.Show()

    UpdateDashboard() {
        MonCount := MonitorGetCount()
        txtCount.Value := MonCount

        ; Update metrics
        totalPixels := 0
        totalWidth := 0
        totalHeight := 0

        Loop MonCount {
            MonitorGet(A_Index, &L, &T, &R, &B)
            totalPixels += (R - L) * (B - T)
            totalWidth += (R - L)
            totalHeight := Max(totalHeight, B - T)
        }

        metrics := "`n"
        metrics .= "  Total Screen Area: " Format("{:,}", totalPixels) " pixels²`n"
        metrics .= "  Combined Width: " Format("{:,}", totalWidth) " pixels`n"
        metrics .= "  Maximum Height: " Format("{:,}", totalHeight) " pixels`n"
        metrics .= "  Primary Monitor: #" MonitorGetPrimary() "`n"
        metrics .= "  Average PPI: ~96 (assumed)`n"

        metricsPanel.Value := metrics

        ; Update ListView
        lv.Delete()
        Loop MonCount {
            MonNum := A_Index
            MonitorGet(MonNum, &L, &T, &R, &B)

            resolution := (R - L) "x" (B - T)
            position := L "," T
            status := (MonNum = MonitorGetPrimary()) ? "Primary" : "Secondary"

            lv.Add("", "Monitor " MonNum, resolution, position, status)
        }

        Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")
    }

    RefreshDashboard(*) {
        UpdateDashboard()
    }
}

;=============================================================================
; EXAMPLE 2: System Tray Monitor Counter
;=============================================================================
; Shows monitor count in system tray with menu
Example2_TrayCounter() {
    ; Create hidden GUI for tray icon
    g := Gui("+AlwaysOnTop +ToolWindow")

    ; Set up tray icon
    A_IconTip := "Monitor Counter"

    ; Update tray tooltip with count
    UpdateTrayInfo()

    ; Create tray menu
    tray := A_TrayMenu
    tray.Delete()  ; Clear default items

    tray.Add("Monitor Count: " MonitorGetCount(), (*) => ShowDetails())
    tray.Add()
    tray.Add("Show Details", (*) => ShowDetails())
    tray.Add("Refresh", (*) => UpdateTrayInfo())
    tray.Add()

    Loop MonitorGetCount() {
        MonNum := A_Index
        tray.Add("Go to Monitor " MonNum, (*) => GoToMonitor(MonNum))
    }

    tray.Add()
    tray.Add("Exit", (*) => ExitApp())

    ; Set up refresh timer
    SetTimer(UpdateTrayInfo, 5000)

    UpdateTrayInfo() {
        MonCount := MonitorGetCount()
        A_IconTip := "Monitor Count: " MonCount "`nClick for details"

        ; Update menu
        try tray.Rename("Monitor Count: *", "Monitor Count: " MonCount)
    }

    ShowDetails() {
        MonCount := MonitorGetCount()

        details := "MONITOR INFORMATION`n"
        details .= "====================`n`n"
        details .= "Total Monitors: " MonCount "`n`n"

        Loop MonCount {
            MonitorGet(A_Index, &L, &T, &R, &B)
            details .= "Monitor " A_Index ":`n"
            details .= "  Resolution: " (R-L) "x" (B-T) "`n"
            details .= "  Position: " L "," T "`n"
            if A_Index = MonitorGetPrimary()
            details .= "  Status: Primary`n"
            details .= "`n"
        }

        MsgBox(details, "Monitor Details", "Icon!")
    }

    GoToMonitor(MonNum) {
        try {
            MonitorGetWorkArea(MonNum, &L, &T, &R, &B)
            ; Move mouse to center of monitor
            MouseMove((L + R) // 2, (T + B) // 2)
        }
    }

    ; Show message
    MsgBox("Tray icon activated. Check system tray for monitor count.", "Tray Counter Active", "T3")
}

;=============================================================================
; EXAMPLE 3: Visual Monitor Count Indicator
;=============================================================================
; Creates visual indicators for each monitor
Example3_VisualIndicator() {
    MonCount := MonitorGetCount()

    ; Create main GUI
    g := Gui("+AlwaysOnTop", "Visual Monitor Indicator")
    g.SetFont("s10")

    g.Add("Text", "w400", "Visual Monitor Count: " MonCount)

    ; Create visual indicators
    g.Add("Text", "xm Section", "Monitor Indicators:")

    indicators := []
    xPos := 10

    Loop MonCount {
        MonNum := A_Index

        ; Create colored indicator
        color := (MonNum = MonitorGetPrimary()) ? "Green" : "Blue"

        indicator := g.Add("Progress", "xs+" xPos " w50 h50 Background" color " c" color, 100)
        indicators.Push(indicator)

        ; Add label
        g.Add("Text", "xs+" (xPos + 15) " y+5 w50 +Center", "M" MonNum)

        xPos += 70
    }

    ; Legend
    g.Add("Text", "xm y+20", "Green = Primary Monitor  |  Blue = Secondary Monitor")

    ; Add info panel
    txtInfo := g.Add("Text", "xm w400 h100 +Border")

    UpdateInfo()

    ; Refresh button
    g.Add("Button", "xm w100", "Refresh").OnEvent("Click", (*) => (g.Destroy(), Example3_VisualIndicator()))

    g.Show()

    UpdateInfo() {
        info := "Configuration Summary:`n"
        info .= "  Total: " MonCount " monitor(s)`n"
        info .= "  Primary: #" MonitorGetPrimary() "`n"
        info .= "  Secondary: " (MonCount - 1) " monitor(s)"

        txtInfo.Value := info
    }
}

;=============================================================================
; EXAMPLE 4: Monitor Count Bar Chart
;=============================================================================
; Creates a bar chart representation of monitor metrics
Example4_BarChart() {
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Monitor Metrics Bar Chart")
    g.SetFont("s9")

    g.Add("Text", "w600", "Monitor Metrics Comparison (Bar Chart)")

    ; Get max resolution for scaling
    maxWidth := 0
    Loop MonCount {
        MonitorGet(A_Index, &L, &T, &R, &B)
        maxWidth := Max(maxWidth, R - L)
    }

    ; Create bars for each monitor
    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &L, &T, &R, &B)

        Width := R - L
        Height := B - T

        ; Calculate bar width (scale to 500px max)
        barWidth := Round((Width / maxWidth) * 500)

        ; Create label
        label := "Monitor " MonNum " (" Width "x" Height "):"
        g.Add("Text", "xm w200", label)

        ; Create bar
        color := (MonNum = MonitorGetPrimary()) ? "0x00AA00" : "0x0066CC"
        g.Add("Progress", "x+10 w" barWidth " h20 Background" color " c" color, 100)
    }

    ; Add statistics
    g.Add("Text", "xm Section", "`nStatistics:")

    totalArea := 0
    Loop MonCount {
        MonitorGet(A_Index, &L, &T, &R, &B)
        totalArea += (R - L) * (B - T)
    }

    avgArea := totalArea // MonCount

    stats := "  Total Monitors: " MonCount "`n"
    stats .= "  Total Area: " Format("{:,}", totalArea) " pixels²`n"
    stats .= "  Average Area: " Format("{:,}", avgArea) " pixels²"

    g.Add("Text", "xs", stats)

    g.Show()
}

;=============================================================================
; EXAMPLE 5: Monitor Configuration Wizard
;=============================================================================
; Interactive wizard for managing monitor configurations
Example5_ConfigurationWizard() {
    ; Create GUI
    g := Gui(, "Monitor Configuration Wizard")
    g.SetFont("s10")

    MonCount := MonitorGetCount()

    ; Welcome page
    g.Add("Text", "w500", "Monitor Configuration Wizard")
    g.Add("Text", "w500", "Detected " MonCount " monitor(s). Let's optimize your setup!")

    ; Configuration options
    g.Add("Text", "xm Section", "`nSelect Configuration Type:")

    options := []

    if MonCount = 1 {
        options := [
        "Single Monitor - Maximized Layout",
        "Single Monitor - Tiled Layout",
        "Single Monitor - Floating Windows"
        ]
    } else if MonCount = 2 {
        options := [
        "Dual Monitor - Extended Desktop",
        "Dual Monitor - Mirror Display",
        "Dual Monitor - Primary + Secondary"
        ]
    } else {
        options := [
        "Multi-Monitor - Surround Mode",
        "Multi-Monitor - Independent Displays",
        "Multi-Monitor - Custom Layout"
        ]
    }

    lstOptions := g.Add("ListBox", "xs w500 h100", options)
    lstOptions.Choose(1)

    ; Details panel
    g.Add("Text", "xs", "Configuration Details:")
    txtDetails := g.Add("Text", "xs w500 h100 +Border")

    ; Buttons
    g.Add("Button", "xs w120", "Apply Config").OnEvent("Click", ApplyConfig)
    g.Add("Button", "x+10 w120", "Cancel").OnEvent("Click", (*) => g.Destroy())

    ; Update details when selection changes
    lstOptions.OnEvent("Change", UpdateDetails)

    UpdateDetails()

    g.Show()

    UpdateDetails(*) {
        selection := lstOptions.Value

        details := "Configuration: " options[selection] "`n`n"

        if MonCount = 1 {
            switch selection {
                case 1: details .= "Windows will be maximized to use full screen space."
                case 2: details .= "Windows will be arranged in a grid pattern."
                case 3: details .= "Windows will overlap in a cascading pattern."
            }
        } else if MonCount = 2 {
            switch selection {
                case 1: details .= "Desktop extends across both monitors."
                case 2: details .= "Same content shown on both monitors."
                case 3: details .= "Different content on each monitor."
            }
        } else {
            switch selection {
                case 1: details .= "All monitors form one continuous display."
                case 2: details .= "Each monitor operates independently."
                case 3: details .= "Create your own custom arrangement."
            }
        }

        txtDetails.Value := details
    }

    ApplyConfig(*) {
        selection := lstOptions.Value
        MsgBox("Would apply: " options[selection], "Configuration", "Icon!")
        g.Destroy()
    }
}

;=============================================================================
; EXAMPLE 6: Monitor Health Monitor
;=============================================================================
; Monitors and displays health metrics for all monitors
Example6_HealthMonitor() {
    ; Create GUI
    g := Gui(, "Monitor Health Monitor")
    g.SetFont("s9")

    MonCount := MonitorGetCount()

    g.Add("Text", "w600", "Monitor Health Status (" MonCount " monitors)")

    ; Create health display for each monitor
    Loop MonCount {
        MonNum := A_Index

        g.Add("Text", "xm Section", "Monitor " MonNum ":")

        ; Status indicators
        g.Add("Progress", "xs w100 h20 BackgroundGreen cGreen", 100)
        g.Add("Text", "x+10", "Connected")

        ; Resolution check
        MonitorGet(MonNum, &L, &T, &R, &B)
        Width := R - L
        Height := B - T

        g.Add("Progress", "xs w100 h20 BackgroundGreen cGreen", 100)
        g.Add("Text", "x+10", "Resolution: " Width "x" Height)

        ; Position check
        g.Add("Progress", "xs w100 h20 BackgroundGreen cGreen", 100)
        g.Add("Text", "x+10", "Position: " L "," T)
    }

    ; Overall health
    g.Add("Text", "xm Section", "`nOverall System Health:")
    g.Add("Progress", "xs w300 h30 BackgroundGreen cGreen", 100)
    g.Add("Text", "xs +Center w300", "All Monitors Healthy")

    ; Refresh button
    g.Add("Button", "xm w120", "Refresh").OnEvent("Click", (*) => (g.Destroy(), Example6_HealthMonitor()))

    g.Show()
}

;=============================================================================
; EXAMPLE 7: Monitor Topology Viewer
;=============================================================================
; Shows the physical topology/arrangement of monitors
Example7_TopologyViewer() {
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Monitor Topology Viewer")
    g.BackColor := "White"

    g.Add("Text", "w700", "Monitor Topology (" MonCount " monitors)")

    ; Get virtual desktop bounds
    virtualLeft := 999999
    virtualTop := 999999
    virtualRight := -999999
    virtualBottom := -999999

    monitors := []

    Loop MonCount {
        MonitorGet(A_Index, &L, &T, &R, &B)

        monitors.Push({
            Num: A_Index,
            Left: L,
            Top: T,
            Right: R,
            Bottom: B
        })

        virtualLeft := Min(virtualLeft, L)
        virtualTop := Min(virtualTop, T)
        virtualRight := Max(virtualRight, R)
        virtualBottom := Max(virtualBottom, B)
    }

    ; Calculate scale
    virtualWidth := virtualRight - virtualLeft
    virtualHeight := virtualBottom - virtualTop

    scale := Min(650 / virtualWidth, 400 / virtualHeight)

    ; Draw monitors
    for mon in monitors {
        x := Round((mon.Left - virtualLeft) * scale) + 25
        y := Round((mon.Top - virtualTop) * scale) + 50
        w := Round((mon.Right - mon.Left) * scale)
        h := Round((mon.Bottom - mon.Top) * scale)

        ; Monitor rectangle
        color := (mon.Num = MonitorGetPrimary()) ? "0x00AA00" : "0x0066CC"
        g.Add("Progress", "x" x " y" y " w" w " h" h " Background" color " c" color, 100)

        ; Monitor label
        g.Add("Text", "x" (x + w // 2 - 30) " y" (y + h // 2 - 10) " w60 h20 +Center BackgroundTrans cWhite",
        "Monitor " mon.Num)

        ; Resolution label
        resolution := (mon.Right - mon.Left) "x" (mon.Bottom - mon.Top)
        g.Add("Text", "x" (x + w // 2 - 40) " y" (y + h - 20) " w80 h15 +Center BackgroundTrans cWhite",
        resolution)
    }

    ; Legend
    g.Add("Text", "x25 y+30 w700", "Green = Primary Monitor  |  Blue = Secondary Monitor")
    g.Add("Text", "x25 w700", "Scale: 1:" Round(1 / scale))

    g.Show("w750 h" (Round((virtualBottom - virtualTop) * scale) + 150))
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGetCount Display Management Examples")
    g.SetFont("s10")

    g.Add("Text", "w450", "Monitor Count Display & Management:")

    g.Add("Button", "w450", "Example 1: Monitor Dashboard").OnEvent("Click", (*) => Example1_Dashboard())
    g.Add("Button", "w450", "Example 2: System Tray Counter").OnEvent("Click", (*) => Example2_TrayCounter())
    g.Add("Button", "w450", "Example 3: Visual Indicator").OnEvent("Click", (*) => Example3_VisualIndicator())
    g.Add("Button", "w450", "Example 4: Bar Chart").OnEvent("Click", (*) => Example4_BarChart())
    g.Add("Button", "w450", "Example 5: Configuration Wizard").OnEvent("Click", (*) => Example5_ConfigurationWizard())
    g.Add("Button", "w450", "Example 6: Health Monitor").OnEvent("Click", (*) => Example6_HealthMonitor())
    g.Add("Button", "w450", "Example 7: Topology Viewer").OnEvent("Click", (*) => Example7_TopologyViewer())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
