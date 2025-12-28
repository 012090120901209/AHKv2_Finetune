#Requires AutoHotkey v2.0

/**
 * BuiltIn_MonitorGetPrimary_02_Positioning.ahk
 * 
 * DESCRIPTION:
 * Advanced window positioning strategies based on the primary monitor.
 * Demonstrates intelligent placement, primary-first algorithms, and
 * primary-aware window management techniques.
 * 
 * FEATURES:
 * - Primary-first window placement
 * - Smart positioning algorithms
 * - Primary monitor snapping
 * - Default position strategies
 * - Primary-aware cascading
 * - Automatic primary detection
 * - Fallback positioning
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/MonitorGetPrimary.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Primary monitor detection for positioning
 * - Combined use of multiple monitor functions
 * - Dynamic window placement algorithms
 * - Smart fallback mechanisms
 * - Event-driven positioning
 * 
 * LEARNING POINTS:
 * 1. Primary monitor is ideal default placement location
 * 2. Users expect critical dialogs on primary monitor
 * 3. Primary positioning improves discoverability
 * 4. Always validate primary before positioning
 * 5. Consider taskbar when placing on primary
 * 6. Primary monitor often has highest visibility
 * 7. Fallback to primary when other monitors unavailable
 */

;=============================================================================
; EXAMPLE 1: Smart Primary Positioner
;=============================================================================
; Intelligently positions windows on the primary monitor with various strategies
Example1_SmartPositioner() {
    ; Create GUI
    g := Gui(, "Smart Primary Positioner")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w400", "Position active window on Primary Monitor (#" PrimaryNum ")")

    ; Position strategies
    strategies := [
        "Center",
        "Top-Left",
        "Top-Right",
        "Bottom-Left",
        "Bottom-Right",
        "Top-Center",
        "Bottom-Center",
        "Left-Center",
        "Right-Center"
    ]

    g.Add("Text", "xm Section", "Select Position Strategy:")

    for strategy in strategies {
        g.Add("Button", "xs w120", strategy).OnEvent("Click", Position.Bind(strategy))
        if Mod(A_Index, 3) = 0
            g.Add("Text", "xm", "")
    }

    txtStatus := g.Add("Text", "xm w400 h60 +Border")

    g.Show()

    Position(strategy, *) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd {
                txtStatus.Value := "No suitable window found"
                return
            }

            ; Get window size
            WinGetPos(, , &W, &H, WinID)

            ; Get primary monitor working area
            PrimaryNum := MonitorGetPrimary()
            MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

            MonWidth := Right - Left
            MonHeight := Bottom - Top

            ; Calculate position based on strategy
            switch strategy {
                case "Center":
                    X := Left + (MonWidth - W) // 2
                    Y := Top + (MonHeight - H) // 2

                case "Top-Left":
                    X := Left + 10
                    Y := Top + 10

                case "Top-Right":
                    X := Right - W - 10
                    Y := Top + 10

                case "Bottom-Left":
                    X := Left + 10
                    Y := Bottom - H - 10

                case "Bottom-Right":
                    X := Right - W - 10
                    Y := Bottom - H - 10

                case "Top-Center":
                    X := Left + (MonWidth - W) // 2
                    Y := Top + 10

                case "Bottom-Center":
                    X := Left + (MonWidth - W) // 2
                    Y := Bottom - H - 10

                case "Left-Center":
                    X := Left + 10
                    Y := Top + (MonHeight - H) // 2

                case "Right-Center":
                    X := Right - W - 10
                    Y := Top + (MonHeight - H) // 2
            }

            ; Move window
            WinMove(X, Y, , , WinID)

            txtStatus.Value := "Applied: " strategy "`nPosition: " X "," Y "`nMonitor: #" PrimaryNum
        }
    }
}

