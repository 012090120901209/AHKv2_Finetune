#Requires AutoHotkey v2.0

/**
 * BuiltIn_Gui_03.ahk - Window Sizing and Constraints
 *
 * This file demonstrates window sizing, constraints, and size management in AutoHotkey v2.
 * Topics covered:
 * - Fixed vs resizable windows
 * - Minimum and maximum size constraints
 * - Aspect ratio maintenance
 * - Dynamic resizing and size events
 * - Fullscreen and maximized states
 * - Size validation and control
 * - Responsive control sizing
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */

; =============================================================================
; Example 1: Fixed Size Window
; =============================================================================

/**
 * Creates a fixed-size window that cannot be resized
 * Useful for dialogs and forms with fixed layout
 */
Example1_FixedSize() {
    myGui := Gui("-Resize", "Fixed Size Window")
    myGui.BackColor := "White"

    myGui.Add("Text", "x20 y20 w360", "This window has a FIXED size")
    myGui.Add("Text", "x20 y45 w360", "Try to resize it - you can't!")
    myGui.Add("Text", "x20 y70 w360", "The -Resize option prevents resizing")

    ; Window info
    infoText := myGui.Add("Text", "x20 y110 w360 h80 Border", "Window Information:`n`nSize: 400x250`nResizable: No`nMaximize button: Disabled")

    ; Show window dimensions
    myGui.Add("Text", "x20 y205", "Fixed Width: 400 pixels")
    myGui.Add("Text", "x220 y205", "Fixed Height: 250 pixels")

    myGui.Add("Button", "x20 y230 w360", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w400 h280")
}

; =============================================================================
; Example 2: Resizable with Min/Max Constraints
; =============================================================================

/**
 * Window with minimum and maximum size constraints
 * Allows resizing within defined bounds
 */
Example2_SizeConstraints() {
    myGui := Gui("+Resize +MinSize300x200 +MaxSize800x600", "Size Constraints Demo")
    myGui.BackColor := "0xF0F8FF"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Resizable Window with Constraints")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y50 w560", "This window can be resized, but within limits:")
    myGui.Add("Text", "x20 y75 w560", "• Minimum Size: 300 x 200 pixels")
    myGui.Add("Text", "x20 y95 w560", "• Maximum Size: 800 x 600 pixels")
    myGui.Add("Text", "x20 y115 w560", "• Current Size: shown below")

    ; Size display
    sizeText := myGui.Add("Text", "x20 y150 w560 h60 Border BackgroundWhite", "")
    UpdateSizeDisplay()

    ; Size test buttons
    myGui.Add("Button", "x20 y225 w130", "Try Min Size").OnEvent("Click", (*) => myGui.Show("w300 h200"))
    myGui.Add("Button", "x160 y225 w130", "Try Medium").OnEvent("Click", (*) => myGui.Show("w500 h350"))
    myGui.Add("Button", "x300 y225 w130", "Try Max Size").OnEvent("Click", (*) => myGui.Show("w800 h600"))
    myGui.Add("Button", "x440 y225 w130", "Try Too Big!").OnEvent("Click", TryTooBig)

    TryTooBig(*) {
        ; This will be constrained to max size
        myGui.Show("w1000 h800")
        MsgBox("Tried to set size to 1000x800, but constrained to max 800x600!", "Constraint Test")
    }

    myGui.Add("Button", "x20 y265 w550", "Close").OnEvent("Click", (*) => myGui.Destroy())

    ; Update size display on resize
    myGui.OnEvent("Size", (*) => UpdateSizeDisplay())

    UpdateSizeDisplay(*) {
        myGui.GetPos(, , &w, &h)
        percentage := Format("{1:.1f}%", ((w - 300) / (800 - 300)) * 100)
        sizeText.Value := Format("Current Width: {1}px`nCurrent Height: {2}px`nSize Range: {3}", w, h, percentage)
    }

    myGui.Show("w600 h320")
}

; =============================================================================
; Example 3: Aspect Ratio Locked Resizing
; =============================================================================

/**
 * Maintains aspect ratio when resizing
 * Demonstrates manual size constraint enforcement
 */
