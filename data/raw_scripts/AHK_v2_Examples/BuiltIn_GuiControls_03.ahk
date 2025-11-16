#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiControls_03.ahk - Checkbox and Radio Button Controls
 *
 * This file demonstrates checkbox and radio button controls in AutoHotkey v2.
 * Topics covered:
 * - Checkbox creation and states
 * - Three-state checkboxes
 * - Radio button groups
 * - Dynamic checkbox/radio behavior
 * - Event handling for selection changes
 * - Grouped options and mutual exclusivity
 * - Checkbox/radio validation
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */

; =============================================================================
; Example 1: Basic Checkboxes
; =============================================================================

/**
 * Demonstrates basic checkbox creation and usage
 * Shows different checkbox configurations
 */
Example1_BasicCheckboxes() {
    myGui := Gui(, "Basic Checkboxes")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Checkbox Examples")
    myGui.SetFont("s9 Norm")

    ; Basic checkboxes
    myGui.Add("Text", "x20 y55", "Select your preferences:")
    
    check1 := myGui.Add("Checkbox", "x20 y80", "Enable notifications")
    check2 := myGui.Add("Checkbox", "x20 y105", "Auto-save documents")
    check3 := myGui.Add("Checkbox", "x20 y130", "Show hidden files")
    check4 := myGui.Add("Checkbox", "x20 y155", "Dark mode")
    check5 := myGui.Add("Checkbox", "x20 y180", "Check for updates automatically")

    ; Pre-checked checkbox
    check6 := myGui.Add("Checkbox", "x20 y215 Checked", "Accept terms and conditions (pre-checked)")
    
    ; Disabled checkbox
    check7 := myGui.Add("Checkbox", "x20 y240 Disabled", "Premium feature (disabled - upgrade required)")

    ; Get all states button
    myGui.Add("Button", "x20 y280 w220", "Show All States").OnEvent("Click", ShowStates)

    resultText := myGui.Add("Edit", "x20 y315 w460 h120 ReadOnly Multi")

    ShowStates(*) {
        result := "Checkbox States:`n`n"
        result .= "Notifications: " (check1.Value ? "ON" : "OFF") "`n"
        result .= "Auto-save: " (check2.Value ? "ON" : "OFF") "`n"
        result .= "Show hidden files: " (check3.Value ? "ON" : "OFF") "`n"
        result .= "Dark mode: " (check4.Value ? "ON" : "OFF") "`n"
        result .= "Auto-update: " (check5.Value ? "ON" : "OFF") "`n"
        result .= "Accept terms: " (check6.Value ? "ON" : "OFF") "`n"
        result .= "Premium: " (check7.Value ? "ON" : "OFF (Disabled)")
        
        resultText.Value := result
    }

    ; Toggle all button
    myGui.Add("Button", "x250 y280 w110", "Check All").OnEvent("Click", CheckAll)
    myGui.Add("Button", "x370 y280 w110", "Uncheck All").OnEvent("Click", UncheckAll)

    CheckAll(*) {
        for ctrl in [check1, check2, check3, check4, check5, check6] {
            ctrl.Value := 1
        }
        ShowStates()
    }

    UncheckAll(*) {
        for ctrl in [check1, check2, check3, check4, check5, check6] {
            ctrl.Value := 0
        }
        ShowStates()
    }

    myGui.Add("Button", "x20 y445 w460", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w500 h490")
}

; =============================================================================
; Example 2: Radio Buttons
; =============================================================================

/**
 * Demonstrates radio button groups
 * Shows mutually exclusive selections
 */
Example2_RadioButtons() {
    myGui := Gui(, "Radio Button Examples")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Radio Button Groups")
    myGui.SetFont("s9 Norm")

    ; Group 1: Size selection
    myGui.Add("GroupBox", "x20 y50 w200 h140", "Select Size")
    radio1_1 := myGui.Add("Radio", "x30 y75 Group", "Small")
    radio1_2 := myGui.Add("Radio", "x30 y100", "Medium")
    radio1_3 := myGui.Add("Radio", "x30 y125 Checked", "Large (default)")
    radio1_4 := myGui.Add("Radio", "x30 y150", "Extra Large")

    ; Group 2: Color selection
    myGui.Add("GroupBox", "x230 y50 w200 h140", "Select Color")
    radio2_1 := myGui.Add("Radio", "x240 y75 Group Checked", "Red (default)")
    radio2_2 := myGui.Add("Radio", "x240 y100", "Green")
    radio2_3 := myGui.Add("Radio", "x240 y125", "Blue")
    radio2_4 := myGui.Add("Radio", "x240 y150", "Yellow")

    ; Group 3: Payment method
    myGui.Add("GroupBox", "x20 y200 w410 h120", "Select Payment Method")
    radio3_1 := myGui.Add("Radio", "x30 y225 Group Checked", "Credit Card")
    radio3_2 := myGui.Add("Radio", "x30 y250", "Debit Card")
    radio3_3 := myGui.Add("Radio", "x30 y275", "PayPal")
    radio3_4 := myGui.Add("Radio", "x200 y225", "Bank Transfer")
    radio3_5 := myGui.Add("Radio", "x200 y250", "Cash on Delivery")
    radio3_6 := myGui.Add("Radio", "x200 y275", "Cryptocurrency")

    ; Get selections button
    myGui.Add("Button", "x20 y335 w200", "Get Selections").OnEvent("Click", GetSelections)

    resultText := myGui.Add("Edit", "x20 y370 w410 h80 ReadOnly Multi")

    GetSelections(*) {
        ; Get size
        size := ""
        if (radio1_1.Value) 
            size := "Small"
        else if (radio1_2.Value)
            size := "Medium"
        else if (radio1_3.Value)
            size := "Large"
        else if (radio1_4.Value)
            size := "Extra Large"

        ; Get color
        color := ""
        if (radio2_1.Value)
            color := "Red"
        else if (radio2_2.Value)
            color := "Green"
        else if (radio2_3.Value)
            color := "Blue"
        else if (radio2_4.Value)
            color := "Yellow"

        ; Get payment
        payment := ""
        for ctrl in [radio3_1, radio3_2, radio3_3, radio3_4, radio3_5, radio3_6] {
            if (ctrl.Value) {
                payment := ctrl.Text
                break
            }
        }

        resultText.Value := Format("Selected:`nSize: {1}`nColor: {2}`nPayment: {3}", size, color, payment)
    }

    ; Reset button
    myGui.Add("Button", "x230 y335 w200", "Reset to Defaults").OnEvent("Click", ResetDefaults)

    ResetDefaults(*) {
        radio1_3.Value := 1  ; Large
        radio2_1.Value := 1  ; Red
        radio3_1.Value := 1  ; Credit Card
        GetSelections()
    }

    myGui.Add("Button", "x20 y460 w410", "Close").OnEvent("Click", (*) => myGui.Destroy())

    GetSelections()
    myGui.Show("w450 h510")
}

; =============================================================================
; Example 3: Three-State Checkboxes
; =============================================================================

/**
 * Demonstrates three-state checkboxes
 * Checked, unchecked, and indeterminate states
 */
Example3_ThreeState() {
    myGui := Gui(, "Three-State Checkboxes")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Three-State Checkbox Example")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55 w460", "Three-state checkboxes have Checked, Unchecked, and Indeterminate states.")

    ; Parent checkbox (controls all children)
    parentCheck := myGui.Add("Checkbox", "x20 y90 Check3", "Select All Features")
    parentCheck.SetFont("s10 Bold")

    myGui.Add("Text", "x20 y120", "Child options:")

    ; Child checkboxes
    child1 := myGui.Add("Checkbox", "x40 y145", "Feature A: Auto-backup")
    child2 := myGui.Add("Checkbox", "x40 y170", "Feature B: Cloud sync")
    child3 := myGui.Add("Checkbox", "x40 y195", "Feature C: Version control")
    child4 := myGui.Add("Checkbox", "x40 y220", "Feature D: Team collaboration")
    child5 := myGui.Add("Checkbox", "x40 y245", "Feature E: Advanced analytics")

    children := [child1, child2, child3, child4, child5]

    ; Update parent when children change
    for child in children {
        child.OnEvent("Click", UpdateParent)
    }

    UpdateParent(*) {
        checkedCount := 0
        for child in children {
            if (child.Value)
                checkedCount++
        }

        if (checkedCount = 0) {
            parentCheck.Value := 0  ; Unchecked
        } else if (checkedCount = children.Length) {
            parentCheck.Value := 1  ; Checked
        } else {
            parentCheck.Value := -1  ; Indeterminate
        }

        UpdateStatus()
    }

    ; Update children when parent changes
    parentCheck.OnEvent("Click", UpdateChildren)

    UpdateChildren(*) {
        state := parentCheck.Value
        if (state = -1) {
            ; If indeterminate, go to checked
            parentCheck.Value := 1
            state := 1
        }

        for child in children {
            child.Value := state
        }

        UpdateStatus()
    }

    ; Status display
    statusText := myGui.Add("Text", "x20 y285 w460 h60 Border BackgroundWhite")

    UpdateStatus(*) {
        checkedCount := 0
        checkedNames := []
        
        for child in children {
            if (child.Value) {
                checkedCount++
                checkedNames.Push(child.Text)
            }
        }

        parentState := ""
        switch parentCheck.Value {
            case 1: parentState := "CHECKED"
            case 0: parentState := "UNCHECKED"
            case -1: parentState := "INDETERMINATE"
        }

        statusText.Value := Format("Parent state: {1}`nChecked features: {2} of {3}`n{4}",
            parentState, checkedCount, children.Length,
            checkedCount > 0 ? "Selected: " StrReplace(checkedNames.Join(", "), "Feature ", "") : "None selected")
    }

    ; Preset buttons
    myGui.Add("Button", "x20 y360 w100", "Check All").OnEvent("Click", (*) => (parentCheck.Value := 1, UpdateChildren()))
    myGui.Add("Button", "x130 y360 w100", "Uncheck All").OnEvent("Click", (*) => (parentCheck.Value := 0, UpdateChildren()))
    myGui.Add("Button", "x240 y360 w120", "Indeterminate").OnEvent("Click", (*) => (parentCheck.Value := -1, UpdateStatus()))
    myGui.Add("Button", "x370 y360 w110", "Random").OnEvent("Click", RandomSelect)

    RandomSelect(*) {
        for child in children {
            Random(&val, 0, 1)
            child.Value := val
        }
        UpdateParent()
    }

    myGui.Add("Button", "x20 y400 w460", "Close").OnEvent("Click", (*) => myGui.Destroy())

    UpdateStatus()
    myGui.Show("w500 h450")
}

