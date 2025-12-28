#Requires AutoHotkey v2.0

/**
 * BuiltIn_SysGet_03_Info.ahk
 * 
 * DESCRIPTION:
 * Comprehensive system information retrieval using SysGet. Demonstrates
 * gathering detailed system configuration, capabilities, and environment
 * information for diagnostic and adaptive purposes.
 * 
 * FEATURES:
 * - System configuration queries
 * - Hardware capability detection
 * - Environment information gathering
 * - System diagnostics
 * - Configuration reporting
 * - System health monitoring
 * - Comprehensive info export
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SysGet.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Comprehensive SysGet usage
 * - System information aggregation
 * - Diagnostic data collection
 * - Configuration export
 * - Multi-source information gathering
 * 
 * LEARNING POINTS:
 * 1. SysGet provides extensive system information
 * 2. Combine multiple queries for complete picture
 * 3. System info useful for debugging
 * 4. Configuration affects application behavior
 * 5. Some metrics vary by Windows version
 * 6. Information useful for support/diagnostics
 * 7. Export data for analysis and troubleshooting
 */

;=============================================================================
; EXAMPLE 1: System Information Summary
;=============================================================================
; Comprehensive system information display
Example1_SystemSummary() {
    ; Gather system information
    info := "═══════════════════════════════════════`n"
    info .= "  SYSTEM INFORMATION SUMMARY`n"
    info .= "═══════════════════════════════════════`n`n"

    info .= "DISPLAY CONFIGURATION:`n"
    info .= "  Primary Screen: " SysGet(0) " × " SysGet(1) " pixels`n"
    info .= "  Virtual Desktop: " SysGet(78) " × " SysGet(79) " pixels`n"
    info .= "  Monitor Count: " SysGet(80) "`n`n"

    info .= "INPUT DEVICES:`n"
    info .= "  Mouse Present: " (SysGet(19) ? "Yes" : "No") "`n"
    info .= "  Mouse Wheel: " (SysGet(75) ? "Yes" : "No") "`n`n"

    info .= "SYSTEM TYPE:`n"
    info .= "  Tablet PC: " (SysGet(86) ? "Yes" : "No") "`n"
    info .= "  Media Center: " (SysGet(87) ? "Yes" : "No") "`n`n"

    info .= "WINDOW METRICS:`n"
    info .= "  Caption Height: " SysGet(4) " pixels`n"
    info .= "  Frame Width: " SysGet(32) " pixels`n"
    info .= "  Border Size: " SysGet(5) " × " SysGet(6) " pixels`n`n"

    info .= "GENERATED:`n"
    info .= "  Date/Time: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
    info .= "  Computer: " A_ComputerName "`n"
    info .= "  User: " A_UserName

    MsgBox(info, "Example 1: System Summary", "Icon!")
}