Example3_AspectRatio() {
    myGui := Gui("+Resize", "Aspect Ratio Locked (16:9)")
    myGui.BackColor := "0x1C1C1C"

    ; Title
    myGui.SetFont("s12 Bold cWhite")
    myGui.Add("Text", "x20 y20 w560 Background0x1C1C1C", "16:9 Aspect Ratio Demo")
    myGui.SetFont("s9 Norm cWhite")
    myGui.Add("Text", "x20 y50 w560 Background0x1C1C1C", "This window maintains a 16:9 aspect ratio (like HD video)")

    ; Video preview placeholder
    videoArea := myGui.Add("Text", "x20 y85 w560 h315 Border Background0x000000 cWhite Center 0x200", "")
    myGui.SetFont("s14 cWhite")
    myGui.Add("Text", "x20 y220 w560 h60 Background0x000000 Center", "VIDEO PREVIEW AREA`n16:9 Aspect Ratio")

    ; Info display
    myGui.SetFont("s9 cWhite")
    infoText := myGui.Add("Text", "x20 y410 w560 Background0x1C1C1C", "")

    ; Handle resize to maintain aspect ratio
    aspectRatio := 16 / 9
    isResizing := false

    myGui.OnEvent("Size", MaintainAspectRatio)

    MaintainAspectRatio(thisGui, MinMax, Width, Height) {
        if (MinMax = -1 || isResizing)  ; Skip if minimized or already resizing
            return

        isResizing := true

        ; Calculate ideal dimensions
        idealWidth := Round(Height * aspectRatio)
        idealHeight := Round(Width / aspectRatio)

        ; Use the dimension that fits current size better
        if (Abs(idealWidth - Width) < Abs(idealHeight - Height)) {
            newWidth := idealWidth
            newHeight := Height
        } else {
            newWidth := Width
            newHeight := idealHeight
        }

        ; Enforce minimum size
        if (newWidth < 400) {
            newWidth := 400
            newHeight := Round(newWidth / aspectRatio)
        }

        ; Resize video area
        videoWidth := newWidth - 40
        videoHeight := Round(videoWidth / aspectRatio)
        videoArea.Move(20, 85, videoWidth, videoHeight)

        ; Update info
        infoText.Move(20, videoHeight + 105)
        infoText.Value := Format("Window: {1}x{2} | Video Area: {3}x{4} | Ratio: {5:.2f}:1",
            newWidth, newHeight, videoWidth, videoHeight, videoWidth / videoHeight)

        ; Resize window if needed
        thisGui.GetPos(, , &currentW, &currentH)
        if (Abs(currentW - newWidth) > 5 || Abs(currentH - newHeight) > 5) {
            thisGui.Show("w" newWidth " h" newHeight)
        }

        isResizing := false
    }

    myGui.Show("w600 h450")
}

; =============================================================================
; Example 4: Dynamic Size Events
; =============================================================================

/**
 * Responds to window size changes dynamically
 * Demonstrates size event handling and control adaptation
 */
Example4_SizeEvents() {
    myGui := Gui("+Resize", "Dynamic Size Events")
    myGui.BackColor := "White"

    myGui.Add("Text", "x20 y20 w560", "Resize the window to see events in action!")

    ; Event log
    logEdit := myGui.Add("Edit", "x20 y50 w560 h200 ReadOnly Multi", "Event Log:`n")

    ; Size categories display
    categoryText := myGui.Add("Text", "x20 y260 w560 h40 Border BackgroundYellow Center", "Size Category: Medium")
    categoryText.SetFont("s12 Bold")

    ; Size statistics
    statsText := myGui.Add("Text", "x20 y310 w560 h80 Border", "")

    ; Reset button
    myGui.Add("Button", "x20 y400 w560", "Clear Log").OnEvent("Click", (*) => logEdit.Value := "Event Log:`n")

    ; Statistics tracking
    resizeCount := 0
    minWidth := 9999
    maxWidth := 0
    minHeight := 9999
    maxHeight := 0

    myGui.OnEvent("Size", HandleSizeEvent)

    HandleSizeEvent(thisGui, MinMax, Width, Height) {
        resizeCount++

        ; Update statistics
        minWidth := Min(minWidth, Width)
        maxWidth := Max(maxWidth, Width)
        minHeight := Min(minHeight, Height)
        maxHeight := Max(maxHeight, Height)

        ; Log event
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        state := ""
        switch MinMax {
            case -1: state := "MINIMIZED"
            case 0: state := "NORMAL"
            case 1: state := "MAXIMIZED"
        }

        logEdit.Value .= Format("[{1}] {2} - Size: {3}x{4}`n", timestamp, state, Width, Height)

        ; Scroll to bottom
        ControlSend("{End}", logEdit)

        ; Determine size category
        category := ""
        bgColor := ""
        if (Width < 400) {
            category := "Extra Small"
            bgColor := "Red"
        } else if (Width < 600) {
            category := "Small"
            bgColor := "Orange"
        } else if (Width < 800) {
            category := "Medium"
            bgColor := "Yellow"
        } else if (Width < 1000) {
            category := "Large"
            bgColor := "Lime"
        } else {
            category := "Extra Large"
            bgColor := "Aqua"
        }

        categoryText.Value := "Size Category: " category
        categoryText.Opt("Background" bgColor)

        ; Update statistics
        statsText.Value := Format("Resize Count: {1}`nWidth Range: {2} - {3} px`nHeight Range: {4} - {5} px`nCurrent: {6}x{7} px",
            resizeCount, minWidth, maxWidth, minHeight, maxHeight, Width, Height)
    }

    myGui.Show("w600 h450")
}

