#Requires AutoHotkey v2.0

/**
* ControlGetVisible - Practical Applications
*
* Comprehensive examples for AutoHotkey v2.0
* @author AutoHotkey Community
* @date 2025-01-16
* @version 1.0.0
*/


;==============================================================================
; Example 1: Responsive UI
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Responsive UI")
    MyGui.Add("Text", "w500", "Check visibility for responsive layouts:")

    Normal := MyGui.Add("Edit", "w300 y+20", "Normal View")
    Compact := MyGui.Add("Edit", "w300 y+10", "Compact View")
    Compact.Visible := false
    BtnNormal := MyGui.Add("Button", "xm y+20 w140", "Normal Mode")
    BtnNormal.OnEvent("Click", (*) => SetMode(true))
    BtnCompact := MyGui.Add("Button", "x+10 w140", "Compact Mode")
    BtnCompact.OnEvent("Click", (*) => SetMode(false))
    BtnCheck := MyGui.Add("Button", "xm y+10 w290", "Check Current Mode")
    BtnCheck.OnEvent("Click", CheckMode)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    SetMode(normal) {
        Normal.Visible := normal
        Compact.Visible := !normal
    }
    CheckMode(*) {
        if (ControlGetVisible(Normal))
        ResultsEdit.Value := "Mode: Normal\n" . ResultsEdit.Value
        else
        ResultsEdit.Value := "Mode: Compact\n" . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Feature Toggles
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Feature Toggles")
    MyGui.Add("Text", "w500", "Check feature visibility:")

    features := Map()
    features["Basic"] := MyGui.Add("Edit", "w200 y+20", "Basic")
    features["Advanced"] := MyGui.Add("Edit", "w200 y+10", "Advanced")
    features["Expert"] := MyGui.Add("Edit", "w200 y+10", "Expert")
    features["Advanced"].Visible := false
    features["Expert"].Visible := false
    Level := MyGui.Add("DropDownList", "xm y+20 w200", ["Basic", "Advanced", "Expert"])
    Level.Choose(1)
    Level.OnEvent("Change", UpdateLevel)
    BtnCheck := MyGui.Add("Button", "xm y+10 w200", "Check Features")
    BtnCheck.OnEvent("Click", CheckFeatures)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    UpdateLevel(*) {
        level := Level.Text
        features["Basic"].Visible := true
        features["Advanced"].Visible := (level = "Advanced" || level = "Expert")
        features["Expert"].Visible := (level = "Expert")
    }
    CheckFeatures(*) {
        result := "Active Features:\n"
        for name, ctrl in features {
            if (ControlGetVisible(ctrl))
            result .= "  ✓ " . name . "\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Progressive Disclosure
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Progressive Disclosure")
    MyGui.Add("Text", "w500", "Check revealed elements:")

    steps := []
    loop 4
    steps.Push(MyGui.Add("Edit", "w250 y+10", "Step " . A_Index))
    for i, step in steps
    if (i > 1)
    step.Visible := false
    current := 1
    BtnNext := MyGui.Add("Button", "xm y+20 w200", "Reveal Next")
    BtnNext.OnEvent("Click", Next)
    BtnCheck := MyGui.Add("Button", "x+10 w200", "Check Progress")
    BtnCheck.OnEvent("Click", Check)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h200 ReadOnly Multi")
    Next(*) {
        if (current < steps.Length) {
            current++
            steps[current].Visible := true
        }
    }
    Check(*) {
        result := "Progress:\n"
        for i, step in steps {
            vis := ControlGetVisible(step)
            result .= "Step " . i . ": " . (vis ? "✓ Visible" : "✗ Hidden") . "\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Context-Sensitive UI
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Context-Sensitive UI")
    MyGui.Add("Text", "w500", "Check context-based visibility:")

    Type := MyGui.Add("DropDownList", "w200 y+20", ["Text", "Number", "Date"])
    TextOpts := MyGui.Add("Edit", "xm y+10 w200", "Text Options")
    NumberOpts := MyGui.Add("Edit", "xm y+10 w200", "Number Options")
    DateOpts := MyGui.Add("Edit", "xm y+10 w200", "Date Options")
    Type.Choose(1)
    Type.OnEvent("Change", UpdateOpts)
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Visible")
    BtnCheck.OnEvent("Click", CheckVis)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    UpdateOpts(*) {
        t := Type.Text
        TextOpts.Visible := (t = "Text")
        NumberOpts.Visible := (t = "Number")
        DateOpts.Visible := (t = "Date")
    }
    CheckVis(*) {
        if (ControlGetVisible(TextOpts))
        ResultsEdit.Value := "Showing: Text Options\n" . ResultsEdit.Value
        else if (ControlGetVisible(NumberOpts))
        ResultsEdit.Value := "Showing: Number Options\n" . ResultsEdit.Value
        else if (ControlGetVisible(DateOpts))
        ResultsEdit.Value := "Showing: Date Options\n" . ResultsEdit.Value
    }
    UpdateOpts()

    MyGui.Show()
}

;==============================================================================
; Example 5: UI State Machine
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: UI State Machine")
    MyGui.Add("Text", "w500", "Track UI state transitions:")

    states := Map("idle", [], "loading", [], "error", [])
    states["idle"].Push(MyGui.Add("Text", "xm y+20 w300", "Ready"))
    states["loading"].Push(MyGui.Add("Text", "xm y+20 w300", "Loading..."))
    states["error"].Push(MyGui.Add("Text", "xm y+20 w300", "Error occurred"))
    currentState := "idle"
    BtnLoad := MyGui.Add("Button", "xm y+60 w140", "Load")
    BtnLoad.OnEvent("Click", (*) => SetState("loading"))
    BtnError := MyGui.Add("Button", "x+10 w140", "Error")
    BtnError.OnEvent("Click", (*) => SetState("error"))
    BtnReset := MyGui.Add("Button", "x+10 w140", "Reset")
    BtnReset.OnEvent("Click", (*) => SetState("idle"))
    BtnCheck := MyGui.Add("Button", "xm y+10 w430", "Check State")
    BtnCheck.OnEvent("Click", CheckState)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h150 ReadOnly Multi")
    SetState(newState) {
        for state, controls in states {
            for ctrl in controls
            ctrl.Visible := (state = newState)
        }
        currentState := newState
    }
    CheckState(*) {
        ResultsEdit.Value := "Current State: " . currentState . "\n" . ResultsEdit.Value
    }
    SetState("idle")

    MyGui.Show()
}

;==============================================================================
; Example 6: Accessibility Audit
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Accessibility Audit")
    MyGui.Add("Text", "w500", "Audit visible/hidden controls:")

    controls := Map()
    controls["Username"] := MyGui.Add("Edit", "w200 y+20")
    controls["Password"] := MyGui.Add("Edit", "w200 y+10 Password")
    controls["Email"] := MyGui.Add("Edit", "w200 y+10")
    controls["Optional1"] := MyGui.Add("Edit", "w200 y+10")
    controls["Optional2"] := MyGui.Add("Edit", "w200 y+10")
    controls["Optional1"].Visible := false
    controls["Optional2"].Visible := false
    BtnAudit := MyGui.Add("Button", "xm y+20 w200", "Run Audit")
    BtnAudit.OnEvent("Click", Audit)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    Audit(*) {
        report := "=== ACCESSIBILITY AUDIT ===\n\n"
        visCount := 0
        hidCount := 0
        for name, ctrl in controls {
            vis := ControlGetVisible(ctrl)
            if (vis) {
                visCount++
                if (StrLen(ctrl.Value) = 0)
                report .= "⚠ " . name . " is visible but empty\n"
            } else {
                hidCount++
            }
        }
        report .= "\nSummary:\n"
        report .= "  Visible: " . visCount . "\n"
        report .= "  Hidden: " . hidCount . "\n"
        ResultsEdit.Value := report
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: External Window Check
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: External Window Check")
    MyGui.Add("Text", "w500", "Check external window controls:")

    MyGui.Add("Text", "xm y+20", "Window:")
    WinEdit := MyGui.Add("Edit", "x+10 w250")
    MyGui.Add("Text", "xm y+10", "Control:")
    CtrlEdit := MyGui.Add("Edit", "x+10 w250")
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Visibility")
    BtnCheck.OnEvent("Click", CheckExt)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    CheckExt(*) {
        try {
            vis := ControlGetVisible(CtrlEdit.Value, WinEdit.Value)
            ResultsEdit.Value := "Visible: " . (vis ? "Yes" : "No") . "\n" . ResultsEdit.Value
        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
"Example 1: Responsive UI",
"Example 2: Feature Toggles",
"Example 3: Progressive Disclosure",
"Example 4: Context-Sensitive UI",
"Example 5: UI State Machine",
"Example 6: Accessibility Audit",
"Example 7: External Window Check",
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