; =============================================================================
; Example 4: Dynamic Checkbox Groups
; =============================================================================

/**
 * Dynamic checkbox groups with conditional logic
 * Checkboxes that enable/disable other controls
 */
Example4_DynamicCheckboxes() {
    myGui := Gui(, "Dynamic Checkbox Groups")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Dynamic Checkbox Behavior")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55", "Main features:")

    ; Feature 1: Email notifications (enables sub-options)
    feature1 := myGui.Add("Checkbox", "x20 y80", "Enable Email Notifications")
    feature1Sub1 := myGui.Add("Checkbox", "x40 y105 Disabled", "Daily digest")
    feature1Sub2 := myGui.Add("Checkbox", "x40 y130 Disabled", "Instant alerts")
    feature1Sub3 := myGui.Add("Checkbox", "x40 y155 Disabled", "Weekly summary")

    feature1.OnEvent("Click", (*) => ToggleSubOptions(feature1, [feature1Sub1, feature1Sub2, feature1Sub3]))

    ; Feature 2: Advanced mode (enables advanced settings)
    feature2 := myGui.Add("Checkbox", "x300 y80", "Advanced Mode")
    feature2Sub1 := myGui.Add("Checkbox", "x320 y105 Disabled", "Debug logging")
    feature2Sub2 := myGui.Add("Checkbox", "x320 y130 Disabled", "Performance metrics")
    feature2Sub3 := myGui.Add("Checkbox", "x320 y155 Disabled", "Developer tools")

    feature2.OnEvent("Click", (*) => ToggleSubOptions(feature2, [feature2Sub1, feature2Sub2, feature2Sub3]))

    ToggleSubOptions(parent, children) {
        enabled := parent.Value
        for child in children {
            child.Enabled := enabled
            if (!enabled)
                child.Value := 0
        }
        UpdateSummary()
    }

    ; Mutually exclusive checkboxes (simulate radio behavior)
    myGui.Add("Text", "x20 y195", "Connection mode (only one can be selected):")
    
    conn1 := myGui.Add("Checkbox", "x20 y220", "Wi-Fi")
    conn2 := myGui.Add("Checkbox", "x100 y220", "Ethernet")
    conn3 := myGui.Add("Checkbox", "x200 y220", "Cellular")
    conn4 := myGui.Add("Checkbox", "x300 y220", "Offline Mode")

    connections := [conn1, conn2, conn3, conn4]

    for conn in connections {
        conn.OnEvent("Click", (*) => MakeExclusive(connections, conn))
    }

    MakeExclusive(group, selected) {
        if (selected.Value) {
            for item in group {
                if (item != selected)
                    item.Value := 0
            }
        }
        UpdateSummary()
    }

    ; Required checkbox
    myGui.Add("Text", "x20 y260", "Required agreements:")
    required1 := myGui.Add("Checkbox", "x20 y285", "I agree to the Terms of Service")
    required2 := myGui.Add("Checkbox", "x20 y310", "I agree to the Privacy Policy")
    required3 := myGui.Add("Checkbox", "x20 y335", "I am 18 years or older")

    ; Summary
    summaryText := myGui.Add("Edit", "x20 y375 w560 h80 ReadOnly Multi")

    UpdateSummary(*) {
        summary := "Configuration Summary:`n`n"

        ; Email notifications
        if (feature1.Value) {
            summary .= "✓ Email Notifications enabled"
            subs := []
            if (feature1Sub1.Value) subs.Push("Daily")
            if (feature1Sub2.Value) subs.Push("Instant")
            if (feature1Sub3.Value) subs.Push("Weekly")
            if (subs.Length > 0)
                summary .= " (" subs.Join(", ") ")"
            summary .= "`n"
        }

        ; Advanced mode
        if (feature2.Value) {
            summary .= "✓ Advanced Mode enabled"
            subs := []
            if (feature2Sub1.Value) subs.Push("Debug")
            if (feature2Sub2.Value) subs.Push("Metrics")
            if (feature2Sub3.Value) subs.Push("Dev tools")
            if (subs.Length > 0)
                summary .= " (" subs.Join(", ") ")"
            summary .= "`n"
        }

        ; Connection
        for conn in connections {
            if (conn.Value) {
                summary .= "✓ Connection: " conn.Text "`n"
                break
            }
        }

        ; Check required agreements
        allAgreed := required1.Value && required2.Value && required3.Value
        summary .= Format("`nRequired agreements: {1}/3 complete", 
            (required1.Value ? 1 : 0) + (required2.Value ? 1 : 0) + (required3.Value ? 1 : 0))

        summaryText.Value := summary
    }

    ; Watch required checkboxes
    for req in [required1, required2, required3] {
        req.OnEvent("Click", UpdateSummary)
    }

    ; Submit button (only enabled if all required are checked)
    submitBtn := myGui.Add("Button", "x20 y465 w270 Disabled", "Submit Configuration")
    submitBtn.OnEvent("Click", Submit)

    ; Check required status
    SetTimer(CheckRequired, 100)

    CheckRequired() {
        allAgreed := required1.Value && required2.Value && required3.Value
        try submitBtn.Enabled := allAgreed
    }

    Submit(*) {
        MsgBox("Configuration submitted successfully!", "Success")
    }

    myGui.Add("Button", "x300 y465 w280", "Close").OnEvent("Click", (*) => (SetTimer(CheckRequired, 0), myGui.Destroy()))

    UpdateSummary()
    myGui.Show("w600 h510")
}