;=============================================================================
; EXAMPLE 2: Diagnostic Information Collector
;=============================================================================
; Collects comprehensive diagnostic information
Example2_DiagnosticCollector() {
    ; Create GUI
    g := Gui("+Resize", "System Diagnostic Information Collector")
    g.SetFont("s9", "Consolas")

    g.Add("Text", "w700", "Comprehensive System Diagnostics")

    ; Collect diagnostic data
    diagnostics := CollectDiagnostics()

    txtDiag := g.Add("Edit", "xm w750 h450 ReadOnly +Multi", diagnostics)

    g.Add("Button", "xm w120", "Refresh").OnEvent("Click", (*) => (g.Destroy(), Example2_DiagnosticCollector()))
    g.Add("Button", "x+10 w120", "Copy All").OnEvent("Click", (*) => (A_Clipboard := diagnostics, MsgBox("Copied!", "", "T1")))
    g.Add("Button", "x+10 w120", "Save to File").OnEvent("Click", SaveDiagnostics)

    g.Show()

    CollectDiagnostics() {
        diag := "SYSTEM DIAGNOSTIC REPORT`n"
        diag .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
        diag .= "═══════════════════════════════════════════════════`n`n"

        ; System Info
        diag .= "[SYSTEM]`n"
        diag .= "Computer Name: " A_ComputerName "`n"
        diag .= "User Name: " A_UserName "`n"
        diag .= "OS Version: " A_OSVersion "`n"
        diag .= "Is 64-bit: " (A_PtrSize = 8 ? "Yes" : "No") "`n"
        diag .= "Is Admin: " (A_IsAdmin ? "Yes" : "No") "`n`n"

        ; Display Configuration
        diag .= "[DISPLAY]`n"
        diag .= "Primary Screen: " SysGet(0) "×" SysGet(1) "`n"
        diag .= "Virtual Desktop: " SysGet(78) "×" SysGet(79) "`n"
        diag .= "Virtual Origin: (" SysGet(76) "," SysGet(77) ")`n"
        diag .= "Monitor Count: " SysGet(80) "`n`n"

        ; Per-Monitor Info
        Loop SysGet(80) {
            MonitorGet(A_Index, &L, &T, &R, &B)
            diag .= "Monitor " A_Index ": " (R - L) "×" (B - T) " at (" L "," T ")`n"
        }

        diag .= "`n[INPUT DEVICES]`n"
        diag .= "Mouse Present: " (SysGet(19) ? "Yes" : "No") "`n"
        diag .= "Mouse Wheel Present: " (SysGet(75) ? "Yes" : "No") "`n"
        diag .= "Mouse Buttons: " SysGet(43) "`n"
        diag .= "Double-Click Time: " A_DoubleClickTime " ms`n"
        diag .= "Double-Click Area: " SysGet(32) "×" SysGet(33) " pixels`n`n"

        diag .= "[WINDOW METRICS]`n"
        diag .= "Caption Height: " SysGet(4) " pixels`n"
        diag .= "Menu Height: " SysGet(15) " pixels`n"
        diag .= "Border: " SysGet(5) "×" SysGet(6) " pixels`n"
        diag .= "Frame: " SysGet(32) "×" SysGet(33) " pixels`n"
        diag .= "Scroll Bar: " SysGet(2) "×" SysGet(3) " pixels`n`n"

        diag .= "[SYSTEM CAPABILITIES]`n"
        diag .= "Tablet PC: " (SysGet(86) ? "Yes" : "No") "`n"
        diag .= "Media Center: " (SysGet(87) ? "Yes" : "No") "`n"
        diag .= "Network Present: " (SysGet(63) ? "Yes" : "No") "`n`n"

        diag .= "[AUTOHOTKEY]`n"
        diag .= "AHK Version: " A_AhkVersion "`n"
        diag .= "Script Dir: " A_ScriptDir "`n"
        diag .= "Working Dir: " A_WorkingDir "`n"

        return diag
    }

    SaveDiagnostics(*) {
        fileName := "SystemDiag_" FormatTime(, "yyyyMMdd_HHmmss") ".txt"
        try {
            FileAppend(diagnostics, A_Desktop "\" fileName)
            MsgBox("Diagnostics saved to:`n" A_Desktop "\" fileName, "Saved", "Icon!")
        } catch as err {
            MsgBox("Error saving file:`n" err.Message, "Error", "Iconx")
        }
    }
}

;=============================================================================
; EXAMPLE 3: System Configuration Validator
;=============================================================================
; Validates system meets application requirements
Example3_ConfigValidator() {
    ; Define requirements
    requirements := Map()
    requirements["MinScreenWidth"] := 1280
    requirements["MinScreenHeight"] := 720
    requirements["MinMonitors"] := 1
    requirements["RequireMouse"] := true
    requirements["RequireMouseWheel"] := false

    ; Create GUI
    g := Gui(, "System Configuration Validator")
    g.SetFont("s10")

    g.Add("Text", "w450", "Validate system configuration against requirements")

    lv := g.Add("ListView", "w450 h200", ["Requirement", "Required", "Actual", "Status"])

    ; Check screen width
    actualWidth := SysGet(0)
    status := actualWidth >= requirements["MinScreenWidth"] ? "✓ PASS" : "✗ FAIL"
    lv.Add("", "Minimum Screen Width", requirements["MinScreenWidth"], actualWidth, status)

    ; Check screen height
    actualHeight := SysGet(1)
    status := actualHeight >= requirements["MinScreenHeight"] ? "✓ PASS" : "✗ FAIL"
    lv.Add("", "Minimum Screen Height", requirements["MinScreenHeight"], actualHeight, status)

    ; Check monitor count
    actualMonitors := SysGet(80)
    status := actualMonitors >= requirements["MinMonitors"] ? "✓ PASS" : "✗ FAIL"
    lv.Add("", "Minimum Monitors", requirements["MinMonitors"], actualMonitors, status)

    ; Check mouse
    hasMouse := SysGet(19)
    status := hasMouse = requirements["RequireMouse"] ? "✓ PASS" : "✗ FAIL"
    lv.Add("", "Mouse Required", requirements["RequireMouse"] ? "Yes" : "No", hasMouse ? "Yes" : "No", status)

    ; Check mouse wheel
    hasWheel := SysGet(75)
    status := !requirements["RequireMouseWheel"] || hasWheel ? "✓ PASS" : "✗ FAIL"
    lv.Add("", "Mouse Wheel Required", requirements["RequireMouseWheel"] ? "Yes" : "No", hasWheel ? "Yes" : "No", status)

    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    ; Overall result
    allPassed := true
    Loop lv.GetCount() {
        lv.GetText(statusText, A_Index, 4)
        if InStr(statusText, "FAIL")
            allPassed := false
    }

    result := "`nOverall Status: " (allPassed ? "✓ SYSTEM MEETS ALL REQUIREMENTS" : "✗ SYSTEM DOES NOT MEET REQUIREMENTS")

    g.Add("Text", "xm w450 +Border", result)

    g.Show()
}

;=============================================================================
; EXAMPLE 4: Multi-Monitor Configuration Reporter
;=============================================================================
; Detailed multi-monitor configuration report
Example4_MultiMonitorReporter() {
    MonCount := SysGet(80)

    ; Create GUI
    g := Gui("+Resize", "Multi-Monitor Configuration Report")
    g.SetFont("s9", "Consolas")

    report := "MULTI-MONITOR CONFIGURATION REPORT`n"
    report .= "═══════════════════════════════════════════`n"
    report .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

    report .= "[OVERVIEW]`n"
    report .= "Total Monitors: " MonCount "`n"
    report .= "Primary Monitor: #" MonitorGetPrimary() "`n`n"

    report .= "[VIRTUAL DESKTOP]`n"
    report .= "Origin: (" SysGet(76) ", " SysGet(77) ")`n"
    report .= "Size: " SysGet(78) " × " SysGet(79) " pixels`n"
    report .= "Area: " Format("{:,}", SysGet(78) * SysGet(79)) " pixels²`n`n"

    ; Individual monitors
    totalArea := 0

    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &L, &T, &R, &B)
        MonitorGetWorkArea(MonNum, &WL, &WT, &WR, &WB)

        Width := R - L
        Height := B - T
        WorkWidth := WR - WL
        WorkHeight := WB - WT

        area := Width * Height
        totalArea += area

        report .= "[MONITOR " MonNum "]`n"
        report .= "Type: " (MonNum = MonitorGetPrimary() ? "Primary" : "Secondary") "`n"
        report .= "Position: " L ", " T " (top-left)`n"
        report .= "Dimensions: " Width " × " Height " pixels`n"
        report .= "Area: " Format("{:,}", area) " pixels²`n"
        report .= "Aspect Ratio: " Round(Width / Height, 2) ":1`n"
        report .= "Working Area: " WorkWidth " × " WorkHeight " pixels`n"
        report .= "Taskbar Space: " (area - WorkWidth * WorkHeight) " pixels²`n"
        report .= "`n"
    }

    report .= "[STATISTICS]`n"
    report .= "Total Screen Area: " Format("{:,}", totalArea) " pixels²`n"
    report .= "Average per Monitor: " Format("{:,}", Round(totalArea / MonCount)) " pixels²`n"

    g.Add("Text", "w700", report)

    g.Add("Button", "xm w120", "Copy Report").OnEvent("Click", (*) => (A_Clipboard := report, MsgBox("Copied!", "", "T1")))
    g.Add("Button", "x+10 w120", "Export").OnEvent("Click", ExportReport)

    g.Show()

    ExportReport(*) {
        fileName := "MonitorConfig_" FormatTime(, "yyyyMMdd_HHmmss") ".txt"
        try {
            FileAppend(report, A_Desktop "\" fileName)
            MsgBox("Report saved to:`n" A_Desktop "\" fileName, "Saved", "Icon!")
        } catch as err {
            MsgBox("Error saving file:`n" err.Message, "Error", "Iconx")
        }
    }
}

;=============================================================================
; EXAMPLE 5: System Metrics Comparison Tool
;=============================================================================
; Compares current system with common configurations
Example5_MetricsComparison() {
    ; Define common configurations
    configs := [{
        Name: "HD (Laptop)", Width: 1366, Height: 768, Monitors: 1 }, {
            Name: "Full HD", Width: 1920, Height: 1080, Monitors: 1 }, {
                Name: "QHD", Width: 2560, Height: 1440, Monitors: 1 }, {
                    Name: "4K UHD", Width: 3840, Height: 2160, Monitors: 1 }, {
                        Name: "Dual Full HD", Width: 3840, Height: 1080, Monitors: 2
                    }
    ]

    ; Get current config
    currentW := SysGet(78)  ; Virtual width
    currentH := SysGet(79)  ; Virtual height
    currentM := SysGet(80)  ; Monitor count

    ; Create GUI
    g := Gui(, "System Metrics Comparison")
    g.SetFont("s10")

    g.Add("Text", "w500", "Compare your system with common configurations")

    lv := g.Add("ListView", "w500 h200", ["Configuration", "Resolution", "Monitors", "Match"])

    for config in configs {
        isMatch := (config.Width = currentW && config.Height = currentH && config.Monitors = currentM)
        matchStr := isMatch ? "✓ EXACT MATCH" : ""

        lv.Add("", config.Name, config.Width "×" config.Height, config.Monitors, matchStr)

        if isMatch
            lv.Modify(A_Index, "Select")
    }

    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    info := "`nYour Configuration:`n"
    info .= "  Virtual Desktop: " currentW "×" currentH "`n"
    info .= "  Monitors: " currentM "`n"

    g.Add("Text", "xm w500 +Border", info)

    g.Show()
}

;=============================================================================
; EXAMPLE 6: Performance Metrics Monitor
;=============================================================================
; Monitors performance-related system metrics
Example6_PerformanceMonitor() {
    ; Create GUI
    g := Gui("+AlwaysOnTop", "Performance Metrics Monitor")
    g.SetFont("s9")

    g.Add("Text", "w400", "Real-time Performance Metrics")

    metrics := Map()
    metrics["ScreenArea"] := g.Add("Text", "xm w400", "")
    metrics["Monitors"] := g.Add("Text", "xm w400", "")
    metrics["MousePos"] := g.Add("Text", "xm w400", "")
    metrics["Updates"] := g.Add("Text", "xm w400", "")

    updateCount := 0

    UpdateMetrics()
    SetTimer(UpdateMetrics, 100)

    g.OnEvent("Close", (*) => (SetTimer(UpdateMetrics, 0), g.Destroy()))
    g.Show()

    UpdateMetrics() {
        updateCount++

        ; Screen area
        area := SysGet(78) * SysGet(79)
        metrics["ScreenArea"].Value := "Virtual Screen Area: " Format("{:,}", area) " pixels²"

        ; Monitor count
        metrics["Monitors"].Value := "Active Monitors: " SysGet(80)

        ; Mouse position
        MouseGetPos(&X, &Y)
        metrics["MousePos"].Value := "Mouse Position: " X ", " Y

        ; Update count
        metrics["Updates"].Value := "Updates: " updateCount " (every 100ms)"
    }
}

;=============================================================================
; EXAMPLE 7: Complete System Profile Exporter
;=============================================================================
; Exports complete system profile with all available information
Example7_ProfileExporter() {
    ; Create GUI
    g := Gui(, "Complete System Profile Exporter")
    g.SetFont("s10")

    g.Add("Text", "w500", "Export complete system profile")

    g.Add("Text", "xm Section", "Include in Export:")

    chkSystem := g.Add("Checkbox", "xs Checked", "System Information")
    chkDisplay := g.Add("Checkbox", "xs Checked", "Display Configuration")
    chkInput := g.Add("Checkbox", "xs Checked", "Input Devices")
    chkMetrics := g.Add("Checkbox", "xs Checked", "Window Metrics")
    chkColors := g.Add("Checkbox", "xs Checked", "System Colors")

    g.Add("Button", "xm w240", "Generate Profile").OnEvent("Click", GenerateProfile)
    g.Add("Button", "x+20 w240", "Export to File").OnEvent("Click", ExportToFile)

    txtPreview := g.Add("Edit", "xm w500 h300 ReadOnly +Multi")

    currentProfile := ""

    g.Show()

    GenerateProfile(*) {
        profile := "═══════════════════════════════════════════════`n"
        profile .= "       COMPLETE SYSTEM PROFILE`n"
        profile .= "═══════════════════════════════════════════════`n"
        profile .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
        profile .= "Computer: " A_ComputerName "`n"
        profile .= "User: " A_UserName "`n"
        profile .= "═══════════════════════════════════════════════`n`n"

        if chkSystem.Value {
            profile .= "[SYSTEM INFORMATION]`n"
            profile .= "OS Version: " A_OSVersion "`n"
            profile .= "Is 64-bit: " (A_PtrSize = 8 ? "Yes" : "No") "`n"
            profile .= "AHK Version: " A_AhkVersion "`n`n"
        }

        if chkDisplay.Value {
            profile .= "[DISPLAY CONFIGURATION]`n"
            profile .= "Primary Screen: " SysGet(0) "×" SysGet(1) "`n"
            profile .= "Virtual Desktop: " SysGet(78) "×" SysGet(79) "`n"
            profile .= "Monitor Count: " SysGet(80) "`n`n"
        }

        if chkInput.Value {
            profile .= "[INPUT DEVICES]`n"
            profile .= "Mouse: " (SysGet(19) ? "Present" : "Not Present") "`n"
            profile .= "Mouse Wheel: " (SysGet(75) ? "Present" : "Not Present") "`n`n"
        }

        if chkMetrics.Value {
            profile .= "[WINDOW METRICS]`n"
            profile .= "Caption Height: " SysGet(4) " px`n"
            profile .= "Frame Size: " SysGet(32) "×" SysGet(33) " px`n`n"
        }

        if chkColors.Value {
            profile .= "[SYSTEM COLORS]`n"
            windowBG := DllCall("GetSysColor", "Int", 5, "UInt")
            highlightBG := DllCall("GetSysColor", "Int", 13, "UInt")
            profile .= "Window BG: 0x" Format("{:06X}", windowBG) "`n"
            profile .= "Highlight: 0x" Format("{:06X}", highlightBG) "`n`n"
        }

        profile .= "═══════════════════════════════════════════════`n"
        profile .= "End of System Profile`n"
        profile .= "═══════════════════════════════════════════════"

        currentProfile := profile
        txtPreview.Value := profile
    }

    ExportToFile(*) {
        if currentProfile = "" {
            MsgBox("Generate profile first!", "Error", "Icon!")
            return
        }

        fileName := "SystemProfile_" FormatTime(, "yyyyMMdd_HHmmss") ".txt"
        try {
            FileAppend(currentProfile, A_Desktop "\" fileName)
            MsgBox("Profile saved to:`n" A_Desktop "\" fileName, "Exported", "Icon!")
        } catch as err {
            MsgBox("Error saving file:`n" err.Message, "Error", "Iconx")
        }
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "SysGet System Information Examples")
    g.SetFont("s10")

    g.Add("Text", "w450", "System Information Examples:")

    g.Add("Button", "w450", "Example 1: System Summary").OnEvent("Click", (*) => Example1_SystemSummary())
    g.Add("Button", "w450", "Example 2: Diagnostic Collector").OnEvent("Click", (*) => Example2_DiagnosticCollector())
    g.Add("Button", "w450", "Example 3: Config Validator").OnEvent("Click", (*) => Example3_ConfigValidator())
    g.Add("Button", "w450", "Example 4: Multi-Monitor Reporter").OnEvent("Click", (*) => Example4_MultiMonitorReporter())
    g.Add("Button", "w450", "Example 5: Metrics Comparison").OnEvent("Click", (*) => Example5_MetricsComparison())
    g.Add("Button", "w450", "Example 6: Performance Monitor").OnEvent("Click", (*) => Example6_PerformanceMonitor())
    g.Add("Button", "w450", "Example 7: Profile Exporter").OnEvent("Click", (*) => Example7_ProfileExporter())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
