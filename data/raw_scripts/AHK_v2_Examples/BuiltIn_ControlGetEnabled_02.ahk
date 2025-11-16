#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ControlGetEnabled - Advanced State Detection
 * ============================================================================
 *
 * Advanced techniques for detecting and analyzing control enabled states.
 *
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Parent-Child State Check
;==============================================================================

/**
 * Check cascading enabled states
 */
Example1() {
    MyGui := Gui("+Resize", "Example 1: Parent-Child State Check")
    MyGui.Add("Text", "w500", "Check parent-child enabled states:")
    
    GroupBox := MyGui.Add("GroupBox", "w300 h150 y+20", "Group")
    Edit1 := MyGui.Add("Edit", "xp+10 yp+25 w280", "Edit in group")
    Edit2 := MyGui.Add("Edit", "xp yp+30 w280", "Another edit")
    
    BtnDisableGroup := MyGui.Add("Button", "xm y+180 w200", "Disable Group")
    BtnDisableGroup.OnEvent("Click", (*) => GroupBox.Enabled := false)
    
    BtnCheck := MyGui.Add("Button", "x+10 w200", "Check States")
    BtnCheck.OnEvent("Click", CheckStates)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    
    CheckStates(*) {
        result := "Group Enabled: " . (ControlGetEnabled(GroupBox) ? "Yes" : "No") . "\n"
        result .= "Edit1 Enabled: " . (ControlGetEnabled(Edit1) ? "Yes" : "No") . "\n"
        result .= "Edit2 Enabled: " . (ControlGetEnabled(Edit2) ? "Yes" : "No") . "\n"
        ResultsEdit.Value := result . "\n" . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 2: State Pattern Detector
;==============================================================================

/**
 * Detect enabled/disabled patterns
 */
Example2() {
    MyGui := Gui("+Resize", "Example 2: State Pattern Detector")
    MyGui.Add("Text", "w500", "Detect state patterns:")
    
    controls := []
    loop 10
        controls.Push(MyGui.Add("Edit", "w100 " . (Mod(A_Index, 5) = 1 ? "xm" : "x+5") . " y" . (Mod(A_Index-1, 5) = 0 ? "+20" : "+0"), A_Index))
    
    BtnPattern1 := MyGui.Add("Button", "xm y+20 w150", "Pattern: Odd")
    BtnPattern1.OnEvent("Click", (*) => ApplyPattern(1))
    
    BtnPattern2 := MyGui.Add("Button", "x+10 w150", "Pattern: Even")
    BtnPattern2.OnEvent("Click", (*) => ApplyPattern(2))
    
    BtnDetect := MyGui.Add("Button", "xm y+10 w310", "Detect Pattern")
    BtnDetect.OnEvent("Click", DetectPattern)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h200 ReadOnly Multi")
    
    ApplyPattern(type) {
        for i, ctrl in controls
            ctrl.Enabled := (type = 1) ? (Mod(i, 2) = 1) : (Mod(i, 2) = 0)
    }
    
    DetectPattern(*) {
        pattern := ""
        for i, ctrl in controls
            pattern .= ControlGetEnabled(ctrl) ? "E" : "D"
        ResultsEdit.Value := "Pattern: " . pattern . "\n" . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: State Comparison
;==============================================================================

/**
 * Compare states across controls
 */
Example3() {
    MyGui := Gui("+Resize", "Example 3: State Comparison")
    MyGui.Add("Text", "w500", "Compare enabled states:")
    
    set1 := []
    set2 := []
    
    MyGui.Add("Text", "xm y+20", "Set 1:")
    loop 3
        set1.Push(MyGui.Add("Edit", "x" . (A_Index = 1 ? "m" : "+10") . " yp+20 w100", "A" . A_Index))
    
    MyGui.Add("Text", "xm y+40", "Set 2:")
    loop 3
        set2.Push(MyGui.Add("Edit", "x" . (A_Index = 1 ? "m" : "+10") . " yp+20 w100", "B" . A_Index))
    
    BtnCompare := MyGui.Add("Button", "xm y+40 w200", "Compare Sets")
    BtnCompare.OnEvent("Click", Compare)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    Compare(*) {
        result := "=== COMPARISON ===\n\n"
        
        for i in [1, 2, 3] {
            s1 := ControlGetEnabled(set1[i])
            s2 := ControlGetEnabled(set2[i])
            result .= "Position " . i . ": " . (s1 = s2 ? "Same" : "Different") . "\n"
        }
        
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: State Validation
;==============================================================================

/**
 * Validate expected states
 */
Example4() {
    MyGui := Gui("+Resize", "Example 4: State Validation")
    MyGui.Add("Text", "w500", "Validate control states:")
    
    controls := []
    loop 5
        controls.Push(MyGui.Add("Edit", "w200 y+10", "Field " . A_Index))
    
    ; Set expected states
    controls[1].Enabled := true
    controls[2].Enabled := false
    controls[3].Enabled := true
    controls[4].Enabled := false
    controls[5].Enabled := true
    
    BtnValidate := MyGui.Add("Button", "xm y+20 w200", "Validate States")
    BtnValidate.OnEvent("Click", Validate)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    
    Validate(*) {
        expected := [true, false, true, false, true]
        result := "=== VALIDATION ===\n\n"
        passed := 0
        
        for i, ctrl in controls {
            actual := ControlGetEnabled(ctrl)
            match := (actual = expected[i])
            result .= "Field " . i . ": " . (match ? "✓ PASS" : "✗ FAIL") . "\n"
            if (match)
                passed++
        }
        
        result .= "\nResult: " . passed . "/" . controls.Length . " passed\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: Dependency Checker
;==============================================================================

/**
 * Check control dependencies
 */
Example5() {
    MyGui := Gui("+Resize", "Example 5: Dependency Checker")
    MyGui.Add("Text", "w500", "Check control dependencies:")
    
    Primary := MyGui.Add("Checkbox", "xm y+20", "Enable dependent fields")
    Dep1 := MyGui.Add("Edit", "xm y+10 w200")
    Dep2 := MyGui.Add("Edit", "xm y+10 w200")
    Dep3 := MyGui.Add("Edit", "xm y+10 w200")
    
    ; Initially disable dependents
    Dep1.Enabled := false
    Dep2.Enabled := false
    Dep3.Enabled := false
    
    Primary.OnEvent("Click", UpdateDeps)
    
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Dependencies")
    BtnCheck.OnEvent("Click", CheckDeps)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w400 h250 ReadOnly Multi")
    
    UpdateDeps(*) {
        enabled := Primary.Value
        Dep1.Enabled := enabled
        Dep2.Enabled := enabled
        Dep3.Enabled := enabled
    }
    
    CheckDeps(*) {
        result := "Primary: " . (Primary.Value ? "Checked" : "Unchecked") . "\n"
        result .= "Dep1: " . (ControlGetEnabled(Dep1) ? "Enabled" : "Disabled") . "\n"
        result .= "Dep2: " . (ControlGetEnabled(Dep2) ? "Enabled" : "Disabled") . "\n"
        result .= "Dep3: " . (ControlGetEnabled(Dep3) ? "Enabled" : "Disabled") . "\n"
        
        allCorrect := (Primary.Value = ControlGetEnabled(Dep1)) && 
                      (Primary.Value = ControlGetEnabled(Dep2)) && 
                      (Primary.Value = ControlGetEnabled(Dep3))
        
        result .= "\nDependencies: " . (allCorrect ? "✓ Correct" : "✗ Incorrect") . "\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 6: State History Tracker
;==============================================================================

/**
 * Track state changes over time
 */
Example6() {
    MyGui := Gui("+Resize", "Example 6: State History Tracker")
    MyGui.Add("Text", "w500", "Track state change history:")
    
    TestEdit := MyGui.Add("Edit", "w300 y+20", "Test")
    
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle Enable")
    BtnToggle.OnEvent("Click", ToggleAndLog)
    
    BtnClear := MyGui.Add("Button", "x+10 w200", "Clear History")
    BtnClear.OnEvent("Click", (*) => ResultsEdit.Value := "")
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    
    changeCount := 0
    
    ToggleAndLog(*) {
        oldState := ControlGetEnabled(TestEdit)
        TestEdit.Enabled := !oldState
        newState := !oldState
        
        changeCount++
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        
        result := "[" . timestamp . "] Change #" . changeCount . ": "
        result .= (oldState ? "Enabled" : "Disabled") . " → "
        result .= (newState ? "Enabled" : "Disabled") . "\n"
        
        ResultsEdit.Value := result . ResultsEdit.Value
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: Batch State Query
;==============================================================================

/**
 * Query multiple control states
 */
Example7() {
    MyGui := Gui("+Resize", "Example 7: Batch State Query")
    MyGui.Add("Text", "w500", "Batch state query:")
    
    controls := Map()
    controls["Field1"] := MyGui.Add("Edit", "w200 y+20")
    controls["Field2"] := MyGui.Add("Edit", "w200 y+10")
    controls["Field3"] := MyGui.Add("Edit", "w200 y+10")
    controls["Button1"] := MyGui.Add("Button", "w200 y+10", "Button")
    controls["Check1"] := MyGui.Add("Checkbox", "y+10", "Checkbox")
    
    BtnRandom := MyGui.Add("Button", "xm y+20 w200", "Randomize States")
    BtnRandom.OnEvent("Click", Randomize)
    
    BtnQuery := MyGui.Add("Button", "x+10 w200", "Query All")
    BtnQuery.OnEvent("Click", QueryAll)
    
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")
    
    Randomize(*) {
        for name, ctrl in controls
            ctrl.Enabled := (Random(0, 1) = 1)
        ResultsEdit.Value := "States randomized\n" . ResultsEdit.Value
    }
    
    QueryAll(*) {
        result := "=== BATCH STATE QUERY ===\n\n"
        enabledCount := 0
        
        for name, ctrl in controls {
            enabled := ControlGetEnabled(ctrl)
            result .= Format("{:<15} {:>10}", name . ":", enabled ? "Enabled" : "Disabled") . "\n"
            if (enabled)
                enabledCount++
        }
        
        result .= "\n" . enabledCount . "/" . controls.Count . " controls enabled\n"
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
    "Example 1: Parent-Child State Check",
    "Example 2: State Pattern Detector",
    "Example 3: State Comparison",
    "Example 4: State Validation",
    "Example 5: Dependency Checker",
    "Example 6: State History Tracker",
    "Example 7: Batch State Query"
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