; =============================================================================
; Example 5: Checkbox List Builder
; =============================================================================

/**
 * Build lists using checkboxes
 * Select multiple items to create a custom list
 */
Example5_CheckboxList() {
    myGui := Gui(, "Checkbox List Builder")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Build Your Custom List")
    myGui.SetFont("s9 Norm")

    myGui.Add("Text", "x20 y55", "Select items to include:")

    ; Categories with items
    categories := Map(
        "Fruits", ["Apple", "Banana", "Orange", "Grape", "Mango"],
        "Vegetables", ["Carrot", "Broccoli", "Spinach", "Tomato", "Cucumber"],
        "Grains", ["Rice", "Wheat", "Oats", "Barley", "Quinoa"]
    )

    checkboxes := Map()
    yPos := 80

    for category, items in categories {
        ; Category header
        myGui.SetFont("s9 Bold")
        myGui.Add("Text", "x20 y" yPos, category ":")
        myGui.SetFont("s9 Norm")
        yPos += 25

        categoryChecks := []
        for item in items {
            check := myGui.Add("Checkbox", "x40 y" yPos, item)
            check.OnEvent("Click", UpdateList)
            categoryChecks.Push(check)
            yPos += 25
        }
        checkboxes[category] := categoryChecks
    }

    ; Selected items list
    myGui.Add("Text", "x320 y55", "Your selected items:")
    selectedList := myGui.Add("Edit", "x320 y80 w240 h" (yPos - 80) " ReadOnly Multi")

    UpdateList(*) {
        selected := []
        
        for category, checks in checkboxes {
            for check in checks {
                if (check.Value) {
                    selected.Push(check.Text)
                }
            }
        }

        if (selected.Length > 0) {
            selectedList.Value := selected.Join("`n")
        } else {
            selectedList.Value := "(Nothing selected)"
        }

        try countText.Value := "Total selected: " selected.Length
    }

    countText := myGui.Add("Text", "x320 y" (yPos + 5) " w240", "Total selected: 0")

    ; Quick select buttons
    btnY := yPos + 35
    myGui.Add("Button", "x20 y" btnY " w90", "Select All").OnEvent("Click", SelectAll)
    myGui.Add("Button", "x120 y" btnY " w90", "Clear All").OnEvent("Click", ClearAll)
    myGui.Add("Button", "x220 y" btnY " w90", "Invert").OnEvent("Click", InvertSelection)

    SelectAll(*) {
        for category, checks in checkboxes {
            for check in checks {
                check.Value := 1
            }
        }
        UpdateList()
    }

    ClearAll(*) {
        for category, checks in checkboxes {
            for check in checks {
                check.Value := 0
            }
        }
        UpdateList()
    }

    InvertSelection(*) {
        for category, checks in checkboxes {
            for check in checks {
                check.Value := !check.Value
            }
        }
        UpdateList()
    }

    ; Category buttons
    catBtnY := btnY + 35
    myGui.Add("Button", "x20 y" catBtnY " w90", "Fruits Only").OnEvent("Click", (*) => SelectCategory("Fruits"))
    myGui.Add("Button", "x120 y" catBtnY " w90", "Veggies Only").OnEvent("Click", (*) => SelectCategory("Vegetables"))
    myGui.Add("Button", "x220 y" catBtnY " w90", "Grains Only").OnEvent("Click", (*) => SelectCategory("Grains"))

    SelectCategory(cat) {
        ClearAll()
        for check in checkboxes[cat] {
            check.Value := 1
        }
        UpdateList()
    }

    ; Export button
    myGui.Add("Button", "x320 y" btnY " w240", "Export List").OnEvent("Click", ExportList)

    ExportList(*) {
        if (selectedList.Value != "(Nothing selected)") {
            A_Clipboard := selectedList.Value
            MsgBox("List copied to clipboard!", "Exported")
        } else {
            MsgBox("No items selected!", "Error")
        }
    }

    myGui.Add("Button", "x20 y" (catBtnY + 35) " w540", "Close").OnEvent("Click", (*) => myGui.Destroy())

    UpdateList()
    myGui.Show("w580 h" (catBtnY + 75))
}

