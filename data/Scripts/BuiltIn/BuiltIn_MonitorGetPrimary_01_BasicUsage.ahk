#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_MonitorGetPrimary_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Demonstrates basic usage of MonitorGetPrimary function for identifying
 * the primary monitor in multi-monitor setups. Shows how to query, validate,
 * and use the primary monitor designation.
 * 
 * FEATURES:
 * - Identifying primary monitor
 * - Primary vs secondary distinction
 * - Primary monitor properties
 * - Default placement strategies
 * - Primary monitor validation
 * - Centering on primary display
 * - Primary-aware window management
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/MonitorGetPrimary.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - MonitorGetPrimary function
 * - Integration with MonitorGet
 * - Conditional logic based on primary
 * - Modern GUI positioning
 * - Property-based window management
 * 
 * LEARNING POINTS:
 * 1. Primary monitor is designated in Windows display settings
 * 2. MonitorGetPrimary returns monitor number (1-based)
 * 3. Primary monitor typically has coordinates starting at 0,0
 * 4. Task bar is usually on primary monitor
 * 5. New windows often default to primary monitor
 * 6. Only one monitor can be primary at a time
 * 7. Primary monitor is where notifications appear
 */

;=============================================================================
; EXAMPLE 1: Basic Primary Monitor Identification
;=============================================================================
; Simple identification and display of primary monitor
Example1_BasicIdentification() {
    ; Get primary monitor number
    PrimaryNum := MonitorGetPrimary()
    TotalMonitors := MonitorGetCount()

    ; Get primary monitor bounds
    MonitorGet(PrimaryNum, &Left, &Top, &Right, &Bottom)

    ; Build information
    info := "PRIMARY MONITOR INFORMATION`n"
    info .= "===========================`n`n"

    info .= "Monitor Number: " PrimaryNum " of " TotalMonitors "`n`n"

    info .= "Bounds:`n"
    info .= "  Left:   " Left "`n"
    info .= "  Top:    " Top "`n"
    info .= "  Right:  " Right "`n"
    info .= "  Bottom: " Bottom "`n`n"

    info .= "Dimensions:`n"
    info .= "  Width:  " (Right - Left) " pixels`n"
    info .= "  Height: " (Bottom - Top) " pixels`n`n"

    info .= "Position:`n"
    if (Left = 0 && Top = 0)
        info .= "  ✓ At origin (0, 0) - typical for primary`n"
    else
        info .= "  ⚠ Not at origin - unusual configuration`n"

    info .= "`nThe primary monitor is where:`n"
    info .= "  • The taskbar typically appears`n"
    info .= "  • New windows open by default`n"
    info .= "  • System notifications display`n"
    info .= "  • The Windows Start menu appears"

    MsgBox(info, "Example 1: Primary Monitor", "Icon!")
}

;=============================================================================
; EXAMPLE 2: Primary vs Secondary Comparison
;=============================================================================
; Compares primary monitor with all secondary monitors
Example2_PrimaryVsSecondary() {
    ; Create GUI
    g := Gui("+Resize", "Primary vs Secondary Monitors")
    g.SetFont("s9", "Consolas")

    MonCount := MonitorGetCount()
    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w700", "Monitor Comparison (Primary Highlighted)")

    ; Create ListView
    lv := g.Add("ListView", "w750 h300", [
        "Monitor", "Type", "Resolution", "Position", "Area (px²)", "At Origin"
    ])

    ; Populate data
    Loop MonCount {
        MonNum := A_Index
        MonitorGet(MonNum, &Left, &Top, &Right, &Bottom)

        Type := (MonNum = PrimaryNum) ? "PRIMARY" : "Secondary"
        Width := Right - Left
        Height := Bottom - Top
        Resolution := Width "x" Height
        Position := Left "," Top
        Area := Format("{:,}", Width * Height)
        AtOrigin := (Left = 0 && Top = 0) ? "Yes" : "No"

        lv.Add("", "Monitor " MonNum, Type, Resolution, Position, Area, AtOrigin)

        ; Highlight primary row
        if MonNum = PrimaryNum
            lv.Modify(MonNum, "Select")
    }

    ; Auto-size columns
    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    ; Add summary
    g.Add("Text", "xm Section", "Summary:")

    MonitorGet(PrimaryNum, &PLeft, &PTop, &PRight, &PBottom)
    PrimWidth := PRight - PLeft
    PrimHeight := PBottom - PTop

    summary := "  Primary Monitor: #" PrimaryNum "`n"
    summary .= "  Primary Size: " PrimWidth "x" PrimHeight "`n"
    summary .= "  Secondary Monitors: " (MonCount - 1) "`n"
    summary .= "  Total Monitors: " MonCount

    g.Add("Text", "xs", summary)

    g.Show()
}

