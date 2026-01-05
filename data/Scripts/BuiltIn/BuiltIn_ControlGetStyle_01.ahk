#Requires AutoHotkey v2.0
#SingleInstance Force

ExitApp

/**
 * ============================================================================
 * ControlGetStyle - Basic Style Reading and Detection
 * ============================================================================
 * 
 * This script demonstrates how to read and analyze window control styles
 * using ControlGetStyle in AutoHotkey v2.
 * 
 * The ControlGetStyle function retrieves the style value of a control as a
 * numeric value that represents various style flags combined with bitwise OR.
 * 
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 * 
 * Related Functions:
 * - ControlGetExStyle() - Gets extended styles
 * - ControlSetStyle() - Modifies control styles
 * - WinGetStyle() - Gets window styles
 * 
 * Style Constants Reference:
 * - WS_VISIBLE (0x10000000) - Control is visible
 * - WS_DISABLED (0x08000000) - Control is disabled
 * - WS_TABSTOP (0x00010000) - Control can receive focus via Tab key
 * - BS_PUSHBUTTON (0x00000000) - Standard push button
 * - BS_DEFPUSHBUTTON (0x00000001) - Default push button
 * - ES_READONLY (0x00000800) - Edit control is read-only
 * - ES_MULTILINE (0x00000004) - Edit control supports multiple lines
 */

;==============================================================================
; Example 1: Reading Basic Control Styles
;==============================================================================

/**
 * Demonstrates reading and displaying basic control styles
 * 
 * @example
 * Creates a GUI with various controls and displays their style values
 */
