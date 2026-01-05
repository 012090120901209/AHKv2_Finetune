#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlGetVisible - Advanced Detection
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Parent Visibility
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Parent Visibility")
    MyGui.Add("Text", "w500", "Check parent-child visibility:")

    GroupBox := MyGui.Add("GroupBox", "w300 h150 y+20", "Group")
    Child1 := MyGui.Add("Edit", "xp+10 yp+25 w280", "Child 1")
    Child2 := MyGui.Add("Edit", "xp yp+30 w280", "Child 2")
    BtnHideGroup := MyGui.Add("Button", "xm y+180 w200", "Hide Group")
    BtnHideGroup.OnEvent("Click", (*) => GroupBox.Visible := false)
    BtnCheck := MyGui.Add("Button", "x+10 w200", "Check All")
    BtnCheck.OnEvent("Click", CheckAll)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h200 ReadOnly Multi")
    CheckAll(*) {
        result := "Group: " . (ControlGetVisible(GroupBox) ? "Visible" : "Hidden") . "\n"
        result .= "Child1: " . (ControlGetVisible(Child1) ? "Visible" : "Hidden") . "\n"
        result .= "Child2: " . (ControlGetVisible(Child2) ? "Visible" : "Hidden") . "\n"
        ResultsEdit.Value := result . "\n" . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Visibility Patterns
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Visibility Patterns")
    MyGui.Add("Text", "w500", "Detect visibility patterns:")

    controls := []
    loop 10
        controls.Push(MyGui.Add("Edit", "w100 " . (Mod(A_Index, 5) = 1 ? "xm" : "x+5") . " y" . (Mod(A_Index - 1, 5) = 0 ? "+20" : "+0"), A_Index))
    BtnPattern1 := MyGui.Add("Button", "xm y+60 w150", "Odd Visible")
    BtnPattern1.OnEvent("Click", (*) => ApplyPattern(1))
    BtnPattern2 := MyGui.Add("Button", "x+10 w150", "Even Visible")
    BtnPattern2.OnEvent("Click", (*) => ApplyPattern(2))
    BtnDetect := MyGui.Add("Button", "xm y+10 w310", "Detect Pattern")
    BtnDetect.OnEvent("Click", Detect)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h180 ReadOnly Multi")
    ApplyPattern(type) {
        for i, ctrl in controls
            ctrl.Visible := (type = 1) ? (Mod(i, 2) = 1) : (Mod(i, 2) = 0)
    }
    Detect(*) {
        pattern := ""
        for i, ctrl in controls
            pattern .= ControlGetVisible(ctrl) ? "V" : "H"
        ResultsEdit.Value := "Pattern: " . pattern . "\n" . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: State Comparison
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: State Comparison")
    MyGui.Add("Text", "w500", "Compare visibility states:")

    set1 := []
    set2 := []
    MyGui.Add("Text", "xm y+20", "Set 1:")
    loop 3
        set1.Push(MyGui.Add("Edit", "x" . (A_Index = 1 ? "m" : "+10") . " yp+20 w100", "A" . A_Index))
    MyGui.Add("Text", "xm y+40", "Set 2:")
    loop 3
        set2.Push(MyGui.Add("Edit", "x" . (A_Index = 1 ? "m" : "+10") . " yp+20 w100", "B" . A_Index))
    set1[2].Visible := false
    set2[2].Visible := false
    BtnCompare := MyGui.Add("Button", "xm y+40 w200", "Compare")
    BtnCompare.OnEvent("Click", Compare)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    Compare(*) {
        result := "=== COMPARISON ===\n\n"
        for i in [1, 2, 3] {
            v1 := ControlGetVisible(set1[i])
            v2 := ControlGetVisible(set2[i])
            result .= "Pos " . i . ": " . (v1 = v2 ? "Same" : "Different") . "\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Dynamic UI Check
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Dynamic UI Check")
    MyGui.Add("Text", "w500", "Check dynamically hidden UI:")

    controls := []
    loop 4
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Field " . A_Index))
    ShowAdvanced := MyGui.Add("Checkbox", "xm y+20", "Show Advanced")
    ShowAdvanced.OnEvent("Click", Update)
    Update(*) {
        for i, ctrl in controls {
            if (i > 2)
                ctrl.Visible := ShowAdvanced.Value
        }
    }
    BtnCheck := MyGui.Add("Button", "xm y+10 w200", "Check Visibility")
    BtnCheck.OnEvent("Click", Check)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    Update()
    Check(*) {
        result := ""
        for i, ctrl in controls
            result .= "Field " . i . ": " . (ControlGetVisible(ctrl) ? "Visible" : "Hidden") . "\n"
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Visibility Tracker
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Visibility Tracker")
    MyGui.Add("Text", "w500", "Track visibility changes:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Tracked")
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle & Log")
    BtnToggle.OnEvent("Click", ToggleLog)
    BtnClear := MyGui.Add("Button", "x+10 w200", "Clear Log")
    BtnClear.OnEvent("Click", (*) => ResultsEdit.Value := "")
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    changeCount := 0
    ToggleLog(*) {
        old := ControlGetVisible(TestEdit)
        TestEdit.Visible := !old
        new := !old
        changeCount++
        ts := FormatTime(A_Now, "HH:mm:ss")
        result := "[" . ts . "] #" . changeCount . ": "
        result .= (old ? "Visible" : "Hidden") . " → " . (new ? "Visible" : "Hidden") . "\n"
        ResultsEdit.Value := result . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Visibility Validator
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Visibility Validator")
    MyGui.Add("Text", "w500", "Validate expected visibility:")

    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Field " . A_Index))
    controls[2].Visible := false
    controls[4].Visible := false
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Validate States")
    BtnValidate.OnEvent("Click", Validate)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    Validate(*) {
        expected := [true, false, true, false, true]
        result := "=== VALIDATION ===\n\n"
        passed := 0
        for i, ctrl in controls {
            actual := ControlGetVisible(ctrl)
            match := (actual = expected[i])
            result .= "Field " . i . ": " . (match ? "✓ PASS" : "✗ FAIL") . "\n"
            if (match)
                passed++
        }
        result .= "\nResult: " . passed . "/" . controls.Length . " correct\n"
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Batch Query
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Batch Query")
    MyGui.Add("Text", "w500", "Query many controls at once:")

    controls := Map()
    controls["Name"] := MyGui.Add("Edit", "w200 y+20")
    controls["Email"] := MyGui.Add("Edit", "w200 y+10")
    controls["Phone"] := MyGui.Add("Edit", "w200 y+10")
    controls["Address"] := MyGui.Add("Edit", "w200 y+10")
    controls["Notes"] := MyGui.Add("Edit", "w200 y+10")
    controls["Phone"].Visible := false
    controls["Notes"].Visible := false
    BtnQuery := MyGui.Add("Button", "xm y+20 w200", "Query All")
    BtnQuery.OnEvent("Click", Query)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    Query(*) {
        result := "=== BATCH QUERY ===\n\n"
        visCount := 0
        for name, ctrl in controls {
            vis := ControlGetVisible(ctrl)
            result .= Format("{:<15} {:>10}", name . ":", vis ? "Visible" : "Hidden") . "\n"
            if (vis)
                visCount++
        }
        result .= "\n" . visCount . "/" . controls.Count . " visible\n"
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
    "Example 1: Parent Visibility",
    "Example 2: Visibility Patterns",
    "Example 3: State Comparison",
    "Example 4: Dynamic UI Check",
    "Example 5: Visibility Tracker",
    "Example 6: Visibility Validator",
    "Example 7: Batch Query",
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
