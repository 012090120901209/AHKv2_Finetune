#Requires AutoHotkey v2.0

/**
 * ControlGetChecked - Get Checkbox/Radio State
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Basic Checked State
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Checked State")
    MyGui.Add("Text", "w500", "Check if checkbox is checked:")
    
    Check1 := MyGui.Add("Checkbox", "xm y+20", "Check me")
    Check2 := MyGui.Add("Checkbox", "xm y+10", "Check me too")
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Get Checked State")
    BtnCheck.OnEvent("Click", GetState)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    GetState(*) {
        state1 := ControlGetChecked(Check1)
        state2 := ControlGetChecked(Check2)
        result := "Check1: " . (state1 ? "Checked" : "Unchecked") . "\n"
        result .= "Check2: " . (state2 ? "Checked" : "Unchecked") . "\n\n"
        ResultsEdit.Value := result . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 2: Radio Button State
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Radio Button State")
    MyGui.Add("Text", "w500", "Check radio button selection:")
    
    Radio1 := MyGui.Add("Radio", "xm y+20", "Option 1")
    Radio2 := MyGui.Add("Radio", "xm y+10", "Option 2")
    Radio3 := MyGui.Add("Radio", "xm y+10", "Option 3")
    Radio1.Value := 1
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Selection")
    BtnCheck.OnEvent("Click", CheckRadio)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    CheckRadio(*) {
        if (ControlGetChecked(Radio1))
            result := "Selected: Option 1\n"
        else if (ControlGetChecked(Radio2))
            result := "Selected: Option 2\n"
        else if (ControlGetChecked(Radio3))
            result := "Selected: Option 3\n"
        else
            result := "Nothing selected\n"
        ResultsEdit.Value := result . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: Multiple Checkboxes
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Multiple Checkboxes")
    MyGui.Add("Text", "w500", "Check multiple checkboxes:")
    
    checks := []
    loop 5
        checks.Push(MyGui.Add("Checkbox", "xm y+10", "Option " . A_Index))
    BtnCheckAll := MyGui.Add("Button", "xm y+20 w200", "Check All States")
    BtnCheckAll.OnEvent("Click", CheckAll)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    CheckAll(*) {
        result := "=== CHECKBOX STATES ===\n\n"
        checkedCount := 0
        for i, check in checks {
            state := ControlGetChecked(check)
            result .= "Option " . i . ": " . (state ? "✓ Checked" : "✗ Unchecked") . "\n"
            if (state)
                checkedCount++
        }
        result .= "\nTotal Checked: " . checkedCount . "/" . checks.Length . "\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: Conditional Actions
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Conditional Actions")
    MyGui.Add("Text", "w500", "Action based on check state:")
    
    Agreement := MyGui.Add("Checkbox", "xm y+20", "I agree to terms")
    Submit := MyGui.Add("Button", "xm y+20 w200", "Submit")
    Submit.OnEvent("Click", TrySubmit)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    TrySubmit(*) {
        if (ControlGetChecked(Agreement))
            ResultsEdit.Value := "✓ Submitted successfully!\n" . ResultsEdit.Value
        else
            ResultsEdit.Value := "✗ Please agree to terms first\n" . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: State Monitoring
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: State Monitoring")
    MyGui.Add("Text", "w500", "Monitor check state changes:")
    
    TestCheck := MyGui.Add("Checkbox", "xm y+20", "Monitor me")
    BtnStart := MyGui.Add("Button", "xm y+20 w140", "Start Monitor")
    BtnStart.OnEvent("Click", StartMon)
    BtnStop := MyGui.Add("Button", "x+10 w140", "Stop Monitor")
    BtnStop.OnEvent("Click", StopMon)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    monitoring := false
    lastState := 0
    StartMon(*) {
        monitoring := true
        lastState := ControlGetChecked(TestCheck)
        SetTimer(CheckState, 250)
        ResultsEdit.Value := "Monitoring started\n" . ResultsEdit.Value
    }
    StopMon(*) {
        monitoring := false
        SetTimer(CheckState, 0)
        ResultsEdit.Value := "Monitoring stopped\n" . ResultsEdit.Value
    }
    CheckState() {
        if (!monitoring)
            return
        current := ControlGetChecked(TestCheck)
        if (current != lastState) {
            ResultsEdit.Value := "State changed: " . (current ? "Checked" : "Unchecked") . "\n" . ResultsEdit.Value
            lastState := current
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 6: Form Validation
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Form Validation")
    MyGui.Add("Text", "w500", "Validate required checkboxes:")
    
    Required1 := MyGui.Add("Checkbox", "xm y+20", "Required 1")
    Required2 := MyGui.Add("Checkbox", "xm y+10", "Required 2")
    Optional := MyGui.Add("Checkbox", "xm y+10", "Optional")
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Validate Form")
    BtnValidate.OnEvent("Click", Validate)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    Validate(*) {
        result := "=== VALIDATION ===\n\n"
        req1 := ControlGetChecked(Required1)
        req2 := ControlGetChecked(Required2)
        if (!req1)
            result .= "✗ Required 1 not checked\n"
        if (!req2)
            result .= "✗ Required 2 not checked\n"
        if (req1 && req2)
            result .= "✓ Form is valid!\n"
        else
            result .= "\n✗ Form is invalid\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: Summary Report
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Summary Report")
    MyGui.Add("Text", "w500", "Generate check state report:")
    
    categories := Map()
    categories["Features"] := []
    categories["Options"] := []
    loop 3
        categories["Features"].Push(MyGui.Add("Checkbox", "xm y+10", "Feature " . A_Index))
    loop 2
        categories["Options"].Push(MyGui.Add("Checkbox", "xm y+10", "Option " . A_Index))
    BtnReport := MyGui.Add("Button", "xm y+20 w200", "Generate Report")
    BtnReport.OnEvent("Click", Report)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    Report(*) {
        report := "=== SELECTION REPORT ===\n\n"
        for category, checks in categories {
            report .= category . ":\n"
            checkedCount := 0
            for i, check in checks {
                if (ControlGetChecked(check)) {
                    report .= "  ✓ Item " . i . "\n"
                    checkedCount++
                }
            }
            report .= "  Total: " . checkedCount . "/" . checks.Length . "\n\n"
        }
        ResultsEdit.Value := report
    }
    
    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Basic Checked State",
    "Example 2: Radio Button State",
    "Example 3: Multiple Checkboxes",
    "Example 4: Conditional Actions",
    "Example 5: State Monitoring",
    "Example 6: Form Validation",
    "Example 7: Summary Report",
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
