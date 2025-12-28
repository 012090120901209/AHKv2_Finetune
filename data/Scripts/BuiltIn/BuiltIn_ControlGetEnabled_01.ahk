#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ControlGetEnabled - Check Control Enabled State
 * ============================================================================
 * 
 * Demonstrates checking if controls are enabled or disabled.
 * 
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Basic Enabled Check
;==============================================================================

/**
 * Check if control is enabled
 */
Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Enabled Check")
    MyGui.Add("Text", "w500", "Check control enabled state:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test")
    TestBtn := MyGui.Add("Button", "w300 y+10", "Button")

    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Enabled")
    BtnCheck.OnEvent("Click", CheckEnabled)

    BtnToggle := MyGui.Add("Button", "x+10 w200", "Toggle Enable")
    BtnToggle.OnEvent("Click", ToggleEnabled)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    CheckEnabled(*) {
        enabled1 := ControlGetEnabled(TestEdit)
        enabled2 := ControlGetEnabled(TestBtn)

        result := "Edit Enabled: " . (enabled1 ? "Yes" : "No") . "\n"
        result .= "Button Enabled: " . (enabled2 ? "Yes" : "No") . "\n\n"

        ResultsEdit.Value := result . ResultsEdit.Value
    }

    ToggleEnabled(*) {
        TestEdit.Enabled := !TestEdit.Enabled
        TestBtn.Enabled := !TestBtn.Enabled
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Multiple Control Check
;==============================================================================

/**
 * Check multiple controls
 */
Example2() {
    MyGui := Gui("+Resize", "Example 2: Multiple Control Check")
    MyGui.Add("Text", "w500", "Check multiple controls:")

    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index))

    BtnDisableOdd := MyGui.Add("Button", "xm y+20 w180", "Disable Odd")
    BtnDisableOdd.OnEvent("Click", DisableOdd)

    BtnCheckAll := MyGui.Add("Button", "x+10 w180", "Check All")
    BtnCheckAll.OnEvent("Click", CheckAll)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")

    DisableOdd(*) {
        for i, ctrl in controls
            if (Mod(i, 2) = 1)
                ctrl.Enabled := false
    }

    CheckAll(*) {
        result := ""
        for i, ctrl in controls {
            enabled := ControlGetEnabled(ctrl)
            result .= "Edit " . i . ": " . (enabled ? "Enabled" : "Disabled") . "\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Validation Check
;==============================================================================

/**
 * Validate enabled states
 */
Example3() {
    MyGui := Gui("+Resize", "Example 3: Validation Check")
    MyGui.Add("Text", "w500", "Validate control states:")

    Username := MyGui.Add("Edit", "w200 y+20")
    Password := MyGui.Add("Edit", "w200 y+10 Password")
    Submit := MyGui.Add("Button", "w200 y+10", "Submit")
    Submit.Enabled := false

    Username.OnEvent("Change", ValidateForm)
    Password.OnEvent("Change", ValidateForm)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")

    ValidateForm(*) {
        if (StrLen(Username.Value) > 0 && StrLen(Password.Value) > 0) {
            Submit.Enabled := true
            ResultsEdit.Value := "Form valid - Submit enabled\n" . ResultsEdit.Value
        } else {
            Submit.Enabled := false
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Conditional Actions
;==============================================================================

/**
 * Perform actions based on state
 */
Example4() {
    MyGui := Gui("+Resize", "Example 4: Conditional Actions")
    MyGui.Add("Text", "w500", "Conditional actions:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test")

    BtnAction := MyGui.Add("Button", "xm y+20 w200", "Conditional Action")
    BtnAction.OnEvent("Click", ConditionalAction)

    BtnToggle := MyGui.Add("Button", "x+10 w200", "Toggle Enable")
    BtnToggle.OnEvent("Click", (*) => TestEdit.Enabled := !TestEdit.Enabled)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")

    ConditionalAction(*) {
        if (ControlGetEnabled(TestEdit)) {
            ResultsEdit.Value := "Action executed - control is enabled\n" . ResultsEdit.Value
        } else {
            ResultsEdit.Value := "Action blocked - control is disabled\n" . ResultsEdit.Value
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: State Monitoring
;==============================================================================

/**
 * Monitor state changes
 */
Example5() {
    MyGui := Gui("+Resize", "Example 5: State Monitoring")
    MyGui.Add("Text", "w500", "Monitor enabled state:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Monitored")

    BtnStart := MyGui.Add("Button", "xm y+20 w140", "Start Monitor")
    BtnStart.OnEvent("Click", StartMonitor)

    BtnStop := MyGui.Add("Button", "x+10 w140", "Stop Monitor")
    BtnStop.OnEvent("Click", StopMonitor)

    BtnToggle := MyGui.Add("Button", "x+10 w140", "Toggle")
    BtnToggle.OnEvent("Click", (*) => TestEdit.Enabled := !TestEdit.Enabled)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")

    monitoring := false
    lastState := true

    StartMonitor(*) {
        monitoring := true
        lastState := ControlGetEnabled(TestEdit)
        SetTimer(CheckState, 250)
        ResultsEdit.Value := "Monitoring started\n" . ResultsEdit.Value
    }

    StopMonitor(*) {
        monitoring := false
        SetTimer(CheckState, 0)
        ResultsEdit.Value := "Monitoring stopped\n" . ResultsEdit.Value
    }

    CheckState() {
        if (!monitoring)
            return
        currentState := ControlGetEnabled(TestEdit)
        if (currentState != lastState) {
            ResultsEdit.Value := "State changed: " . (currentState ? "Enabled" : "Disabled") . "\n" . ResultsEdit.Value
            lastState := currentState
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Form State Report
;==============================================================================

/**
 * Generate state report
 */
Example6() {
    MyGui := Gui("+Resize", "Example 6: Form State Report")
    MyGui.Add("Text", "w500", "Generate form state report:")

    controls := Map()
    controls["Username"] := MyGui.Add("Edit", "w200 y+20")
    controls["Email"] := MyGui.Add("Edit", "w200 y+10")
    controls["Password"] := MyGui.Add("Edit", "w200 y+10 Password")
    controls["Submit"] := MyGui.Add("Button", "w200 y+10", "Submit")

    BtnReport := MyGui.Add("Button", "xm y+20 w200", "Generate Report")
    BtnReport.OnEvent("Click", GenerateReport)

    BtnToggleAll := MyGui.Add("Button", "x+10 w200", "Toggle All")
    BtnToggleAll.OnEvent("Click", ToggleAll)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    GenerateReport(*) {
        report := "=== FORM STATE REPORT ===\n\n"
        enabledCount := 0

        for name, ctrl in controls {
            enabled := ControlGetEnabled(ctrl)
            report .= name . ": " . (enabled ? "✓ Enabled" : "✗ Disabled") . "\n"
            if (enabled)
                enabledCount++
        }

        report .= "\nSummary: " . enabledCount . "/" . controls.Count . " enabled\n"
        ResultsEdit.Value := report
    }

    ToggleAll(*) {
        for name, ctrl in controls
            ctrl.Enabled := !ctrl.Enabled
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Accessibility Checker
;==============================================================================

/**
 * Check accessibility
 */
Example7() {
    MyGui := Gui("+Resize", "Example 7: Accessibility Checker")
    MyGui.Add("Text", "w500", "Check control accessibility:")

    controls := []
    loop 4
        controls.Push(MyGui.Add("Edit", "w250 y+10", "Field " . A_Index))

    ; Disable some for testing
    controls[2].Enabled := false
    controls[4].Enabled := false

    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Accessibility")
    BtnCheck.OnEvent("Click", CheckAccess)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    CheckAccess(*) {
        result := "=== ACCESSIBILITY CHECK ===\n\n"
        issues := 0

        for i, ctrl in controls {
            enabled := ControlGetEnabled(ctrl)
            if (!enabled) {
                result .= "⚠ Field " . i . " is disabled but visible\n"
                issues++
            } else {
                result .= "✓ Field " . i . " is accessible\n"
            }
        }

        result .= "\nTotal Issues: " . issues . "\n"
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples - Main Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Basic Enabled Check",
    "Example 2: Multiple Control Check",
    "Example 3: Validation Check",
    "Example 4: Conditional Actions",
    "Example 5: State Monitoring",
    "Example 6: Form State Report",
    "Example 7: Accessibility Checker"
])

btnRun := MainGui.Add("Button", "w200 y+20", "Run Example")
btnRun.OnEvent("Click", RunSelected)

btnExit := MainGui.Add("Button", "x+10 w200", "Exit")
btnExit.OnEvent("Click", (*) => ExitApp())

MainGui.Show()

RunSelected(*) {
    selected := examplesList.Value
    if (selected = 0) {
        MsgBox("Please select an example", "Info", "Iconi")
        return
    }

    switch selected {
        case 1: Example1()
        case 2: Example2()
        case 3: Example3()
        case 4: Example4()
        case 5: Example5()
        case 6: Example6()
        case 7: Example7()
    }
}

return