; =============================================================================
; Example 6: Survey Form with Radio and Checkbox
; =============================================================================

/**
 * Complete survey form combining radio and checkbox controls
 * Demonstrates real-world form design
 */
Example6_SurveyForm() {
    myGui := Gui(, "Customer Satisfaction Survey")
    myGui.BackColor := "White"

    myGui.SetFont("s12 Bold")
    myGui.Add("Text", "x20 y20 w560", "Customer Satisfaction Survey")
    myGui.SetFont("s9 Norm")

    ; Question 1: Satisfaction (radio)
    myGui.Add("GroupBox", "x20 y50 w560 h100", "1. How satisfied are you with our service?")
    sat1 := myGui.Add("Radio", "x30 y75 Group", "Very Dissatisfied")
    sat2 := myGui.Add("Radio", "x170 y75", "Dissatisfied")
    sat3 := myGui.Add("Radio", "x280 y75 Checked", "Neutral")
    sat4 := myGui.Add("Radio", "x360 y75", "Satisfied")
    sat5 := myGui.Add("Radio", "x450 y75", "Very Satisfied")

    ; Question 2: Features used (checkboxes)
    myGui.Add("GroupBox", "x20 y160 w560 h140", "2. Which features have you used? (Select all that apply)")
    feat1 := myGui.Add("Checkbox", "x30 y185", "Online ordering")
    feat2 := myGui.Add("Checkbox", "x200 y185", "Customer support")
    feat3 := myGui.Add("Checkbox", "x380 y185", "Live chat")
    feat4 := myGui.Add("Checkbox", "x30 y210", "Mobile app")
    feat5 := myGui.Add("Checkbox", "x200 y210", "Loyalty program")
    feat6 := myGui.Add("Checkbox", "x380 y210", "Email updates")
    feat7 := myGui.Add("Checkbox", "x30 y235", "Product reviews")
    feat8 := myGui.Add("Checkbox", "x200 y235", "Price comparison")
    feat9 := myGui.Add("Checkbox", "x380 y235", "Wishlist")

    ; Question 3: Recommendation (radio)
    myGui.Add("GroupBox", "x20 y310 w560 h100", "3. Would you recommend us to a friend?")
    rec1 := myGui.Add("Radio", "x30 y335 Group", "Definitely not")
    rec2 := myGui.Add("Radio", "x150 y335", "Probably not")
    rec3 := myGui.Add("Radio", "x270 y335 Checked", "Might or might not")
    rec4 := myGui.Add("Radio", "x410 y335", "Probably yes")
    rec5 := myGui.Add("Radio", "x30 y360", "Definitely yes")

    ; Submit button
    myGui.Add("Button", "x20 y425 w270", "Submit Survey").OnEvent("Click", SubmitSurvey)
    myGui.Add("Button", "x300 y425 w280", "Clear and Restart").OnEvent("Click", ResetSurvey)

    SubmitSurvey(*) {
        ; Get satisfaction level
        satisfaction := ""
        for i, ctrl in [sat1, sat2, sat3, sat4, sat5] {
            if (ctrl.Value) {
                satisfaction := ctrl.Text
                break
            }
        }

        ; Count features used
        featuresUsed := []
        for ctrl in [feat1, feat2, feat3, feat4, feat5, feat6, feat7, feat8, feat9] {
            if (ctrl.Value) {
                featuresUsed.Push(ctrl.Text)
            }
        }

        ; Get recommendation
        recommendation := ""
        for ctrl in [rec1, rec2, rec3, rec4, rec5] {
            if (ctrl.Value) {
                recommendation := ctrl.Text
                break
            }
        }

        ; Build results
        results := "Survey Results:`n`n"
        results .= "Satisfaction: " satisfaction "`n`n"
        results .= "Features Used (" featuresUsed.Length "):`n"
        results .= (featuresUsed.Length > 0 ? "• " StrReplace(featuresUsed.Join("`n• "), "", "") : "None") "`n`n"
        results .= "Recommendation: " recommendation

        MsgBox(results, "Survey Submitted")
    }

    ResetSurvey(*) {
        sat3.Value := 1
        rec3.Value := 1
        for ctrl in [feat1, feat2, feat3, feat4, feat5, feat6, feat7, feat8, feat9] {
            ctrl.Value := 0
        }
    }

    myGui.Show("w600 h475")
}

