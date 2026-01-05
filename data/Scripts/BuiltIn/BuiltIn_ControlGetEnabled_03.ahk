#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlGetEnabled - Real-World Applications
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: External Window Check
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: External Window Check")
    MyGui.Add("Text", "w500", "Check enabled state in external apps:")

    MyGui.Add("Text", "xm y+20", "Window Title:")
    WinEdit := MyGui.Add("Edit", "x+10 w300")
    MyGui.Add("Text", "xm y+10", "Control ClassNN:")
    CtrlEdit := MyGui.Add("Edit", "x+10 w300")
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check State")
    BtnCheck.OnEvent("Click", CheckExt)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    CheckExt(*) {
        try {
            enabled := ControlGetEnabled(CtrlEdit.Value, WinEdit.Value)
            ResultsEdit.Value := "Enabled: " . (enabled ? "Yes" : "No") . "\n" . ResultsEdit.Value
        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Form Validation
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Form Validation")
    MyGui.Add("Text", "w500", "Validate form completion:")

    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Field " . A_Index))
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Validate Form")
    BtnValidate.OnEvent("Click", Validate)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    Validate(*) {
        result := "Checking form...\n"
        for i, ctrl in controls {
            if (!ControlGetEnabled(ctrl))
                result .= "Field " . i . " is disabled\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: State-Based Actions
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: State-Based Actions")
    MyGui.Add("Text", "w500", "Perform actions based on state:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test")
    BtnAction := MyGui.Add("Button", "xm y+20 w200", "Smart Action")
    BtnAction.OnEvent("Click", SmartAction)
    BtnToggle := MyGui.Add("Button", "x+10 w200", "Toggle")
    BtnToggle.OnEvent("Click", (*) => TestEdit.Enabled := !TestEdit.Enabled)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    SmartAction(*) {
        if (ControlGetEnabled(TestEdit)) {
            text := TestEdit.Value
            ResultsEdit.Value := "Processing: " . text . "\n" . ResultsEdit.Value
        } else {
            ResultsEdit.Value := "Cannot process - control disabled\n" . ResultsEdit.Value
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Accessibility Report
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Accessibility Report")
    MyGui.Add("Text", "w500", "Generate accessibility report:")

    controls := Map()
    controls["Username"] := MyGui.Add("Edit", "w200 y+20")
    controls["Password"] := MyGui.Add("Edit", "w200 y+10 Password")
    controls["Email"] := MyGui.Add("Edit", "w200 y+10")
    controls[2].Enabled := false
    BtnReport := MyGui.Add("Button", "xm y+20 w200", "Accessibility Report")
    BtnReport.OnEvent("Click", Report)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    Report(*) {
        reportText := "=== ACCESSIBILITY REPORT ===\n\n"
        issues := 0
        for name, ctrl in controls {
            if (!ControlGetEnabled(ctrl)) {
                reportText .= "⚠ " . name . " is disabled\n"
                issues++
            }
        }
        reportText .= "\nTotal Issues: " . issues . "\n"
        ResultsEdit.Value := reportText
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Wizard Step Control
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Wizard Step Control")
    MyGui.Add("Text", "w500", "Control wizard steps:")

    steps := []
    loop 3
        steps.Push(MyGui.Add("Edit", "w300 y+10", "Step " . A_Index))
    for i, step in steps
        if (i > 1)
            step.Enabled := false
    currentStep := 1
    BtnNext := MyGui.Add("Button", "xm y+20 w200", "Next Step")
    BtnNext.OnEvent("Click", NextStep)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "Current Step: 1")
    NextStep(*) {
        if (currentStep < steps.Length) {
            currentStep++
            steps[currentStep].Enabled := true
            StatusText.Value := "Current Step: " . currentStep
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Conditional Enable
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Conditional Enable")
    MyGui.Add("Text", "w500", "Enable based on conditions:")

    Age := MyGui.Add("Edit", "w200 y+20", "")
    Consent := MyGui.Add("Checkbox", "xm y+10", "I agree")
    Submit := MyGui.Add("Button", "xm y+10 w200", "Submit")
    Submit.Enabled := false
    Age.OnEvent("Change", Check)
    Consent.OnEvent("Click", Check)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    Check(*) {
        if (Age.Value >= 18 && Consent.Value) {
            Submit.Enabled := true
            ResultsEdit.Value := "Form ready\n" . ResultsEdit.Value
        } else {
            Submit.Enabled := false
        }
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: State Debugger
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: State Debugger")
    MyGui.Add("Text", "w500", "Debug control states:")

    controls := []
    loop 4
        controls.Push(MyGui.Add("Edit", "w150 " . (Mod(A_Index, 2) = 1 ? "xm" : "x+10") . " y" . (Mod(A_Index, 2) = 1 ? "+20" : "+0"), A_Index))
    BtnDebug := MyGui.Add("Button", "xm y+20 w200", "Debug States")
    BtnDebug.OnEvent("Click", Debug)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h300 ReadOnly Multi")
    Debug(*) {
        result := "=== STATE DEBUG ===\n\n"
        for i, ctrl in controls {
            enabled := ControlGetEnabled(ctrl)
            result .= "Control " . i . ": " . (enabled ? "✓" : "✗") . " | Value: " . ctrl.Value . "\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: External Window Check",
    "Example 2: Form Validation",
    "Example 3: State-Based Actions",
    "Example 4: Accessibility Report",
    "Example 5: Wizard Step Control",
    "Example 6: Conditional Enable",
    "Example 7: State Debugger",
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
