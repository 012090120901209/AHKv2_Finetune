#Requires AutoHotkey v2.0

/**
 * ControlGetVisible - Check Visibility State
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Basic Visibility Check
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Visibility Check")
    MyGui.Add("Text", "w500", "Check if controls are visible:")
    
    Edit1 := MyGui.Add("Edit", "w250 y+20", "Visible")
    Edit2 := MyGui.Add("Edit", "w250 y+10", "Hidden")
    Edit2.Visible := false
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Visibility")
    BtnCheck.OnEvent("Click", CheckVis)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    CheckVis(*) {
        vis1 := ControlGetVisible(Edit1)
        vis2 := ControlGetVisible(Edit2)
        result := "Edit1 Visible: " . (vis1 ? "Yes" : "No") . "\n"
        result .= "Edit2 Visible: " . (vis2 ? "Yes" : "No") . "\n\n"
        ResultsEdit.Value := result . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 2: Toggle and Check
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Toggle and Check")
    MyGui.Add("Text", "w500", "Toggle visibility and verify:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Toggle Me")
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle Visibility")
    BtnToggle.OnEvent("Click", Toggle)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    UpdateStatus()
    Toggle(*) {
        TestEdit.Visible := !TestEdit.Visible
        UpdateStatus()
    }
    UpdateStatus() {
        vis := ControlGetVisible(TestEdit)
        StatusText.Value := "Status: " . (vis ? "Visible" : "Hidden")
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: Multiple Controls
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Multiple Controls")
    MyGui.Add("Text", "w500", "Check visibility of many controls:")
    
    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Edit " . A_Index))
    controls[2].Visible := false
    controls[4].Visible := false
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check All")
    BtnCheck.OnEvent("Click", CheckAll)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    CheckAll(*) {
        result := "=== VISIBILITY CHECK ===\n\n"
        for i, ctrl in controls {
            vis := ControlGetVisible(ctrl)
            result .= "Edit " . i . ": " . (vis ? "✓ Visible" : "✗ Hidden") . "\n"
        }
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: Conditional Display
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Conditional Display")
    MyGui.Add("Text", "w500", "Show based on visibility:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test")
    BtnAction := MyGui.Add("Button", "xm y+20 w200", "Conditional Action")
    BtnAction.OnEvent("Click", Action)
    BtnToggle := MyGui.Add("Button", "x+10 w200", "Toggle Visibility")
    BtnToggle.OnEvent("Click", (*) => TestEdit.Visible := !TestEdit.Visible)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    Action(*) {
        if (ControlGetVisible(TestEdit))
            ResultsEdit.Value := "Action: Control is visible\n" . ResultsEdit.Value
        else
            ResultsEdit.Value := "Action: Control is hidden\n" . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: State Monitor
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: State Monitor")
    MyGui.Add("Text", "w500", "Monitor visibility changes:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Monitored")
    BtnStart := MyGui.Add("Button", "xm y+20 w140", "Start Monitor")
    BtnStart.OnEvent("Click", StartMon)
    BtnStop := MyGui.Add("Button", "x+10 w140", "Stop Monitor")
    BtnStop.OnEvent("Click", StopMon)
    BtnToggle := MyGui.Add("Button", "x+10 w140", "Toggle")
    BtnToggle.OnEvent("Click", (*) => TestEdit.Visible := !TestEdit.Visible)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h200 ReadOnly Multi")
    monitoring := false
    lastState := true
    StartMon(*) {
        monitoring := true
        lastState := ControlGetVisible(TestEdit)
        SetTimer(Check, 250)
        ResultsEdit.Value := "Monitoring started\n" . ResultsEdit.Value
    }
    StopMon(*) {
        monitoring := false
        SetTimer(Check, 0)
        ResultsEdit.Value := "Monitoring stopped\n" . ResultsEdit.Value
    }
    Check() {
        if (!monitoring)
            return
        current := ControlGetVisible(TestEdit)
        if (current != lastState) {
            ResultsEdit.Value := "Changed: " . (current ? "Visible" : "Hidden") . "\n" . ResultsEdit.Value
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
    MyGui.Add("Text", "w500", "Validate visible fields:")
    
    controls := Map()
    controls["Required1"] := MyGui.Add("Edit", "w200 y+20")
    controls["Required2"] := MyGui.Add("Edit", "w200 y+10")
    controls["Optional"] := MyGui.Add("Edit", "w200 y+10")
    controls["Optional"].Visible := false
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Validate Form")
    BtnValidate.OnEvent("Click", Validate)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    Validate(*) {
        result := "=== VALIDATION ===\n\n"
        valid := true
        for name, ctrl in controls {
            if (ControlGetVisible(ctrl) && StrLen(ctrl.Value) = 0) {
                result .= "✗ " . name . " is empty\n"
                valid := false
            }
        }
        result .= "\nResult: " . (valid ? "✓ Valid" : "✗ Invalid") . "\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: UI State Report
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: UI State Report")
    MyGui.Add("Text", "w500", "Generate visibility report:")
    
    controls := []
    loop 6
        controls.Push(MyGui.Add("Edit", "w150 " . (Mod(A_Index, 3) = 1 ? "xm" : "x+10") . " y" . (Mod(A_Index-1, 3) = 0 ? "+20" : "+0"), A_Index))
    controls[2].Visible := false
    controls[4].Visible := false
    controls[6].Visible := false
    BtnReport := MyGui.Add("Button", "xm y+60 w200", "Generate Report")
    BtnReport.OnEvent("Click", Report)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    Report(*) {
        report := "=== VISIBILITY REPORT ===\n\n"
        visCount := 0
        for i, ctrl in controls {
            vis := ControlGetVisible(ctrl)
            report .= "Control " . i . ": " . (vis ? "Visible" : "Hidden") . "\n"
            if (vis)
                visCount++
        }
        report .= "\nSummary: " . visCount . "/" . controls.Length . " visible\n"
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
    "Example 1: Basic Visibility Check",
    "Example 2: Toggle and Check",
    "Example 3: Multiple Controls",
    "Example 4: Conditional Display",
    "Example 5: State Monitor",
    "Example 6: Form Validation",
    "Example 7: UI State Report",
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