; =============================================================================
; Example 7: Settings Panel
; =============================================================================

/**
 * Complete settings panel with organized checkbox/radio groups
 * Demonstrates professional settings interface
 */
Example7_SettingsPanel() {
    myGui := Gui(, "Application Settings")
    myGui.BackColor := "0xF0F0F0"

    ; Title bar
    titleBar := myGui.Add("Text", "x0 y0 w600 h40 Background0x2C3E50 cWhite Center 0x200", "")
    myGui.SetFont("s14 Bold cWhite")
    myGui.Add("Text", "x0 y10 w600 Background0x2C3E50 Center", "⚙ Application Settings")

    myGui.SetFont("s10 Bold c000000")
    myGui.Add("Text", "x20 y55", "General Settings")
    myGui.SetFont("s9 Norm")

    gen1 := myGui.Add("Checkbox", "x20 y80 Checked", "Start application on system startup")
    gen2 := myGui.Add("Checkbox", "x20 y105", "Minimize to system tray")
    gen3 := myGui.Add("Checkbox", "x20 y130 Checked", "Show desktop notifications")
    gen4 := myGui.Add("Checkbox", "x20 y155", "Check for updates automatically")

    myGui.SetFont("s10 Bold")
    myGui.Add("Text", "x310 y55", "Appearance")
    myGui.SetFont("s9 Norm")

    myGui.Add("GroupBox", "x310 y75 w270 h85", "Theme")
    theme1 := myGui.Add("Radio", "x320 y95 Group Checked", "Light")
    theme2 := myGui.Add("Radio", "x400 y95", "Dark")
    theme3 := myGui.Add("Radio", "x470 y95", "Auto")
    
    myGui.Add("Text", "x320 y120", "Font Size:")
    font1 := myGui.Add("Radio", "x320 y135 Group", "Small")
    font2 := myGui.Add("Radio", "x380 y135 Checked", "Medium")
    font3 := myGui.Add("Radio", "x450 y135", "Large")

    myGui.SetFont("s10 Bold")
    myGui.Add("Text", "x20 y175", "Privacy Settings")
    myGui.SetFont("s9 Norm")

    priv1 := myGui.Add("Checkbox", "x20 y200 Checked", "Send anonymous usage statistics")
    priv2 := myGui.Add("Checkbox", "x20 y225", "Share crash reports")
    priv3 := myGui.Add("Checkbox", "x20 y250", "Allow location tracking")
    priv4 := myGui.Add("Checkbox", "x20 y275 Checked", "Remember my preferences")

    myGui.SetFont("s10 Bold")
    myGui.Add("Text", "x310 y175", "Notifications")
    myGui.SetFont("s9 Norm")

    notif1 := myGui.Add("Checkbox", "x310 y200 Checked", "Email notifications")
    notif2 := myGui.Add("Checkbox", "x310 y225 Checked", "Push notifications")
    notif3 := myGui.Add("Checkbox", "x310 y250", "SMS notifications")
    notif4 := myGui.Add("Checkbox", "x310 y275", "Sound alerts")

    myGui.SetFont("s10 Bold")
    myGui.Add("Text", "x20 y305", "Data Management")
    myGui.SetFont("s9 Norm")

    data1 := myGui.Add("Checkbox", "x20 y330 Checked", "Enable automatic backups")
    data2 := myGui.Add("Checkbox", "x20 y355 Checked", "Sync across devices")
    data3 := myGui.Add("Checkbox", "x20 y380", "Compress stored data")

    myGui.SetFont("s10 Bold")
    myGui.Add("Text", "x310 y305", "Advanced")
    myGui.SetFont("s9 Norm")

    adv1 := myGui.Add("Checkbox", "x310 y330", "Enable developer mode")
    adv2 := myGui.Add("Checkbox", "x310 y355", "Verbose logging")
    adv3 := myGui.Add("Checkbox", "x310 y380", "Experimental features")

    ; Action buttons
    myGui.Add("Button", "x20 y420 w180", "Save Settings").OnEvent("Click", SaveSettings)
    myGui.Add("Button", "x210 y420 w180", "Reset to Defaults").OnEvent("Click", ResetDefaults)
    myGui.Add("Button", "x400 y420 w180", "Cancel").OnEvent("Click", (*) => myGui.Destroy())

    SaveSettings(*) {
        MsgBox("Settings saved successfully!", "Success")
    }

    ResetDefaults(*) {
        ; Reset to defaults
        for ctrl in [gen1, gen3, priv1, priv4, notif1, notif2, data1, data2] {
            ctrl.Value := 1
        }
        for ctrl in [gen2, gen4, priv2, priv3, notif3, notif4, data3, adv1, adv2, adv3] {
            ctrl.Value := 0
        }
        theme1.Value := 1
        font2.Value := 1
        MsgBox("Settings reset to defaults", "Reset")
    }

    myGui.Show("w600 h470")
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_GuiControls_03 - Checkbox & Radio Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Checkbox and Radio Button Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Basic Checkboxes").OnEvent("Click", (*) => Example1_BasicCheckboxes())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Radio Buttons").OnEvent("Click", (*) => Example2_RadioButtons())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Three-State Checkboxes").OnEvent("Click", (*) => Example3_ThreeState())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Dynamic Checkboxes").OnEvent("Click", (*) => Example4_DynamicCheckboxes())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Checkbox List Builder").OnEvent("Click", (*) => Example5_CheckboxList())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Survey Form").OnEvent("Click", (*) => Example6_SurveyForm())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Settings Panel").OnEvent("Click", (*) => Example7_SettingsPanel())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

ShowMainMenu()
