#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * BuiltIn_ControlClick_03 - Advanced Options and Options
 * ============================================================================
 * 
 * Demonstrates advanced ControlClick options including NA (NoActivate),
 * Pos positioning options, and complex clicking scenarios.
 * 
 * @description
 * ControlClick supports various options that modify its behavior:
 * - NA: Don't activate the window before clicking
 * - Pos: Use positioning relative to client area vs screen
 * - D/U: Hold down/release without clicking
 * 
 * Key Features:
 * - NoActivate (NA) option for true background automation
 * - Position mode options
 * - Down/Up button state control
 * - Complex multi-step clicking sequences
 * - Drag simulation using coordinates
 * 
 * @syntax ControlClick Control, WinTitle, WinText, WhichButton, ClickCount, Options
 * 
 * @author AutoHotkey Community
 * @version 1.0.0
 * @since 2024-01-16
 * 
 * @example
 * ; Click without activating window
 * ControlClick "Button1", "Notepad",,, 1, "NA"
 * 
 * @see https://www.autohotkey.com/docs/v2/lib/ControlClick.htm
 */

; ============================================================================
; Example 1: NoActivate (NA) Option
; ============================================================================

/**
 * @function Example1_NoActivate
 * @description Demonstrates the NA (NoActivate) option
 * Shows how to click without bringing window to foreground
 */
