#Requires AutoHotkey v2.0

/**
 * BuiltIn_Gui_02.ahk - GUI Layouts and Positioning
 * 
 * This file demonstrates layout techniques and control positioning in AutoHotkey v2.
 * Topics covered:
 * - Absolute vs relative positioning
 * - Grid layouts and alignment
 * - Anchoring and docking controls
 * - Dynamic layout adjustments
 * - Section-based layouts
 * - Margin and padding management
 * - Responsive design patterns
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */

; =============================================================================
; Example 1: Absolute Positioning
; =============================================================================

/**
 * Demonstrates absolute positioning of controls
 * Each control has explicit x, y coordinates
 */
Example1_AbsolutePositioning() {
    myGui := Gui(, "Absolute Positioning Example")
    myGui.BackColor := "White"

    myGui.Add("Text", "x20 y20", "Absolute Positioning Demo")
    myGui.Add("Text", "x20 y50", "Each control has explicit coordinates")

    ; Form layout with absolute positioning
    myGui.Add("Text", "x20 y90", "First Name:")
    myGui.Add("Edit", "x120 y87 w200", "John")

    myGui.Add("Text", "x20 y120", "Last Name:")
    myGui.Add("Edit", "x120 y117 w200", "Doe")

    myGui.Add("Text", "x20 y150", "Email:")
    myGui.Add("Edit", "x120 y147 w200", "john.doe@example.com")

    myGui.Add("Text", "x20 y180", "Phone:")
    myGui.Add("Edit", "x120 y177 w200", "(555) 123-4567")

    myGui.Add("Text", "x20 y210", "Address:")
    myGui.Add("Edit", "x120 y207 w200 h60 Multi", "123 Main Street`nAnytown, ST 12345")

    ; Buttons with absolute positioning
    myGui.Add("Button", "x120 y290 w95", "Submit").OnEvent("Click", (*) => MsgBox("Form submitted!", "Success"))
    myGui.Add("Button", "x225 y290 w95", "Cancel").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w360 h340")
}

; =============================================================================
; Example 2: Relative Positioning
; =============================================================================

/**
 * Demonstrates relative positioning using section markers
 * Controls positioned relative to previous control
 */