; =============================================================================
; Example 5: Fullscreen Toggle
; =============================================================================

/**
 * Demonstrates fullscreen mode toggle
 * Shows borderless fullscreen window creation
 */
Example5_FullscreenToggle() {
    myGui := Gui(, "Fullscreen Toggle Demo")
    myGui.BackColor := "0x2C3E50"

    ; Content
    myGui.SetFont("s14 Bold cWhite")
    title := myGui.Add("Text", "x20 y20 w560 Background0x2C3E50", "Fullscreen Mode Demo")

    myGui.SetFont("s10 Norm cWhite")
    myGui.Add("Text", "x20 y60 w560 Background0x2C3E50", "Press F11 or click the button below to toggle fullscreen mode")
    myGui.Add("Text", "x20 y85 w560 Background0x2C3E50", "Press ESC to exit fullscreen")

    statusText := myGui.Add("Text", "x20 y120 w560 Background0x2C3E50", "Status: Windowed Mode")

    ; Fullscreen info
    infoText := myGui.Add("Edit", "x20 y160 w560 h200 ReadOnly Multi",
        "Fullscreen Features:`n`n" .
        "• Borderless window`n" .
        "• Covers entire screen`n" .
        "• No taskbar visible`n" .
        "• Always on top`n" .
        "• Quick toggle with F11 or ESC`n`n" .
        "Common uses:`n" .
        "• Video playback`n" .
        "• Gaming`n" .
        "• Presentations`n" .
        "• Kiosk mode")

    ; Toggle button
    toggleBtn := myGui.Add("Button", "x20 y370 w560 h40", "Enter Fullscreen (F11)")
    toggleBtn.SetFont("s11 Bold")
    toggleBtn.OnEvent("Click", (*) => ToggleFullscreen())

    isFullscreen := false
    savedPos := {x: 0, y: 0, w: 600, h: 450}

    ToggleFullscreen() {
        if (!isFullscreen) {
            ; Save current position and size
            myGui.GetPos(&savedPos.x, &savedPos.y, &savedPos.w, &savedPos.h)

            ; Get monitor size
            MonitorGet(1, &Left, &Top, &Right, &Bottom)
            width := Right - Left
            height := Bottom - Top

            ; Enter fullscreen
            myGui.Opt("-Caption +AlwaysOnTop")
            myGui.Show("x" Left " y" Top " w" width " h" height)

            statusText.Value := "Status: FULLSCREEN MODE (Press F11 or ESC to exit)"
            toggleBtn.Value := "Exit Fullscreen (F11)"
            isFullscreen := true
        } else {
            ; Exit fullscreen
            myGui.Opt("+Caption -AlwaysOnTop")
            myGui.Show("x" savedPos.x " y" savedPos.y " w" savedPos.w " h" savedPos.h)

            statusText.Value := "Status: Windowed Mode"
            toggleBtn.Value := "Enter Fullscreen (F11)"
            isFullscreen := false
        }
    }

    ; Hotkeys
    myGui.OnEvent("Escape", (*) => isFullscreen ? ToggleFullscreen() : myGui.Destroy())

    ; F11 hotkey
    HotIfWinActive("ahk_id " myGui.Hwnd)
    Hotkey("F11", (*) => ToggleFullscreen())
    HotIfWinActive()

    myGui.Show("w600 h450")
}

