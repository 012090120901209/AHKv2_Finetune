#Requires AutoHotkey v2.0

/**
 * ControlSetChecked - Set Checkbox/Radio State
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Basic Set Checked
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Basic Set Checked")
    MyGui.Add("Text", "w500", "Set checkbox state:")

    Check1 := MyGui.Add("Checkbox", "xm y+20", "Checkbox 1")
    Check2 := MyGui.Add("Checkbox", "xm y+10", "Checkbox 2")
    BtnCheck := MyGui.Add("Button", "xm y+20 w140", "Check Both")
    BtnCheck.OnEvent("Click", (*) => CheckBoth())
    BtnUncheck := MyGui.Add("Button", "x+10 w140", "Uncheck Both")
    BtnUncheck.OnEvent("Click", (*) => UncheckBoth())
    CheckBoth() {
        ControlSetChecked(true, Check1)
        ControlSetChecked(true, Check2)
    }
    UncheckBoth() {
        ControlSetChecked(false, Check1)
        ControlSetChecked(false, Check2)
    }

    MyGui.Show()
}

;==============================================================================
; Example 2: Toggle Checked
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Toggle Checked")
    MyGui.Add("Text", "w500", "Toggle checkbox state:")

    TestCheck := MyGui.Add("Checkbox", "xm y+20", "Toggle Me")
    BtnToggle := MyGui.Add("Button", "xm y+20 w200", "Toggle")
    BtnToggle.OnEvent("Click", Toggle)
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    UpdateStatus()
    Toggle(*) {
        current := ControlGetChecked(TestCheck)
        ControlSetChecked(!current, TestCheck)
        UpdateStatus()
    }
    UpdateStatus() {
        state := ControlGetChecked(TestCheck)
        StatusText.Value := "Status: " . (state ? "Checked" : "Unchecked")
    }

    MyGui.Show()
}

;==============================================================================
; Example 3: Set Radio Selection
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Set Radio Selection")
    MyGui.Add("Text", "w500", "Set radio button selection:")

    Radio1 := MyGui.Add("Radio", "xm y+20", "Option 1")
    Radio2 := MyGui.Add("Radio", "xm y+10", "Option 2")
    Radio3 := MyGui.Add("Radio", "xm y+10", "Option 3")
    Btn1 := MyGui.Add("Button", "xm y+20 w120", "Select 1")
    Btn1.OnEvent("Click", (*) => ControlSetChecked(true, Radio1))
    Btn2 := MyGui.Add("Button", "x+10 w120", "Select 2")
    Btn2.OnEvent("Click", (*) => ControlSetChecked(true, Radio2))
    Btn3 := MyGui.Add("Button", "x+10 w120", "Select 3")
    Btn3.OnEvent("Click", (*) => ControlSetChecked(true, Radio3))

    MyGui.Show()
}

;==============================================================================
; Example 4: Check All
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Check All")
    MyGui.Add("Text", "w500", "Check all checkboxes:")

    checks := []
    loop 5
        checks.Push(MyGui.Add("Checkbox", "xm y+10", "Option " . A_Index))
    BtnCheckAll := MyGui.Add("Button", "xm y+20 w140", "Check All")
    BtnCheckAll.OnEvent("Click", CheckAll)
    BtnUncheckAll := MyGui.Add("Button", "x+10 w140", "Uncheck All")
    BtnUncheckAll.OnEvent("Click", UncheckAll)
    CheckAll(*) {
        for check in checks
            ControlSetChecked(true, check)
    }
    UncheckAll(*) {
        for check in checks
            ControlSetChecked(false, check)
    }

    MyGui.Show()
}

;==============================================================================
; Example 5: Conditional Check
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Conditional Check")
    MyGui.Add("Text", "w500", "Check based on condition:")

    Input := MyGui.Add("Edit", "w300 y+20", "")
    AutoCheck := MyGui.Add("Checkbox", "xm y+10", "Auto-checked when valid")
    Input.OnEvent("Change", Validate)
    Validate(ctrl, *) {
        if (StrLen(ctrl.Value) > 5)
            ControlSetChecked(true, AutoCheck)
        else
            ControlSetChecked(false, AutoCheck)
    }

    MyGui.Show()
}

;==============================================================================
; Example 6: Three-State Check
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Three-State Check")
    MyGui.Add("Text", "w500", "Set three-state checkbox:")

    Check3 := MyGui.Add("Checkbox", "xm y+20 Checked0x3", "Three-state")
    BtnUnchecked := MyGui.Add("Button", "xm y+20 w120", "Unchecked")
    BtnUnchecked.OnEvent("Click", (*) => ControlSetChecked(0, Check3))
    BtnChecked := MyGui.Add("Button", "x+10 w120", "Checked")
    BtnChecked.OnEvent("Click", (*) => ControlSetChecked(1, Check3))
    BtnIndeterminate := MyGui.Add("Button", "x+10 w120", "Indeterminate")
    BtnIndeterminate.OnEvent("Click", (*) => ControlSetChecked(-1, Check3))
    StatusText := MyGui.Add("Text", "xm y+10 w300", "")
    Check3.OnEvent("Click", UpdateStatus)
    UpdateStatus(*) {
        state := ControlGetChecked(Check3)
        stateText := (state = 0 ? "Unchecked" : state = 1 ? "Checked" : "Indeterminate")
        StatusText.Value := "State: " . stateText
    }

    MyGui.Show()
}

;==============================================================================
; Example 7: Master Checkbox
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Master Checkbox")
    MyGui.Add("Text", "w500", "Master checkbox controls others:")

    Master := MyGui.Add("Checkbox", "xm y+20", "Select All")
    children := []
    loop 4
        children.Push(MyGui.Add("Checkbox", "xm y+10", "Item " . A_Index))
    Master.OnEvent("Click", UpdateChildren)
    for child in children
        child.OnEvent("Click", UpdateMaster)
    UpdateChildren(*) {
        state := ControlGetChecked(Master)
        for child in children
            ControlSetChecked(state, child)
    }
    UpdateMaster(*) {
        allChecked := true
        for child in children
            if (!ControlGetChecked(child))
                allChecked := false
        ControlSetChecked(allChecked, Master)
    }

    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Basic Set Checked",
    "Example 2: Toggle Checked",
    "Example 3: Set Radio Selection",
    "Example 4: Check All",
    "Example 5: Conditional Check",
    "Example 6: Three-State Check",
    "Example 7: Master Checkbox",
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