Example2_RelativePositioning() {
    myGui := Gui(, "Relative Positioning Example")
    myGui.BackColor := "0xF0F8FF"
    myGui.MarginX := 20
    myGui.MarginY := 20

    ; Title (starts a new section)
    myGui.Add("Text", "xs Section", "Relative Positioning Demo")
    myGui.Add("Text", "xs", "Controls use relative positioning (xs, ys, xp, yp)")

    ; Form with relative positioning
    myGui.Add("Text", "xs y+20 Section", "First Name:")
    myGui.Add("Edit", "x+10 yp w200", "Jane")

    myGui.Add("Text", "xs y+10 Section", "Last Name:")
    myGui.Add("Edit", "x+10 yp w200", "Smith")

    myGui.Add("Text", "xs y+10 Section", "Email:")
    myGui.Add("Edit", "x+10 yp w200", "jane.smith@example.com")

    myGui.Add("Text", "xs y+10 Section", "Department:")
    deptDDL := myGui.Add("DropDownList", "x+10 yp w200", ["Engineering", "Sales", "Marketing", "HR"])
    deptDDL.Choose(1)

    myGui.Add("Text", "xs y+10 Section", "Start Date:")
    myGui.Add("DateTime", "x+10 yp w200", "LongDate")

    ; Checkbox group
    myGui.Add("Text", "xs y+20", "Notifications:")
    myGui.Add("Checkbox", "xs y+5", "Email notifications")
    myGui.Add("Checkbox", "xs y+5", "SMS notifications")
    myGui.Add("Checkbox", "xs y+5", "Push notifications")

    ; Buttons
    myGui.Add("Button", "xs y+20 w95", "Save").OnEvent("Click", (*) => MsgBox("Saved!", "Success"))
    myGui.Add("Button", "x+10 yp w95", "Cancel").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; =============================================================================
; Example 3: Grid Layout
; =============================================================================

/**
 * Creates a grid-based layout
 * Demonstrates structured multi-column layouts
 */
Example3_GridLayout() {
    myGui := Gui(, "Grid Layout Example")
    myGui.BackColor := "White"

    myGui.Add("Text", "x20 y20 w460", "Grid Layout - Calculator Style")

    ; Display
    display := myGui.Add("Edit", "x20 y50 w460 h40 ReadOnly Right")
    display.SetFont("s16")
    display.Value := "0"

    ; Grid dimensions
    startX := 20
    startY := 100
    btnWidth := 110
    btnHeight := 60
    spacing := 10

    ; Button labels in grid format
    buttons := [
        ["7", "8", "9", "/"],
        ["4", "5", "6", "*"],
        ["1", "2", "3", "-"],
        ["0", ".", "=", "+"]
    ]

    ; Create grid of buttons
    for rowIndex, row in buttons {
        for colIndex, label in row {
            x := startX + (colIndex - 1) * (btnWidth + spacing)
            y := startY + (rowIndex - 1) * (btnHeight + spacing)

            btn := myGui.Add("Button", Format("x{1} y{2} w{3} h{4}", x, y, btnWidth, btnHeight), label)
            btn.SetFont("s14 Bold")
            btn.OnEvent("Click", (*) => HandleButtonClick(label))
        }
    }

    ; Clear button
    clearBtn := myGui.Add("Button", "x20 y+10 w460 h40", "Clear")
    clearBtn.SetFont("s12")
    clearBtn.OnEvent("Click", (*) => display.Value := "0")

    ; Calculator logic
    currentValue := "0"
    operator := ""
    previousValue := 0

    HandleButtonClick(label) {
        if (label >= "0" && label <= "9" || label = ".") {
            ; Number or decimal point
            if (currentValue = "0" || operator != "")
                currentValue := label
            else
                currentValue .= label
            operator := ""
        } else if (label = "+" || label = "-" || label = "*" || label = "/") {
            ; Operator
            previousValue := Float(currentValue)
            operator := label
            currentValue := "0"
        } else if (label = "=") {
            ; Calculate
            if (operator != "") {
                switch operator {
                    case "+": currentValue := String(previousValue + Float(currentValue))
                    case "-": currentValue := String(previousValue - Float(currentValue))
                    case "*": currentValue := String(previousValue * Float(currentValue))
                    case "/": currentValue := Float(currentValue) != 0 ? String(previousValue / Float(currentValue)) : "Error"
                }
                operator := ""
            }
        }
        display.Value := currentValue
    }

    myGui.Show("w500 h450")
}

; =============================================================================
; Example 4: Anchored Layout (Resizable)
; =============================================================================

/**
 * Demonstrates anchored controls that resize with window
 * Controls maintain relative positions when window resizes
 */
Example4_AnchoredLayout() {
    myGui := Gui("+Resize", "Anchored Layout Example")
    myGui.BackColor := "0xF5F5F5"

    ; Header (anchored to top, stretches horizontally)
    header := myGui.Add("Text", "x10 y10 w580 h40 Center 0x200 BackgroundWhite", "Header - Anchored Top + Left + Right")
    header.SetFont("s12 Bold")

    ; Left panel (anchored to left, stretches vertically)
    leftPanel := myGui.Add("ListBox", "x10 y60 w180 h330", ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"])
    myGui.Add("Text", "x10 y395 w180", "Left Panel - Anchored Left + Top + Bottom")

    ; Right panel (anchored to right, stretches vertically)
    rightPanel := myGui.Add("Edit", "x410 y60 w180 h330 Multi ReadOnly", "Right Panel`n`nAnchored:`nRight + Top + Bottom`n`nThis panel maintains its width but stretches vertically.")
    myGui.Add("Text", "x410 y395 w180", "Right Panel Info")

    ; Center panel (anchored all sides, stretches both directions)
    centerPanel := myGui.Add("Edit", "x200 y60 w200 h280 Multi", "Center Panel`n`nAnchored to all four sides.`n`nResizes both horizontally and vertically with the window.")

    ; Bottom buttons (anchored to bottom)
    btnOK := myGui.Add("Button", "x200 y350 w95", "OK")
    btnCancel := myGui.Add("Button", "x305 y350 w95", "Cancel")
    btnCancel.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Add("Text", "x200 y395 w200 Center", "Buttons - Anchored Bottom + Left")

    ; Handle resize events
    myGui.OnEvent("Size", ResizeControls)

    ResizeControls(thisGui, MinMax, Width, Height) {
        if (MinMax = -1)  ; Minimized
            return

        ; Calculate new dimensions
        margin := 10
        headerHeight := 40
        footerHeight := 60
        leftWidth := 180
        rightWidth := 180

        ; Resize header (stretch horizontally)
        header.Move(margin, margin, Width - 2 * margin)

        ; Resize left panel (stretch vertically)
        leftPanel.Move(margin, headerHeight + margin, , Height - headerHeight - footerHeight - 2 * margin)

        ; Resize right panel (stretch vertically, stay anchored to right)
        rightX := Width - rightWidth - margin
        rightPanel.Move(rightX, headerHeight + margin, , Height - headerHeight - footerHeight - 2 * margin)

        ; Resize center panel (stretch both directions)
        centerWidth := Width - leftWidth - rightWidth - 4 * margin
        centerHeight := Height - headerHeight - footerHeight - 2 * margin - 50
        centerPanel.Move(leftWidth + 2 * margin, headerHeight + margin, centerWidth, centerHeight)

        ; Position bottom buttons
        btnY := Height - footerHeight
        btnOK.Move(leftWidth + 2 * margin, btnY)
        btnCancel.Move(leftWidth + 2 * margin + 105, btnY)
    }

    myGui.Show("w600 h420")
}

; =============================================================================
; Example 5: Section-Based Layout
; =============================================================================

/**
 * Demonstrates section markers for complex layouts
 * Uses xs, ys, xp, yp, section markers
 */
Example5_SectionLayout() {
    myGui := Gui(, "Section-Based Layout")
    myGui.BackColor := "White"
    myGui.MarginX := 20
    myGui.MarginY := 20

    ; Main title
    myGui.SetFont("s12 Bold")
    myGui.Add("Text", "Section", "User Registration Form")
    myGui.SetFont("s9 Norm")

    ; Personal Information Section
    myGui.Add("GroupBox", "xs y+10 w350 h140 Section", "Personal Information")
    myGui.Add("Text", "xs+10 ys+25", "First Name:")
    myGui.Add("Edit", "x+10 yp-3 w200")

    myGui.Add("Text", "xs+10 y+10", "Last Name:")
    myGui.Add("Edit", "x+10 yp-3 w200")

    myGui.Add("Text", "xs+10 y+10", "Date of Birth:")
    myGui.Add("DateTime", "x+10 yp-3 w200")

    ; Contact Information Section
    myGui.Add("GroupBox", "xs y+20 w350 h110 Section", "Contact Information")
    myGui.Add("Text", "xs+10 ys+25", "Email:")
    myGui.Add("Edit", "x+10 yp-3 w230")

    myGui.Add("Text", "xs+10 y+10", "Phone:")
    myGui.Add("Edit", "x+10 yp-3 w230")

    ; Preferences Section
    myGui.Add("GroupBox", "xs y+20 w350 h100 Section", "Preferences")
    myGui.Add("Text", "xs+10 ys+25", "Language:")
    langDDL := myGui.Add("DropDownList", "x+10 yp-3 w200", ["English", "Spanish", "French", "German", "Chinese"])
    langDDL.Choose(1)

    myGui.Add("Checkbox", "xs+10 y+10", "Subscribe to newsletter")
    myGui.Add("Checkbox", "xs+10 y+5", "Enable notifications")

    ; Buttons
    myGui.Add("Button", "xs y+20 w100", "Register").OnEvent("Click", (*) => MsgBox("Registration submitted!", "Success"))
    myGui.Add("Button", "x+10 yp w100", "Reset").OnEvent("Click", (*) => myGui.Destroy())
    myGui.Add("Button", "x+10 yp w100", "Cancel").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; =============================================================================
; Example 6: Multi-Column Form Layout
; =============================================================================

/**
 * Creates a multi-column form layout
 * Demonstrates side-by-side control placement
 */
Example6_MultiColumnLayout() {
    myGui := Gui(, "Multi-Column Form Layout")
    myGui.BackColor := "0xFAFAFA"
    myGui.MarginX := 20
    myGui.MarginY := 20

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "Section", "Employee Information Form")
    myGui.SetFont("s9 Norm")

    ; Left Column
    myGui.Add("Text", "xs y+20 Section", "Left Column")
    myGui.SetFont("s9 Bold")
    myGui.Add("Text", "xs y+10", "Personal Details")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "xs y+10", "First Name:")
    myGui.Add("Edit", "xs y+5 w200")

    myGui.Add("Text", "xs y+10", "Last Name:")
    myGui.Add("Edit", "xs y+5 w200")

    myGui.Add("Text", "xs y+10", "Employee ID:")
    myGui.Add("Edit", "xs y+5 w200")

    myGui.Add("Text", "xs y+10", "Department:")
    deptDDL := myGui.Add("DropDownList", "xs y+5 w200", ["Engineering", "Sales", "HR", "Marketing", "Finance"])
    deptDDL.Choose(1)

    myGui.Add("Text", "xs y+10", "Position:")
    myGui.Add("Edit", "xs y+5 w200")

    ; Right Column (same y-start as left column)
    myGui.Add("Text", "x250 ys Section", "Right Column")
    myGui.SetFont("s9 Bold")
    myGui.Add("Text", "xs y+10", "Contact Details")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "xs y+10", "Email:")
    myGui.Add("Edit", "xs y+5 w200")

    myGui.Add("Text", "xs y+10", "Phone:")
    myGui.Add("Edit", "xs y+5 w200")

    myGui.Add("Text", "xs y+10", "Extension:")
    myGui.Add("Edit", "xs y+5 w200")

    myGui.Add("Text", "xs y+10", "Office Location:")
    officeDDL := myGui.Add("DropDownList", "xs y+5 w200", ["Building A", "Building B", "Building C", "Remote"])
    officeDDL.Choose(1)

    myGui.Add("Text", "xs y+10", "Manager:")
    myGui.Add("Edit", "xs y+5 w200")

    ; Full-width notes section
    myGui.Add("Text", "x20 y+30 Section", "Additional Notes:")
    myGui.Add("Edit", "xs y+5 w430 h80 Multi")

    ; Bottom buttons (centered)
    myGui.Add("Button", "x20 y+15 w135", "Save").OnEvent("Click", (*) => MsgBox("Employee info saved!", "Success"))
    myGui.Add("Button", "x+10 yp w135", "Clear").OnEvent("Click", (*) => Example6_MultiColumnLayout())
    myGui.Add("Button", "x+10 yp w135", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w470 h550")
}

; =============================================================================
; Example 7: Responsive Dashboard Layout
; =============================================================================

/**
 * Creates a dashboard-style layout with multiple panels
 * Demonstrates complex layout with multiple sections
 */
Example7_DashboardLayout() {
    myGui := Gui("+Resize", "Dashboard Layout")
    myGui.BackColor := "0x2C3E50"

    ; Top bar
    topBar := myGui.Add("Text", "x0 y0 w800 h50 Background0x34495E cWhite Center 0x200", "")
    myGui.SetFont("s14 Bold cWhite", "Segoe UI")
    title := myGui.Add("Text", "x20 y15 Background0x34495E", "Application Dashboard")
    myGui.SetFont("s9 Norm cWhite")
    userText := myGui.Add("Text", "x650 y18 Background0x34495E", "User: Admin")

    ; Stats cards
    myGui.SetFont("s10 Bold c000000")

    ; Card 1
    card1 := myGui.Add("Text", "x20 y70 w180 h100 BackgroundWhite Center 0x200", "")
    myGui.SetFont("s20 Bold c3498DB", "Segoe UI")
    myGui.Add("Text", "x20 y85 w180 h30 BackgroundWhite Center", "1,234")
    myGui.SetFont("s9 Norm c000000")
    myGui.Add("Text", "x20 y120 w180 h30 BackgroundWhite Center", "Total Users")

    ; Card 2
    card2 := myGui.Add("Text", "x210 y70 w180 h100 BackgroundWhite Center 0x200", "")
    myGui.SetFont("s20 Bold c2ECC71", "Segoe UI")
    myGui.Add("Text", "x210 y85 w180 h30 BackgroundWhite Center", "567")
    myGui.SetFont("s9 Norm c000000")
    myGui.Add("Text", "x210 y120 w180 h30 BackgroundWhite Center", "Active Sessions")

    ; Card 3
    card3 := myGui.Add("Text", "x400 y70 w180 h100 BackgroundWhite Center 0x200", "")
    myGui.SetFont("s20 Bold cE74C3C", "Segoe UI")
    myGui.Add("Text", "x400 y85 w180 h30 BackgroundWhite Center", "23")
    myGui.SetFont("s9 Norm c000000")
    myGui.Add("Text", "x400 y120 w180 h30 BackgroundWhite Center", "Alerts")

    ; Card 4
    card4 := myGui.Add("Text", "x590 y70 w180 h100 BackgroundWhite Center 0x200", "")
    myGui.SetFont("s20 Bold c9B59B6", "Segoe UI")
    myGui.Add("Text", "x590 y85 w180 h30 BackgroundWhite Center", "98.5%")
    myGui.SetFont("s9 Norm c000000")
    myGui.Add("Text", "x590 y120 w180 h30 BackgroundWhite Center", "Uptime")

    ; Activity panel
    myGui.SetFont("s10 Bold c000000")
    activityPanel := myGui.Add("Text", "x20 y190 w370 h280 BackgroundWhite 0x200", "")
    myGui.Add("Text", "x30 y200 BackgroundWhite", "Recent Activity")

    myGui.SetFont("s9 Norm c000000")
    activityList := myGui.Add("ListBox", "x30 y230 w350 h230", [
        "User JohnD logged in - 2 min ago",
        "New user registered - 5 min ago",
        "System backup completed - 10 min ago",
        "Database optimized - 15 min ago",
        "User report generated - 20 min ago",
        "Email sent to 150 users - 25 min ago",
        "Server restart - 1 hour ago"
    ])

    ; System status panel
    myGui.SetFont("s10 Bold c000000")
    statusPanel := myGui.Add("Text", "x400 y190 w370 h280 BackgroundWhite 0x200", "")
    myGui.Add("Text", "x410 y200 BackgroundWhite", "System Status")

    myGui.SetFont("s9 Norm c000000")
    myGui.Add("Text", "x410 y235 BackgroundWhite", "CPU Usage:")
    cpuProgress := myGui.Add("Progress", "x510 y232 w250 h20 Background0xECF0F1", "45")
    myGui.Add("Text", "x740 y235 BackgroundWhite", "45%")

    myGui.Add("Text", "x410 y265 BackgroundWhite", "Memory:")
    memProgress := myGui.Add("Progress", "x510 y262 w250 h20 Background0xECF0F1", "62")
    myGui.Add("Text", "x740 y265 BackgroundWhite", "62%")

    myGui.Add("Text", "x410 y295 BackgroundWhite", "Disk Space:")
    diskProgress := myGui.Add("Progress", "x510 y292 w250 h20 Background0xECF0F1", "78")
    myGui.Add("Text", "x740 y295 BackgroundWhite", "78%")

    myGui.Add("Text", "x410 y325 BackgroundWhite", "Network:")
    netProgress := myGui.Add("Progress", "x510 y322 w250 h20 Background0xECF0F1", "33")
    myGui.Add("Text", "x740 y325 BackgroundWhite", "33%")

    myGui.SetFont("s9 Bold c27AE60")
    myGui.Add("Text", "x410 y360 BackgroundWhite", "✓ All systems operational")

    myGui.SetFont("s9 Norm c000000")
    myGui.Add("Text", "x410 y385 BackgroundWhite", "Last updated: " FormatTime(, "HH:mm:ss"))
    myGui.Add("Button", "x410 y415 w100", "Refresh").OnEvent("Click", (*) => MsgBox("Refreshing dashboard...", "Info"))
    myGui.Add("Button", "x520 y415 w100", "Settings").OnEvent("Click", (*) => MsgBox("Opening settings...", "Info"))
    myGui.Add("Button", "x630 y415 w100", "Logout").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w800 h490")
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_Gui_02 - Layout Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "GUI Layout and Positioning Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    ; Example buttons
    menuGui.Add("Button", "x20 y80 w360", "Example 1: Absolute Positioning").OnEvent("Click", (*) => Example1_AbsolutePositioning())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Relative Positioning").OnEvent("Click", (*) => Example2_RelativePositioning())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Grid Layout").OnEvent("Click", (*) => Example3_GridLayout())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Anchored Layout").OnEvent("Click", (*) => Example4_AnchoredLayout())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Section-Based Layout").OnEvent("Click", (*) => Example5_SectionLayout())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Multi-Column Layout").OnEvent("Click", (*) => Example6_MultiColumnLayout())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Dashboard Layout").OnEvent("Click", (*) => Example7_DashboardLayout())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