; =============================================================================
; Example 6: Size-Responsive Layout
; =============================================================================

/**
 * Layout that adapts based on window size
 * Demonstrates responsive design principles
 */
Example6_ResponsiveLayout() {
    myGui := Gui("+Resize +MinSize400x300", "Responsive Layout Demo")
    myGui.BackColor := "White"

    ; Header
    header := myGui.Add("Text", "x0 y0 w600 h50 Background0x3498DB cWhite Center 0x200", "")
    myGui.SetFont("s14 Bold cWhite")
    headerText := myGui.Add("Text", "x0 y15 w600 Background0x3498DB Center", "Responsive Layout")

    ; Content areas
    myGui.SetFont("s9 Norm c000000")
    sidebar := myGui.Add("Edit", "x10 y60 w180 h340 Multi ReadOnly", "Sidebar`n`nThis sidebar shows/hides based on window width.`n`nNarrow window: Hidden`nWide window: Visible")
    mainContent := myGui.Add("Edit", "x200 y60 w390 h340 Multi ReadOnly", "Main Content Area`n`nThis area adjusts its width based on window size and sidebar visibility.")

    ; Status bar
    statusBar := myGui.Add("Text", "x0 y410 w600 h30 Background0xECF0F1 Border", "")

    myGui.OnEvent("Size", AdaptLayout)

    AdaptLayout(thisGui, MinMax, Width, Height) {
        if (MinMax = -1)  ; Minimized
            return

        ; Update header
        header.Move(0, 0, Width)
        headerText.Move(0, 15, Width)

        ; Determine layout based on width
        if (Width < 600) {
            ; Narrow layout - hide sidebar
            sidebar.Visible := false
            mainContent.Move(10, 60, Width - 20, Height - 100)
            statusBar.Value := Format("  Layout: COMPACT (Width: {1}px) - Sidebar hidden", Width)
        } else if (Width < 900) {
            ; Medium layout - small sidebar
            sidebar.Visible := true
            sidebar.Move(10, 60, 150, Height - 100)
            mainContent.Move(170, 60, Width - 180, Height - 100)
            statusBar.Value := Format("  Layout: NORMAL (Width: {1}px) - Sidebar visible", Width)
        } else {
            ; Wide layout - large sidebar
            sidebar.Visible := true
            sidebar.Move(10, 60, 220, Height - 100)
            mainContent.Move(240, 60, Width - 250, Height - 100)
            statusBar.Value := Format("  Layout: WIDE (Width: {1}px) - Extended sidebar", Width)
        }

        ; Update status bar
        statusBar.Move(0, Height - 30, Width)
    }

    myGui.Show("w600 h450")
}

; =============================================================================
; Example 7: Multi-Monitor Size Management
; =============================================================================

/**
 * Handles window sizing across multiple monitors
 * Demonstrates monitor-aware sizing
 */
