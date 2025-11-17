#Requires AutoHotkey v2.0
/**
 * BuiltIn_MonitorGetPrimary_03_MultiDisplay.ahk
 *
 * DESCRIPTION:
 * Multi-display management with primary monitor awareness. Demonstrates
 * complex multi-monitor scenarios, primary-secondary relationships, and
 * advanced display topology handling.
 *
 * FEATURES:
 * - Primary-secondary monitor relationships
 * - Cross-monitor window operations
 * - Display topology analysis
 * - Primary-based monitor ordering
 * - Multi-display synchronization
 * - Primary monitor role management
 * - Display configuration utilities
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/MonitorGetPrimary.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Advanced multi-monitor logic
 * - Primary monitor as reference point
 * - Complex coordinate calculations
 * - Multi-display state management
 * - Dynamic display adaptation
 *
 * LEARNING POINTS:
 * 1. Primary monitor serves as reference for multi-display setups
 * 2. Secondary monitors are numbered relative to primary
 * 3. Primary designation affects window placement logic
 * 4. Multi-display requires primary-aware algorithms
 * 5. Primary monitor anchors the virtual desktop
 * 6. Display topology centers on primary monitor
 * 7. Primary-secondary distinction affects user experience
 */

;=============================================================================
; EXAMPLE 1: Primary-Secondary Relationship Analyzer
;=============================================================================
; Analyzes spatial relationships between primary and secondary monitors
Example1_RelationshipAnalyzer() {
    MonCount := MonitorGetCount()
    PrimaryNum := MonitorGetPrimary()

    if MonCount < 2 {
        MsgBox("This example requires multiple monitors.", "Multi-Display Required", "Icon!")
        return
    }

    ; Create GUI
    g := Gui(, "Primary-Secondary Relationship Analyzer")
    g.SetFont("s9", "Consolas")

    g.Add("Text", "w700", "Analyzing relationships between Primary (#" PrimaryNum ") and Secondary monitors")

    ; Get primary monitor bounds
    MonitorGet(PrimaryNum, &PLeft, &PTop, &PRight, &PBottom)

    ; Analyze each secondary monitor
    report := "`nPrimary Monitor (#" PrimaryNum "): " (PRight-PLeft) "x" (PBottom-PTop) " at " PLeft "," PTop "`n"
    report .= "═══════════════════════════════════════════════════════════`n`n"

    Loop MonCount {
        if A_Index = PrimaryNum
            continue

        SecNum := A_Index
        MonitorGet(SecNum, &SLeft, &STop, &SRight, &SBottom)

        report .= "Secondary Monitor #" SecNum ":`n"
        report .= "  Resolution: " (SRight-SLeft) "x" (SBottom-STop) "`n"
        report .= "  Position: " SLeft "," STop "`n`n"

        ; Determine spatial relationship
        report .= "  Relationship to Primary:`n"

        ; Horizontal
        if SRight <= PLeft
            report .= "    • Located LEFT of primary`n"
        else if SLeft >= PRight
            report .= "    • Located RIGHT of primary`n"
        else
            report .= "    • Horizontally OVERLAPPING with primary`n"

        ; Vertical
        if SBottom <= PTop
            report .= "    • Located ABOVE primary`n"
        else if STop >= PBottom
            report .= "    • Located BELOW primary`n"
        else
            report .= "    • Vertically OVERLAPPING with primary`n"

        ; Check if adjacent (touching edges)
        adjacent := false
        if (SRight = PLeft || SLeft = PRight || SBottom = PTop || STop = PBottom) {
            report .= "    • ADJACENT (touching edges)`n"
            adjacent := true
        } else {
            report .= "    • NOT adjacent (gap exists)`n"
        }

        ; Calculate distance from primary center
        PCenterX := (PLeft + PRight) // 2
        PCenterY := (PTop + PBottom) // 2
        SCenterX := (SLeft + SRight) // 2
        SCenterY := (STop + SBottom) // 2

        distance := Round(Sqrt((SCenterX - PCenterX)**2 + (SCenterY - PCenterY)**2))
        report .= "    • Distance from primary: " distance " pixels`n"

        report .= "`n"
    }

    g.Add("Text", "xm w700 h400 +Border", report)

    g.Show()
}