Example1_NoActivate() {
    MsgBox("Example 1: NoActivate Option`n`n" .
        "Click controls without activating the window.",
        "NoActivate Demo", "OK Icon!")

    ; Create target window
    targetGui := Gui(, "Target Window - NA Demo")
    targetGui.Add("Text", "w350", "This window will be clicked without activation:")

    clickCounter := 0
    statusText := targetGui.Add("Text", "w350 h80 y+20 Border",
        "Total clicks: 0`nWith NA: 0`nWithout NA: 0")

    btn1 := targetGui.Add("Button", "w350 y+20", "Test Button")
    btn1.OnEvent("Click", (*) => UpdateClick("button"))

    targetGui.Show("x50 y50")

    ; Create control window (always on top)
    controlGui := Gui("+AlwaysOnTop", "Control Panel - NA Demo")
    controlGui.Add("Text", "w350", "Use these buttons to test NA option:")

    ; Stats
    totalClicks := 0
    naClicks := 0
    normalClicks := 0

    controlGui.Add("Text", "w350 y+20 Background404040 cFFFFFF Center",
        "WITHOUT NA Option (Activates Window)")

    normalBtn := controlGui.Add("Button", "w350 y+10", "Click Target (Normal - Activates)")
    normalBtn.OnEvent("Click", (*) => ClickNormal())

    controlGui.Add("Text", "w350 y+20 Background004000 cFFFFFF Center",
        "WITH NA Option (No Activation)")

    naBtn := controlGui.Add("Button", "w350 y+10", "Click Target (NA - Background)")
    naBtn.OnEvent("Click", (*) => ClickNA())

    ; Multi-click test
    controlGui.Add("Text", "w350 y+20", "Rapid Testing:")

    rapidNormalBtn := controlGui.Add("Button", "w170 y+10", "10x Normal")
    rapidNormalBtn.OnEvent("Click", (*) => RapidClick(false))

    rapidNABtn := controlGui.Add("Button", "w170 x+10", "10x NA")
    rapidNABtn.OnEvent("Click", (*) => RapidClick(true))

    ; Window state display
    controlGui.Add("Text", "w350 y+20", "Active Window:")
    activeText := controlGui.Add("Text", "w350 h40 Border", "")
    SetTimer(UpdateActiveWindow, 250)

    closeBtn := controlGui.Add("Button", "w350 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => CloseAll())

    controlGui.Show("x450 y50")

    ; Update click counter in target
    UpdateClick(source) {
        totalClicks++
        statusText.Value := "Total clicks: " . totalClicks .
            "`nWith NA: " . naClicks .
            "`nWithout NA: " . normalClicks .
            "`nSource: " . source
    }

    ; Normal click (with activation)
    ClickNormal() {
        try {
            ControlClick("Button1", "Target Window - NA Demo")
            normalClicks++
            UpdateClick("Control Panel (Normal)")

            ToolTip("Normal click - Window activated!")
            SetTimer(() => ToolTip(), -1000)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    ; NA click (without activation)
    ClickNA() {
        try {
            ControlClick("Button1", "Target Window - NA Demo", , , , "NA")
            naClicks++
            UpdateClick("Control Panel (NA)")

            ToolTip("NA click - Window stayed in background!")
            SetTimer(() => ToolTip(), -1000)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Rapid clicking test
    RapidClick(useNA) {
        option := useNA ? "NA" : ""
        typeText := useNA ? "NA" : "Normal"

        MsgBox("Performing 10 rapid clicks (" . typeText . ")`n`n" .
            "Watch the target window to see if it activates!",
            "Rapid Click Test", "OK Icon! T2")

        Loop 10 {
            try {
                ControlClick("Button1", "Target Window - NA Demo", , , , option)

                if useNA
                    naClicks++
                else
                    normalClicks++

                Sleep(100)

            } catch Error as err {
                MsgBox("Error on click " . A_Index . ": " . err.Message, "Error", "OK IconX")
                return
            }
        }

        MsgBox("10 clicks completed (" . typeText . ")!", "Complete", "OK Icon!")
    }

    ; Update active window display
    UpdateActiveWindow() {
        try {
            activeWin := WinGetTitle("A")
            activeText.Value := "Currently Active: " . StrLen(activeWin) > 45 ?
                SubStr(activeWin, 1, 45) . "..." : activeWin
        } catch {
            activeText.Value := "No active window"
        }
    }

    ; Close all windows
    CloseAll() {
        if WinExist("Target Window - NA Demo")
            targetGui.Destroy()
        if WinExist("Control Panel - NA Demo")
            controlGui.Destroy()
    }

    MsgBox("NoActivate demo started!`n`n" .
        "Compare normal clicks vs NA clicks.`n" .
        "Notice how NA clicks don't activate the target window.",
        "Info", "OK Icon! T4")
}

; ============================================================================
; Example 2: Button Down and Up Options
; ============================================================================

/**
 * @function Example2_DownUpOptions
 * @description Demonstrates D (Down) and U (Up) options
 * Shows how to control button press and release separately
 */
Example2_DownUpOptions() {
    MsgBox("Example 2: Button Down/Up Options`n`n" .
        "Control button press and release separately.",
        "Down/Up Demo", "OK Icon!")

    ; Create demo GUI
    myGui := Gui("+AlwaysOnTop", "Down/Up Options Demo")
    myGui.Add("Text", "w400", "Test button press (Down) and release (Up) separately:")

    ; Button state display
    myGui.Add("Text", "w400 y+20", "Button State Monitor:")
    stateArea := myGui.Add("Edit", "w400 h100 ReadOnly", "")

    ; Test target
    myGui.Add("Text", "w400 y+20", "Test Target:")
    testBtn := myGui.Add("Button", "w400 h60", "Click Target")

    ; Track button state
    buttonDown := false
    pressTime := 0
    releaseTime := 0

    testBtn.OnEvent("Click", (*) => LogEvent("Button Clicked!"))

    ; Control buttons
    myGui.Add("Text", "w400 y+20", "Manual Control:")

    downBtn := myGui.Add("Button", "w190 y+10", "Press Down (D)")
    downBtn.OnEvent("Click", (*) => PressDown())

    upBtn := myGui.Add("Button", "w190 x+20", "Release Up (U)")
    upBtn.OnEvent("Click", (*) => ReleaseUp())

    ; Timed press
    myGui.Add("Text", "w400 y+20", "Timed Press:")

    press100Btn := myGui.Add("Button", "w125 y+10", "100ms Press")
    press100Btn.OnEvent("Click", (*) => TimedPress(100))

    press500Btn := myGui.Add("Button", "w125 x+10", "500ms Press")
    press500Btn.OnEvent("Click", (*) => TimedPress(500))

    press1000Btn := myGui.Add("Button", "w125 x+10", "1000ms Press")
    press1000Btn.OnEvent("Click", (*) => TimedPress(1000))

    ; Clear and close
    clearBtn := myGui.Add("Button", "w190 y+20", "Clear Log")
    clearBtn.OnEvent("Click", (*) => stateArea.Value := "")

    closeBtn := myGui.Add("Button", "w190 x+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Log event function
    LogEvent(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") . SubStr(A_TickCount, -2)
        stateArea.Value .= timestamp . " - " . msg . "`n"

        ; Auto-scroll
        SendMessage(0x115, 7, 0, stateArea.Hwnd)
    }

    ; Press down
    PressDown() {
        try {
            ControlClick("Button2", "Down/Up Options Demo", , , 1, "D")
            buttonDown := true
            pressTime := A_TickCount
            LogEvent("Button pressed DOWN (D option)")

            ToolTip("Button pressed - hold until UP")
            SetTimer(() => ToolTip(), -2000)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Release up
    ReleaseUp() {
        try {
            ControlClick("Button2", "Down/Up Options Demo", , , 1, "U")

            if buttonDown {
                releaseTime := A_TickCount
                duration := releaseTime - pressTime
                LogEvent("Button released UP (U option) - Duration: " . duration . "ms")
                buttonDown := false
            } else {
                LogEvent("Button released UP (was not pressed)")
            }

            ToolTip("Button released")
            SetTimer(() => ToolTip(), -1000)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Timed press (press and hold for specified duration)
    TimedPress(duration) {
        LogEvent("Starting " . duration . "ms timed press...")

        try {
            ; Press down
            ControlClick("Button2", "Down/Up Options Demo", , , 1, "D")
            LogEvent("  Button DOWN")

            ; Wait for duration
            Sleep(duration)

            ; Release up
            ControlClick("Button2", "Down/Up Options Demo", , , 1, "U")
            LogEvent("  Button UP after " . duration . "ms")

            LogEvent("✓ Timed press complete!")

        } catch Error as err {
            MsgBox("Error during timed press: " . err.Message, "Error", "OK IconX")
        }
    }

    MsgBox("Down/Up demo started!`n`n" .
        "Test manual and timed button press/release.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 3: Drag Simulation with Coordinates
; ============================================================================

/**
 * @function Example3_DragSimulation
 * @description Simulates dragging by combining Down/Up with coordinates
 * Shows how to perform drag operations on controls
 */
Example3_DragSimulation() {
    MsgBox("Example 3: Drag Simulation`n`n" .
        "Simulate drag operations using Down, move, and Up.",
        "Drag Simulation", "OK Icon!")

    ; Create GUI
    myGui := Gui("+AlwaysOnTop", "Drag Simulation Demo")
    myGui.Add("Text", "w450", "Drag visualization area (450x350):")

    ; Canvas for drag visualization
    canvas := myGui.Add("Edit", "w450 h350 y+10 ReadOnly Multi", "")

    ; Drag log
    myGui.Add("Text", "w450 y+10", "Drag Operations Log:")
    logArea := myGui.Add("Edit", "w450 h100 ReadOnly", "")

    ; Preset drags
    myGui.Add("Text", "w450 y+10", "Preset Drag Operations:")

    horizBtn := myGui.Add("Button", "w140 y+10", "Horizontal Drag")
    horizBtn.OnEvent("Click", (*) => DragHorizontal())

    vertBtn := myGui.Add("Button", "w140 x+10", "Vertical Drag")
    vertBtn.OnEvent("Click", (*) => DragVertical())

    diagBtn := myGui.Add("Button", "w140 x+10", "Diagonal Drag")
    diagBtn.OnEvent("Click", (*) => DragDiagonal())

    circleBtn := myGui.Add("Button", "w140 y+10", "Circle Pattern")
    circleBtn.OnEvent("Click", (*) => DragCircle())

    starBtn := myGui.Add("Button", "w140 x+10", "Star Pattern")
    starBtn.OnEvent("Click", (*) => DragStar())

    clearBtn := myGui.Add("Button", "w140 x+10", "Clear")
    clearBtn.OnEvent("Click", (*) => ClearCanvas())

    closeBtn := myGui.Add("Button", "w450 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    dragCount := 0

    ; Log drag operation
    LogDrag(operation) {
        dragCount++
        timestamp := FormatTime(, "HH:mm:ss")
        logArea.Value .= timestamp . " - Drag #" . dragCount . ": " . operation . "`n"
        SendMessage(0x115, 7, 0, logArea.Hwnd)
    }

    ; Perform drag from (x1,y1) to (x2,y2)
    PerformDrag(x1, y1, x2, y2, steps := 10) {
        try {
            ; Click down at start position
            ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1, "D X" . x1 . " Y" . y1)

            ; Move through intermediate positions
            Loop steps {
                progress := A_Index / steps
                x := Integer(x1 + (x2 - x1) * progress)
                y := Integer(y1 + (y2 - y1) * progress)

                ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1, "X" . x . " Y" . y)
                Sleep(20)
            }

            ; Release at end position
            ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1, "U X" . x2 . " Y" . y2)

            ; Visualize
            marker := Format("Drag: ({:d},{:d}) → ({:d},{:d})`n", x1, y1, x2, y2)
            canvas.Value .= marker

            return true

        } catch Error as err {
            MsgBox("Drag error: " . err.Message, "Error", "OK IconX")
            return false
        }
    }

    ; Horizontal drag
    DragHorizontal() {
        LogDrag("Horizontal (left to right)")
        PerformDrag(50, 175, 400, 175, 15)
    }

    ; Vertical drag
    DragVertical() {
        LogDrag("Vertical (top to bottom)")
        PerformDrag(225, 25, 225, 325, 15)
    }

    ; Diagonal drag
    DragDiagonal() {
        LogDrag("Diagonal")
        PerformDrag(50, 50, 400, 300, 20)
    }

    ; Circle pattern
    DragCircle() {
        LogDrag("Circle pattern")

        centerX := 225
        centerY := 175
        radius := 120

        ; Start at top of circle
        startX := centerX
        startY := centerY - radius

        ; Click down
        ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1,
            "D X" . startX . " Y" . startY)

        ; Draw circle
        numPoints := 36
        Loop numPoints {
            angle := (A_Index / numPoints) * 2 * 3.14159
            x := Integer(centerX + radius * Sin(angle))
            y := Integer(centerY - radius * Cos(angle))

            ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1,
                "X" . x . " Y" . y)
            Sleep(15)
        }

        ; Release
        ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1,
            "U X" . startX . " Y" . startY)

        canvas.Value .= "Circle: center(" . centerX . "," . centerY .
            ") radius=" . radius . "`n"
    }

    ; Star pattern
    DragStar() {
        LogDrag("Star pattern")

        centerX := 225
        centerY := 175
        outerRadius := 100
        innerRadius := 40
        numPoints := 5

        ; Calculate star points
        points := []
        Loop numPoints * 2 {
            angle := ((A_Index - 1) / (numPoints * 2)) * 2 * 3.14159 - 3.14159 / 2
            radius := (Mod(A_Index, 2) = 1) ? outerRadius : innerRadius

            points.Push({
                x: Integer(centerX + radius * Cos(angle)),
                y: Integer(centerY + radius * Sin(angle))
            })
        }

        ; Draw star
        if points.Length > 0 {
            ; Start at first point
            ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1,
                "D X" . points[1].x . " Y" . points[1].y)

            ; Connect all points
            for index, point in points {
                if index > 1 {
                    ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1,
                        "X" . point.x . " Y" . point.y)
                    Sleep(30)
                }
            }

            ; Close the star
            ControlClick("Edit1", "Drag Simulation Demo", , "Left", 1,
                "U X" . points[1].x . " Y" . points[1].y)

            canvas.Value .= "Star: " . numPoints . " points`n"
        }
    }

    ; Clear canvas
    ClearCanvas() {
        canvas.Value := ""
        logArea.Value := ""
        dragCount := 0
    }

    MsgBox("Drag simulation demo started!`n`n" .
        "Test various drag patterns using coordinate-based clicking.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 4: Position Mode Options
; ============================================================================

/**
 * @function Example4_PositionModes
 * @description Demonstrates different position modes for coordinates
 * Shows client vs screen coordinate systems
 */
Example4_PositionModes() {
    MsgBox("Example 4: Position Modes`n`n" .
        "Understand coordinate positioning modes.",
        "Position Modes", "OK Icon!")

    ; Create test GUI
    myGui := Gui("+AlwaysOnTop", "Position Mode Demo")
    myGui.Add("Text", "w400", "Position mode affects how coordinates are interpreted:")

    ; Info display
    infoText := myGui.Add("Edit", "w400 h120 y+10 ReadOnly Multi",
        "Client Mode (default): Coordinates relative to control`n" .
        "Screen Mode: Absolute screen coordinates`n`n" .
        "Most ControlClick operations use client-relative coordinates.")

    ; Test area
    myGui.Add("Text", "w400 y+10", "Test Area:")
    testArea := myGui.Add("Edit", "w400 h200 ReadOnly", "")

    ; Get position info
    myGui.Add("Text", "w400 y+10", "Control Position Info:")

    infoBtn := myGui.Add("Button", "w190 y+10", "Get Position Info")
    infoBtn.OnEvent("Click", (*) => GetPositionInfo())

    testClickBtn := myGui.Add("Button", "w190 x+20", "Test Click")
    testClickBtn.OnEvent("Click", (*) => TestClick())

    ; Results
    myGui.Add("Text", "w400 y+10", "Results:")
    resultArea := myGui.Add("Edit", "w400 h120 ReadOnly", "")

    closeBtn := myGui.Add("Button", "w400 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Get position information
    GetPositionInfo() {
        try {
            ; Get control position
            ControlGetPos(&x, &y, &w, &h, "Edit2", "Position Mode Demo")

            ; Get window position
            WinGetPos(&winX, &winY, &winW, &winH, "Position Mode Demo")

            info := "Control Position Information:`n`n"
            info .= "Control (Edit2):`n"
            info .= "  Client X, Y: " . x . ", " . y . "`n"
            info .= "  Width, Height: " . w . ", " . h . "`n`n"

            info .= "Window Position:`n"
            info .= "  Screen X, Y: " . winX . ", " . winY . "`n"
            info .= "  Width, Height: " . winW . ", " . winH . "`n`n"

            info .= "Control absolute screen position:`n"
            info .= "  Screen X: " . (winX + x) . "`n"
            info .= "  Screen Y: " . (winY + y)

            resultArea.Value := info

        } catch Error as err {
            resultArea.Value := "Error: " . err.Message
        }
    }

    ; Test click
    TestClick() {
        try {
            ; Click in center of test area using client coordinates
            ControlClick("Edit2", "Position Mode Demo", , "Left", 1, "X200 Y100")

            resultArea.Value := "✓ Clicked at client coordinates (200, 100)`n" .
                "This is relative to the control's top-left corner."

            ToolTip("Clicked at (200, 100) client coordinates")
            SetTimer(() => ToolTip(), -1500)

        } catch Error as err {
            resultArea.Value := "Error: " . err.Message
        }
    }

    MsgBox("Position mode demo started!`n`n" .
        "Explore coordinate positioning modes.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 5: Complex Multi-Step Automation
; ============================================================================

/**
 * @function Example5_ComplexAutomation
 * @description Demonstrates complex multi-step automation scenarios
 * Combines various ControlClick options for advanced automation
 */
Example5_ComplexAutomation() {
    MsgBox("Example 5: Complex Multi-Step Automation`n`n" .
        "Combine multiple ControlClick techniques.",
        "Complex Automation", "OK Icon!")

    ; Create application GUI
    appGui := Gui(, "Sample Application")
    appGui.Add("Text", "w400", "Login Form:")

    appGui.Add("Text", "w400 y+20", "Username:")
    usernameEdit := appGui.Add("Edit", "w400")

    appGui.Add("Text", "w400 y+10", "Password:")
    passwordEdit := appGui.Add("Edit", "w400 Password")

    appGui.Add("Text", "w400 y+10", "Remember me:")
    rememberChk := appGui.Add("CheckBox", "w400", "Remember my credentials")

    loginBtn := appGui.Add("Button", "w190 y+20", "Login")
    loginBtn.OnEvent("Click", (*) => ProcessLogin())

    cancelBtn := appGui.Add("Button", "w190 x+20", "Cancel")
    cancelBtn.OnEvent("Click", (*) => appGui.Destroy())

    statusBar := appGui.Add("Text", "w400 y+20 Border h60", "Status: Ready")

    appGui.Show("x50 y50")

    ; Create automation control
    ctrlGui := Gui("+AlwaysOnTop", "Automation Controller")
    ctrlGui.Add("Text", "w400", "Automated Login Test:")

    ; Automation scenarios
    ctrlGui.Add("Text", "w400 y+20", "Automation Scenarios:")

    scenario1Btn := ctrlGui.Add("Button", "w390 y+10",
        "Scenario 1: Fast Login (No Activation)")
    scenario1Btn.OnEvent("Click", (*) => Scenario1())

    scenario2Btn := ctrlGui.Add("Button", "w390 y+10",
        "Scenario 2: Step-by-Step Login (With Delays)")
    scenario2Btn.OnEvent("Click", (*) => Scenario2())

    scenario3Btn := ctrlGui.Add("Button", "w390 y+10",
        "Scenario 3: Multiple Login Attempts")
    scenario3Btn.OnEvent("Click", (*) => Scenario3())

    ; Execution log
    ctrlGui.Add("Text", "w400 y+20", "Execution Log:")
    logEdit := ctrlGui.Add("Edit", "w400 h200 ReadOnly", "")

    clearBtn := ctrlGui.Add("Button", "w190 y+20", "Clear Log")
    clearBtn.OnEvent("Click", (*) => logEdit.Value := "")

    closeBtn := ctrlGui.Add("Button", "w190 x+20", "Close All")
    closeBtn.OnEvent("Click", (*) => CloseAll())

    ctrlGui.Show("x500 y50")

    ; Log function
    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        logEdit.Value .= timestamp . " - " . msg . "`n"
        SendMessage(0x115, 7, 0, logEdit.Hwnd)
    }

    ; Process login (app handler)
    ProcessLogin() {
        username := usernameEdit.Value
        password := passwordEdit.Value
        remember := rememberChk.Value

        if (username = "" || password = "") {
            statusBar.Value := "Status: Error - Please fill all fields!"
            return
        }

        statusBar.Value := "Status: Logged in as " . username .
            (remember ? " (Remembered)" : "")

        MsgBox("Login successful!`n`nUsername: " . username,
            "Login", "OK Icon! T2")
    }

    ; Scenario 1: Fast login without activation
    Scenario1() {
        Log("Starting Scenario 1: Fast Login (NA)")

        try {
            winTitle := "Sample Application"

            ; Fill username (NA = no activation)
            Log("  Filling username...")
            ControlSetText("testuser", "Edit1", winTitle)
            Sleep(100)

            ; Fill password
            Log("  Filling password...")
            ControlSetText("password123", "Edit2", winTitle)
            Sleep(100)

            ; Check remember me
            Log("  Checking 'Remember me'...")
            ControlClick("Button1", winTitle, , , , "NA")
            Sleep(100)

            ; Click login
            Log("  Clicking Login button...")
            ControlClick("Button2", winTitle, , , , "NA")

            Log("✓ Scenario 1 complete (window not activated)")

        } catch Error as err {
            Log("✗ Error: " . err.Message)
        }
    }

    ; Scenario 2: Step-by-step with delays
    Scenario2() {
        Log("Starting Scenario 2: Step-by-Step Login")

        try {
            winTitle := "Sample Application"

            ; Clear fields first
            Log("  Clearing fields...")
            ControlSetText("", "Edit1", winTitle)
            ControlSetText("", "Edit2", winTitle)
            Sleep(200)

            ; Type username character by character
            Log("  Typing username...")
            username := "admin"
            Loop Parse username {
                ControlSend(A_LoopField, "Edit1", winTitle)
                Sleep(50)
            }
            Sleep(300)

            ; Type password
            Log("  Typing password...")
            password := "secret"
            Loop Parse password {
                ControlSend(A_LoopField, "Edit2", winTitle)
                Sleep(50)
            }
            Sleep(300)

            ; Click login
            Log("  Clicking Login...")
            ControlClick("Button2", winTitle)
            Sleep(200)

            Log("✓ Scenario 2 complete")

        } catch Error as err {
            Log("✗ Error: " . err.Message)
        }
    }

    ; Scenario 3: Multiple attempts
    Scenario3() {
        Log("Starting Scenario 3: Multiple Login Attempts")

        credentials := [{
            user: "user1", pass: "pass1" }, {
                user: "user2", pass: "pass2" }, {
                    user: "admin", pass: "admin123"
                }
        ]

        for index, cred in credentials {
            try {
                Log("  Attempt " . index . ": " . cred.user)

                winTitle := "Sample Application"

                ; Fill credentials
                ControlSetText(cred.user, "Edit1", winTitle)
                Sleep(100)
                ControlSetText(cred.pass, "Edit2", winTitle)
                Sleep(100)

                ; Click login
                ControlClick("Button2", winTitle, , , , "NA")
                Sleep(500)

                Log("    ✓ Attempt " . index . " submitted")

            } catch Error as err {
                Log("    ✗ Attempt " . index . " error: " . err.Message)
            }
        }

        Log("✓ Scenario 3 complete - " . credentials.Length . " attempts")
    }

    ; Close all windows
    CloseAll() {
        if WinExist("Sample Application")
            appGui.Destroy()
        if WinExist("Automation Controller")
            ctrlGui.Destroy()
    }

    MsgBox("Complex automation demo started!`n`n" .
        "Run different automation scenarios to see advanced techniques.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menuText := "
            (
            ControlClick Examples - Advanced Options
            =========================================

            1. NoActivate (NA) Option
            2. Button Down/Up Options (D/U)
            3. Drag Simulation
            4. Position Modes
            5. Complex Multi-Step Automation

            Select an example (1-5) or press Esc to exit
            )"

    choice := InputBox(menuText, "ControlClick Advanced Options", "w450 h280")

    if (choice.Result = "Cancel")
        return

    switch choice.Value {
        case "1": Example1_NoActivate()
        case "2": Example2_DownUpOptions()
        case "3": Example3_DragSimulation()
        case "4": Example4_PositionModes()
        case "5": Example5_ComplexAutomation()
        default:
            MsgBox("Invalid choice! Please select 1-5.", "Error", "OK IconX")
    }

    ; Show menu again
    SetTimer(() => ShowMainMenu(), -500)
}

; Start the demo
ShowMainMenu()