Example7_MultiMonitor() {
    myGui := Gui("+Resize", "Multi-Monitor Size Management")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Multi-Monitor Window Management")
    myGui.SetFont("s9 Norm")

    ; Detect monitors
    monitorCount := SysGet(80)  ; SM_CMONITORS
    myGui.Add("Text", "x20 y50 w560", "Detected Monitors: " monitorCount)

    ; Monitor info display
    monitorInfo := myGui.Add("Edit", "x20 y80 w560 h150 ReadOnly Multi", "")

    ; Display monitor information
    infoText := "Monitor Information:`n`n"
    Loop monitorCount {
        MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
        MonitorGetWorkArea(A_Index, &WLeft, &WTop, &WRight, &WBottom)

        width := Right - Left
        height := Bottom - Top
        workWidth := WRight - WLeft
        workHeight := WBottom - WTop

        infoText .= Format("Monitor {1}:`n", A_Index)
        infoText .= Format("  Size: {1}x{2}`n", width, height)
        infoText .= Format("  Work Area: {1}x{2}`n", workWidth, workHeight)
        infoText .= Format("  Position: ({1}, {2})`n`n", Left, Top)
    }
    monitorInfo.Value := infoText

    ; Position buttons
    if (monitorCount >= 2) {
        myGui.Add("Button", "x20 y240 w180", "Move to Monitor 1").OnEvent("Click", (*) => MoveToMonitor(1))
        myGui.Add("Button", "x210 y240 w180", "Move to Monitor 2").OnEvent("Click", (*) => MoveToMonitor(2))
    }

    if (monitorCount >= 3) {
        myGui.Add("Button", "x400 y240 w180", "Move to Monitor 3").OnEvent("Click", (*) => MoveToMonitor(3))
    }

    ; Size buttons
    myGui.Add("Button", "x20 y280 w180", "Fill Monitor").OnEvent("Click", (*) => FillMonitor())
    myGui.Add("Button", "x210 y280 w180", "Center on Monitor").OnEvent("Click", (*) => CenterOnMonitor())
    myGui.Add("Button", "x400 y280 w180", "Half Width").OnEvent("Click", (*) => HalfWidth())

    ; Current position info
    posInfo := myGui.Add("Text", "x20 y320 w560 h40 Border", "")
    UpdatePositionInfo()

    myGui.OnEvent("Move", (*) => UpdatePositionInfo())
    myGui.OnEvent("Size", (*) => UpdatePositionInfo())

    MoveToMonitor(monitorNum) {
        if (monitorNum > monitorCount) {
            MsgBox("Monitor " monitorNum " not detected!", "Error")
            return
        }

        MonitorGet(monitorNum, &Left, &Top, &Right, &Bottom)
        width := Right - Left
        height := Bottom - Top

        ; Center window on selected monitor
        myGui.GetPos(, , &winW, &winH)
        newX := Left + (width - winW) // 2
        newY := Top + (height - winH) // 2

        myGui.Show("x" newX " y" newY)
    }

    FillMonitor() {
        ; Get current monitor
        myGui.GetPos(&winX, &winY)
        currentMon := 1

        Loop monitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (winX >= Left && winX < Right && winY >= Top && winY < Bottom) {
                currentMon := A_Index
                break
            }
        }

        MonitorGetWorkArea(currentMon, &WLeft, &WTop, &WRight, &WBottom)
        myGui.Show("x" WLeft " y" WTop " w" (WRight - WLeft) " h" (WBottom - WTop))
    }

    CenterOnMonitor() {
        myGui.GetPos(&winX, &winY, &winW, &winH)
        currentMon := 1

        Loop monitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (winX >= Left && winX < Right && winY >= Top && winY < Bottom) {
                currentMon := A_Index
                break
            }
        }

        MonitorGet(currentMon, &Left, &Top, &Right, &Bottom)
        width := Right - Left
        height := Bottom - Top

        newX := Left + (width - winW) // 2
        newY := Top + (height - winH) // 2
        myGui.Show("x" newX " y" newY)
    }

    HalfWidth() {
        myGui.GetPos(&winX, &winY, &winW, &winH)
        currentMon := 1

        Loop monitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (winX >= Left && winX < Right && winY >= Top && winY < Bottom) {
                currentMon := A_Index
                break
            }
        }

        MonitorGet(currentMon, &Left, &Top, &Right, &Bottom)
        width := (Right - Left) // 2

        myGui.Show("w" width)
    }

    UpdatePositionInfo() {
        myGui.GetPos(&x, &y, &w, &h)

        ; Determine which monitor
        currentMon := 1
        Loop monitorCount {
            MonitorGet(A_Index, &Left, &Top, &Right, &Bottom)
            if (x >= Left && x < Right && y >= Top && y < Bottom) {
                currentMon := A_Index
                break
            }
        }

        posInfo.Value := Format("Current Monitor: {1} | Position: ({2}, {3}) | Size: {4}x{5}",
            currentMon, x, y, w, h)
    }

    myGui.Show("w600 h380")
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_Gui_03 - Window Sizing Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Window Sizing and Constraints Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    ; Example buttons
    menuGui.Add("Button", "x20 y80 w360", "Example 1: Fixed Size Window").OnEvent("Click", (*) => Example1_FixedSize())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Size Constraints").OnEvent("Click", (*) => Example2_SizeConstraints())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Aspect Ratio Locked").OnEvent("Click", (*) => Example3_AspectRatio())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Dynamic Size Events").OnEvent("Click", (*) => Example4_SizeEvents())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Fullscreen Toggle").OnEvent("Click", (*) => Example5_FullscreenToggle())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Responsive Layout").OnEvent("Click", (*) => Example6_ResponsiveLayout())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Multi-Monitor Management").OnEvent("Click", (*) => Example7_MultiMonitor())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
