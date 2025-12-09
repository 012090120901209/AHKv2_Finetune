#Requires AutoHotkey v2.0

/**
* ControlGetChecked - Advanced State Detection
*
* Comprehensive examples for AutoHotkey v2.0
* @author AutoHotkey Community
* @date 2025-01-16
* @version 1.0.0
*/


;==============================================================================
; Example 1: Three-State Checkbox
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Three-State Checkbox")
    MyGui.Add("Text", "w500", "Handle three-state checkboxes:")

    Check3State := MyGui.Add("Checkbox", "xm y+20 Checked0x3", "Three-state")
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Get State")
    BtnCheck.OnEvent("Click", GetState)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    GetState(*) {
        state := ControlGetChecked(Check3State)
        stateText := (state = 0 ? "Unchecked" : state = 1 ? "Checked" : "Indeterminate")
        ResultsEdit.Value := "State: " . stateText . " (" . state . ")\n" . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Radio Group Detection
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Radio Group Detection")
    MyGui.Add("Text", "w500", "Detect selected radio in group:")

    groups := Map()
    groups["Group1"] := []
    groups["Group2"] := []
    MyGui.Add("Text", "xm y+20", "Group 1:")
    loop 3
    groups["Group1"].Push(MyGui.Add("Radio", "xm y+10", "G1-" . A_Index))
    MyGui.Add("Text", "xm y+20", "Group 2:")
    loop 3
    groups["Group2"].Push(MyGui.Add("Radio", "xm y+10", "G2-" . A_Index))
    groups["Group1"][1].Value := 1
    groups["Group2"][1].Value := 1
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Groups")
    BtnCheck.OnEvent("Click", CheckGroups)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    CheckGroups(*) {
        result := "=== GROUP SELECTIONS ===\n\n"
        for groupName, radios in groups {
            result .= groupName . ": "
            found := false
            for i, radio in radios {
                if (ControlGetChecked(radio)) {
                    result .= "Option " . i . "\n"
                    found := true
                    break
                }
            }
            if (!found)
            result .= "None selected\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: State Patterns
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: State Patterns")
    MyGui.Add("Text", "w500", "Detect check patterns:")

    checks := []
    loop 8
    checks.Push(MyGui.Add("Checkbox", "x" . (Mod(A_Index-1, 4) = 0 ? "m" : "+10") . " y" . (Mod(A_Index-1, 4) = 0 ? "+20" : "+0"), A_Index))
    BtnPattern := MyGui.Add("Button", "xm y+60 w200", "Detect Pattern")
    BtnPattern.OnEvent("Click", DetectPattern)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h200 ReadOnly Multi")
    DetectPattern(*) {
        pattern := ""
        for check in checks
        pattern .= ControlGetChecked(check) ? "1" : "0"
        ResultsEdit.Value := "Pattern: " . pattern . "\n" . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 4: Dependency Checking
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Dependency Checking")
    MyGui.Add("Text", "w500", "Check dependent selections:")

    Parent := MyGui.Add("Checkbox", "xm y+20", "Enable all")
    Children := []
    loop 4
    Children.Push(MyGui.Add("Checkbox", "xm y+10", "Child " . A_Index))
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Consistency")
    BtnCheck.OnEvent("Click", CheckConsist)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    CheckConsist(*) {
        parentState := ControlGetChecked(Parent)
        result := "Parent: " . (parentState ? "Checked" : "Unchecked") . "\n"
        allChildrenChecked := true
        for i, child in Children {
            childState := ControlGetChecked(child)
            result .= "Child " . i . ": " . (childState ? "Checked" : "Unchecked") . "\n"
            if (!childState)
            allChildrenChecked := false
        }
        consistent := (parentState = allChildrenChecked)
        result .= "\nConsistent: " . (consistent ? "Yes" : "No") . "\n"
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: State Comparison
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: State Comparison")
    MyGui.Add("Text", "w500", "Compare check states:")

    set1 := []
    set2 := []
    MyGui.Add("Text", "xm y+20", "Set 1:")
    loop 3
    set1.Push(MyGui.Add("Checkbox", "xm y+10", "A" . A_Index))
    MyGui.Add("Text", "xm y+20", "Set 2:")
    loop 3
    set2.Push(MyGui.Add("Checkbox", "xm y+10", "B" . A_Index))
    BtnCompare := MyGui.Add("Button", "xm y+20 w200", "Compare Sets")
    BtnCompare.OnEvent("Click", Compare)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h200 ReadOnly Multi")
    Compare(*) {
        result := "=== COMPARISON ===\n\n"
        for i in [1, 2, 3] {
            s1 := ControlGetChecked(set1[i])
            s2 := ControlGetChecked(set2[i])
            result .= "Position " . i . ": " . (s1 = s2 ? "Same" : "Different") . "\n"
        }
        ResultsEdit.Value := result
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Selection History
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Selection History")
    MyGui.Add("Text", "w500", "Track selection history:")

    Check := MyGui.Add("Checkbox", "xm y+20", "Track me")
    BtnClear := MyGui.Add("Button", "xm y+20 w200", "Clear History")
    BtnClear.OnEvent("Click", (*) => ResultsEdit.Value := "")
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h300 ReadOnly Multi")
    Check.OnEvent("Click", LogChange)
    changeCount := 0
    LogChange(*) {
        changeCount++
        state := ControlGetChecked(Check)
        ts := FormatTime(A_Now, "HH:mm:ss")
        result := "[" . ts . "] #" . changeCount . ": " . (state ? "Checked" : "Unchecked") . "\n"
        ResultsEdit.Value := result . ResultsEdit.Value
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Batch Query
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Batch Query")
    MyGui.Add("Text", "w500", "Query multiple controls:")

    controls := Map()
    controls["Feature1"] := MyGui.Add("Checkbox", "xm y+20", "Feature 1")
    controls["Feature2"] := MyGui.Add("Checkbox", "xm y+10", "Feature 2")
    controls["Feature3"] := MyGui.Add("Checkbox", "xm y+10", "Feature 3")
    controls["Option1"] := MyGui.Add("Checkbox", "xm y+10", "Option 1")
    controls["Option2"] := MyGui.Add("Checkbox", "xm y+10", "Option 2")
    BtnQuery := MyGui.Add("Button", "xm y+20 w200", "Query All")
    BtnQuery.OnEvent("Click", QueryAll)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    QueryAll(*) {
        result := "=== BATCH QUERY ===\n\n"
        checkedCount := 0
        for name, ctrl in controls {
            state := ControlGetChecked(ctrl)
            result .= Format("{:<15} {:>10}", name . ":", state ? "Checked" : "Unchecked") . "\n"
            if (state)
            checkedCount++
        }
        result .= "\nTotal: " . checkedCount . "/" . controls.Count . " checked\n"
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
"Example 1: Three-State Checkbox",
"Example 2: Radio Group Detection",
"Example 3: State Patterns",
"Example 4: Dependency Checking",
"Example 5: State Comparison",
"Example 6: Selection History",
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