;=============================================================================
; EXAMPLE 3: Primary Monitor Property Inspector
;=============================================================================
; Detailed inspection of primary monitor properties
Example3_PropertyInspector() {
    PrimaryNum := MonitorGetPrimary()

    ; Get bounds
    MonitorGet(PrimaryNum, &Left, &Top, &Right, &Bottom)

    ; Get working area
    MonitorGetWorkArea(PrimaryNum, &WorkLeft, &WorkTop, &WorkRight, &WorkBottom)

    ; Create GUI
    g := Gui(, "Primary Monitor Property Inspector")
    g.SetFont("s9", "Consolas")

    g.Add("Text", "w500", "PRIMARY MONITOR (Monitor #" PrimaryNum ") - DETAILED PROPERTIES")
    g.Add("Text", "w500", "═══════════════════════════════════════════════════")

    ; Full monitor bounds
    g.Add("Text", "xm Section", "`nFULL MONITOR BOUNDS:")
    info := "  Left:   " Left " pixels`n"
    info .= "  Top:    " Top " pixels`n"
    info .= "  Right:  " Right " pixels`n"
    info .= "  Bottom: " Bottom " pixels"
    g.Add("Text", "xs", info)

    ; Working area
    g.Add("Text", "xm Section", "`nWORKING AREA (excluding taskbar):")
    workInfo := "  Left:   " WorkLeft " pixels`n"
    workInfo .= "  Top:    " WorkTop " pixels`n"
    workInfo .= "  Right:  " WorkRight " pixels`n"
    workInfo .= "  Bottom: " WorkBottom " pixels"
    g.Add("Text", "xs", workInfo)

    ; Dimensions
    Width := Right - Left
    Height := Bottom - Top
    WorkWidth := WorkRight - WorkLeft
    WorkHeight := WorkBottom - WorkTop

    g.Add("Text", "xm Section", "`nDIMENSIONS:")
    dimInfo := "  Total Size:    " Width " x " Height " pixels`n"
    dimInfo .= "  Working Size:  " WorkWidth " x " WorkHeight " pixels`n"
    dimInfo .= "  Total Area:    " Format("{:,}", Width * Height) " px²`n"
    dimInfo .= "  Working Area:  " Format("{:,}", WorkWidth * WorkHeight) " px²`n"
    dimInfo .= "  Aspect Ratio:  " Round(Width / Height, 2) ":1"
    g.Add("Text", "xs", dimInfo)

    ; Taskbar info
    TaskbarH := (Bottom - WorkBottom) + (WorkTop - Top)
    TaskbarW := (Left - WorkLeft) + (WorkRight - Right)

    g.Add("Text", "xm Section", "`nTASKBAR/SYSTEM UI:")
    taskbarInfo := "  Height Lost: " TaskbarH " pixels`n"
    taskbarInfo .= "  Width Lost:  " TaskbarW " pixels`n"
    taskbarInfo .= "  Usable Area: " Round((WorkWidth * WorkHeight) / (Width * Height) * 100, 1) "%"
    g.Add("Text", "xs", taskbarInfo)

    ; Position info
    g.Add("Text", "xm Section", "`nPOSITION:")
    posInfo := "  At Origin (0,0): " ((Left = 0 && Top = 0) ? "Yes ✓" : "No ✗") "`n"
    posInfo .= "  Center Point: (" (Left + Width // 2) ", " (Top + Height // 2) ")"
    g.Add("Text", "xs", posInfo)

    g.Show()
}

;=============================================================================
; EXAMPLE 4: Center Window on Primary Monitor
;=============================================================================
; Centers the active window on the primary monitor
Example4_CenterOnPrimary() {
    ; Create GUI
    g := Gui(, "Center on Primary Monitor")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w350", "Primary Monitor: #" PrimaryNum)

    g.Add("Button", "xm w170", "Center Active Window").OnEvent("Click", CenterActive)
    g.Add("Button", "x+10 w170", "Center This Window").OnEvent("Click", CenterThis)

    g.Add("Text", "xm Section", "Window will be centered on Primary Monitor")
    txtStatus := g.Add("Text", "xs w350 h80 +Border")

    g.Show()

    CenterActive(*) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd {
                txtStatus.Value := "No active window found (or this window is active)"
                return
            }

            ; Get window size
            WinGetPos(, , &WinW, &WinH, WinID)

            ; Get primary monitor working area
            PrimaryNum := MonitorGetPrimary()
            MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

            ; Calculate center position
            CenterX := Left + ((Right - Left - WinW) // 2)
            CenterY := Top + ((Bottom - Top - WinH) // 2)

            ; Move window
            WinMove(CenterX, CenterY, , , WinID)

            WinTitle := WinGetTitle(WinID)
            txtStatus.Value := "Centered window:`n" SubStr(WinTitle, 1, 40) "`n`nPosition: " CenterX "," CenterY
        }
    }

    CenterThis(*) {
        ; Get this window size
        WinGetPos(, , &WinW, &WinH, g.Hwnd)

        ; Get primary monitor working area
        PrimaryNum := MonitorGetPrimary()
        MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

        ; Calculate center position
        CenterX := Left + ((Right - Left - WinW) // 2)
        CenterY := Top + ((Bottom - Top - WinH) // 2)

        ; Move window
        g.Move(CenterX, CenterY)

        txtStatus.Value := "This window centered on Primary Monitor`n`nPosition: " CenterX "," CenterY
    }
}

;=============================================================================
; EXAMPLE 5: Primary Monitor Validator
;=============================================================================
; Validates if a window is on the primary monitor
Example5_PrimaryValidator() {
    ; Create GUI
    g := Gui(, "Primary Monitor Validator")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", , "Primary Monitor: #" PrimaryNum)
    g.Add("Button", "xm w200", "Check Active Window").OnEvent("Click", CheckWindow)

    txtResult := g.Add("Text", "xm w400 h250 +Border")

    g.Show()

    CheckWindow(*) {
        try {
            WinID := WinExist("A")
            if !WinID {
                txtResult.Value := "No active window found"
                return
            }

            ; Get window position
            WinGetPos(&X, &Y, &W, &H, WinID)
            WinTitle := WinGetTitle(WinID)

            ; Determine which monitor the window is on
            windowMonitor := 0

            Loop MonitorGetCount() {
                MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)

                ; Check if window's top-left corner is in this monitor
                if (X >= Left && X < Right && Y >= Top && Y < Bottom) {
                    windowMonitor := A_Index
                    break
                }
            }

            ; Build result
            result := "Window: " SubStr(WinTitle, 1, 40) "`n"
            result .= "Position: " X "," Y " (Size: " W "x" H ")`n`n"

            if windowMonitor = 0 {
                result .= "Status: ✗ Off-screen`n"
                result .= "Window is not on any monitor!"
            } else if windowMonitor = PrimaryNum {
                result .= "Status: ✓ ON PRIMARY MONITOR`n"
                result .= "Monitor #" windowMonitor " (Primary)"
            } else {
                result .= "Status: ✗ On Secondary Monitor`n"
                result .= "Monitor #" windowMonitor " (Secondary)`n`n"
                result .= "Primary monitor is #" PrimaryNum
            }

            ; Add distance from primary if not on primary
            if windowMonitor != PrimaryNum && windowMonitor != 0 {
                MonitorGet(PrimaryNum, &PLeft, &PTop, &PRight, &PBottom)
                PCenterX := (PLeft + PRight) // 2
                PCenterY := (PTop + PBottom) // 2
                WinCenterX := X + W // 2
                WinCenterY := Y + H // 2

                distance := Round(Sqrt((WinCenterX - PCenterX) ** 2 + (WinCenterY - PCenterY) ** 2))
                result .= "`n`nDistance from primary: " distance " pixels"
            }

            txtResult.Value := result
        }
    }
}

;=============================================================================
; EXAMPLE 6: Primary Monitor Information Panel
;=============================================================================
; Comprehensive information panel about the primary monitor
Example6_InformationPanel() {
    PrimaryNum := MonitorGetPrimary()
    MonCount := MonitorGetCount()

    ; Get bounds
    MonitorGet(PrimaryNum, &Left, &Top, &Right, &Bottom)
    MonitorGetWorkArea(PrimaryNum, &WLeft, &WTop, &WRight, &WBottom)

    ; Create GUI
    g := Gui(, "Primary Monitor Information Panel")
    g.SetFont("s9", "Consolas")
    g.BackColor := "0xF0F0F0"

    ; Header
    g.SetFont("s11 Bold")
    g.Add("Text", "w600 Center", "PRIMARY MONITOR INFORMATION")

    g.SetFont("s9 Norm")

    ; Main info box
    info := "`n"
    info .= "  ╔═══════════════════════════════════════════╗`n"
    info .= "  ║  Monitor #" PrimaryNum " of " MonCount "                             ║`n"
    info .= "  ╚═══════════════════════════════════════════╝`n`n"

    info .= "  SCREEN BOUNDS:`n"
    info .= "    Top-Left:     (" Left ", " Top ")`n"
    info .= "    Bottom-Right: (" Right ", " Bottom ")`n"
    info .= "    Dimensions:   " (Right - Left) " × " (Bottom - Top) " pixels`n`n"

    info .= "  WORKING AREA:`n"
    info .= "    Top-Left:     (" WLeft ", " WTop ")`n"
    info .= "    Bottom-Right: (" WRight ", " WBottom ")`n"
    info .= "    Dimensions:   " (WRight - WLeft) " × " (WBottom - WTop) " pixels`n`n"

    info .= "  PROPERTIES:`n"
    info .= "    Total Area:   " Format("{:,}", (Right - Left) * (Bottom - Top)) " px²`n"
    info .= "    Working Area: " Format("{:,}", (WRight - WLeft) * (WBottom - WTop)) " px²`n"
    info .= "    Aspect Ratio: " Round((Right - Left) / (Bottom - Top), 2) ":1`n"
    info .= "    At Origin:    " ((Left = 0 && Top = 0) ? "Yes ✓" : "No") "`n`n"

    info .= "  NOTES:`n"
    info .= "    • This is the main display for Windows`n"
    info .= "    • Taskbar usually appears here`n"
    info .= "    • New windows open here by default`n"
    info .= "    • System notifications show here`n"

    g.Add("Text", "xm w600", info)

    g.Show()
}

;=============================================================================
; EXAMPLE 7: Primary-Aware Window Launcher
;=============================================================================
; Launches new windows centered on primary monitor
Example7_WindowLauncher() {
    ; Create launcher GUI
    g := Gui(, "Primary-Aware Window Launcher")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", , "Launch windows on Primary Monitor (#" PrimaryNum ")")

    ; Window size options
    g.Add("Text", "xm Section", "Window Size:")
    g.Add("Radio", "xs Checked", "Small (400x300)")
    g.Add("Radio", "xs", "Medium (800x600)")
    g.Add("Radio", "xs", "Large (1200x800)")

    ; Launch button
    g.Add("Button", "xm w200", "Launch Test Window").OnEvent("Click", LaunchWindow)

    txtStatus := g.Add("Text", "xm w300 +Border")
    txtStatus.Value := "Ready to launch on Monitor #" PrimaryNum

    g.Show()

    LaunchWindow(*) {
        ; Determine size
        if WinExist("ahk_id " g.Hwnd) {
            for ctrl in g {
                if ctrl.Type = "Radio" && ctrl.Value {
                    radioText := ctrl.Text
                    break
                }
            }

            ; Parse size
            if InStr(radioText, "Small")
                Width := 400, Height := 300
            else if InStr(radioText, "Medium")
                Width := 800, Height := 600
            else
                Width := 1200, Height := 800
        }

        ; Get primary monitor working area
        PrimaryNum := MonitorGetPrimary()
        MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

        ; Calculate center position
        X := Left + ((Right - Left - Width) // 2)
        Y := Top + ((Bottom - Top - Height) // 2)

        ; Create new window
        newWin := Gui(, "Test Window on Primary Monitor")
        newWin.Add("Text", "w" (Width - 40) " Center", "This window was launched on Primary Monitor #" PrimaryNum)
        newWin.Add("Text", "w" (Width - 40) " Center", "Position: " X "," Y)
        newWin.Add("Text", "w" (Width - 40) " Center", "Size: " Width "x" Height)
        newWin.Add("Button", "w100 Center", "Close").OnEvent("Click", (*) => newWin.Destroy())

        newWin.Show("x" X " y" Y " w" Width " h" Height)

        txtStatus.Value := "Launched " Width "x" Height " window at " X "," Y
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGetPrimary Basic Usage Examples")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()
    g.Add("Text", "w450", "Current Primary Monitor: #" PrimaryNum)
    g.Add("Text", "w450", "Select an example to run:")

    g.Add("Button", "w450", "Example 1: Basic Identification").OnEvent("Click", (*) => Example1_BasicIdentification())
    g.Add("Button", "w450", "Example 2: Primary vs Secondary").OnEvent("Click", (*) => Example2_PrimaryVsSecondary())
    g.Add("Button", "w450", "Example 3: Property Inspector").OnEvent("Click", (*) => Example3_PropertyInspector())
    g.Add("Button", "w450", "Example 4: Center on Primary").OnEvent("Click", (*) => Example4_CenterOnPrimary())
    g.Add("Button", "w450", "Example 5: Primary Validator").OnEvent("Click", (*) => Example5_PrimaryValidator())
    g.Add("Button", "w450", "Example 6: Information Panel").OnEvent("Click", (*) => Example6_InformationPanel())
    g.Add("Button", "w450", "Example 7: Window Launcher").OnEvent("Click", (*) => Example7_WindowLauncher())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