;=============================================================================
; EXAMPLE 2: Primary-First Multi-Window Manager
;=============================================================================
; Manages multiple windows with primary monitor priority
Example2_MultiWindowManager() {
    ; Create GUI
    g := Gui(, "Primary-First Multi-Window Manager")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w450", "Manages windows with primary monitor (#" PrimaryNum ") priority")

    g.Add("Button", "xm w220", "Stack All on Primary").OnEvent("Click", StackOnPrimary)
    g.Add("Button", "x+10 w220", "Distribute from Primary").OnEvent("Click", DistributeFromPrimary)

    g.Add("Button", "xm w220", "Move All to Primary").OnEvent("Click", MoveAllToPrimary)
    g.Add("Button", "x+10 w220", "Restore Positions").OnEvent("Click", RestorePositions)

    txtLog := g.Add("Edit", "xm w450 h200 ReadOnly +Multi")

    savedPositions := Map()

    g.Show()

    StackOnPrimary(*) {
        PrimaryNum := MonitorGetPrimary()
        MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

        windowList := WinGetList(, , "Program Manager")
        count := 0
        offset := 0

        Log("Stacking windows on Primary Monitor #" PrimaryNum "...")

        for winID in windowList {
            if !WinExist(winID)
                continue

            ; Size and position
            W := 800
            H := 600
            X := Left + 50 + offset
            Y := Top + 50 + offset

            WinMove(X, Y, W, H, winID)
            count++
            offset += 30

            ; Reset offset if getting too far
            if offset > 200
                offset := 0
        }

        Log("Stacked " count " windows on primary monitor")
    }

    DistributeFromPrimary(*) {
        MonCount := MonitorGetCount()
        PrimaryNum := MonitorGetPrimary()

        Log("Distributing windows starting from Primary #" PrimaryNum "...")

        windowList := WinGetList(, , "Program Manager")

        ; Start with primary, then cycle through others
        monitorOrder := [PrimaryNum]
        Loop MonCount {
            if A_Index != PrimaryNum
                monitorOrder.Push(A_Index)
        }

        monIndex := 1
        count := 0

        for winID in windowList {
            if !WinExist(winID)
                continue

            currentMon := monitorOrder[monIndex]
            MonitorGetWorkArea(currentMon, &Left, &Top, &Right, &Bottom)

            ; Center on monitor
            WinGetPos(, , &W, &H, winID)
            X := Left + ((Right - Left - W) // 2)
            Y := Top + ((Bottom - Top - H) // 2)

            WinMove(X, Y, , , winID)
            count++

            ; Next monitor
            monIndex++
            if monIndex > monitorOrder.Length
                monIndex := 1
        }

        Log("Distributed " count " windows across " MonCount " monitors (primary first)")
    }

    MoveAllToPrimary(*) {
        PrimaryNum := MonitorGetPrimary()
        MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

        windowList := WinGetList(, , "Program Manager")
        count := 0

        Log("Moving all windows to Primary Monitor #" PrimaryNum "...")

        ; Save current positions first
        savedPositions.Clear()

        for winID in windowList {
            if !WinExist(winID)
                continue

            ; Save current position
            WinGetPos(&X, &Y, &W, &H, winID)
            savedPositions[winID] := { X: X, Y: Y, W: W, H: H }

            ; Move to primary
            NewX := Left + ((Right - Left - W) // 2)
            NewY := Top + ((Bottom - Top - H) // 2)

            WinMove(NewX, NewY, , , winID)
            count++
        }

        Log("Moved " count " windows to primary monitor (positions saved)")
    }

    RestorePositions(*) {
        if savedPositions.Count = 0 {
            Log("No saved positions to restore")
            return
        }

        count := 0

        for winID, pos in savedPositions {
            if WinExist(winID) {
                WinMove(pos.X, pos.Y, pos.W, pos.H, winID)
                count++
            }
        }

        Log("Restored " count " windows to saved positions")
    }

    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)  ; Scroll to bottom
    }
}

;=============================================================================
; EXAMPLE 3: Primary Monitor Snapper
;=============================================================================
; Snaps windows to primary monitor edges
Example3_PrimarySnapper() {
    ; Create GUI
    g := Gui("+AlwaysOnTop", "Primary Monitor Snapper")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w300", "Snap to Primary Monitor (#" PrimaryNum ")")

    edges := [{
        Name: "Left Edge", Code: "L" }, {
            Name: "Right Edge", Code: "R" }, {
                Name: "Top Edge", Code: "T" }, {
                    Name: "Bottom Edge", Code: "B" }, {
                        Name: "Top-Left Corner", Code: "TL" }, {
                            Name: "Top-Right Corner", Code: "TR" }, {
                                Name: "Bottom-Left Corner", Code: "BL" }, {
                                    Name: "Bottom-Right Corner", Code: "BR"
                                }
    ]

    for edge in edges {
        g.Add("Button", "xm w140", edge.Name).OnEvent("Click", Snap.Bind(edge.Code))
        if Mod(A_Index, 2) = 0
            g.Add("Text", "xm", "")
    }

    g.Add("Text", "xm Section", "Snap Margin (px):")
    edtMargin := g.Add("Edit", "xs w60", "10")

    g.Show()

    Snap(edgeCode, *) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd
                return

            WinGetPos(, , &W, &H, WinID)

            PrimaryNum := MonitorGetPrimary()
            MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

            margin := Integer(edtMargin.Value)

            switch edgeCode {
                case "L":  ; Left edge
                    X := Left + margin
                    Y := Top + ((Bottom - Top - H) // 2)

                case "R":  ; Right edge
                    X := Right - W - margin
                    Y := Top + ((Bottom - Top - H) // 2)

                case "T":  ; Top edge
                    X := Left + ((Right - Left - W) // 2)
                    Y := Top + margin

                case "B":  ; Bottom edge
                    X := Left + ((Right - Left - W) // 2)
                    Y := Bottom - H - margin

                case "TL":  ; Top-Left
                    X := Left + margin
                    Y := Top + margin

                case "TR":  ; Top-Right
                    X := Right - W - margin
                    Y := Top + margin

                case "BL":  ; Bottom-Left
                    X := Left + margin
                    Y := Bottom - H - margin

                case "BR":  ; Bottom-Right
                    X := Right - W - margin
                    Y := Bottom - H - margin
            }

            WinMove(X, Y, , , WinID)
        }
    }
}

;=============================================================================
; EXAMPLE 4: Primary-Aware Dialog Positioner
;=============================================================================
; Ensures critical dialogs always appear on primary monitor
Example4_DialogPositioner() {
    ; Create demo GUI
    g := Gui(, "Primary-Aware Dialog System")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w400", "All dialogs will appear on Primary Monitor (#" PrimaryNum ")")

    g.Add("Button", "xm w190", "Show Info Dialog").OnEvent("Click", (*) => ShowDialog("Info"))
    g.Add("Button", "x+20 w190", "Show Warning Dialog").OnEvent("Click", (*) => ShowDialog("Warning"))
    g.Add("Button", "xm w190", "Show Error Dialog").OnEvent("Click", (*) => ShowDialog("Error"))
    g.Add("Button", "x+20 w190", "Show Question Dialog").OnEvent("Click", (*) => ShowDialog("Question"))

    txtLog := g.Add("Edit", "xm w400 h150 ReadOnly +Multi")

    g.Show()

    ShowDialog(type) {
        ; Create dialog on primary monitor
        PrimaryNum := MonitorGetPrimary()
        MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

        ; Calculate center position
        dialogW := 300
        dialogH := 150
        X := Left + ((Right - Left - dialogW) // 2)
        Y := Top + ((Bottom - Top - dialogH) // 2)

        ; Create dialog
        dialog := Gui("+Owner" g.Hwnd " +AlwaysOnTop", type " Dialog")
        dialog.SetFont("s10")

        switch type {
            case "Info":
                icon := "Icon!"
                msg := "This is an informational message"

            case "Warning":
                icon := "Icon!"
                msg := "This is a warning message"

            case "Error":
                icon := "Iconx"
                msg := "This is an error message"

            case "Question":
                icon := "Icon?"
                msg := "This is a question"
        }

        dialog.Add("Text", "w260", msg)
        dialog.Add("Text", "w260", "`nDialog positioned on Primary Monitor #" PrimaryNum)
        dialog.Add("Button", "w100 Default", "OK").OnEvent("Click", (*) => dialog.Destroy())

        dialog.Show("x" X " y" Y " w" dialogW " h" dialogH)

        Log(type " dialog shown on Primary Monitor at " X "," Y)
    }

    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 5: Automatic Primary Fallback
;=============================================================================
; Demonstrates fallback to primary when preferred monitor unavailable
Example5_AutoFallback() {
    ; Create GUI
    g := Gui(, "Automatic Primary Fallback")
    g.SetFont("s10")

    g.Add("Text", "w450", "Attempts preferred monitor, falls back to primary if unavailable")

    g.Add("Text", "xm Section", "Preferred Monitor:")
    edtPreferred := g.Add("Edit", "xs w60", "2")

    g.Add("Button", "xm w200", "Position with Fallback").OnEvent("Click", PositionWithFallback)

    txtLog := g.Add("Edit", "xm w450 h200 ReadOnly +Multi")

    g.Show()

    PositionWithFallback(*) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd {
                Log("No suitable window found")
                return
            }

            preferredMon := Integer(edtPreferred.Value)
            MonCount := MonitorGetCount()
            PrimaryNum := MonitorGetPrimary()

            Log("Attempting to position on Monitor #" preferredMon "...")

            ; Validate preferred monitor
            targetMon := preferredMon

            if preferredMon < 1 || preferredMon > MonCount {
                Log("  ✗ Monitor #" preferredMon " does not exist")
                Log("  → Falling back to Primary Monitor #" PrimaryNum)
                targetMon := PrimaryNum
            } else {
                Log("  ✓ Monitor #" preferredMon " is valid")
                targetMon := preferredMon
            }

            ; Position on target monitor
            MonitorGetWorkArea(targetMon, &Left, &Top, &Right, &Bottom)
            WinGetPos(, , &W, &H, WinID)

            X := Left + ((Right - Left - W) // 2)
            Y := Top + ((Bottom - Top - H) // 2)

            WinMove(X, Y, , , WinID)

            if targetMon = PrimaryNum && targetMon != preferredMon
                Log("  ✓ Window positioned on PRIMARY (fallback)")
            else
                Log("  ✓ Window positioned on Monitor #" targetMon)

            Log("  Position: " X "," Y)
        }
    }

    Log(msg) {
        txtLog.Value .= msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; EXAMPLE 6: Primary-Centric Tiling
;=============================================================================
; Tiles windows in a grid on the primary monitor
Example6_PrimaryCentricTiling() {
    ; Create GUI
    g := Gui(, "Primary-Centric Window Tiling")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w350", "Tile windows on Primary Monitor (#" PrimaryNum ")")

    g.Add("Text", "xm Section", "Grid Configuration:")

    g.Add("Text", "xs w80", "Columns:")
    edtCols := g.Add("Edit", "x+10 w60", "2")

    g.Add("Text", "xs w80", "Rows:")
    edtRows := g.Add("Edit", "x+10 w60", "2")

    g.Add("Text", "xs w80", "Gap (px):")
    edtGap := g.Add("Edit", "x+10 w60", "5")

    g.Add("Button", "xm w170", "Tile Windows").OnEvent("Click", TileWindows)
    g.Add("Button", "x+10 w170", "Tile Active Window Only").OnEvent("Click", TileActive)

    txtStatus := g.Add("Text", "xm w350 h60 +Border")

    g.Show()

    TileWindows(*) {
        cols := Integer(edtCols.Value)
        rows := Integer(edtRows.Value)
        gap := Integer(edtGap.Value)

        PrimaryNum := MonitorGetPrimary()
        MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

        MonWidth := Right - Left
        MonHeight := Bottom - Top

        cellWidth := (MonWidth - (cols + 1) * gap) // cols
        cellHeight := (MonHeight - (rows + 1) * gap) // rows

        windowList := WinGetList(, , "Program Manager")
        index := 0
        maxCells := cols * rows

        for winID in windowList {
            if !WinExist(winID) || index >= maxCells
                continue

            row := index // cols
            col := Mod(index, cols)

            X := Left + gap + (col * (cellWidth + gap))
            Y := Top + gap + (row * (cellHeight + gap))

            WinMove(X, Y, cellWidth, cellHeight, winID)
            index++
        }

        txtStatus.Value := "Tiled " index " windows on Primary Monitor`nGrid: " cols "x" rows
    }

    TileActive(*) {
        try {
            WinID := WinExist("A")
            if !WinID || WinID = g.Hwnd
                return

            cols := Integer(edtCols.Value)
            rows := Integer(edtRows.Value)
            gap := Integer(edtGap.Value)

            PrimaryNum := MonitorGetPrimary()
            MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

            MonWidth := Right - Left
            MonHeight := Bottom - Top

            cellWidth := (MonWidth - (cols + 1) * gap) // cols
            cellHeight := (MonHeight - (rows + 1) * gap) // rows

            X := Left + gap
            Y := Top + gap

            WinMove(X, Y, cellWidth, cellHeight, WinID)

            txtStatus.Value := "Active window tiled to top-left cell`nCell size: " cellWidth "x" cellHeight
        }
    }
}

;=============================================================================
; EXAMPLE 7: Primary Monitor Hotkey System
;=============================================================================
; Hotkey system for quick primary monitor positioning
Example7_HotkeySystem() {
    ; Create GUI
    g := Gui(, "Primary Monitor Hotkey System")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()

    g.Add("Text", "w400", "Hotkey System for Primary Monitor (#" PrimaryNum ")")

    g.Add("Text", "xm Section", "Active Hotkeys:")

    hotkeys := "
                                (
                                Win+Numpad5 - Center on Primary
                                Win+Numpad7 - Top-Left on Primary
                                Win+Numpad9 - Top-Right on Primary
                                Win+Numpad1 - Bottom-Left on Primary
                                Win+Numpad3 - Bottom-Right on Primary
                                )"

    g.Add("Text", "xs w400", hotkeys)

    chkEnabled := g.Add("Checkbox", "xm Checked", "Enable Hotkeys")
    chkEnabled.OnEvent("Click", ToggleHotkeys)

    txtStatus := g.Add("Text", "xm w400 h80 +Border")
    txtStatus.Value := "Hotkeys: ACTIVE`n`nPress Win+Numpad keys to position windows on Primary Monitor"

    ; Register hotkeys
    HotIfWinExist("ahk_id " g.Hwnd)
    Hotkey("#Numpad5", (*) => PositionOnPrimary("Center"), "On")
    Hotkey("#Numpad7", (*) => PositionOnPrimary("TL"), "On")
    Hotkey("#Numpad9", (*) => PositionOnPrimary("TR"), "On")
    Hotkey("#Numpad1", (*) => PositionOnPrimary("BL"), "On")
    Hotkey("#Numpad3", (*) => PositionOnPrimary("BR"), "On")
    HotIf()

    g.OnEvent("Close", (*) => Cleanup())
    g.Show()

    ToggleHotkeys(*) {
        state := chkEnabled.Value ? "On" : "Off"

        Hotkey("#Numpad5", state)
        Hotkey("#Numpad7", state)
        Hotkey("#Numpad9", state)
        Hotkey("#Numpad1", state)
        Hotkey("#Numpad3", state)

        txtStatus.Value := "Hotkeys: " (chkEnabled.Value ? "ACTIVE" : "DISABLED")
    }

    PositionOnPrimary(position) {
        try {
            WinID := WinGetActiveWindow()
            if !WinID || WinID = g.Hwnd
                return

            WinGetPos(, , &W, &H, WinID)

            PrimaryNum := MonitorGetPrimary()
            MonitorGetWorkArea(PrimaryNum, &Left, &Top, &Right, &Bottom)

            switch position {
                case "Center":
                    X := Left + ((Right - Left - W) // 2)
                    Y := Top + ((Bottom - Top - H) // 2)

                case "TL":
                    X := Left + 10
                    Y := Top + 10

                case "TR":
                    X := Right - W - 10
                    Y := Top + 10

                case "BL":
                    X := Left + 10
                    Y := Bottom - H - 10

                case "BR":
                    X := Right - W - 10
                    Y := Bottom - H - 10
            }

            WinMove(X, Y, , , WinID)
            txtStatus.Value := "Positioned: " position "`nOn Primary Monitor #" PrimaryNum
        }
    }

    Cleanup() {
        Hotkey("#Numpad5", "Off")
        Hotkey("#Numpad7", "Off")
        Hotkey("#Numpad9", "Off")
        Hotkey("#Numpad1", "Off")
        Hotkey("#Numpad3", "Off")
        g.Destroy()
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "MonitorGetPrimary Positioning Examples")
    g.SetFont("s10")

    PrimaryNum := MonitorGetPrimary()
    g.Add("Text", "w450", "Primary Monitor: #" PrimaryNum)
    g.Add("Text", "w450", "Window Positioning Examples:")

    g.Add("Button", "w450", "Example 1: Smart Primary Positioner").OnEvent("Click", (*) => Example1_SmartPositioner())
    g.Add("Button", "w450", "Example 2: Multi-Window Manager").OnEvent("Click", (*) => Example2_MultiWindowManager())
    g.Add("Button", "w450", "Example 3: Primary Monitor Snapper").OnEvent("Click", (*) => Example3_PrimarySnapper())
    g.Add("Button", "w450", "Example 4: Dialog Positioner").OnEvent("Click", (*) => Example4_DialogPositioner())
    g.Add("Button", "w450", "Example 5: Automatic Fallback").OnEvent("Click", (*) => Example5_AutoFallback())
    g.Add("Button", "w450", "Example 6: Primary-Centric Tiling").OnEvent("Click", (*) => Example6_PrimaryCentricTiling())
    g.Add("Button", "w450", "Example 7: Hotkey System").OnEvent("Click", (*) => Example7_HotkeySystem())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