;=============================================================================
; EXAMPLE 2: Primary-Centric Display Map
;=============================================================================
; Creates visual map with primary monitor highlighted
Example2_DisplayMap() {
    MonCount := MonitorGetCount()
    PrimaryNum := MonitorGetPrimary()

    ; Create GUI
    g := Gui(, "Primary-Centric Display Map")
    g.BackColor := "0x2B2B2B"

    g.Add("Text", "w750 cWhite Center", "Display Topology Map (Primary #" PrimaryNum " highlighted)")

    ; Calculate bounds
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
            Bottom: B,
            IsPrimary: (A_Index = PrimaryNum)
        })

        virtualLeft := Min(virtualLeft, L)
        virtualTop := Min(virtualTop, T)
        virtualRight := Max(virtualRight, R)
        virtualBottom := Max(virtualBottom, B)
    }

    ; Calculate scale
    virtualWidth := virtualRight - virtualLeft
    virtualHeight := virtualBottom - virtualTop
    scale := Min(700 / virtualWidth, 450 / virtualHeight)

    ; Draw monitors
    for mon in monitors {
        x := Round((mon.Left - virtualLeft) * scale) + 25
        y := Round((mon.Top - virtualTop) * scale) + 60
        w := Round((mon.Right - mon.Left) * scale)
        h := Round((mon.Bottom - mon.Top) * scale)

        ; Different colors for primary vs secondary
        if mon.IsPrimary {
            color := "0xFFD700"  ; Gold for primary
            borderColor := "0xFFA500"  ; Orange border
        } else {
            color := "0x4169E1"  ; Royal blue for secondary
            borderColor := "0x1E3A8A"  ; Dark blue border
        }

        ; Monitor rectangle
        g.Add("Progress", "x" x " y" y " w" w " h" h " Background" color " c" color, 100)

        ; Monitor label
        labelText := mon.IsPrimary ? "PRIMARY`n#" mon.Num : "Secondary`n#" mon.Num
        g.Add("Text", "x" (x + w//2 - 30) " y" (y + h//2 - 15) " w60 h30 +Center BackgroundTrans cBlack",
              labelText)

        ; Resolution
        resolution := (mon.Right - mon.Left) "x" (mon.Bottom - mon.Top)
        g.Add("Text", "x" (x + w//2 - 40) " y" (y + h - 20) " w80 h15 +Center BackgroundTrans cBlack",
              resolution)
    }

    ; Legend
    g.Add("Text", "x25 y+20 cWhite", "■ Gold = Primary Monitor   ■ Blue = Secondary Monitors")

    g.Show("w800 h" (Round(virtualHeight * scale) + 120))
}

;=============================================================================
; EXAMPLE 3: Secondary Monitor Manager
;=============================================================================
; Manages all secondary monitors relative to primary
Example3_SecondaryManager() {
    MonCount := MonitorGetCount()
    PrimaryNum := MonitorGetPrimary()

    if MonCount < 2 {
        MsgBox("No secondary monitors detected.", "Notice", "Icon!")
        return
    }

    ; Create GUI
    g := Gui(, "Secondary Monitor Manager")
    g.SetFont("s10")

    g.Add("Text", "w450", "Primary Monitor: #" PrimaryNum)
    g.Add("Text", "w450", "Secondary Monitors: " (MonCount - 1))

    ; List secondary monitors
    g.Add("Text", "xm Section", "Select Secondary Monitor:")

    secondaries := []
    Loop MonCount {
        if A_Index != PrimaryNum
            secondaries.Push(A_Index)
    }

    cmbSecondary := g.Add("ComboBox", "xs w150")
    for secNum in secondaries
        cmbSecondary.Add(["Monitor " secNum])
    cmbSecondary.Choose(1)

    ; Actions
    g.Add("Text", "xm Section", "Actions for Selected Secondary:")

    g.Add("Button", "xs w220", "Move Active Window Here").OnEvent("Click", MoveToSecondary)
    g.Add("Button", "x+10 w220", "Mirror from Primary").OnEvent("Click", MirrorFromPrimary)

    g.Add("Button", "xs w220", "Swap with Primary").OnEvent("Click", SwapWithPrimary)
    g.Add("Button", "x+10 w220", "Show Info").OnEvent("Click", ShowSecondaryInfo)

    txtStatus := g.Add("Text", "xs w450 h80 +Border")

    g.Show()

    MoveToSecondary(*) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd {
                txtStatus.Value := "No suitable window found"
                return
            }

            secNum := secondaries[cmbSecondary.Value]
            MonitorGetWorkArea(secNum, &Left, &Top, &Right, &Bottom)

            WinGetPos(, , &W, &H, WinID)
            X := Left + ((Right - Left - W) // 2)
            Y := Top + ((Bottom - Top - H) // 2)

            WinMove(X, Y, , , WinID)

            txtStatus.Value := "Moved window to Secondary Monitor #" secNum "`nPosition: " X "," Y
        }
    }

    MirrorFromPrimary(*) {
        secNum := secondaries[cmbSecondary.Value]

        txt := "Mirror Display Feature`n`n"
        txt .= "Would duplicate content from Primary #" PrimaryNum "`n"
        txt .= "to Secondary #" secNum "`n`n"
        txt .= "Note: Actual mirroring requires display settings"

        txtStatus.Value := txt
    }

    SwapWithPrimary(*) {
        secNum := secondaries[cmbSecondary.Value]

        txt := "Swap Display Feature`n`n"
        txt .= "Would swap roles between:`n"
        txt .= "  Primary: Monitor #" PrimaryNum "`n"
        txt .= "  Secondary: Monitor #" secNum "`n`n"
        txt .= "Note: Requires Windows display settings"

        txtStatus.Value := txt
    }

    ShowSecondaryInfo(*) {
        secNum := secondaries[cmbSecondary.Value]
        MonitorGet(secNum, &L, &T, &R, &B)
        MonitorGetWorkArea(secNum, &WL, &WT, &WR, &WB)

        info := "Secondary Monitor #" secNum " Information:`n`n"
        info .= "Resolution: " (R-L) "x" (B-T) "`n"
        info .= "Position: " L "," T "`n"
        info .= "Working Area: " (WR-WL) "x" (WB-WT) "`n"
        info .= "Distance from Primary: "

        ; Calculate distance
        MonitorGet(PrimaryNum, &PL, &PT, &PR, &PB)
        PCenterX := (PL + PR) // 2
        PCenterY := (PT + PB) // 2
        SCenterX := (L + R) // 2
        SCenterY := (T + B) // 2

        distance := Round(Sqrt((SCenterX - PCenterX)**2 + (SCenterY - PCenterY)**2))
        info .= distance " pixels"

        txtStatus.Value := info
    }
}

;=============================================================================
; EXAMPLE 4: Primary-Based Window Distribution
;=============================================================================
; Distributes windows prioritizing primary monitor
Example4_PrimaryDistribution() {
    MonCount := MonitorGetCount()
    PrimaryNum := MonitorGetPrimary()

    ; Create GUI
    g := Gui(, "Primary-Based Window Distribution")
    g.SetFont("s10")

    g.Add("Text", "w450", "Distribute windows with primary monitor priority")

    g.Add("Text", "xm Section", "Distribution Strategy:")

    strategies := [
        "Primary Heavy (70% primary, 30% secondary)",
        "Primary Moderate (50% primary, 50% secondary)",
        "Even Distribution",
        "Secondary Priority (30% primary, 70% secondary)"
    ]

    ddlStrategy := g.Add("DropDownList", "xs w350 Choose1", strategies)

    g.Add("Button", "xm w200", "Distribute Windows").OnEvent("Click", Distribute)

    txtResult := g.Add("Text", "xm w450 h150 +Border")

    g.Show()

    Distribute(*) {
        strategy := ddlStrategy.Value
        windowList := WinGetList(, , "Program Manager")

        ; Count valid windows
        validWindows := []
        for winID in windowList {
            if WinExist(winID)
                validWindows.Push(winID)
        }

        totalWins := validWindows.Length

        if totalWins = 0 {
            txtResult.Value := "No windows to distribute"
            return
        }

        ; Calculate distribution
        switch strategy {
            case 1:  ; Primary Heavy
                primaryCount := Ceil(totalWins * 0.7)

            case 2:  ; Primary Moderate
                primaryCount := Ceil(totalWins * 0.5)

            case 3:  ; Even
                primaryCount := Ceil(totalWins / MonCount)

            case 4:  ; Secondary Priority
                primaryCount := Ceil(totalWins * 0.3)
        }

        ; Distribute
        primaryAssigned := 0
        secondaryIndex := 0

        for winID in validWindows {
            if primaryAssigned < primaryCount {
                ; Assign to primary
                targetMon := PrimaryNum
                primaryAssigned++
            } else {
                ; Assign to secondary
                secondaries := []
                Loop MonCount {
                    if A_Index != PrimaryNum
                        secondaries.Push(A_Index)
                }

                targetMon := secondaries[Mod(secondaryIndex, secondaries.Length) + 1]
                secondaryIndex++
            }

            ; Position window
            MonitorGetWorkArea(targetMon, &Left, &Top, &Right, &Bottom)
            WinGetPos(, , &W, &H, winID)

            X := Left + ((Right - Left - W) // 2) + (Random(0, 40) - 20)
            Y := Top + ((Bottom - Top - H) // 2) + (Random(0, 40) - 20)

            WinMove(X, Y, , , winID)
        }

        result := "Distribution Complete`n`n"
        result .= "Strategy: " strategies[strategy] "`n"
        result .= "Total Windows: " totalWins "`n"
        result .= "On Primary #" PrimaryNum ": " primaryAssigned "`n"
        result .= "On Secondary: " (totalWins - primaryAssigned)

        txtResult.Value := result
    }
}

;=============================================================================
; EXAMPLE 5: Multi-Monitor Synchronizer
;=============================================================================
; Synchronizes operations across all monitors relative to primary
Example5_MultiMonitorSync() {
    PrimaryNum := MonitorGetPrimary()
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Multi-Monitor Synchronizer")
    g.SetFont("s10")

    g.Add("Text", "w400", "Synchronize operations across all monitors")
    g.Add("Text", "w400", "Primary: Monitor #" PrimaryNum)

    g.Add("Button", "xm w190", "Sync Window Sizes").OnEvent("Click", SyncSizes)
    g.Add("Button", "x+20 w190", "Sync Positions").OnEvent("Click", SyncPositions)

    g.Add("Button", "xm w190", "Create Test Windows").OnEvent("Click", CreateTestWindows)
    g.Add("Button", "x+20 w190", "Clear All").OnEvent("Click", ClearAll)

    txtLog := g.Add("Edit", "xm w400 h200 ReadOnly +Multi")

    testWindows := []

    g.Show()

    SyncSizes(*) {
        ; Make all windows same size as primary's test window
        if testWindows.Length = 0 {
            Log("No test windows to synchronize")
            return
        }

        primaryWin := testWindows[PrimaryNum]

        if !WinExist(primaryWin) {
            Log("Primary test window not found")
            return
        }

        WinGetPos(, , &RefW, &RefH, primaryWin)

        for monNum, winID in testWindows {
            if monNum = PrimaryNum || !WinExist(winID)
                continue

            WinGetPos(&X, &Y, , , winID)
            WinMove(X, Y, RefW, RefH, winID)
        }

        Log("Synchronized window sizes to " RefW "x" RefH " (from primary)")
    }

    SyncPositions(*) {
        ; Position all windows at same relative position on their monitors
        if testWindows.Length = 0 {
            Log("No test windows to synchronize")
            return
        }

        ; Get primary window's relative position
        primaryWin := testWindows[PrimaryNum]

        if !WinExist(primaryWin) {
            Log("Primary test window not found")
            return
        }

        WinGetPos(&WinX, &WinY, &WinW, &WinH, primaryWin)
        MonitorGet(PrimaryNum, &PLeft, &PTop, &PRight, &PBottom)

        ; Calculate relative position (percentage)
        relX := (WinX - PLeft) / (PRight - PLeft)
        relY := (WinY - PTop) / (PBottom - PTop)

        ; Apply to all monitors
        for monNum, winID in testWindows {
            if monNum = PrimaryNum || !WinExist(winID)
                continue

            MonitorGet(monNum, &Left, &Top, &Right, &Bottom)

            NewX := Left + Round((Right - Left) * relX)
            NewY := Top + Round((Bottom - Top) * relY)

            WinMove(NewX, NewY, , , winID)
        }

        Log("Synchronized positions (relative: " Round(relX*100) "%, " Round(relY*100) "%)")
    }

    CreateTestWindows(*) {
        testWindows := []

        Loop MonCount {
            monNum := A_Index
            MonitorGetWorkArea(monNum, &Left, &Top, &Right, &Bottom)

            isPrimary := (monNum = PrimaryNum)
            title := (isPrimary ? "PRIMARY " : "Secondary ") "Monitor #" monNum

            testWin := Gui("+AlwaysOnTop", title)
            testWin.BackColor := isPrimary ? "0xFFD700" : "0x4169E1"
            testWin.Add("Text", "w250 h100 +Center c0xFFFFFF", title "`n`nTest Window")

            X := Left + 50
            Y := Top + 50

            testWin.Show("x" X " y" Y " w300 h150 NA")
            testWindows.Push(testWin.Hwnd)
        }

        Log("Created " MonCount " test windows (1 per monitor)")
    }

    ClearAll(*) {
        for winID in testWindows {
            if WinExist(winID)
                WinClose(winID)
        }

        testWindows := []
        Log("Cleared all test windows")
    }

    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 6: Primary Monitor Role Manager
;=============================================================================
; Manages different roles/purposes for monitors based on primary
Example6_RoleManager() {
    PrimaryNum := MonitorGetPrimary()
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Primary Monitor Role Manager")
    g.SetFont("s10")

    g.Add("Text", "w500", "Assign roles to monitors based on primary monitor")

    ; Define default roles
    roles := Map()
    roles[PrimaryNum] := "Main Workspace"

    ; Assign secondary roles
    secondaryRoles := ["Reference/Documentation", "Communication", "Media/Preview", "Tools/Utilities"]
    roleIndex := 0

    Loop MonCount {
        if A_Index != PrimaryNum {
            roles[A_Index] := secondaryRoles[Mod(roleIndex, secondaryRoles.Length) + 1]
            roleIndex++
        }
    }

    ; Display roles
    g.Add("Text", "xm Section", "Current Monitor Roles:")

    lv := g.Add("ListView", "xs w500 h200", ["Monitor #", "Type", "Role", "Status"])

    Loop MonCount {
        monNum := A_Index
        type := (monNum = PrimaryNum) ? "Primary" : "Secondary"
        role := roles[monNum]
        status := "Active"

        lv.Add("", monNum, type, role, status)
    }

    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    ; Actions
    g.Add("Button", "xm w160", "Apply Layout").OnEvent("Click", ApplyLayout)
    g.Add("Button", "x+10 w160", "Show Assignment").OnEvent("Click", ShowAssignment)

    g.Show()

    ApplyLayout(*) {
        MsgBox("Role-based layout would organize windows according to assigned monitor roles.",
               "Apply Layout", "Icon!")
    }

    ShowAssignment(*) {
        info := "MONITOR ROLE ASSIGNMENTS`n"
        info .= "========================`n`n"

        for monNum, role in roles {
            type := (monNum = PrimaryNum) ? "[PRIMARY]" : "[Secondary]"
            MonitorGet(monNum, &L, &T, &R, &B)

            info .= "Monitor #" monNum " " type "`n"
            info .= "  Role: " role "`n"
            info .= "  Size: " (R-L) "x" (B-T) "`n`n"
        }

        MsgBox(info, "Role Assignments", "Icon!")
    }
}

;=============================================================================
; EXAMPLE 7: Display Configuration Exporter
;=============================================================================
; Exports multi-display configuration with primary information
Example7_ConfigurationExporter() {
    PrimaryNum := MonitorGetPrimary()
    MonCount := MonitorGetCount()

    ; Create GUI
    g := Gui(, "Display Configuration Exporter")
    g.SetFont("s9")

    g.Add("Text", "w500", "Export multi-monitor configuration")

    ; Generate configuration
    config := GenerateConfig()

    txtConfig := g.Add("Edit", "xm w600 h300 ReadOnly +Multi", config)

    g.Add("Button", "xm w140", "Copy to Clipboard").OnEvent("Click", CopyConfig)
    g.Add("Button", "x+10 w140", "Save to File").OnEvent("Click", SaveConfig)

    g.Show()

    GenerateConfig() {
        config := "MULTI-MONITOR CONFIGURATION EXPORT`n"
        config .= "===================================`n"
        config .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

        config .= "[SUMMARY]`n"
        config .= "Total Monitors: " MonCount "`n"
        config .= "Primary Monitor: " PrimaryNum "`n"
        config .= "Secondary Monitors: " (MonCount - 1) "`n`n"

        config .= "[PRIMARY MONITOR]`n"
        MonitorGet(PrimaryNum, &L, &T, &R, &B)
        config .= "Number=" PrimaryNum "`n"
        config .= "Left=" L "`n"
        config .= "Top=" T "`n"
        config .= "Right=" R "`n"
        config .= "Bottom=" B "`n"
        config .= "Width=" (R-L) "`n"
        config .= "Height=" (B-T) "`n`n"

        ; Secondary monitors
        Loop MonCount {
            if A_Index = PrimaryNum
                continue

            config .= "[SECONDARY MONITOR " A_Index "]`n"
            MonitorGet(A_Index, &L, &T, &R, &B)
            config .= "Number=" A_Index "`n"
            config .= "Left=" L "`n"
            config .= "Top=" T "`n"
            config .= "Right=" R "`n"
            config .= "Bottom=" B "`n"
            config .= "Width=" (R-L) "`n"
            config .= "Height=" (B-T) "`n`n"
        }

        return config
    }

    CopyConfig(*) {
        A_Clipboard := config
        MsgBox("Configuration copied to clipboard!", "Success", "Icon! T2")
    }

    SaveConfig(*) {
        fileName := "MonitorConfig_" FormatTime(, "yyyyMMdd_HHmmss") ".ini"
        try {
            FileAppend(config, A_Desktop "\" fileName)
            MsgBox("Configuration saved to:`n" A_Desktop "\" fileName, "Saved", "Icon!")
        } catch as err {
            MsgBox("Error saving file:`n" err.Message, "Error", "Iconx")
        }
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGetPrimary Multi-Display Examples")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()
    MonCount := MonitorGetCount()

    g.Add("Text", "w450", "Primary: Monitor #" PrimaryNum " of " MonCount)
    g.Add("Text", "w450", "Multi-Display Management Examples:")

    g.Add("Button", "w450", "Example 1: Relationship Analyzer").OnEvent("Click", (*) => Example1_RelationshipAnalyzer())
    g.Add("Button", "w450", "Example 2: Primary-Centric Display Map").OnEvent("Click", (*) => Example2_DisplayMap())
    g.Add("Button", "w450", "Example 3: Secondary Monitor Manager").OnEvent("Click", (*) => Example3_SecondaryManager())
    g.Add("Button", "w450", "Example 4: Primary-Based Distribution").OnEvent("Click", (*) => Example4_PrimaryDistribution())
    g.Add("Button", "w450", "Example 5: Multi-Monitor Synchronizer").OnEvent("Click", (*) => Example5_MultiMonitorSync())
    g.Add("Button", "w450", "Example 6: Role Manager").OnEvent("Click", (*) => Example6_RoleManager())
    g.Add("Button", "w450", "Example 7: Configuration Exporter").OnEvent("Click", (*) => Example7_ConfigurationExporter())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