Example1_BasicStyleReading() {
    ; Create a GUI window with different control types
    MyGui := Gui("+Resize", "Example 1: Reading Control Styles")

    ; Add various controls with different styles
    MyGui.Add("Text", "w300", "This example reads the style of each control:")
    MyGui.Add("Text", "w300 y+10", "Click 'Analyze' to see control styles:")

    ; Standard button
    BtnNormal := MyGui.Add("Button", "w150 y+20", "Normal Button")

    ; Default button
    BtnDefault := MyGui.Add("Button", "w150 y+10 Default", "Default Button")

    ; Edit control
    EditNormal := MyGui.Add("Edit", "w150 y+10", "Editable Text")

    ; Read-only edit control
    EditReadOnly := MyGui.Add("Edit", "w150 y+10 ReadOnly", "Read-Only Text")

    ; Checkbox
    ChkBox := MyGui.Add("Checkbox", "y+10", "Check Me")

    ; Analyze button
    BtnAnalyze := MyGui.Add("Button", "w150 y+20", "Analyze Styles")
    BtnAnalyze.OnEvent("Click", AnalyzeControls)

    ; Results display
    ResultsEdit := MyGui.Add("Edit", "w500 h300 y+10 ReadOnly Multi", "")

    MyGui.Show()

    AnalyzeControls(*) {
        results := "=== CONTROL STYLE ANALYSIS ===`n`n"

        ; Analyze Normal Button
        try {
            style := ControlGetStyle(BtnNormal)
            results .= "Normal Button:`n"
            results .= "  Style Value: 0x" . Format("{:08X}", style) . "`n"
            results .= "  Decimal: " . style . "`n"
            results .= "  Visible: " . (style & 0x10000000 ? "Yes" : "No") . "`n"
            results .= "  Disabled: " . (style & 0x08000000 ? "Yes" : "No") . "`n"
            results .= "`n"
        } catch as err {
            results .= "Error reading Normal Button: " . err.Message . "`n`n"
        }

        ; Analyze Default Button
        try {
            style := ControlGetStyle(BtnDefault)
            results .= "Default Button:`n"
            results .= "  Style Value: 0x" . Format("{:08X}", style) . "`n"
            results .= "  Decimal: " . style . "`n"
            results .= "  Default Button: " . (style & 0x1 ? "Yes" : "No") . "`n"
            results .= "  Visible: " . (style & 0x10000000 ? "Yes" : "No") . "`n"
            results .= "`n"
        } catch as err {
            results .= "Error reading Default Button: " . err.Message . "`n`n"
        }

        ; Analyze Normal Edit
        try {
            style := ControlGetStyle(EditNormal)
            results .= "Normal Edit Control:`n"
            results .= "  Style Value: 0x" . Format("{:08X}", style) . "`n"
            results .= "  Read-Only: " . (style & 0x800 ? "Yes" : "No") . "`n"
            results .= "  Multiline: " . (style & 0x4 ? "Yes" : "No") . "`n"
            results .= "`n"
        } catch as err {
            results .= "Error reading Normal Edit: " . err.Message . "`n`n"
        }

        ; Analyze Read-Only Edit
        try {
            style := ControlGetStyle(EditReadOnly)
            results .= "Read-Only Edit Control:`n"
            results .= "  Style Value: 0x" . Format("{:08X}", style) . "`n"
            results .= "  Read-Only: " . (style & 0x800 ? "Yes" : "No") . "`n"
            results .= "  Multiline: " . (style & 0x4 ? "Yes" : "No") . "`n"
            results .= "`n"
        } catch as err {
            results .= "Error reading Read-Only Edit: " . err.Message . "`n`n"
        }

        ; Analyze Checkbox
        try {
            style := ControlGetStyle(ChkBox)
            results .= "Checkbox:`n"
            results .= "  Style Value: 0x" . Format("{:08X}", style) . "`n"
            results .= "  Visible: " . (style & 0x10000000 ? "Yes" : "No") . "`n"
            results .= "`n"
        } catch as err {
            results .= "Error reading Checkbox: " . err.Message . "`n`n"
        }

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 2: Detecting Specific Style Flags
;==============================================================================

/**
 * Demonstrates detecting specific window style flags
 * 
 * @example
 * Shows how to check for specific style flags using bitwise operations
 */
Example2_DetectingStyleFlags() {
    MyGui := Gui("+Resize", "Example 2: Detecting Style Flags")

    MyGui.Add("Text", "w400", "This example demonstrates detecting specific style flags:")

    ; Create various controls
    Edit1 := MyGui.Add("Edit", "w300 y+20", "Normal Edit")
    Edit2 := MyGui.Add("Edit", "w300 y+10 Multi", "Multiline`nEdit`nControl")
    Edit3 := MyGui.Add("Edit", "w300 y+10 ReadOnly", "Read-Only Edit")
    Edit4 := MyGui.Add("Edit", "w300 y+10 Password", "Password")

    BtnCheck := MyGui.Add("Button", "w200 y+20", "Check All Styles")
    BtnCheck.OnEvent("Click", CheckStyles)

    ResultsEdit := MyGui.Add("Edit", "w500 h300 y+10 ReadOnly Multi")

    MyGui.Show()

    CheckStyles(*) {
        ; Define common edit control styles
        ES_LEFT := 0x0000
        ES_CENTER := 0x0001
        ES_RIGHT := 0x0002
        ES_MULTILINE := 0x0004
        ES_UPPERCASE := 0x0008
        ES_LOWERCASE := 0x0010
        ES_PASSWORD := 0x0020
        ES_AUTOVSCROLL := 0x0040
        ES_AUTOHSCROLL := 0x0080
        ES_NOHIDESEL := 0x0100
        ES_READONLY := 0x0800
        ES_WANTRETURN := 0x1000
        ES_NUMBER := 0x2000

        results := "=== STYLE FLAGS DETECTION ===`n`n"

        ; Check Edit1
        style1 := ControlGetStyle(Edit1)
        results .= "Edit1 (Normal):`n"
        results .= "  Style: 0x" . Format("{:08X}", style1) . "`n"
        results .= "  Multiline: " . (style1 & ES_MULTILINE ? "Yes" : "No") . "`n"
        results .= "  ReadOnly: " . (style1 & ES_READONLY ? "Yes" : "No") . "`n"
        results .= "  Password: " . (style1 & ES_PASSWORD ? "Yes" : "No") . "`n"
        results .= "  AutoHScroll: " . (style1 & ES_AUTOHSCROLL ? "Yes" : "No") . "`n"
        results .= "`n"

        ; Check Edit2
        style2 := ControlGetStyle(Edit2)
        results .= "Edit2 (Multiline):`n"
        results .= "  Style: 0x" . Format("{:08X}", style2) . "`n"
        results .= "  Multiline: " . (style2 & ES_MULTILINE ? "Yes" : "No") . "`n"
        results .= "  ReadOnly: " . (style2 & ES_READONLY ? "Yes" : "No") . "`n"
        results .= "  AutoVScroll: " . (style2 & ES_AUTOVSCROLL ? "Yes" : "No") . "`n"
        results .= "  WantReturn: " . (style2 & ES_WANTRETURN ? "Yes" : "No") . "`n"
        results .= "`n"

        ; Check Edit3
        style3 := ControlGetStyle(Edit3)
        results .= "Edit3 (ReadOnly):`n"
        results .= "  Style: 0x" . Format("{:08X}", style3) . "`n"
        results .= "  Multiline: " . (style3 & ES_MULTILINE ? "Yes" : "No") . "`n"
        results .= "  ReadOnly: " . (style3 & ES_READONLY ? "Yes" : "No") . "`n"
        results .= "  Password: " . (style3 & ES_PASSWORD ? "Yes" : "No") . "`n"
        results .= "`n"

        ; Check Edit4
        style4 := ControlGetStyle(Edit4)
        results .= "Edit4 (Password):`n"
        results .= "  Style: 0x" . Format("{:08X}", style4) . "`n"
        results .= "  Multiline: " . (style4 & ES_MULTILINE ? "Yes" : "No") . "`n"
        results .= "  ReadOnly: " . (style4 & ES_READONLY ? "Yes" : "No") . "`n"
        results .= "  Password: " . (style4 & ES_PASSWORD ? "Yes" : "No") . "`n"
        results .= "  AutoHScroll: " . (style4 & ES_AUTOHSCROLL ? "Yes" : "No") . "`n"

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 3: Style Analysis Utility
;==============================================================================

/**
 * Creates a utility for analyzing control styles in any window
 * 
 * @example
 * Interactive tool to get style information from external windows
 */
Example3_StyleAnalyzer() {
    MyGui := Gui("+Resize +AlwaysOnTop", "Example 3: Style Analyzer Utility")

    MyGui.Add("Text", "w400", "Enter window title and control ClassNN:")

    MyGui.Add("Text", "xm y+20", "Window Title:")
    WinTitle := MyGui.Add("Edit", "x+10 w300", "")

    MyGui.Add("Text", "xm y+10", "Control ClassNN:")
    CtrlClass := MyGui.Add("Edit", "x+10 w300", "")

    BtnAnalyze := MyGui.Add("Button", "xm y+20 w150", "Analyze Control")
    BtnAnalyze.OnEvent("Click", AnalyzeControl)

    BtnGetActive := MyGui.Add("Button", "x+10 w150", "Get Active Window")
    BtnGetActive.OnEvent("Click", GetActiveWindow)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h400 ReadOnly Multi")

    MyGui.Show()

    GetActiveWindow(*) {
        ; Wait 2 seconds to let user activate target window
        ToolTip("Activate target window...`nAnalyzing in 2 seconds")
        Sleep(2000)
        ToolTip()

        try {
            activeWin := WinGetTitle("A")
            WinTitle.Value := activeWin

            ; Try to get first control
            try {
                ctrl := ControlGetClassNN(ControlGetFocus("A"), "A")
                CtrlClass.Value := ctrl
            }
        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }

    AnalyzeControl(*) {
        winTitle := WinTitle.Value
        ctrlClass := CtrlClass.Value

        if (winTitle = "" || ctrlClass = "") {
            MsgBox("Please enter both window title and control ClassNN", "Error", "IconX")
            return
        }

        try {
            ; Get the control style
            style := ControlGetStyle(ctrlClass, winTitle)
            exStyle := ControlGetExStyle(ctrlClass, winTitle)

            results := "=== CONTROL STYLE ANALYSIS ===`n`n"
            results .= "Window: " . winTitle . "`n"
            results .= "Control: " . ctrlClass . "`n`n"

            ; Basic style information
            results .= "--- STYLE (WS_*) ---`n"
            results .= "Hex Value: 0x" . Format("{:08X}", style) . "`n"
            results .= "Decimal Value: " . style . "`n`n"

            ; Common window styles
            results .= "Window Styles:`n"
            results .= "  WS_VISIBLE (0x10000000): " . (style & 0x10000000 ? "Yes" : "No") . "`n"
            results .= "  WS_DISABLED (0x08000000): " . (style & 0x08000000 ? "Yes" : "No") . "`n"
            results .= "  WS_CHILD (0x40000000): " . (style & 0x40000000 ? "Yes" : "No") . "`n"
            results .= "  WS_TABSTOP (0x00010000): " . (style & 0x00010000 ? "Yes" : "No") . "`n"
            results .= "  WS_GROUP (0x00020000): " . (style & 0x00020000 ? "Yes" : "No") . "`n"
            results .= "  WS_BORDER (0x00800000): " . (style & 0x00800000 ? "Yes" : "No") . "`n`n"

            ; Extended styles
            results .= "--- EXSTYLE (WS_EX_*) ---`n"
            results .= "Hex Value: 0x" . Format("{:08X}", exStyle) . "`n"
            results .= "Decimal Value: " . exStyle . "`n`n"

            results .= "Extended Styles:`n"
            results .= "  WS_EX_CLIENTEDGE (0x00000200): " . (exStyle & 0x00000200 ? "Yes" : "No") . "`n"
            results .= "  WS_EX_STATICEDGE (0x00020000): " . (exStyle & 0x00020000 ? "Yes" : "No") . "`n"
            results .= "  WS_EX_TRANSPARENT (0x00000020): " . (exStyle & 0x00000020 ? "Yes" : "No") . "`n"
            results .= "  WS_EX_ACCEPTFILES (0x00000010): " . (exStyle & 0x00000010 ? "Yes" : "No") . "`n"

            ; Control-specific styles based on class
            if (InStr(ctrlClass, "Edit")) {
                results .= "`n--- EDIT CONTROL STYLES ---`n"
                results .= "  ES_MULTILINE (0x0004): " . (style & 0x0004 ? "Yes" : "No") . "`n"
                results .= "  ES_READONLY (0x0800): " . (style & 0x0800 ? "Yes" : "No") . "`n"
                results .= "  ES_PASSWORD (0x0020): " . (style & 0x0020 ? "Yes" : "No") . "`n"
                results .= "  ES_NUMBER (0x2000): " . (style & 0x2000 ? "Yes" : "No") . "`n"
                results .= "  ES_AUTOHSCROLL (0x0080): " . (style & 0x0080 ? "Yes" : "No") . "`n"
                results .= "  ES_AUTOVSCROLL (0x0040): " . (style & 0x0040 ? "Yes" : "No") . "`n"
            } else if (InStr(ctrlClass, "Button")) {
                results .= "`n--- BUTTON CONTROL STYLES ---`n"
                buttonType := style & 0xF
                results .= "  Button Type: "
                switch buttonType {
                    case 0: results .= "BS_PUSHBUTTON`n"
                    case 1: results .= "BS_DEFPUSHBUTTON`n"
                    case 2: results .= "BS_CHECKBOX`n"
                    case 3: results .= "BS_AUTOCHECKBOX`n"
                    case 4: results .= "BS_RADIOBUTTON`n"
                    case 5: results .= "BS_3STATE`n"
                    case 6: results .= "BS_AUTO3STATE`n"
                    case 7: results .= "BS_GROUPBOX`n"
                    case 8: results .= "BS_AUTORADIOBUTTON`n"
                    default: results .= "Unknown (" . buttonType . ")`n"
                }
            }

            ResultsEdit.Value := results

        } catch as err {
            MsgBox("Error analyzing control:`n" . err.Message, "Error", "IconX")
        }
    }
}

;==============================================================================
; Example 4: Comparing Styles Before and After
;==============================================================================

/**
 * Demonstrates comparing control styles before and after changes
 * 
 * @example
 * Shows how styles change when controls are modified
 */
Example4_StyleComparison() {
    MyGui := Gui("+Resize", "Example 4: Style Comparison")

    MyGui.Add("Text", "w400", "Compare control styles before and after modifications:")

    ; Create test controls
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test Edit Control")
    TestBtn := MyGui.Add("Button", "w300 y+10", "Test Button")

    ; Control buttons
    BtnDisable := MyGui.Add("Button", "w140 y+20", "Disable Edit")
    BtnDisable.OnEvent("Click", (*) => DisableControl(TestEdit))

    BtnEnable := MyGui.Add("Button", "x+10 w140", "Enable Edit")
    BtnEnable.OnEvent("Click", (*) => EnableControl(TestEdit))

    BtnReadOnly := MyGui.Add("Button", "xm y+10 w140", "Make ReadOnly")
    BtnReadOnly.OnEvent("Click", (*) => MakeReadOnly(TestEdit))

    BtnEditable := MyGui.Add("Button", "x+10 w140", "Make Editable")
    BtnEditable.OnEvent("Click", (*) => MakeEditable(TestEdit))

    ; Results display
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    MyGui.Show()

    ; Update display initially
    UpdateStyleDisplay()

    DisableControl(ctrl) {
        beforeStyle := ControlGetStyle(ctrl)
        ctrl.Enabled := false
        afterStyle := ControlGetStyle(ctrl)
        ShowStyleChange("Disabled Control", beforeStyle, afterStyle)
    }

    EnableControl(ctrl) {
        beforeStyle := ControlGetStyle(ctrl)
        ctrl.Enabled := true
        afterStyle := ControlGetStyle(ctrl)
        ShowStyleChange("Enabled Control", beforeStyle, afterStyle)
    }

    MakeReadOnly(ctrl) {
        beforeStyle := ControlGetStyle(ctrl)
        ctrl.Opt("+ReadOnly")
        afterStyle := ControlGetStyle(ctrl)
        ShowStyleChange("Made ReadOnly", beforeStyle, afterStyle)
    }

    MakeEditable(ctrl) {
        beforeStyle := ControlGetStyle(ctrl)
        ctrl.Opt("-ReadOnly")
        afterStyle := ControlGetStyle(ctrl)
        ShowStyleChange("Made Editable", beforeStyle, afterStyle)
    }

    ShowStyleChange(action, before, after) {
        result := "=== " . action . " ===`n`n"
        result .= "Before:`n"
        result .= "  Hex: 0x" . Format("{:08X}", before) . "`n"
        result .= "  Dec: " . before . "`n"
        result .= "  Disabled: " . (before & 0x08000000 ? "Yes" : "No") . "`n"
        result .= "  ReadOnly: " . (before & 0x0800 ? "Yes" : "No") . "`n`n"

        result .= "After:`n"
        result .= "  Hex: 0x" . Format("{:08X}", after) . "`n"
        result .= "  Dec: " . after . "`n"
        result .= "  Disabled: " . (after & 0x08000000 ? "Yes" : "No") . "`n"
        result .= "  ReadOnly: " . (after & 0x0800 ? "Yes" : "No") . "`n`n"

        result .= "Changed Bits:`n"
        changed := before ^ after  ; XOR to find changed bits
        result .= "  Hex: 0x" . Format("{:08X}", changed) . "`n"
        result .= "  Dec: " . changed . "`n`n"

        ResultsEdit.Value := result . "`n" . ResultsEdit.Value
    }

    UpdateStyleDisplay() {
        style := ControlGetStyle(TestEdit)
        result := "Initial Style:`n"
        result .= "  Hex: 0x" . Format("{:08X}", style) . "`n"
        result .= "  Dec: " . style . "`n"
        ResultsEdit.Value := result
    }
}

;==============================================================================
; Example 5: Bulk Style Reading
;==============================================================================

/**
 * Demonstrates reading styles from multiple controls at once
 * 
 * @example
 * Shows how to read and compare styles across multiple controls
 */
Example5_BulkStyleReading() {
    MyGui := Gui("+Resize", "Example 5: Bulk Style Reading")

    MyGui.Add("Text", "w400", "Read styles from multiple controls simultaneously:")

    ; Create multiple test controls
    controls := []
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 y+20", "Edit 1"), name: "Edit 1" })
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 y+10 ReadOnly", "Edit 2 (ReadOnly)"), name: "Edit 2" })
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 y+10 Multi", "Edit 3`n(Multiline)"), name: "Edit 3" })
    controls.Push({ ctrl: MyGui.Add("Button", "w300 y+10", "Button 1"), name: "Button 1" })
    controls.Push({ ctrl: MyGui.Add("Button", "w300 y+10 Default", "Button 2 (Default)"), name: "Button 2" })
    controls.Push({ ctrl: MyGui.Add("Checkbox", "y+10", "Checkbox"), name: "Checkbox" })
    controls.Push({ ctrl: MyGui.Add("Radio", "y+10", "Radio Button"), name: "Radio" })

    BtnAnalyze := MyGui.Add("Button", "w200 y+20", "Analyze All Controls")
    BtnAnalyze.OnEvent("Click", AnalyzeAll)

    ResultsEdit := MyGui.Add("Edit", "w600 h300 y+10 ReadOnly Multi")

    MyGui.Show()

    AnalyzeAll(*) {
        results := "=== BULK STYLE ANALYSIS ===`n`n"
        results .= "Total Controls: " . controls.Length . "`n`n"

        ; Create summary table
        results .= Format("{:-<70}", "") . "`n"
        results .= Format("{:<20} {:<15} {:<12} {:<10}", "Control", "Style (Hex)", "Visible", "Disabled") . "`n"
        results .= Format("{:-<70}", "") . "`n"

        for index, item in controls {
            try {
                style := ControlGetStyle(item.ctrl)
                visible := (style & 0x10000000) ? "Yes" : "No"
                disabled := (style & 0x08000000) ? "Yes" : "No"

                results .= Format("{:<20} {:<15} {:<12} {:<10}",
                    item.name,
                    "0x" . Format("{:08X}", style),
                    visible,
                    disabled) . "`n"
            } catch as err {
                results .= Format("{:<20} {:<15}", item.name, "ERROR") . "`n"
            }
        }

        results .= Format("{:-<70}", "") . "`n`n"

        ; Detailed analysis
        results .= "=== DETAILED ANALYSIS ===`n`n"

        for index, item in controls {
            try {
                style := ControlGetStyle(item.ctrl)
                results .= item.name . ":`n"
                results .= "  Hex: 0x" . Format("{:08X}", style) . "`n"
                results .= "  Dec: " . style . "`n"
                results .= "  Binary: " . DecToBin(style) . "`n`n"
            }
        }

        ResultsEdit.Value := results
    }

    ; Helper function to convert decimal to binary string
    DecToBin(dec) {
        bin := ""
        while (dec > 0) {
            bin := Mod(dec, 2) . bin
            dec := dec // 2
        }
        return bin != "" ? bin : "0"
    }
}

;==============================================================================
; Example 6: Style Monitoring
;==============================================================================

/**
 * Demonstrates monitoring control styles for changes
 * 
 * @example
 * Shows how to monitor and log style changes over time
 */
Example6_StyleMonitoring() {
    MyGui := Gui("+Resize", "Example 6: Style Monitoring")

    MyGui.Add("Text", "w400", "Monitor control styles for changes:")

    ; Test control
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Monitored Control")

    ; Modification buttons
    MyGui.Add("Text", "xm y+20", "Make changes to see monitoring in action:")

    BtnToggleEnabled := MyGui.Add("Button", "w140 y+10", "Toggle Enabled")
    BtnToggleEnabled.OnEvent("Click", (*) => ToggleEnabled())

    BtnToggleReadOnly := MyGui.Add("Button", "x+10 w140", "Toggle ReadOnly")
    BtnToggleReadOnly.OnEvent("Click", (*) => ToggleReadOnly())

    ; Monitoring controls
    BtnStart := MyGui.Add("Button", "xm y+20 w140", "Start Monitoring")
    BtnStart.OnEvent("Click", (*) => StartMonitoring())

    BtnStop := MyGui.Add("Button", "x+10 w140", "Stop Monitoring")
    BtnStop.OnEvent("Click", (*) => StopMonitoring())

    BtnClear := MyGui.Add("Button", "x+10 w140", "Clear Log")
    BtnClear.OnEvent("Click", (*) => LogEdit.Value := "")

    ; Status display
    StatusText := MyGui.Add("Text", "xm y+10 w400", "Status: Not Monitoring")

    ; Log display
    LogEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    MyGui.Show()

    monitoring := false
    lastStyle := 0
    monitorTimer := 0

    StartMonitoring() {
        if (monitoring)
            return

        monitoring := true
        lastStyle := ControlGetStyle(TestEdit)
        StatusText.Value := "Status: Monitoring... (checking every 250ms)"
        LogMessage("Monitoring started - Initial style: 0x" . Format("{:08X}", lastStyle))

        ; Set timer to check every 250ms
        SetTimer(CheckStyle, 250)
    }

    StopMonitoring() {
        if (!monitoring)
            return

        monitoring := false
        SetTimer(CheckStyle, 0)
        StatusText.Value := "Status: Not Monitoring"
        LogMessage("Monitoring stopped")
    }

    CheckStyle() {
        if (!monitoring)
            return

        try {
            currentStyle := ControlGetStyle(TestEdit)

            if (currentStyle != lastStyle) {
                changed := lastStyle ^ currentStyle
                LogMessage("Style changed!")
                LogMessage("  Previous: 0x" . Format("{:08X}", lastStyle))
                LogMessage("  Current:  0x" . Format("{:08X}", currentStyle))
                LogMessage("  Changed:  0x" . Format("{:08X}", changed))
                LogMessage("  Disabled: " . (currentStyle & 0x08000000 ? "Yes" : "No"))
                LogMessage("  ReadOnly: " . (currentStyle & 0x0800 ? "Yes" : "No"))
                LogMessage("")

                lastStyle := currentStyle
            }
        }
    }

    ToggleEnabled() {
        TestEdit.Enabled := !TestEdit.Enabled
    }

    ToggleReadOnly() {
        style := ControlGetStyle(TestEdit)
        if (style & 0x0800)
            TestEdit.Opt("-ReadOnly")
        else
            TestEdit.Opt("+ReadOnly")
    }

    LogMessage(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        LogEdit.Value .= "[" . timestamp . "] " . msg . "`n"
        ; Auto-scroll to bottom
        Send("{End}")
    }
}

;==============================================================================
; Example 7: Style Helper Class
;==============================================================================

/**
 * Demonstrates a helper class for working with control styles
 * 
 * @example
 * Shows how to create a reusable class for style operations
 */
Example7_StyleHelperClass() {
    /**
     * Helper class for control style operations
     */

    ; Demo the helper class
    MyGui := Gui("+Resize", "Example 7: Style Helper Class")

    MyGui.Add("Text", "w400", "Demonstrating ControlStyleHelper class:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test Control")
    TestBtn := MyGui.Add("Button", "w300 y+10", "Test Button")

    BtnAnalyze := MyGui.Add("Button", "w200 y+20", "Analyze with Helper")
    BtnAnalyze.OnEvent("Click", Analyze)

    BtnCheckFlag := MyGui.Add("Button", "x+10 w200", "Check Specific Flag")
    BtnCheckFlag.OnEvent("Click", CheckFlag)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    MyGui.Show()

    Analyze(*) {
        results := "=== Using ControlStyleHelper ===`n`n"

        results .= "Test Edit Control:`n"
        results .= ControlStyleHelper.ToString(TestEdit)
        results .= "`nSet Flags: " . ArrayToString(ControlStyleHelper.GetSetFlags(TestEdit))
        results .= "`n`n"

        results .= "Test Button Control:`n"
        results .= ControlStyleHelper.ToString(TestBtn)
        results .= "`nSet Flags: " . ArrayToString(ControlStyleHelper.GetSetFlags(TestBtn))

        ResultsEdit.Value := results
    }

    CheckFlag(*) {
        ; Check for WS_TABSTOP flag
        WS_TABSTOP := 0x00010000

        editHasTabStop := ControlStyleHelper.HasStyle(TestEdit, WS_TABSTOP)
        btnHasTabStop := ControlStyleHelper.HasStyle(TestBtn, WS_TABSTOP)

        result := "Checking WS_TABSTOP flag (0x00010000):`n`n"
        result .= "Edit Control: " . (editHasTabStop ? "Has TabStop" : "No TabStop") . "`n"
        result .= "Button Control: " . (btnHasTabStop ? "Has TabStop" : "No TabStop") . "`n"

        ResultsEdit.Value := result
    }

    ArrayToString(arr) {
        if (arr.Length = 0)
            return "None"
        str := ""
        for item in arr
            str .= item . ", "
        return SubStr(str, 1, -2)
    }
}

;==============================================================================
; Main Menu - Run any example
;==============================================================================

; Create main menu
MainGui := Gui("+Resize", "ControlGetStyle Examples - Main Menu")
MainGui.Add("Text", "w400", "Select an example to run:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Basic Style Reading",
    "Example 2: Detecting Style Flags",
    "Example 3: Style Analyzer Utility",
    "Example 4: Style Comparison",
    "Example 5: Bulk Style Reading",
    "Example 6: Style Monitoring",
    "Example 7: Style Helper Class"
])

btnRun := MainGui.Add("Button", "w200 y+20", "Run Example")
btnRun.OnEvent("Click", RunSelected)

btnExit := MainGui.Add("Button", "x+10 w200", "Exit")
btnExit.OnEvent("Click", (*) => ExitApp())

MainGui.Show()

RunSelected(*) {
    selected := examplesList.Value
    if (selected = 0) {
        MsgBox("Please select an example first", "Info", "Iconi")
        return
    }

    switch selected {
        case 1: Example1_BasicStyleReading()
        case 2: Example2_DetectingStyleFlags()
        case 3: Example3_StyleAnalyzer()
        case 4: Example4_StyleComparison()
        case 5: Example5_BulkStyleReading()
        case 6: Example6_StyleMonitoring()
        case 7: Example7_StyleHelperClass()
    }
}

return

; Moved class ControlStyleHelper from nested scope
class ControlStyleHelper {
    /**
     * Gets formatted style information
     * @param {Object} ctrl - The control object
     * @returns {Object} Style information object
     */
    static GetStyleInfo(ctrl) {
        style := ControlGetStyle(ctrl)
        exStyle := ControlGetExStyle(ctrl)

        return {
            style: style,
            styleHex: Format("0x{:08X}", style),
            exStyle: exStyle,
            exStyleHex: Format("0x{:08X}", exStyle),
            visible: !!(style & 0x10000000),
            disabled: !!(style & 0x08000000),
            tabStop: !!(style & 0x00010000),
            border: !!(style & 0x00800000)
        }
    }

    /**
     * Checks if a specific style flag is set
     * @param {Object} ctrl - The control object
     * @param {Number} flag - The style flag to check
     * @returns {Boolean} True if flag is set
     */
    static HasStyle(ctrl, flag) {
        style := ControlGetStyle(ctrl)
        return !!(style & flag)
    }

    /**
     * Gets all set style flags as array
     * @param {Object} ctrl - The control object
     * @returns {Array} Array of set flags
     */
    static GetSetFlags(ctrl) {
        style := ControlGetStyle(ctrl)
        flags := []

        ; Common flags
        commonFlags := Map(
            "WS_VISIBLE", 0x10000000,
            "WS_DISABLED", 0x08000000,
            "WS_TABSTOP", 0x00010000,
            "WS_GROUP", 0x00020000,
            "WS_BORDER", 0x00800000
        )

        for name, value in commonFlags {
            if (style & value)
                flags.Push(name)
        }

        return flags
    }

    /**
     * Formats style info as readable string
     * @param {Object} ctrl - The control object
     * @returns {String} Formatted string
     */
    static ToString(ctrl) {
        info := this.GetStyleInfo(ctrl)
        str := "Style: " . info.styleHex . "`n"
        str .= "ExStyle: " . info.exStyleHex . "`n"
        str .= "Visible: " . (info.visible ? "Yes" : "No") . "`n"
        str .= "Disabled: " . (info.disabled ? "Yes" : "No") . "`n"
        str .= "TabStop: " . (info.tabStop ? "Yes" : "No") . "`n"
        return str
    }
}
